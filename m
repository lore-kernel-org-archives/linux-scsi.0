From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/5] scsi: bnx2i: convert to workqueue
Date: Mon, 10 Apr 2017 19:12:50 +0200
Message-ID: <20170410171254.30367-2-bigeasy@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52145 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754796AbdDJRNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 13:13:16 -0400
In-Reply-To: <20170410171254.30367-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The driver creates its own per-CPU threads which are updated based on CPU
hotplug events. It is also possible to use kworkers and remove some of the
infrastructure get the same job done while saving a few lines of code.

The DECLARE_PER_CPU() definition is moved into the header file where it
belongs. bnx2i_percpu_io_thread() becomes bnx2i_percpu_io_work() which is
mostly the same code. The outer loop (kthread_should_stop()) gets removed a=
nd
the remaining code is shifted to the left.
bnx2i_queue_scsi_cmd_resp() is mostly the same. The code checked ->iothread=
 to
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
care by the workqueue code.

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2i/bnx2i.h      |  11 ++---
 drivers/scsi/bnx2i/bnx2i_hwi.c  | 101 +++++++++++++++++-------------------=
--
 drivers/scsi/bnx2i/bnx2i_init.c | 104 +++---------------------------------=
----
 3 files changed, 53 insertions(+), 163 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 89ef1a1678d1..78f67542cbd3 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -31,7 +31,6 @@
 #include <linux/netdevice.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
-#include <linux/cpu.h>
=20
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -775,12 +774,11 @@ struct bnx2i_work {
 };
=20
 struct bnx2i_percpu_s {
-	struct task_struct *iothread;
+	struct work_struct work;
 	struct list_head work_list;
 	spinlock_t p_work_lock;
 };
=20
-
 /* Global variables */
 extern unsigned int error_mask1, error_mask2;
 extern u64 iscsi_error_mask;
@@ -797,7 +795,7 @@ extern unsigned int rq_size;
=20
 extern struct device_attribute *bnx2i_dev_attributes[];
=20
-
+DECLARE_PER_CPU(struct bnx2i_percpu_s, bnx2i_percpu);
=20
 /*
  * Function Prototypes
@@ -875,8 +873,5 @@ extern void bnx2i_print_active_cmd_queue(struct bnx2i_c=
onn *conn);
 extern void bnx2i_print_xmit_pdu_queue(struct bnx2i_conn *conn);
 extern void bnx2i_print_recv_state(struct bnx2i_conn *conn);
=20
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
=20
-DECLARE_PER_CPU(struct bnx2i_percpu_s, bnx2i_percpu);
-
 /**
  * bnx2i_get_cid_num - get cid from ep
  * @ep: 	endpoint pointer
@@ -1350,9 +1348,9 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hb=
a)
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
 	struct iscsi_conn *conn =3D bnx2i_conn->cls_conn->dd_data;
 	struct bnx2i_hba *hba =3D bnx2i_conn->hba;
@@ -1862,45 +1860,37 @@ static void bnx2i_process_cmd_cleanup_resp(struct i=
scsi_session *session,
=20
=20
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
-	struct bnx2i_percpu_s *p =3D arg;
+	struct bnx2i_percpu_s *p;
 	struct bnx2i_work *work, *tmp;
 	LIST_HEAD(work_list);
=20
-	set_user_nice(current, MIN_NICE);
+	p =3D container_of(work_s, struct bnx2i_percpu_s, work);
=20
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
=20
-
 /**
  * bnx2i_queue_scsi_cmd_resp - queue cmd completion to the percpu thread
  * @bnx2i_conn:		bnx2i connection
@@ -1920,7 +1910,6 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_ses=
sion *session,
 	struct bnx2i_percpu_s *p =3D NULL;
 	struct iscsi_task *task;
 	struct scsi_cmnd *sc;
-	int rc =3D 0;
 	int cpu;
=20
 	spin_lock(&session->back_lock);
@@ -1939,33 +1928,29 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_s=
ession *session,
=20
 	spin_unlock(&session->back_lock);
=20
-	p =3D &per_cpu(bnx2i_percpu, cpu);
-	spin_lock(&p->p_work_lock);
-	if (unlikely(!p->iothread)) {
-		rc =3D -EINVAL;
-		goto err;
-	}
 	/* Alloc and copy to the cqe */
 	bnx2i_work =3D kzalloc(sizeof(struct bnx2i_work), GFP_ATOMIC);
-	if (bnx2i_work) {
-		INIT_LIST_HEAD(&bnx2i_work->list);
-		bnx2i_work->session =3D session;
-		bnx2i_work->bnx2i_conn =3D bnx2i_conn;
-		memcpy(&bnx2i_work->cqe, cqe, sizeof(struct cqe));
-		list_add_tail(&bnx2i_work->list, &p->work_list);
-		atomic_inc(&bnx2i_conn->work_cnt);
-		wake_up_process(p->iothread);
-		spin_unlock(&p->p_work_lock);
-		goto done;
-	} else
-		rc =3D -ENOMEM;
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
=20
+	p =3D per_cpu_ptr(&bnx2i_percpu, cpu);
+
+	INIT_LIST_HEAD(&bnx2i_work->list);
+	bnx2i_work->session =3D session;
+	bnx2i_work->bnx2i_conn =3D bnx2i_conn;
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
=20
 /**
  * bnx2i_process_new_cqes - process newly DMA'ed CQE's
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_ini=
t.c
index 86afc002814c..551a17f9c841 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -402,73 +402,6 @@ int bnx2i_get_stats(void *handle)
 	return 0;
 }
=20
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
-	p =3D &per_cpu(bnx2i_percpu, cpu);
-
-	thread =3D kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
-					cpu_to_node(cpu),
-					"bnx2i_thread/%d", cpu);
-	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread =3D thread;
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
-	p =3D &per_cpu(bnx2i_percpu, cpu);
-	spin_lock_bh(&p->p_work_lock);
-	thread =3D p->iothread;
-	p->iothread =3D NULL;
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
-static int bnx2i_cpu_online(unsigned int cpu)
-{
-	pr_info("bnx2i: CPU %x online: Create Rx thread\n", cpu);
-	bnx2i_percpu_thread_create(cpu);
-	return 0;
-}
-
-static int bnx2i_cpu_dead(unsigned int cpu)
-{
-	pr_info("CPU %x offline: Remove Rx thread\n", cpu);
-	bnx2i_percpu_thread_destroy(cpu);
-	return 0;
-}
-
-static enum cpuhp_state bnx2i_online_state;
-
 /**
  * bnx2i_mod_init - module init entry point
  *
@@ -505,41 +438,20 @@ static int __init bnx2i_mod_init(void)
=20
 	/* Create percpu kernel threads to handle iSCSI I/O completions */
 	for_each_possible_cpu(cpu) {
-		p =3D &per_cpu(bnx2i_percpu, cpu);
+		p =3D per_cpu_ptr(&bnx2i_percpu, cpu);
 		INIT_LIST_HEAD(&p->work_list);
 		spin_lock_init(&p->p_work_lock);
-		p->iothread =3D NULL;
+		INIT_WORK(&p->work, bnx2i_percpu_io_work);
 	}
=20
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_create(cpu);
-
-	err =3D cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-				       "scsi/bnx2i:online",
-				       bnx2i_cpu_online, NULL);
-	if (err < 0)
-		goto remove_threads;
-	bnx2i_online_state =3D err;
-
-	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2I_DEAD, "scsi/bnx2i:dead",
-				  NULL, bnx2i_cpu_dead);
-	put_online_cpus();
 	return 0;
=20
-remove_threads:
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-	put_online_cpus();
-	cnic_unregister_driver(CNIC_ULP_ISCSI);
 unreg_xport:
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 out:
 	return err;
 }
=20
-
 /**
  * bnx2i_mod_exit - module cleanup/exit entry point
  *
@@ -569,14 +481,12 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
=20
-	get_online_cpus();
+	for_each_possible_cpu(cpu) {
+		struct bnx2i_percpu_s *p;
=20
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-
-	cpuhp_remove_state_nocalls(bnx2i_online_state);
-	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2I_DEAD);
-	put_online_cpus();
+		p =3D per_cpu_ptr(&bnx2i_percpu, cpu);
+		flush_work(&p->work);
+	}
=20
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
--=20
2.11.0
