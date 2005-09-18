From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Sun, 18 Sep 2005 14:53:43 -0500
Message-ID: <1127073224.4847.28.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509151524000.4493-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20385 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932182AbVIRTxv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 15:53:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509151524000.4493-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2005-09-15 at 15:29 -0400, Alan Stern wrote:
> Can you please check that the
> 
> 	if (shost->host_busy == shost->host_failed ...
> 
> condition for waking up is really correct?  Thanks.

Yes, it mirrors the one in the scsi_eh_scmd_add()  But it's not quite
correct as a condition for sleeping since it may be true if they're both
zero.

Try the attached, I made our infrastructure as close as possible to
other users of the kthread interface.  I junked the double loop and
added back the check in the scsi_eh_scmd_add() routine for the error
thread not running (this is a theoretical impossibility at the momen,
but it will become relevant if people move the thread shutdown to
earlier in the host removal cycle, so best to leave it in).  I also made
the eh do a final sweep through the queues before shutdown, just in case
(also theoretically not necessary, but it won't hurt anything).

James

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -50,7 +50,7 @@
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
 	if (shost->host_busy == shost->host_failed) {
-		up(shost->eh_wait);
+		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
 	}
@@ -70,7 +70,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	unsigned long flags;
 	int ret = 0;
 
-	if (shost->eh_wait == NULL)
+	if (!shost->ehandler)
 		return 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1591,39 +1591,28 @@ int scsi_error_handler(void *data)
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
 
-	while (1) {
+	while (!kthread_should_stop()) {
 		/*
-		 * If we get a signal, it means we are supposed to go
-		 * away and die.  This typically happens if the user is
-		 * trying to unload a module.
-		 */
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
-						  " scsi_eh_%d"
-						  " sleeping\n",shost->host_no));
-
-		/*
-		 * Note - we always use down_interruptible with the semaphore
-		 * even if the module was loaded as part of the kernel.  The
-		 * reason is that down() will cause this thread to be counted
-		 * in the load average as a running process, and down
-		 * interruptible doesn't.  Given that we need to allow this
-		 * thread to die if the driver was loaded as a module, using
-		 * semaphores isn't unreasonable.
-		 */
-		down_interruptible(&sem);
-		if (kthread_should_stop())
-			break;
+		 * Note - we always use TASK_INTERRUPTIBLE even if the
+		 * module was loaded as part of the kernel.  The reason
+		 * is that UNINTERRUPTIBLE would cause this thread to be
+		 * counted in the load average as a running process, and
+		 * an interruptible wait doesn't.
+		 */
+		if (shost->host_failed == 0 ||
+		    shost->host_failed != shost->host_busy) {
+			SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
+							  " scsi_eh_%d"
+							  " sleeping\n",
+							  shost->host_no));
+			set_current_state(TASK_INTERRUPTIBLE);
+			/* Even though we are INTERRUPTIBLE, ignore signals */
+			flush_signals(current);
+			schedule();
+		}
 
 		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
 						  " scsi_eh_%d waking"
@@ -1660,7 +1649,7 @@ int scsi_error_handler(void *data)
 	/*
 	 * Make sure that nobody tries to wake us up again.
 	 */
-	shost->eh_wait = NULL;
+	shost->ehandler = NULL;
 	return 0;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -467,8 +467,6 @@ struct Scsi_Host {
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct semaphore      * eh_wait;   /* The error recovery thread waits
-					      on this. */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
 	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if


