From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] scsi-mq: fix hw queue hang caused by timeout
Date: Thu, 18 Sep 2014 23:59:10 +0800
Message-ID: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63404 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaIRP7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Sep 2014 11:59:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>

If there are two requests or more timed out, the dispatch queue
is put into stopped state and never be recoverd, and there
is no such problem in non-mq mode.

This patch trys to recover the stopped queue when the queue
becomes unbusy, then the following retries can move on.

Basically this patch maintains same behavior for this situation
with non-mq mode.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/scsi/scsi_lib.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3b92c39..dfbc028 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -142,6 +142,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	struct scsi_device *device = cmd->device;
 	struct request_queue *q = device->request_queue;
 	unsigned long flags;
+	bool restart = false;
+	bool blocked = !!atomic_read(&device->device_blocked);
 
 	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
 		"Inserting command %p into mlqueue\n", cmd));
@@ -152,9 +154,14 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 * Decrement the counters, since these commands are no longer
 	 * active on the host/device.
 	 */
-	if (unbusy)
+	if (unbusy) {
 		scsi_device_unbusy(device);
 
+		/* need to restart hw queue if it was stopped */
+		if (!atomic_read(&device->device_busy) && blocked)
+			restart = true;
+	}
+
 	/*
 	 * Requeue this command.  It will go before all other commands
 	 * that are already in the queue. Schedule requeue work under
@@ -164,6 +171,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	cmd->result = 0;
 	if (q->mq_ops) {
 		scsi_mq_requeue_cmd(cmd);
+		if (restart)
+			blk_mq_start_stopped_hw_queues(q, true);
 		return;
 	}
 	spin_lock_irqsave(q->queue_lock, flags);
-- 
1.7.9.5

