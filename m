From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/17] lpfc 8.3.2 : Addition of SLI4 Interface - Base
	Support - Part 5 of 6
Date: Fri, 22 May 2009 14:52:19 -0400
Message-ID: <1243018339.7729.53.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42069 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbZEVSwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:22 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIqNaS029792
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Base Support - Part 5 of 6

Adds new hardware and interface definitions.

Adds new interface routines - utilizing the reorganized layout of the
driver. Adds SLI-4 specific functions for attachment, initialization,
teardown, etc.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c | 2879 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 2647 insertions(+), 232 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:16:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:17:16.000000000 -0400
@@ -4454,340 +4454,2755 @@ lpfc_sli_pci_mem_unset(struct lpfc_hba *
 }
 
 /**
- * lpfc_sli_enable_msix - Enable MSI-X interrupt mode on SLI-3 device
+ * lpfc_sli4_post_status_check - Wait for SLI4 POST done and check status
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-3 interface specs. The kernel function pci_enable_msix() is
- * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
- * invoked, enables either all or nothing, depending on the current
- * availability of PCI vector resources. The device driver is responsible
- * for calling the individual request_irq() to register each MSI-X vector
- * with a interrupt handler, which is done in this function. Note that
- * later when device is unloading, the driver should always call free_irq()
- * on all MSI-X vectors it has done request_irq() on before calling
- * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
- * will be left with MSI-X enabled and leaks its vectors.
+ * This routine is invoked to wait for SLI4 device Power On Self Test (POST)
+ * done and check status.
  *
- * Return codes
- *   0 - sucessful
- *   other values - error
+ * Return 0 if successful, otherwise -ENODEV.
  **/
-static int
-lpfc_sli_enable_msix(struct lpfc_hba *phba)
+int
+lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 {
-	int rc, i;
-	LPFC_MBOXQ_t *pmb;
-
-	/* Set up MSI-X multi-message vectors */
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		phba->msix_entries[i].entry = i;
+	struct lpfc_register sta_reg, uerrlo_reg, uerrhi_reg, scratchpad;
+	uint32_t onlnreg0, onlnreg1;
+	int i, port_error = -ENODEV;
 
-	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
-	if (rc) {
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0420 PCI enable MSI-X failed (%d)\n", rc);
-		goto msi_fail_out;
-	}
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0477 MSI-X entry[%d]: vector=x%x "
-				"message=%d\n", i,
-				phba->msix_entries[i].vector,
-				phba->msix_entries[i].entry);
-	/*
-	 * Assign MSI-X vectors to interrupt handlers
-	 */
+	if (!phba->sli4_hba.STAregaddr)
+		return -ENODEV;
 
-	/* vector-0 is associated to slow-path handler */
-	rc = request_irq(phba->msix_entries[0].vector,
-			 &lpfc_sli_sp_intr_handler, IRQF_SHARED,
-			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"0421 MSI-X slow-path request_irq failed "
-				"(%d)\n", rc);
-		goto msi_fail_out;
+	/* With uncoverable error, log the error message and return error */
+	onlnreg0 = readl(phba->sli4_hba.ONLINE0regaddr);
+	onlnreg1 = readl(phba->sli4_hba.ONLINE1regaddr);
+	if ((onlnreg0 != LPFC_ONLINE_NERR) || (onlnreg1 != LPFC_ONLINE_NERR)) {
+		uerrlo_reg.word0 = readl(phba->sli4_hba.UERRLOregaddr);
+		uerrhi_reg.word0 = readl(phba->sli4_hba.UERRHIregaddr);
+		if (uerrlo_reg.word0 || uerrhi_reg.word0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1422 HBA Unrecoverable error: "
+					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
+					"online0_reg=0x%x, online1_reg=0x%x\n",
+					uerrlo_reg.word0, uerrhi_reg.word0,
+					onlnreg0, onlnreg1);
+		}
+		return -ENODEV;
 	}
 
-	/* vector-1 is associated to fast-path handler */
-	rc = request_irq(phba->msix_entries[1].vector,
-			 &lpfc_sli_fp_intr_handler, IRQF_SHARED,
-			 LPFC_FP_DRIVER_HANDLER_NAME, phba);
-
-	if (rc) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"0429 MSI-X fast-path request_irq failed "
-				"(%d)\n", rc);
-		goto irq_fail_out;
+	/* Wait up to 30 seconds for the SLI Port POST done and ready */
+	for (i = 0; i < 3000; i++) {
+		sta_reg.word0 = readl(phba->sli4_hba.STAregaddr);
+		/* Encounter fatal POST error, break out */
+		if (bf_get(lpfc_hst_state_perr, &sta_reg)) {
+			port_error = -ENODEV;
+			break;
+		}
+		if (LPFC_POST_STAGE_ARMFW_READY ==
+		    bf_get(lpfc_hst_state_port_status, &sta_reg)) {
+			port_error = 0;
+			break;
+		}
+		msleep(10);
 	}
 
-	/*
-	 * Configure HBA MSI-X attention conditions to messages
-	 */
-	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-
-	if (!pmb) {
-		rc = -ENOMEM;
+	if (port_error)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0474 Unable to allocate memory for issuing "
-				"MBOX_CONFIG_MSI command\n");
-		goto mem_fail_out;
-	}
-	rc = lpfc_config_msi(phba, pmb);
-	if (rc)
-		goto mbx_fail_out;
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
-	if (rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
-				"0351 Config MSI mailbox command failed, "
-				"mbxCmd x%x, mbxStatus x%x\n",
-				pmb->u.mb.mbxCommand, pmb->u.mb.mbxStatus);
-		goto mbx_fail_out;
-	}
-
-	/* Free memory allocated for mailbox command */
-	mempool_free(pmb, phba->mbox_mem_pool);
-	return rc;
-
-mbx_fail_out:
-	/* Free memory allocated for mailbox command */
-	mempool_free(pmb, phba->mbox_mem_pool);
-
-mem_fail_out:
-	/* free the irq already requested */
-	free_irq(phba->msix_entries[1].vector, phba);
+			"1408 Failure HBA POST Status: sta_reg=0x%x, "
+			"perr=x%x, sfi=x%x, nip=x%x, ipc=x%x, xrom=x%x, "
+			"dl=x%x, pstatus=x%x\n", sta_reg.word0,
+			bf_get(lpfc_hst_state_perr, &sta_reg),
+			bf_get(lpfc_hst_state_sfi, &sta_reg),
+			bf_get(lpfc_hst_state_nip, &sta_reg),
+			bf_get(lpfc_hst_state_ipc, &sta_reg),
+			bf_get(lpfc_hst_state_xrom, &sta_reg),
+			bf_get(lpfc_hst_state_dl, &sta_reg),
+			bf_get(lpfc_hst_state_port_status, &sta_reg));
 
-irq_fail_out:
-	/* free the irq already requested */
-	free_irq(phba->msix_entries[0].vector, phba);
+	/* Log device information */
+	scratchpad.word0 =  readl(phba->sli4_hba.SCRATCHPADregaddr);
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2534 Device Info: ChipType=0x%x, SliRev=0x%x, "
+			"FeatureL1=0x%x, FeatureL2=0x%x\n",
+			bf_get(lpfc_scratchpad_chiptype, &scratchpad),
+			bf_get(lpfc_scratchpad_slirev, &scratchpad),
+			bf_get(lpfc_scratchpad_featurelevel1, &scratchpad),
+			bf_get(lpfc_scratchpad_featurelevel2, &scratchpad));
 
-msi_fail_out:
-	/* Unconfigure MSI-X capability structure */
-	pci_disable_msix(phba->pcidev);
-	return rc;
+	return port_error;
 }
 
 /**
- * lpfc_sli_disable_msix - Disable MSI-X interrupt mode on SLI-3 device.
+ * lpfc_sli4_bar0_register_memmap - Set up SLI4 BAR0 register memory map.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to release the MSI-X vectors and then disable the
- * MSI-X interrupt mode to device with SLI-3 interface spec.
+ * This routine is invoked to set up SLI4 BAR0 PCI config space register
+ * memory map.
  **/
 static void
-lpfc_sli_disable_msix(struct lpfc_hba *phba)
+lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba)
 {
-	int i;
+	phba->sli4_hba.UERRLOregaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_UERR_STATUS_LO;
+	phba->sli4_hba.UERRHIregaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_UERR_STATUS_HI;
+	phba->sli4_hba.ONLINE0regaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_ONLINE0;
+	phba->sli4_hba.ONLINE1regaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_ONLINE1;
+	phba->sli4_hba.SCRATCHPADregaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_SCRATCHPAD;
+}
 
-	/* Free up MSI-X multi-message vectors */
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		free_irq(phba->msix_entries[i].vector, phba);
-	/* Disable MSI-X */
-	pci_disable_msix(phba->pcidev);
+/**
+ * lpfc_sli4_bar1_register_memmap - Set up SLI4 BAR1 register memory map.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up SLI4 BAR1 control status register (CSR)
+ * memory map.
+ **/
+static void
+lpfc_sli4_bar1_register_memmap(struct lpfc_hba *phba)
+{
 
+	phba->sli4_hba.STAregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+				    LPFC_HST_STATE;
+	phba->sli4_hba.ISRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+				    LPFC_HST_ISR0;
+	phba->sli4_hba.IMRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+				    LPFC_HST_IMR0;
+	phba->sli4_hba.ISCRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+				     LPFC_HST_ISCR0;
 	return;
 }
 
 /**
- * lpfc_sli_enable_msi - Enable MSI interrupt mode on SLI-3 device.
+ * lpfc_sli4_bar2_register_memmap - Set up SLI4 BAR2 register memory map.
  * @phba: pointer to lpfc hba data structure.
+ * @vf: virtual function number
  *
- * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-3 interface spec. The kernel function pci_enable_msi() is called to
- * enable the MSI vector. The device driver is responsible for calling the
- * request_irq() to register MSI vector with a interrupt the handler, which
- * is done in this function.
+ * This routine is invoked to set up SLI4 BAR2 doorbell register memory map
+ * based on the given viftual function number, @vf.
+ *
+ * Return 0 if successful, otherwise -ENODEV.
+ **/
+static int
+lpfc_sli4_bar2_register_memmap(struct lpfc_hba *phba, uint32_t vf)
+{
+	if (vf > LPFC_VIR_FUNC_MAX)
+		return -ENODEV;
+
+	phba->sli4_hba.RQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE + LPFC_RQ_DOORBELL);
+	phba->sli4_hba.WQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE + LPFC_WQ_DOORBELL);
+	phba->sli4_hba.EQCQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE + LPFC_EQCQ_DOORBELL);
+	phba->sli4_hba.MQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE + LPFC_MQ_DOORBELL);
+	phba->sli4_hba.BMBXregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE + LPFC_BMBX);
+	return 0;
+}
+
+/**
+ * lpfc_create_bootstrap_mbox - Create the bootstrap mailbox
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to create the bootstrap mailbox
+ * region consistent with the SLI-4 interface spec.  This
+ * routine allocates all memory necessary to communicate
+ * mailbox commands to the port and sets up all alignment
+ * needs.  No locks are expected to be held when calling
+ * this routine.
  *
  * Return codes
  * 	0 - sucessful
- * 	other values - error
- */
+ * 	ENOMEM - could not allocated memory.
+ **/
 static int
-lpfc_sli_enable_msi(struct lpfc_hba *phba)
+lpfc_create_bootstrap_mbox(struct lpfc_hba *phba)
 {
-	int rc;
+	uint32_t bmbx_size;
+	struct lpfc_dmabuf *dmabuf;
+	struct dma_address *dma_address;
+	uint32_t pa_addr;
+	uint64_t phys_addr;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0462 PCI enable MSI mode success.\n");
-	else {
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0471 PCI enable MSI mode failed (%d)\n", rc);
-		return rc;
-	}
+	dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!dmabuf)
+		return -ENOMEM;
 
-	rc = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
-			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
-	if (rc) {
-		pci_disable_msi(phba->pcidev);
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"0478 MSI request_irq failed (%d)\n", rc);
+	/*
+	 * The bootstrap mailbox region is comprised of 2 parts
+	 * plus an alignment restriction of 16 bytes.
+	 */
+	bmbx_size = sizeof(struct lpfc_bmbx_create) + (LPFC_ALIGN_16_BYTE - 1);
+	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
+					  bmbx_size,
+					  &dmabuf->phys,
+					  GFP_KERNEL);
+	if (!dmabuf->virt) {
+		kfree(dmabuf);
+		return -ENOMEM;
 	}
-	return rc;
+	memset(dmabuf->virt, 0, bmbx_size);
+
+	/*
+	 * Initialize the bootstrap mailbox pointers now so that the register
+	 * operations are simple later.  The mailbox dma address is required
+	 * to be 16-byte aligned.  Also align the virtual memory as each
+	 * maibox is copied into the bmbx mailbox region before issuing the
+	 * command to the port.
+	 */
+	phba->sli4_hba.bmbx.dmabuf = dmabuf;
+	phba->sli4_hba.bmbx.bmbx_size = bmbx_size;
+
+	phba->sli4_hba.bmbx.avirt = PTR_ALIGN(dmabuf->virt,
+					      LPFC_ALIGN_16_BYTE);
+	phba->sli4_hba.bmbx.aphys = ALIGN(dmabuf->phys,
+					      LPFC_ALIGN_16_BYTE);
+
+	/*
+	 * Set the high and low physical addresses now.  The SLI4 alignment
+	 * requirement is 16 bytes and the mailbox is posted to the port
+	 * as two 30-bit addresses.  The other data is a bit marking whether
+	 * the 30-bit address is the high or low address.
+	 * Upcast bmbx aphys to 64bits so shift instruction compiles
+	 * clean on 32 bit machines.
+	 */
+	dma_address = &phba->sli4_hba.bmbx.dma_address;
+	phys_addr = (uint64_t)phba->sli4_hba.bmbx.aphys;
+	pa_addr = (uint32_t) ((phys_addr >> 34) & 0x3fffffff);
+	dma_address->addr_hi = (uint32_t) ((pa_addr << 2) |
+					   LPFC_BMBX_BIT1_ADDR_HI);
+
+	pa_addr = (uint32_t) ((phba->sli4_hba.bmbx.aphys >> 4) & 0x3fffffff);
+	dma_address->addr_lo = (uint32_t) ((pa_addr << 2) |
+					   LPFC_BMBX_BIT1_ADDR_LO);
+	return 0;
 }
 
 /**
- * lpfc_sli_disable_msi - Disable MSI interrupt mode to SLI-3 device.
+ * lpfc_destroy_bootstrap_mbox - Destroy all bootstrap mailbox resources
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to disable the MSI interrupt mode to device with
- * SLI-3 interface spec. The driver calls free_irq() on MSI vector it has
- * done request_irq() on before calling pci_disable_msi(). Failure to do so
- * results in a BUG_ON() and a device will be left with MSI enabled and leaks
- * its vector.
- */
+ * This routine is invoked to teardown the bootstrap mailbox
+ * region and release all host resources. This routine requires
+ * the caller to ensure all mailbox commands recovered, no
+ * additional mailbox comands are sent, and interrupts are disabled
+ * before calling this routine.
+ *
+ **/
 static void
-lpfc_sli_disable_msi(struct lpfc_hba *phba)
+lpfc_destroy_bootstrap_mbox(struct lpfc_hba *phba)
 {
-	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
-	return;
+	dma_free_coherent(&phba->pcidev->dev,
+			  phba->sli4_hba.bmbx.bmbx_size,
+			  phba->sli4_hba.bmbx.dmabuf->virt,
+			  phba->sli4_hba.bmbx.dmabuf->phys);
+
+	kfree(phba->sli4_hba.bmbx.dmabuf);
+	memset(&phba->sli4_hba.bmbx, 0, sizeof(struct lpfc_bmbx));
 }
 
 /**
- * lpfc_sli_enable_intr - Enable device interrupt to SLI-3 device.
+ * lpfc_sli4_read_config - Get the config parameters.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to enable device interrupt and associate driver's
- * interrupt handler(s) to interrupt vector(s) to device with SLI-3 interface
- * spec. Depends on the interrupt mode configured to the driver, the driver
- * will try to fallback from the configured interrupt mode to an interrupt
- * mode which is supported by the platform, kernel, and device in the order
- * of:
- * MSI-X -> MSI -> IRQ.
+ * This routine is invoked to read the configuration parameters from the HBA.
+ * The configuration parameters are used to set the base and maximum values
+ * for RPI's XRI's VPI's VFI's and FCFIs. These values also affect the resource
+ * allocation for the port.
  *
  * Return codes
- *   0 - sucessful
- *   other values - error
+ * 	0 - sucessful
+ * 	ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
  **/
-static uint32_t
-lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
+static int
+lpfc_sli4_read_config(struct lpfc_hba *phba)
 {
-	uint32_t intr_mode = LPFC_INTR_ERROR;
-	int retval;
+	LPFC_MBOXQ_t *pmb;
+	struct lpfc_mbx_read_config *rd_config;
+	uint32_t rc = 0;
 
-	if (cfg_mode == 2) {
-		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
-		retval = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
-		if (!retval) {
-			/* Now, try to enable MSI-X interrupt mode */
-			retval = lpfc_sli_enable_msix(phba);
-			if (!retval) {
-				/* Indicate initialization to MSI-X mode */
-				phba->intr_type = MSIX;
-				intr_mode = 2;
-			}
-		}
+	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2011 Unable to allocate memory for issuing "
+				"SLI_CONFIG_SPECIAL mailbox command\n");
+		return -ENOMEM;
 	}
 
-	/* Fallback to MSI if MSI-X initialization failed */
-	if (cfg_mode >= 1 && phba->intr_type == NONE) {
-		retval = lpfc_sli_enable_msi(phba);
-		if (!retval) {
-			/* Indicate initialization to MSI mode */
-			phba->intr_type = MSI;
-			intr_mode = 1;
-		}
-	}
+	lpfc_read_config(phba, pmb);
 
-	/* Fallback to INTx if both MSI-X/MSI initalization failed */
-	if (phba->intr_type == NONE) {
-		retval = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
-				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
-		if (!retval) {
-			/* Indicate initialization to INTx mode */
-			phba->intr_type = INTx;
-			intr_mode = 0;
-		}
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"2012 Mailbox failed , mbxCmd x%x "
+			"READ_CONFIG, mbxStatus x%x\n",
+			bf_get(lpfc_mqe_command, &pmb->u.mqe),
+			bf_get(lpfc_mqe_status, &pmb->u.mqe));
+		rc = -EIO;
+	} else {
+		rd_config = &pmb->u.mqe.un.rd_config;
+		phba->sli4_hba.max_cfg_param.max_xri =
+			bf_get(lpfc_mbx_rd_conf_xri_count, rd_config);
+		phba->sli4_hba.max_cfg_param.xri_base =
+			bf_get(lpfc_mbx_rd_conf_xri_base, rd_config);
+		phba->sli4_hba.max_cfg_param.max_vpi =
+			bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config);
+		phba->sli4_hba.max_cfg_param.vpi_base =
+			bf_get(lpfc_mbx_rd_conf_vpi_base, rd_config);
+		phba->sli4_hba.max_cfg_param.max_rpi =
+			bf_get(lpfc_mbx_rd_conf_rpi_count, rd_config);
+		phba->sli4_hba.max_cfg_param.rpi_base =
+			bf_get(lpfc_mbx_rd_conf_rpi_base, rd_config);
+		phba->sli4_hba.max_cfg_param.max_vfi =
+			bf_get(lpfc_mbx_rd_conf_vfi_count, rd_config);
+		phba->sli4_hba.max_cfg_param.vfi_base =
+			bf_get(lpfc_mbx_rd_conf_vfi_base, rd_config);
+		phba->sli4_hba.max_cfg_param.max_fcfi =
+			bf_get(lpfc_mbx_rd_conf_fcfi_count, rd_config);
+		phba->sli4_hba.max_cfg_param.fcfi_base =
+			bf_get(lpfc_mbx_rd_conf_fcfi_base, rd_config);
+		phba->sli4_hba.max_cfg_param.max_eq =
+			bf_get(lpfc_mbx_rd_conf_eq_count, rd_config);
+		phba->sli4_hba.max_cfg_param.max_rq =
+			bf_get(lpfc_mbx_rd_conf_rq_count, rd_config);
+		phba->sli4_hba.max_cfg_param.max_wq =
+			bf_get(lpfc_mbx_rd_conf_wq_count, rd_config);
+		phba->sli4_hba.max_cfg_param.max_cq =
+			bf_get(lpfc_mbx_rd_conf_cq_count, rd_config);
+		phba->lmt = bf_get(lpfc_mbx_rd_conf_lmt, rd_config);
+		phba->sli4_hba.next_xri = phba->sli4_hba.max_cfg_param.xri_base;
+		phba->vpi_base = phba->sli4_hba.max_cfg_param.vpi_base;
+		phba->vfi_base = phba->sli4_hba.max_cfg_param.vfi_base;
+		phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.rpi_base;
+		phba->max_vpi = phba->sli4_hba.max_cfg_param.max_vpi;
+		phba->max_vports = phba->max_vpi;
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"2003 cfg params XRI(B:%d M:%d), "
+				"VPI(B:%d M:%d) "
+				"VFI(B:%d M:%d) "
+				"RPI(B:%d M:%d) "
+				"FCFI(B:%d M:%d)\n",
+				phba->sli4_hba.max_cfg_param.xri_base,
+				phba->sli4_hba.max_cfg_param.max_xri,
+				phba->sli4_hba.max_cfg_param.vpi_base,
+				phba->sli4_hba.max_cfg_param.max_vpi,
+				phba->sli4_hba.max_cfg_param.vfi_base,
+				phba->sli4_hba.max_cfg_param.max_vfi,
+				phba->sli4_hba.max_cfg_param.rpi_base,
+				phba->sli4_hba.max_cfg_param.max_rpi,
+				phba->sli4_hba.max_cfg_param.fcfi_base,
+				phba->sli4_hba.max_cfg_param.max_fcfi);
 	}
-	return intr_mode;
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
+	if (phba->cfg_hba_queue_depth > (phba->sli4_hba.max_cfg_param.max_xri))
+		phba->cfg_hba_queue_depth =
+				phba->sli4_hba.max_cfg_param.max_xri;
+	return rc;
 }
 
 /**
- * lpfc_sli_disable_intr - Disable device interrupt to SLI-3 device.
+ * lpfc_dev_endian_order_setup - Notify the port of the host's endian order.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to disable device interrupt and disassociate the
- * driver's interrupt handler(s) from interrupt vector(s) to device with
- * SLI-3 interface spec. Depending on the interrupt mode, the driver will
- * release the interrupt vector(s) for the message signaled interrupt.
+ * This routine is invoked to setup the host-side endian order to the
+ * HBA consistent with the SLI-4 interface spec.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
  **/
-static void
+static int
+lpfc_setup_endian_order(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mboxq;
+	uint32_t rc = 0;
+	uint32_t endian_mb_data[2] = {HOST_ENDIAN_LOW_WORD0,
+				      HOST_ENDIAN_HIGH_WORD1};
+
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0492 Unable to allocate memory for issuing "
+				"SLI_CONFIG_SPECIAL mailbox command\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * The SLI4_CONFIG_SPECIAL mailbox command requires the first two
+	 * words to contain special data values and no other data.
+	 */
+	memset(mboxq, 0, sizeof(LPFC_MBOXQ_t));
+	memcpy(&mboxq->u.mqe, &endian_mb_data, sizeof(endian_mb_data));
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0493 SLI_CONFIG_SPECIAL mailbox failed with "
+				"status x%x\n",
+				rc);
+		rc = -EIO;
+	}
+
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_queue_create - Create all the SLI4 queues
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate all the SLI4 queues for the FCoE HBA
+ * operation. For each SLI4 queue type, the parameters such as queue entry
+ * count (queue depth) shall be taken from the module parameter. For now,
+ * we just use some constant number as place holder.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+static int
+lpfc_sli4_queue_create(struct lpfc_hba *phba)
+{
+	struct lpfc_queue *qdesc;
+	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
+	int cfg_fcp_wq_count;
+	int cfg_fcp_eq_count;
+
+	/*
+	 * Sanity check for confiugred queue parameters against the run-time
+	 * device parameters
+	 */
+
+	/* Sanity check on FCP fast-path WQ parameters */
+	cfg_fcp_wq_count = phba->cfg_fcp_wq_count;
+	if (cfg_fcp_wq_count >
+	    (phba->sli4_hba.max_cfg_param.max_wq - LPFC_SP_WQN_DEF)) {
+		cfg_fcp_wq_count = phba->sli4_hba.max_cfg_param.max_wq -
+				   LPFC_SP_WQN_DEF;
+		if (cfg_fcp_wq_count < LPFC_FP_WQN_MIN) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2581 Not enough WQs (%d) from "
+					"the pci function for supporting "
+					"FCP WQs (%d)\n",
+					phba->sli4_hba.max_cfg_param.max_wq,
+					phba->cfg_fcp_wq_count);
+			goto out_error;
+		}
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2582 Not enough WQs (%d) from the pci "
+				"function for supporting the requested "
+				"FCP WQs (%d), the actual FCP WQs can "
+				"be supported: %d\n",
+				phba->sli4_hba.max_cfg_param.max_wq,
+				phba->cfg_fcp_wq_count, cfg_fcp_wq_count);
+	}
+	/* The actual number of FCP work queues adopted */
+	phba->cfg_fcp_wq_count = cfg_fcp_wq_count;
+
+	/* Sanity check on FCP fast-path EQ parameters */
+	cfg_fcp_eq_count = phba->cfg_fcp_eq_count;
+	if (cfg_fcp_eq_count >
+	    (phba->sli4_hba.max_cfg_param.max_eq - LPFC_SP_EQN_DEF)) {
+		cfg_fcp_eq_count = phba->sli4_hba.max_cfg_param.max_eq -
+				   LPFC_SP_EQN_DEF;
+		if (cfg_fcp_eq_count < LPFC_FP_EQN_MIN) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2574 Not enough EQs (%d) from the "
+					"pci function for supporting FCP "
+					"EQs (%d)\n",
+					phba->sli4_hba.max_cfg_param.max_eq,
+					phba->cfg_fcp_eq_count);
+			goto out_error;
+		}
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2575 Not enough EQs (%d) from the pci "
+				"function for supporting the requested "
+				"FCP EQs (%d), the actual FCP EQs can "
+				"be supported: %d\n",
+				phba->sli4_hba.max_cfg_param.max_eq,
+				phba->cfg_fcp_eq_count, cfg_fcp_eq_count);
+	}
+	/* It does not make sense to have more EQs than WQs */
+	if (cfg_fcp_eq_count > phba->cfg_fcp_wq_count) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2593 The number of FCP EQs (%d) is more "
+				"than the number of FCP WQs (%d), take "
+				"the number of FCP EQs same as than of "
+				"WQs (%d)\n", cfg_fcp_eq_count,
+				phba->cfg_fcp_wq_count,
+				phba->cfg_fcp_wq_count);
+		cfg_fcp_eq_count = phba->cfg_fcp_wq_count;
+	}
+	/* The actual number of FCP event queues adopted */
+	phba->cfg_fcp_eq_count = cfg_fcp_eq_count;
+	/* The overall number of event queues used */
+	phba->sli4_hba.cfg_eqn = phba->cfg_fcp_eq_count + LPFC_SP_EQN_DEF;
+
+	/*
+	 * Create Event Queues (EQs)
+	 */
+
+	/* Get EQ depth from module parameter, fake the default for now */
+	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
+	phba->sli4_hba.eq_ecount = LPFC_EQE_DEF_COUNT;
+
+	/* Create slow path event queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
+				      phba->sli4_hba.eq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0496 Failed allocate slow-path EQ\n");
+		goto out_error;
+	}
+	phba->sli4_hba.sp_eq = qdesc;
+
+	/* Create fast-path FCP Event Queue(s) */
+	phba->sli4_hba.fp_eq = kzalloc((sizeof(struct lpfc_queue *) *
+			       phba->cfg_fcp_eq_count), GFP_KERNEL);
+	if (!phba->sli4_hba.fp_eq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2576 Failed allocate memory for fast-path "
+				"EQ record array\n");
+		goto out_free_sp_eq;
+	}
+	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++) {
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
+					      phba->sli4_hba.eq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0497 Failed allocate fast-path EQ\n");
+			goto out_free_fp_eq;
+		}
+		phba->sli4_hba.fp_eq[fcp_eqidx] = qdesc;
+	}
+
+	/*
+	 * Create Complete Queues (CQs)
+	 */
+
+	/* Get CQ depth from module parameter, fake the default for now */
+	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
+	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
+
+	/* Create slow-path Mailbox Command Complete Queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+				      phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0500 Failed allocate slow-path mailbox CQ\n");
+		goto out_free_fp_eq;
+	}
+	phba->sli4_hba.mbx_cq = qdesc;
+
+	/* Create slow-path ELS Complete Queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+				      phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0501 Failed allocate slow-path ELS CQ\n");
+		goto out_free_mbx_cq;
+	}
+	phba->sli4_hba.els_cq = qdesc;
+
+	/* Create slow-path Unsolicited Receive Complete Queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+				      phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0502 Failed allocate slow-path USOL RX CQ\n");
+		goto out_free_els_cq;
+	}
+	phba->sli4_hba.rxq_cq = qdesc;
+
+	/* Create fast-path FCP Completion Queue(s), one-to-one with EQs */
+	phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
+				phba->cfg_fcp_eq_count), GFP_KERNEL);
+	if (!phba->sli4_hba.fcp_cq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2577 Failed allocate memory for fast-path "
+				"CQ record array\n");
+		goto out_free_rxq_cq;
+	}
+	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++) {
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					      phba->sli4_hba.cq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0499 Failed allocate fast-path FCP "
+					"CQ (%d)\n", fcp_cqidx);
+			goto out_free_fcp_cq;
+		}
+		phba->sli4_hba.fcp_cq[fcp_cqidx] = qdesc;
+	}
+
+	/* Create Mailbox Command Queue */
+	phba->sli4_hba.mq_esize = LPFC_MQE_SIZE;
+	phba->sli4_hba.mq_ecount = LPFC_MQE_DEF_COUNT;
+
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.mq_esize,
+				      phba->sli4_hba.mq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0505 Failed allocate slow-path MQ\n");
+		goto out_free_fcp_cq;
+	}
+	phba->sli4_hba.mbx_wq = qdesc;
+
+	/*
+	 * Create all the Work Queues (WQs)
+	 */
+	phba->sli4_hba.wq_esize = LPFC_WQE_SIZE;
+	phba->sli4_hba.wq_ecount = LPFC_WQE_DEF_COUNT;
+
+	/* Create slow-path ELS Work Queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
+				      phba->sli4_hba.wq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0504 Failed allocate slow-path ELS WQ\n");
+		goto out_free_mbx_wq;
+	}
+	phba->sli4_hba.els_wq = qdesc;
+
+	/* Create fast-path FCP Work Queue(s) */
+	phba->sli4_hba.fcp_wq = kzalloc((sizeof(struct lpfc_queue *) *
+				phba->cfg_fcp_wq_count), GFP_KERNEL);
+	if (!phba->sli4_hba.fcp_wq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2578 Failed allocate memory for fast-path "
+				"WQ record array\n");
+		goto out_free_els_wq;
+	}
+	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_wq_count; fcp_wqidx++) {
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
+					      phba->sli4_hba.wq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0503 Failed allocate fast-path FCP "
+					"WQ (%d)\n", fcp_wqidx);
+			goto out_free_fcp_wq;
+		}
+		phba->sli4_hba.fcp_wq[fcp_wqidx] = qdesc;
+	}
+
+	/*
+	 * Create Receive Queue (RQ)
+	 */
+	phba->sli4_hba.rq_esize = LPFC_RQE_SIZE;
+	phba->sli4_hba.rq_ecount = LPFC_RQE_DEF_COUNT;
+
+	/* Create Receive Queue for header */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.rq_esize,
+				      phba->sli4_hba.rq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0506 Failed allocate receive HRQ\n");
+		goto out_free_fcp_wq;
+	}
+	phba->sli4_hba.hdr_rq = qdesc;
+
+	/* Create Receive Queue for data */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.rq_esize,
+				      phba->sli4_hba.rq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0507 Failed allocate receive DRQ\n");
+		goto out_free_hdr_rq;
+	}
+	phba->sli4_hba.dat_rq = qdesc;
+
+	return 0;
+
+out_free_hdr_rq:
+	lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
+	phba->sli4_hba.hdr_rq = NULL;
+out_free_fcp_wq:
+	for (--fcp_wqidx; fcp_wqidx >= 0; fcp_wqidx--) {
+		lpfc_sli4_queue_free(phba->sli4_hba.fcp_wq[fcp_wqidx]);
+		phba->sli4_hba.fcp_wq[fcp_wqidx] = NULL;
+	}
+	kfree(phba->sli4_hba.fcp_wq);
+out_free_els_wq:
+	lpfc_sli4_queue_free(phba->sli4_hba.els_wq);
+	phba->sli4_hba.els_wq = NULL;
+out_free_mbx_wq:
+	lpfc_sli4_queue_free(phba->sli4_hba.mbx_wq);
+	phba->sli4_hba.mbx_wq = NULL;
+out_free_fcp_cq:
+	for (--fcp_cqidx; fcp_cqidx >= 0; fcp_cqidx--) {
+		lpfc_sli4_queue_free(phba->sli4_hba.fcp_cq[fcp_cqidx]);
+		phba->sli4_hba.fcp_cq[fcp_cqidx] = NULL;
+	}
+	kfree(phba->sli4_hba.fcp_cq);
+out_free_rxq_cq:
+	lpfc_sli4_queue_free(phba->sli4_hba.rxq_cq);
+	phba->sli4_hba.rxq_cq = NULL;
+out_free_els_cq:
+	lpfc_sli4_queue_free(phba->sli4_hba.els_cq);
+	phba->sli4_hba.els_cq = NULL;
+out_free_mbx_cq:
+	lpfc_sli4_queue_free(phba->sli4_hba.mbx_cq);
+	phba->sli4_hba.mbx_cq = NULL;
+out_free_fp_eq:
+	for (--fcp_eqidx; fcp_eqidx >= 0; fcp_eqidx--) {
+		lpfc_sli4_queue_free(phba->sli4_hba.fp_eq[fcp_eqidx]);
+		phba->sli4_hba.fp_eq[fcp_eqidx] = NULL;
+	}
+	kfree(phba->sli4_hba.fp_eq);
+out_free_sp_eq:
+	lpfc_sli4_queue_free(phba->sli4_hba.sp_eq);
+	phba->sli4_hba.sp_eq = NULL;
+out_error:
+	return -ENOMEM;
+}
+
+/**
+ * lpfc_sli4_queue_destroy - Destroy all the SLI4 queues
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release all the SLI4 queues with the FCoE HBA
+ * operation.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+static void
+lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
+{
+	int fcp_qidx;
+
+	/* Release mailbox command work queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.mbx_wq);
+	phba->sli4_hba.mbx_wq = NULL;
+
+	/* Release ELS work queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.els_wq);
+	phba->sli4_hba.els_wq = NULL;
+
+	/* Release FCP work queue */
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_wq_count; fcp_qidx++)
+		lpfc_sli4_queue_free(phba->sli4_hba.fcp_wq[fcp_qidx]);
+	kfree(phba->sli4_hba.fcp_wq);
+	phba->sli4_hba.fcp_wq = NULL;
+
+	/* Release unsolicited receive queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
+	phba->sli4_hba.hdr_rq = NULL;
+	lpfc_sli4_queue_free(phba->sli4_hba.dat_rq);
+	phba->sli4_hba.dat_rq = NULL;
+
+	/* Release unsolicited receive complete queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.rxq_cq);
+	phba->sli4_hba.rxq_cq = NULL;
+
+	/* Release ELS complete queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.els_cq);
+	phba->sli4_hba.els_cq = NULL;
+
+	/* Release mailbox command complete queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.mbx_cq);
+	phba->sli4_hba.mbx_cq = NULL;
+
+	/* Release FCP response complete queue */
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
+		lpfc_sli4_queue_free(phba->sli4_hba.fcp_cq[fcp_qidx]);
+	kfree(phba->sli4_hba.fcp_cq);
+	phba->sli4_hba.fcp_cq = NULL;
+
+	/* Release fast-path event queue */
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
+		lpfc_sli4_queue_free(phba->sli4_hba.fp_eq[fcp_qidx]);
+	kfree(phba->sli4_hba.fp_eq);
+	phba->sli4_hba.fp_eq = NULL;
+
+	/* Release slow-path event queue */
+	lpfc_sli4_queue_free(phba->sli4_hba.sp_eq);
+	phba->sli4_hba.sp_eq = NULL;
+
+	return;
+}
+
+/**
+ * lpfc_sli4_queue_setup - Set up all the SLI4 queues
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up all the SLI4 queues for the FCoE HBA
+ * operation.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+int
+lpfc_sli4_queue_setup(struct lpfc_hba *phba)
+{
+	int rc = -ENOMEM;
+	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
+	int fcp_cq_index = 0;
+
+	/*
+	 * Set up Event Queues (EQs)
+	 */
+
+	/* Set up slow-path event queue */
+	if (!phba->sli4_hba.sp_eq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0520 Slow-path EQ not allocated\n");
+		goto out_error;
+	}
+	rc = lpfc_eq_create(phba, phba->sli4_hba.sp_eq,
+			    LPFC_SP_DEF_IMAX);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0521 Failed setup of slow-path EQ: "
+				"rc = 0x%x\n", rc);
+		goto out_error;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2583 Slow-path EQ setup: queue-id=%d\n",
+			phba->sli4_hba.sp_eq->queue_id);
+
+	/* Set up fast-path event queue */
+	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++) {
+		if (!phba->sli4_hba.fp_eq[fcp_eqidx]) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0522 Fast-path EQ (%d) not "
+					"allocated\n", fcp_eqidx);
+			goto out_destroy_fp_eq;
+		}
+		rc = lpfc_eq_create(phba, phba->sli4_hba.fp_eq[fcp_eqidx],
+				    phba->cfg_fcp_imax);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0523 Failed setup of fast-path EQ "
+					"(%d), rc = 0x%x\n", fcp_eqidx, rc);
+			goto out_destroy_fp_eq;
+		}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2584 Fast-path EQ setup: "
+				"queue[%d]-id=%d\n", fcp_eqidx,
+				phba->sli4_hba.fp_eq[fcp_eqidx]->queue_id);
+	}
+
+	/*
+	 * Set up Complete Queues (CQs)
+	 */
+
+	/* Set up slow-path MBOX Complete Queue as the first CQ */
+	if (!phba->sli4_hba.mbx_cq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0528 Mailbox CQ not allocated\n");
+		goto out_destroy_fp_eq;
+	}
+	rc = lpfc_cq_create(phba, phba->sli4_hba.mbx_cq, phba->sli4_hba.sp_eq,
+			    LPFC_MCQ, LPFC_MBOX);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0529 Failed setup of slow-path mailbox CQ: "
+				"rc = 0x%x\n", rc);
+		goto out_destroy_fp_eq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2585 MBX CQ setup: cq-id=%d, parent eq-id=%d\n",
+			phba->sli4_hba.mbx_cq->queue_id,
+			phba->sli4_hba.sp_eq->queue_id);
+
+	/* Set up slow-path ELS Complete Queue */
+	if (!phba->sli4_hba.els_cq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0530 ELS CQ not allocated\n");
+		goto out_destroy_mbx_cq;
+	}
+	rc = lpfc_cq_create(phba, phba->sli4_hba.els_cq, phba->sli4_hba.sp_eq,
+			    LPFC_WCQ, LPFC_ELS);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0531 Failed setup of slow-path ELS CQ: "
+				"rc = 0x%x\n", rc);
+		goto out_destroy_mbx_cq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2586 ELS CQ setup: cq-id=%d, parent eq-id=%d\n",
+			phba->sli4_hba.els_cq->queue_id,
+			phba->sli4_hba.sp_eq->queue_id);
+
+	/* Set up slow-path Unsolicited Receive Complete Queue */
+	if (!phba->sli4_hba.rxq_cq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0532 USOL RX CQ not allocated\n");
+		goto out_destroy_els_cq;
+	}
+	rc = lpfc_cq_create(phba, phba->sli4_hba.rxq_cq, phba->sli4_hba.sp_eq,
+			    LPFC_RCQ, LPFC_USOL);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0533 Failed setup of slow-path USOL RX CQ: "
+				"rc = 0x%x\n", rc);
+		goto out_destroy_els_cq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2587 USL CQ setup: cq-id=%d, parent eq-id=%d\n",
+			phba->sli4_hba.rxq_cq->queue_id,
+			phba->sli4_hba.sp_eq->queue_id);
+
+	/* Set up fast-path FCP Response Complete Queue */
+	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++) {
+		if (!phba->sli4_hba.fcp_cq[fcp_cqidx]) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0526 Fast-path FCP CQ (%d) not "
+					"allocated\n", fcp_cqidx);
+			goto out_destroy_fcp_cq;
+		}
+		rc = lpfc_cq_create(phba, phba->sli4_hba.fcp_cq[fcp_cqidx],
+				    phba->sli4_hba.fp_eq[fcp_cqidx],
+				    LPFC_WCQ, LPFC_FCP);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0527 Failed setup of fast-path FCP "
+					"CQ (%d), rc = 0x%x\n", fcp_cqidx, rc);
+			goto out_destroy_fcp_cq;
+		}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2588 FCP CQ setup: cq[%d]-id=%d, "
+				"parent eq[%d]-id=%d\n",
+				fcp_cqidx,
+				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id,
+				fcp_cqidx,
+				phba->sli4_hba.fp_eq[fcp_cqidx]->queue_id);
+	}
+
+	/*
+	 * Set up all the Work Queues (WQs)
+	 */
+
+	/* Set up Mailbox Command Queue */
+	if (!phba->sli4_hba.mbx_wq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0538 Slow-path MQ not allocated\n");
+		goto out_destroy_fcp_cq;
+	}
+	rc = lpfc_mq_create(phba, phba->sli4_hba.mbx_wq,
+			    phba->sli4_hba.mbx_cq, LPFC_MBOX);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0539 Failed setup of slow-path MQ: "
+				"rc = 0x%x\n", rc);
+		goto out_destroy_fcp_cq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
+			phba->sli4_hba.mbx_wq->queue_id,
+			phba->sli4_hba.mbx_cq->queue_id);
+
+	/* Set up slow-path ELS Work Queue */
+	if (!phba->sli4_hba.els_wq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0536 Slow-path ELS WQ not allocated\n");
+		goto out_destroy_mbx_wq;
+	}
+	rc = lpfc_wq_create(phba, phba->sli4_hba.els_wq,
+			    phba->sli4_hba.els_cq, LPFC_ELS);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0537 Failed setup of slow-path ELS WQ: "
+				"rc = 0x%x\n", rc);
+		goto out_destroy_mbx_wq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2590 ELS WQ setup: wq-id=%d, parent cq-id=%d\n",
+			phba->sli4_hba.els_wq->queue_id,
+			phba->sli4_hba.els_cq->queue_id);
+
+	/* Set up fast-path FCP Work Queue */
+	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_wq_count; fcp_wqidx++) {
+		if (!phba->sli4_hba.fcp_wq[fcp_wqidx]) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0534 Fast-path FCP WQ (%d) not "
+					"allocated\n", fcp_wqidx);
+			goto out_destroy_fcp_wq;
+		}
+		rc = lpfc_wq_create(phba, phba->sli4_hba.fcp_wq[fcp_wqidx],
+				    phba->sli4_hba.fcp_cq[fcp_cq_index],
+				    LPFC_FCP);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0535 Failed setup of fast-path FCP "
+					"WQ (%d), rc = 0x%x\n", fcp_wqidx, rc);
+			goto out_destroy_fcp_wq;
+		}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2591 FCP WQ setup: wq[%d]-id=%d, "
+				"parent cq[%d]-id=%d\n",
+				fcp_wqidx,
+				phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
+				fcp_cq_index,
+				phba->sli4_hba.fcp_cq[fcp_cq_index]->queue_id);
+		/* Round robin FCP Work Queue's Completion Queue assignment */
+		fcp_cq_index = ((fcp_cq_index + 1) % phba->cfg_fcp_eq_count);
+	}
+
+	/*
+	 * Create Receive Queue (RQ)
+	 */
+	if (!phba->sli4_hba.hdr_rq || !phba->sli4_hba.dat_rq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0540 Receive Queue not allocated\n");
+		goto out_destroy_fcp_wq;
+	}
+	rc = lpfc_rq_create(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
+			    phba->sli4_hba.rxq_cq, LPFC_USOL);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0541 Failed setup of Receive Queue: "
+				"rc = 0x%x\n", rc);
+		goto out_destroy_fcp_wq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2592 USL RQ setup: hdr-rq-id=%d, dat-rq-id=%d "
+			"parent cq-id=%d\n",
+			phba->sli4_hba.hdr_rq->queue_id,
+			phba->sli4_hba.dat_rq->queue_id,
+			phba->sli4_hba.rxq_cq->queue_id);
+	return 0;
+
+out_destroy_fcp_wq:
+	for (--fcp_wqidx; fcp_wqidx >= 0; fcp_wqidx--)
+		lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_wqidx]);
+	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
+out_destroy_mbx_wq:
+	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+out_destroy_fcp_cq:
+	for (--fcp_cqidx; fcp_cqidx >= 0; fcp_cqidx--)
+		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_cqidx]);
+	lpfc_cq_destroy(phba, phba->sli4_hba.rxq_cq);
+out_destroy_els_cq:
+	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+out_destroy_mbx_cq:
+	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
+out_destroy_fp_eq:
+	for (--fcp_eqidx; fcp_eqidx >= 0; fcp_eqidx--)
+		lpfc_eq_destroy(phba, phba->sli4_hba.fp_eq[fcp_eqidx]);
+	lpfc_eq_destroy(phba, phba->sli4_hba.sp_eq);
+out_error:
+	return rc;
+}
+
+/**
+ * lpfc_sli4_queue_unset - Unset all the SLI4 queues
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset all the SLI4 queues with the FCoE HBA
+ * operation.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+void
+lpfc_sli4_queue_unset(struct lpfc_hba *phba)
+{
+	int fcp_qidx;
+
+	/* Unset mailbox command work queue */
+	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+	/* Unset ELS work queue */
+	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
+	/* Unset unsolicited receive queue */
+	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
+	/* Unset FCP work queue */
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_wq_count; fcp_qidx++)
+		lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_qidx]);
+	/* Unset mailbox command complete queue */
+	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
+	/* Unset ELS complete queue */
+	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+	/* Unset unsolicited receive complete queue */
+	lpfc_cq_destroy(phba, phba->sli4_hba.rxq_cq);
+	/* Unset FCP response complete queue */
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
+		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_qidx]);
+	/* Unset fast-path event queue */
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
+		lpfc_eq_destroy(phba, phba->sli4_hba.fp_eq[fcp_qidx]);
+	/* Unset slow-path event queue */
+	lpfc_eq_destroy(phba, phba->sli4_hba.sp_eq);
+}
+
+/**
+ * lpfc_sli4_cq_event_pool_create - Create completion-queue event free pool
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate and set up a pool of completion queue
+ * events. The body of the completion queue event is a completion queue entry
+ * CQE. For now, this pool is used for the interrupt service routine to queue
+ * the following HBA completion queue events for the worker thread to process:
+ *   - Mailbox asynchronous events
+ *   - Receive queue completion unsolicited events
+ * Later, this can be used for all the slow-path events.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      -ENOMEM - No availble memory
+ **/
+static int
+lpfc_sli4_cq_event_pool_create(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+	int i;
+
+	for (i = 0; i < (4 * phba->sli4_hba.cq_ecount); i++) {
+		cq_event = kmalloc(sizeof(struct lpfc_cq_event), GFP_KERNEL);
+		if (!cq_event)
+			goto out_pool_create_fail;
+		list_add_tail(&cq_event->list,
+			      &phba->sli4_hba.sp_cqe_event_pool);
+	}
+	return 0;
+
+out_pool_create_fail:
+	lpfc_sli4_cq_event_pool_destroy(phba);
+	return -ENOMEM;
+}
+
+/**
+ * lpfc_sli4_cq_event_pool_destroy - Free completion-queue event free pool
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to free the pool of completion queue events at
+ * driver unload time. Note that, it is the responsibility of the driver
+ * cleanup routine to free all the outstanding completion-queue events
+ * allocated from this pool back into the pool before invoking this routine
+ * to destroy the pool.
+ **/
+static void
+lpfc_sli4_cq_event_pool_destroy(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event, *next_cq_event;
+
+	list_for_each_entry_safe(cq_event, next_cq_event,
+				 &phba->sli4_hba.sp_cqe_event_pool, list) {
+		list_del(&cq_event->list);
+		kfree(cq_event);
+	}
+}
+
+/**
+ * __lpfc_sli4_cq_event_alloc - Allocate a completion-queue event from free pool
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is the lock free version of the API invoked to allocate a
+ * completion-queue event from the free pool.
+ *
+ * Return: Pointer to the newly allocated completion-queue event if successful
+ *         NULL otherwise.
+ **/
+struct lpfc_cq_event *
+__lpfc_sli4_cq_event_alloc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event = NULL;
+
+	list_remove_head(&phba->sli4_hba.sp_cqe_event_pool, cq_event,
+			 struct lpfc_cq_event, list);
+	return cq_event;
+}
+
+/**
+ * lpfc_sli4_cq_event_alloc - Allocate a completion-queue event from free pool
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is the lock version of the API invoked to allocate a
+ * completion-queue event from the free pool.
+ *
+ * Return: Pointer to the newly allocated completion-queue event if successful
+ *         NULL otherwise.
+ **/
+struct lpfc_cq_event *
+lpfc_sli4_cq_event_alloc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	cq_event = __lpfc_sli4_cq_event_alloc(phba);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return cq_event;
+}
+
+/**
+ * __lpfc_sli4_cq_event_release - Release a completion-queue event to free pool
+ * @phba: pointer to lpfc hba data structure.
+ * @cq_event: pointer to the completion queue event to be freed.
+ *
+ * This routine is the lock free version of the API invoked to release a
+ * completion-queue event back into the free pool.
+ **/
+void
+__lpfc_sli4_cq_event_release(struct lpfc_hba *phba,
+			     struct lpfc_cq_event *cq_event)
+{
+	list_add_tail(&cq_event->list, &phba->sli4_hba.sp_cqe_event_pool);
+}
+
+/**
+ * lpfc_sli4_cq_event_release - Release a completion-queue event to free pool
+ * @phba: pointer to lpfc hba data structure.
+ * @cq_event: pointer to the completion queue event to be freed.
+ *
+ * This routine is the lock version of the API invoked to release a
+ * completion-queue event back into the free pool.
+ **/
+void
+lpfc_sli4_cq_event_release(struct lpfc_hba *phba,
+			   struct lpfc_cq_event *cq_event)
+{
+	unsigned long iflags;
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	__lpfc_sli4_cq_event_release(phba, cq_event);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+}
+
+/**
+ * lpfc_sli4_cq_event_release_all - Release all cq events to the free pool
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to free all the pending completion-queue events to the
+ * back into the free pool for device reset.
+ **/
+static void
+lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
+{
+	LIST_HEAD(cqelist);
+	struct lpfc_cq_event *cqe;
+	unsigned long iflags;
+
+	/* Retrieve all the pending WCQEs from pending WCQE lists */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	/* Pending FCP XRI abort events */
+	list_splice_init(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue,
+			 &cqelist);
+	/* Pending ELS XRI abort events */
+	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
+			 &cqelist);
+	/* Pending asynnc events */
+	list_splice_init(&phba->sli4_hba.sp_asynce_work_queue,
+			 &cqelist);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	while (!list_empty(&cqelist)) {
+		list_remove_head(&cqelist, cqe, struct lpfc_cq_event, list);
+		lpfc_sli4_cq_event_release(phba, cqe);
+	}
+}
+
+/**
+ * lpfc_pci_function_reset - Reset pci function.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to request a PCI function reset. It will destroys
+ * all resources assigned to the PCI function which originates this request.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+int
+lpfc_pci_function_reset(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mboxq;
+	uint32_t rc = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0494 Unable to allocate memory for issuing "
+				"SLI_FUNCTION_RESET mailbox command\n");
+		return -ENOMEM;
+	}
+
+	/* Set up PCI function reset SLI4_CONFIG mailbox-ioctl command */
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_FUNCTION_RESET, 0,
+			 LPFC_SLI4_MBX_EMBED);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mboxq->u.mqe.un.sli4_config.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0495 SLI_FUNCTION_RESET mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli4_send_nop_mbox_cmds - Send sli-4 nop mailbox commands
+ * @phba: pointer to lpfc hba data structure.
+ * @cnt: number of nop mailbox commands to send.
+ *
+ * This routine is invoked to send a number @cnt of NOP mailbox command and
+ * wait for each command to complete.
+ *
+ * Return: the number of NOP mailbox command completed.
+ **/
+static int
+lpfc_sli4_send_nop_mbox_cmds(struct lpfc_hba *phba, uint32_t cnt)
+{
+	LPFC_MBOXQ_t *mboxq;
+	int length, cmdsent;
+	uint32_t mbox_tmo;
+	uint32_t rc = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (cnt == 0) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2518 Requested to send 0 NOP mailbox cmd\n");
+		return cnt;
+	}
+
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2519 Unable to allocate memory for issuing "
+				"NOP mailbox command\n");
+		return 0;
+	}
+
+	/* Set up NOP SLI4_CONFIG mailbox-ioctl command */
+	length = (sizeof(struct lpfc_mbx_nop) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_NOP, length, LPFC_SLI4_MBX_EMBED);
+
+	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+	for (cmdsent = 0; cmdsent < cnt; cmdsent++) {
+		if (!phba->sli4_hba.intr_enable)
+			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		else
+			rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+		if (rc == MBX_TIMEOUT)
+			break;
+		/* Check return status */
+		shdr = (union lpfc_sli4_cfg_shdr *)
+			&mboxq->u.mqe.un.sli4_config.header.cfg_shdr;
+		shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+					 &shdr->response);
+		if (shdr_status || shdr_add_status || rc) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"2520 NOP mailbox command failed "
+					"status x%x add_status x%x mbx "
+					"status x%x\n", shdr_status,
+					shdr_add_status, rc);
+			break;
+		}
+	}
+
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+
+	return cmdsent;
+}
+
+/**
+ * lpfc_sli4_fcfi_unreg - Unregister fcfi to device
+ * @phba: pointer to lpfc hba data structure.
+ * @fcfi: fcf index.
+ *
+ * This routine is invoked to unregister a FCFI from device.
+ **/
+void
+lpfc_sli4_fcfi_unreg(struct lpfc_hba *phba, uint16_t fcfi)
+{
+	LPFC_MBOXQ_t *mbox;
+	uint32_t mbox_tmo;
+	int rc;
+	unsigned long flags;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+
+	if (!mbox)
+		return;
+
+	lpfc_unreg_fcfi(mbox, fcfi);
+
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	if (rc != MBX_SUCCESS)
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2517 Unregister FCFI command failed "
+				"status %d, mbxStatus x%x\n", rc,
+				bf_get(lpfc_mqe_status, &mbox->u.mqe));
+	else {
+		spin_lock_irqsave(&phba->hbalock, flags);
+		/* Mark the FCFI is no longer registered */
+		phba->fcf.fcf_flag &=
+			~(FCF_AVAILABLE | FCF_REGISTERED | FCF_DISCOVERED);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+	}
+}
+
+/**
+ * lpfc_sli4_pci_mem_setup - Setup SLI4 HBA PCI memory space.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the PCI device memory space for device
+ * with SLI-4 interface spec.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static int
+lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
+{
+	struct pci_dev *pdev;
+	unsigned long bar0map_len, bar1map_len, bar2map_len;
+	int error = -ENODEV;
+
+	/* Obtain PCI device reference */
+	if (!phba->pcidev)
+		return error;
+	else
+		pdev = phba->pcidev;
+
+	/* Set the device DMA mask size */
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+			return error;
+
+	/* Get the bus address of SLI4 device Bar0, Bar1, and Bar2 and the
+	 * number of bytes required by each mapping. They are actually
+	 * mapping to the PCI BAR regions 1, 2, and 4 by the SLI4 device.
+	 */
+	phba->pci_bar0_map = pci_resource_start(pdev, LPFC_SLI4_BAR0);
+	bar0map_len = pci_resource_len(pdev, LPFC_SLI4_BAR0);
+
+	phba->pci_bar1_map = pci_resource_start(pdev, LPFC_SLI4_BAR1);
+	bar1map_len = pci_resource_len(pdev, LPFC_SLI4_BAR1);
+
+	phba->pci_bar2_map = pci_resource_start(pdev, LPFC_SLI4_BAR2);
+	bar2map_len = pci_resource_len(pdev, LPFC_SLI4_BAR2);
+
+	/* Map SLI4 PCI Config Space Register base to a kernel virtual addr */
+	phba->sli4_hba.conf_regs_memmap_p =
+				ioremap(phba->pci_bar0_map, bar0map_len);
+	if (!phba->sli4_hba.conf_regs_memmap_p) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for SLI4 PCI config registers.\n");
+		goto out;
+	}
+
+	/* Map SLI4 HBA Control Register base to a kernel virtual address. */
+	phba->sli4_hba.ctrl_regs_memmap_p =
+				ioremap(phba->pci_bar1_map, bar1map_len);
+	if (!phba->sli4_hba.ctrl_regs_memmap_p) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for SLI4 HBA control registers.\n");
+		goto out_iounmap_conf;
+	}
+
+	/* Map SLI4 HBA Doorbell Register base to a kernel virtual address. */
+	phba->sli4_hba.drbl_regs_memmap_p =
+				ioremap(phba->pci_bar2_map, bar2map_len);
+	if (!phba->sli4_hba.drbl_regs_memmap_p) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for SLI4 HBA doorbell registers.\n");
+		goto out_iounmap_ctrl;
+	}
+
+	/* Set up BAR0 PCI config space register memory map */
+	lpfc_sli4_bar0_register_memmap(phba);
+
+	/* Set up BAR1 register memory map */
+	lpfc_sli4_bar1_register_memmap(phba);
+
+	/* Set up BAR2 register memory map */
+	error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
+	if (error)
+		goto out_iounmap_all;
+
+	return 0;
+
+out_iounmap_all:
+	iounmap(phba->sli4_hba.drbl_regs_memmap_p);
+out_iounmap_ctrl:
+	iounmap(phba->sli4_hba.ctrl_regs_memmap_p);
+out_iounmap_conf:
+	iounmap(phba->sli4_hba.conf_regs_memmap_p);
+out:
+	return error;
+}
+
+/**
+ * lpfc_sli4_pci_mem_unset - Unset SLI4 HBA PCI memory space.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the PCI device memory space for device
+ * with SLI-4 interface spec.
+ **/
+static void
+lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
+{
+	struct pci_dev *pdev;
+
+	/* Obtain PCI device reference */
+	if (!phba->pcidev)
+		return;
+	else
+		pdev = phba->pcidev;
+
+	/* Free coherent DMA memory allocated */
+
+	/* Unmap I/O memory space */
+	iounmap(phba->sli4_hba.drbl_regs_memmap_p);
+	iounmap(phba->sli4_hba.ctrl_regs_memmap_p);
+	iounmap(phba->sli4_hba.conf_regs_memmap_p);
+
+	return;
+}
+
+/**
+ * lpfc_sli_enable_msix - Enable MSI-X interrupt mode on SLI-3 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI-X interrupt vectors to device
+ * with SLI-3 interface specs. The kernel function pci_enable_msix() is
+ * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
+ * invoked, enables either all or nothing, depending on the current
+ * availability of PCI vector resources. The device driver is responsible
+ * for calling the individual request_irq() to register each MSI-X vector
+ * with a interrupt handler, which is done in this function. Note that
+ * later when device is unloading, the driver should always call free_irq()
+ * on all MSI-X vectors it has done request_irq() on before calling
+ * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
+ * will be left with MSI-X enabled and leaks its vectors.
+ *
+ * Return codes
+ *   0 - sucessful
+ *   other values - error
+ **/
+static int
+lpfc_sli_enable_msix(struct lpfc_hba *phba)
+{
+	int rc, i;
+	LPFC_MBOXQ_t *pmb;
+
+	/* Set up MSI-X multi-message vectors */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		phba->msix_entries[i].entry = i;
+
+	/* Configure MSI-X capability structure */
+	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
+				ARRAY_SIZE(phba->msix_entries));
+	if (rc) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0420 PCI enable MSI-X failed (%d)\n", rc);
+		goto msi_fail_out;
+	}
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0477 MSI-X entry[%d]: vector=x%x "
+				"message=%d\n", i,
+				phba->msix_entries[i].vector,
+				phba->msix_entries[i].entry);
+	/*
+	 * Assign MSI-X vectors to interrupt handlers
+	 */
+
+	/* vector-0 is associated to slow-path handler */
+	rc = request_irq(phba->msix_entries[0].vector,
+			 &lpfc_sli_sp_intr_handler, IRQF_SHARED,
+			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0421 MSI-X slow-path request_irq failed "
+				"(%d)\n", rc);
+		goto msi_fail_out;
+	}
+
+	/* vector-1 is associated to fast-path handler */
+	rc = request_irq(phba->msix_entries[1].vector,
+			 &lpfc_sli_fp_intr_handler, IRQF_SHARED,
+			 LPFC_FP_DRIVER_HANDLER_NAME, phba);
+
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0429 MSI-X fast-path request_irq failed "
+				"(%d)\n", rc);
+		goto irq_fail_out;
+	}
+
+	/*
+	 * Configure HBA MSI-X attention conditions to messages
+	 */
+	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+
+	if (!pmb) {
+		rc = -ENOMEM;
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0474 Unable to allocate memory for issuing "
+				"MBOX_CONFIG_MSI command\n");
+		goto mem_fail_out;
+	}
+	rc = lpfc_config_msi(phba, pmb);
+	if (rc)
+		goto mbx_fail_out;
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+				"0351 Config MSI mailbox command failed, "
+				"mbxCmd x%x, mbxStatus x%x\n",
+				pmb->u.mb.mbxCommand, pmb->u.mb.mbxStatus);
+		goto mbx_fail_out;
+	}
+
+	/* Free memory allocated for mailbox command */
+	mempool_free(pmb, phba->mbox_mem_pool);
+	return rc;
+
+mbx_fail_out:
+	/* Free memory allocated for mailbox command */
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+mem_fail_out:
+	/* free the irq already requested */
+	free_irq(phba->msix_entries[1].vector, phba);
+
+irq_fail_out:
+	/* free the irq already requested */
+	free_irq(phba->msix_entries[0].vector, phba);
+
+msi_fail_out:
+	/* Unconfigure MSI-X capability structure */
+	pci_disable_msix(phba->pcidev);
+	return rc;
+}
+
+/**
+ * lpfc_sli_disable_msix - Disable MSI-X interrupt mode on SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release the MSI-X vectors and then disable the
+ * MSI-X interrupt mode to device with SLI-3 interface spec.
+ **/
+static void
+lpfc_sli_disable_msix(struct lpfc_hba *phba)
+{
+	int i;
+
+	/* Free up MSI-X multi-message vectors */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		free_irq(phba->msix_entries[i].vector, phba);
+	/* Disable MSI-X */
+	pci_disable_msix(phba->pcidev);
+
+	return;
+}
+
+/**
+ * lpfc_sli_enable_msi - Enable MSI interrupt mode on SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI interrupt mode to device with
+ * SLI-3 interface spec. The kernel function pci_enable_msi() is called to
+ * enable the MSI vector. The device driver is responsible for calling the
+ * request_irq() to register MSI vector with a interrupt the handler, which
+ * is done in this function.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ */
+static int
+lpfc_sli_enable_msi(struct lpfc_hba *phba)
+{
+	int rc;
+
+	rc = pci_enable_msi(phba->pcidev);
+	if (!rc)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0462 PCI enable MSI mode success.\n");
+	else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0471 PCI enable MSI mode failed (%d)\n", rc);
+		return rc;
+	}
+
+	rc = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
+			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+	if (rc) {
+		pci_disable_msi(phba->pcidev);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0478 MSI request_irq failed (%d)\n", rc);
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli_disable_msi - Disable MSI interrupt mode to SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable the MSI interrupt mode to device with
+ * SLI-3 interface spec. The driver calls free_irq() on MSI vector it has
+ * done request_irq() on before calling pci_disable_msi(). Failure to do so
+ * results in a BUG_ON() and a device will be left with MSI enabled and leaks
+ * its vector.
+ */
+static void
+lpfc_sli_disable_msi(struct lpfc_hba *phba)
+{
+	free_irq(phba->pcidev->irq, phba);
+	pci_disable_msi(phba->pcidev);
+	return;
+}
+
+/**
+ * lpfc_sli_enable_intr - Enable device interrupt to SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable device interrupt and associate driver's
+ * interrupt handler(s) to interrupt vector(s) to device with SLI-3 interface
+ * spec. Depends on the interrupt mode configured to the driver, the driver
+ * will try to fallback from the configured interrupt mode to an interrupt
+ * mode which is supported by the platform, kernel, and device in the order
+ * of:
+ * MSI-X -> MSI -> IRQ.
+ *
+ * Return codes
+ *   0 - sucessful
+ *   other values - error
+ **/
+static uint32_t
+lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
+{
+	uint32_t intr_mode = LPFC_INTR_ERROR;
+	int retval;
+
+	if (cfg_mode == 2) {
+		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
+		retval = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+		if (!retval) {
+			/* Now, try to enable MSI-X interrupt mode */
+			retval = lpfc_sli_enable_msix(phba);
+			if (!retval) {
+				/* Indicate initialization to MSI-X mode */
+				phba->intr_type = MSIX;
+				intr_mode = 2;
+			}
+		}
+	}
+
+	/* Fallback to MSI if MSI-X initialization failed */
+	if (cfg_mode >= 1 && phba->intr_type == NONE) {
+		retval = lpfc_sli_enable_msi(phba);
+		if (!retval) {
+			/* Indicate initialization to MSI mode */
+			phba->intr_type = MSI;
+			intr_mode = 1;
+		}
+	}
+
+	/* Fallback to INTx if both MSI-X/MSI initalization failed */
+	if (phba->intr_type == NONE) {
+		retval = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
+				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+		if (!retval) {
+			/* Indicate initialization to INTx mode */
+			phba->intr_type = INTx;
+			intr_mode = 0;
+		}
+	}
+	return intr_mode;
+}
+
+/**
+ * lpfc_sli_disable_intr - Disable device interrupt to SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable device interrupt and disassociate the
+ * driver's interrupt handler(s) from interrupt vector(s) to device with
+ * SLI-3 interface spec. Depending on the interrupt mode, the driver will
+ * release the interrupt vector(s) for the message signaled interrupt.
+ **/
+static void
 lpfc_sli_disable_intr(struct lpfc_hba *phba)
 {
-	/* Disable the currently initialized interrupt mode */
-	if (phba->intr_type == MSIX)
-		lpfc_sli_disable_msix(phba);
-	else if (phba->intr_type == MSI)
-		lpfc_sli_disable_msi(phba);
-	else if (phba->intr_type == INTx)
-		free_irq(phba->pcidev->irq, phba);
+	/* Disable the currently initialized interrupt mode */
+	if (phba->intr_type == MSIX)
+		lpfc_sli_disable_msix(phba);
+	else if (phba->intr_type == MSI)
+		lpfc_sli_disable_msi(phba);
+	else if (phba->intr_type == INTx)
+		free_irq(phba->pcidev->irq, phba);
+
+	/* Reset interrupt management states */
+	phba->intr_type = NONE;
+	phba->sli.slistat.sli_intr = 0;
+
+	return;
+}
+
+/**
+ * lpfc_sli4_enable_msix - Enable MSI-X interrupt mode to SLI-4 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI-X interrupt vectors to device
+ * with SLI-4 interface spec. The kernel function pci_enable_msix() is called
+ * to enable the MSI-X vectors. Note that pci_enable_msix(), once invoked,
+ * enables either all or nothing, depending on the current availability of
+ * PCI vector resources. The device driver is responsible for calling the
+ * individual request_irq() to register each MSI-X vector with a interrupt
+ * handler, which is done in this function. Note that later when device is
+ * unloading, the driver should always call free_irq() on all MSI-X vectors
+ * it has done request_irq() on before calling pci_disable_msix(). Failure
+ * to do so results in a BUG_ON() and a device will be left with MSI-X
+ * enabled and leaks its vectors.
+ *
+ * Return codes
+ * 0 - sucessful
+ * other values - error
+ **/
+static int
+lpfc_sli4_enable_msix(struct lpfc_hba *phba)
+{
+	int rc, index;
+
+	/* Set up MSI-X multi-message vectors */
+	for (index = 0; index < phba->sli4_hba.cfg_eqn; index++)
+		phba->sli4_hba.msix_entries[index].entry = index;
+
+	/* Configure MSI-X capability structure */
+	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
+			     phba->sli4_hba.cfg_eqn);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0484 PCI enable MSI-X failed (%d)\n", rc);
+		goto msi_fail_out;
+	}
+	/* Log MSI-X vector assignment */
+	for (index = 0; index < phba->sli4_hba.cfg_eqn; index++)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0489 MSI-X entry[%d]: vector=x%x "
+				"message=%d\n", index,
+				phba->sli4_hba.msix_entries[index].vector,
+				phba->sli4_hba.msix_entries[index].entry);
+	/*
+	 * Assign MSI-X vectors to interrupt handlers
+	 */
+
+	/* The first vector must associated to slow-path handler for MQ */
+	rc = request_irq(phba->sli4_hba.msix_entries[0].vector,
+			 &lpfc_sli4_sp_intr_handler, IRQF_SHARED,
+			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0485 MSI-X slow-path request_irq failed "
+				"(%d)\n", rc);
+		goto msi_fail_out;
+	}
+
+	/* The rest of the vector(s) are associated to fast-path handler(s) */
+	for (index = 1; index < phba->sli4_hba.cfg_eqn; index++) {
+		phba->sli4_hba.fcp_eq_hdl[index - 1].idx = index - 1;
+		phba->sli4_hba.fcp_eq_hdl[index - 1].phba = phba;
+		rc = request_irq(phba->sli4_hba.msix_entries[index].vector,
+				 &lpfc_sli4_fp_intr_handler, IRQF_SHARED,
+				 LPFC_FP_DRIVER_HANDLER_NAME,
+				 &phba->sli4_hba.fcp_eq_hdl[index - 1]);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0486 MSI-X fast-path (%d) "
+					"request_irq failed (%d)\n", index, rc);
+			goto cfg_fail_out;
+		}
+	}
+
+	return rc;
+
+cfg_fail_out:
+	/* free the irq already requested */
+	for (--index; index >= 1; index--)
+		free_irq(phba->sli4_hba.msix_entries[index - 1].vector,
+			 &phba->sli4_hba.fcp_eq_hdl[index - 1]);
+
+	/* free the irq already requested */
+	free_irq(phba->sli4_hba.msix_entries[0].vector, phba);
+
+msi_fail_out:
+	/* Unconfigure MSI-X capability structure */
+	pci_disable_msix(phba->pcidev);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_disable_msix - Disable MSI-X interrupt mode to SLI-4 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release the MSI-X vectors and then disable the
+ * MSI-X interrupt mode to device with SLI-4 interface spec.
+ **/
+static void
+lpfc_sli4_disable_msix(struct lpfc_hba *phba)
+{
+	int index;
+
+	/* Free up MSI-X multi-message vectors */
+	free_irq(phba->sli4_hba.msix_entries[0].vector, phba);
+
+	for (index = 1; index < phba->sli4_hba.cfg_eqn; index++)
+		free_irq(phba->sli4_hba.msix_entries[index].vector,
+			 &phba->sli4_hba.fcp_eq_hdl[index - 1]);
+	/* Disable MSI-X */
+	pci_disable_msix(phba->pcidev);
+
+	return;
+}
+
+/**
+ * lpfc_sli4_enable_msi - Enable MSI interrupt mode to SLI-4 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI interrupt mode to device with
+ * SLI-4 interface spec. The kernel function pci_enable_msi() is called
+ * to enable the MSI vector. The device driver is responsible for calling
+ * the request_irq() to register MSI vector with a interrupt the handler,
+ * which is done in this function.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static int
+lpfc_sli4_enable_msi(struct lpfc_hba *phba)
+{
+	int rc, index;
+
+	rc = pci_enable_msi(phba->pcidev);
+	if (!rc)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0487 PCI enable MSI mode success.\n");
+	else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0488 PCI enable MSI mode failed (%d)\n", rc);
+		return rc;
+	}
+
+	rc = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
+			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+	if (rc) {
+		pci_disable_msi(phba->pcidev);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0490 MSI request_irq failed (%d)\n", rc);
+	}
+
+	for (index = 0; index < phba->cfg_fcp_eq_count; index++) {
+		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
+		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+	}
+
+	return rc;
+}
+
+/**
+ * lpfc_sli4_disable_msi - Disable MSI interrupt mode to SLI-4 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable the MSI interrupt mode to device with
+ * SLI-4 interface spec. The driver calls free_irq() on MSI vector it has
+ * done request_irq() on before calling pci_disable_msi(). Failure to do so
+ * results in a BUG_ON() and a device will be left with MSI enabled and leaks
+ * its vector.
+ **/
+static void
+lpfc_sli4_disable_msi(struct lpfc_hba *phba)
+{
+	free_irq(phba->pcidev->irq, phba);
+	pci_disable_msi(phba->pcidev);
+	return;
+}
+
+/**
+ * lpfc_sli4_enable_intr - Enable device interrupt to SLI-4 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable device interrupt and associate driver's
+ * interrupt handler(s) to interrupt vector(s) to device with SLI-4
+ * interface spec. Depends on the interrupt mode configured to the driver,
+ * the driver will try to fallback from the configured interrupt mode to an
+ * interrupt mode which is supported by the platform, kernel, and device in
+ * the order of:
+ * MSI-X -> MSI -> IRQ.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static uint32_t
+lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
+{
+	uint32_t intr_mode = LPFC_INTR_ERROR;
+	int retval, index;
+
+	if (cfg_mode == 2) {
+		/* Preparation before conf_msi mbox cmd */
+		retval = 0;
+		if (!retval) {
+			/* Now, try to enable MSI-X interrupt mode */
+			retval = lpfc_sli4_enable_msix(phba);
+			if (!retval) {
+				/* Indicate initialization to MSI-X mode */
+				phba->intr_type = MSIX;
+				intr_mode = 2;
+			}
+		}
+	}
+
+	/* Fallback to MSI if MSI-X initialization failed */
+	if (cfg_mode >= 1 && phba->intr_type == NONE) {
+		retval = lpfc_sli4_enable_msi(phba);
+		if (!retval) {
+			/* Indicate initialization to MSI mode */
+			phba->intr_type = MSI;
+			intr_mode = 1;
+		}
+	}
+
+	/* Fallback to INTx if both MSI-X/MSI initalization failed */
+	if (phba->intr_type == NONE) {
+		retval = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
+				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+		if (!retval) {
+			/* Indicate initialization to INTx mode */
+			phba->intr_type = INTx;
+			intr_mode = 0;
+			for (index = 0; index < phba->cfg_fcp_eq_count;
+			     index++) {
+				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
+				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+			}
+		}
+	}
+	return intr_mode;
+}
+
+/**
+ * lpfc_sli4_disable_intr - Disable device interrupt to SLI-4 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable device interrupt and disassociate
+ * the driver's interrupt handler(s) from interrupt vector(s) to device
+ * with SLI-4 interface spec. Depending on the interrupt mode, the driver
+ * will release the interrupt vector(s) for the message signaled interrupt.
+ **/
+static void
+lpfc_sli4_disable_intr(struct lpfc_hba *phba)
+{
+	/* Disable the currently initialized interrupt mode */
+	if (phba->intr_type == MSIX)
+		lpfc_sli4_disable_msix(phba);
+	else if (phba->intr_type == MSI)
+		lpfc_sli4_disable_msi(phba);
+	else if (phba->intr_type == INTx)
+		free_irq(phba->pcidev->irq, phba);
+
+	/* Reset interrupt management states */
+	phba->intr_type = NONE;
+	phba->sli.slistat.sli_intr = 0;
+
+	return;
+}
+
+/**
+ * lpfc_unset_hba - Unset SLI3 hba device initialization
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the HBA device initialization steps to
+ * a device with SLI-3 interface spec.
+ **/
+static void
+lpfc_unset_hba(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+
+	spin_lock_irq(shost->host_lock);
+	vport->load_flag |= FC_UNLOADING;
+	spin_unlock_irq(shost->host_lock);
+
+	lpfc_stop_hba_timers(phba);
+
+	phba->pport->work_port_events = 0;
+
+	lpfc_sli_hba_down(phba);
+
+	lpfc_sli_brdrestart(phba);
+
+	lpfc_sli_disable_intr(phba);
+
+	return;
+}
+
+/**
+ * lpfc_sli4_unset_hba - Unset SLI4 hba device initialization.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the HBA device initialization steps to
+ * a device with SLI-4 interface spec.
+ **/
+static void
+lpfc_sli4_unset_hba(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+
+	spin_lock_irq(shost->host_lock);
+	vport->load_flag |= FC_UNLOADING;
+	spin_unlock_irq(shost->host_lock);
+
+	phba->pport->work_port_events = 0;
+
+	lpfc_sli4_hba_down(phba);
+
+	lpfc_sli4_disable_intr(phba);
+
+	return;
+}
+
+/**
+ * lpfc_sli4_hba_unset - Unset the fcoe hba
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called in the SLI4 code path to reset the HBA's FCoE
+ * function. The caller is not required to hold any lock. This routine
+ * issues PCI function reset mailbox command to reset the FCoE function.
+ * At the end of the function, it calls lpfc_hba_down_post function to
+ * free any pending commands.
+ **/
+static void
+lpfc_sli4_hba_unset(struct lpfc_hba *phba)
+{
+	int wait_cnt = 0;
+	LPFC_MBOXQ_t *mboxq;
+
+	lpfc_stop_hba_timers(phba);
+	phba->sli4_hba.intr_enable = 0;
+
+	/*
+	 * Gracefully wait out the potential current outstanding asynchronous
+	 * mailbox command.
+	 */
+
+	/* First, block any pending async mailbox command from posted */
+	spin_lock_irq(&phba->hbalock);
+	phba->sli.sli_flag |= LPFC_SLI_ASYNC_MBX_BLK;
+	spin_unlock_irq(&phba->hbalock);
+	/* Now, trying to wait it out if we can */
+	while (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) {
+		msleep(10);
+		if (++wait_cnt > LPFC_ACTIVE_MBOX_WAIT_CNT)
+			break;
+	}
+	/* Forcefully release the outstanding mailbox command if timed out */
+	if (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) {
+		spin_lock_irq(&phba->hbalock);
+		mboxq = phba->sli.mbox_active;
+		mboxq->u.mb.mbxStatus = MBX_NOT_FINISHED;
+		__lpfc_mbox_cmpl_put(phba, mboxq);
+		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+		phba->sli.mbox_active = NULL;
+		spin_unlock_irq(&phba->hbalock);
+	}
+
+	/* Tear down the queues in the HBA */
+	lpfc_sli4_queue_unset(phba);
+
+	/* Disable PCI subsystem interrupt */
+	lpfc_sli4_disable_intr(phba);
+
+	/* Stop kthread signal shall trigger work_done one more time */
+	kthread_stop(phba->worker_thread);
+
+	/* Stop the SLI4 device port */
+	phba->pport->work_port_events = 0;
+}
+
+/**
+ * lpfc_pci_probe_one_s3 - PCI probe func to reg SLI-3 device to PCI subsystem.
+ * @pdev: pointer to PCI device
+ * @pid: pointer to PCI device identifier
+ *
+ * This routine is to be called to attach a device with SLI-3 interface spec
+ * to the PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
+ * presented on PCI bus, the kernel PCI subsystem looks at PCI device-specific
+ * information of the device and driver to see if the driver state that it can
+ * support this kind of device. If the match is successful, the driver core
+ * invokes this routine. If this routine determines it can claim the HBA, it
+ * does all the initialization that it needs to do to handle the HBA properly.
+ *
+ * Return code
+ * 	0 - driver can claim the device
+ * 	negative value - driver can not claim the device
+ **/
+static int __devinit
+lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
+{
+	struct lpfc_hba   *phba;
+	struct lpfc_vport *vport = NULL;
+	int error;
+	uint32_t cfg_mode, intr_mode;
+
+	/* Allocate memory for HBA structure */
+	phba = lpfc_hba_alloc(pdev);
+	if (!phba)
+		return -ENOMEM;
+
+	/* Perform generic PCI device enabling operation */
+	error = lpfc_enable_pci_dev(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1401 Failed to enable pci device.\n");
+		goto out_free_phba;
+	}
+
+	/* Set up SLI API function jump table for PCI-device group-0 HBAs */
+	error = lpfc_api_table_setup(phba, LPFC_PCI_DEV_LP);
+	if (error)
+		goto out_disable_pci_dev;
+
+	/* Set up SLI-3 specific device PCI memory space */
+	error = lpfc_sli_pci_mem_setup(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1402 Failed to set up pci memory space.\n");
+		goto out_disable_pci_dev;
+	}
+
+	/* Set up phase-1 common device driver resources */
+	error = lpfc_setup_driver_resource_phase1(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1403 Failed to set up driver resource.\n");
+		goto out_unset_pci_mem_s3;
+	}
+
+	/* Set up SLI-3 specific device driver resources */
+	error = lpfc_sli_driver_resource_setup(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1404 Failed to set up driver resource.\n");
+		goto out_unset_pci_mem_s3;
+	}
+
+	/* Initialize and populate the iocb list per host */
+	error = lpfc_init_iocb_list(phba, LPFC_IOCB_LIST_CNT);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1405 Failed to initialize iocb list.\n");
+		goto out_unset_driver_resource_s3;
+	}
+
+	/* Set up common device driver resources */
+	error = lpfc_setup_driver_resource_phase2(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1406 Failed to set up driver resource.\n");
+		goto out_free_iocb_list;
+	}
+
+	/* Create SCSI host to the physical port */
+	error = lpfc_create_shost(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1407 Failed to create scsi host.\n");
+		goto out_unset_driver_resource;
+	}
+
+	/* Configure sysfs attributes */
+	vport = phba->pport;
+	error = lpfc_alloc_sysfs_attr(vport);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1476 Failed to allocate sysfs attr\n");
+		goto out_destroy_shost;
+	}
+
+	/* Now, trying to enable interrupt and bring up the device */
+	cfg_mode = phba->cfg_use_msi;
+	while (true) {
+		/* Put device to a known state before enabling interrupt */
+		lpfc_stop_port(phba);
+		/* Configure and enable interrupt */
+		intr_mode = lpfc_sli_enable_intr(phba, cfg_mode);
+		if (intr_mode == LPFC_INTR_ERROR) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0431 Failed to enable interrupt.\n");
+			error = -ENODEV;
+			goto out_free_sysfs_attr;
+		}
+		/* SLI-3 HBA setup */
+		if (lpfc_sli_hba_setup(phba)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1477 Failed to set up hba\n");
+			error = -ENODEV;
+			goto out_remove_device;
+		}
+
+		/* Wait 50ms for the interrupts of previous mailbox commands */
+		msleep(50);
+		/* Check active interrupts on message signaled interrupts */
+		if (intr_mode == 0 ||
+		    phba->sli.slistat.sli_intr > LPFC_MSIX_VECTORS) {
+			/* Log the current active interrupt mode */
+			phba->intr_mode = intr_mode;
+			lpfc_log_intr_mode(phba, intr_mode);
+			break;
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"0447 Configure interrupt mode (%d) "
+					"failed active interrupt test.\n",
+					intr_mode);
+			/* Disable the current interrupt mode */
+			lpfc_sli_disable_intr(phba);
+			/* Try next level of interrupt mode */
+			cfg_mode = --intr_mode;
+		}
+	}
+
+	/* Perform post initialization setup */
+	lpfc_post_init_setup(phba);
+
+	/* Check if there are static vports to be created. */
+	lpfc_create_static_vport(phba);
+
+	return 0;
+
+out_remove_device:
+	lpfc_unset_hba(phba);
+out_free_sysfs_attr:
+	lpfc_free_sysfs_attr(vport);
+out_destroy_shost:
+	lpfc_destroy_shost(phba);
+out_unset_driver_resource:
+	lpfc_unset_driver_resource_phase2(phba);
+out_free_iocb_list:
+	lpfc_free_iocb_list(phba);
+out_unset_driver_resource_s3:
+	lpfc_sli_driver_resource_unset(phba);
+out_unset_pci_mem_s3:
+	lpfc_sli_pci_mem_unset(phba);
+out_disable_pci_dev:
+	lpfc_disable_pci_dev(phba);
+out_free_phba:
+	lpfc_hba_free(phba);
+	return error;
+}
+
+/**
+ * lpfc_pci_remove_one_s3 - PCI func to unreg SLI-3 device from PCI subsystem.
+ * @pdev: pointer to PCI device
+ *
+ * This routine is to be called to disattach a device with SLI-3 interface
+ * spec from PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
+ * removed from PCI bus, it performs all the necessary cleanup for the HBA
+ * device to be removed from the PCI subsystem properly.
+ **/
+static void __devexit
+lpfc_pci_remove_one_s3(struct pci_dev *pdev)
+{
+	struct Scsi_Host  *shost = pci_get_drvdata(pdev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_vport **vports;
+	struct lpfc_hba   *phba = vport->phba;
+	int i;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	spin_lock_irq(&phba->hbalock);
+	vport->load_flag |= FC_UNLOADING;
+	spin_unlock_irq(&phba->hbalock);
+
+	lpfc_free_sysfs_attr(vport);
+
+	/* Release all the vports against this physical port */
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for (i = 1; i <= phba->max_vports && vports[i] != NULL; i++)
+			fc_vport_terminate(vports[i]->fc_vport);
+	lpfc_destroy_vport_work_array(phba, vports);
+
+	/* Remove FC host and then SCSI host with the physical port */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+	lpfc_cleanup(vport);
+
+	/*
+	 * Bring down the SLI Layer. This step disable all interrupts,
+	 * clears the rings, discards all mailbox commands, and resets
+	 * the HBA.
+	 */
+
+	/* HBA interrupt will be diabled after this call */
+	lpfc_sli_hba_down(phba);
+	/* Stop kthread signal shall trigger work_done one more time */
+	kthread_stop(phba->worker_thread);
+	/* Final cleanup of txcmplq and reset the HBA */
+	lpfc_sli_brdrestart(phba);
+
+	lpfc_stop_hba_timers(phba);
+	spin_lock_irq(&phba->hbalock);
+	list_del_init(&vport->listentry);
+	spin_unlock_irq(&phba->hbalock);
+
+	lpfc_debugfs_terminate(vport);
+
+	/* Disable interrupt */
+	lpfc_sli_disable_intr(phba);
+
+	pci_set_drvdata(pdev, NULL);
+	scsi_host_put(shost);
+
+	/*
+	 * Call scsi_free before mem_free since scsi bufs are released to their
+	 * corresponding pools here.
+	 */
+	lpfc_scsi_free(phba);
+	lpfc_mem_free_all(phba);
+
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+			  phba->hbqslimp.virt, phba->hbqslimp.phys);
+
+	/* Free resources associated with SLI2 interface */
+	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
+			  phba->slim2p.virt, phba->slim2p.phys);
+
+	/* unmap adapter SLIM and Control Registers */
+	iounmap(phba->ctrl_regs_memmap_p);
+	iounmap(phba->slim_memmap_p);
+
+	lpfc_hba_free(phba);
+
+	pci_release_selected_regions(pdev, bars);
+	pci_disable_device(pdev);
+}
+
+/**
+ * lpfc_pci_suspend_one_s3 - PCI func to suspend SLI-3 device for power mgmnt
+ * @pdev: pointer to PCI device
+ * @msg: power management message
+ *
+ * This routine is to be called from the kernel's PCI subsystem to support
+ * system Power Management (PM) to device with SLI-3 interface spec. When
+ * PM invokes this method, it quiesces the device by stopping the driver's
+ * worker thread for the device, turning off device's interrupt and DMA,
+ * and bring the device offline. Note that as the driver implements the
+ * minimum PM requirements to a power-aware driver's PM support for the
+ * suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE, FREEZE)
+ * to the suspend() method call will be treated as SUSPEND and the driver will
+ * fully reinitialize its device during resume() method call, the driver will
+ * set device to PCI_D3hot state in PCI config space instead of setting it
+ * according to the @msg provided by the PM.
+ *
+ * Return code
+ * 	0 - driver suspended the device
+ * 	Error otherwise
+ **/
+static int
+lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	/* Reset interrupt management states */
-	phba->intr_type = NONE;
-	phba->sli.slistat.sli_intr = 0;
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0473 PCI device Power Management suspend.\n");
 
-	return;
+	/* Bring down the device */
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+	kthread_stop(phba->worker_thread);
+
+	/* Disable interrupt from device */
+	lpfc_sli_disable_intr(phba);
+
+	/* Save device state to PCI config space */
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
 }
 
 /**
- * lpfc_unset_hba - Unset SLI3 hba device initialization
- * @phba: pointer to lpfc hba data structure.
+ * lpfc_pci_resume_one_s3 - PCI func to resume SLI-3 device for power mgmnt
+ * @pdev: pointer to PCI device
  *
- * This routine is invoked to unset the HBA device initialization steps to
- * a device with SLI-3 interface spec.
+ * This routine is to be called from the kernel's PCI subsystem to support
+ * system Power Management (PM) to device with SLI-3 interface spec. When PM
+ * invokes this method, it restores the device's PCI config space state and
+ * fully reinitializes the device and brings it online. Note that as the
+ * driver implements the minimum PM requirements to a power-aware driver's
+ * PM for suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE,
+ * FREEZE) to the suspend() method call will be treated as SUSPEND and the
+ * driver will fully reinitialize its device during resume() method call,
+ * the device will be set to PCI_D0 directly in PCI config space before
+ * restoring the state.
+ *
+ * Return code
+ * 	0 - driver suspended the device
+ * 	Error otherwise
  **/
-static void
-lpfc_unset_hba(struct lpfc_hba *phba)
+static int
+lpfc_pci_resume_one_s3(struct pci_dev *pdev)
 {
-	struct lpfc_vport *vport = phba->pport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	uint32_t intr_mode;
+	int error;
 
-	spin_lock_irq(shost->host_lock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(shost->host_lock);
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0452 PCI device Power Management resume.\n");
 
-	lpfc_stop_hba_timers(phba);
+	/* Restore device state from PCI config space */
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	if (pdev->is_busmaster)
+		pci_set_master(pdev);
 
-	phba->pport->work_port_events = 0;
+	/* Startup the kernel thread for this host adapter. */
+	phba->worker_thread = kthread_run(lpfc_do_work, phba,
+					"lpfc_worker_%d", phba->brd_no);
+	if (IS_ERR(phba->worker_thread)) {
+		error = PTR_ERR(phba->worker_thread);
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0434 PM resume failed to start worker "
+				"thread: error=x%x.\n", error);
+		return error;
+	}
 
-	lpfc_sli_hba_down(phba);
+	/* Configure and enable interrupt */
+	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
+	if (intr_mode == LPFC_INTR_ERROR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0430 PM resume Failed to enable interrupt\n");
+		return -EIO;
+	} else
+		phba->intr_mode = intr_mode;
 
+	/* Restart HBA and bring it online */
 	lpfc_sli_brdrestart(phba);
+	lpfc_online(phba);
+
+	/* Log the current active interrupt mode */
+	lpfc_log_intr_mode(phba, phba->intr_mode);
+
+	return 0;
+}
+
+/**
+ * lpfc_io_error_detected_s3 - Method for handling SLI-3 device PCI I/O error
+ * @pdev: pointer to PCI device.
+ * @state: the current PCI connection state.
+ *
+ * This routine is called from the PCI subsystem for I/O error handling to
+ * device with SLI-3 interface spec. This function is called by the PCI
+ * subsystem after a PCI bus error affecting this device has been detected.
+ * When this function is invoked, it will need to stop all the I/Os and
+ * interrupt(s) to the device. Once that is done, it will return
+ * PCI_ERS_RESULT_NEED_RESET for the PCI subsystem to perform proper recovery
+ * as desired.
+ *
+ * Return codes
+ * 	PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
+ * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ **/
+static pci_ers_result_t
+lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+
+	if (state == pci_channel_io_perm_failure) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0472 PCI channel I/O permanent failure\n");
+		/* Block all SCSI devices' I/Os on the host */
+		lpfc_scsi_dev_block(phba);
+		/* Clean up all driver's outstanding SCSI I/Os */
+		lpfc_sli_flush_fcp_rings(phba);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_disable_device(pdev);
+	/*
+	 * There may be I/Os dropped by the firmware.
+	 * Error iocb (I/O) on txcmplq and let the SCSI layer
+	 * retry it after re-establishing link.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
 
+	/* Disable interrupt */
 	lpfc_sli_disable_intr(phba);
 
-	return;
+	/* Request a slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
 }
 
 /**
- * lpfc_pci_probe_one_s3 - PCI probe func to reg SLI-3 device to PCI subsystem.
+ * lpfc_io_slot_reset_s3 - Method for restarting PCI SLI-3 device from scratch.
+ * @pdev: pointer to PCI device.
+ *
+ * This routine is called from the PCI subsystem for error handling to
+ * device with SLI-3 interface spec. This is called after PCI bus has been
+ * reset to restart the PCI card from scratch, as if from a cold-boot.
+ * During the PCI subsystem error recovery, after driver returns
+ * PCI_ERS_RESULT_NEED_RESET, the PCI subsystem will perform proper error
+ * recovery and then call this routine before calling the .resume method
+ * to recover the device. This function will initialize the HBA device,
+ * enable the interrupt, but it will just put the HBA to offline state
+ * without passing any I/O traffic.
+ *
+ * Return codes
+ * 	PCI_ERS_RESULT_RECOVERED - the device has been recovered
+ * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ */
+static pci_ers_result_t
+lpfc_io_slot_reset_s3(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	struct lpfc_sli *psli = &phba->sli;
+	uint32_t intr_mode;
+
+	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	if (pci_enable_device_mem(pdev)) {
+		printk(KERN_ERR "lpfc: Cannot re-enable "
+			"PCI device after reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_restore_state(pdev);
+	if (pdev->is_busmaster)
+		pci_set_master(pdev);
+
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Configure and enable interrupt */
+	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
+	if (intr_mode == LPFC_INTR_ERROR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0427 Cannot re-enable interrupt after "
+				"slot reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	} else
+		phba->intr_mode = intr_mode;
+
+	/* Take device offline; this will perform cleanup */
+	lpfc_offline(phba);
+	lpfc_sli_brdrestart(phba);
+
+	/* Log the current active interrupt mode */
+	lpfc_log_intr_mode(phba, phba->intr_mode);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ * lpfc_io_resume_s3 - Method for resuming PCI I/O operation on SLI-3 device.
+ * @pdev: pointer to PCI device
+ *
+ * This routine is called from the PCI subsystem for error handling to device
+ * with SLI-3 interface spec. It is called when kernel error recovery tells
+ * the lpfc driver that it is ok to resume normal PCI operation after PCI bus
+ * error recovery. After this call, traffic can start to flow from this device
+ * again.
+ */
+static void
+lpfc_io_resume_s3(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	lpfc_online(phba);
+}
+
+/**
+ * lpfc_sli4_get_els_iocb_cnt - Calculate the # of ELS IOCBs to reserve
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * returns the number of ELS/CT IOCBs to reserve
+ **/
+int
+lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
+{
+	int max_xri = phba->sli4_hba.max_cfg_param.max_xri;
+
+	if (max_xri <= 100)
+		return 4;
+	else if (max_xri <= 256)
+		return 8;
+	else if (max_xri <= 512)
+		return 16;
+	else if (max_xri <= 1024)
+		return 32;
+	else
+		return 48;
+}
+
+/**
+ * lpfc_pci_probe_one_s4 - PCI probe func to reg SLI-4 device to PCI subsys
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
  *
- * This routine is to be called to attach a device with SLI-3 interface spec
- * to the PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
+ * This routine is called from the kernel's PCI subsystem to device with
+ * SLI-4 interface spec. When an Emulex HBA with SLI-4 interface spec is
  * presented on PCI bus, the kernel PCI subsystem looks at PCI device-specific
- * information of the device and driver to see if the driver state that it can
- * support this kind of device. If the match is successful, the driver core
- * invokes this routine. If this routine determines it can claim the HBA, it
- * does all the initialization that it needs to do to handle the HBA properly.
+ * information of the device and driver to see if the driver state that it
+ * can support this kind of device. If the match is successful, the driver
+ * core invokes this routine. If this routine determines it can claim the HBA,
+ * it does all the initialization that it needs to do to handle the HBA
+ * properly.
  *
  * Return code
  * 	0 - driver can claim the device
  * 	negative value - driver can not claim the device
  **/
 static int __devinit
-lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
+lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	int error;
 	uint32_t cfg_mode, intr_mode;
+	int mcnt;
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);


