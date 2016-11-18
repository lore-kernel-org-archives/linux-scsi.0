From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/5] scsi: bnx2fc: convert per-CPU thread to kworker
Date: Fri, 18 Nov 2016 11:10:16 +0100
Message-ID: <20161118101019.2317-3-bigeasy@linutronix.de>
References: <20161118101019.2317-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:51357 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbcKRKKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 05:10:50 -0500
In-Reply-To: <20161118101019.2317-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The driver creates its own per-CPU threads which are updated based on CPU
hotplug events. It is also possible to use kworkers and remove some of the
infrastructure get the same job done while saving a few lines of code.

bnx2fc_percpu_io_thread() becomes bnx2fc_percpu_io_work() which is
mostly the same code. The outer loop (kthread_should_stop()) gets
removed and the remaining code is shifted to the left.
In bnx2fc_process_new_cqes() the code checked for ->iothread to
decide if there is an active per-CPU thread. With the kworkers this
is no longer possible nor required. The allocation of a new work item
(via bnx2fc_alloc_work()) does no longer happen with the ->fp_work_lock
lock held. It performs only a memory allocation + initialization which
does not require any kind of serialization. The lock is held while
adding the new member to fps->work_list list.

The remaining part is the removal CPU hotplug notifier since it is taken
care by the kworker code.

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 157 ++++++----------------------------=
----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |  22 +++---
 3 files changed, 32 insertions(+), 149 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index fdd4eb4e41b2..fdd89935cac7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -168,7 +168,7 @@ extern struct fcoe_percpu_s bnx2fc_global;
 extern struct workqueue_struct *bnx2fc_wq;
=20
 struct bnx2fc_percpu_s {
-	struct task_struct *iothread;
+	struct work_struct work;
 	struct list_head work_list;
 	spinlock_t fp_work_lock;
 };
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc=
_fcoe.c
index f9ddb6156f14..79ff0ed2b364 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -127,13 +127,6 @@ module_param_named(log_fka, bnx2fc_log_fka, uint, S_IR=
UGO|S_IWUSR);
 MODULE_PARM_DESC(log_fka, " Print message to kernel log when fcoe is "
 	"initiating a FIP keep alive when debug logging is enabled.");
=20
-static int bnx2fc_cpu_callback(struct notifier_block *nfb,
-			     unsigned long action, void *hcpu);
-/* notification function for CPU hotplug events */
-static struct notifier_block bnx2fc_cpu_notifier =3D {
-	.notifier_call =3D bnx2fc_cpu_callback,
-};
-
 static inline struct net_device *bnx2fc_netdev(const struct fc_lport *lpor=
t)
 {
 	return ((struct bnx2fc_interface *)
@@ -621,39 +614,32 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 }
=20
 /**
- * bnx2fc_percpu_io_thread - thread per cpu for ios
+ * bnx2fc_percpu_io_work - work per cpu for ios
  *
- * @arg:	ptr to bnx2fc_percpu_info structure
+ * @work_s:	The work struct
  */
-static int bnx2fc_percpu_io_thread(void *arg)
+static void bnx2fc_percpu_io_work(struct work_struct *work_s)
 {
-	struct bnx2fc_percpu_s *p =3D arg;
+	struct bnx2fc_percpu_s *p;
 	struct bnx2fc_work *work, *tmp;
 	LIST_HEAD(work_list);
=20
-	set_user_nice(current, MIN_NICE);
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		spin_lock_bh(&p->fp_work_lock);
-		while (!list_empty(&p->work_list)) {
-			list_splice_init(&p->work_list, &work_list);
-			spin_unlock_bh(&p->fp_work_lock);
+	p =3D container_of(work_s, struct bnx2fc_percpu_s, work);
=20
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
=20
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
=20
 static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *=
shost)
@@ -2571,91 +2557,6 @@ static struct fcoe_transport bnx2fc_transport =3D {
 	.disable =3D bnx2fc_disable,
 };
=20
-/**
- * bnx2fc_percpu_thread_create - Create a receive thread for an
- *				 online CPU
- *
- * @cpu: cpu index for the online cpu
- */
-static void bnx2fc_percpu_thread_create(unsigned int cpu)
-{
-	struct bnx2fc_percpu_s *p;
-	struct task_struct *thread;
-
-	p =3D &per_cpu(bnx2fc_percpu, cpu);
-
-	thread =3D kthread_create_on_node(bnx2fc_percpu_io_thread,
-					(void *)p, cpu_to_node(cpu),
-					"bnx2fc_thread/%d", cpu);
-	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread =3D thread;
-		wake_up_process(thread);
-	}
-}
-
-static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
-{
-	struct bnx2fc_percpu_s *p;
-	struct task_struct *thread;
-	struct bnx2fc_work *work, *tmp;
-
-	BNX2FC_MISC_DBG("destroying io thread for CPU %d\n", cpu);
-
-	/* Prevent any new work from being queued for this CPU */
-	p =3D &per_cpu(bnx2fc_percpu, cpu);
-	spin_lock_bh(&p->fp_work_lock);
-	thread =3D p->iothread;
-	p->iothread =3D NULL;
-
-
-	/* Free all work in the list */
-	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
-		list_del_init(&work->list);
-		bnx2fc_process_cq_compl(work->tgt, work->wqe);
-		kfree(work);
-	}
-
-	spin_unlock_bh(&p->fp_work_lock);
-
-	if (thread)
-		kthread_stop(thread);
-}
-
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
-{
-	unsigned cpu =3D (unsigned long)hcpu;
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
-}
-
 static int bnx2fc_slave_configure(struct scsi_device *sdev)
 {
 	if (!bnx2fc_queue_depth)
@@ -2723,19 +2624,9 @@ static int __init bnx2fc_mod_init(void)
 		p =3D &per_cpu(bnx2fc_percpu, cpu);
 		INIT_LIST_HEAD(&p->work_list);
 		spin_lock_init(&p->fp_work_lock);
+		INIT_WORK(&p->work, bnx2fc_percpu_io_work);
 	}
=20
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
 	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
=20
 	return 0;
@@ -2798,17 +2689,13 @@ static void __exit bnx2fc_mod_exit(void)
 	if (l2_thread)
 		kthread_stop(l2_thread);
=20
-	cpu_notifier_register_begin();
+	for_each_possible_cpu(cpu) {
+		struct bnx2fc_percpu_s *p;
=20
-	/* Destroy per cpu threads */
-	for_each_online_cpu(cpu) {
-		bnx2fc_percpu_thread_destroy(cpu);
+		p =3D per_cpu_ptr(&bnx2fc_percpu, cpu);
+		flush_work(&p->work);
 	}
=20
-	__unregister_hotcpu_notifier(&bnx2fc_cpu_notifier);
-
-	cpu_notifier_register_done();
-
 	destroy_workqueue(bnx2fc_wq);
 	/*
 	 * detach from scsi transport
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_=
hwi.c
index 5ff9f89c17c7..1ed7a1784e15 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1046,23 +1046,19 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tg=
t)
 			struct bnx2fc_percpu_s *fps =3D NULL;
 			unsigned int cpu =3D wqe % num_possible_cpus();
=20
-			fps =3D &per_cpu(bnx2fc_percpu, cpu);
-			spin_lock_bh(&fps->fp_work_lock);
-			if (unlikely(!fps->iothread))
-				goto unlock;
-
 			work =3D bnx2fc_alloc_work(tgt, wqe);
-			if (work)
+			if (work) {
+				fps =3D &per_cpu(bnx2fc_percpu, cpu);
+
+				spin_lock_bh(&fps->fp_work_lock);
 				list_add_tail(&work->list,
 					      &fps->work_list);
-unlock:
-			spin_unlock_bh(&fps->fp_work_lock);
-
-			/* Pending work request completion */
-			if (fps->iothread && work)
-				wake_up_process(fps->iothread);
-			else
+				spin_unlock_bh(&fps->fp_work_lock);
+				schedule_work_on(cpu, &fps->work);
+			} else {
 				bnx2fc_process_cq_compl(tgt, wqe);
+			}
+
 			num_free_sqes++;
 		}
 		cqe++;
--=20
2.10.2

