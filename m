From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 1/18] megaraid_sas : Add separate function for
 setting up IRQs
Date: Mon, 20 Apr 2015 18:02:30 +0530
Message-ID: <201504201234.t3KCYg04016312@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:39725
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755278AbbDTMsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 08:48:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will create separate function for setting up IRQs and enable interrupts after adapter's initialization.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |  201 ++++++++++++++---------------
 1 files changed, 97 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..bb68ba9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4415,6 +4415,72 @@ fail_alloc_cmds:
 }
 
 /**
+ * megasas_setup_irqs -	register interrupt with IRQ sub system.
+ * @instance:				Adapter soft state
+ * @is_probe:				Driver probe check
+ *
+ * Do not enable interrupt, only setup ISRs.
+ *
+ * Return 0 on success.
+ */
+static int
+megasas_setup_irqs(struct megasas_instance *instance, u8 is_probe)
+{
+	int i, j, cpu;
+	struct pci_dev *pdev;
+
+	pdev = instance->pdev;
+
+try_io_apic:
+	if (!instance->msix_vectors) {
+		instance->irq_context[0].instance = instance;
+		instance->irq_context[0].MSIxIndex = 0;
+		if (request_irq(pdev->irq, instance->instancet->service_isr,
+			IRQF_SHARED, "megasas", &instance->irq_context[0])) {
+			dev_err(&instance->pdev->dev,
+					"Failed to register IRQ from %s %d\n",
+					__func__, __LINE__);
+			return -1;
+		}
+		return 0;
+	}
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
+				goto try_io_apic;
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
+/**
  * megasas_init_fw -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -4552,11 +4618,14 @@ static int megasas_init_fw(struct megasas_instance *instance)
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
+		if (megasas_setup_irqs(instance, 1))
+			goto fail_setup_irqs;
 	}
 
 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
@@ -4573,6 +4642,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
+	instance->instancet->enable_intr(instance);
 
 	printk(KERN_ERR "megasas: INIT adapter done\n");
 
@@ -4584,7 +4654,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
 		printk(KERN_ERR "megasas: failed to get PD list\n");
-		goto fail_init_adapter;
+		goto fail_get_pd_list;
 	}
 
 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
@@ -4733,7 +4803,22 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	return 0;
 
+fail_get_pd_list:
+	instance->instancet->disable_intr(instance);
 fail_init_adapter:
+	if (instance->msix_vectors)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
+			free_irq(instance->msixentry[i].vector, &instance->irq_context[i]);
+		}
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+fail_setup_irqs:
+	if (instance->msix_vectors)
+		pci_disable_msix(instance->pdev);
+	instance->msix_vectors = 0;
 fail_ready_state:
 	kfree(instance->ctrl_info);
 	instance->ctrl_info = NULL;
@@ -5106,7 +5191,7 @@ fail_set_dma_mask:
 static int megasas_probe_one(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
-	int rval, pos, i, j, cpu;
+	int rval, pos, i;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
@@ -5315,55 +5400,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
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
@@ -5420,7 +5456,7 @@ retry_irq_register:
 		}
 	else
 		free_irq(instance->pdev->irq, &instance->irq_context[0]);
-fail_irq:
+
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
@@ -5428,9 +5464,9 @@ fail_irq:
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
-      fail_init_mfi:
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
+      fail_init_mfi:
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -5611,7 +5647,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 static int
 megasas_resume(struct pci_dev *pdev)
 {
-	int rval, i, j, cpu;
+	int rval;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -5681,50 +5717,8 @@ megasas_resume(struct pci_dev *pdev)
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
+	if (megasas_setup_irqs(instance, 0))
+		goto fail_init_mfi;
 
 	/* Re-launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
@@ -5748,7 +5742,6 @@ megasas_resume(struct pci_dev *pdev)
 
 	return 0;
 
-fail_irq:
 fail_init_mfi:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
-- 
1.7.1

