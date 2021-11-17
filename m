Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC4BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B54461BFA
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhKQGRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1726C061200;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4B5bPzZBI/RyRz5DgrZ23Yjj20qoEABWXooz0Jl0HiU=; b=aousJe038ZkoZyUbwpN7CwPnGG
        Fy1M5rKKYRiZSv+VlzU+btB/DlBwVFKfM4AFpERfyrnKUFid6JcmW53drnTcXActvAzjFlEn4gYaR
        5NdyMri9i4l+6uzeu/uOMpEAepuU2apsMeeFaHFUoksQOzeVL1uR+qOsHRsDtZBkbTNSqVOHWIGOH
        v86J0hIXkxSY5JUszlsyP07nPggVASqibOcRnFWZW6XnO5TpGVaHJfJLNOFBXEtOowyP5iMKuLAID
        +2qaxvz7HaQItqBX2zSNgvnc4G7i3DYCs68WNkH1gJ0ilF4qubdl5ZwICZfaaXgiYHluM1+IB1e5j
        cJ/Bqvxg==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnECw-007MEZ-Hc; Wed, 17 Nov 2021 06:14:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 03/11] block: remove blk-exec.c
Date:   Wed, 17 Nov 2021 07:13:56 +0100
Message-Id: <20211117061404.331732-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All this code is tightly coupled to the blk-mq core, so move it
there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Makefile   |   2 +-
 block/blk-exec.c | 116 -----------------------------------------------
 block/blk-mq.c   | 107 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 117 deletions(-)
 delete mode 100644 block/blk-exec.c

diff --git a/block/Makefile b/block/Makefile
index 44df57e562bf0..f38eaa6129296 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -5,7 +5,7 @@
 
 obj-y		:= bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-flush.o blk-settings.o blk-ioc.o blk-map.o \
-			blk-exec.o blk-merge.o blk-timeout.o \
+			blk-merge.o blk-timeout.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
 			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
diff --git a/block/blk-exec.c b/block/blk-exec.c
deleted file mode 100644
index 1b8b47f6e79bb..0000000000000
--- a/block/blk-exec.c
+++ /dev/null
@@ -1,116 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Functions related to setting various queue properties from drivers
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/bio.h>
-#include <linux/blkdev.h>
-#include <linux/blk-mq.h>
-#include <linux/sched/sysctl.h>
-
-#include "blk.h"
-#include "blk-mq-sched.h"
-
-/**
- * blk_end_sync_rq - executes a completion event on a request
- * @rq: request to complete
- * @error: end I/O status of the request
- */
-static void blk_end_sync_rq(struct request *rq, blk_status_t error)
-{
-	struct completion *waiting = rq->end_io_data;
-
-	rq->end_io_data = (void *)(uintptr_t)error;
-
-	/*
-	 * complete last, if this is a stack request the process (and thus
-	 * the rq pointer) could be invalid right after this complete()
-	 */
-	complete(waiting);
-}
-
-/**
- * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
- * @bd_disk:	matching gendisk
- * @rq:		request to insert
- * @at_head:    insert request at head or tail of queue
- * @done:	I/O completion handler
- *
- * Description:
- *    Insert a fully prepared request at the back of the I/O scheduler queue
- *    for execution.  Don't wait for completion.
- *
- * Note:
- *    This function will invoke @done directly if the queue is dead.
- */
-void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
-			   int at_head, rq_end_io_fn *done)
-{
-	WARN_ON(irqs_disabled());
-	WARN_ON(!blk_rq_is_passthrough(rq));
-
-	rq->rq_disk = bd_disk;
-	rq->end_io = done;
-
-	blk_account_io_start(rq);
-
-	/*
-	 * don't check dying flag for MQ because the request won't
-	 * be reused after dying flag is set
-	 */
-	blk_mq_sched_insert_request(rq, at_head, true, false);
-}
-EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
-
-static bool blk_rq_is_poll(struct request *rq)
-{
-	if (!rq->mq_hctx)
-		return false;
-	if (rq->mq_hctx->type != HCTX_TYPE_POLL)
-		return false;
-	if (WARN_ON_ONCE(!rq->bio))
-		return false;
-	return true;
-}
-
-static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
-{
-	do {
-		bio_poll(rq->bio, NULL, 0);
-		cond_resched();
-	} while (!completion_done(wait));
-}
-
-/**
- * blk_execute_rq - insert a request into queue for execution
- * @bd_disk:	matching gendisk
- * @rq:		request to insert
- * @at_head:    insert request at head or tail of queue
- *
- * Description:
- *    Insert a fully prepared request at the back of the I/O scheduler queue
- *    for execution and wait for completion.
- * Return: The blk_status_t result provided to blk_mq_end_request().
- */
-blk_status_t blk_execute_rq(struct gendisk *bd_disk, struct request *rq, int at_head)
-{
-	DECLARE_COMPLETION_ONSTACK(wait);
-	unsigned long hang_check;
-
-	rq->end_io_data = &wait;
-	blk_execute_rq_nowait(bd_disk, rq, at_head, blk_end_sync_rq);
-
-	/* Prevent hang_check timer from firing at us during very long I/O */
-	hang_check = sysctl_hung_task_timeout_secs;
-
-	if (blk_rq_is_poll(rq))
-		blk_rq_poll_completion(rq, &wait);
-	else if (hang_check)
-		while (!wait_for_completion_io_timeout(&wait, hang_check * (HZ/2)));
-	else
-		wait_for_completion_io(&wait);
-
-	return (blk_status_t)(uintptr_t)rq->end_io_data;
-}
-EXPORT_SYMBOL(blk_execute_rq);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ab34c4f20daf..c33411f9ce898 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -28,6 +28,7 @@
 #include <linux/crash_dump.h>
 #include <linux/prefetch.h>
 #include <linux/blk-crypto.h>
+#include <linux/sched/sysctl.h>
 
 #include <trace/events/block.h>
 
@@ -1057,6 +1058,112 @@ void blk_mq_start_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_start_request);
 
+/**
+ * blk_end_sync_rq - executes a completion event on a request
+ * @rq: request to complete
+ * @error: end I/O status of the request
+ */
+static void blk_end_sync_rq(struct request *rq, blk_status_t error)
+{
+	struct completion *waiting = rq->end_io_data;
+
+	rq->end_io_data = (void *)(uintptr_t)error;
+
+	/*
+	 * complete last, if this is a stack request the process (and thus
+	 * the rq pointer) could be invalid right after this complete()
+	 */
+	complete(waiting);
+}
+
+/**
+ * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
+ * @bd_disk:	matching gendisk
+ * @rq:		request to insert
+ * @at_head:    insert request at head or tail of queue
+ * @done:	I/O completion handler
+ *
+ * Description:
+ *    Insert a fully prepared request at the back of the I/O scheduler queue
+ *    for execution.  Don't wait for completion.
+ *
+ * Note:
+ *    This function will invoke @done directly if the queue is dead.
+ */
+void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
+			   int at_head, rq_end_io_fn *done)
+{
+	WARN_ON(irqs_disabled());
+	WARN_ON(!blk_rq_is_passthrough(rq));
+
+	rq->rq_disk = bd_disk;
+	rq->end_io = done;
+
+	blk_account_io_start(rq);
+
+	/*
+	 * don't check dying flag for MQ because the request won't
+	 * be reused after dying flag is set
+	 */
+	blk_mq_sched_insert_request(rq, at_head, true, false);
+}
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
+static bool blk_rq_is_poll(struct request *rq)
+{
+	if (!rq->mq_hctx)
+		return false;
+	if (rq->mq_hctx->type != HCTX_TYPE_POLL)
+		return false;
+	if (WARN_ON_ONCE(!rq->bio))
+		return false;
+	return true;
+}
+
+static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
+{
+	do {
+		bio_poll(rq->bio, NULL, 0);
+		cond_resched();
+	} while (!completion_done(wait));
+}
+
+/**
+ * blk_execute_rq - insert a request into queue for execution
+ * @bd_disk:	matching gendisk
+ * @rq:		request to insert
+ * @at_head:    insert request at head or tail of queue
+ *
+ * Description:
+ *    Insert a fully prepared request at the back of the I/O scheduler queue
+ *    for execution and wait for completion.
+ * Return: The blk_status_t result provided to blk_mq_end_request().
+ */
+blk_status_t blk_execute_rq(struct gendisk *bd_disk, struct request *rq,
+		int at_head)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	unsigned long hang_check;
+
+	rq->end_io_data = &wait;
+	blk_execute_rq_nowait(bd_disk, rq, at_head, blk_end_sync_rq);
+
+	/* Prevent hang_check timer from firing at us during very long I/O */
+	hang_check = sysctl_hung_task_timeout_secs;
+
+	if (blk_rq_is_poll(rq))
+		blk_rq_poll_completion(rq, &wait);
+	else if (hang_check)
+		while (!wait_for_completion_io_timeout(&wait,
+				hang_check * (HZ/2)))
+			;
+	else
+		wait_for_completion_io(&wait);
+
+	return (blk_status_t)(uintptr_t)rq->end_io_data;
+}
+EXPORT_SYMBOL(blk_execute_rq);
+
 static void __blk_mq_requeue_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-- 
2.30.2

