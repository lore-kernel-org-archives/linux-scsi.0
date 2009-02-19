From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: remove scsi_end_request()
Date: Thu, 19 Feb 2009 15:46:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902191545160.7953-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48492 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752871AbZBSUqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Feb 2009 15:46:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>

This patch (as1144d) removes scsi_end_request().  The routine had only
one caller, so it is moved inline and simplified.

In addition, if no forward progress has been made then the patch
decrements a request's retry counter before unpreparing and requeuing
it, to avoid infinite retry loops.

Finally, fix up an omission left by an earlier change: The "error"
variable should be passed to blk_end_request().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Martin K. Petersen <martin.petersen@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>

---

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -703,71 +703,6 @@ void scsi_run_host_queues(struct Scsi_Ho
 
 static void __scsi_release_buffers(struct scsi_cmnd *, int);
 
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
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
-
-		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request(req, error, leftover);
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
-	__scsi_release_buffers(cmd, 0);
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -929,7 +864,6 @@ static void scsi_end_bidi_request(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -980,24 +914,37 @@ void scsi_io_completion(struct scsi_cmnd
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-
-	/* A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
-	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
+	if (blk_end_request(req, error, good_bytes) == 0) {
+		/* This request is completely finished; start the next one */
+		 __scsi_release_buffers(cmd, 0);
+		scsi_next_command(cmd);
 		return;
-	this_count = blk_rq_bytes(req);
-
-	error = -EIO;
+	}
 
-	if (host_byte(result) == DID_RESET) {
+	/* The request isn't finished yet.  Figure out what to do next. */
+	if (result == 0) {
+		/* No error, so carry out the remainder of the request.
+		 * Failure to make forward progress counts against the
+		 * the number of retries.
+		 */
+		if (good_bytes > 0 || --req->retries >= 0)
+			action = ACTION_REPREP;
+		else {
+			description = "Retries exhausted";
+			action = ACTION_FAIL;
+			error = -EIO;
+		}
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* Retrys are disallowed, so kill the remainder. */
+		action = ACTION_FAIL;
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.
 		 */
 		action = ACTION_RETRY;
 	} else if (sense_valid && !sense_deferred) {
+		error = -EIO;
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
@@ -1098,7 +1045,7 @@ void scsi_io_completion(struct scsi_cmnd
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
-		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		blk_end_request(req, error, blk_rq_bytes(req));
 		scsi_next_command(cmd);
 		break;
 	case ACTION_REPREP:

