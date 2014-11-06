From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] scsi: move more requeue handling into scsi_requeue_command
Date: Thu,  6 Nov 2014 08:40:30 +0100
Message-ID: <1415259630-20784-7-git-send-email-hch@lst.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaKFHkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:40:32 -0500
In-Reply-To: <1415259630-20784-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

Move a bit code out of scsi_io_completion and into scsi_requeue_command
in preparation for further refactoring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 86 ++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6400c6b..e8457fc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -507,42 +507,6 @@ void scsi_requeue_run_queue(struct work_struct *work)
 	scsi_run_queue(q);
 }
 
-/*
- * Function:	scsi_requeue_command()
- *
- * Purpose:	Handle post-processing of completed commands.
- *
- * Arguments:	q	- queue to operate on
- *		cmd	- command that may need to be requeued.
- *
- * Returns:	Nothing
- *
- * Notes:	After command completion, there may be blocks left
- *		over which weren't finished by the previous command
- *		this can be for a number of reasons - the main one is
- *		I/O errors in the middle of the request, in which case
- *		we need to request the blocks that come after the bad
- *		sector.
- * Notes:	Upon return, cmd is a stale pointer.
- */
-static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct request *req = cmd->request;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_unprep_request(req);
-	req->special = NULL;
-	scsi_put_command(cmd);
-	blk_requeue_request(q, req);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	scsi_run_queue(q);
-
-	put_device(&sdev->sdev_gendev);
-}
-
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
@@ -648,6 +612,43 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
+/**
+ * scsi_requeue_command - requeue a command from the I/O completion path.
+ * @cmd		: command that needs to be requeued
+ *
+ * After command completion, there may be blocks left over which weren't
+ * finished by the previous command this can be for a number of reasons -
+ * the main one is I/O errors in the middle of the request, in which case
+ * we need to request the blocks that come after the bad sector.
+ */
+static void scsi_requeue_command(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+	struct request_queue *q = req->q;
+
+	scsi_free_sgtables(cmd);
+
+	if (q->mq_ops) {
+		cmd->request->cmd_flags &= ~REQ_DONTPREP;
+		scsi_mq_uninit_cmd(cmd);
+		scsi_mq_requeue_cmd(cmd);
+	} else {
+		struct scsi_device *sdev = cmd->device;
+		unsigned long flags;
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_unprep_request(req);
+		req->special = NULL;
+		scsi_put_command(cmd);
+		blk_requeue_request(q, req);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+
+		scsi_run_queue(q);
+
+		put_device(&sdev->sdev_gendev);
+	}
+}
+
 static bool scsi_end_request(struct request *req, int error,
 		unsigned int bytes, unsigned int bidi_bytes)
 {
@@ -779,7 +780,6 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
 	struct scsi_sense_hdr sshdr;
@@ -1015,17 +1015,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		/*FALLTHRU*/
 	case ACTION_REPREP:
 	requeue:
-		/* Unprep the request and put it back at the head of the queue.
-		 * A new command will be prepared and issued.
-		 */
-		scsi_free_sgtables(cmd);
-		if (q->mq_ops) {
-			cmd->request->cmd_flags &= ~REQ_DONTPREP;
-			scsi_mq_uninit_cmd(cmd);
-			scsi_mq_requeue_cmd(cmd);
-		} else {
-			scsi_requeue_command(q, cmd);
-		}
+		scsi_requeue_command(cmd);
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-- 
1.9.1

