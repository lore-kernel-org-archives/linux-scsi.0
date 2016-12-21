From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 04/10] scsi/bnx2i: Convert to hotplug state machine
Date: Wed, 21 Dec 2016 20:19:51 +0100
Message-ID: <20161221192111.836895753@linutronix.de>
References: <20161221191947.089046759@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=scsibnx2i_Convert_to_hotplug_state_machine.patch
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
 drivers/scsi/bnx2i/bnx2i_init.c |   80 +++++++++++++++-------------------------
 include/linux/cpuhotplug.h      |    1 
 2 files changed, 32 insertions(+), 49 deletions(-)

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
@@ -461,41 +453,21 @@ static void bnx2i_percpu_thread_destroy(
 		kthread_stop(thread);
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
+static int bnx2i_cpu_online(unsigned int cpu)
 {
-	unsigned cpu = (unsigned long)hcpu;
+	pr_info("bnx2i: CPU %x online: Create Rx thread\n", cpu);
+	bnx2i_percpu_thread_create(cpu);
+	return 0;
+}
 
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
+static int bnx2i_cpu_dead(unsigned int cpu)
+{
+	pr_info("CPU %x offline: Remove Rx thread\n", cpu);
+	bnx2i_percpu_thread_destroy(cpu);
+	return 0;
 }
 
+static enum cpuhp_state bnx2i_online_state;
 
 /**
  * bnx2i_mod_init - module init entry point
@@ -539,18 +511,28 @@ static int __init bnx2i_mod_init(void)
 		p->iothread = NULL;
 	}
 
-	cpu_notifier_register_begin();
+	get_online_cpus();
 
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_create(cpu);
 
-	/* Initialize per CPU interrupt thread */
-	__register_hotcpu_notifier(&bnx2i_cpu_notifier);
-
-	cpu_notifier_register_done();
-
+	err = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+				       "scsi/bnx2i:online",
+				       bnx2i_cpu_online, NULL);
+	if (err < 0)
+		goto remove_threads;
+	bnx2i_online_state = err;
+
+	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2I_DEAD, "scsi/bnx2i:dead",
+				  NULL, bnx2i_cpu_dead);
+	put_online_cpus();
 	return 0;
 
+remove_threads:
+	for_each_online_cpu(cpu)
+		bnx2i_percpu_thread_destroy(cpu);
+	put_online_cpus();
+	cnic_unregister_driver(CNIC_ULP_ISCSI);
 unreg_xport:
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 out:
@@ -587,14 +569,14 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	cpu_notifier_register_begin();
+	get_online_cpus();
 
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_destroy(cpu);
 
-	__unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
-
-	cpu_notifier_register_done();
+	cpuhp_remove_state_nocalls(bnx2i_online_state);
+	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2I_DEAD);
+	put_online_cpus();
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -42,6 +42,7 @@ enum cpuhp_state {
 	CPUHP_PCI_XGENE_DEAD,
 	CPUHP_IOMMU_INTEL_DEAD,
 	CPUHP_SCSI_BNX2FC_DEAD,
+	CPUHP_SCSI_BNX2I_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
