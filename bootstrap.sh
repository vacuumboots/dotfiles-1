#!/usr/bin/env bash

# Bootstraps a fresh OSX machine so it isnt a useless hunk of trash
# Dont just run this if you arent me (or take a chance for once and do it anyway)
#copied from https://github.com/usererror/dotfiles/blob/master/bootstrap.sh

###
# Echo helpers written by @adameivy \[^_^]/
###
# Colors for echo
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"
# Functions for echo
function msg() {
    echo -e "$COL_BLUE[msg]$COL_RESET "$1
}
function ok() {
    echo -e "$COL_GREEN[ok]$COL_RESET "$1
}
function warn() {
    echo -e "$COL_YELLOW[warning]$COL_RESET "$1
}
function error() {
    echo -e "$COL_RED[error]$COL_RESET "$1
}

# Install Homebrew
msg "Checking if Homebrew is installed..."
have_brew=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    msg "Homebrew not installed. Installing now..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
        error "Couldn't install Homebrew - Bailing out, you are on your own. Good luck!"
        exit 666
    fi
    ok "Brew installation complete."
else
    msg "Homebrew already installed. Updating now..."
    brew update
    ok "Brew update complete."
    msg "Upgrade currently installed packages?"
    read -r -p " [yY|nN]? " resp
    if [[ $resp =~ (yes|y|Y|YES) ]];then
        brew upgrade
        ok "Brew upgrade complete."
    fi
fi

# Tap into homebrew/bundle so we can use Brewfile
# See: https://github.com/Homebrew/homebrew-bundle
# We can run this without checking if its already tapped, brew figures it out
msg "Tapping Homebrew/bundle so we can use our Brewfile"
brew tap Homebrew/bundle
ok "Tap complete"

# Install Homebrew packages
# This uses the 'Brewfile' in whatever directory its run in
msg "Installing all Homebrew packages, casks, taps from Brewfile..."
brew bundle
ok "Package installation complete."

# Cleanup the cellar
msg "Cleaning up the cellar..."
brew cleanup
ok "Cleanup complete - cellar is sparkling, sir."

# Set iTerm2 fonts
defaults write com.googlecode.iterm2 "Normal Font" -string "Envy Code R "14";
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "RobotoMonoForPowerline-Regular 12";
