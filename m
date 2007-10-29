From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Mon, 29 Oct 2007 10:35:57 -0500
Message-ID: <1193672157.3383.22.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710291107180.4550-200000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34617 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752279AbXJ2PgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 11:36:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0710291107180.4550-200000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2007-10-29 at 11:18 -0400, Alan Stern wrote:
> With regard to the discussion below, is there any objection to the 
> attached patch?  It moves the call to scsi_release_queue() from 
> scsi_device_dev_release_usercontext() to __scsi_remove_device().  In 
> fact, it might turn out that with this change, the extra _usercontext 
> routine isn't needed at all.

There's a flaw in the discussion.

> As far as I can see, the only reason for not adopting this patch would 
> be if a scsi_device's queue structure was needed even after the 
> scsi_device was unregistered.  Does this ever happen?  If it does, it 
> would be indicative of a nasty reference-loop problem (scsi_device 
> needs reference to request_queue, request_queue holds reference to 
> gendisk, gendisk holds reference to scsi_device).

I'm not sure if we can do this patch.  If you kill a device, you see
there's a processing state in scsi_prep_fn() for SDEV_DEL, which has a
printk message I see quite often when I unplug devices while they're
operating.

If you NULL out and free the request queue immediately after setting
SDEV_DEL, without allowing the devices and filesystems to finish, are
you sure we're not going to get a null deref on sdev->request_queue?

> Alan Stern
> 
> 
> ---------- Forwarded message ----------
> Date: Tue, 23 Oct 2007 13:27:49 +0200
> From: Kay Sievers <kay.sievers@vrfy.org>
> To: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg KH <greg@kroah.com>,
>      Kernel development list <linux-kernel@vger.kernel.org>,
>      Hannes Reinecke <hare@suse.de>
> Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
>     devices
> 
> On Tue, 2007-10-23 at 00:14 -0400, Alan Stern wrote:
> > On Tue, 23 Oct 2007, Kay Sievers wrote:
> > 
> > > There must be something going wrong with the block patch in conjunction
> > > with the crazy SCSI release logic.
> > 
> > I don't know -- there's nothing obviously wrong with the block patch 
> > except the extra put_device.  But you're right that the SCSI logic is 
> > crazy.  The scsi_device is the parent of the gendisk, which is the 
> > parent of the request_queue.  But the scsi_device holds a reference to 
> > the request_queue, which is dropped in the scsi_device's release 
> > routine!
> 
> That's the thing. We see a circular reference when we use the SCSI LUN
> as the parent.
> The sysfs relationship is: scsi_device -> genhd -> queue, while the

That's not true.

The relationship is scsi_device -> queue

However, genhd is conditioned on the ULD attachment (we can have queues
with no gendisk), so for instance, for sd it's

scsi_disk -> genhd -> queue
          -> scsi_device

However, when we get to the device destruction part, the first thing
that should happen is that the driver should unbind, so we release the
driver specific structure and the genhd (and it's ref to the queue and
the scsi_device).  Then we can let the mid-layer remove functions
release the queue.

> queue holds a ref to to the blockdev (parent), the blockdev to the
> scsi_device (parent) and the scsi_devices to the queue (SCSI). All
> waiting for their release functions to be called, to release the other
> refs.

This isn't how it's supposed to be ... the refs are supposed to be the
other way around (blockdev/genhd has a ref to the queue, but scsi_device
has a separate ref to the queue; the genhd should be releaseable even if
the device hasn't given up the queue).

I probably need more thread context to make a more informed statement,
though.

> The scsi_device needs to drop the queue reference while the device is
> removed, not when it's data is released. Hannes came up with the
> attached patch, which seems to work fine here.
> 
> > That doesn't make much sense to me, and it is complicated by 
> > the fact that deleting a kobject doesn't drop the kobject's reference 
> > to its parent -- only releasing the kobject does.
> 
> Right, that makes things very complicated.
> 
> > In fact, for my development work I normally use a patch which makes 
> > kobjects behave better: They do drop the reference to their parent when 
> > they are deleted.  This actually is nothing more than a reversion of a 
> > patch added several years ago to try and cover up some of the 
> > weaknesses of the SCSI stack!  Now that the SCSI stack is in better 
> > shape, maybe my patch should be included in the mainstream kernel.  The 
> > patch is below; see what you think.
> 
> Sounds good to me, to disconnect a dead object from its parent when it's
> deleted. We only need to protect for "use after free" but not lock the
> parent, I guess. We should give it a try.

James


