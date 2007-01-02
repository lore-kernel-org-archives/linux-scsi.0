From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill scsi_rety_command
Date: Tue, 2 Jan 2007 12:56:00 +0100
Message-ID: <20070102115600.GA6909@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45168 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825AbXABMRv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 07:17:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

scsi_retry_command only has a single caller, so there is no point
in having this function.  Additionally the memset of the sense
buffer it does is entirely superflous as scsi_request_fn already
calls scsi_init_cmd_errh to perform this memset before the command
is reissued.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c	2007-01-02 12:34:46.000000000 +0100
+++ linux-2.6/drivers/scsi/scsi.c	2007-01-02 12:35:46.000000000 +0100
@@ -673,27 +673,6 @@
 }
 
 /*
- * Function:    scsi_retry_command
- *
- * Purpose:     Send a command back to the low level to be retried.
- *
- * Notes:       This command is always executed in the context of the
- *              bottom half handler, or the error handler thread. Low
- *              level drivers should not become re-entrant as a result of
- *              this.
- */
-int scsi_retry_command(struct scsi_cmnd *cmd)
-{
-        /*
-         * Zero the sense information from the last time we tried
-         * this command.
-         */
-	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
-
-	return scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
-}
-
-/*
  * Function:    scsi_finish_command
  *
  * Purpose:     Pass command off to upper layer for finishing of I/O
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2007-01-02 12:34:46.000000000 +0100
+++ linux-2.6/drivers/scsi/scsi_lib.c	2007-01-02 12:36:58.000000000 +0100
@@ -1400,7 +1400,7 @@
 			scsi_finish_command(cmd);
 			break;
 		case NEEDS_RETRY:
-			scsi_retry_command(cmd);
+			scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
 			break;
 		case ADD_TO_MLQUEUE:
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h	2007-01-02 12:34:46.000000000 +0100
+++ linux-2.6/drivers/scsi/scsi_priv.h	2007-01-02 12:35:51.000000000 +0100
@@ -28,7 +28,6 @@
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 extern void __scsi_done(struct scsi_cmnd *cmd);
-extern int scsi_retry_command(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
