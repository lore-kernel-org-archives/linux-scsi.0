From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Thu, 5 Mar 2009 11:30:24 +0100
Message-ID: <20090305103023.GW11787@kernel.dk>
References: <20090305182958Q.fujita.tomonori@lab.ntt.co.jp> <20090305100901.GU11787@kernel.dk> <20090305101436.GV11787@kernel.dk> <20090305192737I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:48215 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZCEKa0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 05:30:26 -0500
Content-Disposition: inline
In-Reply-To: <20090305192737I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tglx@linutronix.de, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Mar 05 2009, FUJITA Tomonori wrote:
> On Thu, 5 Mar 2009 11:14:36 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Mar 05 2009, Jens Axboe wrote:
> > > On Thu, Mar 05 2009, FUJITA Tomonori wrote:
> > > > Oops, somehow I forgot to CC Jens...
> > > > 
> > > > On Thu, 5 Mar 2009 17:39:17 +0900
> > > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > > 
> > > > > On Thu, 5 Mar 2009 17:36:13 +0900
> > > > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > > > 
> > > > > > CC'ed Jens,
> > > > > > 
> > > > > > On Wed, 04 Mar 2009 22:56:29 +0000
> > > > > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > > > 
> > > > > > > On Wed, 2009-03-04 at 22:45 +0100, Thomas Gleixner wrote:
> > > > > > > > On Wed, 4 Mar 2009, Thomas Gleixner wrote:
> > > > > > > > 
> > > > > > > > Instrumented the code and the result of the failing request is
> > > > > > > > below. Looks like the function which sets up the request gets
> > > > > > > > nr_phys_segments wrong by one. 
> > > > > > > > 
> > > > > > > > If you need further trace data feel free to ask.
> > > > > > > 
> > > > > > > OK, the mapping all checks out correctly ... there must be something
> > > > > > > wrong with the way we count before mapping.
> > > > > > 
> > > > > > Yeah, looks we miscalculate nr_phys_segments in the merging path.
> > > > > > 
> > > > > > blk_recount_segments() needs to set bi_seg_front_size and
> > > > > > bi_seg_back_size for ll_merge_requests_fn()?
> > > > > > 
> > > > > > =
> > > > > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > > > > index a104593..efb65b6 100644
> > > > > > --- a/block/blk-merge.c
> > > > > > +++ b/block/blk-merge.c
> > > > > > @@ -111,12 +111,19 @@ void blk_recalc_rq_segments(struct request *rq)
> > > > > >  
> > > > > >  void blk_recount_segments(struct request_queue *q, struct bio *bio)
> > > > > >  {
> > > > > > +	unsigned int seg_size;
> > > > > >  	struct bio *nxt = bio->bi_next;
> > > > > >  
> > > > > >  	bio->bi_next = NULL;
> > > > > > -	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
> > > > > > +	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, &seg_size);
> > > > > >  	bio->bi_next = nxt;
> > > > > >  	bio->bi_flags |= (1 << BIO_SEG_VALID);
> > > > > > +
> > > > > > +	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
> > > > > > +		bio->bi_seg_front_size = seg_size;
> > > > > > +	if (bio->bi_phys_segments > bio->bi_seg_back_size)
> > > > > > +		bio->bi_seg_back_size = seg_size;
> > > > > > +
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(blk_recount_segments);
> > > > > 
> > > > > Duh, here's the proper patch.
> > > > > 
> > > > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > > > index a104593..06e0db4 100644
> > > > > --- a/block/blk-merge.c
> > > > > +++ b/block/blk-merge.c
> > > > > @@ -111,12 +111,19 @@ void blk_recalc_rq_segments(struct request *rq)
> > > > >  
> > > > >  void blk_recount_segments(struct request_queue *q, struct bio *bio)
> > > > >  {
> > > > > +	unsigned int seg_size;
> > > > >  	struct bio *nxt = bio->bi_next;
> > > > >  
> > > > >  	bio->bi_next = NULL;
> > > > > -	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
> > > > > +	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, &seg_size);
> > > > >  	bio->bi_next = nxt;
> > > > >  	bio->bi_flags |= (1 << BIO_SEG_VALID);
> > > > > +
> > > > > +	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
> > > > > +		bio->bi_seg_front_size = seg_size;
> > > > > +	if (seg_size > bio->bi_seg_back_size)
> > > > > +		bio->bi_seg_back_size = seg_size;
> > > > > +
> > > > >  }
> > > > >  EXPORT_SYMBOL(blk_recount_segments);
> > > 
> > > Good catch, I merged it with a slight change of layout and clearing
> > > seg_size initially, to avoid gcc silly errors.
> > 
> > While merging that, I think we can do better than this. Essentially we
> > just need to have __blk_recalc_rq_segments() track the back bio as well,
> > then we don't have to pass in a pointer for segment sizes.
> > 
> > Totally untested, comments welcome...
> 
> Yeah, I think that updating bi_seg_front_size and bi_seg_back_size at
> one place, __blk_recalc_rq_segments, is better. I thought about the
> same way. But we are already in -rc7 and this must go into mainline
> now. So I chose a less-intrusive way (similar to what we have done in
> the past).
> 
> As you know, the merging code is really complicated and we could
> overlook stuff easily. ;) It might be better to simplify the merging
> code a bit.

If someone (Ingo?) is willing to test the last variant, I'd much rather
add that. It does simplify it (imho), and it kills 23 lines while only
adding 9. But a quick response would be nice, then I can ask Linus to
pull it later today.

-- 
Jens Axboe

