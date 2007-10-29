From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Mon, 29 Oct 2007 12:38:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710291209250.4882-100000@iolanthe.rowland.org>
References: <1193672157.3383.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46512 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752904AbXJ2Qi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 12:38:57 -0400
In-Reply-To: <1193672157.3383.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 29 Oct 2007, James Bottomley wrote:

> On Mon, 2007-10-29 at 11:18 -0400, Alan Stern wrote:
> > With regard to the discussion below, is there any objection to the 
> > attached patch?  It moves the call to scsi_release_queue() from 
> > scsi_device_dev_release_usercontext() to __scsi_remove_device().  In 
> > fact, it might turn out that with this change, the extra _usercontext 
> > routine isn't needed at all.
> 
> There's a flaw in the discussion.
> 
> > As far as I can see, the only reason for not adopting this patch would 
> > be if a scsi_device's queue structure was needed even after the 
> > scsi_device was unregistered.  Does this ever happen?  If it does, it 
> > would be indicative of a nasty reference-loop problem (scsi_device 
> > needs reference to request_queue, request_queue holds reference to 
> > gendisk, gendisk holds reference to scsi_device).
> 
> I'm not sure if we can do this patch.  If you kill a device, you see
> there's a processing state in scsi_prep_fn() for SDEV_DEL, which has a
> printk message I see quite often when I unplug devices while they're
> operating.

Me too.

> If you NULL out and free the request queue immediately after setting
> SDEV_DEL, without allowing the devices and filesystems to finish, are
> you sure we're not going to get a null deref on sdev->request_queue?

That's basically what I was asking you!  :-)  What happens if you try 
to clean up a block queue when there are still outstanding requests?

> > On Tue, 2007-10-23 at 00:14 -0400, Alan Stern wrote:
> > > On Tue, 23 Oct 2007, Kay Sievers wrote:
> > > 
> > > > There must be something going wrong with the block patch in conjunction
> > > > with the crazy SCSI release logic.
> > > 
> > > I don't know -- there's nothing obviously wrong with the block patch 
> > > except the extra put_device.  But you're right that the SCSI logic is 
> > > crazy.  The scsi_device is the parent of the gendisk, which is the 
> > > parent of the request_queue.  But the scsi_device holds a reference to 
> > > the request_queue, which is dropped in the scsi_device's release 
> > > routine!
> > 
> > That's the thing. We see a circular reference when we use the SCSI LUN
> > as the parent.
> > The sysfs relationship is: scsi_device -> genhd -> queue, while the
> 
> That's not true.
> 
> The relationship is scsi_device -> queue

I think Kay wrote his arrows backwards.  Or maybe he just made a simple 
mistake.

> However, genhd is conditioned on the ULD attachment (we can have queues
> with no gendisk), so for instance, for sd it's
> 
> scsi_disk -> genhd -> queue
>           -> scsi_device
> 
> However, when we get to the device destruction part, the first thing
> that should happen is that the driver should unbind, so we release the
> driver specific structure and the genhd (and it's ref to the queue and
> the scsi_device).  Then we can let the mid-layer remove functions
> release the queue.

That's what should happen.  And in fact the scsi_disk structure doesn't
cause any difficulties; we're only worried about the scsi_device
structure.

> > queue holds a ref to to the blockdev (parent), the blockdev to the
> > scsi_device (parent) and the scsi_devices to the queue (SCSI). All
> > waiting for their release functions to be called, to release the other
> > refs.
> 
> This isn't how it's supposed to be ... the refs are supposed to be the
> other way around (blockdev/genhd has a ref to the queue, but scsi_device
> has a separate ref to the queue; the genhd should be releaseable even if
> the device hasn't given up the queue).

No, that's not what happens.  The genhd's parent is the scsi_device and 
the queue's parent is the genhd.  You can see this immediately from the 
directory layout in sysfs.  Thus:

	the scsi_device holds a reference to the queue,
	which holds a reference to the genhd,
	which holds a reference to the scsi_device.

In fact it's not the struct device's reference to the parent which
causes the problem -- it's the embedded kobject's reference to the
kobject embedded in the parent device.  This reference doesn't get
dropped when the device (and its embedded kobject) are removed; it
persists until they are released.  But with the reference loop they
never do get released.

> I probably need more thread context to make a more informed statement,
> though.

If you want to wade through the email messages, the thread starts here:

	http://marc.info/?t=119273573500006&r=1&w=2

Here's a brief summary.  Kay wrote a patch modifying the block-device 
core, the "Driver core: convert block from raw kobjects to core 
devices" patch in $Subject.  The patch itself is located here:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/block-device.patch

although this version has been updated; in its original form the patch 
included an extra call to put_device(&disk_dev) right at the end of 
del_gendisk() in fs/partitions/check.c.

In my testing I found the extra put_device() caused problems and I
complained to Kay about it.  He explained that on his system the device
structures would never get released without it.  In the end he agreed
the call was wrong (which is presumably why the patch was modified),
and we determined that the structures never got released because of the
circular references.

The best way to fix the problem is to drop the kobject references at 
remove time instead of release time.  Hence my question to you about 
whether Hannes's patch to the SCSI core would be acceptable.

Alan Stern

