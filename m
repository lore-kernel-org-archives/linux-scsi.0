From: Jens Axboe <axboe@suse.de>
Subject: Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 18:03:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119170320.GP1106@suse.de>
References: <20031119154911.GM1106@suse.de> <Pine.LNX.4.44L0.0311191147270.957-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:24256 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263920AbTKSRDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 12:03:53 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311191147270.957-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, Nov 19 2003, Alan Stern wrote:
> On Wed, 19 Nov 2003, Jens Axboe wrote:
> 
> > > any main code path, and it wouldn't get invoked by anything using the st
> > > or sg drivers.  In fact, it looks like scsi_ioctl.c:scsi_cmd_ioctl() is
> > > only called from within the sd driver.
> > 
> > It's invoked from user space. Don't mix block and scsi scsi_ioctl() up.
> > bio_map_user() would be used by a block layer sg driver too, for
> > instance.
> 
> You've lost me.  scsi_cmd_ioctl() and bio_map_user() are _not_ used by the
> sg driver -- did you mean that a hypothetical block layer sg driver would
> call them?  That doesn't seem relevant to the point of this thread.  

Well you brought up bio_map_user(), so I'm telling where it's used and
why. The block layer provides SG_IO functionality for non-scsi devices,
that is its current use.

> Although come to think of it, you probably never saw the start of the
> thread.  Take a look at
> 
> http://marc.theaimsgroup.com/?l=linux-usb-devel&m=106916943618090&w=2
> 
> to understand my problem.

Ok I see. Then make sg/st return -EINVAL if the address isn't 512-byte
aligned would be the rigth fix, imo.

> > > So something needs to be fixed up.  Is there some spot in the block layer 
> > > that's supposed to be checking dma alignments but isn't doing so?
> > 
> > The queue dma alignment was added to better cater to cdrecord, for
> > instance. We need better than 512b granularity there, or you cannot use
> > DMA on certain types of burns (lots of sector types are non-2kb aligned
> > there).
> > 
> > If you can 512-byte align the data and transfer from user space, _that
> > is enough_. The program just needs to be aware of this, it's not an odd
> > restriction. There are just scenarious where you cannot do this, and
> > that is why I added the queue dma alignment attribute. To me, it doesn't
> > sound like your case applies.
> 
> This isn't a userspace problem as such; it's a problem of enforcing dma
> alignment restrictions within the block layer or lower.  I'm not working
> on a user program; I'm working on the usb-storage driver.  It too needs
> 512-byte alignment, but under the right circumstances the st and sg
> drivers can submit scatter-gather buffers that aren't aligned.  You said
> earlier that misaligned buffers would be caught in the block layer
> queueing code, but I don't see any place where that happens.

sg/st submissions would never pass through the block layer, even if they
use the queue as a transport between the scsi mid layer. They need to
impose this restrictions themselves. I still don't think this warrants
adding a host template attribute for this. 512-byte alignment is
perfectly fine.

-- 
Jens Axboe

