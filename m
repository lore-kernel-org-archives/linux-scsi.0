From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 02/16] lpfc: use pci_irq_alloc_vectors and
 pci_irq_free_vectors
Date: Sun, 12 Feb 2017 13:52:26 -0800
Message-ID: <58a0d91a.9n5crfX+63xwYfdj%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33336 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdBLVwa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:30 -0500
Received: by mail-ot0-f195.google.com with SMTP id f9so9225001otd.0
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


From: Christoph Hellwig <hch@lst.de>

This avoids having to store the msix_entries array and simpliefies the
shutdown and cleanup path a lot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc.h      |   2 -
 drivers/scsi/lpfc/lpfc_init.c | 240 ++++++++++--------------------------------
 drivers/scsi/lpfc/lpfc_sli4.h |   1 -
 3 files changed, 54 insertions(+), 189 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 6593b07..64022d7 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -878,8 +878,6 @@ struct lpfc_hba {
 	enum intr_type_t intr_type;
 	uint32_t intr_mode;
 #define LPFC_INTR_ERROR	0xFFFFFFFF
-	struct msix_entry msix_entries[LPFC_MSIX_VECTORS];
-
 	struct list_head port_list;
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
 	uint16_t max_vpi;		/* Maximum virtual nports */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4776fd8..c4e8fad 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5510,17 +5510,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_fcf_rr_bmask;
 	}
 
-	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
-				  (fof_vectors +
-				   phba->cfg_fcp_io_channel)), GFP_KERNEL);
-	if (!phba->sli4_hba.msix_entries) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2573 Failed allocate memory for msi-x "
-				"interrupt vector entries\n");
-		rc = -ENOMEM;
-		goto out_free_fcp_eq_hdl;
-	}
-
 	phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
 					 phba->sli4_hba.num_present_cpu),
 					 GFP_KERNEL);
@@ -5529,7 +5518,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 				"3327 Failed allocate memory for msi-x "
 				"interrupt vector mapping\n");
 		rc = -ENOMEM;
-		goto out_free_msix;
+		goto out_free_fcp_eq_hdl;
 	}
 	if (lpfc_used_cpu == NULL) {
 		lpfc_used_cpu = kzalloc((sizeof(uint16_t) * lpfc_present_cpu),
@@ -5540,7 +5529,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					"interrupt vector mapping\n");
 			kfree(phba->sli4_hba.cpu_map);
 			rc = -ENOMEM;
-			goto out_free_msix;
+			goto out_free_fcp_eq_hdl;
 		}
 		for (i = 0; i < lpfc_present_cpu; i++)
 			lpfc_used_cpu[i] = LPFC_VECTOR_MAP_EMPTY;
@@ -5575,8 +5564,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	return 0;
 
-out_free_msix:
-	kfree(phba->sli4_hba.msix_entries);
 out_free_fcp_eq_hdl:
 	kfree(phba->sli4_hba.fcp_eq_hdl);
 out_free_fcf_rr_bmask:
@@ -5612,9 +5599,6 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 	phba->sli4_hba.num_online_cpu = 0;
 	phba->sli4_hba.curr_disp_cpu = 0;
 
-	/* Free memory allocated for msi-x interrupt vector entries */
-	kfree(phba->sli4_hba.msix_entries);
-
 	/* Free memory allocated for fast-path work queue handles */
 	kfree(phba->sli4_hba.fcp_eq_hdl);
 
@@ -8485,16 +8469,7 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-3 interface specs. The kernel function pci_enable_msix_exact()
- * is called to enable the MSI-X vectors. Note that pci_enable_msix_exact(),
- * once invoked, enables either all or nothing, depending on the current
- * availability of PCI vector resources. The device driver is responsible
- * for calling the individual request_irq() to register each MSI-X vector
- * with a interrupt handler, which is done in this function. Note that
- * later when device is unloading, the driver should always call free_irq()
- * on all MSI-X vectors it has done request_irq() on before calling
- * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
- * will be left with MSI-X enabled and leaks its vectors.
+ * with SLI-3 interface specs.
  *
  * Return codes
  *   0 - successful
@@ -8503,33 +8478,24 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 static int
 lpfc_sli_enable_msix(struct lpfc_hba *phba)
 {
-	int rc, i;
+	int rc;
 	LPFC_MBOXQ_t *pmb;
 
 	/* Set up MSI-X multi-message vectors */
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		phba->msix_entries[i].entry = i;
-
-	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
-				   LPFC_MSIX_VECTORS);
-	if (rc) {
+	rc = pci_alloc_irq_vectors(phba->pcidev,
+			LPFC_MSIX_VECTORS, LPFC_MSIX_VECTORS, PCI_IRQ_MSIX);
+	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
 		goto vec_fail_out;
 	}
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0477 MSI-X entry[%d]: vector=x%x "
-				"message=%d\n", i,
-				phba->msix_entries[i].vector,
-				phba->msix_entries[i].entry);
+
 	/*
 	 * Assign MSI-X vectors to interrupt handlers
 	 */
 
 	/* vector-0 is associated to slow-path handler */
-	rc = request_irq(phba->msix_entries[0].vector,
+	rc = request_irq(pci_irq_vector(phba->pcidev, 0),
 			 &lpfc_sli_sp_intr_handler, 0,
 			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
 	if (rc) {
@@ -8540,7 +8506,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 	}
 
 	/* vector-1 is associated to fast-path handler */
-	rc = request_irq(phba->msix_entries[1].vector,
+	rc = request_irq(pci_irq_vector(phba->pcidev, 1),
 			 &lpfc_sli_fp_intr_handler, 0,
 			 LPFC_FP_DRIVER_HANDLER_NAME, phba);
 
@@ -8585,42 +8551,21 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 
 mem_fail_out:
 	/* free the irq already requested */
-	free_irq(phba->msix_entries[1].vector, phba);
+	free_irq(pci_irq_vector(phba->pcidev, 1), phba);
 
 irq_fail_out:
 	/* free the irq already requested */
-	free_irq(phba->msix_entries[0].vector, phba);
+	free_irq(pci_irq_vector(phba->pcidev, 0), phba);
 
 msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
-	pci_disable_msix(phba->pcidev);
+	pci_free_irq_vectors(phba->pcidev);
 
 vec_fail_out:
 	return rc;
 }
 
 /**
- * lpfc_sli_disable_msix - Disable MSI-X interrupt mode on SLI-3 device.
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to release the MSI-X vectors and then disable the
- * MSI-X interrupt mode to device with SLI-3 interface spec.
- **/
-static void
-lpfc_sli_disable_msix(struct lpfc_hba *phba)
-{
-	int i;
-
-	/* Free up MSI-X multi-message vectors */
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		free_irq(phba->msix_entries[i].vector, phba);
-	/* Disable MSI-X */
-	pci_disable_msix(phba->pcidev);
-
-	return;
-}
-
-/**
  * lpfc_sli_enable_msi - Enable MSI interrupt mode on SLI-3 device.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -8660,24 +8605,6 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_disable_msi - Disable MSI interrupt mode to SLI-3 device.
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to disable the MSI interrupt mode to device with
- * SLI-3 interface spec. The driver calls free_irq() on MSI vector it has
- * done request_irq() on before calling pci_disable_msi(). Failure to do so
- * results in a BUG_ON() and a device will be left with MSI enabled and leaks
- * its vector.
- */
-static void
-lpfc_sli_disable_msi(struct lpfc_hba *phba)
-{
-	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
-	return;
-}
-
-/**
  * lpfc_sli_enable_intr - Enable device interrupt to SLI-3 device.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -8748,19 +8675,20 @@ lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 static void
 lpfc_sli_disable_intr(struct lpfc_hba *phba)
 {
-	/* Disable the currently initialized interrupt mode */
+	int nr_irqs, i;
+
 	if (phba->intr_type == MSIX)
-		lpfc_sli_disable_msix(phba);
-	else if (phba->intr_type == MSI)
-		lpfc_sli_disable_msi(phba);
-	else if (phba->intr_type == INTx)
-		free_irq(phba->pcidev->irq, phba);
+		nr_irqs = LPFC_MSIX_VECTORS;
+	else
+		nr_irqs = 1;
+
+	for (i = 0; i < nr_irqs; i++)
+		free_irq(pci_irq_vector(phba->pcidev, i), phba);
+	pci_free_irq_vectors(phba->pcidev);
 
 	/* Reset interrupt management states */
 	phba->intr_type = NONE;
 	phba->sli.slistat.sli_intr = 0;
-
-	return;
 }
 
 /**
@@ -8916,7 +8844,7 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 			lpfc_used_cpu[cpu] = phys_id;
 
 		/* Associate vector with selected CPU */
-		cpup->irq = phba->sli4_hba.msix_entries[idx].vector;
+		cpup->irq = pci_irq_vector(phba->pcidev, idx);
 
 		/* Associate IO channel with selected CPU */
 		cpup->channel_id = idx;
@@ -8926,14 +8854,14 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 			first_cpu = cpu;
 
 		/* Now affinitize to the selected CPU */
-		i = irq_set_affinity_hint(phba->sli4_hba.msix_entries[idx].
-					  vector, get_cpu_mask(cpu));
+		i = irq_set_affinity_hint(pci_irq_vector(phba->pcidev, idx),
+					  get_cpu_mask(cpu));
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"3330 Set Affinity: CPU %d channel %d "
 				"irq %d (%x)\n",
 				cpu, cpup->channel_id,
-				phba->sli4_hba.msix_entries[idx].vector, i);
+				pci_irq_vector(phba->pcidev, idx), i);
 
 		/* Spread vector mapping across multple physical CPU nodes */
 		phys_id++;
@@ -9048,14 +8976,7 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
- * is called to enable the MSI-X vectors. The device driver is responsible
- * for calling the individual request_irq() to register each MSI-X vector
- * with a interrupt handler, which is done in this function. Note that
- * later when device is unloading, the driver should always call free_irq()
- * on all MSI-X vectors it has done request_irq() on before calling
- * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
- * will be left with MSI-X enabled and leaks its vectors.
+ * with SLI-4 interface spec.
  *
  * Return codes
  * 0 - successful
@@ -9067,17 +8988,11 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	int vectors, rc, index;
 
 	/* Set up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
-		phba->sli4_hba.msix_entries[index].entry = index;
-
-	/* Configure MSI-X capability structure */
 	vectors = phba->cfg_fcp_io_channel;
-	if (phba->cfg_fof) {
-		phba->sli4_hba.msix_entries[index].entry = index;
+	if (phba->cfg_fof)
 		vectors++;
-	}
-	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
-				   2, vectors);
+
+	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors, PCI_IRQ_MSIX);
 	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
@@ -9085,14 +9000,6 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	}
 	vectors = rc;
 
-	/* Log MSI-X vector assignment */
-	for (index = 0; index < vectors; index++)
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0489 MSI-X entry[%d]: vector=x%x "
-				"message=%d\n", index,
-				phba->sli4_hba.msix_entries[index].vector,
-				phba->sli4_hba.msix_entries[index].entry);
-
 	/* Assign MSI-X vectors to interrupt handlers */
 	for (index = 0; index < vectors; index++) {
 		memset(&phba->sli4_hba.handler_name[index], 0, 16);
@@ -9104,14 +9011,12 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
 		atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].fcp_eq_in_use, 1);
 		if (phba->cfg_fof && (index == (vectors - 1)))
-			rc = request_irq(
-				phba->sli4_hba.msix_entries[index].vector,
+			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_fof_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
 				 &phba->sli4_hba.fcp_eq_hdl[index]);
 		else
-			rc = request_irq(
-				phba->sli4_hba.msix_entries[index].vector,
+			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_hba_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
 				 &phba->sli4_hba.fcp_eq_hdl[index]);
@@ -9141,49 +9046,20 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 cfg_fail_out:
 	/* free the irq already requested */
 	for (--index; index >= 0; index--) {
-		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
-					  vector, NULL);
-		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+		int irq = pci_irq_vector(phba->pcidev, index);
+
+		irq_set_affinity_hint(irq, NULL);
+		free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
 	}
 
 	/* Unconfigure MSI-X capability structure */
-	pci_disable_msix(phba->pcidev);
+	pci_free_irq_vectors(phba->pcidev);
 
 vec_fail_out:
 	return rc;
 }
 
 /**
- * lpfc_sli4_disable_msix - Disable MSI-X interrupt mode to SLI-4 device
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to release the MSI-X vectors and then disable the
- * MSI-X interrupt mode to device with SLI-4 interface spec.
- **/
-static void
-lpfc_sli4_disable_msix(struct lpfc_hba *phba)
-{
-	int index;
-
-	/* Free up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
-					  vector, NULL);
-		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
-	}
-	if (phba->cfg_fof) {
-		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
-	}
-	/* Disable MSI-X */
-	pci_disable_msix(phba->pcidev);
-
-	return;
-}
-
-/**
  * lpfc_sli4_enable_msi - Enable MSI interrupt mode to SLI-4 device
  * @phba: pointer to lpfc hba data structure.
  *
@@ -9234,24 +9110,6 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_disable_msi - Disable MSI interrupt mode to SLI-4 device
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to disable the MSI interrupt mode to device with
- * SLI-4 interface spec. The driver calls free_irq() on MSI vector it has
- * done request_irq() on before calling pci_disable_msi(). Failure to do so
- * results in a BUG_ON() and a device will be left with MSI enabled and leaks
- * its vector.
- **/
-static void
-lpfc_sli4_disable_msi(struct lpfc_hba *phba)
-{
-	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
-	return;
-}
-
-/**
  * lpfc_sli4_enable_intr - Enable device interrupt to SLI-4 device
  * @phba: pointer to lpfc hba data structure.
  *
@@ -9336,18 +9194,28 @@ static void
 lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 {
 	/* Disable the currently initialized interrupt mode */
-	if (phba->intr_type == MSIX)
-		lpfc_sli4_disable_msix(phba);
-	else if (phba->intr_type == MSI)
-		lpfc_sli4_disable_msi(phba);
-	else if (phba->intr_type == INTx)
+	if (phba->intr_type == MSIX) {
+		int index;
+
+		/* Free up MSI-X multi-message vectors */
+		for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
+			int irq = pci_irq_vector(phba->pcidev, index);
+
+			irq_set_affinity_hint(irq, NULL);
+			free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
+		}
+
+		if (phba->cfg_fof)
+			free_irq(pci_irq_vector(phba->pcidev, index), phba);
+	} else {
 		free_irq(phba->pcidev->irq, phba);
+	}
+
+	pci_free_irq_vectors(phba->pcidev);
 
 	/* Reset interrupt management states */
 	phba->intr_type = NONE;
 	phba->sli.slistat.sli_intr = 0;
-
-	return;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 0b88b570..dfbb25e 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -515,7 +515,6 @@ struct lpfc_sli4_hba {
 	uint32_t ue_to_rp;
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
-	struct msix_entry *msix_entries;
 	uint8_t handler_name[LPFC_SLI4_HANDLER_CNT][LPFC_SLI4_HANDLER_NAME_SZ];
 	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
 
-- 
2.5.0
