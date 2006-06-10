From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Sat, 10 Jun 2006 18:08:15 +0200
Message-ID: <20060610160815.GA12034@lst.de>
References: <20060603112610.GB17018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:29659 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751534AbWFJQIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:08:22 -0400
Content-Disposition: inline
In-Reply-To: <20060603112610.GB17018@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: fischer@norbit.de, linux-scsi@vger.kernel.org

On Sat, Jun 03, 2006 at 01:26:10PM +0200, Christoph Hellwig wrote:
> Currently struct scsi_cmnd has various fields that are used to backup
> original data after the corresponding fields have been overridden for
> EH commands.  This means drivers can easily get at it and misuse it.
> Due to the old_ naming this doesn't happen for most of them, but two
> that have different names have been used wrong a lot (see previous
> patch).  Another downside is that they unessecarily bloat the scsi_cmnd
> size.
> 
> This patch moves them onstack in scsi_send_eh_cmnd to fix those two
> issues above.
> 
> Note that this breaks the aha152x and 53x700 drivers because they're
> plaing with those fields internally.
> 
> J"urgen and James, could you take a look at whether it's feasible to
> fix those drivers?
> 
> Otherwise any comments on the general approach?
> 
> (Note:  you probably want the patch to remove the wrong buffer and
>  bufflen patches applied before this, else lots of drivers will stop
>  compiling)

That patch is now in.  Below is a patch rediffed against the
scsi_request removal I just posed to linux-scsi.


Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2005-10-29 19:22:47.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2005-10-29 19:23:00.000000000 +0200
@@ -417,43 +417,15 @@
 }
 
 /**
- * scsi_eh_times_out - timeout function for error handling.
- * @scmd:	Cmd that is timing out.
- *
- * Notes:
- *    During error handling, the kernel thread will be sleeping waiting
- *    for some action to complete on the device.  our only job is to
- *    record that it timed out, and to wake up the thread.
- **/
-static void scsi_eh_times_out(struct scsi_cmnd *scmd)
-{
-	scmd->eh_eflags |= SCSI_EH_REC_TIMEOUT;
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
-					  scmd));
-
-	up(scmd->device->host->eh_action);
-}
-
-/**
  * scsi_eh_done - Completion function for error handling.
  * @scmd:	Cmd that is done.
  **/
 static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
-	/*
-	 * if the timeout handler is already running, then just set the
-	 * flag which says we finished late, and return.  we have no
-	 * way of stopping the timeout handler from running, so we must
-	 * always defer to it.
-	 */
-	if (del_timer(&scmd->eh_timeout)) {
-		scmd->request->rq_status = RQ_SCSI_DONE;
-
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
-					   __FUNCTION__, scmd, scmd->result));
-
-		up(scmd->device->host->eh_action);
-	}
+	SCSI_LOG_ERROR_RECOVERY(3,
+		printk("%s scmd: %p result: %x\n",
+			__FUNCTION__, scmd, scmd->result));
+	complete(scmd->device->host->eh_action);
 }
 
 /**
@@ -461,10 +433,6 @@
  * @scmd:	SCSI Cmd to send.
  * @timeout:	Timeout for cmd.
  *
- * Notes:
- *    The initialization of the structures is quite a bit different in
- *    this case, and furthermore, there is a different completion handler
- *    vs scsi_dispatch_cmd.
  * Return value:
  *    SUCCESS or FAILED or NEEDS_RETRY
  **/
@@ -472,24 +440,16 @@
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
-	DECLARE_MUTEX_LOCKED(sem);
+	DECLARE_COMPLETION(done);
+	unsigned long timeleft;
 	unsigned long flags;
-	int rtn = SUCCESS;
+	int rtn;
 
-	/*
-	 * we will use a queued command if possible, otherwise we will
-	 * emulate the queuing and calling of completion function ourselves.
-	 */
 	if (sdev->scsi_level <= SCSI_2)
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
 
-	scsi_add_timer(scmd, timeout, scsi_eh_times_out);
-
-	/*
-	 * set up the semaphore so we wait for the command to complete.
-	 */
-	shost->eh_action = &sem;
+	shost->eh_action = &done;
 	scmd->request->rq_status = RQ_SCSI_BUSY;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -497,47 +457,29 @@
 	shost->hostt->queuecommand(scmd, scsi_eh_done);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	down(&sem);
-	scsi_log_completion(scmd, SUCCESS);
+	timeleft = wait_for_completion_timeout(&done, timeout);
 
+	scmd->request->rq_status = RQ_SCSI_DONE;
 	shost->eh_action = NULL;
 
-	/*
-	 * see if timeout.  if so, tell the host to forget about it.
-	 * in other words, we don't want a callback any more.
-	 */
-	if (scmd->eh_eflags & SCSI_EH_REC_TIMEOUT) {
-		scmd->eh_eflags &= ~SCSI_EH_REC_TIMEOUT;
-
-		/*
-		 * as far as the low level driver is
-		 * concerned, this command is still active, so
-		 * we must give the low level driver a chance
-		 * to abort it. (db) 
-		 *
-		 * FIXME(eric) - we are not tracking whether we could
-		 * abort a timed out command or not.  not sure how
-		 * we should treat them differently anyways.
-		 */
-		if (shost->hostt->eh_abort_handler)
-			shost->hostt->eh_abort_handler(scmd);
-			
-		scmd->request->rq_status = RQ_SCSI_DONE;
-		rtn = FAILED;
-	}
+	scsi_log_completion(scmd, SUCCESS);
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd: %p, rtn:%x\n",
-					  __FUNCTION__, scmd, rtn));
+	SCSI_LOG_ERROR_RECOVERY(3,
+		printk("%s: scmd: %p, timeleft: %ld\n",
+			__FUNCTION__, scmd, timeleft));
 
 	/*
-	 * now examine the actual status codes to see whether the command
-	 * actually did complete normally.
+	 * If there is time left scsi_eh_done got called, and we will
+	 * examine the actual status codes to see whether the command
+	 * actually did complete normally, else tell the host to forget
+	 * about this command.
 	 */
-	if (rtn == SUCCESS) {
+	if (timeleft) {
 		rtn = scsi_eh_completed_normally(scmd);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			printk("%s: scsi_eh_completed_normally %x\n",
 			       __FUNCTION__, rtn));
+
 		switch (rtn) {
 		case SUCCESS:
 		case NEEDS_RETRY:
@@ -547,6 +489,15 @@
 			rtn = FAILED;
 			break;
 		}
+	} else {
+		/*
+		 * FIXME(eric) - we are not tracking whether we could
+		 * abort a timed out command or not.  not sure how
+		 * we should treat them differently anyways.
+		 */
+		if (shost->hostt->eh_abort_handler)
+			shost->hostt->eh_abort_handler(scmd);
+		rtn = FAILED;
 	}
 
 	return rtn;
Index: scsi-misc-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_priv.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_priv.h	2005-10-29 19:23:00.000000000 +0200
@@ -22,7 +22,6 @@
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
-#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
 
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
Index: scsi-misc-2.6/include/scsi/scsi_host.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_host.h	2005-10-29 19:22:47.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_host.h	2005-10-29 19:23:00.000000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/workqueue.h>
 
 struct block_device;
+struct completion;
 struct module;
 struct scsi_cmnd;
 struct scsi_device;
@@ -467,8 +468,8 @@
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct semaphore      * eh_action; /* Wait for specific actions on the
-                                          host. */
+	struct completion     * eh_action; /* Wait for specific actions on the
+					      host. */
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
