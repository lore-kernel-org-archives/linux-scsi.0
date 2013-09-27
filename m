From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v4 Repost 1/2] block: factor out vector mergeable decision
 to a, helper function
Date: Fri, 27 Sep 2013 14:23:49 +0200
Message-ID: <524578D5.1030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3I0MYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Sep 2013 08:24:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, james.bottomley@hansenpartnership.com, Jens Axboe <axboe@kernel.dk>, koverstreet@google.com, Kai.Makisara@kolumbus.fi, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

From: Jan Vesely <jvesely@redhat.com>

Export the function so it can be used to predict segment counts
without calling the recalc function. This will be used in the next
patch.

Signed-off-by: Jan Vesely <jvesely@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 block/blk-merge.c   | 52 +++++++++++++++++++++++++++++++---------------------
 include/linux/bio.h |  3 +++
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5f24482..f1ef657 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,11 +9,39 @@
 
 #include "blk.h"
 
+bool bvec_mergeable(struct request_queue *q, struct bio_vec *lastbv,
+		    struct bio_vec *newbv, unsigned int seg_size)
+{
+	unsigned long limit = queue_bounce_pfn(q);
+
+	if (!blk_queue_cluster(q))
+		return false;
+
+	/*
+	 * the trick here is to make sure that a high page is
+	 * never considered part of another segment, since that
+	 * might change with the bounce page.
+	 */
+	if ((page_to_pfn(lastbv->bv_page) > limit)
+	    || (page_to_pfn(newbv->bv_page) > limit))
+		return false;
+
+	if (seg_size + newbv->bv_len > queue_max_segment_size(q))
+		return false;
+
+	if (!BIOVEC_PHYS_MERGEABLE(lastbv, newbv))
+		return false;
+	if (!BIOVEC_SEG_BOUNDARY(q, lastbv, newbv))
+		return false;
+	return true;
+}
+
+
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
 	struct bio_vec *bv, *bvprv = NULL;
-	int cluster, i, high, highprv = 1;
+	int i;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
 
@@ -21,33 +49,16 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 		return 0;
 
 	fbio = bio;
-	cluster = blk_queue_cluster(q);
 	seg_size = 0;
 	nr_phys_segs = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, i) {
-			/*
-			 * the trick here is making sure that a high page is
-			 * never considered part of another segment, since that
-			 * might change with the bounce page.
-			 */
-			high = page_to_pfn(bv->bv_page) > queue_bounce_pfn(q);
-			if (high || highprv)
-				goto new_segment;
-			if (cluster) {
-				if (seg_size + bv->bv_len
-				    > queue_max_segment_size(q))
-					goto new_segment;
-				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
-					goto new_segment;
-				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
-					goto new_segment;
-
+			if (bvprv && bvec_mergeable(q, bvprv, bv, seg_size)) {
 				seg_size += bv->bv_len;
 				bvprv = bv;
 				continue;
 			}
-new_segment:
+			/* new segment */
 			if (nr_phys_segs == 1 && seg_size >
 			    fbio->bi_seg_front_size)
 				fbio->bi_seg_front_size = seg_size;
@@ -55,7 +66,6 @@ new_segment:
 			nr_phys_segs++;
 			bvprv = bv;
 			seg_size = bv->bv_len;
-			highprv = high;
 		}
 		bbio = bio;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ec48bac..929ac53 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -307,6 +307,9 @@ extern struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
 extern void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
+extern bool bvec_mergeable(struct request_queue *q, struct bio_vec *lastbv,
+			   struct bio_vec *newbv, unsigned int seg_size);
+
 #ifdef CONFIG_BLK_CGROUP
 int bio_associate_current(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
-- 
1.8.3.1


