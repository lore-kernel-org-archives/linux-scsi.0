From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/14] fcoe: create/destroy fcoe Rx threads on CPU hotplug
	events
Date: Tue, 17 Mar 2009 11:41:46 -0700
Message-ID: <20090317184145.22987.97528.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbZCQSls (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:41:48 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This patch adds support for dynamically created Rx threads
upon CPU hotplug events.

There were existing synchronization problems that this patch
attempts to resolve. The main problem had to do with fcoe_rcv()
running in a different context than the hotplug notifications.
This opened the possiblity that fcoe_rcv() would target a Rx
thread for a skb. However, that thread could become NULL if
the CPU was made offline.

This patch uses the Rx queue's (a skb_queue) lock to protect
the thread it's associated with and we use the 'thread' member
of the fcoe_percpu_s to determine if the thread is ready to
accept new skbs.

The patch also attempts to do a better job of cleaning up, both
if hotplug registration fails as well as when the module is
removed.

Contribution provided by Joe Eykholt <jeykholt@cisco.com> to
fix incorrect use of __cpuinitdata.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |  246 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 199 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 648a2fc..951d244 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -81,6 +81,156 @@ static struct notifier_block fcoe_notifier = {
 };
 
 /**
+ * fcoe_percpu_thread_create() - Create a receive thread for an online cpu
+ * @cpu: cpu index for the online cpu
+ */
+static void fcoe_percpu_thread_create(unsigned int cpu)
+{
+	struct fcoe_percpu_s *p;
+	struct task_struct *thread;
+
+	p = &per_cpu(fcoe_percpu, cpu);
+
+	thread = kthread_create(fcoe_percpu_receive_thread,
+				(void *)p, "fcoethread/%d", cpu);
+
+	if (likely(!IS_ERR(p->thread))) {
+		kthread_bind(thread, cpu);
+		wake_up_process(thread);
+
+		spin_lock_bh(&p->fcoe_rx_list.lock);
+		p->thread = thread;
+		spin_unlock_bh(&p->fcoe_rx_list.lock);
+	}
+}
+
+/**
+ * fcoe_percpu_thread_destroy() - removes the rx thread for the given cpu
+ * @cpu: cpu index the rx thread is to be removed
+ *
+ * Destroys a per-CPU Rx thread. Any pending skbs are moved to the
+ * current CPU's Rx thread. If the thread being destroyed is bound to
+ * the CPU processing this context the skbs will be freed.
+ */
+static void fcoe_percpu_thread_destroy(unsigned int cpu)
+{
+	struct fcoe_percpu_s *p;
+	struct task_struct *thread;
+	struct page *crc_eof;
+	struct sk_buff *skb;
+#ifdef CONFIG_SMP
+	struct fcoe_percpu_s *p0;
+	unsigned targ_cpu = smp_processor_id();
+#endif /* CONFIG_SMP */
+
+	printk(KERN_DEBUG "fcoe: Destroying receive thread for CPU %d\n", cpu);
+
+	/* Prevent any new skbs from being queued for this CPU. */
+	p = &per_cpu(fcoe_percpu, cpu);
+	spin_lock_bh(&p->fcoe_rx_list.lock);
+	thread = p->thread;
+	p->thread = NULL;
+	crc_eof = p->crc_eof_page;
+	p->crc_eof_page = NULL;
+	p->crc_eof_offset = 0;
+	spin_unlock_bh(&p->fcoe_rx_list.lock);
+
+#ifdef CONFIG_SMP
+	/*
+	 * Don't bother moving the skb's if this context is running
+	 * on the same CPU that is having its thread destroyed. This
+	 * can easily happen when the module is removed.
+	 */
+	if (cpu != targ_cpu) {
+		p0 = &per_cpu(fcoe_percpu, targ_cpu);
+		spin_lock_bh(&p0->fcoe_rx_list.lock);
+		if (p0->thread) {
+			FC_DBG("Moving frames from CPU %d to CPU %d\n",
+			       cpu, targ_cpu);
+
+			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
+				__skb_queue_tail(&p0->fcoe_rx_list, skb);
+			spin_unlock_bh(&p0->fcoe_rx_list.lock);
+		} else {
+			/*
+			 * The targeted CPU is not initialized and cannot accept
+			 * new  skbs. Unlock the targeted CPU and drop the skbs
+			 * on the CPU that is going offline.
+			 */
+			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
+				kfree_skb(skb);
+			spin_unlock_bh(&p0->fcoe_rx_list.lock);
+		}
+	} else {
+		/*
+		 * This scenario occurs when the module is being removed
+		 * and all threads are being destroyed. skbs will continue
+		 * to be shifted from the CPU thread that is being removed
+		 * to the CPU thread associated with the CPU that is processing
+		 * the module removal. Once there is only one CPU Rx thread it
+		 * will reach this case and we will drop all skbs and later
+		 * stop the thread.
+		 */
+		spin_lock_bh(&p->fcoe_rx_list.lock);
+		while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
+			kfree_skb(skb);
+		spin_unlock_bh(&p->fcoe_rx_list.lock);
+	}
+#else
+	/*
+	 * This a non-SMP scenario where the singluar Rx thread is
+	 * being removed. Free all skbs and stop the thread.
+	 */
+	spin_lock_bh(&p->fcoe_rx_list.lock);
+	while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
+		kfree_skb(skb);
+	spin_unlock_bh(&p->fcoe_rx_list.lock);
+#endif
+
+	if (thread)
+		kthread_stop(thread);
+
+	if (crc_eof)
+		put_page(crc_eof);
+}
+
+/**
+ * fcoe_cpu_callback() - fcoe cpu hotplug event callback
+ * @nfb: callback data block
+ * @action: event triggering the callback
+ * @hcpu: index for the cpu of this event
+ *
+ * This creates or destroys per cpu data for fcoe
+ *
+ * Returns NOTIFY_OK always.
+ */
+static int fcoe_cpu_callback(struct notifier_block *nfb,
+			     unsigned long action, void *hcpu)
+{
+	unsigned cpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		FC_DBG("CPU %x online: Create Rx thread\n", cpu);
+		fcoe_percpu_thread_create(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		FC_DBG("CPU %x offline: Remove Rx thread\n", cpu);
+		fcoe_percpu_thread_destroy(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block fcoe_cpu_notifier = {
+	.notifier_call = fcoe_cpu_callback,
+};
+
+/**
  * fcoe_rcv() - this is the fcoe receive function called by NET_RX_SOFTIRQ
  * @skb: the receive skb
  * @dev: associated net device
@@ -100,7 +250,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
 	unsigned short oxid;
-	unsigned int cpu_idx;
+	unsigned int cpu = 0;
 
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	lp = fc->lp;
@@ -140,25 +290,42 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fr = fcoe_dev_from_skb(skb);
 	fr->fr_dev = lp;
 	fr->ptype = ptype;
-	cpu_idx = 0;
 
 #ifdef CONFIG_SMP
 	/*
 	 * The incoming frame exchange id(oxid) is ANDed with num of online
-	 * cpu bits to get cpu_idx and then this cpu_idx is used for selecting
-	 * a per cpu kernel thread from fcoe_percpu. In case the cpu is
-	 * offline or no kernel thread for derived cpu_idx then cpu_idx is
-	 * initialize to first online cpu index.
+	 * cpu bits to get cpu and then this cpu is used for selecting
+	 * a per cpu kernel thread from fcoe_percpu.
 	 */
-	cpu_idx = oxid & (num_online_cpus() - 1);
-	if (!cpu_online(cpu_idx))
-		cpu_idx = first_cpu(cpu_online_map);
-
+	cpu = oxid & (num_online_cpus() - 1);
 #endif
 
-	fps = &per_cpu(fcoe_percpu, cpu_idx);
-
+	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock_bh(&fps->fcoe_rx_list.lock);
+	if (unlikely(!fps->thread)) {
+		/*
+		 * The targeted CPU is not ready, let's target
+		 * the first CPU now. For non-SMP systems this
+		 * will check the same CPU twice.
+		 */
+		FC_DBG("CPU is online, but no receive thread ready "
+		       "for incoming skb- using first online CPU.\n");
+
+		spin_unlock_bh(&fps->fcoe_rx_list.lock);
+		cpu = first_cpu(cpu_online_map);
+		fps = &per_cpu(fcoe_percpu, cpu);
+		spin_lock_bh(&fps->fcoe_rx_list.lock);
+		if (!fps->thread) {
+			spin_unlock_bh(&fps->fcoe_rx_list.lock);
+			goto err;
+		}
+	}
+
+	/*
+	 * We now have a valid CPU that we're targeting for
+	 * this skb. We also have this receive thread locked,
+	 * so we're free to queue skbs into it's queue.
+	 */
 	__skb_queue_tail(&fps->fcoe_rx_list, skb);
 	if (fps->fcoe_rx_list.qlen == 1)
 		wake_up_process(fps->thread);
@@ -214,7 +381,7 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 			return -ENOMEM;
 		}
 		fps->crc_eof_page = page;
-		WARN_ON(fps->crc_eof_offset != 0);
+		fps->crc_eof_offset = 0;
 	}
 
 	get_page(page);
@@ -1271,6 +1438,7 @@ EXPORT_SYMBOL_GPL(fcoe_libfc_config);
 static int __init fcoe_init(void)
 {
 	unsigned int cpu;
+	int rc = 0;
 	struct fcoe_percpu_s *p;
 
 	INIT_LIST_HEAD(&fcoe_hostlist);
@@ -1281,29 +1449,15 @@ static int __init fcoe_init(void)
 		skb_queue_head_init(&p->fcoe_rx_list);
 	}
 
-	/*
-	 * initialize per CPU interrupt thread
-	 */
-	for_each_online_cpu(cpu) {
-		p = &per_cpu(fcoe_percpu, cpu);
-		p->thread = kthread_create(fcoe_percpu_receive_thread,
-					   (void *)p, "fcoethread/%d", cpu);
+	for_each_online_cpu(cpu)
+		fcoe_percpu_thread_create(cpu);
 
-		/*
-		 * If there is no error then bind the thread to the CPU
-		 * and wake it up.
-		 */
-		if (!IS_ERR(p->thread)) {
-			kthread_bind(p->thread, cpu);
-			wake_up_process(p->thread);
-		} else {
-			p->thread = NULL;
-		}
-	}
+	/* Initialize per CPU interrupt thread */
+	rc = register_hotcpu_notifier(&fcoe_cpu_notifier);
+	if (rc)
+		goto out_free;
 
-	/*
-	 * setup link change notification
-	 */
+	/* Setup link change notification */
 	fcoe_dev_setup();
 
 	setup_timer(&fcoe_timer, fcoe_watchdog, 0);
@@ -1316,6 +1470,13 @@ static int __init fcoe_init(void)
 	fcoe_sw_init();
 
 	return 0;
+
+out_free:
+	for_each_online_cpu(cpu) {
+		fcoe_percpu_thread_destroy(cpu);
+	}
+
+	return rc;
 }
 module_init(fcoe_init);
 
@@ -1328,8 +1489,6 @@ static void __exit fcoe_exit(void)
 {
 	unsigned int cpu;
 	struct fcoe_softc *fc, *tmp;
-	struct fcoe_percpu_s *p;
-	struct sk_buff *skb;
 
 	fcoe_dev_cleanup();
 
@@ -1340,17 +1499,10 @@ static void __exit fcoe_exit(void)
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
 		fcoe_transport_release(fc->real_dev);
 
-	for_each_possible_cpu(cpu) {
-		p = &per_cpu(fcoe_percpu, cpu);
-		if (p->thread) {
-			kthread_stop(p->thread);
-			spin_lock_bh(&p->fcoe_rx_list.lock);
-			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
-				kfree_skb(skb);
-			spin_unlock_bh(&p->fcoe_rx_list.lock);
-			if (p->crc_eof_page)
-				put_page(p->crc_eof_page);
-		}
+	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
+
+	for_each_online_cpu(cpu) {
+		fcoe_percpu_thread_destroy(cpu);
 	}
 
 	/* remove sw trasnport */

