From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] scsi: remove scsi_end_request
Date: Thu,  1 May 2014 16:51:03 +0200
Message-ID: <1398955865-20629-3-git-send-email-hch@lst.de>
References: <1398955865-20629-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaEAOsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2014 10:48:53 -0400
In-Reply-To: <1398955865-20629-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

By folding scsi_end_request into its only caller we can significantly clean
up the completion logic.  We can use simple goto labels now to only have
a single place to finish or requeue command there instead of the previous
convoluted logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |  114 +++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f416b59..045822b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -512,66 +512,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-/*
- * Function:    scsi_end_request()
- *
- * Purpose:     Post-processing of completed commands (usually invoked at end
- *		of upper level post-processing and scsi_io_completion).
- *
- * Arguments:   cmd	 - command that is complete.
- *              error    - 0 if I/O indicates success, < 0 for I/O error.
- *              bytes    - number of bytes of completed I/O
- *		requeue  - indicates whether we should requeue leftovers.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     cmd if requeue required, NULL otherwise.
- *
- * Notes:       This is called for block device requests in order to
- *              mark some number of sectors as complete.
- * 
- *		We are guaranteeing that the request queue will be goosed
- *		at some point during this call.
- * Notes:	If cmd was requeued, upon return it will be a stale pointer.
- */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
-					  int bytes, int requeue)
-{
-	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
-
-	/*
-	 * If there are blocks left over at the end, set up the command
-	 * to queue the remainder of them.
-	 */
-	if (blk_end_request(req, error, bytes)) {
-		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request_all(req, error);
-		else {
-			if (requeue) {
-				/*
-				 * Bleah.  Leftovers again.  Stick the
-				 * leftovers in the front of the
-				 * queue, and goose the queue again.
-				 */
-				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
-				cmd = NULL;
-			}
-			return cmd;
-		}
-	}
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	scsi_release_buffers(cmd);
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -717,16 +657,9 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
  *
  * Returns:     Nothing
  *
- * Notes:       This function is matched in terms of capabilities to
- *              the function that created the scatter-gather list.
- *              In other words, if there are no bounce buffers
- *              (the normal case for most drivers), we don't need
- *              the logic to deal with cleaning up afterwards.
- *
- *		We must call scsi_end_request().  This will finish off
- *		the specified number of sectors.  If we are done, the
- *		command block will be released and the queue function
- *		will be goosed.  If we are not done then we have to
+ * Notes:       We will finish off the specified number of sectors.  If we
+ *		are done, the command block will be released and the queue
+ *		function will be goosed.  If we are not done then we have to
  *		figure out what to do next:
  *
  *		a) We can call scsi_requeue_command().  The request
@@ -735,7 +668,7 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
  *		   be used if we made forward progress, or if we want
  *		   to switch from READ(10) to READ(6) for example.
  *
- *		b) We can call scsi_queue_insert().  The request will
+ *		b) We can call __scsi_queue_insert().  The request will
  *		   be put back on the queue and retried using the same
  *		   command as before, possibly after a delay.
  *
@@ -794,6 +727,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 			scsi_release_buffers(cmd);
 			scsi_release_bidi_buffers(cmd);
+
 			blk_end_request_all(req, 0);
 
 			scsi_next_command(cmd);
@@ -833,12 +767,25 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	/*
-	 * A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
+	 * If we finished all bytes in the request we are done now.
 	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
-		return;
+	if (!blk_end_request(req, error, good_bytes))
+		goto next_command;
+
+	/*
+	 * Kill remainder if no retrys.
+	 */
+	if (error && scsi_noretry_cmd(cmd)) {
+		blk_end_request_all(req, error);
+		goto next_command;
+	}
+
+	/*
+	 * If there had been no error, but we have leftover bytes in the
+	 * requeues just queue the command up again.
+	 */
+	if (result == 0)
+		goto requeue;
 
 	error = __scsi_error_from_host_byte(cmd, result);
 
@@ -966,7 +913,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
-		scsi_release_buffers(cmd);
 		if (!(req->cmd_flags & REQ_QUIET)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
@@ -976,12 +922,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (blk_end_request_err(req, error))
-			scsi_requeue_command(q, cmd);
-		else
-			scsi_next_command(cmd);
-		break;
+		if (!blk_end_request_err(req, error))
+			goto next_command;
+		/*FALLTHRU*/
 	case ACTION_REPREP:
+	requeue:
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
@@ -997,6 +942,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
 		break;
 	}
+	return;
+
+next_command:
+	scsi_release_buffers(cmd);
+	scsi_next_command(cmd);
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
-- 
1.7.10.4

