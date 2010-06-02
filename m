From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6/7] SCSI: simplify scsi_error_handler()
Date: Wed, 2 Jun 2010 16:37:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021618190.1330-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58695 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027Ab0FBUhK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:37:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1360) improves the scsi_error_handler() routine by
removing two occurrences of set_current_state().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -1734,21 +1734,24 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
 
-	/*
-	 * We use TASK_INTERRUPTIBLE so that the thread is not
-	 * counted against the load average as a running process.
-	 * We never actually get interrupted because kthread_run
-	 * disables signal delivery for the created thread.
-	 */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
+	for (;;) {
+		/*
+		 * We use TASK_INTERRUPTIBLE so that the thread is not
+		 * counted against the load average as a running process.
+		 * We never actually get interrupted because kthread_run
+		 * disables signal delivery for the created thread.
+		 */
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk("Error handler scsi_eh_%d sleeping\n",
 					shost->host_no));
 			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
 		}
 
@@ -1775,9 +1778,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	__set_current_state(TASK_RUNNING);
 
 	SCSI_LOG_ERROR_RECOVERY(1,
 		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));

