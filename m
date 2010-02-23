From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Tue, 23 Feb 2010 13:01:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002231253320.1308-100000@iolanthe.rowland.org>
References: <yq1aauzopk2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50695 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752888Ab0BWSBT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 13:01:19 -0500
In-Reply-To: <yq1aauzopk2.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Tue, 23 Feb 2010, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> Alan> James or Jens, is there a reason why this routine limits
> Alan> max_sectors to 1024?
> 
> Alan> And is there a reason why it sets both max_sectors and
> Alan> max_hw_sectors, leaving no way to change one without the other?
> 
> The rationale being that we don't want the default value to be too large
> because it makes I/O choppy on single-spindle setups.  
> 
> If the device driver supports bigger requests we set the hard limit to
> whatever they support.  But filesystem I/O is capped at the default
> limit which is 1024 for modern devices (and 255 for crappy ones).
> 
> You can change the current soft limit on a per-device basis in
> /sys/block/<dev>/queue/max_sectors_kb.
> 
> I agree it would be nice to have a system-wide default that's not a
> #define.  But given that a lot of queues are created early that's not so
> easy to do.
> 
> 
> Alan> Are drivers supposed to assign values directly to
> Alan> q-> limits.max_sectors?  Shouldn't there be a cleaner API for all
> Alan> this?
> 
> Drivers are supposed to set the hard limit.  The soft limit is a
> fs/block layer value and none of the device driver's business.

So Ramya, it looks like you need to edit store_max_sectors() in 
drivers/usb/storage/scsiglue.c.  Get rid of the " && ms <= 
SCSI_DEFAULT_MAX_SECTORS" part.

Then you should be able to write a large value to
/sys/block/sdX/device/max_sectors to increase the hardware limit.  The
new value divided by 2 will show up in
/sys/block/sdX/queue/max_hw_sectors_kb.

Once that limit is increased, you can write a large value to 
/sys/block/sdX/queue/max_sectors_kb.  That should give you long 
transfer lengths.

Alan Stern

