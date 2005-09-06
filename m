From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] switch EH thread startup to the kthread API
Date: Tue, 6 Sep 2005 14:04:26 +0200
Message-ID: <20050906120426.GB20177@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20357 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964834AbVIFME3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 08:04:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Index: scsi-misc-2.6/drivers/scsi/hosts.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/hosts.c	2005-09-06 13:50:46.000000000 +0200
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/init.h>
@@ -225,15 +226,8 @@
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	if (shost->ehandler) {
-		DECLARE_COMPLETION(sem);
-		shost->eh_notify = &sem;
-		shost->eh_kill = 1;
-		up(shost->eh_wait);
-		wait_for_completion(&sem);
-		shost->eh_notify = NULL;
-	}
-
+	if (shost->ehandler)
+		kthread_stop(shost->ehandler);
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
@@ -263,7 +257,6 @@
 {
 	struct Scsi_Host *shost;
 	int gfp_mask = GFP_KERNEL, rval;
-	DECLARE_COMPLETION(complete);
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -369,12 +362,12 @@
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 
-	shost->eh_notify = &complete;
-	rval = kernel_thread(scsi_error_handler, shost, 0);
-	if (rval < 0)
+	shost->ehandler = kthread_run(scsi_error_handler, shost,
+			"scsi_eh_%d", shost->host_no);
+	if (IS_ERR(shost->ehandler)) {
+		rval = PTR_ERR(shost->ehandler);
 		goto fail_destroy_freelist;
-	wait_for_completion(&complete);
-	shost->eh_notify = NULL;
+	}
 
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2005-09-06 13:50:31.000000000 +0200
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -1583,16 +1584,8 @@
 	int rtn;
 	DECLARE_MUTEX_LOCKED(sem);
 
-	/*
-	 *    Flush resources
-	 */
-
-	daemonize("scsi_eh_%d", shost->host_no);
-
 	current->flags |= PF_NOFREEZE;
-
 	shost->eh_wait = &sem;
-	shost->ehandler = current;
 
 	/*
 	 * Wake up the thread that created us.
@@ -1600,8 +1593,6 @@
 	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
 					  " scsi_eh_%d\n",shost->host_no));
 
-	complete(shost->eh_notify);
-
 	while (1) {
 		/*
 		 * If we get a signal, it means we are supposed to go
@@ -1622,7 +1613,7 @@
 		 * semaphores isn't unreasonable.
 		 */
 		down_interruptible(&sem);
-		if (shost->eh_kill)
+		if (kthread_should_stop())
 			break;
 
 		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
@@ -1661,22 +1652,6 @@
 	 * Make sure that nobody tries to wake us up again.
 	 */
 	shost->eh_wait = NULL;
-
-	/*
-	 * Knock this down too.  From this point on, the host is flying
-	 * without a pilot.  If this is because the module is being unloaded,
-	 * that's fine.  If the user sent a signal to this thing, we are
-	 * potentially in real danger.
-	 */
-	shost->eh_active = 0;
-	shost->ehandler = NULL;
-
-	/*
-	 * If anyone is waiting for us to exit (i.e. someone trying to unload
-	 * a driver), then wake up that process to let them know we are on
-	 * the way out the door.
-	 */
-	complete_and_exit(shost->eh_notify, 0);
 	return 0;
 }
 
Index: scsi-misc-2.6/include/scsi/scsi_host.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_host.h	2005-08-31 13:59:16.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_host.h	2005-09-06 13:47:17.000000000 +0200
@@ -467,12 +467,10 @@
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct semaphore      * eh_wait;   /* The error recovery thread waits
 					      on this. */
-	struct completion     * eh_notify; /* wait for eh to begin or end */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
 	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if
                                           this is true. */
-	unsigned int            eh_kill:1; /* set when killing the eh thread */
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
