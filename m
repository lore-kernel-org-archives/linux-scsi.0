From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 10:25:28 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org>
References: <20030922004943.E32009@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263158AbTIVOZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 10:25:29 -0400
In-Reply-To: <20030922004943.E32009@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

This problem has been cropping up with many, many USB storage devices.  
They just don't handle MODE-SENSE page 8 correctly.  Some devices are okay
with a 128-byte transfer and others aren't.  Some are okay with a 64-byte
transfer and others aren't.  Some are okay transferring the actual size of
the page (as given in the header) and others aren't.  Some are okay
transferring the minimum amount we actually need (12 bytes IIRC) and
others aren't.

Although it may not directly address all the problems that Linus observed,
a solution has been floating around in the linux-scsi and usb-storage
development lists.  It looks to me like it's ready to be merged, although
no one has done so yet.  Basically, it amounts to a per-device flag that
can be inherited by default from the host template or set/cleared
specifically by the host driver, rather like the flag for using 10-byte
READ/WRITE commands.  The flag tells sd.c not to ask for page 8 but to
assume a write-through cache.  The patch is in

http://marc.theaimsgroup.com/?l=linux-scsi&m=106366112221507&w=2

At the moment, this MODE-SENSE page 8 is probably the most severe 
outstanding problem with the usb-storage driver.  I'm all in favor of the 
patch being adopted (hint, hint...).

I've been assuming that the "babble" problem arises because the device
either tries to send more than 128 bytes of mode-sense data or because it
tries to send the data and the subsequent 13-byte status in the same
packet.  Whether or not this would be detected as an error depends on the
maxpacket size, which depends on the speed of the USB bus.  (Maybe the
device even tries to send an over-sized packet.)  Of course, it's always
possible that reading page 8 just triggers a bug in the device firmware,
and from then on it's all over.

On Mon, 22 Sep 2003, Matthew Dharm wrote:

> You say this worked with UHCI 'some time ago'?  Perhaps that was before all
> this mode page 8 stuff got settled?

The MODE-SENSE page 8 stuff was added sometime during the 2.5 development 
cycle.  Before it was put in, quite likely the device would have worked 
fine with UHCI.

Alan Stern

