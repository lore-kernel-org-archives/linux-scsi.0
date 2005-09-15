From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix thread termination for the SCSI error handler
Date: Thu, 15 Sep 2005 15:29:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509151524000.4493-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42635 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965267AbVIOT3a
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 15:29:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as561) fixes the error handler's thread-exit code.  The 
kthread_stop call won't wake the thread from a down_interruptible, so 
the patch gets rid of the semaphore and simply does

	set_current_state(TASK_INTERRUPTIBLE);

Can you please check that the

	if (shost->host_busy == shost->host_failed ...

condition for waking up is really correct?  Thanks.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -50,7 +50,7 @@
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
 	if (shost->host_busy == shost->host_failed) {
-		up(shost->eh_wait);
+		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
 	}
@@ -69,9 +69,6 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 
-	if (shost->eh_wait == NULL)
-		return 0;
-
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	scmd->eh_eflags |= eh_flag;
@@ -1582,37 +1579,33 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = (struct Scsi_Host *) data;
 	int rtn;
-	DECLARE_MUTEX_LOCKED(sem);
 
 	current->flags |= PF_NOFREEZE;
-	shost->eh_wait = &sem;
-
-	/*
-	 * Wake up the thread that created us.
-	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
-					  " scsi_eh_%d\n",shost->host_no));
 
 	while (1) {
-		/*
-		 * If we get a signal, it means we are supposed to go
-		 * away and die.  This typically happens if the user is
-		 * trying to unload a module.
-		 */
 		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
 						  " scsi_eh_%d"
 						  " sleeping\n",shost->host_no));
 
 		/*
-		 * Note - we always use down_interruptible with the semaphore
-		 * even if the module was loaded as part of the kernel.  The
-		 * reason is that down() will cause this thread to be counted
-		 * in the load average as a running process, and down
-		 * interruptible doesn't.  Given that we need to allow this
-		 * thread to die if the driver was loaded as a module, using
-		 * semaphores isn't unreasonable.
-		 */
-		down_interruptible(&sem);
+		 * Note - we always use TASK_INTERRUPTIBLE even if the
+		 * module was loaded as part of the kernel.  The reason
+		 * is that UNINTERRUPTIBLE would cause this thread to be
+		 * counted in the load average as a running process, and
+		 * an interruptible wait doesn't.
+		 */
+		for (;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (shost->host_busy == shost->host_failed ||
+					kthread_should_stop()) {
+				set_current_state(TASK_RUNNING);
+				break;
+			}
+
+			/* Even though we are INTERRUPTIBLE, ignore signals */
+			flush_signals(current);
+			schedule();
+		}
 		if (kthread_should_stop())
 			break;
 
@@ -1648,10 +1641,6 @@ int scsi_error_handler(void *data)
 	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
 					  " exiting\n",shost->host_no));
 
-	/*
-	 * Make sure that nobody tries to wake us up again.
-	 */
-	shost->eh_wait = NULL;
 	return 0;
 }
 
Index: usb-2.6/include/scsi/scsi_host.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_host.h
+++ usb-2.6/include/scsi/scsi_host.h
@@ -465,8 +465,6 @@ struct Scsi_Host {
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct semaphore      * eh_wait;   /* The error recovery thread waits
-					      on this. */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
 	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if

