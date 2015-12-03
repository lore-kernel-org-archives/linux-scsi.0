From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Thu, 3 Dec 2015 13:36:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1512031320580.1324-100000@iolanthe.rowland.org>
References: <1435008177.2237.137.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:32988 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752684AbbLCSgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2015 13:36:20 -0500
In-Reply-To: <1435008177.2237.137.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dan Williams <dcbw@redhat.com>, brad <bradhaack@fastmail.us>

This is an old problem, but it was never resolved and it still affects
people (Bugzilla #89511).  In short, there are USB-(S)ATA bridges that
claim to be write-back but don't support the SYNCHRONIZE CACHE command.  
This causes errors when filesystems try to flush data out to the disk.

On Mon, 22 Jun 2015, James Bottomley wrote:

> On Mon, 2015-06-22 at 13:48 -0400, Alan Stern wrote:
> > On Mon, 22 Jun 2015, James Bottomley wrote:
> > 
> > > On Mon, 2015-06-22 at 13:30 -0400, Alan Stern wrote:
> > > > On Mon, 22 Jun 2015, James Bottomley wrote:
> > > > 
> > > > > I'm not sure I entirely like this:  we are back again treating data
> > > > > corruption problems silently.
> > > > > 
> > > > > However, I also believe treating a single flush failure as a critical
> > > > > filesystem error is also wrong:  The data's all there correctly; all it
> > > > > does is introduce a potential window were the FS could get corrupted in
> > > > > the unlikely event the system crashed.
> > > > > 
> > > > > Obviously, for a disk with a writeback cache that can't do flush, that
> > > > > window is much wider and the real solution should be to try to switch
> > > > > the cache to write through.
> > > > 
> > > > I agree.  Doing the switch manually (by writing to the "cache_type" 
> > > > attribute file) works, but it's a nuisance to do this when you have a 
> > > > portable USB drive that gets moved among a bunch of machines.
> > > 
> > > Perhaps it might be wise to do this to every USB device ... for external
> > > devices, the small performance gain doesn't really make up for the
> > > potential data loss.
> > > 
> > > > > How about something like this patch?  It transforms FS FLUSH into a log
> > > > > warning from an error but preserves the error on any other path.  You'll
> > > > > still get a fairly continuous dump of warnings for one of these devices,
> > > > > though ... do they respond to mode selects turning off the writeback?
> > > > 
> > > > I would be very surprised if any of those drives support MODE SELECT at 
> > > > all.
> > > 
> > > I assume the cache type attribute file you refer to above is just
> > > pretending their cache is write through rather than actually setting it
> > > to be so?
> > 
> > Yes; I'm referring to cache_type_store() in sd.c, and writing
> > "temporary write through", which does not issue a MODE SELECT command.  
> > It would be easy enough for people to try leaving out the "temporary", 
> > but I don't expect it to work.
> > 
> > >  The original IDE device had no way of turning their cache
> > > types to write through either, but the manufacturers were eventually
> > > convinced of the error of their ways.
> > 
> > In this case the stupidity resides in the USB-ATA bridge.  You can see 
> > the gory details at
> > 
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=89511#c19
> 
> OK, so that says the SAT in the bridge doesn't know what to do with
> MODE_SELECT (probably unsurprising given that it's a usb bridge).  the
> SATA disk should respond to the ATA command SET FEATURES, though.
> Presuming we can get it through the bridge.
> 
> You can try it with
> 
> hdparm -W 0 <dev>
> 
> optionally with --prefer_ata_12 to do the 12 instead of 16 byte
> encapsulation and see if that makes a difference.

As reported by Dan Williams, the SET FEATURES command results in an 
"Illegal Request: Invalid command operation code" error response.

So the question remains, what should we do about these things?  We can
have a blacklist flag that overrides the cache setting, as in my
original patch.  We can leave the setting alone and change the errors
to warnings, as in James's patch earlier in this thread (but that will
generate a lot of warnings).

James, what do you think?

Alan Stern


