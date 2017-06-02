From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 11/17] lpfc: Fix System panic after loading the driver
Date: Thu,  1 Jun 2017 21:07:05 -0700
Message-ID: <20170602040711.21046-12-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33303 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdFBEH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:07:57 -0400
Received: by mail-qt0-f194.google.com with SMTP id w1so3909547qtg.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:07:57 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

System panic with general protection fault during driver load

The driver uses a static array sli4_hba.handler_name
to store the irq handler names. If the io_channel_irqs
exceeds the pre-allocated size (32+1), then the driver
will overwrite other fields of sli4_hba.

Fix: Dynamically allocate handler_name.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++++-----
 drivers/scsi/lpfc/lpfc_sli4.h |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3064f0768033..a825806036c3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9665,6 +9665,7 @@ static int
 lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
 	int vectors, rc, index;
+	char *name;
 
 	/* Set up MSI-X multi-message vectors */
 	vectors = phba->io_channel_irqs;
@@ -9683,9 +9684,9 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 
 	/* Assign MSI-X vectors to interrupt handlers */
 	for (index = 0; index < vectors; index++) {
-		memset(&phba->sli4_hba.handler_name[index], 0, 16);
-		snprintf((char *)&phba->sli4_hba.handler_name[index],
-			 LPFC_SLI4_HANDLER_NAME_SZ,
+		name = phba->sli4_hba.hba_eq_hdl[index].handler_name;
+		memset(name, 0, LPFC_SLI4_HANDLER_NAME_SZ);
+		snprintf(name, LPFC_SLI4_HANDLER_NAME_SZ,
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
 		phba->sli4_hba.hba_eq_hdl[index].idx = index;
@@ -9694,12 +9695,12 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		if (phba->cfg_fof && (index == (vectors - 1)))
 			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_fof_intr_handler, 0,
-				 (char *)&phba->sli4_hba.handler_name[index],
+				 name,
 				 &phba->sli4_hba.hba_eq_hdl[index]);
 		else
 			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_hba_intr_handler, 0,
-				 (char *)&phba->sli4_hba.handler_name[index],
+				 name,
 				 &phba->sli4_hba.hba_eq_hdl[index]);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index cf863db27700..28b75e08e044 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -407,8 +407,10 @@ struct lpfc_max_cfg_param {
 
 struct lpfc_hba;
 /* SLI4 HBA multi-fcp queue handler struct */
+#define LPFC_SLI4_HANDLER_NAME_SZ	16
 struct lpfc_hba_eq_hdl {
 	uint32_t idx;
+	char handler_name[LPFC_SLI4_HANDLER_NAME_SZ];
 	struct lpfc_hba *phba;
 	atomic_t hba_eq_in_use;
 	struct cpumask *cpumask;
@@ -480,7 +482,6 @@ struct lpfc_sli4_lnk_info {
 
 #define LPFC_SLI4_HANDLER_CNT		(LPFC_HBA_IO_CHAN_MAX+ \
 					 LPFC_FOF_IO_CHAN_NUM)
-#define LPFC_SLI4_HANDLER_NAME_SZ	16
 
 /* Used for IRQ vector to CPU mapping */
 struct lpfc_vector_map_info {
@@ -548,7 +549,6 @@ struct lpfc_sli4_hba {
 	uint32_t ue_to_rp;
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
-	uint8_t handler_name[LPFC_SLI4_HANDLER_CNT][LPFC_SLI4_HANDLER_NAME_SZ];
 	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
 	/* Pointers to the constructed SLI4 queues */
-- 
2.11.0
