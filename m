From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 12:47:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901281233250.3134-100000@iolanthe.rowland.org>
References: <20090128091406.316a80fc@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36964 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751113AbZA1Rrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 12:47:47 -0500
In-Reply-To: <20090128091406.316a80fc@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dirk Hohndel <hohndel@infradead.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009, Dirk Hohndel wrote:

> > > The other one is "why isn't the USB stack filtering that command when
> > > it comes down from SCSI?"
> > 
> > The USB stack doesn't do any filtering.  The SCSI stack is supposed to 
> > know what commands should and should not be sent.
> > 
> > Furthermore, it seems quite likely this command was sent by userspace, 
> > not by the SCSI stack -- in which case the program is supposed to know 
> > what commands it shouldn't send.
> 
> Not sure I agree with that logic. If the USB stack KNOWS that
> non-removable devices get upset by this command, then it would be
> appropriate for it to filter those out - to protect from bugs as much
> as to protect from denial of service attacks.

Part of the problem is that many devices claim to have removable media 
when in fact they don't.  And going back to your first email message, I 
see that your device is one of them:

> Jan 22 13:49:53 dhohndel-mobl4 kernel: [   46.329437] sd 4:0:0:0: [sdb] Attached SCSI \
>                 removable disk
                  ^^^^^^^^^

In any case, usb-storage is just a transport.  It sends commands from
higher up (the SCSI stack) to a USB device.  It filters the commands as
little as possible.  In other words, don't blame the messenger for
delivering a bad message.

> > > Maybe we need to bring such code back?
> > 
> > Definitely not!  The correct approach to is to find the program
> > responsible for sending that command and fix it.
> 
> That's definitely something we should do (and I will continue to hunt
> this down), but my logic above still applies. I think this should have
> a WARN_ON around it, but should still be filtered.

Nope.  How would people feel when they triggered your WARN_ON every 
time they ejected a disc from their USB CD-ROM drive?

> > Or you could guess that the offending command is sent by a
> > system/desktop utility, such as hal or udev.  Have you added or changed
> > any software in that area recently?
> 
> As I mentioned, I tried this in runlevel 3 - no desktop running.

Both hal and udev would still be running in level 3.

> And
> this is on an (as far as I can remember) unmodified F10 64bit... so I'm
> surprised that I appear to be the only one reporting this; which of
> course makes me challenge my own "unmodified" statement :-)

Alan Stern

