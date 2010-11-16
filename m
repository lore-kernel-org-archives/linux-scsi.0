From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: fix minor bug in scsi_error_handler
Date: Tue, 16 Nov 2010 11:26:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1011161125020.1597-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56312 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754408Ab0KPQ0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 11:26:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1360b) fixes a small bug in scsi_error_handler(): If for
any reason the scsi_autopm_get_host() call should fail, the thread's
state doesn't get set back to TASK_INTERRUPTIBLE.  The routine will
run through its main loop an extra time instead of going straight to
sleep.

Rather than adding yet another set_current_state() call, the patch
shrinks the scsi_error_handler() routine by moving an existing
set_current_state() call inside the loop where it really ought to be,
removing two other calls in the process.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: stable@kernel.org

---

Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -1744,21 +1744,22 @@ int scsi_error_handler(void *data)
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
+		if (kthread_should_stop())
+			break;
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk("Error handler scsi_eh_%d sleeping\n",
 					shost->host_no));
 			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
 		}
 
@@ -1794,7 +1795,6 @@ int scsi_error_handler(void *data)
 		 */
 		scsi_restart_operations(shost);
 		scsi_autopm_put_host(shost);
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
 

