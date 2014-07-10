From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH V3] scsi_lib: remove the description string in scsi_io_completion()
Date: Thu, 10 Jul 2014 09:41:53 +0200
Message-ID: <1404978113-3693-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGJHmW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 03:42:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, Elliott@hp.com

During IO with fabric faults, one generally sees several "Unhandled error
code" messages in the syslog as shown below:

sd 4:0:6:2: [sdbw] Unhandled error code
sd 4:0:6:2: [sdbw] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 4:0:6:2: [sdbw] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sdbw, sector 0

This comes from scsi_io_completion (in scsi_lib.c) while handling error
codes other than DID_RESET or not deferred sense keys i.e. this is
actually handled by the SCSI mid layer. But what gets displayed here is
"Unhandled error code" which is quite misleading as it indicates
something that is not addressed by the mid layer.

The description string is based on the sense key and sometimes on the
additional sense code;
since the ACTION_FAIL case always prints the sense key and the
additional sense code, this patch removes the description string
completely because it does not add useful information.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_lib.c | 40 ++++------------------------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..e953b9b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -686,7 +686,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_deferred = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
-	char *description = NULL;
 	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
 
 	if (result) {
@@ -803,7 +802,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				description = "Media Changed";
 				action = ACTION_FAIL;
 			} else {
 				/* Must have been a power glitch, or a
@@ -831,27 +829,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				cmd->device->use_10_for_rw = 0;
 				action = ACTION_REPREP;
 			} else if (sshdr.asc == 0x10) /* DIX */ {
-				description = "Host Data Integrity Failure";
 				action = ACTION_FAIL;
 				error = -EILSEQ;
 			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
 			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
-				switch (cmd->cmnd[0]) {
-				case UNMAP:
-					description = "Discard failure";
-					break;
-				case WRITE_SAME:
-				case WRITE_SAME_16:
-					if (cmd->cmnd[1] & 0x8)
-						description = "Discard failure";
-					else
-						description =
-							"Write same failure";
-					break;
-				default:
-					description = "Invalid command failure";
-					break;
-				}
 				action = ACTION_FAIL;
 				error = -EREMOTEIO;
 			} else
@@ -859,10 +840,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			break;
 		case ABORTED_COMMAND:
 			action = ACTION_FAIL;
-			if (sshdr.asc == 0x10) { /* DIF */
-				description = "Target Data Integrity Failure";
+			if (sshdr.asc == 0x10) /* DIF */
 				error = -EILSEQ;
-			}
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
@@ -881,42 +860,31 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 					action = ACTION_DELAYED_RETRY;
 					break;
 				default:
-					description = "Device not ready";
 					action = ACTION_FAIL;
 					break;
 				}
-			} else {
-				description = "Device not ready";
+			} else
 				action = ACTION_FAIL;
-			}
 			break;
 		case VOLUME_OVERFLOW:
 			/* See SSC3rXX or current. */
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
 			action = ACTION_FAIL;
 			break;
 		}
-	} else {
-		description = "Unhandled error code";
+	} else
 		action = ACTION_FAIL;
-	}
 
 	if (action != ACTION_FAIL &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies))
 		action = ACTION_FAIL;
-		description = "Command timed out";
-	}
 
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		if (!(req->cmd_flags & REQ_QUIET)) {
-			if (description)
-				scmd_printk(KERN_INFO, cmd, "%s\n",
-					    description);
 			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
-- 
Maurizio Lombardi

