From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V3 10/24] aacraid: Reworked aac_command_thread
Date: Fri, 27 Jan 2017 11:28:39 -0800
Message-ID: <20170127192853.10082-11-RaghavaAditya.Renukunta@microsemi.com>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:11136
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750829AbdA1CV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Jan 2017 21:21:57 -0500
In-Reply-To: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

Reworked aac_command_thread into aac_process_events

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
Changes in  V2:
None

Changes in  V3:
None

 drivers/scsi/aacraid/commsup.c | 411 ++++++++++++++++++++++-------------------
 1 file changed, 217 insertions(+), 194 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4b1177a..346c1c0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1729,6 +1729,222 @@ int aac_check_health(struct aac_dev * aac)
 	return BlinkLED;
 }
 
+static void aac_process_events(struct aac_dev *dev)
+{
+	struct hw_fib *hw_fib, *hw_newfib;
+	struct fib *fib, *newfib;
+	struct aac_fib_context *fibctx;
+	unsigned long flags;
+	spinlock_t *t_lock;
+
+	spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock, flags);
+	while (!list_empty(&(dev->queues->queue[HostNormCmdQueue].cmdq))) {
+		struct list_head *entry;
+		struct aac_aifcmd *aifcmd;
+		u32 time_now, time_last;
+		unsigned long flagv;
+		unsigned int  num;
+		struct hw_fib **hw_fib_pool, **hw_fib_p;
+		struct fib **fib_pool, **fib_p;
+
+		set_current_state(TASK_RUNNING);
+
+		entry = dev->queues->queue[HostNormCmdQueue].cmdq.next;
+		list_del(entry);
+
+
+		t_lock = dev->queues->queue[HostNormCmdQueue].lock;
+		spin_unlock_irqrestore(t_lock, flags);
+
+		fib = list_entry(entry, struct fib, fiblink);
+		hw_fib = fib->hw_fib_va;
+		/*
+		 *	We will process the FIB here or pass it to a
+		 *	worker thread that is TBD. We Really can't
+		 *	do anything at this point since we don't have
+		 *	anything defined for this thread to do.
+		 */
+		memset(fib, 0, sizeof(struct fib));
+		fib->type = FSAFS_NTC_FIB_CONTEXT;
+		fib->size = sizeof(struct fib);
+		fib->hw_fib_va = hw_fib;
+		fib->data = hw_fib->data;
+		fib->dev = dev;
+		/*
+		 *	We only handle AifRequest fibs from the adapter.
+		 */
+
+		aifcmd = (struct aac_aifcmd *) hw_fib->data;
+		if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
+			/* Handle Driver Notify Events */
+			aac_handle_aif(dev, fib);
+			*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+			aac_fib_adapter_complete(fib, (u16)sizeof(u32));
+			continue;
+		}
+		/*
+		 * The u32 here is important and intended. We are using
+		 * 32bit wrapping time to fit the adapter field
+		 */
+
+
+		/* Sniff events */
+		if ((aifcmd->command ==	cpu_to_le32(AifCmdEventNotify)) ||
+				(aifcmd->command ==
+				cpu_to_le32(AifCmdJobProgress))) {
+			aac_handle_aif(dev, fib);
+		}
+
+		time_now = jiffies/HZ;
+
+		/*
+		 * Warning: no sleep allowed while
+		 * holding spinlock. We take the estimate
+		 * and pre-allocate a set of fibs outside the
+		 * lock.
+		 */
+		num = le32_to_cpu(dev->init->r7.adapter_fibs_size)
+				/ sizeof(struct hw_fib); /* some extra */
+		spin_lock_irqsave(&dev->fib_lock, flagv);
+		entry = dev->fib_list.next;
+		while (entry != &dev->fib_list) {
+			entry = entry->next;
+			++num;
+		}
+		spin_unlock_irqrestore(&dev->fib_lock, flagv);
+		hw_fib_pool = kmalloc_array(num, sizeof(struct hw_fib *),
+						GFP_KERNEL);
+		fib_pool = kmalloc_array(num, sizeof(struct fib *),
+						GFP_KERNEL);
+		if (num	&& fib_pool && hw_fib_pool) {
+			hw_fib_p = hw_fib_pool;
+			fib_p = fib_pool;
+			while (hw_fib_p < &hw_fib_pool[num]) {
+				*(hw_fib_p) = kmalloc(sizeof(struct hw_fib),
+						GFP_KERNEL);
+				if (!(*(hw_fib_p++))) {
+					--hw_fib_p;
+					break;
+				}
+				*(fib_p) = kmalloc(sizeof(struct fib),
+						GFP_KERNEL);
+				if (!(*(fib_p++))) {
+					kfree(*(--hw_fib_p));
+					break;
+				}
+			}
+			num = hw_fib_p - hw_fib_pool;
+			if (!num) {
+				kfree(fib_pool);
+				fib_pool = NULL;
+				kfree(hw_fib_pool);
+				hw_fib_pool = NULL;
+				continue;
+			}
+		} else {
+			kfree(hw_fib_pool);
+			hw_fib_pool = NULL;
+			kfree(fib_pool);
+			fib_pool = NULL;
+		}
+		spin_lock_irqsave(&dev->fib_lock, flagv);
+		entry = dev->fib_list.next;
+		/*
+		 * For each Context that is on the
+		 * fibctxList, make a copy of the
+		 * fib, and then set the event to wake up the
+		 * thread that is waiting for it.
+		 */
+		hw_fib_p = hw_fib_pool;
+		fib_p = fib_pool;
+		while (entry != &dev->fib_list) {
+			/*
+			 * Extract the fibctx
+			 */
+			fibctx = list_entry(entry, struct aac_fib_context,
+					next);
+			/*
+			 * Check if the queue is getting
+			 * backlogged
+			 */
+			if (fibctx->count > 20) {
+				/*
+				 * It's *not* jiffies folks,
+				 * but jiffies / HZ so do not
+				 * panic ...
+				 */
+				time_last = fibctx->jiffies;
+				/*
+				 * Has it been > 2 minutes
+				 * since the last read off
+				 * the queue?
+				 */
+				if ((time_now - time_last) > aif_timeout) {
+					entry = entry->next;
+					aac_close_fib_context(dev, fibctx);
+					continue;
+				}
+			}
+			/*
+			 * Warning: no sleep allowed while
+			 * holding spinlock
+			 */
+			if (hw_fib_p < &hw_fib_pool[num]) {
+				hw_newfib = *hw_fib_p;
+				*(hw_fib_p++) = NULL;
+				newfib = *fib_p;
+				*(fib_p++) = NULL;
+				/*
+				 * Make the copy of the FIB
+				 */
+				memcpy(hw_newfib, hw_fib,
+					sizeof(struct hw_fib));
+				memcpy(newfib, fib, sizeof(struct fib));
+				newfib->hw_fib_va = hw_newfib;
+				/*
+				 * Put the FIB onto the
+				 * fibctx's fibs
+				 */
+				list_add_tail(&newfib->fiblink,
+					&fibctx->fib_list);
+				fibctx->count++;
+				/*
+				 * Set the event to wake up the
+				 * thread that is waiting.
+				 */
+				up(&fibctx->wait_sem);
+			} else {
+				pr_warn("aifd: didn't allocate NewFib.\n");
+			}
+			entry = entry->next;
+		}
+		/*
+		 *	Set the status of this FIB
+		 */
+		*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+		aac_fib_adapter_complete(fib, sizeof(u32));
+		spin_unlock_irqrestore(&dev->fib_lock, flagv);
+		/* Free up the remaining resources */
+		hw_fib_p = hw_fib_pool;
+		fib_p = fib_pool;
+		while (hw_fib_p < &hw_fib_pool[num]) {
+			kfree(*hw_fib_p);
+			kfree(*fib_p);
+			++fib_p;
+			++hw_fib_p;
+		}
+		kfree(hw_fib_pool);
+		kfree(fib_pool);
+		kfree(fib);
+		spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock,
+				flags);
+	}
+	/*
+	 *	There are no more AIF's
+	 */
+	spin_unlock_irqrestore(dev->queues->queue[HostNormCmdQueue].lock,
+			flags);
+}
 
 /**
  *	aac_command_thread	-	command processing thread
@@ -1743,10 +1959,6 @@ int aac_check_health(struct aac_dev * aac)
 int aac_command_thread(void *data)
 {
 	struct aac_dev *dev = data;
-	struct hw_fib *hw_fib, *hw_newfib;
-	struct fib *fib, *newfib;
-	struct aac_fib_context *fibctx;
-	unsigned long flags;
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long next_jiffies = jiffies + HZ;
 	unsigned long next_check_jiffies = next_jiffies;
@@ -1766,197 +1978,8 @@ int aac_command_thread(void *data)
 	set_current_state(TASK_INTERRUPTIBLE);
 	dprintk ((KERN_INFO "aac_command_thread start\n"));
 	while (1) {
-		spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock, flags);
-		while(!list_empty(&(dev->queues->queue[HostNormCmdQueue].cmdq))) {
-			struct list_head *entry;
-			struct aac_aifcmd * aifcmd;
 
-			set_current_state(TASK_RUNNING);
-
-			entry = dev->queues->queue[HostNormCmdQueue].cmdq.next;
-			list_del(entry);
-
-			spin_unlock_irqrestore(dev->queues->queue[HostNormCmdQueue].lock, flags);
-			fib = list_entry(entry, struct fib, fiblink);
-			/*
-			 *	We will process the FIB here or pass it to a
-			 *	worker thread that is TBD. We Really can't
-			 *	do anything at this point since we don't have
-			 *	anything defined for this thread to do.
-			 */
-			hw_fib = fib->hw_fib_va;
-			memset(fib, 0, sizeof(struct fib));
-			fib->type = FSAFS_NTC_FIB_CONTEXT;
-			fib->size = sizeof(struct fib);
-			fib->hw_fib_va = hw_fib;
-			fib->data = hw_fib->data;
-			fib->dev = dev;
-			/*
-			 *	We only handle AifRequest fibs from the adapter.
-			 */
-			aifcmd = (struct aac_aifcmd *) hw_fib->data;
-			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
-				/* Handle Driver Notify Events */
-				aac_handle_aif(dev, fib);
-				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
-				aac_fib_adapter_complete(fib, (u16)sizeof(u32));
-			} else {
-				/* The u32 here is important and intended. We are using
-				   32bit wrapping time to fit the adapter field */
-
-				u32 time_now, time_last;
-				unsigned long flagv;
-				unsigned num;
-				struct hw_fib ** hw_fib_pool, ** hw_fib_p;
-				struct fib ** fib_pool, ** fib_p;
-
-				/* Sniff events */
-				if ((aifcmd->command ==
-				     cpu_to_le32(AifCmdEventNotify)) ||
-				    (aifcmd->command ==
-				     cpu_to_le32(AifCmdJobProgress))) {
-					aac_handle_aif(dev, fib);
-				}
-
-				time_now = jiffies/HZ;
-
-				/*
-				 * Warning: no sleep allowed while
-				 * holding spinlock. We take the estimate
-				 * and pre-allocate a set of fibs outside the
-				 * lock.
-				 */
-				num = le32_to_cpu(dev->init->
-							r7.adapter_fibs_size)
-				    / sizeof(struct hw_fib); /* some extra */
-				spin_lock_irqsave(&dev->fib_lock, flagv);
-				entry = dev->fib_list.next;
-				while (entry != &dev->fib_list) {
-					entry = entry->next;
-					++num;
-				}
-				spin_unlock_irqrestore(&dev->fib_lock, flagv);
-				hw_fib_pool = NULL;
-				fib_pool = NULL;
-				if (num
-				 && ((hw_fib_pool = kmalloc(sizeof(struct hw_fib *) * num, GFP_KERNEL)))
-				 && ((fib_pool = kmalloc(sizeof(struct fib *) * num, GFP_KERNEL)))) {
-					hw_fib_p = hw_fib_pool;
-					fib_p = fib_pool;
-					while (hw_fib_p < &hw_fib_pool[num]) {
-						if (!(*(hw_fib_p++) = kmalloc(sizeof(struct hw_fib), GFP_KERNEL))) {
-							--hw_fib_p;
-							break;
-						}
-						if (!(*(fib_p++) = kmalloc(sizeof(struct fib), GFP_KERNEL))) {
-							kfree(*(--hw_fib_p));
-							break;
-						}
-					}
-					if ((num = hw_fib_p - hw_fib_pool) == 0) {
-						kfree(fib_pool);
-						fib_pool = NULL;
-						kfree(hw_fib_pool);
-						hw_fib_pool = NULL;
-					}
-				} else {
-					kfree(hw_fib_pool);
-					hw_fib_pool = NULL;
-				}
-				spin_lock_irqsave(&dev->fib_lock, flagv);
-				entry = dev->fib_list.next;
-				/*
-				 * For each Context that is on the
-				 * fibctxList, make a copy of the
-				 * fib, and then set the event to wake up the
-				 * thread that is waiting for it.
-				 */
-				hw_fib_p = hw_fib_pool;
-				fib_p = fib_pool;
-				while (entry != &dev->fib_list) {
-					/*
-					 * Extract the fibctx
-					 */
-					fibctx = list_entry(entry, struct aac_fib_context, next);
-					/*
-					 * Check if the queue is getting
-					 * backlogged
-					 */
-					if (fibctx->count > 20)
-					{
-						/*
-						 * It's *not* jiffies folks,
-						 * but jiffies / HZ so do not
-						 * panic ...
-						 */
-						time_last = fibctx->jiffies;
-						/*
-						 * Has it been > 2 minutes
-						 * since the last read off
-						 * the queue?
-						 */
-						if ((time_now - time_last) > aif_timeout) {
-							entry = entry->next;
-							aac_close_fib_context(dev, fibctx);
-							continue;
-						}
-					}
-					/*
-					 * Warning: no sleep allowed while
-					 * holding spinlock
-					 */
-					if (hw_fib_p < &hw_fib_pool[num]) {
-						hw_newfib = *hw_fib_p;
-						*(hw_fib_p++) = NULL;
-						newfib = *fib_p;
-						*(fib_p++) = NULL;
-						/*
-						 * Make the copy of the FIB
-						 */
-						memcpy(hw_newfib, hw_fib, sizeof(struct hw_fib));
-						memcpy(newfib, fib, sizeof(struct fib));
-						newfib->hw_fib_va = hw_newfib;
-						/*
-						 * Put the FIB onto the
-						 * fibctx's fibs
-						 */
-						list_add_tail(&newfib->fiblink, &fibctx->fib_list);
-						fibctx->count++;
-						/*
-						 * Set the event to wake up the
-						 * thread that is waiting.
-						 */
-						up(&fibctx->wait_sem);
-					} else {
-						printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
-					}
-					entry = entry->next;
-				}
-				/*
-				 *	Set the status of this FIB
-				 */
-				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
-				aac_fib_adapter_complete(fib, sizeof(u32));
-				spin_unlock_irqrestore(&dev->fib_lock, flagv);
-				/* Free up the remaining resources */
-				hw_fib_p = hw_fib_pool;
-				fib_p = fib_pool;
-				while (hw_fib_p < &hw_fib_pool[num]) {
-					kfree(*hw_fib_p);
-					kfree(*fib_p);
-					++fib_p;
-					++hw_fib_p;
-				}
-				kfree(hw_fib_pool);
-				kfree(fib_pool);
-			}
-			kfree(fib);
-			spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock, flags);
-		}
-		/*
-		 *	There are no more AIF's
-		 */
-		spin_unlock_irqrestore(dev->queues->queue[HostNormCmdQueue].lock, flags);
+		aac_process_events(dev);
 
 		/*
 		 *	Background activity
-- 
2.7.4

