From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/14] lpfc: Fix to remove IRQF_SHARED flag for MSI/MSI-X
 vectors.
Date: Mon, 20 Apr 2015 09:56:32 -0400
Message-ID: <55350590.RQUlxZyUzEkcVEaD%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:30920 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbbDTN5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix to remove IRQF_SHARED flag for MSI/MSI-X vectors.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 15825f6..6ab8312 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8369,7 +8369,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 
 	/* vector-0 is associated to slow-path handler */
 	rc = request_irq(phba->msix_entries[0].vector,
-			 &lpfc_sli_sp_intr_handler, IRQF_SHARED,
+			 &lpfc_sli_sp_intr_handler, 0,
 			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
@@ -8380,7 +8380,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 
 	/* vector-1 is associated to fast-path handler */
 	rc = request_irq(phba->msix_entries[1].vector,
-			 &lpfc_sli_fp_intr_handler, IRQF_SHARED,
+			 &lpfc_sli_fp_intr_handler, 0,
 			 LPFC_FP_DRIVER_HANDLER_NAME, phba);
 
 	if (rc) {
@@ -8489,7 +8489,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 	}
 
 	rc = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
-			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+			 0, LPFC_DRIVER_NAME, phba);
 	if (rc) {
 		pci_disable_msi(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
@@ -8946,13 +8946,13 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		if (phba->cfg_fof && (index == (vectors - 1)))
 			rc = request_irq(
 				phba->sli4_hba.msix_entries[index].vector,
-				 &lpfc_sli4_fof_intr_handler, IRQF_SHARED,
+				 &lpfc_sli4_fof_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
 				 &phba->sli4_hba.fcp_eq_hdl[index]);
 		else
 			rc = request_irq(
 				phba->sli4_hba.msix_entries[index].vector,
-				 &lpfc_sli4_hba_intr_handler, IRQF_SHARED,
+				 &lpfc_sli4_hba_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
 				 &phba->sli4_hba.fcp_eq_hdl[index]);
 		if (rc) {
@@ -9052,7 +9052,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	}
 
 	rc = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
-			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+			 0, LPFC_DRIVER_NAME, phba);
 	if (rc) {
 		pci_disable_msi(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-- 
1.7.11.7

