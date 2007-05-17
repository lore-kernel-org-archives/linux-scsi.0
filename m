From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 23:11:27 +0900
Message-ID: <20070517231127T.fujita.tomonori@lab.ntt.co.jp>
References: <464C1721.8030009@panasas.com>
	<1179408422.3785.5.camel@mulgrave.il.steeleye.com>
	<464C5FF5.6000705@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:45329 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbXEQONA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 10:13:00 -0400
In-Reply-To: <464C5FF5.6000705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 17:00:21 +0300

> James Bottomley wrote:
> > On Thu, 2007-05-17 at 11:49 +0300, Boaz Harrosh wrote:
> >> These are regular fs (ext3) requests during bootup. The machine will not
> >> boot. (Usually from the read ahead code)
> >> Don't believe me look at the second patch Over Tomo's cleanup.
> >> If I define SCSI_MAX_SG_SEGMENTS to 127 it will crash even when I
> >> did in code:
> >> 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
> >> I suppose someone is looking at a different definition. Or there is
> >> another call I need to do for this to work.
> > 
> > It would really help us if you showed the actual code for what you did
> > and where ... if this is wrong, we have bigger problems that quibbling
> > about bidirectional slab sizes.  The correct way to adjust this limit
> > artificially to 127 is:
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 1f5a07b..4a27841 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1576,7 +1576,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
> >  		return NULL;
> >  
> >  	blk_queue_max_hw_segments(q, shost->sg_tablesize);
> > -	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
> > +	blk_queue_max_phys_segments(q, 127);
> >  	blk_queue_max_sectors(q, shost->max_sectors);
> >  	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
> >  	blk_queue_segment_boundary(q, shost->dma_boundary);
> > 
> > (It doesn't alter the allocation pools or anything else, just limits the
> > max phys segments of the queue).  The way to check that this limit is
> > being honoured is:
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 1f5a07b..ae42e4d 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1000,6 +1000,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
> >  	 * kmapping pages)
> >  	 */
> >  	cmd->use_sg = req->nr_phys_segments;
> > +	WARN_ON(req->nr_phys_segments > 127);
> >  
> >  	/*
> >  	 * If sg table allocation fails, requeue request later.
> > 
> > James
> > 
> > 
> Yes Tomo found it at ata_scsi_slave_config(). Attached below the way I
> fixed it. Now it works with 127.

I think that we can just remove blk_queue_max_phys_segments since the
ata drivers seem to set sg_tablesize to LIBATA_MAX_PRD.


> (By the way Tomo, a printk like you did in scsi_init_io and
> scsi_free_sgtable, 2 for every IO, or even 1 for every IO, will make
> a SCSI booting PC like mine almost un-usable. Think of printk going
> to log-file doing a printk...)

Oops, I forgot to remove it since my SCSI booting pSeries box works
with that. :)
