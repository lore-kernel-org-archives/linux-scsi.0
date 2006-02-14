From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aacraid: use kthread_ API
Date: Tue, 14 Feb 2006 18:45:06 +0100
Message-ID: <20060214174506.GA18919@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:32460 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422707AbWBNRpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 12:45:40 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Use the kthread_ API instead of opencoding lots of hairy code for kernel
thread creation and teardown.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/aacraid/aacraid.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/aacraid.h	2006-01-15 21:45:28.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/aacraid.h	2006-02-12 18:48:48.000000000 +0100
@@ -997,7 +997,7 @@
 	int			maximum_num_physicals;
 	int			maximum_num_channels;
 	struct fsa_dev_info	*fsa_dev;
-	pid_t			thread_pid;
+	struct task_struct	*thread;
 	int			cardtype;
 	
 	/*
@@ -1017,7 +1017,6 @@
 	 *	AIF thread states
 	 */
 	u32			aif_thread;
-	struct completion	aif_completion;
 	struct aac_adapter_info adapter_info;
 	struct aac_supplement_adapter_info supplement_adapter_info;
 	/* These are in adapter info but they are in the io flow so
@@ -1797,7 +1796,7 @@
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
-int aac_command_thread(struct aac_dev * dev);
+int aac_command_thread(void *data);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
 int fib_adapter_complete(struct fib * fibptr, unsigned short size);
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
Index: linux-2.6/drivers/scsi/aacraid/comminit.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/comminit.c	2005-12-27 18:30:30.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/comminit.c	2006-02-12 18:48:55.000000000 +0100
@@ -433,7 +433,6 @@
 	}
 		
 	INIT_LIST_HEAD(&dev->fib_list);
-	init_completion(&dev->aif_completion);
 
 	return dev;
 }
Index: linux-2.6/drivers/scsi/aacraid/commsup.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/commsup.c	2006-02-10 19:45:43.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/commsup.c	2006-02-14 15:49:44.000000000 +0100
@@ -39,6 +39,7 @@
 #include <linux/completion.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <asm/semaphore.h>
@@ -1043,8 +1044,9 @@
  *	more FIBs.
  */
  
-int aac_command_thread(struct aac_dev * dev)
+int aac_command_thread(void *data)
 {
+	struct aac_dev *dev = data;
 	struct hw_fib *hw_fib, *hw_newfib;
 	struct fib *fib, *newfib;
 	struct aac_fib_context *fibctx;
@@ -1056,12 +1058,7 @@
 	 */
 	if (dev->aif_thread)
 		return -EINVAL;
-	/*
-	 *	Set up the name that will appear in 'ps'
-	 *	stored in  task_struct.comm[16].
-	 */
-	daemonize("aacraid");
-	allow_signal(SIGKILL);
+
 	/*
 	 *	Let the DPC know it has a place to send the AIF's to.
 	 */
@@ -1264,13 +1261,12 @@
 		spin_unlock_irqrestore(dev->queues->queue[HostNormCmdQueue].lock, flags);
 		schedule();
 
-		if(signal_pending(current))
+		if (kthread_should_stop())
 			break;
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	if (dev->queues)
 		remove_wait_queue(&dev->queues->queue[HostNormCmdQueue].cmdready, &wait);
 	dev->aif_thread = 0;
-	complete_and_exit(&dev->aif_completion, 0);
 	return 0;
 }
Index: linux-2.6/drivers/scsi/aacraid/linit.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/linit.c	2006-01-15 21:45:28.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/linit.c	2006-02-14 15:49:59.000000000 +0100
@@ -48,6 +48,7 @@
 #include <linux/syscalls.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
+#include <linux/kthread.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -822,10 +823,10 @@
 	/*
 	 *	Start any kernel threads needed
 	 */
-	aac->thread_pid = kernel_thread((int (*)(void *))aac_command_thread,
-	  aac, 0);
-	if (aac->thread_pid < 0) {
+	aac->thread = kthread_run(aac_command_thread, aac, "aacraid");
+	if (IS_ERR(aac->thread)) {
 		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
+		error = PTR_ERR(aac->thread);
 		goto out_deinit;
 	}
 
@@ -906,9 +907,7 @@
 	return 0;
 
  out_deinit:
-	kill_proc(aac->thread_pid, SIGKILL, 0);
-	wait_for_completion(&aac->aif_completion);
-
+	kthread_stop(aac->thread);
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
 	free_irq(pdev->irq, aac);
@@ -942,8 +941,7 @@
 
 	scsi_remove_host(shost);
 
-	kill_proc(aac->thread_pid, SIGKILL, 0);
-	wait_for_completion(&aac->aif_completion);
+	kthread_stop(aac->thread);
 
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
