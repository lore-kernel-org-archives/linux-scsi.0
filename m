From: Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 1/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 19:11:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912191152.A4739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17pYRW-0005B1-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:11:54 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17pYRU-0001Ko-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:11:52 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been chasing a few SCSI problems today, and here's 4 patches to
address the issues I found.  These patches are against 2.4.19.

My main aim here was to solve the bad behaviour with a medium error.
Some problems were found in my HBA driver, but some were found in
the error handling code.

Problems found were:

a) retrying a command with stale or invalid command information.
   (Patches 1 and 2)
b) reporting the wrong command on IO error.
   (Patch 3)
c) drives behaving badly in error condition, reporting success without
   data transfer.
   (Patch 4)

Results of investigation into these issues can be found at in my lkml
messages at:

  http://marc.theaimsgroup.com/?l=linux-kernel&m=103184937214222&w=2

Patch 4 is the one I'm least happy about; we shouldn't unconditionally
set the FUA bit in READ10 commands.  It seems that we need to set this
bit only after receiving an error, and only when we try to read the
remaining blocks which we believe are good.

Patch 1: scsi_eh_retry_command

--- orig/drivers/scsi/scsi.c	Thu Sep 12 17:57:59 2002
+++ linux/drivers/scsi/scsi.c	Thu Sep 12 17:59:59 2002
@@ -1330,14 +1330,10 @@
  */
 int scsi_retry_command(Scsi_Cmnd * SCpnt)
 {
-	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
-	       sizeof(SCpnt->data_cmnd));
-	SCpnt->request_buffer = SCpnt->buffer;
-	SCpnt->request_bufflen = SCpnt->bufflen;
-	SCpnt->use_sg = SCpnt->old_use_sg;
-	SCpnt->cmd_len = SCpnt->old_cmd_len;
-	SCpnt->sc_data_direction = SCpnt->sc_old_data_direction;
-	SCpnt->underflow = SCpnt->old_underflow;
+	/*
+	 * Restore the SCSI command state.
+	 */
+	scsi_setup_cmd_retry(SCpnt);
 
         /*
          * Zero the sense information from the last time we tried
--- orig/drivers/scsi/scsi.h	Thu Sep 12 17:57:35 2002
+++ linux/drivers/scsi/scsi.h	Thu Sep 12 18:00:03 2002
@@ -474,6 +474,7 @@
 				   int sectors);
 extern struct Scsi_Device_Template *scsi_get_request_dev(struct request *);
 extern int scsi_init_cmd_errh(Scsi_Cmnd * SCpnt);
+extern void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt);
 extern int scsi_insert_special_cmd(Scsi_Cmnd * SCpnt, int);
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
 			       int block_sectors);
--- orig/drivers/scsi/scsi_error.c	Thu Sep 12 17:58:44 2002
+++ linux/drivers/scsi/scsi_error.c	Thu Sep 12 18:00:10 2002
@@ -385,15 +385,7 @@
  */
 STATIC int scsi_eh_retry_command(Scsi_Cmnd * SCpnt)
 {
-	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
-	       sizeof(SCpnt->data_cmnd));
-	SCpnt->request_buffer = SCpnt->buffer;
-	SCpnt->request_bufflen = SCpnt->bufflen;
-	SCpnt->use_sg = SCpnt->old_use_sg;
-	SCpnt->cmd_len = SCpnt->old_cmd_len;
-	SCpnt->sc_data_direction = SCpnt->sc_old_data_direction;
-	SCpnt->underflow = SCpnt->old_underflow;
-
+	scsi_setup_cmd_retry(SCpnt);
 	scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
 
 	/*
--- orig/drivers/scsi/scsi_lib.c	Thu Sep 12 17:56:21 2002
+++ linux/drivers/scsi/scsi_lib.c	Thu Sep 12 18:00:15 2002
@@ -208,6 +208,30 @@
 }
 
 /*
+ * Function:	scsi_setup_cmd_retry()
+ *
+ * Purpose:	Restore the command state for a retry
+ *
+ * Arguments:	SCpnt	- command to be restored
+ *
+ * Returns:	Nothing
+ *
+ * Notes:	Immediately prior to retrying a command, we need
+ *		to restore certain fields that we saved above.
+ */
+void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt)
+{
+	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
+	       sizeof(SCpnt->data_cmnd));
+	SCpnt->request_buffer = SCpnt->buffer;
+	SCpnt->request_bufflen = SCpnt->bufflen;
+	SCpnt->use_sg = SCpnt->old_use_sg;
+	SCpnt->cmd_len = SCpnt->old_cmd_len;
+	SCpnt->sc_data_direction = SCpnt->sc_old_data_direction;
+	SCpnt->underflow = SCpnt->old_underflow;
+}
+
+/*
  * Function:    scsi_queue_next_request()
  *
  * Purpose:     Handle post-processing of completed commands.


-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

