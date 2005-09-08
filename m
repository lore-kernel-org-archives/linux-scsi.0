From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/8] aacraid: AIF preallocation
Date: Thu, 08 Sep 2005 13:50:07 -0700
Message-ID: <1126212607.7479.19.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:37549 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751386AbVIHUxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 16:53:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Recevied from Mark Salyzyn from Adaptec.

Aif pre-allocation is used to pull the kmalloc outside of the locks.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>


Index: scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/commsup.c	2005-09-08 11:00:20.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:17.000000000 -0700
@@ -805,7 +805,6 @@
 {
 	struct hw_fib *hw_fib, *hw_newfib;
 	struct fib *fib, *newfib;
-	struct aac_queue_block *queues = dev->queues;
 	struct aac_fib_context *fibctx;
 	unsigned long flags;
 	DECLARE_WAITQUEUE(wait, current);
@@ -825,21 +824,22 @@
 	 *	Let the DPC know it has a place to send the AIF's to.
 	 */
 	dev->aif_thread = 1;
-	add_wait_queue(&queues->queue[HostNormCmdQueue].cmdready, &wait);
+	add_wait_queue(&dev->queues->queue[HostNormCmdQueue].cmdready, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
+	dprintk ((KERN_INFO "aac_command_thread start\n"));
 	while(1) 
 	{
-		spin_lock_irqsave(queues->queue[HostNormCmdQueue].lock, flags);
-		while(!list_empty(&(queues->queue[HostNormCmdQueue].cmdq))) {
+		spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock, flags);
+		while(!list_empty(&(dev->queues->queue[HostNormCmdQueue].cmdq))) {
 			struct list_head *entry;
 			struct aac_aifcmd * aifcmd;
 
 			set_current_state(TASK_RUNNING);
-		
-			entry = queues->queue[HostNormCmdQueue].cmdq.next;
+	
+			entry = dev->queues->queue[HostNormCmdQueue].cmdq.next;
 			list_del(entry);
-			
-			spin_unlock_irqrestore(queues->queue[HostNormCmdQueue].lock, flags);
+		
+			spin_unlock_irqrestore(dev->queues->queue[HostNormCmdQueue].lock, flags);
 			fib = list_entry(entry, struct fib, fiblink);
 			/*
 			 *	We will process the FIB here or pass it to a 
@@ -869,9 +869,54 @@
 				   
 				u32 time_now, time_last;
 				unsigned long flagv;
+				unsigned num;
+				struct hw_fib ** hw_fib_pool, ** hw_fib_p;
+				struct fib ** fib_pool, ** fib_p;
 				
 				time_now = jiffies/HZ;
 
+				/*
+				 * Warning: no sleep allowed while
+				 * holding spinlock. We take the estimate
+				 * and pre-allocate a set of fibs outside the
+				 * lock.
+				 */
+				num = le32_to_cpu(dev->init->AdapterFibsSize)
+				    / sizeof(struct hw_fib); /* some extra */
+				spin_lock_irqsave(&dev->fib_lock, flagv);
+				entry = dev->fib_list.next;
+				while (entry != &dev->fib_list) {
+					entry = entry->next;
+					++num;
+				}
+				spin_unlock_irqrestore(&dev->fib_lock, flagv);
+				hw_fib_pool = NULL;
+				fib_pool = NULL;
+				if (num
+				 && ((hw_fib_pool = kmalloc(sizeof(struct hw_fib *) * num, GFP_ATOMIC|GFP_KERNEL)))
+				 && ((fib_pool = kmalloc(sizeof(struct fib *) * num, GFP_ATOMIC|GFP_KERNEL)))) {
+					hw_fib_p = hw_fib_pool;
+					fib_p = fib_pool;
+					while (hw_fib_p < &hw_fib_pool[num]) {
+						if (!(*(hw_fib_p++) = kmalloc(sizeof(struct hw_fib), GFP_ATOMIC|GFP_KERNEL))) {
+							--hw_fib_p;
+							break;
+						}
+						if (!(*(fib_p++) = kmalloc(sizeof(struct fib), GFP_ATOMIC|GFP_KERNEL))) {
+							kfree(*(--hw_fib_p));
+							break;
+						}
+					}
+					if ((num = hw_fib_p - hw_fib_pool) == 0) {
+						kfree(fib_pool);
+						fib_pool = NULL;
+						kfree(hw_fib_pool);
+						hw_fib_pool = NULL;
+					}
+				} else if (hw_fib_pool) {
+					kfree(hw_fib_pool);
+					hw_fib_pool = NULL;
+				}
 				spin_lock_irqsave(&dev->fib_lock, flagv);
 				entry = dev->fib_list.next;
 				/*
@@ -880,6 +925,8 @@
 				 * fib, and then set the event to wake up the
 				 * thread that is waiting for it.
 				 */
+				hw_fib_p = hw_fib_pool;
+				fib_p = fib_pool;
 				while (entry != &dev->fib_list) {
 					/*
 					 * Extract the fibctx
@@ -912,9 +959,11 @@
 					 * Warning: no sleep allowed while
 					 * holding spinlock
 					 */
-					hw_newfib = kmalloc(sizeof(struct hw_fib), GFP_ATOMIC);
-					newfib = kmalloc(sizeof(struct fib), GFP_ATOMIC);
-					if (newfib && hw_newfib) {
+					if (hw_fib_p < &hw_fib_pool[num]) {
+						hw_newfib = *hw_fib_p;
+						*(hw_fib_p++) = NULL;
+						newfib = *fib_p;
+						*(fib_p++) = NULL;
 						/*
 						 * Make the copy of the FIB
 						 */
@@ -929,15 +978,11 @@
 						fibctx->count++;
 						/* 
 						 * Set the event to wake up the
-						 * thread that will waiting.
+						 * thread that is waiting.
 						 */
 						up(&fibctx->wait_sem);
 					} else {
 						printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
-						if(newfib)
-							kfree(newfib);
-						if(hw_newfib)
-							kfree(hw_newfib);
 					}
 					entry = entry->next;
 				}
@@ -948,20 +993,22 @@
 				fib_adapter_complete(fib, sizeof(u32));
 				spin_unlock_irqrestore(&dev->fib_lock, flagv);
 			}
-			spin_lock_irqsave(queues->queue[HostNormCmdQueue].lock, flags);
+			spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock, flags);
 			kfree(fib);
 		}
 		/*
 		 *	There are no more AIF's
 		 */
-		spin_unlock_irqrestore(queues->queue[HostNormCmdQueue].lock, flags);
+		spin_unlock_irqrestore(dev->queues->queue[HostNormCmdQueue].lock, flags);
 		schedule();
 
 		if(signal_pending(current))
 			break;
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	remove_wait_queue(&queues->queue[HostNormCmdQueue].cmdready, &wait);
+	if (dev->queues)
+		remove_wait_queue(&dev->queues->queue[HostNormCmdQueue].cmdready, &wait);
 	dev->aif_thread = 0;
 	complete_and_exit(&dev->aif_completion, 0);
+	return 0;
 }

-- 
Mark Haverkamp <markh@osdl.org>

