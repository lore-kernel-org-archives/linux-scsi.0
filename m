From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Sun, 18 Sep 2005 20:43:34 -0500
Message-ID: <1127094214.4847.54.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41891 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932286AbVISBnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 21:43:41 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2005-09-18 at 17:04 -0400, Alan Stern wrote:
> One effect of the semaphore in the old code was that there was a
> one-to-one relationship between successful calls to scsi_eh_wakeup and
> runs of the error handler -- the thread was awakened exactly once for
> every up you did on the semaphore.  Is that important/desirable?  Or would
> it be okay for the error handler to go through a few unintended loop
> iterations?

Not really ... it just processes an empty command list.  What matters is
that we don't start the error handler while we're waiting for
outstanding commands to return or time out.  If we can get a spurious
wakeup then this condition will have to be checked again.  That should
be possible simply by putting a continue after the schedule.

> > Try the attached, I made our infrastructure as close as possible to
> > other users of the kthread interface.  I junked the double loop and
> > added back the check in the scsi_eh_scmd_add() routine for the error
> > thread not running (this is a theoretical impossibility at the momen,
> > but it will become relevant if people move the thread shutdown to
> > earlier in the host removal cycle, so best to leave it in).  I also made
> > the eh do a final sweep through the queues before shutdown, just in case
> > (also theoretically not necessary, but it won't hurt anything).
> 
> Your patch isn't right.  You really _do_ need that double loop, otherwise 
> you run the risk of losing wakeup calls:
> 
> > +	while (!kthread_should_stop()) {
> 
> > +		if (shost->host_failed == 0 ||
> > +		    shost->host_failed != shost->host_busy) {
> > +			SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
> > +							  " scsi_eh_%d"
> > +							  " sleeping\n",
> > +							  shost->host_no));
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			/* Even though we are INTERRUPTIBLE, ignore signals */
> > +			flush_signals(current);
> > +			schedule();
> > +		}
> >  
> >  		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
> >  						  " scsi_eh_%d waking"
> 
> What happens if kthread_stop runs in between the "while" test and the
> set_current_task call?  Of if a normal invocation arrives between the "if"
> test and the set_current_task?  In wait loops like this, it's vital to
> check the activation condition _after_ setting the state to
> TASK_INTERRUPTIBLE.  And note also that it's possible for a thread to wake 
> up even when the activation condition isn't true, in which case it should 
> put itself right back to sleep.

Aha, that's why everyone else sets the TASK_INTERRUPTIBLE at the top of
the while loop ... we can just do the same.

> I got rid of the check for the error handler thread no longer running
> because it was racy (and it still is, with this patch).  It could be added
> back in however, in a non-racy way.  Oh yes, and I asked Andrew Morton 
> about the flush_signals call; he said it's not necessary.

Yes ... someone gets to fix that when it matters.

> At the moment I have two candidate patches for fixing this.  One involves
> replacing the semaphore with an atomic_t variable that counts the number
> of pending invocations.  It preserves the existing behavior of exactly one
> loop iteration per invocation.  I don't really like it, though, because
> the combination of atomic_t manipulations along with the double loop and
> set_current_state looks like nothing so much as a poor-man's
> implementation of a semaphore!
> 
> Better just to continue using a real semaphore.  So the other patch adds 
> to the kthread API a new routine,
> 
> 	int kthread_stop_sem(struct task_state *k, struct semaphore *s)
> 
> which does the same thing as kthread_stop except that it wakes up k by 
> calling up(s) rather than wakeup_process(k).  Then scsi_host_dev_release 
> simply calls kthread_stop_sem in place of kthread_stop.
> 
> If anyone is interested in seeing these patches I will post them.  Neither 
> one is quite final, but they are in working condition.

Right at the moment, I need something that will work for 2.6.14-rc1
before I get shot by any more bug reports, so the attached should fix
all the issues and be no worse for the races than what we previously
had; we can worry about closing the theoretical races for the next
kernel release.

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
@@ -69,7 +69,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 
-	if (shost->eh_wait == NULL)
+	if (!shost->ehandler)
 		return 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1582,40 +1582,31 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = (struct Scsi_Host *) data;
 	int rtn;
-	DECLARE_MUTEX_LOCKED(sem);
 
 	current->flags |= PF_NOFREEZE;
-	shost->eh_wait = &sem;
 
+	
 	/*
-	 * Wake up the thread that created us.
-	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
-					  " scsi_eh_%d\n",shost->host_no));
-
-	while (1) {
-		/*
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
+	 * Note - we always use TASK_INTERRUPTIBLE even if the module
+	 * was loaded as part of the kernel.  The reason is that
+	 * UNINTERRUPTIBLE would cause this thread to be counted in
+	 * the load average as a running process, and an interruptible
+	 * wait doesn't.
+	 */
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		if (shost->host_failed == 0 ||
+		    shost->host_failed != shost->host_busy) {
+			SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
+							  " scsi_eh_%d"
+							  " sleeping\n",
+							  shost->host_no));
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+			continue;
+		}
 
+		__set_current_state(TASK_RUNNING);
 		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
 						  " scsi_eh_%d waking"
 						  " up\n",shost->host_no));
@@ -1642,7 +1633,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
 
 	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
@@ -1651,7 +1642,7 @@ int scsi_error_handler(void *data)
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
@@ -465,8 +465,6 @@ struct Scsi_Host {
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct semaphore      * eh_wait;   /* The error recovery thread waits
-					      on this. */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
 	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if


