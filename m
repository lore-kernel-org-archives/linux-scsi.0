From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 20 Jan 2004 14:20:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120132052.GA6740@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:57520 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265477AbUATNVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 08:21:03 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, gibbs@scsiguy.com
Cc: linux-scsi@vger.kernel.org

We all know talk is cheap, so here's a first draft patch to allow LLDDs
to get control first after a command timeout.  Justin, does this look
okay for you?  BTW, your drivers are the last ones using scsi_add_timer
from outside the midlayer, if we could get rid of that we'd be able to
keep the interface private.


===== drivers/scsi/scsi.c 1.134 vs edited =====
--- 1.134/drivers/scsi/scsi.c	Sat Jan 10 21:37:37 2004
+++ edited/drivers/scsi/scsi.c	Tue Jan 20 14:18:51 2004
@@ -484,6 +484,28 @@
 }
 #endif
 
+/**
+ * scsi_times_out - Timeout handler for normal scsi commands.
+ * @scmd:	Cmd that is timing out.
+ *
+ * Notes:
+ *     We do not need to lock this.  There is the potential for a race
+ *     only in that the normal completion handling might run, but if the
+ *     normal completion function determines that the timer has already
+ *     fired, then it mustn't do anything.
+ */
+static void scsi_times_out(struct scsi_cmnd *scmd)
+{
+	scsi_log_completion(scmd, TIMEOUT_ERROR);
+
+	if (scmd->device->host->hostt->eh_timeout) {
+		scmd->device->host->hostt->eh_timeout(scmd);
+	} else if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
+		panic("Error handler thread not present at %p %p %s %d",
+		      scmd, scmd->device->host, __FILE__, __LINE__);
+	}
+}
+
 /*
  * Function:    scsi_dispatch_command
  *
===== drivers/scsi/scsi_error.c 1.69 vs edited =====
--- 1.69/drivers/scsi/scsi_error.c	Thu Jan 15 23:14:40 2004
+++ edited/drivers/scsi/scsi_error.c	Tue Jan 20 14:18:56 2004
@@ -153,25 +153,6 @@
 }
 
 /**
- * scsi_times_out - Timeout function for normal scsi commands.
- * @scmd:	Cmd that is timing out.
- *
- * Notes:
- *     We do not need to lock this.  There is the potential for a race
- *     only in that the normal completion handling might run, but if the
- *     normal completion function determines that the timer has already
- *     fired, then it mustn't do anything.
- **/
-void scsi_times_out(struct scsi_cmnd *scmd)
-{
-	scsi_log_completion(scmd, TIMEOUT_ERROR);
-	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
-		panic("Error handler thread not present at %p %p %s %d",
-		      scmd, scmd->device->host, __FILE__, __LINE__);
-	}
-}
-
-/**
  * scsi_block_when_processing_errors - Prevent cmds from being queued.
  * @sdev:	Device on which we are performing recovery.
  *
===== drivers/scsi/scsi_priv.h 1.30 vs edited =====
--- 1.30/drivers/scsi/scsi_priv.h	Mon Sep 29 14:37:28 2003
+++ edited/drivers/scsi/scsi_priv.h	Tue Jan 20 14:17:30 2004
@@ -100,11 +100,9 @@
 extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
-extern void scsi_times_out(struct scsi_cmnd *cmd);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
-extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
===== include/scsi/scsi_eh.h 1.1 vs edited =====
--- 1.1/include/scsi/scsi_eh.h	Mon Jun  9 00:03:00 2003
+++ edited/include/scsi/scsi_eh.h	Tue Jan 20 14:17:27 2004
@@ -4,6 +4,7 @@
 extern void scsi_add_timer(struct scsi_cmnd *, int,
 			   void (*)(struct scsi_cmnd *));
 extern int scsi_delete_timer(struct scsi_cmnd *);
+extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
===== include/scsi/scsi_host.h 1.13 vs edited =====
--- 1.13/include/scsi/scsi_host.h	Wed Nov 12 15:15:46 2003
+++ edited/include/scsi/scsi_host.h	Tue Jan 20 14:11:46 2004
@@ -125,6 +125,11 @@
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
 	/*
+	 * Timeout handler.  Optional.
+	 */
+	void (* eh_timeout)(struct scsi_cmnd *);
+
+	/*
 	 * Old EH handlers, no longer used. Make them warn the user of old
 	 * drivers by using a wrong type
 	 *
