From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 2/2] relax scsi dma alignment
Date: Tue, 1 Jan 2008 12:15:29 -0500
Message-ID: <20080101171529.GA545@osc.edu>
References: <1199141005.3110.27.camel@localhost.localdomain> <20080101160859.GA482@osc.edu> <1199204821.3252.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:42428 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbYAARPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jan 2008 12:15:31 -0500
Content-Disposition: inline
In-Reply-To: <1199204821.3252.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Kristian Hoegsberg <krh@bitplanet.net>, Jens Axboe <Jens.Axboe@oracle.com>

James.Bottomley@HansenPartnership.com wrote on Tue, 01 Jan 2008 10:27 -0600:
> On Tue, 2008-01-01 at 11:08 -0500, Pete Wyckoff wrote:
> > James.Bottomley@HansenPartnership.com wrote on Mon, 31 Dec 2007 16:43 -0600:
> > > This patch relaxes the default SCSI DMA alignment from 512 bytes to 4
> > > bytes.  I remember from previous discussions that usb and firewire have
> > > sector size alignment requirements, so I upped their alignments in the
> > > respective slave allocs.
> > > 
> > > The reason for doing this is so that we don't get such a huge amount of
> > > copy overhead in bio_copy_user() for udev.  (basically all inquiries it
> > > issues can now be directly mapped).
> > 
> > Great change.  Here's another patch.  It allows a queue
> > dma_alignment of 0 bytes, for drivers that can move data
> > at byte granularity.
> > 
> > Two drivers try to turn off DMA alignment restrictions by
> > setting the dma_alignment to zero:
> > 
> >     drivers/scsi/iscsi_tcp.c: blk_queue_dma_alignment(sdev->request_queue, 0);
> >     drivers/scsi/scsi_tgt_lib.c: blk_queue_dma_alignment(q, 0);
> > 
> > But they end up doing copies due to the way that queue_dma_alignment()
> > returns 511 in this case.
[..]
> > From 90ee6d61ad71a024815eee2b416edb40c6b01256 Mon Sep 17 00:00:00 2001
> > From: Pete Wyckoff <pw@osc.edu>
> > Date: Tue, 1 Jan 2008 10:23:02 -0500
> > Subject: [PATCH] block: allow queue dma_alignment of zero
> > 
> > Let queue_dma_alignment return 0 if it was specifically set to 0.
> > This permits devices with no particular alignment restrictions to
> > use arbitrary user space buffers without copying.
> > 
> > Signed-off-by: Pete Wyckoff <pw@osc.edu>
> > ---
> >  include/linux/blkdev.h |    7 +------
> >  1 files changed, 1 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index aa3090c..eea31c2 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -860,12 +860,7 @@ static inline int bdev_hardsect_size(struct block_device *bdev)
> >  
> >  static inline int queue_dma_alignment(struct request_queue *q)
> >  {
> > -	int retval = 511;
> > -
> > -	if (q && q->dma_alignment)
> > -		retval = q->dma_alignment;
> > -
> > -	return retval;
> > +	return q ? q->dma_alignment : 511;
> >  }
> >  
> >  /* assumes size > 256 */
> 
> This is certainly a possible patch.  What assurance do you have that it
> doesn't upset block devices who set zero assuming they get the default
> alignment?

Code inspection of the initialization and use of this field.  I hope
anybody who sees a mistake here will point it out.

1. Initialization

Most users call blk_init_queue{,_node} to alloc and initialize a new
request_queue.  This leads to initialization of dma_alignment to 511
in blk_queue_make_request().

The rest of the callers use blk_alloc_queue{,_node}.  Most of those
call blk_queue_make_request() with a custom make_request_fn a few
lines later, similarly causing dma_alignment to be initialized to
non-zero.  The loop and pktcdvd drivers require a bit of reading to
convince oneself, but also can be seen to call
blk_queue_make_request() before using the queue.

2. Use of blk_queue_dma_alignment() to set, queue_dma_alignment() and
   ->dma_alignment to get

Inspection of the 20-odd spots that match "dma_alignment" shows that
none of them set zero to expect the default.


Definitely a valid concern, but it seems to be a safe change, at
least for in-tree users.  Do you think a new request_queue flag for
zero-aware drivers and a WARN_ON that checks for zero and !zero_aware
would be worthwhile?

Without this change, we can go as low as two-byte alignment on
buffer start and length by setting dma_alignment to 1, but will do a
full copy if (buffer&1) or (length&1).

		-- Pete

