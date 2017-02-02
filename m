From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 10/24] aacraid: Reworked aac_command_thread
Date: Thu, 2 Feb 2017 15:53:24 -0800
Message-ID: <20170202235338.14724-11-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0077.outbound.protection.outlook.com ([104.47.37.77]:11575
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752642AbdBCGaz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:30:55 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

Reworked aac_command_thread into aac_process_events

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---

Changes in  V2:
None

Changes in  V3:
None

Changes in V4:
Reworked aac_process_events and broke it into logical block functions

 drivers/scsi/aacraid/commsup.c | 468 ++++++++++++++++++++++++-----------------
 1 file changed, 274 insertions(+), 194 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4b1177a..3dfb9da 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1729,6 +1729,279 @@ int aac_check_health(struct aac_dev * aac)
 	return BlinkLED;
 }
 
+static int get_fib_count(struct aac_dev *dev)
+{
+	unsigned int num = 0;
+	struct list_head *entry;
+	unsigned long flagv;
+
+	/*
+	 * Warning: no sleep allowed while
+	 * holding spinlock. We take the estimate
+	 * and pre-allocate a set of fibs outside the
+	 * lock.
+	 */
+	num = le32_to_cpu(dev->init->r7.adapter_fibs_size)
+			/ sizeof(struct hw_fib); /* some extra */
+	spin_lock_irqsave(&dev->fib_lock, flagv);
+	entry = dev->fib_list.next;
+	while (entry != &dev->fib_list) {
+		entry = entry->next;
+		++num;
+	}
+	spin_unlock_irqrestore(&dev->fib_lock, flagv);
+
+	return num;
+}
+
+static int fillup_pools(struct aac_dev *dev, struct hw_fib **hw_fib_pool,
+						struct fib **fib_pool,
+						unsigned int num)
+{
+	struct hw_fib **hw_fib_p;
+	struct fib **fib_p;
+	int rcode = 1;
+
+	hw_fib_p = hw_fib_pool;
+	fib_p = fib_pool;
+	while (hw_fib_p < &hw_fib_pool[num]) {
+		*(hw_fib_p) = kmalloc(sizeof(struct hw_fib), GFP_KERNEL);
+		if (!(*(hw_fib_p++))) {
+			--hw_fib_p;
+			break;
+		}
+
+		*(fib_p) = kmalloc(sizeof(struct fib), GFP_KERNEL);
+		if (!(*(fib_p++))) {
+			kfree(*(--hw_fib_p));
+			break;
+		}
+	}
+
+	num = hw_fib_p - hw_fib_pool;
+	if (!num)
+		rcode = 0;
+
+	return rcode;
+}
+
+static void wakeup_fibctx_threads(struct aac_dev *dev,
+						struct hw_fib **hw_fib_pool,
+						struct fib **fib_pool,
+						struct fib *fib,
+						struct hw_fib *hw_fib,
+						unsigned int num)
+{
+	unsigned long flagv;
+	struct list_head *entry;
+	struct hw_fib **hw_fib_p;
+	struct fib **fib_p;
+	u32 time_now, time_last;
+	struct hw_fib *hw_newfib;
+	struct fib *newfib;
+	struct aac_fib_context *fibctx;
+
+	time_now = jiffies/HZ;
+	spin_lock_irqsave(&dev->fib_lock, flagv);
+	entry = dev->fib_list.next;
+	/*
+	 * For each Context that is on the
+	 * fibctxList, make a copy of the
+	 * fib, and then set the event to wake up the
+	 * thread that is waiting for it.
+	 */
+
+	hw_fib_p = hw_fib_pool;
+	fib_p = fib_pool;
+	while (entry != &dev->fib_list) {
+		/*
+		 * Extract the fibctx
+		 */
+		fibctx = list_entry(entry, struct aac_fib_context,
+				next);
+		/*
+		 * Check if the queue is getting
+		 * backlogged
+		 */
+		if (fibctx->count > 20) {
+			/*
+			 * It's *not* jiffies folks,
+			 * but jiffies / HZ so do not
+			 * panic ...
+			 */
+			time_last = fibctx->jiffies;
+			/*
+			 * Has it been > 2 minutes
+			 * since the last read off
+			 * the queue?
+			 */
+			if ((time_now - time_last) > aif_timeout) {
+				entry = entry->next;
+				aac_close_fib_context(dev, fibctx);
+				continue;
+			}
+		}
+		/*
+		 * Warning: no sleep allowed while
+		 * holding spinlock
+		 */
+		if (hw_fib_p >= &hw_fib_pool[num]) {
+			pr_warn("aifd: didn't allocate NewFib\n");
+			entry = entry->next;
+			continue;
+		}
+
+		hw_newfib = *hw_fib_p;
+		*(hw_fib_p++) = NULL;
+		newfib = *fib_p;
+		*(fib_p++) = NULL;
+		/*
+		 * Make the copy of the FIB
+		 */
+		memcpy(hw_newfib, hw_fib, sizeof(struct hw_fib));
+		memcpy(newfib, fib, sizeof(struct fib));
+		newfib->hw_fib_va = hw_newfib;
+		/*
+		 * Put the FIB onto the
+		 * fibctx's fibs
+		 */
+		list_add_tail(&newfib->fiblink, &fibctx->fib_list);
+		fibctx->count++;
+		/*
+		 * Set the event to wake up the
+		 * thread that is waiting.
+		 */
+		up(&fibctx->wait_sem);
+
+		entry = entry->next;
+	}
+	/*
+	 *	Set the status of this FIB
+	 */
+	*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+	aac_fib_adapter_complete(fib, sizeof(u32));
+	spin_unlock_irqrestore(&dev->fib_lock, flagv);
+
+}
+
+static void aac_process_events(struct aac_dev *dev)
+{
+	struct hw_fib *hw_fib;
+	struct fib *fib;
+	unsigned long flags;
+	spinlock_t *t_lock;
+	unsigned int rcode;
+
+	t_lock = dev->queues->queue[HostNormCmdQueue].lock;
+	spin_lock_irqsave(t_lock, flags);
+
+	while (!list_empty(&(dev->queues->queue[HostNormCmdQueue].cmdq))) {
+		struct list_head *entry;
+		struct aac_aifcmd *aifcmd;
+		unsigned int  num;
+		struct hw_fib **hw_fib_pool, **hw_fib_p;
+		struct fib **fib_pool, **fib_p;
+
+		set_current_state(TASK_RUNNING);
+
+		entry = dev->queues->queue[HostNormCmdQueue].cmdq.next;
+		list_del(entry);
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
+			goto free_fib;
+		}
+		/*
+		 * The u32 here is important and intended. We are using
+		 * 32bit wrapping time to fit the adapter field
+		 */
+
+		/* Sniff events */
+		if (aifcmd->command == cpu_to_le32(AifCmdEventNotify)
+		 || aifcmd->command == cpu_to_le32(AifCmdJobProgress)) {
+			aac_handle_aif(dev, fib);
+		}
+
+		/*
+		 * get number of fibs to process
+		 */
+		num = get_fib_count(dev);
+		if (!num)
+			goto free_fib;
+
+		hw_fib_pool = kmalloc_array(num, sizeof(struct hw_fib *),
+						GFP_KERNEL);
+		if (!hw_fib_pool)
+			goto free_fib;
+
+		fib_pool = kmalloc_array(num, sizeof(struct fib *), GFP_KERNEL);
+		if (!fib_pool)
+			goto free_hw_fib_pool;
+
+		/*
+		 * Fill up fib pointer pools with actual fibs
+		 * and hw_fibs
+		 */
+		rcode = fillup_pools(dev, hw_fib_pool, fib_pool, num);
+		if (!rcode)
+			goto free_mem;
+
+		/*
+		 * wakeup the thread that is waiting for
+		 * the response from fw (ioctl)
+		 */
+		wakeup_fibctx_threads(dev, hw_fib_pool, fib_pool,
+							    fib, hw_fib, num);
+
+free_mem:
+		/* Free up the remaining resources */
+		hw_fib_p = hw_fib_pool;
+		fib_p = fib_pool;
+		while (hw_fib_p < &hw_fib_pool[num]) {
+			kfree(*hw_fib_p);
+			kfree(*fib_p);
+			++fib_p;
+			++hw_fib_p;
+		}
+		kfree(fib_pool);
+free_hw_fib_pool:
+		kfree(hw_fib_pool);
+free_fib:
+		kfree(fib);
+		t_lock = dev->queues->queue[HostNormCmdQueue].lock;
+		spin_lock_irqsave(t_lock, flags);
+	}
+	/*
+	 *	There are no more AIF's
+	 */
+	t_lock = dev->queues->queue[HostNormCmdQueue].lock;
+	spin_unlock_irqrestore(t_lock, flags);
+}
 
 /**
  *	aac_command_thread	-	command processing thread
@@ -1743,10 +2016,6 @@ int aac_check_health(struct aac_dev * aac)
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
@@ -1766,197 +2035,8 @@ int aac_command_thread(void *data)
 	set_current_state(TASK_INTERRUPTIBLE);
 	dprintk ((KERN_INFO "aac_command_thread start\n"));
 	while (1) {
-		spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock, flags);
-		while(!list_empty(&(dev->queues->queue[HostNormCmdQueue].cmdq))) {
-			struct list_head *entry;
-			struct aac_aifcmd * aifcmd;
-
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
