Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D64EC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiBVOPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiBVOPr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:15:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAD1160419;
        Tue, 22 Feb 2022 06:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lQCATnTSQh7gT8jhpdzuMWGhBlC8Fzy0Gq37ojUngpo=; b=PYL4ZOp/Gane//aKKJ+YnqqPSo
        ZjpNTkZw35nyBMlz3DDEptfsw2fQis8McKbCj39q/uri5blFPnwR9UhQAE1USOziI2uc4dIebopj9
        v7YETxCLnNKmW5uwdgBZzsR0DB3jEjHbybWN5VUHe6VHYaZnAlT9+3rIQDS3WskRblOpWjTbeQZ+t
        6KJHPxlMlDP+vuhwZRaPTTz+6oHT24zYiQtbUAylWRXcn3swxqMtT2S0ccu690qUZy6h13/wCV4Sw
        PSJacbJvQdG4mjsmMCrmgp5t6nrwAmD9AnZi02PK3Q5dEbaspD1BUVKTDvLoBPiJIBrD0sA4peUx3
        SgKi/Raw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwl-009qNf-PJ; Tue, 22 Feb 2022 14:15:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 10/12] block: move blk_exit_queue into disk_release
Date:   Tue, 22 Feb 2022 15:14:48 +0100
Message-Id: <20220222141450.591193-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

There can't be FS IO in disk_release(), so move blk_exit_queue() there.

We still need to freeze queue here since the request is freed after the
bio is completed and passthrough request rely on scheduler tags as well.

The disk can be released before or after queue is cleaned up, and we have
to free the scheduler request pool before blk_cleanup_queue returns,
while the static request pool has to be freed before exiting the
I/O scheduler.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
[hch: rebased]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c | 16 ----------------
 block/genhd.c     | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4ea22169b5186..faf8577578929 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -739,20 +739,6 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 	kmem_cache_free(blk_get_queue_kmem_cache(blk_queue_has_srcu(q)), q);
 }
 
-/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
-static void blk_exit_queue(struct request_queue *q)
-{
-	/*
-	 * Since the I/O scheduler exit code may access cgroup information,
-	 * perform I/O scheduler exit before disassociating from the block
-	 * cgroup controller.
-	 */
-	if (q->elevator) {
-		ioc_clear_queue(q);
-		elevator_exit(q);
-	}
-}
-
 /**
  * blk_release_queue - releases all allocated resources of the request_queue
  * @kobj: pointer to a kobject, whose container is a request_queue
@@ -786,8 +772,6 @@ static void blk_release_queue(struct kobject *kobj)
 		blk_stat_remove_callback(q, q->poll_cb);
 	blk_stat_free_callback(q->poll_cb);
 
-	blk_exit_queue(q);
-
 	blk_free_queue_stats(q->stats);
 	kfree(q->poll_stat);
 
diff --git a/block/genhd.c b/block/genhd.c
index ebf0e0be1c545..40ef013382872 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -29,6 +29,7 @@
 #include "blk.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
+#include "blk-cgroup.h"
 
 static struct kobject *block_depr;
 
@@ -1092,6 +1093,34 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
+static void blk_mq_release_queue(struct request_queue *q)
+{
+	blk_mq_cancel_work_sync(q);
+
+	/*
+	 * There can't be any non non-passthrough bios in flight here, but
+	 * requests stay around longer, including passthrough ones so we
+	 * still need to freeze the queue here.
+	 */
+	blk_mq_freeze_queue(q);
+
+	/*
+	 * Since the I/O scheduler exit code may access cgroup information,
+	 * perform I/O scheduler exit before disassociating from the block
+	 * cgroup controller.
+	 */
+	if (q->elevator) {
+		ioc_clear_queue(q);
+
+		mutex_lock(&q->sysfs_lock);
+		blk_mq_sched_free_rqs(q);
+		elevator_exit(q);
+		mutex_unlock(&q->sysfs_lock);
+	}
+
+	__blk_mq_unfreeze_queue(q, true);
+}
+
 /**
  * disk_release - releases all allocated resources of the gendisk
  * @dev: the device representing this disk
@@ -1113,7 +1142,8 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
-	blk_mq_cancel_work_sync(disk->queue);
+	if (queue_is_mq(disk->queue))
+		blk_mq_release_queue(disk->queue);
 
 	/*
 	 * Remove all references to @q from the block cgroup controller before
-- 
2.30.2

