From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 09/11] scsi: bnx2i: convert to smpboot thread
Date: Fri, 11 Mar 2016 16:29:01 +0100
Message-ID: <1457710143-29182-10-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37946 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbcCKP33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:29 -0500
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
in `kthread' instead of `iothread' so anything trying to use `thread' is
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
 drivers/scsi/bnx2i/bnx2i.h      |   4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c  |  45 +----------
 drivers/scsi/bnx2i/bnx2i_init.c | 162 ++++++++++++++++------------------------
 3 files changed, 69 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index ed7f3228e234..2bbccf571a18 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -775,9 +775,10 @@ struct bnx2i_work {
 };
 
 struct bnx2i_percpu_s {
-	struct task_struct *iothread;
+	struct task_struct *kthread;
 	struct list_head work_list;
 	spinlock_t p_work_lock;
+	bool active;
 };
 
 
@@ -875,7 +876,6 @@ extern void bnx2i_print_active_cmd_queue(struct bnx2i_conn *conn);
 extern void bnx2i_print_xmit_pdu_queue(struct bnx2i_conn *conn);
 extern void bnx2i_print_recv_state(struct bnx2i_conn *conn);
 
-extern int bnx2i_percpu_io_thread(void *arg);
 extern int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 				       struct bnx2i_conn *bnx2i_conn,
 				       struct cqe *cqe);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index fb072cc5e9fd..ec3969732846 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1860,47 +1860,6 @@ static void bnx2i_process_cmd_cleanup_resp(struct iscsi_session *session,
 	complete(&bnx2i_conn->cmd_cleanup_cmpl);
 }
 
-
-/**
- * bnx2i_percpu_io_thread - thread per cpu for ios
- *
- * @arg:	ptr to bnx2i_percpu_info structure
- */
-int bnx2i_percpu_io_thread(void *arg)
-{
-	struct bnx2i_percpu_s *p = arg;
-	struct bnx2i_work *work, *tmp;
-	LIST_HEAD(work_list);
-
-	set_user_nice(current, MIN_NICE);
-
-	while (!kthread_should_stop()) {
-		spin_lock_bh(&p->p_work_lock);
-		while (!list_empty(&p->work_list)) {
-			list_splice_init(&p->work_list, &work_list);
-			spin_unlock_bh(&p->p_work_lock);
-
-			list_for_each_entry_safe(work, tmp, &work_list, list) {
-				list_del_init(&work->list);
-				/* work allocated in the bh, freed here */
-				bnx2i_process_scsi_cmd_resp(work->session,
-							    work->bnx2i_conn,
-							    &work->cqe);
-				atomic_dec(&work->bnx2i_conn->work_cnt);
-				kfree(work);
-			}
-			spin_lock_bh(&p->p_work_lock);
-		}
-		set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock_bh(&p->p_work_lock);
-		schedule();
-	}
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-
 /**
  * bnx2i_queue_scsi_cmd_resp - queue cmd completion to the percpu thread
  * @bnx2i_conn:		bnx2i connection
@@ -1941,7 +1900,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 
 	p = &per_cpu(bnx2i_percpu, cpu);
 	spin_lock(&p->p_work_lock);
-	if (unlikely(!p->iothread)) {
+	if (unlikely(!p->active)) {
 		rc = -EINVAL;
 		goto err;
 	}
@@ -1954,7 +1913,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 		memcpy(&bnx2i_work->cqe, cqe, sizeof(struct cqe));
 		list_add_tail(&bnx2i_work->list, &p->work_list);
 		atomic_inc(&bnx2i_conn->work_cnt);
-		wake_up_process(p->iothread);
+		wake_up_process(p->kthread);
 		spin_unlock(&p->p_work_lock);
 		goto done;
 	} else
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index c8b410c24cf0..4ec8c552cc95 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -13,8 +13,8 @@
  * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
-
 #include "bnx2i.h"
+#include <linux/smpboot.h>
 
 static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
@@ -70,14 +70,6 @@ u64 iscsi_error_mask = 0x00;
 
 DEFINE_PER_CPU(struct bnx2i_percpu_s, bnx2i_percpu);
 
-static int bnx2i_cpu_callback(struct notifier_block *nfb,
-			      unsigned long action, void *hcpu);
-/* notification function for CPU hotplug events */
-static struct notifier_block bnx2i_cpu_notifier = {
-	.notifier_call = bnx2i_cpu_callback,
-};
-
-
 /**
  * bnx2i_identify_device - identifies NetXtreme II device type
  * @hba: 		Adapter structure pointer
@@ -410,92 +402,95 @@ int bnx2i_get_stats(void *handle)
 	return 0;
 }
 
-
-/**
- * bnx2i_percpu_thread_create - Create a receive thread for an
- *				online CPU
- *
- * @cpu:	cpu index for the online cpu
- */
-static void bnx2i_percpu_thread_create(unsigned int cpu)
+static void bnx2i_thread_io_process(unsigned int cpu)
 {
-	struct bnx2i_percpu_s *p;
-	struct task_struct *thread;
+	struct bnx2i_percpu_s *p = per_cpu_ptr(&bnx2i_percpu, cpu);
+	struct bnx2i_work *work, *tmp;
+	LIST_HEAD(work_list);
 
-	p = &per_cpu(bnx2i_percpu, cpu);
+	spin_lock_bh(&p->p_work_lock);
+	while (!list_empty(&p->work_list)) {
+		list_splice_init(&p->work_list, &work_list);
+		spin_unlock_bh(&p->p_work_lock);
 
-	thread = kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
-					cpu_to_node(cpu),
-					"bnx2i_thread/%d", cpu);
-	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread = thread;
-		wake_up_process(thread);
+		list_for_each_entry_safe(work, tmp, &work_list, list) {
+			list_del_init(&work->list);
+			/* work allocated in the bh, freed here */
+			bnx2i_process_scsi_cmd_resp(work->session,
+						    work->bnx2i_conn,
+						    &work->cqe);
+			atomic_dec(&work->bnx2i_conn->work_cnt);
+			kfree(work);
+		}
+		spin_lock_bh(&p->p_work_lock);
 	}
+	spin_unlock_bh(&p->p_work_lock);
 }
 
+static void bnx2i_thread_setup(unsigned int cpu)
+{
+	struct bnx2i_percpu_s *p = per_cpu_ptr(&bnx2i_percpu, cpu);
 
-static void bnx2i_percpu_thread_destroy(unsigned int cpu)
+	set_user_nice(current, MIN_NICE);
+	INIT_LIST_HEAD(&p->work_list);
+	spin_lock_init(&p->p_work_lock);
+}
+
+static int bnx2i_thread_should_run(unsigned int cpu)
+{
+	struct bnx2i_percpu_s *p = per_cpu_ptr(&bnx2i_percpu, cpu);
+	/*
+	 * A lockless peek at the list. The real check is done in
+	 * bnx2i_thread_io_process()
+	 */
+	return !list_empty(&p->work_list);
+}
+
+static void bnx2i_thread_park(unsigned int cpu)
 {
 	struct bnx2i_percpu_s *p;
-	struct task_struct *thread;
 	struct bnx2i_work *work, *tmp;
 
 	/* Prevent any new work from being queued for this CPU */
 	p = &per_cpu(bnx2i_percpu, cpu);
 	spin_lock_bh(&p->p_work_lock);
-	thread = p->iothread;
-	p->iothread = NULL;
+	p->active = false;
 
 	/* Free all work in the list */
 	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
 		list_del_init(&work->list);
-		bnx2i_process_scsi_cmd_resp(work->session,
-					    work->bnx2i_conn, &work->cqe);
+		bnx2i_process_scsi_cmd_resp(work->session, work->bnx2i_conn,
+					    &work->cqe);
 		kfree(work);
 	}
 
 	spin_unlock_bh(&p->p_work_lock);
-	if (thread)
-		kthread_stop(thread);
 }
 
-
-/**
- * bnx2i_cpu_callback - Handler for CPU hotplug events
- *
- * @nfb:	The callback data block
- * @action:	The event triggering the callback
- * @hcpu:	The index of the CPU that the event is for
- *
- * This creates or destroys per-CPU data for iSCSI
- *
- * Returns NOTIFY_OK always.
- */
-static int bnx2i_cpu_callback(struct notifier_block *nfb,
-			      unsigned long action, void *hcpu)
+static void bnx2i_thread_cleanup(unsigned int cpu, bool online)
 {
-	unsigned cpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		printk(KERN_INFO "bnx2i: CPU %x online: Create Rx thread\n",
-			cpu);
-		bnx2i_percpu_thread_create(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		printk(KERN_INFO "CPU %x offline: Remove Rx thread\n", cpu);
-		bnx2i_percpu_thread_destroy(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
+	if (!online)
+		return;
+	bnx2i_thread_park(cpu);
 }
 
+static void bnx2i_thread_unpark(unsigned int cpu)
+{
+	struct bnx2i_percpu_s *p = per_cpu_ptr(&bnx2i_percpu, cpu);
+
+	p->active = true;
+}
+
+static struct smp_hotplug_thread bnx2i_threads = {
+	.store                  = &bnx2i_percpu.kthread,
+	.setup                  = bnx2i_thread_setup,
+	.cleanup		= bnx2i_thread_cleanup,
+	.thread_should_run      = bnx2i_thread_should_run,
+	.thread_fn              = bnx2i_thread_io_process,
+	.park                   = bnx2i_thread_park,
+	.unpark                 = bnx2i_thread_unpark,
+	.thread_comm            = "bnx2i_thread/%u",
+};
 
 /**
  * bnx2i_mod_init - module init entry point
@@ -507,8 +502,6 @@ static int bnx2i_cpu_callback(struct notifier_block *nfb,
 static int __init bnx2i_mod_init(void)
 {
 	int err;
-	unsigned cpu = 0;
-	struct bnx2i_percpu_s *p;
 
 	printk(KERN_INFO "%s", version);
 
@@ -531,24 +524,7 @@ static int __init bnx2i_mod_init(void)
 		goto unreg_xport;
 	}
 
-	/* Create percpu kernel threads to handle iSCSI I/O completions */
-	for_each_possible_cpu(cpu) {
-		p = &per_cpu(bnx2i_percpu, cpu);
-		INIT_LIST_HEAD(&p->work_list);
-		spin_lock_init(&p->p_work_lock);
-		p->iothread = NULL;
-	}
-
-	cpu_notifier_register_begin();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_create(cpu);
-
-	/* Initialize per CPU interrupt thread */
-	__register_hotcpu_notifier(&bnx2i_cpu_notifier);
-
-	cpu_notifier_register_done();
-
+	smpboot_register_percpu_thread(&bnx2i_threads);
 	return 0;
 
 unreg_xport:
@@ -569,7 +545,6 @@ static int __init bnx2i_mod_init(void)
 static void __exit bnx2i_mod_exit(void)
 {
 	struct bnx2i_hba *hba;
-	unsigned cpu = 0;
 
 	mutex_lock(&bnx2i_dev_lock);
 	while (!list_empty(&adapter_list)) {
@@ -587,14 +562,7 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	cpu_notifier_register_begin();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-
-	__unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
-
-	cpu_notifier_register_done();
+	smpboot_unregister_percpu_thread(&bnx2i_threads);
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
-- 
2.7.0

