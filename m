From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Mon, 29 Sep 2008 17:11:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809291710390.4420-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53510 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751818AbYI2VLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2008 17:11:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1142) consolidates some repetitious code in
scsi_io_completion().  Multiple calls to scsi_end_request() and to
scsi_requeue_command() are combined together and moved to the end of
the function.

This is simple mechanical code motion, with no change in behavior.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -910,9 +910,6 @@ void scsi_io_completion(struct scsi_cmnd
 		return;
 	this_count = blk_rq_bytes(req);
 
-	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
-	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
@@ -921,18 +918,15 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				scsi_end_request(cmd, -EIO, this_count, 1);
-				return;
+				goto retry2;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
 				 * media change, so we just retry the
 				 * request and see what happens.
 				 */
-				scsi_requeue_command(q, cmd);
-				return;
+				goto requeue;
 			}
-			break;
 		case ILLEGAL_REQUEST:
 			/* If we had an ILLEGAL REQUEST returned, then
 			 * we may have performed an unsupported
@@ -950,17 +944,14 @@ void scsi_io_completion(struct scsi_cmnd
 				/* This will cause a retry with a
 				 * 6-byte command.
 				 */
-				scsi_requeue_command(q, cmd);
+				goto requeue;
 			} else if (sshdr.asc == 0x10) /* DIX */
-				scsi_end_request(cmd, -EIO, this_count, 0);
+				goto fail;
 			else
-				scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+				goto retry2;
 		case ABORTED_COMMAND:
-			if (sshdr.asc == 0x10) { /* DIF */
-				scsi_end_request(cmd, -EIO, this_count, 0);
-				return;
-			}
+			if (sshdr.asc == 0x10)  /* DIF */
+				goto fail;
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
@@ -975,8 +966,7 @@ void scsi_io_completion(struct scsi_cmnd
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
-					scsi_requeue_command(q, cmd);
-					return;
+					goto requeue;
 				default:
 					break;
 				}
@@ -985,9 +975,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_cmd_print_sense_hdr(cmd,
 							 "Device not ready",
 							 &sshdr);
-
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			goto retry2;
 		case VOLUME_OVERFLOW:
 			if (!(req->cmd_flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
@@ -996,8 +984,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 			}
 			/* See SSC3rXX or current. */
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			goto retry2;
 		default:
 			break;
 		}
@@ -1007,8 +994,7 @@ void scsi_io_completion(struct scsi_cmnd
 		 * reasons.  Just retry the request and see what
 		 * happens.
 		 */
-		scsi_requeue_command(q, cmd);
-		return;
+		goto requeue;
 	}
 	if (result) {
 		if (!(req->cmd_flags & REQ_QUIET)) {
@@ -1016,8 +1002,18 @@ void scsi_io_completion(struct scsi_cmnd
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
+		goto fail;
 	}
-	scsi_end_request(cmd, -EIO, this_count, !result);
+
+ retry2:
+	scsi_end_request(cmd, -EIO, this_count, 1);
+	return;
+ fail:
+	scsi_end_request(cmd, -EIO, this_count, 0);
+	return;
+ requeue:
+	scsi_requeue_command(q, cmd);
+	return;
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,

