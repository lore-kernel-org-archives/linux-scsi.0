Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684F6C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbiCDQFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240574AbiCDQE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:04:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4709A1B0C51;
        Fri,  4 Mar 2022 08:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=42H601cOwvwAo/A7Sr0BwCGR0gh7uZFGJO/rSSY9fl0=; b=u1H9iL2CqcgPDhaUTHh+p9vGUG
        p4zlZlZwCR0MQlI51cvjZE4YCvSTM1YtynX6qdlYxndq6A+J9RhaAl/4d1em5LYaHjaMn18tIMqmE
        CvVsUz7i3b3BfiJRjdE04UzjWnsJOYNAZSztECt0AP7Nf5k8mfFuAC2Aqdn2FbjLXRXokYdV0zV1K
        zTHpV1kGegKYuH8EPwVck44Y5X3Bt7OrYXseOIlQvg7uFEHZZMN43XAr0BQJRsRt+dLpHbfIR2S1+
        1r5Y1wwIFGbbBhbmEz6k8QwiTPOCHqNqLHKvltmHtclVrIbs3M3s2XhcK7R3KhINXTp4koehYBKkA
        tYKVQyfw==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAPS-00Au5K-TK; Fri, 04 Mar 2022 16:04:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 09/14] block: move blkcg initialization/destroy into disk allocation/release handler
Date:   Fri,  4 Mar 2022 17:03:26 +0100
Message-Id: <20220304160331.399757-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304160331.399757-1-hch@lst.de>
References: <20220304160331.399757-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

blkcg works on FS bio level, so it is reasonable to make both blkcg and
gendisk sharing same lifetime. Meantime there won't be any FS IO when
releasing disk, so safe to move blkcg initialization/destroy into disk
allocation/release handler

Long term, we can move blkcg into gendisk completely.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c  | 5 -----
 block/blk-sysfs.c | 7 -------
 block/genhd.c     | 8 ++++++++
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 94bf37f8e61d2..b2f2c65774812 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -496,17 +496,12 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
 		goto fail_stats;
 
-	if (blkcg_init_queue(q))
-		goto fail_ref;
-
 	blk_queue_dma_alignment(q, 511);
 	blk_set_default_limits(&q->limits);
 	q->nr_requests = BLKDEV_DEFAULT_RQ;
 
 	return q;
 
-fail_ref:
-	percpu_ref_exit(&q->q_usage_counter);
 fail_stats:
 	blk_free_queue_stats(q->stats);
 fail_split:
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 241ded62f458f..220085109d7f0 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -751,13 +751,6 @@ static void blk_exit_queue(struct request_queue *q)
 		ioc_clear_queue(q);
 		elevator_exit(q);
 	}
-
-	/*
-	 * Remove all references to @q from the block cgroup controller before
-	 * restoring @q->queue_lock to avoid that restoring this pointer causes
-	 * e.g. blkcg_print_blkgs() to crash.
-	 */
-	blkcg_exit_queue(q);
 }
 
 /**
diff --git a/block/genhd.c b/block/genhd.c
index 54f60ded2ee6f..073e93f2fc40b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1120,9 +1120,12 @@ static void disk_release(struct device *dev)
 
 	blk_mq_cancel_work_sync(disk->queue);
 
+	blkcg_exit_queue(disk->queue);
+
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
+
 	disk->queue->disk = NULL;
 	blk_put_queue(disk->queue);
 
@@ -1328,6 +1331,9 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
+	if (blkcg_init_queue(q))
+		goto out_erase_part0;
+
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
@@ -1340,6 +1346,8 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 #endif
 	return disk;
 
+out_erase_part0:
+	xa_erase(&disk->part_tbl, 0);
 out_destroy_part_tbl:
 	xa_destroy(&disk->part_tbl);
 	disk->part0->bd_disk = NULL;
-- 
2.30.2

