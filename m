From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 11/11] scsi: bnx2fc: convert to smpboot thread
Date: Fri, 11 Mar 2016 16:29:03 +0100
Message-ID: <1457710143-29182-12-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37926 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbcCKP30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:26 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

The driver creates its own per-CPU threads which are updated based on
CPU hotplug events. It is also possible to delegate this task to the
smpboot-thread infrastructure and get the same job done while saving a
few lines of code.
The code checked ->iothread to decide if there is an active per-CPU
thread. With the smpboot infrastructure this is no longer possible and I
replaced its logic with the ->active member. The thread pointer is saved
in `kthread' instead of `iothread' so anything trying to use thread is
caught by the compiler.

The remaining part of the conversion is mostly straightforward.
This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |   3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 187 ++++++++++++--------------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   4 +-
 3 files changed, 64 insertions(+), 130 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 499e369eabf0..7bc5692bb493 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -168,9 +168,10 @@ extern struct fcoe_percpu_s bnx2fc_global;
 extern struct workqueue_struct *bnx2fc_wq;
 
 struct bnx2fc_percpu_s {
-	struct task_struct *iothread;
+	struct task_struct *kthread;
 	struct list_head work_list;
 	spinlock_t fp_work_lock;
+	bool active;
 };
 
 struct bnx2fc_fw_stats {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f5bc11b2e884..12ee035e9c4c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -14,6 +14,7 @@
  */
 
 #include "bnx2fc.h"
+#include <linux/smpboot.h>
 
 static struct list_head adapter_list;
 static struct list_head if_list;
@@ -98,13 +99,6 @@ static void __exit bnx2fc_mod_exit(void);
 unsigned int bnx2fc_debug_level;
 module_param_named(debug_logging, bnx2fc_debug_level, int, S_IRUGO|S_IWUSR);
 
-static int bnx2fc_cpu_callback(struct notifier_block *nfb,
-			     unsigned long action, void *hcpu);
-/* notification function for CPU hotplug events */
-static struct notifier_block bnx2fc_cpu_notifier = {
-	.notifier_call = bnx2fc_cpu_callback,
-};
-
 static inline struct net_device *bnx2fc_netdev(const struct fc_lport *lport)
 {
 	return ((struct bnx2fc_interface *)
@@ -591,40 +585,26 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	fc_exch_recv(lport, fp);
 }
 
-/**
- * bnx2fc_percpu_io_thread - thread per cpu for ios
- *
- * @arg:	ptr to bnx2fc_percpu_info structure
- */
-int bnx2fc_percpu_io_thread(void *arg)
+static void bnx2fc_thread_io_process(unsigned int cpu)
 {
-	struct bnx2fc_percpu_s *p = arg;
+	struct bnx2fc_percpu_s *p = per_cpu_ptr(&bnx2fc_percpu, cpu);
 	struct bnx2fc_work *work, *tmp;
 	LIST_HEAD(work_list);
 
-	set_user_nice(current, MIN_NICE);
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		spin_lock_bh(&p->fp_work_lock);
-		while (!list_empty(&p->work_list)) {
-			list_splice_init(&p->work_list, &work_list);
-			spin_unlock_bh(&p->fp_work_lock);
-
-			list_for_each_entry_safe(work, tmp, &work_list, list) {
-				list_del_init(&work->list);
-				bnx2fc_process_cq_compl(work->tgt, work->wqe);
-				kfree(work);
-			}
-
-			spin_lock_bh(&p->fp_work_lock);
-		}
-		__set_current_state(TASK_INTERRUPTIBLE);
+	spin_lock_bh(&p->fp_work_lock);
+	while (!list_empty(&p->work_list)) {
+		list_splice_init(&p->work_list, &work_list);
 		spin_unlock_bh(&p->fp_work_lock);
-	}
-	__set_current_state(TASK_RUNNING);
 
-	return 0;
+		list_for_each_entry_safe(work, tmp, &work_list, list) {
+			list_del_init(&work->list);
+			bnx2fc_process_cq_compl(work->tgt, work->wqe);
+			kfree(work);
+		}
+
+		spin_lock_bh(&p->fp_work_lock);
+	}
+	spin_unlock_bh(&p->fp_work_lock);
 }
 
 static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
@@ -2518,34 +2498,9 @@ static struct fcoe_transport bnx2fc_transport = {
 	.disable = bnx2fc_disable,
 };
 
-/**
- * bnx2fc_percpu_thread_create - Create a receive thread for an
- *				 online CPU
- *
- * @cpu: cpu index for the online cpu
- */
-static void bnx2fc_percpu_thread_create(unsigned int cpu)
+static void bnx2fc_thread_park(unsigned int cpu)
 {
 	struct bnx2fc_percpu_s *p;
-	struct task_struct *thread;
-
-	p = &per_cpu(bnx2fc_percpu, cpu);
-
-	thread = kthread_create_on_node(bnx2fc_percpu_io_thread,
-					(void *)p, cpu_to_node(cpu),
-					"bnx2fc_thread/%d", cpu);
-	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread = thread;
-		wake_up_process(thread);
-	}
-}
-
-static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
-{
-	struct bnx2fc_percpu_s *p;
-	struct task_struct *thread;
 	struct bnx2fc_work *work, *tmp;
 
 	BNX2FC_MISC_DBG("destroying io thread for CPU %d\n", cpu);
@@ -2553,9 +2508,7 @@ static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
 	/* Prevent any new work from being queued for this CPU */
 	p = &per_cpu(bnx2fc_percpu, cpu);
 	spin_lock_bh(&p->fp_work_lock);
-	thread = p->iothread;
-	p->iothread = NULL;
-
+	p->active = false;
 
 	/* Free all work in the list */
 	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
@@ -2565,44 +2518,52 @@ static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
 	}
 
 	spin_unlock_bh(&p->fp_work_lock);
-
-	if (thread)
-		kthread_stop(thread);
 }
 
-/**
- * bnx2fc_cpu_callback - Handler for CPU hotplug events
- *
- * @nfb:    The callback data block
- * @action: The event triggering the callback
- * @hcpu:   The index of the CPU that the event is for
- *
- * This creates or destroys per-CPU data for fcoe
- *
- * Returns NOTIFY_OK always.
- */
-static int bnx2fc_cpu_callback(struct notifier_block *nfb,
-			     unsigned long action, void *hcpu)
+static void bnx2fc_thread_cleanup(unsigned int cpu, bool online)
 {
-	unsigned cpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		printk(PFX "CPU %x online: Create Rx thread\n", cpu);
-		bnx2fc_percpu_thread_create(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		printk(PFX "CPU %x offline: Remove Rx thread\n", cpu);
-		bnx2fc_percpu_thread_destroy(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
+	if (!online)
+		return;
+	bnx2fc_thread_park(cpu);
 }
 
+static void bnx2fc_thread_setup(unsigned int cpu)
+{
+	struct bnx2fc_percpu_s *p = per_cpu_ptr(&bnx2fc_percpu, cpu);
+
+	set_user_nice(current, MIN_NICE);
+	INIT_LIST_HEAD(&p->work_list);
+	spin_lock_init(&p->fp_work_lock);
+}
+
+static int bnx2fc_thread_should_run(unsigned int cpu)
+{
+	struct bnx2fc_percpu_s *p = per_cpu_ptr(&bnx2fc_percpu, cpu);
+	/*
+	 * lockless peek at the list. Real check is done in
+	 * bnx2fc_thread_io_process()
+	 */
+	return !list_empty(&p->work_list);
+}
+
+static void bnx2fc_thread_unpark(unsigned int cpu)
+{
+	struct bnx2fc_percpu_s *p = per_cpu_ptr(&bnx2fc_percpu, cpu);
+
+	p->active = true;
+}
+
+static struct smp_hotplug_thread bnx2fc_threads = {
+	.store			= &bnx2fc_percpu.kthread,
+	.setup			= bnx2fc_thread_setup,
+	.cleanup		= bnx2fc_thread_cleanup,
+	.thread_should_run	= bnx2fc_thread_should_run,
+	.thread_fn		= bnx2fc_thread_io_process,
+	.park			= bnx2fc_thread_park,
+	.unpark			= bnx2fc_thread_unpark,
+	.thread_comm		= "bnx2fc_thread/%u",
+};
+
 /**
  * bnx2fc_mod_init - module init entry point
  *
@@ -2614,8 +2575,6 @@ static int __init bnx2fc_mod_init(void)
 	struct fcoe_percpu_s *bg;
 	struct task_struct *l2_thread;
 	int rc = 0;
-	unsigned int cpu = 0;
-	struct bnx2fc_percpu_s *p;
 
 	printk(KERN_INFO PFX "%s", version);
 
@@ -2657,23 +2616,7 @@ static int __init bnx2fc_mod_init(void)
 	bg->kthread = l2_thread;
 	spin_unlock_bh(&bg->fcoe_rx_list.lock);
 
-	for_each_possible_cpu(cpu) {
-		p = &per_cpu(bnx2fc_percpu, cpu);
-		INIT_LIST_HEAD(&p->work_list);
-		spin_lock_init(&p->fp_work_lock);
-	}
-
-	cpu_notifier_register_begin();
-
-	for_each_online_cpu(cpu) {
-		bnx2fc_percpu_thread_create(cpu);
-	}
-
-	/* Initialize per CPU interrupt thread */
-	__register_hotcpu_notifier(&bnx2fc_cpu_notifier);
-
-	cpu_notifier_register_done();
-
+	smpboot_register_percpu_thread(&bnx2fc_threads);
 	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
 
 	return 0;
@@ -2695,7 +2638,6 @@ static void __exit bnx2fc_mod_exit(void)
 	struct fcoe_percpu_s *bg;
 	struct task_struct *l2_thread;
 	struct sk_buff *skb;
-	unsigned int cpu = 0;
 
 	/*
 	 * NOTE: Since cnic calls register_driver routine rtnl_lock,
@@ -2737,16 +2679,7 @@ static void __exit bnx2fc_mod_exit(void)
 	if (l2_thread)
 		kthread_stop(l2_thread);
 
-	cpu_notifier_register_begin();
-
-	/* Destroy per cpu threads */
-	for_each_online_cpu(cpu) {
-		bnx2fc_percpu_thread_destroy(cpu);
-	}
-
-	__unregister_hotcpu_notifier(&bnx2fc_cpu_notifier);
-
-	cpu_notifier_register_done();
+	smpboot_unregister_percpu_thread(&bnx2fc_threads);
 
 	destroy_workqueue(bnx2fc_wq);
 	/*
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 1427062e86f0..33aad48effaf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1049,14 +1049,14 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 
 			fps = &per_cpu(bnx2fc_percpu, cpu);
 			spin_lock_bh(&fps->fp_work_lock);
-			if (unlikely(!fps->iothread))
+			if (unlikely(!fps->active))
 				goto unlock;
 
 			work = bnx2fc_alloc_work(tgt, wqe);
 			if (work) {
 				list_add_tail(&work->list,
 					      &fps->work_list);
-				wake_up_process(fps->iothread);
+				wake_up_process(fps->kthread);
 				process = false;
 			}
 unlock:
-- 
2.7.0

