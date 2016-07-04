From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] scsi: bnx2i: convert to kworker
Date: Mon,  4 Jul 2016 19:40:37 +0200
Message-ID: <1467654037-17339-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:59800 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbcGDRkx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2016 13:40:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

The driver creates its own per-CPU threads which are updated based on CPU
hotplug events. It is also possible to use kworkers and remove some of the
infrastructure get the same job done while saving a few lines of code.

The DECLARE_PER_CPU() definition is moved into the header file where it
belongs. bnx2i_percpu_io_thread() becomes bnx2i_percpu_io_work() which is
mostly the same code. The outer loop (kthread_should_stop()) gets removed and
the remaining code is shifted to the left.
bnx2i_queue_scsi_cmd_resp() is mostly the same. The code checked ->iothread to
decide if there is an active per-CPU thread. With the kworkers this is no
longer possible nor required.
The allocation of struct bnx2i_work does not happen with ->p_work_lock held
which is not required. I am unsure about the call-stack so I can't say
if this qualifies it for the allocation with GFP_KERNEL instead of
GFP_ATOMIC (it is not _bh lock but as I said, I don't know the context).
The allocation case has been reversed so the inner if case is called on
!bnx2i_work and is just the invocation one function since the lock is not
held during allocation. The init of the new bnx2i_work struct is now
done also without the ->p_work_lock held: it is a new object, nobody
knows about it yet. It should be enough to hold the lock while adding
this item to the list. I am unsure about that atomic_inc() so I keep
things as they were.

The remaining part is the removal CPU hotplug notifier since it is taken
care by the kworker code.

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2i/bnx2i.h      |  11 +---
 drivers/scsi/bnx2i/bnx2i_hwi.c  | 101 ++++++++++++++-------------------
 drivers/scsi/bnx2i/bnx2i_init.c | 121 +++-------------------------------------
 3 files changed, 53 insertions(+), 180 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index ed7f3228e234..78cdc493bab5 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -31,7 +31,6 @@
 #include <linux/netdevice.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
-#include <linux/cpu.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -775,12 +774,11 @@ struct bnx2i_work {
 };
 
 struct bnx2i_percpu_s {
-	struct task_struct *iothread;
+	struct work_struct work;
 	struct list_head work_list;
 	spinlock_t p_work_lock;
 };
 
-
 /* Global variables */
 extern unsigned int error_mask1, error_mask2;
 extern u64 iscsi_error_mask;
@@ -797,7 +795,7 @@ extern unsigned int rq_size;
 
 extern struct device_attribute *bnx2i_dev_attributes[];
 
-
+DECLARE_PER_CPU(struct bnx2i_percpu_s, bnx2i_percpu);
 
 /*
  * Function Prototypes
@@ -875,8 +873,5 @@ extern void bnx2i_print_active_cmd_queue(struct bnx2i_conn *conn);
 extern void bnx2i_print_xmit_pdu_queue(struct bnx2i_conn *conn);
 extern void bnx2i_print_recv_state(struct bnx2i_conn *conn);
 
-extern int bnx2i_percpu_io_thread(void *arg);
-extern int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
-				       struct bnx2i_conn *bnx2i_conn,
-				       struct cqe *cqe);
+extern void bnx2i_percpu_io_work(struct work_struct *work);
 #endif
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 42921dbba927..9be58f6523b3 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -19,8 +19,6 @@
 #include <scsi/libiscsi.h>
 #include "bnx2i.h"
 
-DECLARE_PER_CPU(struct bnx2i_percpu_s, bnx2i_percpu);
-
 /**
  * bnx2i_get_cid_num - get cid from ep
  * @ep: 	endpoint pointer
@@ -1350,9 +1348,9 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
  *
  * process SCSI CMD Response CQE & complete the request to SCSI-ML
  */
-int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
-				struct bnx2i_conn *bnx2i_conn,
-				struct cqe *cqe)
+static int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
+				       struct bnx2i_conn *bnx2i_conn,
+				       struct cqe *cqe)
 {
 	struct iscsi_conn *conn = bnx2i_conn->cls_conn->dd_data;
 	struct bnx2i_hba *hba = bnx2i_conn->hba;
@@ -1862,45 +1860,37 @@ static void bnx2i_process_cmd_cleanup_resp(struct iscsi_session *session,
 
 
 /**
- * bnx2i_percpu_io_thread - thread per cpu for ios
+ * bnx2i_percpu_io_work - thread per cpu for ios
  *
- * @arg:	ptr to bnx2i_percpu_info structure
+ * @work_s:	The work struct
  */
-int bnx2i_percpu_io_thread(void *arg)
+void bnx2i_percpu_io_work(struct work_struct *work_s)
 {
-	struct bnx2i_percpu_s *p = arg;
+	struct bnx2i_percpu_s *p;
 	struct bnx2i_work *work, *tmp;
 	LIST_HEAD(work_list);
 
-	set_user_nice(current, MIN_NICE);
+	p = container_of(work_s, struct bnx2i_percpu_s, work);
 
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
+	spin_lock_bh(&p->p_work_lock);
+	while (!list_empty(&p->work_list)) {
+		list_splice_init(&p->work_list, &work_list);
 		spin_unlock_bh(&p->p_work_lock);
-		schedule();
+
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
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
+	spin_unlock_bh(&p->p_work_lock);
 }
 
-
 /**
  * bnx2i_queue_scsi_cmd_resp - queue cmd completion to the percpu thread
  * @bnx2i_conn:		bnx2i connection
@@ -1920,7 +1910,6 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 	struct bnx2i_percpu_s *p = NULL;
 	struct iscsi_task *task;
 	struct scsi_cmnd *sc;
-	int rc = 0;
 	int cpu;
 
 	spin_lock(&session->back_lock);
@@ -1939,33 +1928,29 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 
 	spin_unlock(&session->back_lock);
 
-	p = &per_cpu(bnx2i_percpu, cpu);
-	spin_lock(&p->p_work_lock);
-	if (unlikely(!p->iothread)) {
-		rc = -EINVAL;
-		goto err;
-	}
 	/* Alloc and copy to the cqe */
 	bnx2i_work = kzalloc(sizeof(struct bnx2i_work), GFP_ATOMIC);
-	if (bnx2i_work) {
-		INIT_LIST_HEAD(&bnx2i_work->list);
-		bnx2i_work->session = session;
-		bnx2i_work->bnx2i_conn = bnx2i_conn;
-		memcpy(&bnx2i_work->cqe, cqe, sizeof(struct cqe));
-		list_add_tail(&bnx2i_work->list, &p->work_list);
-		atomic_inc(&bnx2i_conn->work_cnt);
-		wake_up_process(p->iothread);
-		spin_unlock(&p->p_work_lock);
-		goto done;
-	} else
-		rc = -ENOMEM;
-err:
-	spin_unlock(&p->p_work_lock);
-	bnx2i_process_scsi_cmd_resp(session, bnx2i_conn, (struct cqe *)cqe);
-done:
-	return rc;
-}
+	if (!bnx2i_work) {
+		bnx2i_process_scsi_cmd_resp(session, bnx2i_conn,
+					    (struct cqe *)cqe);
+		return -ENOMEM;
+	}
 
+	p = per_cpu_ptr(&bnx2i_percpu, cpu);
+
+	INIT_LIST_HEAD(&bnx2i_work->list);
+	bnx2i_work->session = session;
+	bnx2i_work->bnx2i_conn = bnx2i_conn;
+	memcpy(&bnx2i_work->cqe, cqe, sizeof(struct cqe));
+
+	spin_lock(&p->p_work_lock);
+	list_add_tail(&bnx2i_work->list, &p->work_list);
+	atomic_inc(&bnx2i_conn->work_cnt);
+	spin_unlock(&p->p_work_lock);
+
+	schedule_work_on(cpu, &p->work);
+	return 0;
+}
 
 /**
  * bnx2i_process_new_cqes - process newly DMA'ed CQE's
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index c8b410c24cf0..976a6bc86d39 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
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
@@ -410,93 +402,6 @@ int bnx2i_get_stats(void *handle)
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
-{
-	struct bnx2i_percpu_s *p;
-	struct task_struct *thread;
-
-	p = &per_cpu(bnx2i_percpu, cpu);
-
-	thread = kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
-					cpu_to_node(cpu),
-					"bnx2i_thread/%d", cpu);
-	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread = thread;
-		wake_up_process(thread);
-	}
-}
-
-
-static void bnx2i_percpu_thread_destroy(unsigned int cpu)
-{
-	struct bnx2i_percpu_s *p;
-	struct task_struct *thread;
-	struct bnx2i_work *work, *tmp;
-
-	/* Prevent any new work from being queued for this CPU */
-	p = &per_cpu(bnx2i_percpu, cpu);
-	spin_lock_bh(&p->p_work_lock);
-	thread = p->iothread;
-	p->iothread = NULL;
-
-	/* Free all work in the list */
-	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
-		list_del_init(&work->list);
-		bnx2i_process_scsi_cmd_resp(work->session,
-					    work->bnx2i_conn, &work->cqe);
-		kfree(work);
-	}
-
-	spin_unlock_bh(&p->p_work_lock);
-	if (thread)
-		kthread_stop(thread);
-}
-
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
-{
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
-}
-
-
 /**
  * bnx2i_mod_init - module init entry point
  *
@@ -533,22 +438,12 @@ static int __init bnx2i_mod_init(void)
 
 	/* Create percpu kernel threads to handle iSCSI I/O completions */
 	for_each_possible_cpu(cpu) {
-		p = &per_cpu(bnx2i_percpu, cpu);
+		p = per_cpu_ptr(&bnx2i_percpu, cpu);
 		INIT_LIST_HEAD(&p->work_list);
 		spin_lock_init(&p->p_work_lock);
-		p->iothread = NULL;
+		INIT_WORK(&p->work, bnx2i_percpu_io_work);
 	}
 
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
 	return 0;
 
 unreg_xport:
@@ -587,14 +482,12 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	cpu_notifier_register_begin();
+	for_each_possible_cpu(cpu) {
+		struct bnx2i_percpu_s *p;
 
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-
-	__unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
-
-	cpu_notifier_register_done();
+		p = per_cpu_ptr(&bnx2i_percpu, cpu);
+		flush_work(&p->work);
+	}
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
-- 
2.8.1

