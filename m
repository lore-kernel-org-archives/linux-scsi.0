From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3 version 4] scsi_lib: Collapse scsi_end_request into only
 user
Date: Tue, 05 Jan 2010 11:07:10 +0200
Message-ID: <4B43013E.9010502@panasas.com>
References: <4B41DADD.4000102@panasas.com> <4B41DC42.1090706@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:49316 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396Ab0AEJHO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 04:07:14 -0500
In-Reply-To: <4B41DC42.1090706@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.k>


Embedding scsi_end_request() into scsi_io_completion actually simplifies
the code and makes it clearer what's going on.

There is absolutely no functional and/or side effects changes after this
patch.

Patch was inspired by Alan Stern.

CC: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   92 ++++++++++-------------------------------------
 1 files changed, 19 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d8b4eb..523453f 100644
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
-				scsi_requeue_command(cmd);
-				cmd = NULL;
-			}
-			return cmd;
-		}
-	}
-
-	cmd->request = NULL;
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
@@ -704,7 +644,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
-	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
+	enum {ACTION_NEXT_CMND, ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
 	char *description = NULL;
 
@@ -773,17 +713,19 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		error = 0;
 	}
 
-	/*
-	 * A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
-	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
-		return;
-
-	error = -EIO;
-
-	if (host_byte(result) == DID_RESET) {
+	if (likely(0 == blk_end_request(req, error, good_bytes))) {
+		/* All is done and good move to next command */
+		cmd->request = NULL;
+		action = ACTION_NEXT_CMND;
+	} else if (result == 0) {
+		/* Wrote some bytes but request was split */
+		action = ACTION_REPREP;
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* kill remainder if no retries */
+		blk_end_request_all(req, error);
+		cmd->request = NULL;
+		action = ACTION_NEXT_CMND;
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.
@@ -879,6 +821,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	switch (action) {
+	case ACTION_NEXT_CMND :
+		scsi_release_buffers(cmd);
+		scsi_next_command(cmd);
+		break;
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		scsi_release_buffers(cmd);
@@ -891,7 +837,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (blk_end_request_err(req, error))
+		if (blk_end_request_err(req, error ? error : -EIO))
 			scsi_requeue_command(cmd);
 		else
 			scsi_next_command(cmd);
-- 
1.6.6


