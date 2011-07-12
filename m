From: <jayamohan.kallickal@emulex.com>
Subject: [PATCH 2/2] be2iscsi: Fixing the /proc/interrupts problem V3
Date: Tue, 12 Jul 2011 10:12:35 -0700
Message-ID: <894955a8-23e3-4553-bfb5-614b2bc8ed93@exht1.ad.emulex.com>
References: <1310490756-2210-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:50430 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009Ab1GLRNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 13:13:11 -0400
In-Reply-To: <1310490756-2210-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Prarit Bhargava <prarit@redhat.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patch is based on one by Prarit Bhargava. I have made minor
changes. Also, removed the redundant check for i == 0 and adding changelog  as suggested
by Rolf.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Jayamohan Kallickal <jayamohan,kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   33 +++++++++++++++++++++++++--------
 drivers/scsi/be2iscsi/be_main.h |    3 +++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 97c134a..a8a80e4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -822,33 +822,46 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	int ret, msix_vec, i, j;
-	char desc[32];
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
 	if (phba->msix_enabled) {
 		for (i = 0; i < phba->num_cpus; i++) {
-			sprintf(desc, "beiscsi_msix_%04x", i);
+			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
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
 
@@ -863,8 +876,11 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
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
 
@@ -4125,6 +4141,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 		for (i = 0; i <= phba->num_cpus; i++) {
 			msix_vec = phba->msix_entries[i].vector;
 			free_irq(msix_vec, &phwi_context->be_eq[i]);
+			kfree(phba->msi_name[i]);
 		}
 	} else
 		if (phba->pcidev->irq)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 4677de9..7b6578e 100644
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

