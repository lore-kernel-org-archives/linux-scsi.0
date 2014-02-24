From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 12/23] lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:12 +0100
Message-ID: <4deb0051eba22e1a741e4359621b858db0cbe1e5.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbaBXIBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 03:01:05 -0500
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

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
 drivers/scsi/lpfc/lpfc_init.c |   45 ++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a9df97a..5368f75 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8047,9 +8047,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
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
@@ -8073,8 +8073,8 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 		phba->msix_entries[i].entry = i;
 
 	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
+	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
+				   ARRAY_SIZE(phba->msix_entries));
 	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
@@ -8187,8 +8187,8 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-3 interface spec. The kernel function pci_enable_msi() is called to
- * enable the MSI vector. The device driver is responsible for calling the
+ * SLI-3 interface spec. The kernel function pci_enable_msi() is called
+ * to enable the MSI vector. The device driver is responsible for calling the
  * request_irq() to register MSI vector with a interrupt the handler, which
  * is done in this function.
  *
@@ -8611,16 +8611,14 @@ out:
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
@@ -8636,17 +8634,14 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
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

