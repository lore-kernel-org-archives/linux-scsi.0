From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 1/3] be2iscsi: Fixing the /proc/interrupts problem V3
Date: Wed, 24 Aug 2011 16:05:30 -0700
Message-ID: <cfc23c84-77ba-42e6-9465-ee567eabdb93@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:5729 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821Ab1HXXGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2011 19:06:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Fix be2iscsi driver to use a separate pointer for each irq action->name
field and avoid display corruption in /proc/interrupts. The be2iscsi driver
was using a single static array in a function for the irq action->name field.
This results in garbage output from  /proc/interrupts

The pointer for action->name is garbage and scribbles the output on the screen.

This patch fixes the problem:

156:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0          0       PCI-MSI-X  beiscsi_msix_0017

This patch is based on Prarit's patch here:
http://www.spinics.net/lists/linux-scsi/msg52325.html
but I have fixed up the failure paths and removed
redundant check for !i suggested by Eike.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   34 ++++++++++++++++++++++++++--------
 drivers/scsi/be2iscsi/be_main.h |    3 +++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 72ac64b..04970eb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -822,33 +822,47 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	int ret, msix_vec, i, j;
-	char desc[32];
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
 	if (phba->msix_enabled) {
 		for (i = 0; i < phba->num_cpus; i++) {
-			sprintf(desc, "beiscsi_msix_%04x", i);
+			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
+						    GFP_KERNEL);
+			if (!phba->msi_name[i]) {
+				ret = -ENOMEM;
+				goto free_msix_irqs;
+			}
+
+			sprintf(phba->msi_name[i], "beiscsi_%02x_%02x",
+				phba->shost->host_no, i);
 			msix_vec = phba->msix_entries[i].vector;
-			ret = request_irq(msix_vec, be_isr_msix, 0, desc,
+			ret = request_irq(msix_vec, be_isr_msix, 0,
+					  phba->msi_name[i],
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
 					     "beiscsi_init_irqs-Failed to"
 					     "register msix for i = %d\n", i);
-				if (!i)
-					return ret;
+				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
 			}
 		}
+		phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
+		if (!phba->msi_name[i]) {
+			ret = -ENOMEM;
+			goto free_msix_irqs;
+		}
+		sprintf(phba->msi_name[i], "beiscsi_mcc_%02x",
+			phba->shost->host_no);
 		msix_vec = phba->msix_entries[i].vector;
-		ret = request_irq(msix_vec, be_isr_mcc, 0, "beiscsi_msix_mcc",
+		ret = request_irq(msix_vec, be_isr_mcc, 0, phba->msi_name[i],
 				  &phwi_context->be_eq[i]);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
 				     "Failed to register beiscsi_msix_mcc\n");
-			i++;
+			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
 
@@ -863,8 +877,11 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 	}
 	return 0;
 free_msix_irqs:
-	for (j = i - 1; j == 0; j++)
+	for (j = i - 1; j >= 0; j--) {
+		kfree(phba->msi_name[j]);
+		msix_vec = phba->msix_entries[j].vector;
 		free_irq(msix_vec, &phwi_context->be_eq[j]);
+	}
 	return ret;
 }
 
@@ -4125,6 +4142,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 		for (i = 0; i <= phba->num_cpus; i++) {
 			msix_vec = phba->msix_entries[i].vector;
 			free_irq(msix_vec, &phwi_context->be_eq[i]);
+			kfree(phba->msi_name[i]);
 		}
 	} else
 		if (phba->pcidev->irq)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 5ce5170..be0e0bd 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -162,6 +162,8 @@ do {							\
 #define PAGES_REQUIRED(x) \
 	((x < PAGE_SIZE) ? 1 :  ((x + PAGE_SIZE - 1) / PAGE_SIZE))
 
+#define BEISCSI_MSI_NAME 20 /* size of msi_name string */
+
 enum be_mem_enum {
 	HWI_MEM_ADDN_CONTEXT,
 	HWI_MEM_WRB,
@@ -287,6 +289,7 @@ struct beiscsi_hba {
 	unsigned int num_cpus;
 	unsigned int nxt_cqid;
 	struct msix_entry msix_entries[MAX_CPUS + 1];
+	char *msi_name[MAX_CPUS + 1];
 	bool msix_enabled;
 	struct be_mem_descriptor *init_mem;
 
-- 
1.7.1

