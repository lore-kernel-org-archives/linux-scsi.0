From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] scsi: split error handling slow path out of scsi_io_completion
Date: Sun,  7 Sep 2014 09:31:08 -0700
Message-ID: <1410107469-896-8-git-send-email-hch@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35032 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaIGQ3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:29:12 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfKw-0006T8-Jd
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:29:11 +0000
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move the error handling path out of scsi_io_completion and into an
out of line helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 263 +++++++++++++++++++++++++-----------------------
 1 file changed, 136 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2221bf1..cc5d404 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -742,6 +742,132 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 	return error;
 }
 
+static noinline bool
+scsi_handle_ioerror(struct scsi_cmnd *cmd, int result,
+		struct scsi_sense_hdr *sshdr)
+{
+	struct request *req = cmd->request;
+	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
+	int error = 0;
+	enum {
+		ACTION_FAIL,
+		ACTION_REPREP,
+		ACTION_RETRY,
+		ACTION_DELAYED_RETRY,
+	} action = ACTION_FAIL;
+
+	error = __scsi_error_from_host_byte(cmd, result);
+
+	if (host_byte(result) == DID_RESET) {
+		/* Third party bus reset or reset for error recovery
+		 * reasons.  Just retry the command and see what
+		 * happens.
+		 */
+		action = ACTION_RETRY;
+	} else if (sshdr) {
+		switch (sshdr->sense_key) {
+		case UNIT_ATTENTION:
+			if (cmd->device->removable) {
+				/* Detected disc change.  Set a bit
+				 * and quietly refuse further access.
+				 */
+				cmd->device->changed = 1;
+			} else {
+				/* Must have been a power glitch, or a
+				 * bus reset.  Could not have been a
+				 * media change, so we just retry the
+				 * command and see what happens.
+				 */
+				action = ACTION_RETRY;
+			}
+			break;
+		case ILLEGAL_REQUEST:
+			/* If we had an ILLEGAL REQUEST returned, then
+			 * we may have performed an unsupported
+			 * command.  The only thing this should be
+			 * would be a ten byte read where only a six
+			 * byte read was supported.  Also, on a system
+			 * where READ CAPACITY failed, we may have
+			 * read past the end of the disk.
+			 */
+			if ((cmd->device->use_10_for_rw &&
+			    sshdr->asc == 0x20 && sshdr->ascq == 0x00) &&
+			    (cmd->cmnd[0] == READ_10 ||
+			     cmd->cmnd[0] == WRITE_10)) {
+				/* This will issue a new 6-byte command. */
+				cmd->device->use_10_for_rw = 0;
+				action = ACTION_REPREP;
+			} else if (sshdr->asc == 0x10) /* DIX */ {
+				error = -EILSEQ;
+			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
+			} else if (sshdr->asc == 0x20 || sshdr->asc == 0x24) {
+				error = -EREMOTEIO;
+			}
+			break;
+		case ABORTED_COMMAND:
+			if (sshdr->asc == 0x10) /* DIF */
+				error = -EILSEQ;
+			break;
+		case NOT_READY:
+			/* If the device is in the process of becoming
+			 * ready, or has a temporary blockage, retry.
+			 */
+			if (sshdr->asc == 0x04) {
+				switch (sshdr->ascq) {
+				case 0x01: /* becoming ready */
+				case 0x04: /* format in progress */
+				case 0x05: /* rebuild in progress */
+				case 0x06: /* recalculation in progress */
+				case 0x07: /* operation in progress */
+				case 0x08: /* Long write in progress */
+				case 0x09: /* self test in progress */
+				case 0x14: /* space allocation in progress */
+					action = ACTION_DELAYED_RETRY;
+					break;
+				default:
+					break;
+				}
+			}
+			break;
+		case VOLUME_OVERFLOW:
+			/* See SSC3rXX or current. */
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (action != ACTION_FAIL &&
+	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies))
+		action = ACTION_FAIL;
+
+	switch (action) {
+	case ACTION_FAIL:
+		/* Give up and fail the remainder of the request */
+		if (!(req->cmd_flags & REQ_QUIET)) {
+			scsi_print_result(cmd);
+			if (driver_byte(result) & DRIVER_SENSE)
+				scsi_print_sense("", cmd);
+			scsi_print_command(cmd);
+		}
+		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
+			break;
+		/*FALLTHRU*/
+	case ACTION_REPREP:
+		return false;
+	case ACTION_RETRY:
+		/* Retry the same command immediately */
+		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, 0);
+		break;
+	case ACTION_DELAYED_RETRY:
+		/* Retry the same command after a delay */
+		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
+		break;
+	}
+
+	return true;
+}
+
 /*
  * Function:    scsi_io_completion()
  *
@@ -779,9 +905,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
-	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-	      ACTION_DELAYED_RETRY} action;
-	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -867,7 +990,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	/*
 	 * If we finished all bytes in the request we are done now.
 	 */
-	if (!scsi_end_request(req, error, good_bytes, 0))
+	if (likely(!scsi_end_request(req, error, good_bytes, 0)))
 		return;
 
 	/*
@@ -880,132 +1003,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	/*
-	 * If there had been no error, but we have leftover bytes in the
-	 * requeues just queue the command up again.
+	 * Try to handle errors if we got a non-zero result.
 	 */
-	if (result == 0)
-		goto requeue;
-
-	error = __scsi_error_from_host_byte(cmd, result);
-
-	if (host_byte(result) == DID_RESET) {
-		/* Third party bus reset or reset for error recovery
-		 * reasons.  Just retry the command and see what
-		 * happens.
-		 */
-		action = ACTION_RETRY;
-	} else if (sense_valid && !sense_deferred) {
-		switch (sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (cmd->device->removable) {
-				/* Detected disc change.  Set a bit
-				 * and quietly refuse further access.
-				 */
-				cmd->device->changed = 1;
-				action = ACTION_FAIL;
-			} else {
-				/* Must have been a power glitch, or a
-				 * bus reset.  Could not have been a
-				 * media change, so we just retry the
-				 * command and see what happens.
-				 */
-				action = ACTION_RETRY;
-			}
-			break;
-		case ILLEGAL_REQUEST:
-			/* If we had an ILLEGAL REQUEST returned, then
-			 * we may have performed an unsupported
-			 * command.  The only thing this should be
-			 * would be a ten byte read where only a six
-			 * byte read was supported.  Also, on a system
-			 * where READ CAPACITY failed, we may have
-			 * read past the end of the disk.
-			 */
-			if ((cmd->device->use_10_for_rw &&
-			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
-			    (cmd->cmnd[0] == READ_10 ||
-			     cmd->cmnd[0] == WRITE_10)) {
-				/* This will issue a new 6-byte command. */
-				cmd->device->use_10_for_rw = 0;
-				action = ACTION_REPREP;
-			} else if (sshdr.asc == 0x10) /* DIX */ {
-				action = ACTION_FAIL;
-				error = -EILSEQ;
-			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
-				action = ACTION_FAIL;
-				error = -EREMOTEIO;
-			} else
-				action = ACTION_FAIL;
-			break;
-		case ABORTED_COMMAND:
-			action = ACTION_FAIL;
-			if (sshdr.asc == 0x10) /* DIF */
-				error = -EILSEQ;
-			break;
-		case NOT_READY:
-			/* If the device is in the process of becoming
-			 * ready, or has a temporary blockage, retry.
-			 */
-			if (sshdr.asc == 0x04) {
-				switch (sshdr.ascq) {
-				case 0x01: /* becoming ready */
-				case 0x04: /* format in progress */
-				case 0x05: /* rebuild in progress */
-				case 0x06: /* recalculation in progress */
-				case 0x07: /* operation in progress */
-				case 0x08: /* Long write in progress */
-				case 0x09: /* self test in progress */
-				case 0x14: /* space allocation in progress */
-					action = ACTION_DELAYED_RETRY;
-					break;
-				default:
-					action = ACTION_FAIL;
-					break;
-				}
-			} else
-				action = ACTION_FAIL;
-			break;
-		case VOLUME_OVERFLOW:
-			/* See SSC3rXX or current. */
-			action = ACTION_FAIL;
-			break;
-		default:
-			action = ACTION_FAIL;
-			break;
-		}
-	} else
-		action = ACTION_FAIL;
-
-	if (action != ACTION_FAIL &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies))
-		action = ACTION_FAIL;
-
-	switch (action) {
-	case ACTION_FAIL:
-		/* Give up and fail the remainder of the request */
-		if (!(req->cmd_flags & REQ_QUIET)) {
-			scsi_print_result(cmd);
-			if (driver_byte(result) & DRIVER_SENSE)
-				scsi_print_sense("", cmd);
-			scsi_print_command(cmd);
-		}
-		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
+	if (result != 0) {
+		if (scsi_handle_ioerror(cmd, result,
+				sense_valid && !sense_deferred ? &sshdr : NULL))
 			return;
-		/*FALLTHRU*/
-	case ACTION_REPREP:
-	requeue:
-		scsi_requeue_command(cmd);
-		break;
-	case ACTION_RETRY:
-		/* Retry the same command immediately */
-		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, 0);
-		break;
-	case ACTION_DELAYED_RETRY:
-		/* Retry the same command after a delay */
-		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
-		break;
 	}
+
+	/*
+	 * Queue up the leftovers again.
+	 */
+	scsi_requeue_command(cmd);
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
-- 
1.9.1

