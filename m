From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] Eliminate signals entirely from the mid-layer
Date: Fri, 10 Jan 2003 16:19:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301102119.h0ALJUf05888@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_12226870000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA05902
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2003 13:19:33 -0800
Received: from localhost.localdomain (midgard.sc.steeleye.com [172.17.6.40])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id NAA05765
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2003 13:19:31 -0800
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id h0ALJUf05888
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2003 16:19:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_12226870000
Content-Type: text/plain; charset=us-ascii

the attached patch removes SCSI's use of signals for killing the error handler 
thread.  It also:

- changes the eh_notify semaphore to a completion
- adds complete_and_exit() to the thread
- uses a host structure flag to signal thread death instead of the signal

I'm currently travelling, so could someone test it out for me?  Thanks,

James



--==_Exmh_12226870000
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.947   -> 1.948  
#	drivers/scsi/scsi_error.c	1.26    -> 1.27   
#	drivers/scsi/hosts.c	1.42    -> 1.43   
#	drivers/scsi/hosts.h	1.47    -> 1.48   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/01/10	jejb@mulgrave.(none)	1.948
# remove SCSI's use of signals for killing the error handler thread
# 
# - change the eh_notify semaphore to a completion
# - add complete_and_exit() to the thread
# - use a host structure flag to signal thread death instead of the signal
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Fri Jan 10 16:14:02 2003
+++ b/drivers/scsi/hosts.c	Fri Jan 10 16:14:02 2003
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/completion.h>
 
 #define __KERNEL_SYSCALLS__
 
@@ -335,10 +336,10 @@
 	 * Next, kill the kernel error recovery thread for this host.
 	 */
 	if (shost->ehandler) {
-		DECLARE_MUTEX_LOCKED(sem);
+		DECLARE_COMPLETION(sem);
 		shost->eh_notify = &sem;
-		send_sig(SIGPWR, shost->ehandler, 1);
-		down(&sem);
+		up(shost->eh_wait);
+		wait_for_completion(&sem);
 		shost->eh_notify = NULL;
 	}
 
@@ -368,7 +369,7 @@
 {
 	struct Scsi_Host *shost, *shost_scr;
 	int gfp_mask;
-	DECLARE_MUTEX_LOCKED(sem);
+	DECLARE_COMPLETION(sem);
 
         /* Check to see if this host has any error handling facilities */
         if(shost_tp->eh_strategy_handler == NULL &&
@@ -464,7 +465,7 @@
 	 * Now wait for the kernel error thread to initialize itself
 	 * as it might be needed when we scan the bus.
 	 */
-	down(&sem);
+	wait_for_completion(&sem);
 	shost->eh_notify = NULL;
 
 	shost->hostt->present++;
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Fri Jan 10 16:14:02 2003
+++ b/drivers/scsi/hosts.h	Fri Jan 10 16:14:02 2003
@@ -381,11 +381,12 @@
     struct task_struct    * ehandler;  /* Error recovery thread. */
     struct semaphore      * eh_wait;   /* The error recovery thread waits on
                                           this. */
-    struct semaphore      * eh_notify; /* wait for eh to begin */
+    struct completion     * eh_notify; /* wait for eh to begin or end */
     struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
     unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if
                                           this is true. */
+    unsigned int            eh_kill:1; /* set when killing the eh thread */
     wait_queue_head_t       host_wait;
     Scsi_Host_Template    * hostt;
     atomic_t                host_active; /* commands checked out */
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Fri Jan 10 16:14:02 2003
+++ b/drivers/scsi/scsi_error.c	Fri Jan 10 16:14:02 2003
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
+#include <linux/completion.h>
 
 #define __KERNEL_SYSCALLS__
 
@@ -41,24 +42,6 @@
 
 #include <scsi/scsi_ioctl.h> /* grr */
 
-/*
- * We must always allow SHUTDOWN_SIGS.  Even if we are not a module,
- * the host drivers that we are using may be loaded as modules, and
- * when we unload these,  we need to ensure that the error handler thread
- * can be shut down.
- *
- * Note - when we unload a module, we send a SIGHUP.  We mustn't
- * enable SIGTERM, as this is how the init shuts things down when you
- * go to single-user mode.  For that matter, init also sends SIGKILL,
- * so we mustn't enable that one either.  We use SIGHUP instead.  Other
- * options would be SIGPWR, I suppose.
- *
- * Changed behavior 1/1/2003 - it turns out, that SIGHUP can get sent
- * to error handlers from a process responsible for their creation.
- * To sidestep that issue, we now use SIGPWR as suggested above.
- */
-#define SHUTDOWN_SIGS	(sigmask(SIGPWR))
-
 #ifdef DEBUG
 #define SENSE_TIMEOUT SCSI_TIMEOUT
 #else
@@ -1593,12 +1576,10 @@
 	int rtn;
 	DECLARE_MUTEX_LOCKED(sem);
 
-	/*
-	 * We only listen to signals if the HA was loaded as a module.
-	 * If the HA was compiled into the kernel, then we don't listen
-	 * to any signals.
-	 */
-	siginitsetinv(&current->blocked, SHUTDOWN_SIGS);
+	spin_lock_irq(&current->sig->siglock);
+	sigfillset(&current->blocked);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sig->siglock);
 
 	lock_kernel();
 
@@ -1624,7 +1605,7 @@
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of scsi_eh_%d\n",shost->host_no));
 
-	up(shost->eh_notify);
+	complete(shost->eh_notify);
 
 	while (1) {
 		/*
@@ -1644,7 +1625,7 @@
 		 * semaphores isn't unreasonable.
 		 */
 		down_interruptible(&sem);
-		if (signal_pending(current))
+		if (shost->eh_kill)
 			break;
 
 		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d waking up\n",shost->host_no));
@@ -1695,13 +1676,9 @@
 	/*
 	 * If anyone is waiting for us to exit (i.e. someone trying to unload
 	 * a driver), then wake up that process to let them know we are on
-	 * the way out the door.  This may be overkill - I *think* that we
-	 * could probably just unload the driver and send the signal, and when
-	 * the error handling thread wakes up that it would just exit without
-	 * needing to touch any memory associated with the driver itself.
+	 * the way out the door.
 	 */
-	if (shost->eh_notify != NULL)
-		up(shost->eh_notify);
+	complete_and_exit(shost->eh_notify, 0);
 }
 
 /**

--==_Exmh_12226870000--


