From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] SCSI: simplify scsi_io_completion()
Date: Wed, 26 Nov 2008 13:02:43 -0600
Message-ID: <1227726163.3387.27.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0811031553530.2186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51377 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYKZTCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 14:02:47 -0500
In-Reply-To: <Pine.LNX.4.44L0.0811031553530.2186-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2008-11-03 at 15:56 -0500, Alan Stern wrote:
> This patch (as1142b) consolidates a lot of repetitious code in
> scsi_io_completion().  It also fixes a few comments.  Most
> importantly, however, it clearly distinguishes among the three sorts
> of retries that can be done when a command fails to complete:
> 
> 	Unprepare the request and resubmit it, so that a new
> 	command will be created for it.
> 
> 	Requeue the request directly so that it will be retried
> 	immediately using the same command.
> 
> 	Requeue the request so that it will be retried following
> 	a short delay.
> 
> 	Complete the remainder of the request with an I/O error.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

OK, how about this as an update to the patch.  It corrects several
things:

     1. For several error conditions, we would now print the sense twice
        in slightly different ways, so unify the location of sense
        printing.
     2. I added more descriptions to actual failure conditions for
        better debugging
     3. according to spec, ABORTED_COMMAND is supposed to be retried
        (except on DIF failure).  Our old behaviour of erroring it looks
        to be a bug.
     4. I'd prefer not to default initialise the action variable because
        that ensures that every leg of the error handler has an
        associated action and the compiler will warn if someone later
        accidentally misses one or removes one.

It also looks like 

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6994cde..4eaace8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -906,7 +906,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-			ACTION_DELAYED_RETRY} action;
+	      ACTION_DELAYED_RETRY} action;
+	char *description = NULL;
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -957,7 +958,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 	this_count = blk_rq_bytes(req);
-	action = ACTION_FAIL;
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
@@ -973,6 +973,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
+				description = "Media Changed";
+				action = ACTION_FAIL;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
@@ -998,9 +1000,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				/* This will issue a new 6-byte command. */
 				cmd->device->use_10_for_rw = 0;
 				action = ACTION_REPREP;
-			}
+			} else
+				action = ACTION_FAIL;
 			break;
 		case ABORTED_COMMAND:
+			if (sshdr.asc == 0x10) { /* DIF */
+				action = ACTION_FAIL;
+				description = "Data Integrity Failure";
+			} else
+				action = ACTION_RETRY;
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
@@ -1018,34 +1026,36 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 					action = ACTION_DELAYED_RETRY;
 					break;
 				}
+			} else {
+				description = "Device not ready";
+				action = ACTION_FAIL;
 			}
-			if (!(req->cmd_flags & REQ_QUIET) &&
-					action == ACTION_FAIL)
-				scsi_cmd_print_sense_hdr(cmd,
-							 "Device not ready",
-							 &sshdr);
 			break;
 		case VOLUME_OVERFLOW:
-			if (!(req->cmd_flags & REQ_QUIET)) {
-				scmd_printk(KERN_INFO, cmd,
-					    "Volume overflow, CDB: ");
-				__scsi_print_command(cmd->cmnd);
-				scsi_print_sense("", cmd);
-			}
+			description = "Volume Overflow";
 			/* See SSC3rXX or current. */
+			action = ACTION_FAIL;
+			break;
+		default:
+			description = "Unhandled sense code";
+			action = ACTION_FAIL;
 			break;
 		}
+	} else {
+		description = "Unhandled error code";
+		action = ACTION_FAIL;
 	}
 
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
-		if (result) {
-			if (!(req->cmd_flags & REQ_QUIET)) {
-				scsi_print_result(cmd);
-				if (driver_byte(result) & DRIVER_SENSE)
-					scsi_print_sense("", cmd);
-			}
+		if (!(req->cmd_flags & REQ_QUIET)) {
+			if (description)
+				scmd_printk(KERN_INFO, cmd, "%s",
+					    description);
+			scsi_print_result(cmd);
+			if (driver_byte(result) & DRIVER_SENSE)
+				scsi_print_sense("", cmd);
 		}
 		blk_end_request(req, -EIO, blk_rq_bytes(req));
 		scsi_next_command(cmd);


