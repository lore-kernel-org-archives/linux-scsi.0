From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 5 Nov 2004 11:18:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0411051059540.834-100000@ida.rowland.org>
References: <41765CD1.8060108@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:11780 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261153AbUKEQSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 11:18:36 -0500
In-Reply-To: <41765CD1.8060108@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Everything we've tried for detecting too-high-by-one READ CAPACITY
responses has failed on one device or another.  I can't think of any way
to detect the error at runtime, short of actually trying to read the last
sector.  And that is not a good tactic because it will quite likely leave
the device is some non-resettable hung-up state.  Even the heuristic that
USB devices will always have an even number of sectors turns out to be
wrong for the Apple iPod.

There doesn't seem to be anything left but blacklisting.  This could be
done at the SCSI level or the usb-storage level.  It turns out there's
actually an advantage to putting the entries in the usb-storage list:  In
many cases a vendor will use a USB interface chip from another company,
changing the vendor name stored in the INQUIRY data but leaving the USB
vendor ID alone (so it reflects the chip designer, not the drive seller).  
This means that a single USB blacklist could cover a range of devices that
would require multiple SCSI blacklist entries.  I've actually seen
something like this happen in a different context (the Panasonic DMC-LCx
cameras with internal interfaces by Matsushita have different Product
strings in their INQUIRY data but the same Product ID in their USB
descriptors).

On the other hand, the adjustment of the READ CAPACITY value should still 
be moved to sd.c from usb-storage.  This can be implemented easily enough 
by adding a bitflag to the scsi_device structure; the flag could be set 
either by a SCSI blist entry or by usb-storage in its slave_configure 
routine.  The flag would tell sd_read_capacity to decrement the number of 
sectors it receives from the device.

Can anyone come up with a better suggestion?

Alan Stern

