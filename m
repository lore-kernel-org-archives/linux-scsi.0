From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] SCSI: simplify scsi_io_completion()
Date: Mon, 3 Nov 2008 15:56:47 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811031553530.2186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57761 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754248AbYKCU4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 15:56:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1142b) consolidates a lot of repetitious code in
scsi_io_completion().  It also fixes a few comments.  Most
importantly, however, it clearly distinguishes among the three sorts
of retries that can be done when a command fails to complete:

	Unprepare the request and resubmit it, so that a new
	command will be created for it.

	Requeue the request directly so that it will be retried
	immediately using the same command.

	Requeue the request so that it will be retried following
	a short delay.

	Complete the remainder of the request with an I/O error.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

There haven't been any bad comments on these proposed patches, so I am
now officially submitting them for 2.6.29.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -876,16 +876,24 @@ static void scsi_end_bidi_request(struct
  *              (the normal case for most drivers), we don't need
  *              the logic to deal with cleaning up afterwards.
  *
- *		We must do one of several things here:
+ *		We must call scsi_end_request().  This will finish off
+ *		the specified number of sectors.  If we are done, the
+ *		command block will be released and the queue function
+ *		will be goosed.  If we are not done then we have to
+ *		figure out what to do next:
+ *
+ *		a) We can call scsi_requeue_command().  The request
+ *		   will be unprepared and put back on the queue.  Then
+ *		   a new command will be created for it.  This should
+ *		   be used if we made forward progress, or if we want
+ *		   to switch from READ(10) to READ(6) for example.
+ *
+ *		b) We can call scsi_queue_insert().  The request will
+ *		   be put back on the queue and retried using the same
+ *		   command as before, possibly after a delay.
  *
- *		a) Call scsi_end_request.  This will finish off the
- *		   specified number of sectors.  If we are done, the
- *		   command block will be released, and the queue
- *		   function will be goosed.  If we are not done, then
- *		   scsi_end_request will directly goose the queue.
- *
- *		b) We can just use scsi_requeue_command() here.  This would
- *		   be used if we just wanted to retry, for example.
+ *		c) We can call blk_end_request() with -EIO to fail
+ *		   the remainder of the request.
  */
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
@@ -897,6 +905,8 @@ void scsi_io_completion(struct scsi_cmnd
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
+	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
+			ACTION_DELAYED_RETRY} action;
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -947,11 +957,15 @@ void scsi_io_completion(struct scsi_cmnd
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 	this_count = blk_rq_bytes(req);
+	action = ACTION_FAIL;
 
-	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
-	 */
-	if (sense_valid && !sense_deferred) {
+	if (host_byte(result) == DID_RESET) {
+		/* Third party bus reset or reset for error recovery
+		 * reasons.  Just retry the command and see what
+		 * happens.
+		 */
+		action = ACTION_RETRY;
+	} else if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
@@ -959,16 +973,13 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				scsi_end_request(cmd, -EIO, this_count, 1);
-				return;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
 				 * media change, so we just retry the
-				 * request and see what happens.
+				 * command and see what happens.
 				 */
-				scsi_requeue_command(q, cmd);
-				return;
+				action = ACTION_RETRY;
 			}
 			break;
 		case ILLEGAL_REQUEST:
@@ -984,22 +995,13 @@ void scsi_io_completion(struct scsi_cmnd
 			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
 			    (cmd->cmnd[0] == READ_10 ||
 			     cmd->cmnd[0] == WRITE_10)) {
+				/* This will issue a new 6-byte command. */
 				cmd->device->use_10_for_rw = 0;
-				/* This will cause a retry with a
-				 * 6-byte command.
-				 */
-				scsi_requeue_command(q, cmd);
-			} else if (sshdr.asc == 0x10) /* DIX */
-				scsi_end_request(cmd, -EIO, this_count, 0);
-			else
-				scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
-		case ABORTED_COMMAND:
-			if (sshdr.asc == 0x10) { /* DIF */
-				scsi_end_request(cmd, -EIO, this_count, 0);
-				return;
+				action = ACTION_REPREP;
 			}
 			break;
+		case ABORTED_COMMAND:
+			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
 			 * ready, or has a temporary blockage, retry.
@@ -1013,19 +1015,16 @@ void scsi_io_completion(struct scsi_cmnd
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
-					scsi_requeue_command(q, cmd);
-					return;
-				default:
+					action = ACTION_DELAYED_RETRY;
 					break;
 				}
 			}
-			if (!(req->cmd_flags & REQ_QUIET))
+			if (!(req->cmd_flags & REQ_QUIET) &&
+					action == ACTION_FAIL)
 				scsi_cmd_print_sense_hdr(cmd,
 							 "Device not ready",
 							 &sshdr);
-
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			break;
 		case VOLUME_OVERFLOW:
 			if (!(req->cmd_flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
@@ -1034,28 +1033,38 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 			}
 			/* See SSC3rXX or current. */
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
-		default:
 			break;
 		}
 	}
-	if (host_byte(result) == DID_RESET) {
-		/* Third party bus reset or reset for error recovery
-		 * reasons.  Just retry the request and see what
-		 * happens.
+
+	switch (action) {
+	case ACTION_FAIL:
+		/* Give up and fail the remainder of the request */
+		if (result) {
+			if (!(req->cmd_flags & REQ_QUIET)) {
+				scsi_print_result(cmd);
+				if (driver_byte(result) & DRIVER_SENSE)
+					scsi_print_sense("", cmd);
+			}
+		}
+		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		scsi_next_command(cmd);
+		break;
+	case ACTION_REPREP:
+		/* Unprep the request and put it back at the head of the queue.
+		 * A new command will be prepared and issued.
 		 */
 		scsi_requeue_command(q, cmd);
-		return;
-	}
-	if (result) {
-		if (!(req->cmd_flags & REQ_QUIET)) {
-			scsi_print_result(cmd);
-			if (driver_byte(result) & DRIVER_SENSE)
-				scsi_print_sense("", cmd);
-		}
+		break;
+	case ACTION_RETRY:
+		/* Retry the same command immediately */
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
+		break;
+	case ACTION_DELAYED_RETRY:
+		/* Retry the same command after a delay */
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		break;
 	}
-	scsi_end_request(cmd, -EIO, this_count, !result);
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,

