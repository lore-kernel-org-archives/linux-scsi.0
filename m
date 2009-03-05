From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Thu, 5 Mar 2009 11:14:36 +0100
Message-ID: <20090305101436.GV11787@kernel.dk>
References: <1236207389.21486.19.camel@localhost.localdomain> <20090305173649M.fujita.tomonori@lab.ntt.co.jp> <20090305173952U.fujita.tomonori@lab.ntt.co.jp> <20090305182958Q.fujita.tomonori@lab.ntt.co.jp> <20090305100901.GU11787@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:45008 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZCEKOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 05:14:39 -0500
Content-Disposition: inline
In-Reply-To: <20090305100901.GU11787@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tglx@linutronix.de, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Mar 05 2009, Jens Axboe wrote:
> On Thu, Mar 05 2009, FUJITA Tomonori wrote:
> > Oops, somehow I forgot to CC Jens...
> > 
> > On Thu, 5 Mar 2009 17:39:17 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Thu, 5 Mar 2009 17:36:13 +0900
> > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > CC'ed Jens,
> > > > 
> > > > On Wed, 04 Mar 2009 22:56:29 +0000
> > > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > 
> > > > > On Wed, 2009-03-04 at 22:45 +0100, Thomas Gleixner wrote:
> > > > > > On Wed, 4 Mar 2009, Thomas Gleixner wrote:
> > > > > > 
> > > > > > Instrumented the code and the result of the failing request is
> > > > > > below. Looks like the function which sets up the request gets
> > > > > > nr_phys_segments wrong by one. 
> > > > > > 
> > > > > > If you need further trace data feel free to ask.
> > > > > 
> > > > > OK, the mapping all checks out correctly ... there must be something
> > > > > wrong with the way we count before mapping.
> > > > 
> > > > Yeah, looks we miscalculate nr_phys_segments in the merging path.
> > > > 
> > > > blk_recount_segments() needs to set bi_seg_front_size and
> > > > bi_seg_back_size for ll_merge_requests_fn()?
> > > > 
> > > > =
> > > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > > index a104593..efb65b6 100644
> > > > --- a/block/blk-merge.c
> > > > +++ b/block/blk-merge.c
> > > > @@ -111,12 +111,19 @@ void blk_recalc_rq_segments(struct request *rq)
> > > >  
> > > >  void blk_recount_segments(struct request_queue *q, struct bio *bio)
> > > >  {
> > > > +	unsigned int seg_size;
> > > >  	struct bio *nxt = bio->bi_next;
> > > >  
> > > >  	bio->bi_next = NULL;
> > > > -	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
> > > > +	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, &seg_size);
> > > >  	bio->bi_next = nxt;
> > > >  	bio->bi_flags |= (1 << BIO_SEG_VALID);
> > > > +
> > > > +	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
> > > > +		bio->bi_seg_front_size = seg_size;
> > > > +	if (bio->bi_phys_segments > bio->bi_seg_back_size)
> > > > +		bio->bi_seg_back_size = seg_size;
> > > > +
> > > >  }
> > > >  EXPORT_SYMBOL(blk_recount_segments);
> > > 
> > > Duh, here's the proper patch.
> > > 
> > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > index a104593..06e0db4 100644
> > > --- a/block/blk-merge.c
> > > +++ b/block/blk-merge.c
> > > @@ -111,12 +111,19 @@ void blk_recalc_rq_segments(struct request *rq)
> > >  
> > >  void blk_recount_segments(struct request_queue *q, struct bio *bio)
> > >  {
> > > +	unsigned int seg_size;
> > >  	struct bio *nxt = bio->bi_next;
> > >  
> > >  	bio->bi_next = NULL;
> > > -	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
> > > +	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, &seg_size);
> > >  	bio->bi_next = nxt;
> > >  	bio->bi_flags |= (1 << BIO_SEG_VALID);
> > > +
> > > +	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
> > > +		bio->bi_seg_front_size = seg_size;
> > > +	if (seg_size > bio->bi_seg_back_size)
> > > +		bio->bi_seg_back_size = seg_size;
> > > +
> > >  }
> > >  EXPORT_SYMBOL(blk_recount_segments);
> 
> Good catch, I merged it with a slight change of layout and clearing
> seg_size initially, to avoid gcc silly errors.

While merging that, I think we can do better than this. Essentially we
just need to have __blk_recalc_rq_segments() track the back bio as well,
then we don't have to pass in a pointer for segment sizes.

Totally untested, comments welcome...

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6be3797..5a244f0 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -39,14 +39,13 @@ void blk_recalc_rq_sectors(struct request *rq, int nsect)
 }
 
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
-					     struct bio *bio,
-					     unsigned int *seg_size_ptr)
+					     struct bio *bio)
 {
 	unsigned int phys_size;
 	struct bio_vec *bv, *bvprv = NULL;
 	int cluster, i, high, highprv = 1;
 	unsigned int seg_size, nr_phys_segs;
-	struct bio *fbio;
+	struct bio *fbio, *bbio;
 
 	if (!bio)
 		return 0;
@@ -87,41 +86,28 @@ new_segment:
 			seg_size = bv->bv_len;
 			highprv = high;
 		}
+		bbio = bio;
 	}
 
-	if (seg_size_ptr)
-		*seg_size_ptr = seg_size;
+	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
+		fbio->bi_seg_front_size = seg_size;
+	if (seg_size > bbio->bi_seg_back_size)
+		bbio->bi_seg_back_size = seg_size;
 
 	return nr_phys_segs;
 }
 
 void blk_recalc_rq_segments(struct request *rq)
 {
-	unsigned int seg_size = 0, phys_segs;
-
-	phys_segs = __blk_recalc_rq_segments(rq->q, rq->bio, &seg_size);
-
-	if (phys_segs == 1 && seg_size > rq->bio->bi_seg_front_size)
-		rq->bio->bi_seg_front_size = seg_size;
-	if (seg_size > rq->biotail->bi_seg_back_size)
-		rq->biotail->bi_seg_back_size = seg_size;
-
-	rq->nr_phys_segments = phys_segs;
+	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
 	struct bio *nxt = bio->bi_next;
-	unsigned int seg_size = 0;
 
 	bio->bi_next = NULL;
-	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
-
-	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
-		bio->bi_seg_front_size = seg_size;
-	if (seg_size > bio->bi_seg_back_size)
-		bio->bi_seg_back_size = seg_size;
-
+	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio);
 	bio->bi_next = nxt;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }

-- 
Jens Axboe

