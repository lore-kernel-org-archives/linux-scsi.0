From: Jan Vesely <jvesely@redhat.com>
Subject: [PATCH v4 1/2] block: factor out vector mergeable decision to a helper function
Date: Fri, 12 Jul 2013 17:52:22 +0200
Message-ID: <1373644343-6671-2-git-send-email-jvesely@redhat.com>
References: <1373644343-6671-1-git-send-email-jvesely@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab3GLPwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 11:52:50 -0400
In-Reply-To: <1373644343-6671-1-git-send-email-jvesely@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Rob Evers <revers@redhat.com>, Tomas Henzl <thenzl@redhat.com>, Nikola Pajkovsky <npajkovs@redhat.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Don Howard <dhoward@redhat.com>

From: Jan Vesely <jvesely@redhat.com>

Export the function so it can be used to predict segment counts
without calling the recalc function. This will be used in the next
patch.

Signed-off-by: Jan Vesely <jvesely@redhat.com>

CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Kent Overstreet <koverstreet@google.com>
CC: Rob Evers <revers@redhat.com>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Nikola Pajkovsky <npajkovs@redhat.com>
CC: Kai Makisara <Kai.Makisara@kolumbus.fi>
CC: linux-scsi@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
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
index ef24466..3af0e36 100644
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

