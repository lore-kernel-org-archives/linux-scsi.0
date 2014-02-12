From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 4/4] megaraid_sas : Performance boost fixes
Date: Wed, 12 Feb 2014 23:40:14 +0530
Message-ID: <201402121239.s1CCdw6s007458@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:56137
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751337AbaBLMlN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 07:41:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Changes done for performance boost-
1) Added code to set SMP IRQ affinity per CPU
2) Removed host lock for queue_command to enable Asynchronous IO submission
3) Pass MSI-x index, while issuing sysPD IO.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 74cd884..28acd7a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1519,7 +1519,7 @@ out_return_cmd:
  * @done:			Callback entry point
  */
 static int
-megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
+megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *instance;
 	unsigned long flags;
@@ -1535,7 +1535,7 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 		scmd->result = DID_ERROR << 16;
-		done(scmd);
+		scmd->scsi_done(scmd);
 		return 0;
 	}
 
@@ -1546,7 +1546,6 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-	scmd->scsi_done = done;
 	scmd->result = 0;
 
 	if (MEGASAS_IS_LOGICAL(scmd) &&
@@ -1575,12 +1574,10 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 	return 0;
 
  out_done:
-	done(scmd);
+	scmd->scsi_done(scmd);
 	return 0;
 }
 
-static DEF_SCSI_QCMD(megasas_queue_command)
-
 static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 {
 	int i;
@@ -4246,7 +4243,7 @@ fail_set_dma_mask:
 static int megasas_probe_one(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
-	int rval, pos, i, j;
+	int rval, pos, i, j, cpu;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
@@ -4419,7 +4416,8 @@ retry_irq_register:
 	 * Register IRQ
 	 */
 	if (instance->msix_vectors) {
-		for (i = 0 ; i < instance->msix_vectors; i++) {
+		cpu = cpumask_first(cpu_online_mask);
+		for (i = 0; i < instance->msix_vectors; i++) {
 			instance->irq_context[i].instance = instance;
 			instance->irq_context[i].MSIxIndex = i;
 			if (request_irq(instance->msixentry[i].vector,
@@ -4428,14 +4426,22 @@ retry_irq_register:
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
@@ -4489,9 +4495,12 @@ retry_irq_register:
 
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
@@ -4645,9 +4654,12 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
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
@@ -4668,7 +4680,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 static int
 megasas_resume(struct pci_dev *pdev)
 {
-	int rval, i, j;
+	int rval, i, j, cpu;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -4740,6 +4752,7 @@ megasas_resume(struct pci_dev *pdev)
 	 * Register IRQ
 	 */
 	if (instance->msix_vectors) {
+		cpu = cpumask_first(cpu_online_mask);
 		for (i = 0 ; i < instance->msix_vectors; i++) {
 			instance->irq_context[i].instance = instance;
 			instance->irq_context[i].MSIxIndex = i;
@@ -4749,12 +4762,21 @@ megasas_resume(struct pci_dev *pdev)
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
@@ -4853,9 +4875,12 @@ static void megasas_detach_one(struct pci_dev *pdev)
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
@@ -4910,9 +4935,12 @@ static void megasas_shutdown(struct pci_dev *pdev)
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
