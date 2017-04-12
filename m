From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] block: use bio_has_data to check if a bio has bvecs
Date: Wed, 12 Apr 2017 10:48:09 +0200
Message-ID: <20170412084809.8245-9-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753698AbdDLIsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 04:48:43 -0400
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com

Now that Write Same is gone and discard bios never have a payload we
can simply use bio_has_data as an indicator that the bio has bvecs
that need to be handled.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         |  8 +-------
 block/blk-merge.c   |  9 +--------
 include/linux/bio.h | 21 +++++----------------
 3 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b310e7ef3fbf..1c9f04c30ba9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -679,15 +679,9 @@ static struct bio *__bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		break;
-	default:
+	if (bio_has_data(bio)) {
 		__bio_for_each_segment(bv, bio_src, iter, iter_src)
 			bio->bi_io_vec[bio->bi_vcnt++] = bv;
-		break;
 	}
 
 	if (bio_integrity(bio_src)) {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index d6c86bfc5722..549d060097f1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -232,16 +232,9 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
 
-	if (!bio)
+	if (!bio || !bio_has_data(bio))
 		return 0;
 
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		return 0;
-	}
-
 	fbio = bio;
 	cluster = blk_queue_cluster(q);
 	seg_size = 0;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7a24a1a24967..86bf531f97aa 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -178,26 +178,15 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 static inline unsigned __bio_segments(struct bio *bio, struct bvec_iter *bvec)
 {
 	unsigned segs = 0;
-	struct bio_vec bv;
-	struct bvec_iter iter;
 
-	/*
-	 * We special case discard/write same/write zeroes, because they
-	 * interpret bi_size differently:
-	 */
+	if (bio_has_data(bio)) {
+		struct bio_vec bv;
+		struct bvec_iter iter;
 
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		return 0;
-	default:
-		break;
+		__bio_for_each_segment(bv, bio, iter, *bvec)
+			segs++;
 	}
 
-	__bio_for_each_segment(bv, bio, iter, *bvec)
-		segs++;
-
 	return segs;
 }
 
-- 
2.11.0
