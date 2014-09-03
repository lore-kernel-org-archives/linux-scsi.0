From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/19] lpfc 10.4.8000.0: Use pci_enable_msix_range() instead
 of pci_enable_msix()
Date: Wed, 3 Sep 2014 12:56:29 -0400
Message-ID: <1409763389.12357.9.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:43852 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaICQ4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:56:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=linux-scsi&m=140835226413990&w=2

  Alexander Gordeev <agordeev@redhat.com>
  [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()

  As result of deprecation of MSI-X/MSI enablement functions
  pci_enable_msix() and pci_enable_msi_block() all drivers
  using these two interfaces need to be updated to use the
  new pci_enable_msi_range()  or pci_enable_msi_exact()
  and pci_enable_msix_range() or pci_enable_msix_exact()
  interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 990c3a2..1953b3b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8203,9 +8203,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
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
@@ -8229,8 +8229,8 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 		phba->msix_entries[i].entry = i;
 
 	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
+	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
+				   LPFC_MSIX_VECTORS);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
@@ -8767,16 +8767,14 @@ out:
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
- * enabled and leaks its vectors.
+ * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
+ * is called to enable the MSI-X vectors. The device driver is responsible
+ * for calling the individual request_irq() to register each MSI-X vector
+ * with a interrupt handler, which is done in this function. Note that
+ * later when device is unloading, the driver should always call free_irq()
+ * on all MSI-X vectors it has done request_irq() on before calling
+ * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
+ * will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
  * 0 - successful
@@ -8797,17 +8795,14 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
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
-- 
1.7.11.7




