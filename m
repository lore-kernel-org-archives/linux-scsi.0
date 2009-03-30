From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] fix recovered error handling
Date: Mon, 30 Mar 2009 16:55:51 +0000
Message-ID: <1238432151.25357.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40920 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbZC3RCk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2009 13:02:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>

We have a problem with recovered error handling in that any command
which goes down as BLOCK_PC but which returns a sense code of RECOVERED
ERROR gets completed with -EIO.  For actual SG_IO commands, this doesn't
matter at all, since the error return code gets dropped in favour of
req->errors which contain the SCSI completion code.

However, if this command is part of the block system, then it will pay
attention to the returned error code.  In particularly if a SYNCHRONIZE
CACHE from a barrier command completes with RECOVERED ERROR, the
resulting -EIO on the barrier causes block to error the request and
return it to the filesystem.  Fix this by converting the -EIO for
recovered error to zero, plus remove the printing of this from sd and sr
so the message isn't double printed.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4b13e36..ec94652 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -791,6 +791,20 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
 
+	/*
+	 * Recovered errors need reporting, but they're always treated
+	 * as success, so fiddle the result code here.  For BLOCK_PC
+	 * we already took a copy of the original into rq->errors which
+	 * is what gets returned to the user
+	 */
+	if (sense_valid && sshdr.sense_key == RECOVERED_ERROR) {
+		if (!(req->cmd_flags & REQ_QUIET))
+			scsi_print_sense("", cmd);
+		result = 0;
+		/* BLOCK_PC may have set error */
+		error = 0;
+	}
+	
 	/* A number of bytes were successfully read.  If there
 	 * are leftovers and there is some kind of error
 	 * (result != 0), retry the rest.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aeab5d9..3fcb64b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1051,12 +1051,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case RECOVERED_ERROR:
-		/* Inform the user, but make sure that it's not treated
-		 * as a hard error.
-		 */
-		scsi_print_sense("sd", SCpnt);
-		SCpnt->result = 0;
-		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		good_bytes = scsi_bufflen(SCpnt);
 		break;
 	case NO_SENSE:
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e7fa3ca..0e1a0f2 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -309,15 +309,6 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 			break;
 
 		case RECOVERED_ERROR:
-
-			/*
-			 * An error occured, but it recovered.  Inform the
-			 * user, but make sure that it's not treated as a
-			 * hard error.
-			 */
-			scsi_print_sense("sr", SCpnt);
-			SCpnt->result = 0;
-			SCpnt->sense_buffer[0] = 0x0;
 			good_bytes = this_count;
 			break;
 


