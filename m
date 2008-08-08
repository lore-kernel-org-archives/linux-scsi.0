From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] drop vmerge accounting
Date: Fri, 8 Aug 2008 13:07:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
 <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
 <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYHHRIB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 13:08:01 -0400
In-Reply-To: <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Fri, 8 Aug 2008, Mikulas Patocka wrote:

> On Fri, 8 Aug 2008, Jens Axboe wrote:
> 
> > On Fri, Aug 08 2008, FUJITA Tomonori wrote:
> > > On Fri, 8 Aug 2008 08:15:37 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > BTW, we also wait for your verdict on:
> > > > > 
> > > > > http://marc.info/?t=121611935500002&r=1&w=2
> > > > 
> > > > I've always hated the iommu virtual merging complexity. My plan is to
> > > > rip it out.
> > > 
> > > No complaint from me. I'm just happy to see the verdict at length.
> > 
> > Mikulas, you had a patch for this. Can you strip out the arch bits and
> > just send me the block bits? The arch bits should go in via the arch
> > maintainers.
> > 
> > The iommu code may still do virtual merging, it would be silly not to do
> > that if possible. Now that later kernels expose the necessary parameters
> > at that level as well, it's perfectly feasible.
> 
> Here I'm sending the first one, it removes virtual merge accounting from 
> blk-merge.c (it acts as if all architectures undefined 
> BIO_VMERGE_BOUNDARY). I also created second patch that removes 
> bi_hw_segments field from struct bio and struct request. The next task 
> would be to remove nr_hw_segments from the request_queue, but it will 
> require changing the drivers.
> 
> Mikulas

(note: raid5 uses nr_hw_segments field for some other purpose, so this 
patch will break it. It should be fixed by raid5 maintainers)

Remove hw_segments field from struct bio and struct request. Without virtual
merge accounting they have no purpose.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c       |    1 -
 block/blk-merge.c      |   31 ++++---------------------------
 drivers/md/raid1.c     |    3 ---
 drivers/md/raid10.c    |    3 ---
 fs/bio.c               |   12 +-----------
 include/linux/bio.h    |   16 +---------------
 include/linux/blkdev.h |    7 -------
 7 files changed, 6 insertions(+), 67 deletions(-)

Index: linux-2.6.26-devel/block/blk-core.c
===================================================================
--- linux-2.6.26-devel.orig/block/blk-core.c	2008-08-08 18:46:30.000000000 +0200
+++ linux-2.6.26-devel/block/blk-core.c	2008-08-08 18:47:59.000000000 +0200
@@ -2003,7 +2003,6 @@ void blk_rq_bio_prep(struct request_queu
 	rq->cmd_flags |= (bio->bi_rw & 3);
 
 	rq->nr_phys_segments = bio_phys_segments(q, bio);
-	rq->nr_hw_segments = bio_hw_segments(q, bio);
 	rq->current_nr_sectors = bio_cur_sectors(bio);
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
Index: linux-2.6.26-devel/block/blk-merge.c
===================================================================
--- linux-2.6.26-devel.orig/block/blk-merge.c	2008-08-08 18:46:57.000000000 +0200
+++ linux-2.6.26-devel/block/blk-merge.c	2008-08-08 18:47:59.000000000 +0200
@@ -41,12 +41,9 @@ void blk_recalc_rq_sectors(struct reques
 void blk_recalc_rq_segments(struct request *rq)
 {
 	int nr_phys_segs;
-	int nr_hw_segs;
 	unsigned int phys_size;
-	unsigned int hw_size;
 	struct bio_vec *bv, *bvprv = NULL;
 	int seg_size;
-	int hw_seg_size;
 	int cluster;
 	struct req_iterator iter;
 	int high, highprv = 1;
@@ -56,8 +53,8 @@ void blk_recalc_rq_segments(struct reque
 		return;
 
 	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
-	hw_seg_size = seg_size = 0;
-	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
+	seg_size = 0;
+	phys_size = nr_phys_segs = 0;
 	rq_for_each_segment(bv, rq, iter) {
 		/*
 		 * the trick here is making sure that a high page is never
@@ -76,30 +73,17 @@ void blk_recalc_rq_segments(struct reque
 				goto new_segment;
 
 			seg_size += bv->bv_len;
-			hw_seg_size += bv->bv_len;
 			bvprv = bv;
 			continue;
 		}
 new_segment:
-		if (nr_hw_segs == 1 &&
-		    hw_seg_size > rq->bio->bi_hw_front_size)
-			rq->bio->bi_hw_front_size = hw_seg_size;
-		hw_seg_size = bv->bv_len;
-		nr_hw_segs++;
-
 		nr_phys_segs++;
 		bvprv = bv;
 		seg_size = bv->bv_len;
 		highprv = high;
 	}
 
-	if (nr_hw_segs == 1 &&
-	    hw_seg_size > rq->bio->bi_hw_front_size)
-		rq->bio->bi_hw_front_size = hw_seg_size;
-	if (hw_seg_size > rq->biotail->bi_hw_back_size)
-		rq->biotail->bi_hw_back_size = hw_seg_size;
 	rq->nr_phys_segments = nr_phys_segs;
-	rq->nr_hw_segments = nr_hw_segs;
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
@@ -112,7 +96,6 @@ void blk_recount_segments(struct request
 	blk_recalc_rq_segments(&rq);
 	bio->bi_next = nxt;
 	bio->bi_phys_segments = rq.nr_phys_segments;
-	bio->bi_hw_segments = rq.nr_hw_segments;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
 EXPORT_SYMBOL(blk_recount_segments);
@@ -251,10 +234,9 @@ static inline int ll_new_hw_segment(stru
 				    struct request *req,
 				    struct bio *bio)
 {
-	int nr_hw_segs = bio_hw_segments(q, bio);
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_hw_segments + nr_hw_segs > q->max_hw_segments
+	if (req->nr_phys_segments + nr_phys_segs > q->max_hw_segments
 	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
@@ -266,7 +248,6 @@ static inline int ll_new_hw_segment(stru
 	 * This will form the start of a new hw segment.  Bump both
 	 * counters.
 	 */
-	req->nr_hw_segments += nr_hw_segs;
 	req->nr_phys_segments += nr_phys_segs;
 	return 1;
 }
@@ -324,7 +305,6 @@ static int ll_merge_requests_fn(struct r
 				struct request *next)
 {
 	int total_phys_segments;
-	int total_hw_segments;
 
 	/*
 	 * First check if the either of the requests are re-queued
@@ -346,14 +326,11 @@ static int ll_merge_requests_fn(struct r
 	if (total_phys_segments > q->max_phys_segments)
 		return 0;
 
-	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
-
-	if (total_hw_segments > q->max_hw_segments)
+	if (total_phys_segments > q->max_hw_segments)
 		return 0;
 
 	/* Merge is OK... */
 	req->nr_phys_segments = total_phys_segments;
-	req->nr_hw_segments = total_hw_segments;
 	return 1;
 }
 
Index: linux-2.6.26-devel/include/linux/bio.h
===================================================================
--- linux-2.6.26-devel.orig/include/linux/bio.h	2008-08-08 18:46:29.000000000 +0200
+++ linux-2.6.26-devel/include/linux/bio.h	2008-08-08 18:47:59.000000000 +0200
@@ -79,21 +79,8 @@ struct bio {
 	 */
 	unsigned short		bi_phys_segments;
 
-	/* Number of segments after physical and DMA remapping
-	 * hardware coalescing is performed.
-	 */
-	unsigned short		bi_hw_segments;
-
 	unsigned int		bi_size;	/* residual I/O count */
 
-	/*
-	 * To keep track of the max hw size, we account for the
-	 * sizes of the first and last virtually mergeable segments
-	 * in this bio
-	 */
-	unsigned int		bi_hw_front_size;
-	unsigned int		bi_hw_back_size;
-
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
@@ -112,7 +99,7 @@ struct bio {
 #define BIO_UPTODATE	0	/* ok after I/O completion */
 #define BIO_RW_BLOCK	1	/* RW_AHEAD set, and read/write would block */
 #define BIO_EOF		2	/* out-out-bounds error */
-#define BIO_SEG_VALID	3	/* nr_hw_seg valid */
+#define BIO_SEG_VALID	3	/* bi_phys_segments valid */
 #define BIO_CLONED	4	/* doesn't own data */
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
@@ -292,7 +279,6 @@ extern void bio_free(struct bio *, struc
 extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
-extern int bio_hw_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone(struct bio *, gfp_t);
Index: linux-2.6.26-devel/include/linux/blkdev.h
===================================================================
--- linux-2.6.26-devel.orig/include/linux/blkdev.h	2008-08-08 18:46:29.000000000 +0200
+++ linux-2.6.26-devel/include/linux/blkdev.h	2008-08-08 18:47:59.000000000 +0200
@@ -195,13 +195,6 @@ struct request {
 	 */
 	unsigned short nr_phys_segments;
 
-	/* Number of scatter-gather addr+len pairs after
-	 * physical and DMA remapping hardware coalescing is performed.
-	 * This is the number of scatter-gather entries the driver
-	 * will actually have to deal with after DMA mapping is done.
-	 */
-	unsigned short nr_hw_segments;
-
 	unsigned short ioprio;
 
 	void *special;
Index: linux-2.6.26-devel/fs/bio.c
===================================================================
--- linux-2.6.26-devel.orig/fs/bio.c	2008-08-08 18:46:30.000000000 +0200
+++ linux-2.6.26-devel/fs/bio.c	2008-08-08 18:48:00.000000000 +0200
@@ -229,14 +229,6 @@ inline int bio_phys_segments(struct requ
 	return bio->bi_phys_segments;
 }
 
-inline int bio_hw_segments(struct request_queue *q, struct bio *bio)
-{
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, bio);
-
-	return bio->bi_hw_segments;
-}
-
 /**
  * 	__bio_clone	-	clone a bio
  * 	@bio: destination bio
@@ -352,7 +344,7 @@ static int __bio_add_page(struct request
 	 */
 
 	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_hw_segments >= q->max_hw_segments) {
+	       || bio->bi_phys_segments >= q->max_hw_segments) {
 
 		if (retried_segments)
 			return 0;
@@ -394,7 +386,6 @@ static int __bio_add_page(struct request
 
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;
-	bio->bi_hw_segments++;
  done:
 	bio->bi_size += len;
 	return len;
@@ -1387,7 +1378,6 @@ EXPORT_SYMBOL(bio_init);
 EXPORT_SYMBOL(__bio_clone);
 EXPORT_SYMBOL(bio_clone);
 EXPORT_SYMBOL(bio_phys_segments);
-EXPORT_SYMBOL(bio_hw_segments);
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
Index: linux-2.6.26-devel/drivers/md/raid1.c
===================================================================
--- linux-2.6.26-devel.orig/drivers/md/raid1.c	2008-08-08 19:01:55.000000000 +0200
+++ linux-2.6.26-devel/drivers/md/raid1.c	2008-08-08 19:04:10.000000000 +0200
@@ -1297,9 +1297,6 @@ static void sync_request_write(mddev_t *
 					sbio->bi_size = r1_bio->sectors << 9;
 					sbio->bi_idx = 0;
 					sbio->bi_phys_segments = 0;
-					sbio->bi_hw_segments = 0;
-					sbio->bi_hw_front_size = 0;
-					sbio->bi_hw_back_size = 0;
 					sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
 					sbio->bi_flags |= 1 << BIO_UPTODATE;
 					sbio->bi_next = NULL;
Index: linux-2.6.26-devel/drivers/md/raid10.c
===================================================================
--- linux-2.6.26-devel.orig/drivers/md/raid10.c	2008-08-08 19:01:58.000000000 +0200
+++ linux-2.6.26-devel/drivers/md/raid10.c	2008-08-08 19:04:19.000000000 +0200
@@ -1334,9 +1334,6 @@ static void sync_request_write(mddev_t *
 		tbio->bi_size = r10_bio->sectors << 9;
 		tbio->bi_idx = 0;
 		tbio->bi_phys_segments = 0;
-		tbio->bi_hw_segments = 0;
-		tbio->bi_hw_front_size = 0;
-		tbio->bi_hw_back_size = 0;
 		tbio->bi_flags &= ~(BIO_POOL_MASK - 1);
 		tbio->bi_flags |= 1 << BIO_UPTODATE;
 		tbio->bi_next = NULL;
