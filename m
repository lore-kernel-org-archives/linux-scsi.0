From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] update commands and trace statemenets in scsi_error_handler
Date: Wed, 7 Sep 2005 15:52:19 +0200
Message-ID: <20050907135219.GB16340@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39072 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932145AbVIGNwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 09:52:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

There are lots of comments that are either outdated, slightly wrong or
stating the obvious.  Also remove a useless trace statement and reformat
the others to be more easily readable.

Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2005-09-07 14:22:58.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2005-09-07 14:29:14.000000000 +0200
@@ -1566,57 +1566,39 @@
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
 	DECLARE_MUTEX_LOCKED(sem);
 
 	current->flags |= PF_NOFREEZE;
 	shost->eh_wait = &sem;
 
-	/*
-	 * Wake up the thread that created us.
-	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
-					  " scsi_eh_%d\n",shost->host_no));
-
 	while (!kthread_should_stop()) {
-		/*
-		 * If we get a signal, it means we are supposed to go
-		 * away and die.  This typically happens if the user is
-		 * trying to unload a module.
-		 */
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
-						  " scsi_eh_%d"
-						  " sleeping\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1,
+			printk("Error handler scsi_eh_%d sleeping\n",
+				shost->host_no));
 
 		/*
-		 * Note - we always use down_interruptible with the semaphore
-		 * even if the module was loaded as part of the kernel.  The
-		 * reason is that down() will cause this thread to be counted
-		 * in the load average as a running process, and down
-		 * interruptible doesn't.  Given that we need to allow this
-		 * thread to die if the driver was loaded as a module, using
-		 * semaphores isn't unreasonable.
+		 * We use down_interruptible() so that the thread is not
+		 * counted against the load average as a running process.
+		 * We never actually get interrupted because kthread_run
+		 * disables singal delivery for the create thread.
 		 */
 		down_interruptible(&sem);
 		if (kthread_should_stop())
 			break;
 
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
-						  " scsi_eh_%d waking"
-						  " up\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1,
+			printk("Error handler scsi_eh_%d waking up\n",
+				shost->host_no));
 
 		shost->eh_active = 1;
 
@@ -1626,7 +1608,7 @@
 		 * If we fail, we end up taking the thing offline.
 		 */
 		if (shost->hostt->eh_strategy_handler) 
-			rtn = shost->hostt->eh_strategy_handler(shost);
+			shost->hostt->eh_strategy_handler(shost);
 		else
 			scsi_unjam_host(shost);
 
@@ -1643,12 +1625,9 @@
 
 	}
 
-	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
-					  " exiting\n",shost->host_no));
+	SCSI_LOG_ERROR_RECOVERY(1,
+		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));
 
-	/*
-	 * Make sure that nobody tries to wake us up again.
-	 */
 	shost->eh_wait = NULL;
 	return 0;
 }
