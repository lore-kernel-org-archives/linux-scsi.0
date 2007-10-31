From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 11:46:23 -0500
Message-ID: <1193849183.3411.45.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710311200080.4704-100000@iolanthe.rowland.org>
	 <1193847197.3411.32.camel@localhost.localdomain>
	 <1193847866.6621.5.camel@lov.site>
	 <1193848270.3411.39.camel@localhost.localdomain>
	 <1193848942.6621.18.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34863 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754982AbXJaQqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 12:46:25 -0400
In-Reply-To: <1193848942.6621.18.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 17:42 +0100, Kay Sievers wrote:
> On Wed, 2007-10-31 at 11:31 -0500, James Bottomley wrote:
> > On Wed, 2007-10-31 at 17:24 +0100, Kay Sievers wrote:
> > > On Wed, 2007-10-31 at 11:13 -0500, James Bottomley wrote:
> > > > On Wed, 2007-10-31 at 12:04 -0400, Alan Stern wrote:
> > > > > On Wed, 31 Oct 2007, James Bottomley wrote:
> > > > > 
> > > > > > > Yes, the queue is a child of the disk.
> > > > > > 
> > > > > > Right, so this goes gendisk->queue (-> meaning parent of, or takes
> > > > > > reference to)
> > > > > 
> > > > > No, no!  The _child_ takes an implicit reference to the _parent_, not 
> > > > > the other way around.
> > > > > 
> > > > > > > > The scsi_device has a ref to the queue
> > > > > > > 
> > > > > > > Yeah, while the queue is a grandchild of the scsi_device with the
> > > > > > > unified sysfs layout.
> > > > > > 
> > > > > > No, the scsi_device is a direct parent of the queue, so we have
> > > > > > 
> > > > > > scsi_device->queue
> > > > > 
> > > > > Wrong -- the gendisk is the direct parent of the queue.  The relevant 
> > > > > line is in ll_rw_blk.c:blk_register_queue():
> > > > > 
> > > > > 	q->kobj.parent = kobject_get(&disk->dev.kobj);
> > > > > 
> > > > > > > Yes, sounds right. We need to break that deleted-but-wait-for-cleanup at
> > > > > > > least at one of the devices involved.
> > > > > > 
> > > > > > But it's broken when the driver is unbound.  Diagrammatically it's:
> > > > > > 
> > > > > > scsi_disk -> scsi_device -> queue
> > > > > >           -> gendisk     ->
> > > > > > 
> > > > > > It's not circular, it's released when scsi_disk is released.  It can
> > > > > > become circular if there's some hidden dependency between any of the
> > > > > > components ... but I don't think there is.
> > > > > 
> > > > > Forget about the scsi_disk.  It isn't part of the problem.  Just 
> > > > > concentrate on the scsi_device, the gendisk, and the queue.  We have:
> > > > > 
> > > > > 	scsi_device <- gendisk <- queue <- scsi_device,
> > > > 
> > > > OK, so where does the gendisk get a reference to the scsi device?
> > > 
> > > In the unified sysfs layout where the silly and conceptual broken idea
> > > of "class devices" gets removed.
> > > Everything that has a "device" link today will just live below the
> > > device the "device" link points to. The whole current kernel is already
> > > converted to do this, besides the "raw kobject" gendisk's, and the SCSI
> > > subsystem. The gendisk patch is queued in Greg's tree (see subject of
> > > this mail), and the conversion from "struct class_device" to "struct
> > > device" for the whole SCSI directory is coming soon.
> > > 
> > > With the gendisk pointing to "driverfs_dev" ("device" link) it will
> > > become a child of the scsi_device.
> > 
> > OK, light beginning to go on now.
> > 
> > The problem is that you've fallen into the conceptual trap we tried very
> > hard to avoid in the initial go around of joining SCSI upper layer
> > drivers to gendisks.  That's why no gendisk references are held by the
> > mid-layer, only by the entities that represent the objects created by
> > upper layer drivers.
> 
> That will not change, only the disk will reference the device which it
> points to. It's not a problem, we can "orphan" the disk on delete, or we
> do the "orphaning" for all devices in the core, which is probably the
> right fix anyway.

But you're assuming the relationship gendisk->queue exists when we
delete the scsi device.  What should happen is that the gendisk should
be released first in the ULD detach.  Queues are allowed to exist
without gendisks (when a SCSI queue is first created, that's what it
should look like), so I think we're perhaps simply missing an API that
would detach the queue and the gendisk (and get the gendisk to delete
itself and give up its device link) ... doesn't del_gendisk() do this?

> > Doesn't this circularity now exist for everything?  Every device that
> > creates a queue has a reference to the queue, every queue has a
> > reference to its attached gendisk and now every gendisk has a reference
> > to the device creating the queue?  This doesn't look to be a SCSI
> > specific problem.
> 
> It's only SCSI so far, everything else seems fine.

But you didn't respond to the stated problem: there are very few other
non-scsi block devices ... have you tried looking at cciss?

> But, the real problem is that the core seems to deadlock if two devices
> reference each other (or build a larger circle), even when they are
> deleted, that's the problem we are running in.

Yes ... we sort of evaded that one by having class devices hang off the
sides of real devices ... making everything a peer with crosslinks
brings it back with a vengeance.

James


