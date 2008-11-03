From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/2] SCSI: remove scsi_end_request()
Date: Mon, 3 Nov 2008 15:56:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811031555010.2186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57764 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754757AbYKCU4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 15:56:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1144b) removes scsi_end_request().  The routine had only
one caller, so it is moved inline and simplified.

In addition, if no forward progress has been made then the patch
decrements a request's retry counter before unpreparing and requeuing
it, to avoid infinite retry loops.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -680,69 +680,6 @@ void scsi_run_host_queues(struct Scsi_Ho
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
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -898,7 +835,6 @@ static void scsi_end_bidi_request(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -949,22 +885,31 @@ void scsi_io_completion(struct scsi_cmnd
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
+		scsi_next_command(cmd);
 		return;
-	this_count = blk_rq_bytes(req);
+	}
+
+	/* The request isn't finished yet.  Figure out what to do next. */
 	action = ACTION_FAIL;
+	if (result == 0) {
+		/* No error, so carry out the remainder of the request.
+		 * Failure to make forward progress counts against the
+		 * the number of retries.
+		 */
+		if (good_bytes > 0 || --req->retries >= 0)
+			action = ACTION_REPREP;
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* Retrys are disallowed, so kill the remainder. */
 
-	if (host_byte(result) == DID_RESET) {
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.
 		 */
 		action = ACTION_RETRY;
+
 	} else if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:

