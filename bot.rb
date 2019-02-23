# ruborobo - a ruby testing bot
# (C) 2018 Team ruborobo (ry00001, Erisa Arrowsmith (Seriel))

module Ruborobo
    require 'discordrb' # meme
    require 'yaml'
    require 'commandorobo'
    require 'rest_client'

    config = {} # because scoping:tm:
    owners = nil # same here...

    if !ENV['DOCKER']
        config = YAML.load(File.read('./config.yml'))
    else
        puts 'Docker detected, loading config from environment variables.'
        config = {
            'token' => ENV['TOKEN'],
            'invokers' => ENV['INVOKERS'].split('/').map {|a| a.split(' ')},
            'version' => 'Docker'
        }
        owners = ENV['OWNER'].split(',').map(&:to_i)
    end

    $bot = Commandorobo::Bot.new(config, config['token'])

    puts "attey v#{config['version']}"

    Dir['plugins/**/*.rb'].each do |p|
        puts "Loading #{File.basename(p, '.rb')}..."
        require_relative p
    end

    $bot.ready do |ev|
        aa = $bot.invokers.map {|x| x.value}
        puts "Bot ready, logged in as #{ev.bot.profile.distinct} (#{ev.bot.profile.id})"
        puts "Prefixes: #{aa}"
        puts "Owners: #{$bot.owners}"
    end

    $bot.run
end
