From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: Wed, 10 Sep 2003 17:02:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030910170227.C3367@beaverton.ibm.com>
References: <3F5E434D.6080801@unixsol.org> <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:23027 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S266084AbTIKADc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 20:03:32 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Wed, Sep 10, 2003 at 12:23:43PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Sep 10, 2003 at 12:23:43PM -0400, Alan Stern wrote:

> Is there any feeling about how to handle these ongoing problems with the 
> mode-sense cache page?  There doesn't seem to be any general solution that 
> can work with all USB storage devices.  Some hang when asked to read the 
> entire page; some hang when asked to read just part of the page; some hang 
> when asked to read just the page header.
> 
> What do the SCSI folk have to say about it?

There was at least this thread last April:

http://marc.theaimsgroup.com/?t=104839042700001&r=1&w=2

Matthew had a simple patch so that emulated hosts did not do any (sd.c)
mode-sense cache checks, James had a filter commands patch.

There were changes since then in how the MODE SENSE is handled (sd.c
only?).

In current 2.6 code, the scsi_host emulated flag does nothing, and can
be deleted.

I don't like per-host (or transport) flags or filters that cannot be
modified. They make some sense for hosts that process the scsi commands
(like a RAID card). If you moved a device from one transport to another,
the commands sent to the device should not change: for example, you move
an iSCSI attached device onto your local system via SPI.

IMO we ought to go with two new BFLAGS, one to block the MODE SENSE page 8
(for the cache), and one to block the MODE SENSE page 0x3f (to check the
write protect). 

A per host bflags could be added, and overwritten by per device (devinfo)
settings. I'd rather we black list the broken ones but that does not
appear to be practical. usb-storage could then set the per-host bflag to
include the two new flags.

We still end up sending some non-popular SCSI commands to all SCSI
devices.

Such flags would not stop sg from sending those commands, but that is
postive as well as negative in that you can override what the kernel is
doing via user space (sort of what Pat LaVarre experienced).

Also mentioned in the above thread:

The EVPD code has been removed, and is not an issue.

There is now code to set BLIST_INQUIRY_36 (we can still potentially hang
broken devices before it is set, but you should get a warning, and then
could modify devinfo on the boot/module command line or via proc devinfo).

-- Patrick Mansfield
