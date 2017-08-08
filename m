From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.13-rc4
Date: Tue, 08 Aug 2017 08:34:45 -0700
Message-ID: <1502206485.2736.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two small fixes, one re-fix of a previous fix and five patches sorting
out hotplug in the bnx2X class of drivers.  The latter is rather
involved, but necessary because these drivers have started dropping
lockdep recursion warnings on the hotplug lock because of its
conversion to a percpu rwsem.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi: aacraid: reading out of bounds

Johannes Thumshirn (1):
      scsi: sg: only check for dxfer_len greater than 256M

Thomas Bogendoerfer (1):
      scsi: qedf: Limit number of CQs

Thomas Gleixner (5):
      scsi: bnx2i: Simplify cpu hotplug code
      scsi: bnx2fc: Simplify CPU hotplug code
      scsi: bnx2i: Prevent recursive cpuhotplug locking
      scsi: bnx2fc: Prevent recursive cpuhotplug locking
      scsi: bnx2fc: Plug CPU hotplug race

And the diffstat:

 drivers/scsi/aacraid/aachba.c     |  7 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 68 +++++++++------------------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  | 45 +++++++++++++-------------
 drivers/scsi/bnx2i/bnx2i_init.c   | 64 +++++++++---------------------------
 drivers/scsi/qedf/qedf.h          |  3 +-
 drivers/scsi/qedf/qedf_main.c     | 20 ++++++------
 drivers/scsi/sg.c                 | 31 +-----------------
 include/linux/cpuhotplug.h        |  2 --
 8 files changed, 69 insertions(+), 171 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 707ee2f5954d..4591113c49de 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3198,10 +3198,11 @@ static int query_disk(struct aac_dev *dev, void __user *arg)
 		return -EBUSY;
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
-	if (qd.cnum == -1)
+	if (qd.cnum == -1) {
+		if (qd.id < 0 || qd.id >= dev->maximum_num_containers)
+			return -EINVAL;
 		qd.cnum = qd.id;
-	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1))
-	{
+	} else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) {
 		if (qd.cnum < 0 || qd.cnum >= dev->maximum_num_containers)
 			return -EINVAL;
 		qd.instance = dev->scsi_host_ptr->host_no;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 7dfe709a7138..6844ba361616 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2624,12 +2624,11 @@ static struct fcoe_transport bnx2fc_transport = {
 };
 
 /**
- * bnx2fc_percpu_thread_create - Create a receive thread for an
- *				 online CPU
+ * bnx2fc_cpu_online - Create a receive thread for an  online CPU
  *
  * @cpu: cpu index for the online cpu
  */
-static void bnx2fc_percpu_thread_create(unsigned int cpu)
+static int bnx2fc_cpu_online(unsigned int cpu)
 {
 	struct bnx2fc_percpu_s *p;
 	struct task_struct *thread;
@@ -2639,15 +2638,17 @@ static void bnx2fc_percpu_thread_create(unsigned int cpu)
 	thread = kthread_create_on_node(bnx2fc_percpu_io_thread,
 					(void *)p, cpu_to_node(cpu),
 					"bnx2fc_thread/%d", cpu);
+	if (IS_ERR(thread))
+		return PTR_ERR(thread);
+
 	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread = thread;
-		wake_up_process(thread);
-	}
+	kthread_bind(thread, cpu);
+	p->iothread = thread;
+	wake_up_process(thread);
+	return 0;
 }
 
-static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
+static int bnx2fc_cpu_offline(unsigned int cpu)
 {
 	struct bnx2fc_percpu_s *p;
 	struct task_struct *thread;
@@ -2661,7 +2662,6 @@ static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
 	thread = p->iothread;
 	p->iothread = NULL;
 
-
 	/* Free all work in the list */
 	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
 		list_del_init(&work->list);
@@ -2673,20 +2673,6 @@ static void bnx2fc_percpu_thread_destroy(unsigned int cpu)
 
 	if (thread)
 		kthread_stop(thread);
-}
-
-
-static int bnx2fc_cpu_online(unsigned int cpu)
-{
-	printk(PFX "CPU %x online: Create Rx thread\n", cpu);
-	bnx2fc_percpu_thread_create(cpu);
-	return 0;
-}
-
-static int bnx2fc_cpu_dead(unsigned int cpu)
-{
-	printk(PFX "CPU %x offline: Remove Rx thread\n", cpu);
-	bnx2fc_percpu_thread_destroy(cpu);
 	return 0;
 }
 
@@ -2761,30 +2747,16 @@ static int __init bnx2fc_mod_init(void)
 		spin_lock_init(&p->fp_work_lock);
 	}
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		bnx2fc_percpu_thread_create(cpu);
-
-	rc = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-				       "scsi/bnx2fc:online",
-				       bnx2fc_cpu_online, NULL);
+	rc = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "scsi/bnx2fc:online",
+			       bnx2fc_cpu_online, bnx2fc_cpu_offline);
 	if (rc < 0)
-		goto stop_threads;
+		goto stop_thread;
 	bnx2fc_online_state = rc;
 
-	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2FC_DEAD, "scsi/bnx2fc:dead",
-				  NULL, bnx2fc_cpu_dead);
-	put_online_cpus();
-
 	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
-
 	return 0;
 
-stop_threads:
-	for_each_online_cpu(cpu)
-		bnx2fc_percpu_thread_destroy(cpu);
-	put_online_cpus();
+stop_thread:
 	kthread_stop(l2_thread);
 free_wq:
 	destroy_workqueue(bnx2fc_wq);
@@ -2803,7 +2775,6 @@ static void __exit bnx2fc_mod_exit(void)
 	struct fcoe_percpu_s *bg;
 	struct task_struct *l2_thread;
 	struct sk_buff *skb;
-	unsigned int cpu = 0;
 
 	/*
 	 * NOTE: Since cnic calls register_driver routine rtnl_lock,
@@ -2844,16 +2815,7 @@ static void __exit bnx2fc_mod_exit(void)
 	if (l2_thread)
 		kthread_stop(l2_thread);
 
-	get_online_cpus();
-	/* Destroy per cpu threads */
-	for_each_online_cpu(cpu) {
-		bnx2fc_percpu_thread_destroy(cpu);
-	}
-
-	cpuhp_remove_state_nocalls(bnx2fc_online_state);
-	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2FC_DEAD);
-
-	put_online_cpus();
+	cpuhp_remove_state(bnx2fc_online_state);
 
 	destroy_workqueue(bnx2fc_wq);
 	/*
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 913c750205ce..26de61d65a4d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1008,6 +1008,28 @@ static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
 	return work;
 }
 
+/* Pending work request completion */
+static void bnx2fc_pending_work(struct bnx2fc_rport *tgt, unsigned int wqe)
+{
+	unsigned int cpu = wqe % num_possible_cpus();
+	struct bnx2fc_percpu_s *fps;
+	struct bnx2fc_work *work;
+
+	fps = &per_cpu(bnx2fc_percpu, cpu);
+	spin_lock_bh(&fps->fp_work_lock);
+	if (fps->iothread) {
+		work = bnx2fc_alloc_work(tgt, wqe);
+		if (work) {
+			list_add_tail(&work->list, &fps->work_list);
+			wake_up_process(fps->iothread);
+			spin_unlock_bh(&fps->fp_work_lock);
+			return;
+		}
+	}
+	spin_unlock_bh(&fps->fp_work_lock);
+	bnx2fc_process_cq_compl(tgt, wqe);
+}
+
 int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 {
 	struct fcoe_cqe *cq;
@@ -1042,28 +1064,7 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 			/* Unsolicited event notification */
 			bnx2fc_process_unsol_compl(tgt, wqe);
 		} else {
-			/* Pending work request completion */
-			struct bnx2fc_work *work = NULL;
-			struct bnx2fc_percpu_s *fps = NULL;
-			unsigned int cpu = wqe % num_possible_cpus();
-
-			fps = &per_cpu(bnx2fc_percpu, cpu);
-			spin_lock_bh(&fps->fp_work_lock);
-			if (unlikely(!fps->iothread))
-				goto unlock;
-
-			work = bnx2fc_alloc_work(tgt, wqe);
-			if (work)
-				list_add_tail(&work->list,
-					      &fps->work_list);
-unlock:
-			spin_unlock_bh(&fps->fp_work_lock);
-
-			/* Pending work request completion */
-			if (fps->iothread && work)
-				wake_up_process(fps->iothread);
-			else
-				bnx2fc_process_cq_compl(tgt, wqe);
+			bnx2fc_pending_work(tgt, wqe);
 			num_free_sqes++;
 		}
 		cqe++;
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 86afc002814c..4ebcda8d9500 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -404,12 +404,11 @@ int bnx2i_get_stats(void *handle)
 
 
 /**
- * bnx2i_percpu_thread_create - Create a receive thread for an
- *				online CPU
+ * bnx2i_cpu_online - Create a receive thread for an online CPU
  *
  * @cpu:	cpu index for the online cpu
  */
-static void bnx2i_percpu_thread_create(unsigned int cpu)
+static int bnx2i_cpu_online(unsigned int cpu)
 {
 	struct bnx2i_percpu_s *p;
 	struct task_struct *thread;
@@ -419,16 +418,17 @@ static void bnx2i_percpu_thread_create(unsigned int cpu)
 	thread = kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
 					cpu_to_node(cpu),
 					"bnx2i_thread/%d", cpu);
+	if (IS_ERR(thread))
+		return PTR_ERR(thread);
+
 	/* bind thread to the cpu */
-	if (likely(!IS_ERR(thread))) {
-		kthread_bind(thread, cpu);
-		p->iothread = thread;
-		wake_up_process(thread);
-	}
+	kthread_bind(thread, cpu);
+	p->iothread = thread;
+	wake_up_process(thread);
+	return 0;
 }
 
-
-static void bnx2i_percpu_thread_destroy(unsigned int cpu)
+static int bnx2i_cpu_offline(unsigned int cpu)
 {
 	struct bnx2i_percpu_s *p;
 	struct task_struct *thread;
@@ -451,19 +451,6 @@ static void bnx2i_percpu_thread_destroy(unsigned int cpu)
 	spin_unlock_bh(&p->p_work_lock);
 	if (thread)
 		kthread_stop(thread);
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
 	return 0;
 }
 
@@ -511,27 +498,14 @@ static int __init bnx2i_mod_init(void)
 		p->iothread = NULL;
 	}
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_create(cpu);
-
-	err = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-				       "scsi/bnx2i:online",
-				       bnx2i_cpu_online, NULL);
+	err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "scsi/bnx2i:online",
+				bnx2i_cpu_online, bnx2i_cpu_offline);
 	if (err < 0)
-		goto remove_threads;
+		goto unreg_driver;
 	bnx2i_online_state = err;
-
-	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2I_DEAD, "scsi/bnx2i:dead",
-				  NULL, bnx2i_cpu_dead);
-	put_online_cpus();
 	return 0;
 
-remove_threads:
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-	put_online_cpus();
+unreg_driver:
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
 unreg_xport:
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
@@ -551,7 +525,6 @@ static int __init bnx2i_mod_init(void)
 static void __exit bnx2i_mod_exit(void)
 {
 	struct bnx2i_hba *hba;
-	unsigned cpu = 0;
 
 	mutex_lock(&bnx2i_dev_lock);
 	while (!list_empty(&adapter_list)) {
@@ -569,14 +542,7 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-
-	cpuhp_remove_state_nocalls(bnx2i_online_state);
-	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2I_DEAD);
-	put_online_cpus();
+	cpuhp_remove_state(bnx2i_online_state);
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 4d038926a455..351f06dfc5a0 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -528,7 +528,8 @@ struct fip_vlan {
 #define QEDF_WRITE                    (1 << 0)
 #define MAX_FIBRE_LUNS			0xffffffff
 
-#define QEDF_MAX_NUM_CQS		8
+#define MIN_NUM_CPUS_MSIX(x)	min_t(u32, x->dev_info.num_cqs, \
+					num_online_cpus())
 
 /*
  * PCI function probe defines
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7786c97e033f..1d13c9ca517d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2760,11 +2760,9 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx *qedf)
 	 * we allocation is the minimum off:
 	 *
 	 * Number of CPUs
-	 * Number of MSI-X vectors
-	 * Max number allocated in hardware (QEDF_MAX_NUM_CQS)
+	 * Number allocated by qed for our PCI function
 	 */
-	qedf->num_queues = min((unsigned int)QEDF_MAX_NUM_CQS,
-	    num_online_cpus());
+	qedf->num_queues = MIN_NUM_CPUS_MSIX(qedf);
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "Number of CQs is %d.\n",
 		   qedf->num_queues);
@@ -2962,6 +2960,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		goto err1;
 	}
 
+	/* Learn information crucial for qedf to progress */
+	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
+	if (rc) {
+		QEDF_ERR(&(qedf->dbg_ctx), "Failed to dev info.\n");
+		goto err1;
+	}
+
 	/* queue allocation code should come here
 	 * order should be
 	 * 	slowpath_start
@@ -2977,13 +2982,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 	qed_ops->common->update_pf_params(qedf->cdev, &qedf->pf_params);
 
-	/* Learn information crucial for qedf to progress */
-	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
-	if (rc) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Failed to dev info.\n");
-		goto err1;
-	}
-
 	/* Record BDQ producer doorbell addresses */
 	qedf->bdq_primary_prod = qedf->dev_info.primary_dbq_rq_addr;
 	qedf->bdq_secondary_prod = qedf->dev_info.secondary_bdq_rq_addr;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4fe606b000b4..d7ff71e0c85c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -751,35 +751,6 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	return count;
 }
 
-static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
-{
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_NONE:
-		if (hp->dxferp || hp->dxfer_len > 0)
-			return false;
-		return true;
-	case SG_DXFER_FROM_DEV:
-		/*
-		 * for SG_DXFER_FROM_DEV we always set dxfer_len to > 0. dxferp
-		 * can either be NULL or != NULL so there's no point in checking
-		 * it either. So just return true.
-		 */
-		return true;
-	case SG_DXFER_TO_DEV:
-	case SG_DXFER_TO_FROM_DEV:
-		if (!hp->dxferp || hp->dxfer_len == 0)
-			return false;
-		return true;
-	case SG_DXFER_UNKNOWN:
-		if ((!hp->dxferp && hp->dxfer_len) ||
-		    (hp->dxferp && hp->dxfer_len == 0))
-			return false;
-		return true;
-	default:
-		return false;
-	}
-}
-
 static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
@@ -800,7 +771,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (!sg_is_valid_dxfer(hp))
+	if (hp->dxfer_len >= SZ_256M)
 		return -EINVAL;
 
 	k = sg_start_req(srp, cmnd);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index b56573bf440d..82b30e638430 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -39,8 +39,6 @@ enum cpuhp_state {
 	CPUHP_PCI_XGENE_DEAD,
 	CPUHP_IOMMU_INTEL_DEAD,
 	CPUHP_LUSTRE_CFS_DEAD,
-	CPUHP_SCSI_BNX2FC_DEAD,
-	CPUHP_SCSI_BNX2I_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
