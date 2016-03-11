From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/11] scsi/fcoe: convert to smpboot thread
Date: Fri, 11 Mar 2016 16:29:00 +0100
Message-ID: <1457710143-29182-9-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37907 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbcCKP3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:25 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

The driver creates its own per-CPU threads which are updated based on
CPU hotplug events. It is also possible to delegate this task to the
smpboot-thread infrastructure and get the same job done while saving a
few lines of code.

The code checked ->thread to decide if there is an active per-CPU
thread. With the smpboot infrastructure this is no longer possible and I
replaced its logic with the ->active member. The thread pointer is saved
in `kthread' instead of `thread' so anything trying to use thread is
caught by the compiler.

The ->park() callback cleans up the resources if a CPU is going down. At
least one CPU has to be online (and not parked) and the skbs are moved to
this CPU. On module removal the ->cleanup() is invoked instead and all skbs
are purged.

The remaining part of the conversion is mostly straightforward.
This patch was only compile-tested due to -ENODEV.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   8 +-
 drivers/scsi/fcoe/fcoe.c          | 281 ++++++++++++++------------------------
 include/scsi/libfcoe.h            |   6 +-
 3 files changed, 112 insertions(+), 183 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 67405c628864..f5bc11b2e884 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -457,7 +457,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	__skb_queue_tail(&bg->fcoe_rx_list, skb);
 	if (bg->fcoe_rx_list.qlen == 1)
-		wake_up_process(bg->thread);
+		wake_up_process(bg->kthread);
 
 	spin_unlock(&bg->fcoe_rx_list.lock);
 
@@ -2654,7 +2654,7 @@ static int __init bnx2fc_mod_init(void)
 	}
 	wake_up_process(l2_thread);
 	spin_lock_bh(&bg->fcoe_rx_list.lock);
-	bg->thread = l2_thread;
+	bg->kthread = l2_thread;
 	spin_unlock_bh(&bg->fcoe_rx_list.lock);
 
 	for_each_possible_cpu(cpu) {
@@ -2727,8 +2727,8 @@ static void __exit bnx2fc_mod_exit(void)
 	/* Destroy global thread */
 	bg = &bnx2fc_global;
 	spin_lock_bh(&bg->fcoe_rx_list.lock);
-	l2_thread = bg->thread;
-	bg->thread = NULL;
+	l2_thread = bg->kthread;
+	bg->kthread = NULL;
 	while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL)
 		kfree_skb(skb);
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4a877ab95d44..2bc570e96663 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -26,6 +26,7 @@
 #include <linux/if_vlan.h>
 #include <linux/crc32.h>
 #include <linux/slab.h>
+#include <linux/smpboot.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
 #include <linux/sysfs.h>
@@ -80,7 +81,6 @@ static int fcoe_reset(struct Scsi_Host *);
 static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
 static int fcoe_rcv(struct sk_buff *, struct net_device *,
 		    struct packet_type *, struct net_device *);
-static int fcoe_percpu_receive_thread(void *);
 static void fcoe_percpu_clean(struct fc_lport *);
 static int fcoe_link_ok(struct fc_lport *);
 
@@ -107,7 +107,6 @@ static int fcoe_ddp_setup(struct fc_lport *, u16, struct scatterlist *,
 static int fcoe_ddp_done(struct fc_lport *, u16);
 static int fcoe_ddp_target(struct fc_lport *, u16, struct scatterlist *,
 			   unsigned int);
-static int fcoe_cpu_callback(struct notifier_block *, unsigned long, void *);
 static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 				     ulong event, void *ptr);
 
@@ -136,11 +135,6 @@ static struct notifier_block fcoe_notifier = {
 	.notifier_call = fcoe_device_notification,
 };
 
-/* notification function for CPU hotplug events */
-static struct notifier_block fcoe_cpu_notifier = {
-	.notifier_call = fcoe_cpu_callback,
-};
-
 /* notification function for DCB events */
 static struct notifier_block dcb_notifier = {
 	.notifier_call = fcoe_dcb_app_notification,
@@ -1245,55 +1239,15 @@ static int __exit fcoe_if_exit(void)
 	return 0;
 }
 
-/**
- * fcoe_percpu_thread_create() - Create a receive thread for an online CPU
- * @cpu: The CPU index of the CPU to create a receive thread for
- */
-static void fcoe_percpu_thread_create(unsigned int cpu)
+static struct fcoe_percpu_s *fcoe_thread_cleanup_local(unsigned int cpu)
 {
-	struct fcoe_percpu_s *p;
-	struct task_struct *thread;
-
-	p = &per_cpu(fcoe_percpu, cpu);
-
-	thread = kthread_create_on_node(fcoe_percpu_receive_thread,
-					(void *)p, cpu_to_node(cpu),
-					"fcoethread/%d", cpu);
-
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		wake_up_process(thread);
-
-		spin_lock_bh(&p->fcoe_rx_list.lock);
-		p->thread = thread;
-		spin_unlock_bh(&p->fcoe_rx_list.lock);
-	}
-}
-
-/**
- * fcoe_percpu_thread_destroy() - Remove the receive thread of a CPU
- * @cpu: The CPU index of the CPU whose receive thread is to be destroyed
- *
- * Destroys a per-CPU Rx thread. Any pending skbs are moved to the
- * current CPU's Rx thread. If the thread being destroyed is bound to
- * the CPU processing this context the skbs will be freed.
- */
-static void fcoe_percpu_thread_destroy(unsigned int cpu)
-{
-	struct fcoe_percpu_s *p;
-	struct task_struct *thread;
 	struct page *crc_eof;
-	struct sk_buff *skb;
-	struct fcoe_percpu_s *p_target;
-	unsigned targ_cpu = get_cpu();
-
-	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
+	struct fcoe_percpu_s *p;
 
 	/* Prevent any new skbs from being queued for this CPU. */
-	p = &per_cpu(fcoe_percpu, cpu);
+	p = per_cpu_ptr(&fcoe_percpu, cpu);
 	spin_lock_bh(&p->fcoe_rx_list.lock);
-	thread = p->thread;
-	p->thread = NULL;
+	p->active = false;
 	crc_eof = p->crc_eof_page;
 	p->crc_eof_page = NULL;
 	p->crc_eof_offset = 0;
@@ -1301,81 +1255,56 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 
 	if (crc_eof)
 		put_page(crc_eof);
-	/*
-	 * Don't bother moving the skb's if this context is running
-	 * on the same CPU that is having its thread destroyed. This
-	 * can easily happen when the module is removed.
-	 */
-	if (cpu != targ_cpu) {
-		p_target = &per_cpu(fcoe_percpu, targ_cpu);
-		spin_lock_bh(&p_target->fcoe_rx_list.lock);
-		if (p_target->thread) {
-			FCOE_DBG("Moving frames from CPU %d to CPU %d\n",
-				 cpu, targ_cpu);
-
-			skb_queue_splice_tail(&p->fcoe_rx_list,
-					      &p_target->fcoe_rx_list);
-			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
-		} else {
-			/*
-			 * The targeted CPU is not initialized and cannot accept
-			 * new	skbs. Unlock the targeted CPU and drop the skbs
-			 * on the CPU that is going offline.
-			 */
-			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
-
-			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
-				kfree_skb(skb);
-		}
-	} else {
-		/*
-		 * This scenario occurs when the module is being removed
-		 * and all threads are being destroyed. skbs will continue
-		 * to be shifted from the CPU thread that is being removed
-		 * to the CPU thread associated with the CPU that is processing
-		 * the module removal. Once there is only one CPU Rx thread it
-		 * will reach this case and we will drop all skbs and later
-		 * stop the thread.
-		 */
-		while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
-			kfree_skb(skb);
-	}
-	put_cpu();
-
-	if (thread)
-		kthread_stop(thread);
+	return p;
 }
 
 /**
- * fcoe_cpu_callback() - Handler for CPU hotplug events
- * @nfb:    The callback data block
- * @action: The event triggering the callback
- * @hcpu:   The index of the CPU that the event is for
+ * fcoe_thread_park() - Park the receive thread of a CPU
+ * @cpu: The CPU index of the CPU whose receive thread is to be parked
  *
- * This creates or destroys per-CPU data for fcoe
- *
- * Returns NOTIFY_OK always.
+ * Parks the per-CPU Rx thread. Any pending skbs are moved to the
+ * first online CPU's Rx thread.
  */
-static int fcoe_cpu_callback(struct notifier_block *nfb,
-			     unsigned long action, void *hcpu)
+static void fcoe_thread_park(unsigned int cpu)
 {
-	unsigned cpu = (unsigned long)hcpu;
+	struct fcoe_percpu_s *p;
+	struct fcoe_percpu_s *p_target;
+	unsigned int targ_cpu = cpumask_any_but(cpu_online_mask, cpu);
 
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		FCOE_DBG("CPU %x online: Create Rx thread\n", cpu);
-		fcoe_percpu_thread_create(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		FCOE_DBG("CPU %x offline: Remove Rx thread\n", cpu);
-		fcoe_percpu_thread_destroy(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
+	FCOE_DBG("Parking receive thread for CPU %d\n", cpu);
+
+	p = fcoe_thread_cleanup_local(cpu);
+
+	p_target = &per_cpu(fcoe_percpu, targ_cpu);
+	spin_lock_bh(&p_target->fcoe_rx_list.lock);
+	BUG_ON(!p_target->active);
+	FCOE_DBG("Moving frames from CPU %u to CPU %u\n", cpu, targ_cpu);
+
+	skb_queue_splice_tail(&p->fcoe_rx_list,
+			      &p_target->fcoe_rx_list);
+	spin_unlock_bh(&p_target->fcoe_rx_list.lock);
+}
+
+/**
+ * fcoe_thread_cleanup() - Cleanup the receive thread of a CPU
+ * @cpu: The CPU index of the CPU whose receive thread is to be cleaned up
+ * @online: true if the CPU is still online.
+ *
+ * Cleans up the per-CPU Rx thread. Any pending skbs are freed because this
+ * module will be removed. If the CPU is not online then it was parked and
+ * there are not resources bound to this per-CPU structure.
+ */
+static void fcoe_thread_cleanup(unsigned int cpu, bool online)
+{
+	struct fcoe_percpu_s *p;
+	struct sk_buff *skb;
+
+	if (!online)
+		return;
+	p = fcoe_thread_cleanup_local(cpu);
+
+	while ((skb = __skb_dequeue(&p->fcoe_rx_list)))
+		kfree_skb(skb);
 }
 
 /**
@@ -1494,7 +1423,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 
 	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock(&fps->fcoe_rx_list.lock);
-	if (unlikely(!fps->thread)) {
+	if (unlikely(!fps->active)) {
 		/*
 		 * The targeted CPU is not ready, let's target
 		 * the first CPU now. For non-SMP systems this
@@ -1508,7 +1437,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		cpu = cpumask_first(cpu_online_mask);
 		fps = &per_cpu(fcoe_percpu, cpu);
 		spin_lock(&fps->fcoe_rx_list.lock);
-		if (!fps->thread) {
+		if (!fps->active) {
 			spin_unlock(&fps->fcoe_rx_list.lock);
 			goto err;
 		}
@@ -1528,8 +1457,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	 * in softirq context.
 	 */
 	__skb_queue_tail(&fps->fcoe_rx_list, skb);
-	if (fps->thread->state == TASK_INTERRUPTIBLE)
-		wake_up_process(fps->thread);
+	wake_up_process(per_cpu_ptr(fcoe_percpu.kthread, cpu));
 	spin_unlock(&fps->fcoe_rx_list.lock);
 
 	return NET_RX_SUCCESS;
@@ -1842,40 +1770,42 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 }
 
 /**
- * fcoe_percpu_receive_thread() - The per-CPU packet receive thread
- * @arg: The per-CPU context
+ * fcoe_thread_receive() - The per-CPU packet receive thread
+ * @arg: The CPU number
  *
- * Return: 0 for success
  */
-static int fcoe_percpu_receive_thread(void *arg)
+static void fcoe_thread_receive(unsigned int cpu)
 {
-	struct fcoe_percpu_s *p = arg;
+	struct fcoe_percpu_s *p = per_cpu_ptr(&fcoe_percpu, cpu);
 	struct sk_buff *skb;
 	struct sk_buff_head tmp;
 
 	skb_queue_head_init(&tmp);
 
-	set_user_nice(current, MIN_NICE);
+	spin_lock_bh(&p->fcoe_rx_list.lock);
+	skb_queue_splice_init(&p->fcoe_rx_list, &tmp);
+	spin_unlock_bh(&p->fcoe_rx_list.lock);
 
-	while (!kthread_should_stop()) {
+	if (!skb_queue_len(&tmp))
+		return;
 
-		spin_lock_bh(&p->fcoe_rx_list.lock);
-		skb_queue_splice_init(&p->fcoe_rx_list, &tmp);
+	while ((skb = __skb_dequeue(&tmp)))
+		fcoe_recv_frame(skb);
 
-		if (!skb_queue_len(&tmp)) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_bh(&p->fcoe_rx_list.lock);
-			schedule();
-			continue;
-		}
+	return;
+}
 
-		spin_unlock_bh(&p->fcoe_rx_list.lock);
+static int fcoe_thread_should_run(unsigned int cpu)
+{
+	struct fcoe_percpu_s *p = per_cpu_ptr(&fcoe_percpu, cpu);
 
-		while ((skb = __skb_dequeue(&tmp)) != NULL)
-			fcoe_recv_frame(skb);
-
-	}
-	return 0;
+	/*
+	 * Lockless peek on the list to see if it is empty. Real check happens
+	 * in fcoe_thread_receive().
+	 */
+	if (skb_queue_empty(&p->fcoe_rx_list))
+		return 0;
+	return 1;
 }
 
 /**
@@ -2459,7 +2389,7 @@ static void fcoe_percpu_clean(struct fc_lport *lport)
 		spin_lock_bh(&pp->fcoe_rx_list.lock);
 		__skb_queue_tail(&pp->fcoe_rx_list, skb);
 		if (pp->fcoe_rx_list.qlen == 1)
-			wake_up_process(pp->thread);
+			wake_up_process(per_cpu_ptr(fcoe_percpu.kthread, cpu));
 		spin_unlock_bh(&pp->fcoe_rx_list.lock);
 
 		wait_for_completion(&fcoe_flush_completion);
@@ -2583,6 +2513,32 @@ static struct fcoe_transport fcoe_sw_transport = {
 	.disable = fcoe_disable,
 };
 
+static void fcoe_thread_setup(unsigned int cpu)
+{
+	struct fcoe_percpu_s *p = per_cpu_ptr(&fcoe_percpu, cpu);
+
+	set_user_nice(current, MIN_NICE);
+	skb_queue_head_init(&p->fcoe_rx_list);
+}
+
+static void fcoe_thread_unpark(unsigned int cpu)
+{
+	struct fcoe_percpu_s *p = per_cpu_ptr(&fcoe_percpu, cpu);
+
+	p->active = true;
+}
+
+static struct smp_hotplug_thread fcoe_threads = {
+	.store			= &fcoe_percpu.kthread,
+	.setup			= fcoe_thread_setup,
+	.cleanup		= fcoe_thread_cleanup,
+	.thread_should_run      = fcoe_thread_should_run,
+	.thread_fn              = fcoe_thread_receive,
+	.park			= fcoe_thread_park,
+	.unpark			= fcoe_thread_unpark,
+	.thread_comm            = "fcoethread/%u",
+};
+
 /**
  * fcoe_init() - Initialize fcoe.ko
  *
@@ -2590,8 +2546,6 @@ static struct fcoe_transport fcoe_sw_transport = {
  */
 static int __init fcoe_init(void)
 {
-	struct fcoe_percpu_s *p;
-	unsigned int cpu;
 	int rc = 0;
 
 	fcoe_wq = alloc_workqueue("fcoe", 0, 0);
@@ -2608,22 +2562,7 @@ static int __init fcoe_init(void)
 
 	mutex_lock(&fcoe_config_mutex);
 
-	for_each_possible_cpu(cpu) {
-		p = &per_cpu(fcoe_percpu, cpu);
-		skb_queue_head_init(&p->fcoe_rx_list);
-	}
-
-	cpu_notifier_register_begin();
-
-	for_each_online_cpu(cpu)
-		fcoe_percpu_thread_create(cpu);
-
-	/* Initialize per CPU interrupt thread */
-	rc = __register_hotcpu_notifier(&fcoe_cpu_notifier);
-	if (rc)
-		goto out_free;
-
-	cpu_notifier_register_done();
+	smpboot_register_percpu_thread(&fcoe_threads);
 
 	/* Setup link change notification */
 	fcoe_dev_setup();
@@ -2636,11 +2575,7 @@ static int __init fcoe_init(void)
 	return 0;
 
 out_free:
-	for_each_online_cpu(cpu) {
-		fcoe_percpu_thread_destroy(cpu);
-	}
-
-	cpu_notifier_register_done();
+	smpboot_unregister_percpu_thread(&fcoe_threads);
 
 	mutex_unlock(&fcoe_config_mutex);
 	destroy_workqueue(fcoe_wq);
@@ -2658,7 +2593,6 @@ static void __exit fcoe_exit(void)
 	struct fcoe_interface *fcoe, *tmp;
 	struct fcoe_ctlr *ctlr;
 	struct fcoe_port *port;
-	unsigned int cpu;
 
 	mutex_lock(&fcoe_config_mutex);
 
@@ -2674,14 +2608,7 @@ static void __exit fcoe_exit(void)
 	}
 	rtnl_unlock();
 
-	cpu_notifier_register_begin();
-
-	for_each_online_cpu(cpu)
-		fcoe_percpu_thread_destroy(cpu);
-
-	__unregister_hotcpu_notifier(&fcoe_cpu_notifier);
-
-	cpu_notifier_register_done();
+	smpboot_unregister_percpu_thread(&fcoe_threads);
 
 	mutex_unlock(&fcoe_config_mutex);
 
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index de7e3ee60f0c..74ea1ea9c1f6 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -319,17 +319,19 @@ struct fcoe_transport {
 
 /**
  * struct fcoe_percpu_s - The context for FCoE receive thread(s)
- * @thread:	    The thread context
+ * @kthread:	    The thread context of the smp_hotplug_thread
  * @fcoe_rx_list:   The queue of pending packets to process
  * @page:	    The memory page for calculating frame trailer CRCs
  * @crc_eof_offset: The offset into the CRC page pointing to available
  *		    memory for a new trailer
+ * @active:	    true if the queue is active and not being removed
  */
 struct fcoe_percpu_s {
-	struct task_struct *thread;
+	struct task_struct *kthread;
 	struct sk_buff_head fcoe_rx_list;
 	struct page *crc_eof_page;
 	int crc_eof_offset;
+	bool active;
 };
 
 /**
-- 
2.7.0

