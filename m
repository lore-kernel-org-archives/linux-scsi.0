Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B82C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiCHFxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244002AbiCHFxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C425C1261C;
        Mon,  7 Mar 2022 21:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=olkS7i/OWJESMOkpxfW/l1wgYaKHCoBQyMvPpMK7Sv4=; b=tAaaB4GBr9eHjto3x8vke+Pv+R
        NBxyvSVrBWaIFTmbkVy9AjV1Cz3VcFBshnh11RDrL1tNhrqcw5IXG9FxrpmREIypzDakG+r3Vf6wZ
        DqZ9/zROvkuB9g/D7nO8ELe8gJe8sAJu3uDACEvxQdOk4JOzGP9usE/Zdg6CnjCZQmKny8bilSiMm
        NEuQU7tVBUZIj7vT/SjwEwdffmdsa/E6+kYxvH2pPpdnx199dXh3x2O7lex61AStllujcwj4uFSLu
        /o0xxR/3wFffbFwch6Vg3IuyhPfaCOQHrs2egS17oQwtTS6XTA137idwtZ6KSIWBaV/3amMykcvkl
        V3pIlrvw==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSls-002itL-Am; Tue, 08 Mar 2022 05:52:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 12/14] block: move blk_exit_queue into disk_release
Date:   Tue,  8 Mar 2022 06:51:58 +0100
Message-Id: <20220308055200.735835-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308055200.735835-1-hch@lst.de>
References: <20220308055200.735835-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

There can't be file system I/O in disk_release(), so move the call to
blk_exit_queue() there, preparing to have the teardown of file system I/O
only functionality in one place, when the gendisk that is needed for it
is torn down.

We still need to freeze queue here since the request is freed after the
bio is completed and passthrough request rely on scheduler tags as well.

The disk can be released before or after queue is cleaned up, and we have
to free the scheduler request pool before blk_cleanup_queue returns,
while the static request pool has to be freed before exiting the
I/O scheduler.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
[hch: rebased, updated the commit log]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-sysfs.c | 16 ----------------
 block/genhd.c     | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index af5a6d86073f1..85c4ba006671d 100644
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
index 073e93f2fc40b..73705a749ea92 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -29,6 +29,7 @@
 #include "blk.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
+#include "blk-cgroup.h"
 
 static struct kobject *block_depr;
 
@@ -1097,6 +1098,34 @@ static const struct attribute_group *disk_attr_groups[] = {
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
@@ -1118,7 +1147,8 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
-	blk_mq_cancel_work_sync(disk->queue);
+	if (queue_is_mq(disk->queue))
+		disk_release_mq(disk->queue);
 
 	blkcg_exit_queue(disk->queue);
 
-- 
2.30.2

