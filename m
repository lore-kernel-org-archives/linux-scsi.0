From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Wed, 31 Oct 2007 12:04:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710311200080.4704-100000@iolanthe.rowland.org>
References: <1193845634.3411.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60189 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753432AbXJaQE0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 12:04:26 -0400
In-Reply-To: <1193845634.3411.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 31 Oct 2007, James Bottomley wrote:

> > Yes, the queue is a child of the disk.
> 
> Right, so this goes gendisk->queue (-> meaning parent of, or takes
> reference to)

No, no!  The _child_ takes an implicit reference to the _parent_, not 
the other way around.

> > > The scsi_device has a ref to the queue
> > 
> > Yeah, while the queue is a grandchild of the scsi_device with the
> > unified sysfs layout.
> 
> No, the scsi_device is a direct parent of the queue, so we have
> 
> scsi_device->queue

Wrong -- the gendisk is the direct parent of the queue.  The relevant 
line is in ll_rw_blk.c:blk_register_queue():

	q->kobj.parent = kobject_get(&disk->dev.kobj);

> > Yes, sounds right. We need to break that deleted-but-wait-for-cleanup at
> > least at one of the devices involved.
> 
> But it's broken when the driver is unbound.  Diagrammatically it's:
> 
> scsi_disk -> scsi_device -> queue
>           -> gendisk     ->
> 
> It's not circular, it's released when scsi_disk is released.  It can
> become circular if there's some hidden dependency between any of the
> components ... but I don't think there is.

Forget about the scsi_disk.  It isn't part of the problem.  Just 
concentrate on the scsi_device, the gendisk, and the queue.  We have:

	scsi_device <- gendisk <- queue <- scsi_device,

where "A <- B" means that B holds a reference to A.

Alan Stern

