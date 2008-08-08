From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] drop vmerge accounting
Date: Fri, 8 Aug 2008 12:53:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
 <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
 <20080808063527.GJ20055@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYHHQzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 12:55:12 -0400
In-Reply-To: <20080808063527.GJ20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Fri, 8 Aug 2008, Jens Axboe wrote:

> On Fri, Aug 08 2008, FUJITA Tomonori wrote:
> > On Fri, 8 Aug 2008 08:15:37 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > > BTW, we also wait for your verdict on:
> > > > 
> > > > http://marc.info/?t=121611935500002&r=1&w=2
> > > 
> > > I've always hated the iommu virtual merging complexity. My plan is to
> > > rip it out.
> > 
> > No complaint from me. I'm just happy to see the verdict at length.
> 
> Mikulas, you had a patch for this. Can you strip out the arch bits and
> just send me the block bits? The arch bits should go in via the arch
> maintainers.
> 
> The iommu code may still do virtual merging, it would be silly not to do
> that if possible. Now that later kernels expose the necessary parameters
> at that level as well, it's perfectly feasible.

Here I'm sending the first one, it removes virtual merge accounting from 
blk-merge.c (it acts as if all architectures undefined 
BIO_VMERGE_BOUNDARY). I also created second patch that removes 
bi_hw_segments field from struct bio and struct request. The next task 
would be to remove nr_hw_segments from the request_queue, but it will 
require changing the drivers.

Mikulas

---

Remove virtual merge accounting.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-merge.c   |   76 ++++------------------------------------------------
 fs/bio.c            |    6 +---
 include/linux/bio.h |   15 ----------
 3 files changed, 8 insertions(+), 89 deletions(-)

Index: linux-2.6.26-devel/block/blk-merge.c
===================================================================
--- linux-2.6.26-devel.orig/block/blk-merge.c	2008-07-15 23:29:39.000000000 +0200
+++ linux-2.6.26-devel/block/blk-merge.c	2008-08-08 18:46:57.000000000 +0200
@@ -66,7 +66,7 @@ void blk_recalc_rq_segments(struct reque
 		 */
 		high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
 		if (high || highprv)
-			goto new_hw_segment;
+			goto new_segment;
 		if (cluster) {
 			if (seg_size + bv->bv_len > q->max_segment_size)
 				goto new_segment;
@@ -74,8 +74,6 @@ void blk_recalc_rq_segments(struct reque
 				goto new_segment;
 			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
 				goto new_segment;
-			if (BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
-				goto new_hw_segment;
 
 			seg_size += bv->bv_len;
 			hw_seg_size += bv->bv_len;
@@ -83,17 +81,11 @@ void blk_recalc_rq_segments(struct reque
 			continue;
 		}
 new_segment:
-		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
-		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
-			hw_seg_size += bv->bv_len;
-		else {
-new_hw_segment:
-			if (nr_hw_segs == 1 &&
-			    hw_seg_size > rq->bio->bi_hw_front_size)
-				rq->bio->bi_hw_front_size = hw_seg_size;
-			hw_seg_size = BIOVEC_VIRT_START_SIZE(bv) + bv->bv_len;
-			nr_hw_segs++;
-		}
+		if (nr_hw_segs == 1 &&
+		    hw_seg_size > rq->bio->bi_hw_front_size)
+			rq->bio->bi_hw_front_size = hw_seg_size;
+		hw_seg_size = bv->bv_len;
+		nr_hw_segs++;
 
 		nr_phys_segs++;
 		bvprv = bv;
@@ -146,22 +138,6 @@ static int blk_phys_contig_segment(struc
 	return 0;
 }
 
-static int blk_hw_contig_segment(struct request_queue *q, struct bio *bio,
-				 struct bio *nxt)
-{
-	if (!bio_flagged(bio, BIO_SEG_VALID))
-		blk_recount_segments(q, bio);
-	if (!bio_flagged(nxt, BIO_SEG_VALID))
-		blk_recount_segments(q, nxt);
-	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)) ||
-	    BIOVEC_VIRT_OVERSIZE(bio->bi_hw_back_size + nxt->bi_hw_front_size))
-		return 0;
-	if (bio->bi_hw_back_size + nxt->bi_hw_front_size > q->max_segment_size)
-		return 0;
-
-	return 1;
-}
-
 /*
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
@@ -299,7 +275,6 @@ int ll_back_merge_fn(struct request_queu
 		     struct bio *bio)
 {
 	unsigned short max_sectors;
-	int len;
 
 	if (unlikely(blk_pc_request(req)))
 		max_sectors = q->max_hw_sectors;
@@ -316,19 +291,6 @@ int ll_back_merge_fn(struct request_queu
 		blk_recount_segments(q, req->biotail);
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
-	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))
-	    && !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
-
-		if (mergeable) {
-			if (req->nr_hw_segments == 1)
-				req->bio->bi_hw_front_size = len;
-			if (bio->bi_hw_segments == 1)
-				bio->bi_hw_back_size = len;
-		}
-		return mergeable;
-	}
 
 	return ll_new_hw_segment(q, req, bio);
 }
@@ -337,7 +299,6 @@ int ll_front_merge_fn(struct request_que
 		      struct bio *bio)
 {
 	unsigned short max_sectors;
-	int len;
 
 	if (unlikely(blk_pc_request(req)))
 		max_sectors = q->max_hw_sectors;
@@ -351,23 +312,10 @@ int ll_front_merge_fn(struct request_que
 			q->last_merge = NULL;
 		return 0;
 	}
-	len = bio->bi_hw_back_size + req->bio->bi_hw_front_size;
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
 	if (!bio_flagged(req->bio, BIO_SEG_VALID))
 		blk_recount_segments(q, req->bio);
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(req->bio)) &&
-	    !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
-
-		if (mergeable) {
-			if (bio->bi_hw_segments == 1)
-				bio->bi_hw_front_size = len;
-			if (req->nr_hw_segments == 1)
-				req->biotail->bi_hw_back_size = len;
-		}
-		return mergeable;
-	}
 
 	return ll_new_hw_segment(q, req, bio);
 }
@@ -399,18 +347,6 @@ static int ll_merge_requests_fn(struct r
 		return 0;
 
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
-	if (blk_hw_contig_segment(q, req->biotail, next->bio)) {
-		int len = req->biotail->bi_hw_back_size +
-				next->bio->bi_hw_front_size;
-		/*
-		 * propagate the combined length to the end of the requests
-		 */
-		if (req->nr_hw_segments == 1)
-			req->bio->bi_hw_front_size = len;
-		if (next->nr_hw_segments == 1)
-			next->biotail->bi_hw_back_size = len;
-		total_hw_segments--;
-	}
 
 	if (total_hw_segments > q->max_hw_segments)
 		return 0;
Index: linux-2.6.26-devel/include/linux/bio.h
===================================================================
--- linux-2.6.26-devel.orig/include/linux/bio.h	2008-07-15 23:29:39.000000000 +0200
+++ linux-2.6.26-devel/include/linux/bio.h	2008-08-08 18:46:29.000000000 +0200
@@ -26,21 +26,8 @@
 
 #ifdef CONFIG_BLOCK
 
-/* Platforms may set this to teach the BIO layer about IOMMU hardware. */
 #include <asm/io.h>
 
-#if defined(BIO_VMERGE_MAX_SIZE) && defined(BIO_VMERGE_BOUNDARY)
-#define BIOVEC_VIRT_START_SIZE(x) (bvec_to_phys(x) & (BIO_VMERGE_BOUNDARY - 1))
-#define BIOVEC_VIRT_OVERSIZE(x)	((x) > BIO_VMERGE_MAX_SIZE)
-#else
-#define BIOVEC_VIRT_START_SIZE(x)	0
-#define BIOVEC_VIRT_OVERSIZE(x)		0
-#endif
-
-#ifndef BIO_VMERGE_BOUNDARY
-#define BIO_VMERGE_BOUNDARY	0
-#endif
-
 #define BIO_DEBUG
 
 #ifdef BIO_DEBUG
@@ -235,8 +222,6 @@ static inline void *bio_data(struct bio 
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
 #endif
 
-#define BIOVEC_VIRT_MERGEABLE(vec1, vec2)	\
-	((((bvec_to_phys((vec1)) + (vec1)->bv_len) | bvec_to_phys((vec2))) & (BIO_VMERGE_BOUNDARY - 1)) == 0)
 #define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
Index: linux-2.6.26-devel/fs/bio.c
===================================================================
--- linux-2.6.26-devel.orig/fs/bio.c	2008-07-15 23:29:39.000000000 +0200
+++ linux-2.6.26-devel/fs/bio.c	2008-08-08 18:46:30.000000000 +0200
@@ -352,8 +352,7 @@ static int __bio_add_page(struct request
 	 */
 
 	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_hw_segments >= q->max_hw_segments
-	       || BIOVEC_VIRT_OVERSIZE(bio->bi_size)) {
+	       || bio->bi_hw_segments >= q->max_hw_segments) {
 
 		if (retried_segments)
 			return 0;
@@ -390,8 +389,7 @@ static int __bio_add_page(struct request
 	}
 
 	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec) ||
-	    BIOVEC_VIRT_MERGEABLE(bvec-1, bvec)))
+	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	bio->bi_vcnt++;
