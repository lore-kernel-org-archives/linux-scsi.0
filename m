Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69239C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432D363238
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhKQGRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5A6C061570;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=IsPROaCipz2qEku5ZBq0gX9TFxSFlAzEARfEL6H87tY=; b=hhYVowLzafOFv5t8eJzlg+BWuG
        7VqE2d7aQNFqOCv47qhVva5144E4Duy490/C228lJgN1rLca6VTjCB54NXPDq1WnfwV0yG57QJ0Sx
        vCHKN+kKmsR0BCgDY2QbS3ZnfIBWngdsNy3Z2g2rNCI6bo5D0Ec245umktpl5gEfmG3uTqniZyHJf
        OmlFVNkrP/TMK3C1SpEcPNvFj8UkP9gC+QnzR7urnoBi9aualtXssYTpXONtWpI5/vsnL0y6FZbUh
        iJmNlJjKtcxw/w6zmOKbHsxm+e69KAg4omH8SHc8SL85NjWqcUZece0yqapXXnZCX2pTjomRT82Xt
        KUYGz10Q==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnECz-007MF5-Dm; Wed, 17 Nov 2021 06:14:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 05/11] block: move request based cloning helpers to blk-mq.c
Date:   Wed, 17 Nov 2021 07:13:58 +0100
Message-Id: <20211117061404.331732-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Keep all the request based code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 184 +----------------------------------------------
 block/blk-mq.c   | 175 +++++++++++++++++++++++++++++++++++++++++++-
 block/blk-mq.h   |   3 -
 block/blk.h      |  10 +++
 4 files changed, 185 insertions(+), 187 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f1ca31a89493a..e1c928ec92946 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -592,7 +592,7 @@ static int __init setup_fail_make_request(char *str)
 }
 __setup("fail_make_request=", setup_fail_make_request);
 
-static bool should_fail_request(struct block_device *part, unsigned int bytes)
+bool should_fail_request(struct block_device *part, unsigned int bytes)
 {
 	return part->bd_make_it_fail && should_fail(&fail_make_request, bytes);
 }
@@ -606,15 +606,6 @@ static int __init fail_make_request_debugfs(void)
 }
 
 late_initcall(fail_make_request_debugfs);
-
-#else /* CONFIG_FAIL_MAKE_REQUEST */
-
-static inline bool should_fail_request(struct block_device *part,
-					unsigned int bytes)
-{
-	return false;
-}
-
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
 static inline bool bio_check_ro(struct bio *bio)
@@ -1087,92 +1078,6 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 }
 EXPORT_SYMBOL_GPL(iocb_bio_iopoll);
 
-/**
- * blk_cloned_rq_check_limits - Helper function to check a cloned request
- *                              for the new queue limits
- * @q:  the queue
- * @rq: the request being checked
- *
- * Description:
- *    @rq may have been made based on weaker limitations of upper-level queues
- *    in request stacking drivers, and it may violate the limitation of @q.
- *    Since the block layer and the underlying device driver trust @rq
- *    after it is inserted to @q, it should be checked against @q before
- *    the insertion using this generic function.
- *
- *    Request stacking drivers like request-based dm may change the queue
- *    limits when retrying requests on other queues. Those requests need
- *    to be checked against the new queue limits again during dispatch.
- */
-static blk_status_t blk_cloned_rq_check_limits(struct request_queue *q,
-				      struct request *rq)
-{
-	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
-
-	if (blk_rq_sectors(rq) > max_sectors) {
-		/*
-		 * SCSI device does not have a good way to return if
-		 * Write Same/Zero is actually supported. If a device rejects
-		 * a non-read/write command (discard, write same,etc.) the
-		 * low-level device driver will set the relevant queue limit to
-		 * 0 to prevent blk-lib from issuing more of the offending
-		 * operations. Commands queued prior to the queue limit being
-		 * reset need to be completed with BLK_STS_NOTSUPP to avoid I/O
-		 * errors being propagated to upper layers.
-		 */
-		if (max_sectors == 0)
-			return BLK_STS_NOTSUPP;
-
-		printk(KERN_ERR "%s: over max size limit. (%u > %u)\n",
-			__func__, blk_rq_sectors(rq), max_sectors);
-		return BLK_STS_IOERR;
-	}
-
-	/*
-	 * The queue settings related to segment counting may differ from the
-	 * original queue.
-	 */
-	rq->nr_phys_segments = blk_recalc_rq_segments(rq);
-	if (rq->nr_phys_segments > queue_max_segments(q)) {
-		printk(KERN_ERR "%s: over max segments limit. (%hu > %hu)\n",
-			__func__, rq->nr_phys_segments, queue_max_segments(q));
-		return BLK_STS_IOERR;
-	}
-
-	return BLK_STS_OK;
-}
-
-/**
- * blk_insert_cloned_request - Helper for stacking drivers to submit a request
- * @q:  the queue to submit the request
- * @rq: the request being queued
- */
-blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *rq)
-{
-	blk_status_t ret;
-
-	ret = blk_cloned_rq_check_limits(q, rq);
-	if (ret != BLK_STS_OK)
-		return ret;
-
-	if (rq->rq_disk &&
-	    should_fail_request(rq->rq_disk->part0, blk_rq_bytes(rq)))
-		return BLK_STS_IOERR;
-
-	if (blk_crypto_insert_cloned_request(rq))
-		return BLK_STS_IOERR;
-
-	blk_account_io_start(rq);
-
-	/*
-	 * Since we have a scheduler attached on the top device,
-	 * bypass a potential scheduler on the bottom device for
-	 * insert.
-	 */
-	return blk_mq_request_issue_directly(rq, true);
-}
-EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
-
 static void update_io_ticks(struct block_device *part, unsigned long now,
 		bool end)
 {
@@ -1325,93 +1230,6 @@ int blk_lld_busy(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_lld_busy);
 
-/**
- * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
- * @rq: the clone request to be cleaned up
- *
- * Description:
- *     Free all bios in @rq for a cloned request.
- */
-void blk_rq_unprep_clone(struct request *rq)
-{
-	struct bio *bio;
-
-	while ((bio = rq->bio) != NULL) {
-		rq->bio = bio->bi_next;
-
-		bio_put(bio);
-	}
-}
-EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
-
-/**
- * blk_rq_prep_clone - Helper function to setup clone request
- * @rq: the request to be setup
- * @rq_src: original request to be cloned
- * @bs: bio_set that bios for clone are allocated from
- * @gfp_mask: memory allocation mask for bio
- * @bio_ctr: setup function to be called for each clone bio.
- *           Returns %0 for success, non %0 for failure.
- * @data: private data to be passed to @bio_ctr
- *
- * Description:
- *     Clones bios in @rq_src to @rq, and copies attributes of @rq_src to @rq.
- *     Also, pages which the original bios are pointing to are not copied
- *     and the cloned bios just point same pages.
- *     So cloned bios must be completed before original bios, which means
- *     the caller must complete @rq before @rq_src.
- */
-int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
-		      struct bio_set *bs, gfp_t gfp_mask,
-		      int (*bio_ctr)(struct bio *, struct bio *, void *),
-		      void *data)
-{
-	struct bio *bio, *bio_src;
-
-	if (!bs)
-		bs = &fs_bio_set;
-
-	__rq_for_each_bio(bio_src, rq_src) {
-		bio = bio_clone_fast(bio_src, gfp_mask, bs);
-		if (!bio)
-			goto free_and_out;
-
-		if (bio_ctr && bio_ctr(bio, bio_src, data))
-			goto free_and_out;
-
-		if (rq->bio) {
-			rq->biotail->bi_next = bio;
-			rq->biotail = bio;
-		} else {
-			rq->bio = rq->biotail = bio;
-		}
-		bio = NULL;
-	}
-
-	/* Copy attributes of the original request to the clone request. */
-	rq->__sector = blk_rq_pos(rq_src);
-	rq->__data_len = blk_rq_bytes(rq_src);
-	if (rq_src->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
-		rq->special_vec = rq_src->special_vec;
-	}
-	rq->nr_phys_segments = rq_src->nr_phys_segments;
-	rq->ioprio = rq_src->ioprio;
-
-	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
-		goto free_and_out;
-
-	return 0;
-
-free_and_out:
-	if (bio)
-		bio_put(bio);
-	blk_rq_unprep_clone(rq);
-
-	return -ENOMEM;
-}
-EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
-
 int kblockd_schedule_work(struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d70a470c9c1f1..0362ec9ad4d14 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2434,7 +2434,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	hctx_unlock(hctx, srcu_idx);
 }
 
-blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
+static blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
 {
 	blk_status_t ret;
 	int srcu_idx;
@@ -2821,6 +2821,179 @@ void blk_mq_submit_bio(struct bio *bio)
 	}
 }
 
+/**
+ * blk_cloned_rq_check_limits - Helper function to check a cloned request
+ *                              for the new queue limits
+ * @q:  the queue
+ * @rq: the request being checked
+ *
+ * Description:
+ *    @rq may have been made based on weaker limitations of upper-level queues
+ *    in request stacking drivers, and it may violate the limitation of @q.
+ *    Since the block layer and the underlying device driver trust @rq
+ *    after it is inserted to @q, it should be checked against @q before
+ *    the insertion using this generic function.
+ *
+ *    Request stacking drivers like request-based dm may change the queue
+ *    limits when retrying requests on other queues. Those requests need
+ *    to be checked against the new queue limits again during dispatch.
+ */
+static blk_status_t blk_cloned_rq_check_limits(struct request_queue *q,
+				      struct request *rq)
+{
+	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+
+	if (blk_rq_sectors(rq) > max_sectors) {
+		/*
+		 * SCSI device does not have a good way to return if
+		 * Write Same/Zero is actually supported. If a device rejects
+		 * a non-read/write command (discard, write same,etc.) the
+		 * low-level device driver will set the relevant queue limit to
+		 * 0 to prevent blk-lib from issuing more of the offending
+		 * operations. Commands queued prior to the queue limit being
+		 * reset need to be completed with BLK_STS_NOTSUPP to avoid I/O
+		 * errors being propagated to upper layers.
+		 */
+		if (max_sectors == 0)
+			return BLK_STS_NOTSUPP;
+
+		printk(KERN_ERR "%s: over max size limit. (%u > %u)\n",
+			__func__, blk_rq_sectors(rq), max_sectors);
+		return BLK_STS_IOERR;
+	}
+
+	/*
+	 * The queue settings related to segment counting may differ from the
+	 * original queue.
+	 */
+	rq->nr_phys_segments = blk_recalc_rq_segments(rq);
+	if (rq->nr_phys_segments > queue_max_segments(q)) {
+		printk(KERN_ERR "%s: over max segments limit. (%hu > %hu)\n",
+			__func__, rq->nr_phys_segments, queue_max_segments(q));
+		return BLK_STS_IOERR;
+	}
+
+	return BLK_STS_OK;
+}
+
+/**
+ * blk_insert_cloned_request - Helper for stacking drivers to submit a request
+ * @q:  the queue to submit the request
+ * @rq: the request being queued
+ */
+blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *rq)
+{
+	blk_status_t ret;
+
+	ret = blk_cloned_rq_check_limits(q, rq);
+	if (ret != BLK_STS_OK)
+		return ret;
+
+	if (rq->rq_disk &&
+	    should_fail_request(rq->rq_disk->part0, blk_rq_bytes(rq)))
+		return BLK_STS_IOERR;
+
+	if (blk_crypto_insert_cloned_request(rq))
+		return BLK_STS_IOERR;
+
+	blk_account_io_start(rq);
+
+	/*
+	 * Since we have a scheduler attached on the top device,
+	 * bypass a potential scheduler on the bottom device for
+	 * insert.
+	 */
+	return blk_mq_request_issue_directly(rq, true);
+}
+EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
+
+/**
+ * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
+ * @rq: the clone request to be cleaned up
+ *
+ * Description:
+ *     Free all bios in @rq for a cloned request.
+ */
+void blk_rq_unprep_clone(struct request *rq)
+{
+	struct bio *bio;
+
+	while ((bio = rq->bio) != NULL) {
+		rq->bio = bio->bi_next;
+
+		bio_put(bio);
+	}
+}
+EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
+
+/**
+ * blk_rq_prep_clone - Helper function to setup clone request
+ * @rq: the request to be setup
+ * @rq_src: original request to be cloned
+ * @bs: bio_set that bios for clone are allocated from
+ * @gfp_mask: memory allocation mask for bio
+ * @bio_ctr: setup function to be called for each clone bio.
+ *           Returns %0 for success, non %0 for failure.
+ * @data: private data to be passed to @bio_ctr
+ *
+ * Description:
+ *     Clones bios in @rq_src to @rq, and copies attributes of @rq_src to @rq.
+ *     Also, pages which the original bios are pointing to are not copied
+ *     and the cloned bios just point same pages.
+ *     So cloned bios must be completed before original bios, which means
+ *     the caller must complete @rq before @rq_src.
+ */
+int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
+		      struct bio_set *bs, gfp_t gfp_mask,
+		      int (*bio_ctr)(struct bio *, struct bio *, void *),
+		      void *data)
+{
+	struct bio *bio, *bio_src;
+
+	if (!bs)
+		bs = &fs_bio_set;
+
+	__rq_for_each_bio(bio_src, rq_src) {
+		bio = bio_clone_fast(bio_src, gfp_mask, bs);
+		if (!bio)
+			goto free_and_out;
+
+		if (bio_ctr && bio_ctr(bio, bio_src, data))
+			goto free_and_out;
+
+		if (rq->bio) {
+			rq->biotail->bi_next = bio;
+			rq->biotail = bio;
+		} else {
+			rq->bio = rq->biotail = bio;
+		}
+		bio = NULL;
+	}
+
+	/* Copy attributes of the original request to the clone request. */
+	rq->__sector = blk_rq_pos(rq_src);
+	rq->__data_len = blk_rq_bytes(rq_src);
+	if (rq_src->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
+		rq->special_vec = rq_src->special_vec;
+	}
+	rq->nr_phys_segments = rq_src->nr_phys_segments;
+	rq->ioprio = rq_src->ioprio;
+
+	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
+		goto free_and_out;
+
+	return 0;
+
+free_and_out:
+	if (bio)
+		bio_put(bio);
+	blk_rq_unprep_clone(rq);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
+
 static size_t order_to_size(unsigned int order)
 {
 	return (size_t)PAGE_SIZE << order;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 8acfa650f5751..f39454456c064 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -65,9 +65,6 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
 				  bool run_queue);
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 				struct list_head *list);
-
-/* Used by blk_insert_cloned_request() to issue request directly */
-blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last);
 void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 				    struct list_head *list);
 
diff --git a/block/blk.h b/block/blk.h
index b4fed2033e48f..1bac4063afffb 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -493,4 +493,14 @@ int disk_register_independent_access_ranges(struct gendisk *disk,
 				struct blk_independent_access_ranges *new_iars);
 void disk_unregister_independent_access_ranges(struct gendisk *disk);
 
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+bool should_fail_request(struct block_device *part, unsigned int bytes);
+#else /* CONFIG_FAIL_MAKE_REQUEST */
+static inline bool should_fail_request(struct block_device *part,
+					unsigned int bytes)
+{
+	return false;
+}
+#endif /* CONFIG_FAIL_MAKE_REQUEST */
+
 #endif /* BLK_INTERNAL_H */
-- 
2.30.2

