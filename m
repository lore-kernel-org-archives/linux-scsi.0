Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E100C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiB0RXE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiB0RXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:23:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C84E6D3AD;
        Sun, 27 Feb 2022 09:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nUJaN2Wch8/DNzM0cGbUFr1WaFdcbcmF2Uj5fjnFr+w=; b=1PtGrKxRewvY9cRbmhcSd3EBrs
        UCTUqu6xttDuGvybwLgrZT4HDF9ulEXZv4i0FiTGjonSWZuPVXnBvd94AFm/AqLhDyBQQXRdU46W3
        4AeH9IV+r1oNsNktwHieFv1NeLd02Oc6RlNUFJaQgZ2z2qssIQM/h6Ib0g6HUW/+CnTt5ltXPUcGl
        XpERX2yvRey6gFRrPKvrTWlgMskI9RxfyEByNDHflpLeXy+kM8FxgCF1W0CtW+tfQ7QHw4WtojKGv
        SXOSjAc2F04VbxE51ZgII/u7UKS2OBJkiRgcjPgwAeXkJr5e171zHVZdXRaF2QBARHaZEiEew/3oI
        ccL2OPvg==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONFM-009s3E-Ux; Sun, 27 Feb 2022 17:22:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 09/14] block: move blkcg initialization/destroy into disk allocation/release handler
Date:   Sun, 27 Feb 2022 18:21:39 +0100
Message-Id: <20220227172144.508118-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
References: <20220227172144.508118-1-hch@lst.de>
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
index 4c6b7dff71e5b..5f723d2ff8948 100644
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
index d89c35d5f2432..3249d4206f312 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1122,9 +1122,12 @@ static void disk_release(struct device *dev)
 
 	blk_mq_cancel_work_sync(disk->queue);
 
+	blkcg_exit_queue(disk->queue);
+
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
+
 	disk->queue->disk = NULL;
 	blk_put_queue(disk->queue);
 
@@ -1330,6 +1333,9 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
+	if (blkcg_init_queue(q))
+		goto out_erase_part0;
+
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
@@ -1342,6 +1348,8 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 #endif
 	return disk;
 
+out_erase_part0:
+	xa_erase(&disk->part_tbl, 0);
 out_destroy_part_tbl:
 	xa_destroy(&disk->part_tbl);
 	disk->part0->bd_disk = NULL;
-- 
2.30.2

