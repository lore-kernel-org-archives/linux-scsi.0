From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/18] lpfc 8.3.42: Fix WARN_ON when driver unloads
Date: Fri, 6 Sep 2013 12:21:19 -0400
Message-ID: <1378484479.14051.32.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22353 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab3IFQV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:21:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix WARN_ON when driver unloads


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:04:23.071058739 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:04:24.916058781 -0400
@@ -8691,9 +8691,12 @@ enable_msix_vectors:
 
 cfg_fail_out:
 	/* free the irq already requested */
-	for (--index; index >= 0; index--)
+	for (--index; index >= 0; index--) {
+		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
+					  vector, NULL);
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
+	}
 
 msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
@@ -8714,9 +8717,12 @@ lpfc_sli4_disable_msix(struct lpfc_hba *
 	int index;
 
 	/* Free up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
+	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
+		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
+					  vector, NULL);
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
+	}
 
 	/* Disable MSI-X */
 	pci_disable_msix(phba->pcidev);



