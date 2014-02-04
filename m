From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 12/22] lpfc: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:58 +0100
Message-ID: <605e7b6cc5ef782344ad8de2b14766126ada061a.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a9df97a..5bb40ca 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8187,8 +8187,8 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-3 interface spec. The kernel function pci_enable_msi() is called to
- * enable the MSI vector. The device driver is responsible for calling the
+ * SLI-3 interface spec. The kernel function pci_enable_msi_range() is called
+ * to enable the MSI vector. The device driver is responsible for calling the
  * request_irq() to register MSI vector with a interrupt the handler, which
  * is done in this function.
  *
@@ -8201,8 +8201,8 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 {
 	int rc;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
+	rc = pci_enable_msi_range(phba->pcidev, 1, 1);
+	if (rc > 0)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0462 PCI enable MSI mode success.\n");
 	else {
@@ -8636,17 +8636,14 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		phba->sli4_hba.msix_entries[index].entry = index;
 
 	/* Configure MSI-X capability structure */
-	vectors = phba->cfg_fcp_io_channel;
-enable_msix_vectors:
-	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
-			     vectors);
-	if (rc > 1) {
-		vectors = rc;
-		goto enable_msix_vectors;
-	} else if (rc) {
+	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
+				   2, phba->cfg_fcp_io_channel);
+	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
 		goto vec_fail_out;
+	} else {
+		vectors = rc;
 	}
 
 	/* Log MSI-X vector assignment */
-- 
1.7.7.6
