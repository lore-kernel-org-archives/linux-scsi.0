From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 08/11] megaraid_sas : Add module parameter to
 disable IRQ-CPU affinity hint
Date: Fri, 12 Sep 2014 18:57:48 +0530
Message-ID: <201409121330.s8CDUAIJ022453@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:17820
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753374AbaILN2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 09:28:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Resending the patch. Addressed the review comments from Tomas Henzl.

For certain deployment, we may need to disable irq cpu affinity hint.
This module parameter provides option for use to disable irq cpu affinity hint
and allow irqbalancer to handle the rest.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 60 +++++++++++++++++++------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index bc79a05..4c4c266 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -89,6 +89,10 @@ module_param(resetwaittime, int, S_IRUGO);
 MODULE_PARM_DESC(resetwaittime, "Wait time in seconds after I/O timeout "
 		 "before resetting adapter. Default: 180");
 
+int smp_affinity_enable = 1;
+module_param(smp_affinity_enable, int, S_IRUGO);
+MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -5162,8 +5166,9 @@ retry_irq_register:
 				printk(KERN_DEBUG "megasas: Failed to "
 				       "register IRQ for vector %d.\n", i);
 				for (j = 0; j < i; j++) {
-					irq_set_affinity_hint(
-						instance->msixentry[j].vector, NULL);
+					if (smp_affinity_enable)
+						irq_set_affinity_hint(
+							instance->msixentry[j].vector, NULL);
 					free_irq(
 						instance->msixentry[j].vector,
 						&instance->irq_context[j]);
@@ -5172,11 +5177,14 @@ retry_irq_register:
 				instance->msix_vectors = 0;
 				goto retry_irq_register;
 			}
-			if (irq_set_affinity_hint(instance->msixentry[i].vector,
-				get_cpu_mask(cpu)))
-				dev_err(&instance->pdev->dev, "Error setting"
-					"affinity hint for cpu %d\n", cpu);
-			cpu = cpumask_next(cpu, cpu_online_mask);
+			if (smp_affinity_enable) {
+				if (irq_set_affinity_hint(instance->msixentry[i].vector,
+					get_cpu_mask(cpu)))
+					dev_err(&instance->pdev->dev,
+						"Error setting affinity hint "
+						"for cpu %d\n", cpu);
+				cpu = cpumask_next(cpu, cpu_online_mask);
+			}
 		}
 	} else {
 		instance->irq_context[0].instance = instance;
@@ -5235,8 +5243,9 @@ retry_irq_register:
 	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
-			irq_set_affinity_hint(
-				instance->msixentry[i].vector, NULL);
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
 		}
@@ -5399,8 +5408,9 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
-			irq_set_affinity_hint(
-				instance->msixentry[i].vector, NULL);
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
 		}
@@ -5509,8 +5519,9 @@ megasas_resume(struct pci_dev *pdev)
 				printk(KERN_DEBUG "megasas: Failed to "
 				       "register IRQ for vector %d.\n", i);
 				for (j = 0; j < i; j++) {
-					irq_set_affinity_hint(
-						instance->msixentry[j].vector, NULL);
+					if (smp_affinity_enable)
+						irq_set_affinity_hint(
+							instance->msixentry[j].vector, NULL);
 					free_irq(
 						instance->msixentry[j].vector,
 						&instance->irq_context[j]);
@@ -5518,11 +5529,14 @@ megasas_resume(struct pci_dev *pdev)
 				goto fail_irq;
 			}
 
-			if (irq_set_affinity_hint(instance->msixentry[i].vector,
-				get_cpu_mask(cpu)))
-				dev_err(&instance->pdev->dev, "Error setting"
-					"affinity hint for cpu %d\n", cpu);
-			cpu = cpumask_next(cpu, cpu_online_mask);
+			if (smp_affinity_enable) {
+				if (irq_set_affinity_hint(instance->msixentry[i].vector,
+					get_cpu_mask(cpu)))
+					dev_err(&instance->pdev->dev, "Error "
+						"setting affinity hint for cpu "
+						"%d\n", cpu);
+				cpu = cpumask_next(cpu, cpu_online_mask);
+			}
 		}
 	} else {
 		instance->irq_context[0].instance = instance;
@@ -5640,8 +5654,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
-			irq_set_affinity_hint(
-				instance->msixentry[i].vector, NULL);
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
 		}
@@ -5729,8 +5744,9 @@ static void megasas_shutdown(struct pci_dev *pdev)
 	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
-			irq_set_affinity_hint(
-				instance->msixentry[i].vector, NULL);
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
 			free_irq(instance->msixentry[i].vector,
 				 &instance->irq_context[i]);
 		}
-- 
1.8.3.1

