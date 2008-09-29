From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: don't do bogus retries
Date: Mon, 29 Sep 2008 17:12:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809291711440.4420-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53513 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751411AbYI2VM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2008 17:12:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1143) changes the bogus "retry" paths in
scsi_io_completion() into straightforward failures.  It's not clear
why the retries were present to begin with.

The patch also changes the "failure" path; now instead of calling
scsi_end_request() it directly calls end_dequeued_request() followed
by scsi_next_command().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -852,7 +852,6 @@ static void scsi_end_bidi_request(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -908,7 +907,6 @@ void scsi_io_completion(struct scsi_cmnd
 	 */
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
-	this_count = blk_rq_bytes(req);
 
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
@@ -918,7 +916,7 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				goto retry2;
+				goto fail;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
@@ -948,7 +946,7 @@ void scsi_io_completion(struct scsi_cmnd
 			} else if (sshdr.asc == 0x10) /* DIX */
 				goto fail;
 			else
-				goto retry2;
+				goto fail;
 		case ABORTED_COMMAND:
 			if (sshdr.asc == 0x10)  /* DIF */
 				goto fail;
@@ -975,7 +973,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_cmd_print_sense_hdr(cmd,
 							 "Device not ready",
 							 &sshdr);
-			goto retry2;
+			goto fail;
 		case VOLUME_OVERFLOW:
 			if (!(req->cmd_flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
@@ -984,7 +982,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 			}
 			/* See SSC3rXX or current. */
-			goto retry2;
+			goto fail;
 		default:
 			break;
 		}
@@ -1002,14 +1000,10 @@ void scsi_io_completion(struct scsi_cmnd
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
-		goto fail;
 	}
-
- retry2:
-	scsi_end_request(cmd, -EIO, this_count, 1);
-	return;
  fail:
-	scsi_end_request(cmd, -EIO, this_count, 0);
+	end_dequeued_request(req, -EIO);
+	scsi_next_command(cmd);
 	return;
  requeue:
 	scsi_requeue_command(q, cmd);

