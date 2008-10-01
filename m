From: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC] Rearrange code in scsi_io_completion
Date: Wed, 1 Oct 2008 17:00:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810011639340.2182-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56055 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751037AbYJAVAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 17:00:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Here's a new patch to rework scsi_io_completion.  I tried to take into 
account comments on the old patch set.

A lot of the old code turned out to be redundant and got removed.  And 
some of the remaining code is present only to add some error messages 
to the log; I'm not at all sure they are really needed.

Perhaps most significantly, the test for host_byte(result) == DID_RESET
was moved in front of the other analysis code.  This seemed to be the
proper place for it; please tell me if it isn't.

This has hardly been tested at all.  All I can say for sure is that it 
works if no commands fail...  :-)

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -859,6 +859,8 @@ void scsi_io_completion(struct scsi_cmnd
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
+	enum {ACTION_FAIL, ACTION_REQUEUE, ACTION_RETRY,
+			ACTION_DELAYED_RETRY} action;
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -909,11 +911,15 @@ void scsi_io_completion(struct scsi_cmnd
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
@@ -921,16 +927,13 @@ void scsi_io_completion(struct scsi_cmnd
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
@@ -946,22 +949,13 @@ void scsi_io_completion(struct scsi_cmnd
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
+				action = ACTION_REQUEUE;
 			}
 			break;
+		case ABORTED_COMMAND:
+			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
 			 * ready, or has a temporary blockage, retry.
@@ -975,19 +969,16 @@ void scsi_io_completion(struct scsi_cmnd
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
@@ -996,28 +987,38 @@ void scsi_io_completion(struct scsi_cmnd
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
+	case ACTION_REQUEUE:
+		/* Put the request back at the head of the queue.
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

