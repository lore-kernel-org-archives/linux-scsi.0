From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill scsi_cmnd.flags
Date: Sat, 20 Sep 2003 10:36:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920083639.GE20301@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:46829 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261762AbTITIgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 04:36:42 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This was only used by the old error handling, the new code uses .eh_state
and .eh_eflags instead.


diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sat Sep 20 09:36:20 2003
+++ b/drivers/scsi/scsi.c	Sat Sep 20 09:36:20 2003
@@ -497,7 +497,6 @@
 	cmd->serial_number_at_timeout = 0;
 	cmd->bufflen = sreq->sr_bufflen;
 	cmd->buffer = sreq->sr_buffer;
-	cmd->flags = 0;
 	cmd->retries = 0;
 	cmd->allowed = sreq->sr_allowed;
 	cmd->done = sreq->sr_done;
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Sat Sep 20 09:36:20 2003
+++ b/drivers/scsi/scsi.h	Sat Sep 20 09:36:20 2003
@@ -124,27 +124,6 @@
 #define SCSI_2          3
 #define SCSI_3          4
 
-/*
- *  Every SCSI command starts with a one byte OP-code.
- *  The next byte's high three bits are the LUN of the
- *  device.  Any multi-byte quantities are stored high byte
- *  first, and may have a 5 bit MSB in the same byte
- *  as the LUN.
- */
-
-/*
- *  As the scsi do command functions are intelligent, and may need to
- *  redo a command, we need to keep track of the last command
- *  executed on each one.
- */
-
-#define WAS_RESET       0x01
-#define WAS_TIMEDOUT    0x02
-#define WAS_SENSE       0x04
-#define IS_RESETTING    0x08
-#define IS_ABORTING     0x10
-#define ASKED_FOR_SENSE 0x20
-#define SYNC_RESET      0x40
 
 struct Scsi_Host;
 struct scsi_cmnd;
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Sat Sep 20 09:36:20 2003
+++ b/drivers/scsi/scsi_error.c	Sat Sep 20 09:36:20 2003
@@ -323,17 +323,6 @@
 	 * that would indicate what we need to do.
 	 */
 	if (host_byte(scmd->result) == DID_RESET) {
-		if (scmd->flags & IS_RESETTING) {
-			/*
-			 * ok, this is normal.  we don't know whether in fact
-			 * the command in question really needs to be rerun
-			 * or not - if this was the original data command then
-			 * the answer is yes, otherwise we just flag it as
-			 * SUCCESS.
-			 */
-			scmd->flags &= ~IS_RESETTING;
-			return NEEDS_RETRY;
-		}
 		/*
 		 * rats.  we are already in the error handler, so we now
 		 * get to try and figure out what to do next.  if the sense
@@ -1217,14 +1206,6 @@
 			return FAILED;
 		}
 	case DID_RESET:
-		/*
-		 * in the normal case where we haven't initiated a reset,
-		 * this is a failure.
-		 */
-		if (scmd->flags & IS_RESETTING) {
-			scmd->flags &= ~IS_RESETTING;
-			goto maybe_retry;
-		}
 		return SUCCESS;
 	default:
 		return FAILED;
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Sat Sep 20 09:36:20 2003
+++ b/drivers/scsi/scsi_lib.c	Sat Sep 20 09:36:20 2003
@@ -260,7 +260,6 @@
 	cmd->owner = SCSI_OWNER_MIDLEVEL;
 	cmd->serial_number = 0;
 	cmd->serial_number_at_timeout = 0;
-	cmd->flags = 0;
 	cmd->abort_reason = 0;
 
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
diff -Nru a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Sat Sep 20 09:36:20 2003
+++ b/include/scsi/scsi_cmnd.h	Sat Sep 20 09:36:20 2003
@@ -118,8 +118,6 @@
 						 * received on original command 
 						 * (auto-sense) */
 
-	unsigned flags;
-
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
 	void (*scsi_done) (struct scsi_cmnd *);
