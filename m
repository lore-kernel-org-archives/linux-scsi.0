From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 03/10] scsi/bnx2fc: Convert to hotplug state machine
Date: Wed, 21 Dec 2016 20:19:50 +0100
Message-ID: <20161221192111.757309869@linutronix.de>
References: <20161221191947.089046759@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=scsibnx2fc_Convert_to_hotplug_state_machine.patch
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Siewior <bigeasy@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Install the callbacks via the state machine. No functional change.

This is the minimal fixup so we can remove the hotplug notifier mess
completely.

The real rework of this driver to use work queues is still stuck in
review/testing on the SCSI mailing list.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   81 +++++++++++++++-----------------------
 include/linux/cpuhotplug.h        |    1 
 2 files changed, 35 insertions(+), 47 deletions(-)

--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -127,13 +127,6 @@ module_param_named(log_fka, bnx2fc_log_f
 MODULE_PARM_DESC(log_fka, " Print message to kernel log when fcoe is "
 	"initiating a FIP keep alive when debug logging is enabled.");
 
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
@@ -2622,37 +2615,19 @@ static void bnx2fc_percpu_thread_destroy
 		kthread_stop(thread);
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
+
+static int bnx2fc_cpu_online(unsigned int cpu)
 {
-	unsigned cpu = (unsigned long)hcpu;
+	printk(PFX "CPU %x online: Create Rx thread\n", cpu);
+	bnx2fc_percpu_thread_create(cpu);
+	return 0;
+}
 
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
+static int bnx2fc_cpu_dead(unsigned int cpu)
+{
+	printk(PFX "CPU %x offline: Remove Rx thread\n", cpu);
+	bnx2fc_percpu_thread_destroy(cpu);
+	return 0;
 }
 
 static int bnx2fc_slave_configure(struct scsi_device *sdev)
@@ -2664,6 +2639,8 @@ static int bnx2fc_slave_configure(struct
 	return 0;
 }
 
+static enum cpuhp_state bnx2fc_online_state;
+
 /**
  * bnx2fc_mod_init - module init entry point
  *
@@ -2724,21 +2701,31 @@ static int __init bnx2fc_mod_init(void)
 		spin_lock_init(&p->fp_work_lock);
 	}
 
-	cpu_notifier_register_begin();
+	get_online_cpus();
 
-	for_each_online_cpu(cpu) {
+	for_each_online_cpu(cpu)
 		bnx2fc_percpu_thread_create(cpu);
-	}
 
-	/* Initialize per CPU interrupt thread */
-	__register_hotcpu_notifier(&bnx2fc_cpu_notifier);
-
-	cpu_notifier_register_done();
+	rc = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+				       "scsi/bnx2fc:online",
+				       bnx2fc_cpu_online, NULL);
+	if (rc < 0)
+		goto stop_threads;
+	bnx2fc_online_state = rc;
+
+	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2FC_DEAD, "scsi/bnx2fc:dead",
+				  NULL, bnx2fc_cpu_dead);
+	put_online_cpus();
 
 	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
 
 	return 0;
 
+stop_threads:
+	for_each_online_cpu(cpu)
+		bnx2fc_percpu_thread_destroy(cpu);
+	put_online_cpus();
+	kthread_stop(l2_thread);
 free_wq:
 	destroy_workqueue(bnx2fc_wq);
 release_bt:
@@ -2797,16 +2784,16 @@ static void __exit bnx2fc_mod_exit(void)
 	if (l2_thread)
 		kthread_stop(l2_thread);
 
-	cpu_notifier_register_begin();
-
+	get_online_cpus();
 	/* Destroy per cpu threads */
 	for_each_online_cpu(cpu) {
 		bnx2fc_percpu_thread_destroy(cpu);
 	}
 
-	__unregister_hotcpu_notifier(&bnx2fc_cpu_notifier);
+	cpuhp_remove_state_nocalls(bnx2fc_online_state);
+	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2FC_DEAD);
 
-	cpu_notifier_register_done();
+	put_online_cpus();
 
 	destroy_workqueue(bnx2fc_wq);
 	/*
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -41,6 +41,7 @@ enum cpuhp_state {
 	CPUHP_NET_DEV_DEAD,
 	CPUHP_PCI_XGENE_DEAD,
 	CPUHP_IOMMU_INTEL_DEAD,
+	CPUHP_SCSI_BNX2FC_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
