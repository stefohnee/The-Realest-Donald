#!/usr/bin/ruby
require 'open-uri'
require 'twitter'
require 'rubygems'
require 'gizoogle'

def trumpConv()
	# Create a new client with my client info
	client = Twitter::REST::Client.new do |config|
		config.consumer_key        = "SECRET"
		config.consumer_secret     = "SECRET"
		config.access_token        = "SECRET"
		config.access_token_secret = "SECRET"
	end
	# Read a text file containing Trump's most recent tweet
	file1 = File.open("mostRecentTweet.txt", "rb")
	contents = file1.read
	# Close the file, need to write to it later
	file1.close
	
	# Use the twitter API to get Donald Trump's most recent tweet
	newestTweet = client.user_timeline("realDonaldTrump").first.text
	
	# If the most recent tweet does not match that stored in the file
	if newestTweet != contents.chomp
		# Open the file and replace the contents with newestTweet
		file2 = File.open("mostRecenttweet.txt", "w")
		file2.puts newestTweet
		file2.close
		
		# Now append the converted text to another file, called translated trump
		file3 = File.open("translatedTrump.txt", "a")
		outputText = Gizoogle::String.translate(newestTweet)
		file3.puts outputText
		file3.close
		# That wasn't really necessary for just posting to twitter, but I like to keep records
		
		# Now post the tweet! (But only if it's short enough)
		if outputText.length <= 140
			client.update(outputText)
			puts "Posted Tweet! Contents:\n", outputText, "\n\n"
		end
	end
end

# Every so often wake from sleep and call the main function
while true
	trumpConv()
	sleep(60)
end
