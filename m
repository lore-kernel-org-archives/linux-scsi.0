From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Mon, 22 Feb 2010 12:44:26 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002221232160.1251-100000@iolanthe.rowland.org>
References: <1266843999.4414.27.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48879 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752297Ab0BVRo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2010 12:44:29 -0500
In-Reply-To: <1266843999.4414.27.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ramya Desai <ramya.desai@gmail.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Mon, 22 Feb 2010, James Bottomley wrote:

> On Mon, 2010-02-22 at 18:20 +0530, Ramya Desai wrote:
> > On Fri, Feb 19, 2010 at 7:56 PM, James Bottomley
> > <James.Bottomley@suse.de> wrote:
> > 
> > > Before we get into that, what architecture is this?  There are a few,
> > > like arm that don't have architecture support for chaining, so they can
> > > never go over 128 segments.
> > 
> > I am using the desktop PC to access my device. i.e, Intel processor
> > with x86 architecture.
> 
> OK, so now see what max_hw_sectors_kb says ... if it's still 512 and
> you're sure you've got sg_tablesize set to something higher, there's
> likely something in the USB stack resetting it ... I suppose it's
> possible there's something else in your kernel doing that for the
> architecture, but you could rule that out by looking at
> max_hw_sectors_kb for either a SCSI or libata device and verifying it's
> much higher than 512.

Usb-storage sets max_sectors to 240 in the host template.  For some
reason, the block layer also changes max_hw_sectors to the same value
(see block/blk-settings.c:blk_queue_max_sectors()).

The value can be changed by writing to 
/sys/block/sdX/device/max_sectors (where X is the drive letter).  Note 
that this value is in 512-byte blocks, not in KB.  However it is 
limited to SCSI_DEFAULT_MAX_SECTORS, which is 1024, corresponding to 
512 MB.  If larger transfers are needed then 
drivers/usb/storage/scsiglue.c:store_max_sectors() must be changed.

Alan Stern

