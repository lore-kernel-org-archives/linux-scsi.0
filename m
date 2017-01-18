From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 01/17] lpfc: Use new pci_alloc_irq_vectors() interface
Date: Tue, 17 Jan 2017 17:20:44 -0800
Message-ID: <587ec2ec.lHOM16QZ9nmppg4/%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33335 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdARBUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:20:49 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so282422wme.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:20:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


Move to new pci_alloc_irq_vectors() interface for intx/msi/msix

Note: io channel paradigm remains, for now.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 227 ++++++++++++++++++++++++++++--------------
 1 file changed, 154 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4776fd8..7a17bd0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8485,16 +8485,14 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-3 interface specs. The kernel function pci_enable_msix_exact()
- * is called to enable the MSI-X vectors. Note that pci_enable_msix_exact(),
- * once invoked, enables either all or nothing, depending on the current
- * availability of PCI vector resources. The device driver is responsible
+ * with SLI-3 interface specs. The kernel function pci_alloc_irq_vectors()
+ * is called to enable the MSI-X vectors. The device driver is responsible
  * for calling the individual request_irq() to register each MSI-X vector
  * with a interrupt handler, which is done in this function. Note that
  * later when device is unloading, the driver should always call free_irq()
  * on all MSI-X vectors it has done request_irq() on before calling
- * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
- * will be left with MSI-X enabled and leaks its vectors.
+ * pci_free_irq_vectors(). Failure to do so results in a BUG_ON() and a
+ * device will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
  *   0 - successful
@@ -8503,21 +8501,33 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 static int
 lpfc_sli_enable_msix(struct lpfc_hba *phba)
 {
-	int rc, i;
+	int vectors, rc, i;
 	LPFC_MBOXQ_t *pmb;
+	unsigned int irq_flags;
+	uint32_t min_cnt;
 
 	/* Set up MSI-X multi-message vectors */
 	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
 		phba->msix_entries[i].entry = i;
 
 	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
-				   LPFC_MSIX_VECTORS);
-	if (rc) {
+	/* Allocate explicitly LPFC_MSIX_VECTORS number of vectors */
+	min_cnt = LPFC_MSIX_VECTORS;
+	irq_flags = PCI_IRQ_MSIX;
+	vectors = pci_alloc_irq_vectors(phba->pcidev, min_cnt,
+					LPFC_MSIX_VECTORS, irq_flags);
+	if (vectors < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0420 PCI enable MSI-X failed (%d)\n", rc);
+				"0420 PCI enable MSI-X failed (%d)\n",
+				vectors);
+		rc = -1;
 		goto vec_fail_out;
 	}
+
+	/* Complete the MSIX vector setup. */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		phba->msix_entries[i].vector = pci_irq_vector(phba->pcidev, i);
+
 	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0477 MSI-X entry[%d]: vector=x%x "
@@ -8593,7 +8603,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 
 msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
-	pci_disable_msix(phba->pcidev);
+	pci_free_irq_vectors(phba->pcidev);
 
 vec_fail_out:
 	return rc;
@@ -8615,7 +8625,7 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
 	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
 		free_irq(phba->msix_entries[i].vector, phba);
 	/* Disable MSI-X */
-	pci_disable_msix(phba->pcidev);
+	pci_free_irq_vectors(phba->pcidev);
 
 	return;
 }
@@ -8625,10 +8635,10 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-3 interface spec. The kernel function pci_enable_msi() is called to
- * enable the MSI vector. The device driver is responsible for calling the
- * request_irq() to register MSI vector with a interrupt the handler, which
- * is done in this function.
+ * SLI-3 interface spec. The kernel function pci_alloc_irq_vectors() is
+ * called to enable the MSI vector. The device driver is responsible for
+ * calling the request_irq() to register MSI vector with a interrupt the
+ * handler, which is done in this function.
  *
  * Return codes
  * 	0 - successful
@@ -8637,10 +8647,18 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
 static int
 lpfc_sli_enable_msi(struct lpfc_hba *phba)
 {
-	int rc;
+	int vector, rc;
+	unsigned int irq_flags;
+
+	/* The adapter supports all these modes and wants the irq affinity.
+	 * The kernel documents MSIX first, then MSI and then IRQ.  No
+	 * need for failover code.
+	 */
+	irq_flags = PCI_IRQ_MSI;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
+	/* Only 1 vector. */
+	rc = pci_alloc_irq_vectors(phba->pcidev, 1, 1, irq_flags);
+	if (rc == 1)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0462 PCI enable MSI mode success.\n");
 	else {
@@ -8649,10 +8667,11 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 		return rc;
 	}
 
-	rc = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
+	vector = pci_irq_vector(phba->pcidev, 0);
+	rc = request_irq(vector, lpfc_sli_intr_handler,
 			 0, LPFC_DRIVER_NAME, phba);
 	if (rc) {
-		pci_disable_msi(phba->pcidev);
+		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0478 MSI request_irq failed (%d)\n", rc);
 	}
@@ -8665,15 +8684,18 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
  *
  * This routine is invoked to disable the MSI interrupt mode to device with
  * SLI-3 interface spec. The driver calls free_irq() on MSI vector it has
- * done request_irq() on before calling pci_disable_msi(). Failure to do so
- * results in a BUG_ON() and a device will be left with MSI enabled and leaks
- * its vector.
+ * done request_irq() on before calling pci_free_irq_vectors(). Failure to
+ * do so results in a BUG_ON() and a device will be left with MSI enabled
+ * and leaks its vector.
  */
 static void
 lpfc_sli_disable_msi(struct lpfc_hba *phba)
 {
-	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
+	int vector;
+
+	vector = pci_irq_vector(phba->pcidev, 0);
+	free_irq(vector, phba);
+	pci_free_irq_vectors(phba->pcidev);
 	return;
 }
 
@@ -8697,7 +8719,7 @@ static uint32_t
 lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 {
 	uint32_t intr_mode = LPFC_INTR_ERROR;
-	int retval;
+	int retval, vector;
 
 	if (cfg_mode == 2) {
 		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
@@ -8725,7 +8747,24 @@ lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 
 	/* Fallback to INTx if both MSI-X/MSI initalization failed */
 	if (phba->intr_type == NONE) {
-		retval = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
+
+		/* Only 1 vector. */
+		retval = pci_alloc_irq_vectors(phba->pcidev, 1, 1,
+						PCI_IRQ_LEGACY);
+		if (retval < 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6313 Failed to Alloc INTX Vector "
+					"(%d)\n", retval);
+		}
+
+		vector = pci_irq_vector(phba->pcidev, 0);
+		if (vector < 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9998 Failed to Get INTX Vector "
+					"Number (%d)\n", vector);
+		}
+
+		retval = request_irq(vector, lpfc_sli4_intr_handler,
 				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
 		if (!retval) {
 			/* Indicate initialization to INTx mode */
@@ -8748,13 +8787,18 @@ lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 static void
 lpfc_sli_disable_intr(struct lpfc_hba *phba)
 {
+	int vector;
+
 	/* Disable the currently initialized interrupt mode */
 	if (phba->intr_type == MSIX)
 		lpfc_sli_disable_msix(phba);
 	else if (phba->intr_type == MSI)
 		lpfc_sli_disable_msi(phba);
-	else if (phba->intr_type == INTx)
-		free_irq(phba->pcidev->irq, phba);
+	else if (phba->intr_type == INTx) {
+		vector = pci_irq_vector(phba->pcidev, 0);
+		free_irq(vector, phba);
+		pci_free_irq_vectors(phba->pcidev);
+	}
 
 	/* Reset interrupt management states */
 	phba->intr_type = NONE;
@@ -9048,14 +9092,14 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
+ * with SLI-4 interface spec. The kernel function pci_alloc_irq_vectors()
  * is called to enable the MSI-X vectors. The device driver is responsible
  * for calling the individual request_irq() to register each MSI-X vector
  * with a interrupt handler, which is done in this function. Note that
  * later when device is unloading, the driver should always call free_irq()
  * on all MSI-X vectors it has done request_irq() on before calling
- * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
- * will be left with MSI-X enabled and leaks its vectors.
+ * pci_free_irq_vectors(). Failure to do so results in a BUG_ON() and
+ * a device will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
  * 0 - successful
@@ -9065,6 +9109,8 @@ static int
 lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
 	int vectors, rc, index;
+	unsigned int irq_flags;
+	uint32_t min_cnt;
 
 	/* Set up MSI-X multi-message vectors */
 	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
@@ -9076,14 +9122,28 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		phba->sli4_hba.msix_entries[index].entry = index;
 		vectors++;
 	}
-	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
-				   2, vectors);
-	if (rc < 0) {
+
+	/* Need a vector for slow-path and fast-path minimally.  But for target
+	 * mode, the min is just one to service a single RQ.
+	 */
+	min_cnt = 2;
+	irq_flags = PCI_IRQ_MSIX | PCI_IRQ_AFFINITY;
+	vectors = pci_alloc_irq_vectors(phba->pcidev, min_cnt, vectors,
+					irq_flags);
+	if (vectors < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0484 PCI enable MSI-X failed (%d)\n", rc);
+				"0484 PCI enable MSI-X failed (%d) min 2 "
+				"max %d\n",
+				vectors, phba->cfg_fcp_io_channel);
+		rc = -1;
 		goto vec_fail_out;
 	}
-	vectors = rc;
+
+	/* Complete the MSIX vector setup. */
+	for (index = 0; index < vectors; index++) {
+		phba->sli4_hba.msix_entries[index].vector =
+			pci_irq_vector(phba->pcidev, index);
+	}
 
 	/* Log MSI-X vector assignment */
 	for (index = 0; index < vectors; index++)
@@ -9141,14 +9201,10 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 cfg_fail_out:
 	/* free the irq already requested */
 	for (--index; index >= 0; index--) {
-		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
-					  vector, NULL);
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
 	}
-
-	/* Unconfigure MSI-X capability structure */
-	pci_disable_msix(phba->pcidev);
+	pci_free_irq_vectors(phba->pcidev);
 
 vec_fail_out:
 	return rc;
@@ -9168,8 +9224,6 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
 
 	/* Free up MSI-X multi-message vectors */
 	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
-					  vector, NULL);
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
 	}
@@ -9177,9 +9231,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
 	}
-	/* Disable MSI-X */
-	pci_disable_msix(phba->pcidev);
-
+	pci_free_irq_vectors(phba->pcidev);
 	return;
 }
 
@@ -9188,7 +9240,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-4 interface spec. The kernel function pci_enable_msi() is called
+ * SLI-4 interface spec. The kernel function pci_alloc_irq_vectors() is called
  * to enable the MSI vector. The device driver is responsible for calling
  * the request_irq() to register MSI vector with a interrupt the handler,
  * which is done in this function.
@@ -9200,10 +9252,18 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
 static int
 lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 {
-	int rc, index;
+	int rc, index, vector;
+	unsigned int irq_flags;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
+	/* The adapter supports all these modes and wants the irq affinity.
+	 * The kernel documents MSIX first, then MSI and then IRQ.  No
+	 * need for failover code.
+	 */
+	irq_flags = PCI_IRQ_MSI | PCI_IRQ_AFFINITY;
+
+	/* Only 1 vector. */
+	rc = pci_alloc_irq_vectors(phba->pcidev, 1, 1, irq_flags);
+	if (rc == 1)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0487 PCI enable MSI mode success.\n");
 	else {
@@ -9212,10 +9272,11 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 		return rc;
 	}
 
-	rc = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
+	vector = pci_irq_vector(phba->pcidev, 0);
+	rc = request_irq(vector, lpfc_sli4_intr_handler,
 			 0, LPFC_DRIVER_NAME, phba);
 	if (rc) {
-		pci_disable_msi(phba->pcidev);
+		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0490 MSI request_irq failed (%d)\n", rc);
 		return rc;
@@ -9239,15 +9300,18 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
  *
  * This routine is invoked to disable the MSI interrupt mode to device with
  * SLI-4 interface spec. The driver calls free_irq() on MSI vector it has
- * done request_irq() on before calling pci_disable_msi(). Failure to do so
- * results in a BUG_ON() and a device will be left with MSI enabled and leaks
- * its vector.
+ * done request_irq() on before calling pci_free_irq_vectors(). Failure to
+ * do so results in a BUG_ON() and a device will be left with MSI enabled
+ * and leaks its vector.
  **/
 static void
 lpfc_sli4_disable_msi(struct lpfc_hba *phba)
 {
-	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
+	int vector;
+
+	vector = pci_irq_vector(phba->pcidev, 0);
+	free_irq(vector, phba);
+	pci_free_irq_vectors(phba->pcidev);
 	return;
 }
 
@@ -9271,19 +9335,15 @@ static uint32_t
 lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 {
 	uint32_t intr_mode = LPFC_INTR_ERROR;
-	int retval, index;
+	int retval, index, vector;
 
 	if (cfg_mode == 2) {
-		/* Preparation before conf_msi mbox cmd */
-		retval = 0;
+		/* Now, try to enable MSI-X interrupt mode */
+		retval = lpfc_sli4_enable_msix(phba);
 		if (!retval) {
-			/* Now, try to enable MSI-X interrupt mode */
-			retval = lpfc_sli4_enable_msix(phba);
-			if (!retval) {
-				/* Indicate initialization to MSI-X mode */
-				phba->intr_type = MSIX;
-				intr_mode = 2;
-			}
+			/* Indicate initialization to MSI-X mode */
+			phba->intr_type = MSIX;
+			intr_mode = 2;
 		}
 	}
 
@@ -9299,7 +9359,23 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 
 	/* Fallback to INTx if both MSI-X/MSI initalization failed */
 	if (phba->intr_type == NONE) {
-		retval = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
+		/* Only 1 vector. */
+		retval = pci_alloc_irq_vectors(phba->pcidev, 1, 1,
+						PCI_IRQ_LEGACY);
+		if (retval < 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6313 Failed to Alloc INTX Vector "
+					"(%d)\n", retval);
+		}
+
+		vector = pci_irq_vector(phba->pcidev, 0);
+		if (vector < 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9998 Failed to Get INTX Vector "
+					"Number (%d)\n", vector);
+		}
+
+		retval = request_irq(vector, lpfc_sli4_intr_handler,
 				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
 		if (!retval) {
 			/* Indicate initialization to INTx mode */
@@ -9335,13 +9411,18 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 static void
 lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 {
+	int vector;
+
 	/* Disable the currently initialized interrupt mode */
 	if (phba->intr_type == MSIX)
 		lpfc_sli4_disable_msix(phba);
 	else if (phba->intr_type == MSI)
 		lpfc_sli4_disable_msi(phba);
-	else if (phba->intr_type == INTx)
-		free_irq(phba->pcidev->irq, phba);
+	else if (phba->intr_type == INTx) {
+		vector = pci_irq_vector(phba->pcidev, 0);
+		free_irq(vector, phba);
+		pci_free_irq_vectors(phba->pcidev);
+	}
 
 	/* Reset interrupt management states */
 	phba->intr_type = NONE;
-- 
2.5.0

