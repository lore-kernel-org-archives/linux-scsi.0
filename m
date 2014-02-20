From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 12/22] lpfc: Use pci_enable_msix_range()
Date: Thu, 20 Feb 2014 11:47:02 -0500
Message-ID: <a34533b1-77d9-45bc-ad66-aab336972b95@CMEXHTCAS2.ad.emulex.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: agordeev@redhat.com
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Alexander,

I've reworked this patch to layer on top of our rev 8.3.45 patches
that were just posted to linux-scsi. There were some conflicts due to
new additions.  Additionally, there were two other uses of pci_enable_msiXXX
that needed to be addressed.  The changes in this patch also address the
change requested by:
"[PATCH 11/22] lpfc: Remove superfluous call to pci_disable_msix()"

To avoid creating merge conflicts - either by your patches going in then
scsi git tree trying to merge or by scsi git tree going in and your patches
trying to merge - I recommend that you eliminate your lpfc patches from the
kernel and apply the patch below once scsi git with the updated lpfc driver
has actually merged.

-- james s


Revised patch:



As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

CC: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org



Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 16:23:07.260097013 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-02-20 11:39:20.348203354 -0500
@@ -8100,8 +8100,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-3 interface specs. The kernel function pci_enable_msix() is
- * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
+ * with SLI-3 interface specs. The kernel function pci_enable_msix_range() is
+ * called to enable the MSI-X vectors. Note that pci_enable_msix_range(), once
  * invoked, enables either all or nothing, depending on the current
  * availability of PCI vector resources. The device driver is responsible
  * for calling the individual request_irq() to register each MSI-X vector
@@ -8126,12 +8126,12 @@ lpfc_sli_enable_msix(struct lpfc_hba *ph
 		phba->msix_entries[i].entry = i;
 
 	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
-	if (rc) {
+	rc = pci_enable_msix_range(phba->pcidev, phba->msix_entries,
+				   LPFC_MSIX_VECTORS, LPFC_MSIX_VECTORS);
+	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
-		goto msi_fail_out;
+		goto vec_fail_out;
 	}
 	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -8209,6 +8209,8 @@ irq_fail_out:
 msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
 	pci_disable_msix(phba->pcidev);
+
+vec_fail_out:
 	return rc;
 }
 
@@ -8238,8 +8240,8 @@ lpfc_sli_disable_msix(struct lpfc_hba *p
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
@@ -8252,8 +8254,8 @@ lpfc_sli_enable_msi(struct lpfc_hba *phb
 {
 	int rc;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
+	rc = pci_enable_msi_range(phba->pcidev, 1, 1);
+	if (rc > 0)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0462 PCI enable MSI mode success.\n");
 	else {
@@ -8692,17 +8694,15 @@ lpfc_sli4_enable_msix(struct lpfc_hba *p
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
 		goto msi_fail_out;
 	}
+	vectors = rc;
 
 	/* Log MSI-X vector assignment */
 	for (index = 0; index < vectors; index++)
@@ -8764,9 +8764,10 @@ cfg_fail_out:
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
 	}
 
-msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
 	pci_disable_msix(phba->pcidev);
+
+msi_fail_out:
 	return rc;
 }
 
@@ -8804,7 +8805,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-4 interface spec. The kernel function pci_enable_msi() is called
+ * SLI-4 interface spec. The kernel function pci_enable_msi_range() is called
  * to enable the MSI vector. The device driver is responsible for calling
  * the request_irq() to register MSI vector with a interrupt the handler,
  * which is done in this function.
@@ -8818,8 +8819,8 @@ lpfc_sli4_enable_msi(struct lpfc_hba *ph
 {
 	int rc, index;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
+	rc = pci_enable_msi_range(phba->pcidev, 1, 1);
+	if (rc > 0)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0487 PCI enable MSI mode success.\n");
 	else {
