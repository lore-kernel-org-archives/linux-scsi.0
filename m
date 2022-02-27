Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1664C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiB0RXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiB0RXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:23:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F9325F4;
        Sun, 27 Feb 2022 09:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WPV6qqfYK9KN5lfX3TzpAUpHb0etUqbkw1a3zeRzfko=; b=rOuVWjiC6Qo/TqIjZrPicCQ2CN
        y3UrZQ9w0oDUYAnb/eHu1tLgbBJkRiB4ZG43GSJXBNj2nlkKG3WrZtR+ZAWtGbhADSj4nvrhH2Zv6
        Bwgibm3OLlWs+ZEwvOm1v+Et/USqJVwyYmIzqwNWa1WvoT79C5eqv2spbGJT9dQcoUtLqs75MGRUe
        sw1jv+bxOAnVtgJh3/PWY22EfzkscCaS4aq7/kS7fOc8cE4PSnmRDimBnkuvrnZ8ynJsRUbBsEDgg
        rg0dZsk8+EhsilIfbU2y17jOxaWStKjhQJZuUtITS14oVjBya6OBFvsaADY0ezO4Rr7qwTHlUs8kX
        TrmVbGcg==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONFV-009s5i-74; Sun, 27 Feb 2022 17:22:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/14] block: move blk_exit_queue into disk_release
Date:   Sun, 27 Feb 2022 18:21:42 +0100
Message-Id: <20220227172144.508118-13-hch@lst.de>
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
index 3249d4206f312..a92641911bc1b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -30,6 +30,7 @@
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
 #include "blk-throttle.h"
+#include "blk-cgroup.h"
 
 static struct kobject *block_depr;
 
@@ -1099,6 +1100,34 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
+static void disk_release_mq(struct request_queue *q)
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
@@ -1120,7 +1149,8 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
-	blk_mq_cancel_work_sync(disk->queue);
+	if (queue_is_mq(disk->queue))
+		disk_release_mq(disk->queue);
 
 	blkcg_exit_queue(disk->queue);
 
-- 
2.30.2

