From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 10:47:14 -0500
Message-ID: <1193845634.3411.26.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710291434370.11432-100000@iolanthe.rowland.org>
	 <1193685197.2321.9.camel@lov.site> <20071031042531.GB16426@kroah.com>
	 <1193827590.2423.42.camel@lov.site>  <20071031143255.GC7076@kroah.com>
	 <1193843701.3411.20.camel@localhost.localdomain>
	 <1193845222.3254.9.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44224 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755714AbXJaPrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 11:47:17 -0400
In-Reply-To: <1193845222.3254.9.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 16:40 +0100, Kay Sievers wrote:
> On Wed, 2007-10-31 at 10:15 -0500, James Bottomley wrote:
> > On Wed, 2007-10-31 at 07:32 -0700, Greg KH wrote:
> > > Hm, I seem to have missed the part in this thread where someone said
> > > that it was valid to have a parent reference a child device.  That's
> > > just wrong and needs to be fixed.  Is that in the scsi layer somewhere?
> > > The block layer?  It sure isn't in the driver core...
> > 
> > This is the piece I'm still not clear on.  It's something to do with the
> > gendisk.  I'd have to look in block, but I believe the queue takes a ref
> > to the gendisk.
> 
> Yes, the queue is a child of the disk.

Right, so this goes gendisk->queue (-> meaning parent of, or takes
reference to)

> > The scsi_device has a ref to the queue
> 
> Yeah, while the queue is a grandchild of the scsi_device with the
> unified sysfs layout.

No, the scsi_device is a direct parent of the queue, so we have

scsi_device->queue

> > and the scsi_disk (in sd) has a
> > ref to both the scsi_device and the gendisk.  That means, until sd is
> > unbound and the scsi_disk released, there's an implied unbreakable
> > reference chain.
> > 
> > at least, I think that's what the problem is.
> 
> Yes, sounds right. We need to break that deleted-but-wait-for-cleanup at
> least at one of the devices involved.

But it's broken when the driver is unbound.  Diagrammatically it's:

scsi_disk -> scsi_device -> queue
          -> gendisk     ->

It's not circular, it's released when scsi_disk is released.  It can
become circular if there's some hidden dependency between any of the
components ... but I don't think there is.

James


