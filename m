From: Jens Axboe <axboe@suse.de>
Subject: Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 16:49:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119154911.GM1106@suse.de>
References: <20031119084729.GA1106@suse.de> <Pine.LNX.4.44L0.0311191033300.957-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:41903 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264126AbTKSPt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 10:49:26 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311191033300.957-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, Nov 19 2003, Alan Stern wrote:
> On Wed, 19 Nov 2003, Jens Axboe wrote:
> 
> > The queue already has such a restriction embedded, see bio_map_user()
> > and queue_dma_alignment().
> 
> Searching through the 2.6 kernel source gave some interesting results.
> 
> queue_dma_alignment() does nothing but set the dma_alignment field of the
> request queue structure.  The _only_ place this field is used is in
> fs/bio.c by __bio_map_user(), called from bio_map_user().  In turn, the
> _only_ place bio_map_user() is called is from drivers/block/scsi_ioctl.c,
> and that's only for a certain specific type of SCSI ioctl.  It's not on

It's for SG_IO.

> any main code path, and it wouldn't get invoked by anything using the st
> or sg drivers.  In fact, it looks like scsi_ioctl.c:scsi_cmd_ioctl() is
> only called from within the sd driver.

It's invoked from user space. Don't mix block and scsi scsi_ioctl() up.
bio_map_user() would be used by a block layer sg driver too, for
instance.

> So something needs to be fixed up.  Is there some spot in the block layer 
> that's supposed to be checking dma alignments but isn't doing so?

The queue dma alignment was added to better cater to cdrecord, for
instance. We need better than 512b granularity there, or you cannot use
DMA on certain types of burns (lots of sector types are non-2kb aligned
there).

If you can 512-byte align the data and transfer from user space, _that
is enough_. The program just needs to be aware of this, it's not an odd
restriction. There are just scenarious where you cannot do this, and
that is why I added the queue dma alignment attribute. To me, it doesn't
sound like your case applies.

-- 
Jens Axboe

