From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: Thu, 11 Sep 2003 16:05:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
References: <20030910170227.C3367@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:47876 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261490AbTIKUF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 16:05:56 -0400
In-Reply-To: <20030910170227.C3367@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 10 Sep 2003, Patrick Mansfield wrote:

> On Wed, Sep 10, 2003 at 12:23:43PM -0400, Alan Stern wrote:
> 
> > Is there any feeling about how to handle these ongoing problems with the 
> > mode-sense cache page?  There doesn't seem to be any general solution that 
> > can work with all USB storage devices.  Some hang when asked to read the 
> > entire page; some hang when asked to read just part of the page; some hang 
> > when asked to read just the page header.
> > 
> > What do the SCSI folk have to say about it?

> I don't like per-host (or transport) flags or filters that cannot be
> modified. They make some sense for hosts that process the scsi commands
> (like a RAID card). If you moved a device from one transport to another,
> the commands sent to the device should not change: for example, you move
> an iSCSI attached device onto your local system via SPI.
> 
> IMO we ought to go with two new BFLAGS, one to block the MODE SENSE page 8
> (for the cache), and one to block the MODE SENSE page 0x3f (to check the
> write protect). 
> 
> A per host bflags could be added, and overwritten by per device (devinfo)
> settings. I'd rather we black list the broken ones but that does not
> appear to be practical. usb-storage could then set the per-host bflag to
> include the two new flags.

What do people think of just having per-device flags that the host driver
could set during the slave_configure() callback?  The point of these flags
is not to prevent bad commands from being sent to the device --
user-generated commands sent via sg should always be allowed.  Rather, the
point is to prevent sd.c from generating these commands in the first
place.  (Apparently the commands don't present a problem for sr.c.)

So for example, usb-storage could set the BFLAG to block MODE-SENSE page 8
for any disk-type device.  This isn't a perfect solution; consider an
iSCSI-attached device that is actually a usb-storage disk on some server.  
Nevertheless, this might take care of the majority of the problems we see.  
(I haven't seen any MODE-SENSE page 0x3f problems, but others have.)

Alan Stern

