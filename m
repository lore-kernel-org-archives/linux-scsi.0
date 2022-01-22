Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFCAC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiAVLMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234157AbiAVLMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IhzZxghKLjv/eAyw20BiM/yJyRuvLKKix2OV+q1Q9hY=;
        b=LkLEgDOMDETXazdrP9H1K6l4TISL8fRJ/2D0VC23mH8I6tQHnTi/CLd1/GvlNuRzFnQWk/
        UZN6XcFASdKt8vAa93YxvDqAU+wtM4xF5lsgpzlrgTUTg82S79x2V74lqSYZTUweb0BJfo
        X+xjAcsz4pSRsVOpvSElDcRJQiDRyy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-VdJ4s97LPuO7HEw3K5CcjQ-1; Sat, 22 Jan 2022 06:11:56 -0500
X-MC-Unique: VdJ4s97LPuO7HEw3K5CcjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B58BD1083F60;
        Sat, 22 Jan 2022 11:11:54 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03059108BD2C;
        Sat, 22 Jan 2022 11:11:50 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 03/13] block: move blkcg initialization/destroy into disk allocation/release handler
Date:   Sat, 22 Jan 2022 19:10:44 +0800
Message-Id: <20220122111054.1126146-4-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blkcg works on FS bio level, so it is reasonable to make both blkcg and
gendisk sharing same lifetime. Meantime there won't be any FS IO when
releasing disk, so safe to move blkcg initialization/destroy into disk
allocation/release handler

Long term, we can move blkcg into gendisk completely.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c  |  5 -----
 block/blk-sysfs.c |  7 -------
 block/genhd.c     | 14 ++++++++++++++
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a400fa8cabd..d9477191b303 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -495,17 +495,12 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
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
index e20eadfcf5c8..6f326b44fb00 100644
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
index 626c8406f21a..b9b0db168ce1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1112,6 +1112,14 @@ static void disk_release(struct device *dev)
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
+
+	/*
+	 * Remove all references to @q from the block cgroup controller before
+	 * restoring @q->queue_lock to avoid that restoring this pointer causes
+	 * e.g. blkcg_print_blkgs() to crash.
+	 */
+	blkcg_exit_queue(disk->queue);
+
 	disk->queue->disk = NULL;
 	blk_put_queue(disk->queue);
 	iput(disk->part0->bd_inode);	/* frees the disk */
@@ -1308,6 +1316,10 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
+	/* todo: move blkcg into gendisk */
+	if (blkcg_init_queue(q))
+		goto out_erase_part0;
+
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
@@ -1320,6 +1332,8 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 #endif
 	return disk;
 
+out_erase_part0:
+	xa_erase(&disk->part_tbl, 0);
 out_destroy_part_tbl:
 	xa_destroy(&disk->part_tbl);
 	disk->part0->bd_disk = NULL;
-- 
2.31.1

