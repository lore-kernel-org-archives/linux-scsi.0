From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 8/9] scsi: Add scsi_requeue_request function
Date: Mon,  3 May 2010 20:37:07 -0700
Message-ID: <1272944228-30511-9-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51372 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab0EDDhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:51 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443Q7h2003130
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:26:07 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443boo6122698
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443bn3u019196
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:50 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Add a common scsi_requeue_request function and move previous callers of
separate requeue calls to a this common one. This is a preparation step to
allow a follow on patch to be added to a common function.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_lib.c |   53 +++++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1685d35..73182db 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -102,6 +102,33 @@ static void scsi_unprep_fn(struct request_queue *q, struct request *req)
 }
 
 
+/*
+ * Function:	scsi_requeue_request()
+ *
+ * Purpose:	Requeue a request.
+ *
+ * Arguments:	q	- queue to operate on
+ *		req	- request to be requeued.
+ *		unprep	- indicate if unprep needed.
+ *
+ * Returns:	Nothing
+ *
+ * Notes:	Upon return, req is a stale pointer.
+ */
+static void scsi_requeue_request(struct request_queue *q, struct request *req,
+				 int unprep)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (unprep)
+		scsi_unprep_request(req);
+	blk_requeue_request(q, req);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	scsi_run_queue(q);
+}
+
 /**
  * __scsi_queue_insert - private queue insertion
  * @cmd: The SCSI command being requeued
@@ -120,7 +147,6 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	struct scsi_device *device = cmd->device;
 	struct scsi_target *starget = scsi_target(device);
 	struct request_queue *q = device->request_queue;
-	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
 		 printk("Inserting command %p into mlqueue\n", cmd));
@@ -157,22 +183,7 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	if (unbusy)
 		scsi_device_unbusy(device);
 
-	/*
-	 * Requeue this command.  It will go before all other commands
-	 * that are already in the queue.
-	 *
-	 * NOTE: there is magic here about the way the queue is plugged if
-	 * we have no outstanding commands.
-	 * 
-	 * Although we *don't* plug the queue, we call the request
-	 * function.  The SCSI request function detects the blocked condition
-	 * and plugs the queue appropriately.
-         */
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_requeue_request(q, cmd->request);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	scsi_run_queue(q);
+	scsi_requeue_request(q, cmd->request, 0);
 
 	return 0;
 }
@@ -489,14 +500,8 @@ static void scsi_run_queue(struct request_queue *q)
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
 	struct request *req = cmd->request;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	scsi_unprep_request(req);
-	blk_requeue_request(q, req);
-	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	scsi_run_queue(q);
+	scsi_requeue_request(q, req, 1);
 }
 
 void scsi_next_command(struct scsi_cmnd *cmd)
-- 
1.6.6.1

