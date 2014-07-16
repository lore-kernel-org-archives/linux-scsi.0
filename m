From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 12/23] lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 16 Jul 2014 20:05:16 +0200
Message-ID: <ea1bf102a3ce0471996e2ddaaa498b088ac791c8.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a5769a9..d9caed9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8211,9 +8211,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-3 interface specs. The kernel function pci_enable_msix() is
- * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
- * invoked, enables either all or nothing, depending on the current
+ * with SLI-3 interface specs. The kernel function pci_enable_msix_exact()
+ * is called to enable the MSI-X vectors. Note that pci_enable_msix_exact(),
+ * once invoked, enables either all or nothing, depending on the current
  * availability of PCI vector resources. The device driver is responsible
  * for calling the individual request_irq() to register each MSI-X vector
  * with a interrupt handler, which is done in this function. Note that
@@ -8237,8 +8237,8 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 		phba->msix_entries[i].entry = i;
 
 	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
+	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
+				   ARRAY_SIZE(phba->msix_entries));
 	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
@@ -8775,15 +8775,13 @@ out:
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-4 interface spec. The kernel function pci_enable_msix() is called
- * to enable the MSI-X vectors. Note that pci_enable_msix(), once invoked,
- * enables either all or nothing, depending on the current availability of
- * PCI vector resources. The device driver is responsible for calling the
- * individual request_irq() to register each MSI-X vector with a interrupt
- * handler, which is done in this function. Note that later when device is
- * unloading, the driver should always call free_irq() on all MSI-X vectors
- * it has done request_irq() on before calling pci_disable_msix(). Failure
- * to do so results in a BUG_ON() and a device will be left with MSI-X
+ * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
+ * is called to enable the MSI-X vectors. The device driver is responsible
+ * for calling the individual request_irq() to register each MSI-X vector
+ * with a interrupt handler, which is done in this function. Note that later
+ * when device is unloading, the driver should always call free_irq() on all
+ * MSI-X vectors it has done request_irq() on before calling pci_disable_msix()
+ * Failure to do so results in a BUG_ON() and a device will be left with MSI-X
  * enabled and leaks its vectors.
  *
  * Return codes
@@ -8805,18 +8803,16 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		phba->sli4_hba.msix_entries[index].entry = index;
 		vectors++;
 	}
-enable_msix_vectors:
-	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
-			     vectors);
-	if (rc > 1) {
-		vectors = rc;
-		goto enable_msix_vectors;
-	} else if (rc) {
+
+	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
+				   2, vectors);
+	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
 		goto vec_fail_out;
 	}
 
+	vectors = rc;
 	/* Log MSI-X vector assignment */
 	for (index = 0; index < vectors; index++)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-- 
1.7.7.6
