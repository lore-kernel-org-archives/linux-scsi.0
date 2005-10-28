From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] tidy up scsi_error_handler
Date: Sat, 29 Oct 2005 01:01:55 +0200
Message-ID: <20051028230155.GA13083@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:21431 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751896AbVJ1XCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 19:02:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

adjust comments, remove a useless cast and remove a write-only variable.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-10-22 13:25:08.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-10-22 13:33:15.000000000 +0200
@@ -1577,48 +1577,41 @@
 }
 
 /**
- * scsi_error_handler - Handle errors/timeouts of SCSI cmds.
+ * scsi_error_handler - SCSI error handler thread
  * @data:	Host for which we are running.
  *
  * Notes:
- *    This is always run in the context of a kernel thread.  The idea is
- *    that we start this thing up when the kernel starts up (one per host
- *    that we detect), and it immediately goes to sleep and waits for some
- *    event (i.e. failure).  When this takes place, we have the job of
- *    trying to unjam the bus and restarting things.
+ *    This is the main error handling loop.  This is run as a kernel thread
+ *    for every SCSI host and handles all error handling activity.
  **/
 int scsi_error_handler(void *data)
 {
-	struct Scsi_Host *shost = (struct Scsi_Host *) data;
-	int rtn;
+	struct Scsi_Host *shost = data;
 
 	current->flags |= PF_NOFREEZE;
 
-	
 	/*
-	 * Note - we always use TASK_INTERRUPTIBLE even if the module
-	 * was loaded as part of the kernel.  The reason is that
-	 * UNINTERRUPTIBLE would cause this thread to be counted in
-	 * the load average as a running process, and an interruptible
-	 * wait doesn't.
+	 * We use TASK_INTERRUPTIBLE so that the thread is not
+	 * counted against the load average as a running process.
+	 * We never actually get interrupted because kthread_run
+	 * disables singal delivery for the created thread.
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		if (shost->host_failed == 0 ||
 		    shost->host_failed != shost->host_busy) {
-			SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
-							  " scsi_eh_%d"
-							  " sleeping\n",
-							  shost->host_no));
+			SCSI_LOG_ERROR_RECOVERY(1,
+				printk("Error handler scsi_eh_%d sleeping\n",
+					shost->host_no));
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
 		}
 
 		__set_current_state(TASK_RUNNING);
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
-						  " scsi_eh_%d waking"
-						  " up\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1,
+			printk("Error handler scsi_eh_%d waking up\n",
+				shost->host_no));
 
 		shost->eh_active = 1;
 
@@ -1628,7 +1621,7 @@
 		 * If we fail, we end up taking the thing offline.
 		 */
 		if (shost->hostt->eh_strategy_handler) 
-			rtn = shost->hostt->eh_strategy_handler(shost);
+			shost->hostt->eh_strategy_handler(shost);
 		else
 			scsi_unjam_host(shost);
 
@@ -1644,15 +1637,10 @@
 		scsi_restart_operations(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
-
 	__set_current_state(TASK_RUNNING);
 
-	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
-					  " exiting\n",shost->host_no));
-
-	/*
-	 * Make sure that nobody tries to wake us up again.
-	 */
+	SCSI_LOG_ERROR_RECOVERY(1,
+		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));
 	shost->ehandler = NULL;
 	return 0;
 }
