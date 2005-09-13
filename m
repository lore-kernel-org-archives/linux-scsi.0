From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Tue, 13 Sep 2005 15:03:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509131457530.4662-100000@iolanthe.rowland.org>
References: <200509131901.33033@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:24460 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964987AbVIMTDU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 15:03:20 -0400
In-Reply-To: <200509131901.33033@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Christoph Hellwig <hch@lst.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 13 Sep 2005, Rolf Eike Beer wrote:

> Looks like someone has to build a waitqueue to fix this.

Tell me what you think of this patch.  I'm not sure whether that 
condition, host_busy == host_failed, is correct for the call to 
wait_event_interruptible.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -50,7 +50,7 @@
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
 	if (shost->host_busy == shost->host_failed) {
-		up(shost->eh_wait);
+		wake_up(&shost->eh_wait);
 		SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
 	}
@@ -69,7 +69,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 
-	if (shost->eh_wait == NULL)
+	if (shost->eh_alive == 0)	/* Not 100% reliable */
 		return 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1582,37 +1582,24 @@ int scsi_error_handler(void *data)
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
+		 * Note - we always use wait_event_interruptible even if
+		 * the module was loaded as part of the kernel.  The reason
+		 * is that wait_event() will cause this thread to be counted
+		 * in the load average as a running process, and an
+		 * interruptible wait doesn't.
+		 */
+		wait_event_interruptible(shost->eh_wait,
+				shost->host_busy == shost->host_failed ||
+				kthread_should_stop());
 		if (kthread_should_stop())
 			break;
 
@@ -1651,7 +1638,7 @@ int scsi_error_handler(void *data)
 	/*
 	 * Make sure that nobody tries to wake us up again.
 	 */
-	shost->eh_wait = NULL;
+	shost->eh_alive = 0;
 	return 0;
 }
 
Index: usb-2.6/include/scsi/scsi_host.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_host.h
+++ usb-2.6/include/scsi/scsi_host.h
@@ -465,10 +465,11 @@ struct Scsi_Host {
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct semaphore      * eh_wait;   /* The error recovery thread waits
+	wait_queue_head_t	eh_wait;   /* The error recovery thread waits
 					      on this. */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
+	unsigned int		eh_alive:1;
 	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if
                                           this is true. */
 	wait_queue_head_t       host_wait;
Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -285,6 +285,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	INIT_LIST_HEAD(&shost->__targets);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
+	init_waitqueue_head(&shost->eh_wait);
 	init_waitqueue_head(&shost->host_wait);
 
 	init_MUTEX(&shost->scan_mutex);
@@ -368,6 +369,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 		rval = PTR_ERR(shost->ehandler);
 		goto fail_destroy_freelist;
 	}
+	shost->eh_alive = 1;
 
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;

