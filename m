From: <Sumit.Saxena@lsi.com>
Subject: [PATCH/RESEND 4/4] megaraid_sas : Performance boost fixes
Date: Sun, 2 Mar 2014 05:28:11 +0530
Message-ID: <201403020759.s227xWs6017901@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:27160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751741AbaCBICf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2014 03:02:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com, megaraidlinux@lsi.com
Cc: aradford@gmail.com

Please ignore last sent patch on performance boost with subject line - "[PATCH 4/4] megaraid_sas : Performance boost fixes"
Resending the performance boost patch with one change being reverted back- Remove host lock for queuecommand for asynchronous IO submission
, Host lock is added back around queuecommand. Host lock removal can create race conditon between ISR path(when RAID map update interrupt 
is raised) and IO build path of driver, since IO build path is making use of RAID map, and in case of RAID map update interrupt, old RAID
map copy is memset to zero, which some IOs may be referencing in build IO path.
Changes done for performance boost-
1) Added code to set SMP IRQ affinity per CPU.
2) Pass MSI-x index, while issuing sysPD IO.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 74cd884..d2faa61 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4246,7 +4246,7 @@ fail_set_dma_mask:
 static int megasas_probe_one(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
-	int rval, pos, i, j;
+	int rval, pos, i, j, cpu;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
@@ -4419,7 +4419,8 @@ retry_irq_register:
 	 * Register IRQ
 	 */
 	if (instance->msix_vectors) {
-		for (i = 0 ; i < instance->msix_vectors; i++) {
+		cpu = cpumask_first(cpu_online_mask);
+		for (i = 0; i < instance->msix_vectors; i++) {
 			instance->irq_context[i].instance = instance;
 			instance->irq_context[i].MSIxIndex = i;
 			if (request_irq(instance->msixentry[i].vector,
@@ -4428,14 +4429,22 @@ retry_irq_register:
 					&instance->irq_context[i])) {
 				printk(KERN_DEBUG "megasas: Failed to "
 				       "register IRQ for vector %d.\n", i);
-				for (j = 0 ; j < i ; j++)
+				for (j = 0; j < i; j++) {
+					irq_set_affinity_hint(
+						instance->msixentry[j].vector, NULL);
 					free_irq(
 						instance->msixentry[j].vector,
 						&instance->irq_context[j]);
+				}
 				/* Retry irq register for IO_APIC */
 				instance->msix_vectors = 0;
 				goto retry_irq_register;
 			}
+			if (irq_set_affinity_hint(instance->msixentry[i].vector,
+				get_cpu_mask(cpu)))
+				dev_err(&instance->pdev->dev, "Error setting"
+					"affinity hint for cpu %d\n", cpu);
+			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
 	} else {
 		instance->irq_context[0].instance = instance;
@@ -4489,9 +4498,12 @@ retry_irq_register:
 
 	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
-		for (i = 0 ; i < instance->msix_vectors; i++)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			irq_set_affinity_hint(
+				instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
+		}
 	else
 		free_irq(instance->pdev->irq, &instance->irq_context[0]);
 fail_irq:
@@ -4645,9 +4657,12 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	instance->instancet->disable_intr(instance);
 
 	if (instance->msix_vectors)
-		for (i = 0 ; i < instance->msix_vectors; i++)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			irq_set_affinity_hint(
+				instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
+		}
 	else
 		free_irq(instance->pdev->irq, &instance->irq_context[0]);
 	if (instance->msix_vectors)
@@ -4668,7 +4683,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 static int
 megasas_resume(struct pci_dev *pdev)
 {
-	int rval, i, j;
+	int rval, i, j, cpu;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -4740,6 +4755,7 @@ megasas_resume(struct pci_dev *pdev)
 	 * Register IRQ
 	 */
 	if (instance->msix_vectors) {
+		cpu = cpumask_first(cpu_online_mask);
 		for (i = 0 ; i < instance->msix_vectors; i++) {
 			instance->irq_context[i].instance = instance;
 			instance->irq_context[i].MSIxIndex = i;
@@ -4749,12 +4765,21 @@ megasas_resume(struct pci_dev *pdev)
 					&instance->irq_context[i])) {
 				printk(KERN_DEBUG "megasas: Failed to "
 				       "register IRQ for vector %d.\n", i);
-				for (j = 0 ; j < i ; j++)
+				for (j = 0; j < i; j++) {
+					irq_set_affinity_hint(
+						instance->msixentry[j].vector, NULL);
 					free_irq(
 						instance->msixentry[j].vector,
 						&instance->irq_context[j]);
+				}
 				goto fail_irq;
 			}
+
+			if (irq_set_affinity_hint(instance->msixentry[i].vector,
+				get_cpu_mask(cpu)))
+				dev_err(&instance->pdev->dev, "Error setting"
+					"affinity hint for cpu %d\n", cpu);
+			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
 	} else {
 		instance->irq_context[0].instance = instance;
@@ -4853,9 +4878,12 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	instance->instancet->disable_intr(instance);
 
 	if (instance->msix_vectors)
-		for (i = 0 ; i < instance->msix_vectors; i++)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			irq_set_affinity_hint(
+				instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
+		}
 	else
 		free_irq(instance->pdev->irq, &instance->irq_context[0]);
 	if (instance->msix_vectors)
@@ -4910,9 +4938,12 @@ static void megasas_shutdown(struct pci_dev *pdev)
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
-		for (i = 0 ; i < instance->msix_vectors; i++)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			irq_set_affinity_hint(
+				instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
+		}
 	else
 		free_irq(instance->pdev->irq, &instance->irq_context[0]);
 	if (instance->msix_vectors)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0de0e63..e452f68 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1611,6 +1611,8 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		cmd->request_desc->SCSIIO.DevHandle =
 			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+		cmd->request_desc->SCSIIO.MSIxIndex =
+			instance->msix_vectors ? smp_processor_id() % instance->msix_vectors : 0;
 		/*
 		 * If the command is for the tape device, set the
 		 * FP timeout to the os layer timeout value.
