From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 17:24:26 +0100
Message-ID: <1193847866.6621.5.camel@lov.site>
References: <Pine.LNX.4.44L0.0710311200080.4704-100000@iolanthe.rowland.org>
	 <1193847197.3411.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbXJaQWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 12:22:15 -0400
In-Reply-To: <1193847197.3411.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 11:13 -0500, James Bottomley wrote:
> On Wed, 2007-10-31 at 12:04 -0400, Alan Stern wrote:
> > On Wed, 31 Oct 2007, James Bottomley wrote:
> > 
> > > > Yes, the queue is a child of the disk.
> > > 
> > > Right, so this goes gendisk->queue (-> meaning parent of, or takes
> > > reference to)
> > 
> > No, no!  The _child_ takes an implicit reference to the _parent_, not 
> > the other way around.
> > 
> > > > > The scsi_device has a ref to the queue
> > > > 
> > > > Yeah, while the queue is a grandchild of the scsi_device with the
> > > > unified sysfs layout.
> > > 
> > > No, the scsi_device is a direct parent of the queue, so we have
> > > 
> > > scsi_device->queue
> > 
> > Wrong -- the gendisk is the direct parent of the queue.  The relevant 
> > line is in ll_rw_blk.c:blk_register_queue():
> > 
> > 	q->kobj.parent = kobject_get(&disk->dev.kobj);
> > 
> > > > Yes, sounds right. We need to break that deleted-but-wait-for-cleanup at
> > > > least at one of the devices involved.
> > > 
> > > But it's broken when the driver is unbound.  Diagrammatically it's:
> > > 
> > > scsi_disk -> scsi_device -> queue
> > >           -> gendisk     ->
> > > 
> > > It's not circular, it's released when scsi_disk is released.  It can
> > > become circular if there's some hidden dependency between any of the
> > > components ... but I don't think there is.
> > 
> > Forget about the scsi_disk.  It isn't part of the problem.  Just 
> > concentrate on the scsi_device, the gendisk, and the queue.  We have:
> > 
> > 	scsi_device <- gendisk <- queue <- scsi_device,
> 
> OK, so where does the gendisk get a reference to the scsi device?

In the unified sysfs layout where the silly and conceptual broken idea
of "class devices" gets removed.
Everything that has a "device" link today will just live below the
device the "device" link points to. The whole current kernel is already
converted to do this, besides the "raw kobject" gendisk's, and the SCSI
subsystem. The gendisk patch is queued in Greg's tree (see subject of
this mail), and the conversion from "struct class_device" to "struct
device" for the whole SCSI directory is coming soon.

With the gendisk pointing to "driverfs_dev" ("device" link) it will
become a child of the scsi_device.

Kay

