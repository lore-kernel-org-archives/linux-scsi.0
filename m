From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 1/18] megaraid_sas : Add separate function for setting
 up IRQs
Date: Thu, 23 Apr 2015 16:30:09 +0530
Message-ID: <201504231102.t3NB2PGl029163@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:1632
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932980AbbDWLAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:00:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will create separate functions for- 1) setting up IRQs for MSI-x interrupts 2) setting up IRQs for legacy interrupts 3) freeing up IRQs.
and enable interrupts after adapter's initialization. The reason behind initialising adapter earlier is: by that time firmware is operational
and can send interrupts, so better to use interrupt based interface to send internal DCMD to firmware instead of using polling method, since MFI frames'
pool size is reduced and polling method does not free up MFI frame for fusion adapters, so sending more DCMDs with polled method may cause MFI frames's pool go out of frames and end up failing DCMD.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |  281 ++++++++++++++---------------
 1 files changed, 135 insertions(+), 146 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..5be9ce4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4414,6 +4414,107 @@ fail_alloc_cmds:
 	return 1;
 }
 
+/*
+ * megasas_setup_irqs_msix -		register legacy interrupts.
+ * @instance:				Adapter soft state
+ *
+ * Do not enable interrupt, only setup ISRs.
+ *
+ * Return 0 on success.
+ */
+static int
+megasas_setup_irqs_ioapic(struct megasas_instance *instance)
+{
+	struct pci_dev *pdev;
+
+	pdev = instance->pdev;
+	instance->irq_context[0].instance = instance;
+	instance->irq_context[0].MSIxIndex = 0;
+	if (request_irq(pdev->irq, instance->instancet->service_isr,
+		IRQF_SHARED, "megasas", &instance->irq_context[0])) {
+		dev_err(&instance->pdev->dev,
+				"Failed to register IRQ from %s %d\n",
+				__func__, __LINE__);
+		return -1;
+	}
+	return 0;
+}
+
+/**
+ * megasas_setup_irqs_msix -		register MSI-x interrupts.
+ * @instance:				Adapter soft state
+ * @is_probe:				Driver probe check
+ *
+ * Do not enable interrupt, only setup ISRs.
+ *
+ * Return 0 on success.
+ */
+static int
+megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
+{
+	int i, j, cpu;
+	struct pci_dev *pdev;
+
+	pdev = instance->pdev;
+
+	/* Try MSI-x */
+	cpu = cpumask_first(cpu_online_mask);
+	for (i = 0; i < instance->msix_vectors; i++) {
+		instance->irq_context[i].instance = instance;
+		instance->irq_context[i].MSIxIndex = i;
+		if (request_irq(instance->msixentry[i].vector,
+			instance->instancet->service_isr, 0, "megasas",
+			&instance->irq_context[i])) {
+			dev_err(&instance->pdev->dev,
+				"Failed to register IRQ for vector %d.\n", i);
+			for (j = 0; j < i; j++) {
+				if (smp_affinity_enable)
+					irq_set_affinity_hint(
+						instance->msixentry[j].vector, NULL);
+				free_irq(instance->msixentry[j].vector,
+					&instance->irq_context[j]);
+			}
+			/* Retry irq register for IO_APIC*/
+			instance->msix_vectors = 0;
+			if (is_probe)
+				return megasas_setup_irqs_ioapic(instance);
+			else
+				return -1;
+		}
+		if (smp_affinity_enable) {
+			if (irq_set_affinity_hint(instance->msixentry[i].vector,
+				get_cpu_mask(cpu)))
+				dev_err(&instance->pdev->dev,
+					"Failed to set affinity hint"
+					" for cpu %d\n", cpu);
+			cpu = cpumask_next(cpu, cpu_online_mask);
+		}
+	}
+	return 0;
+}
+
+/*
+ * megasas_destroy_irqs-		unregister interrupts.
+ * @instance:				Adapter soft state
+ * return:				void
+ */
+static void
+megasas_destroy_irqs(struct megasas_instance *instance) {
+
+	int i;
+
+	if (instance->msix_vectors)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
+			free_irq(instance->msixentry[i].vector,
+				 &instance->irq_context[i]);
+		}
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+}
+
 /**
  * megasas_init_fw -	Initializes the FW
  * @instance:		Adapter soft state
@@ -4552,11 +4653,16 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		else
 			instance->msix_vectors = 0;
 
-		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
-			"<%d> MSIX vector,Online CPUs: <%d>,"
-			"Current MSIX <%d>\n", instance->host->host_no,
-			fw_msix_count, (unsigned int)num_online_cpus(),
-			instance->msix_vectors);
+		dev_info(&instance->pdev->dev,
+			"firmware supports msix\t: (%d)", fw_msix_count);
+		dev_info(&instance->pdev->dev,
+			"current msix/online cpus\t: (%d/%d)\n",
+			instance->msix_vectors, (unsigned int)num_online_cpus());
+
+		if (instance->msix_vectors ?
+				megasas_setup_irqs_msix(instance, 1) :
+				megasas_setup_irqs_ioapic(instance))
+			goto fail_setup_irqs;
 	}
 
 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
@@ -4573,6 +4679,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
+	instance->instancet->enable_intr(instance);
 
 	printk(KERN_ERR "megasas: INIT adapter done\n");
 
@@ -4584,7 +4691,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
 		printk(KERN_ERR "megasas: failed to get PD list\n");
-		goto fail_init_adapter;
+		goto fail_get_pd_list;
 	}
 
 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
@@ -4733,7 +4840,14 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	return 0;
 
+fail_get_pd_list:
+	instance->instancet->disable_intr(instance);
 fail_init_adapter:
+	megasas_destroy_irqs(instance);
+fail_setup_irqs:
+	if (instance->msix_vectors)
+		pci_disable_msix(instance->pdev);
+	instance->msix_vectors = 0;
 fail_ready_state:
 	kfree(instance->ctrl_info);
 	instance->ctrl_info = NULL;
@@ -5106,7 +5220,7 @@ fail_set_dma_mask:
 static int megasas_probe_one(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
-	int rval, pos, i, j, cpu;
+	int rval, pos;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
@@ -5315,55 +5429,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		}
 	}
 
-retry_irq_register:
-	/*
-	 * Register IRQ
-	 */
-	if (instance->msix_vectors) {
-		cpu = cpumask_first(cpu_online_mask);
-		for (i = 0; i < instance->msix_vectors; i++) {
-			instance->irq_context[i].instance = instance;
-			instance->irq_context[i].MSIxIndex = i;
-			if (request_irq(instance->msixentry[i].vector,
-					instance->instancet->service_isr, 0,
-					"megasas",
-					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
-				       "register IRQ for vector %d.\n", i);
-				for (j = 0; j < i; j++) {
-					if (smp_affinity_enable)
-						irq_set_affinity_hint(
-							instance->msixentry[j].vector, NULL);
-					free_irq(
-						instance->msixentry[j].vector,
-						&instance->irq_context[j]);
-				}
-				/* Retry irq register for IO_APIC */
-				instance->msix_vectors = 0;
-				goto retry_irq_register;
-			}
-			if (smp_affinity_enable) {
-				if (irq_set_affinity_hint(instance->msixentry[i].vector,
-					get_cpu_mask(cpu)))
-					dev_err(&instance->pdev->dev,
-						"Error setting affinity hint "
-						"for cpu %d\n", cpu);
-				cpu = cpumask_next(cpu, cpu_online_mask);
-			}
-		}
-	} else {
-		instance->irq_context[0].instance = instance;
-		instance->irq_context[0].MSIxIndex = 0;
-		if (request_irq(pdev->irq, instance->instancet->service_isr,
-				IRQF_SHARED, "megasas",
-				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
-			goto fail_irq;
-		}
-	}
-
-	instance->instancet->enable_intr(instance);
-
 	/*
 	 * Store instance in PCI softstate
 	 */
@@ -5410,17 +5475,8 @@ retry_irq_register:
 	megasas_mgmt_info.max_index--;
 
 	instance->instancet->disable_intr(instance);
-	if (instance->msix_vectors)
-		for (i = 0; i < instance->msix_vectors; i++) {
-			if (smp_affinity_enable)
-				irq_set_affinity_hint(
-					instance->msixentry[i].vector, NULL);
-			free_irq(instance->msixentry[i].vector,
-				 &instance->irq_context[i]);
-		}
-	else
-		free_irq(instance->pdev->irq, &instance->irq_context[0]);
-fail_irq:
+	megasas_destroy_irqs(instance);
+
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
@@ -5428,9 +5484,9 @@ fail_irq:
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
-      fail_init_mfi:
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
+fail_init_mfi:
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -5558,7 +5614,6 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
-	int i;
 
 	instance = pci_get_drvdata(pdev);
 	host = instance->host;
@@ -5583,16 +5638,8 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance);
 
-	if (instance->msix_vectors)
-		for (i = 0; i < instance->msix_vectors; i++) {
-			if (smp_affinity_enable)
-				irq_set_affinity_hint(
-					instance->msixentry[i].vector, NULL);
-			free_irq(instance->msixentry[i].vector,
-				 &instance->irq_context[i]);
-		}
-	else
-		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+	megasas_destroy_irqs(instance);
+
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 
@@ -5611,7 +5658,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 static int
 megasas_resume(struct pci_dev *pdev)
 {
-	int rval, i, j, cpu;
+	int rval;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -5681,50 +5728,10 @@ megasas_resume(struct pci_dev *pdev)
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		     (unsigned long)instance);
 
-	/*
-	 * Register IRQ
-	 */
-	if (instance->msix_vectors) {
-		cpu = cpumask_first(cpu_online_mask);
-		for (i = 0 ; i < instance->msix_vectors; i++) {
-			instance->irq_context[i].instance = instance;
-			instance->irq_context[i].MSIxIndex = i;
-			if (request_irq(instance->msixentry[i].vector,
-					instance->instancet->service_isr, 0,
-					"megasas",
-					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
-				       "register IRQ for vector %d.\n", i);
-				for (j = 0; j < i; j++) {
-					if (smp_affinity_enable)
-						irq_set_affinity_hint(
-							instance->msixentry[j].vector, NULL);
-					free_irq(
-						instance->msixentry[j].vector,
-						&instance->irq_context[j]);
-				}
-				goto fail_irq;
-			}
-
-			if (smp_affinity_enable) {
-				if (irq_set_affinity_hint(instance->msixentry[i].vector,
-					get_cpu_mask(cpu)))
-					dev_err(&instance->pdev->dev, "Error "
-						"setting affinity hint for cpu "
-						"%d\n", cpu);
-				cpu = cpumask_next(cpu, cpu_online_mask);
-			}
-		}
-	} else {
-		instance->irq_context[0].instance = instance;
-		instance->irq_context[0].MSIxIndex = 0;
-		if (request_irq(pdev->irq, instance->instancet->service_isr,
-				IRQF_SHARED, "megasas",
-				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
-			goto fail_irq;
-		}
-	}
+	if (instance->msix_vectors ?
+			megasas_setup_irqs_msix(instance, 0) :
+			megasas_setup_irqs_ioapic(instance))
+		goto fail_init_mfi;
 
 	/* Re-launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
@@ -5748,7 +5755,6 @@ megasas_resume(struct pci_dev *pdev)
 
 	return 0;
 
-fail_irq:
 fail_init_mfi:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -5829,16 +5835,8 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	instance->instancet->disable_intr(instance);
 
-	if (instance->msix_vectors)
-		for (i = 0; i < instance->msix_vectors; i++) {
-			if (smp_affinity_enable)
-				irq_set_affinity_hint(
-					instance->msixentry[i].vector, NULL);
-			free_irq(instance->msixentry[i].vector,
-				 &instance->irq_context[i]);
-		}
-	else
-		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+	megasas_destroy_irqs(instance);
+
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 
@@ -5912,23 +5910,14 @@ static void megasas_detach_one(struct pci_dev *pdev)
  */
 static void megasas_shutdown(struct pci_dev *pdev)
 {
-	int i;
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
 
 	instance->unload = 1;
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 	instance->instancet->disable_intr(instance);
-	if (instance->msix_vectors)
-		for (i = 0; i < instance->msix_vectors; i++) {
-			if (smp_affinity_enable)
-				irq_set_affinity_hint(
-					instance->msixentry[i].vector, NULL);
-			free_irq(instance->msixentry[i].vector,
-				 &instance->irq_context[i]);
-		}
-	else
-		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+	megasas_destroy_irqs(instance);
+
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 }
-- 
1.7.1

