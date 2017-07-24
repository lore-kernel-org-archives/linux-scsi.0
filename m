From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 5/5] scsi/bnx2i: Simplify cpu hotplug code
Date: Mon, 24 Jul 2017 12:53:00 +0200
Message-ID: <20170724105341.629655637@linutronix.de>
References: <20170724105255.715647116@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=scsci-bxn2i--Simplify-cpu-hotplug-code.patch
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

The CPU hotplug related code of this driver can be simplified by:

1) Consolidating the callbacks into a single state. The CPU thread can be
   torn down on the CPU which goes offline. There is no point in delaying
   that to the CPU dead state

2) Let the core code invoke the online/offline callbacks and remove the
   extra for_each_online_cpu() loops.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   65 +++++++++-------------------------------
 include/linux/cpuhotplug.h      |    1 
 2 files changed, 15 insertions(+), 51 deletions(-)

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
@@ -419,16 +418,17 @@ static void bnx2i_percpu_thread_create(u
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
@@ -451,19 +451,6 @@ static void bnx2i_percpu_thread_destroy(
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
 
@@ -511,28 +498,14 @@ static int __init bnx2i_mod_init(void)
 		p->iothread = NULL;
 	}
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_create(cpu);
-
-	err = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
-						   "scsi/bnx2i:online",
-						   bnx2i_cpu_online, NULL);
+	err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "scsi/bnx2i:online",
+				bnx2i_cpu_online, bnx2i_cpu_offline);
 	if (err < 0)
-		goto remove_threads;
+		goto unreg_driver;
 	bnx2i_online_state = err;
-
-	cpuhp_setup_state_nocalls_cpuslocked(CPUHP_SCSI_BNX2I_DEAD,
-					     "scsi/bnx2i:dead",
-					     NULL, bnx2i_cpu_dead);
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
@@ -552,7 +525,6 @@ static int __init bnx2i_mod_init(void)
 static void __exit bnx2i_mod_exit(void)
 {
 	struct bnx2i_hba *hba;
-	unsigned cpu = 0;
 
 	mutex_lock(&bnx2i_dev_lock);
 	while (!list_empty(&adapter_list)) {
@@ -570,14 +542,7 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		bnx2i_percpu_thread_destroy(cpu);
-
-	cpuhp_remove_state_nocalls_cpuslocked(bnx2i_online_state);
-	cpuhp_remove_state_nocalls_cpuslocked(CPUHP_SCSI_BNX2I_DEAD);
-	put_online_cpus();
+	cpuhp_remove_state(bnx2i_online_state);
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -39,7 +39,6 @@ enum cpuhp_state {
 	CPUHP_PCI_XGENE_DEAD,
 	CPUHP_IOMMU_INTEL_DEAD,
 	CPUHP_LUSTRE_CFS_DEAD,
-	CPUHP_SCSI_BNX2I_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
