From: Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 2.6.7-mm3] ipr: minor fixes and assorted nit
Date: Tue, 29 Jun 2004 23:59:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040629235940.A6183@electric-eye.fr.zoreil.com>
References: <20040628140721.GA10393@devserv.devel.redhat.com> <40E05F43.7040602@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55194 "EHLO
	fr.zoreil.com") by vger.kernel.org with ESMTP id S266079AbUF2WCt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 18:02:49 -0400
Content-Disposition: inline
In-Reply-To: <40E05F43.7040602@us.ibm.com>; from brking@us.ibm.com on Mon, Jun 28, 2004 at 01:11:15PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

- balance pci_enable_device() with pci_disable_device() where appropriate;
- pci_release_regions() replaces release_mem_region();
- ipr_alloc_mem() can not simply issue a call to ipr_free_mem() when
  something goes wrong as it would lead to pci_free_consistent() of
  unset data. Let ipr_alloc_mem() carefully release whatever it has
  allocated instead;
- no need to memset(..., 0, ...) an area returned by pci_alloc_consistent;
- ipr_probe_ioa:
  + DMA_32BIT_MASK for all;
  + error path rework (includes bug fix when ipr_alloc_mem fails);
- ipr_init() can fail: return adequate status code.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

diff -puN drivers/scsi/ipr.c~ipr-00 drivers/scsi/ipr.c
--- linux-2.6.7/drivers/scsi/ipr.c~ipr-00	2004-06-29 22:29:29.000000000 +0200
+++ linux-2.6.7-fr/drivers/scsi/ipr.c	2004-06-29 23:36:49.000000000 +0200
@@ -5437,13 +5437,15 @@ static void ipr_free_mem(struct ipr_ioa_
  **/
 static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
 {
+	struct pci_dev *pdev = ioa_cfg->pdev;
+
 	ENTER;
-	free_irq(ioa_cfg->pdev->irq, ioa_cfg);
+	free_irq(pdev->irq, ioa_cfg);
 	iounmap((void *) ioa_cfg->hdw_dma_regs);
-	release_mem_region(ioa_cfg->hdw_dma_regs_pci,
-			   pci_resource_len(ioa_cfg->pdev, 0));
+	pci_release_regions(pdev);
 	ipr_free_mem(ioa_cfg);
 	scsi_host_put(ioa_cfg->host);
+	pci_disable_device(pdev);
 	LEAVE;
 }
 
@@ -5508,14 +5510,15 @@ static int __devinit ipr_alloc_cmd_blks(
  **/
 static int __devinit ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int i;
+	struct pci_dev *pdev = ioa_cfg->pdev;
+	int i, rc = -ENOMEM;
 
 	ENTER;
 	ioa_cfg->res_entries = kmalloc(sizeof(struct ipr_resource_entry) *
 				       IPR_MAX_PHYSICAL_DEVS, GFP_KERNEL);
 
 	if (!ioa_cfg->res_entries)
-		goto cleanup;
+		goto out;
 
 	memset(ioa_cfg->res_entries, 0,
 	       sizeof(struct ipr_resource_entry) * IPR_MAX_PHYSICAL_DEVS);
@@ -5528,24 +5531,24 @@ static int __devinit ipr_alloc_mem(struc
 						&ioa_cfg->vpd_cbs_dma);
 
 	if (!ioa_cfg->vpd_cbs)
-		goto cleanup;
+		goto out_free_res_entries;
 
 	if (ipr_alloc_cmd_blks(ioa_cfg))
-		goto cleanup;
+		goto out_free_vpd_cbs;
 
 	ioa_cfg->host_rrq = pci_alloc_consistent(ioa_cfg->pdev,
 						 sizeof(u32) * IPR_NUM_CMD_BLKS,
 						 &ioa_cfg->host_rrq_dma);
 
 	if (!ioa_cfg->host_rrq)
-		goto cleanup;
+		goto out_ipr_free_cmd_blocks;
 
 	ioa_cfg->cfg_table = pci_alloc_consistent(ioa_cfg->pdev,
 						  sizeof(struct ipr_config_table),
 						  &ioa_cfg->cfg_table_dma);
 
 	if (!ioa_cfg->cfg_table)
-		goto cleanup;
+		goto out_free_host_rrq;
 
 	for (i = 0; i < IPR_NUM_HCAMS; i++) {
 		ioa_cfg->hostrcb[i] = pci_alloc_consistent(ioa_cfg->pdev,
@@ -5553,9 +5556,8 @@ static int __devinit ipr_alloc_mem(struc
 							   &ioa_cfg->hostrcb_dma[i]);
 
 		if (!ioa_cfg->hostrcb[i])
-			goto cleanup;
+			goto out_free_hostrcb_dma;
 
-		memset(ioa_cfg->hostrcb[i], 0, sizeof(struct ipr_hostrcb));
 		ioa_cfg->hostrcb[i]->hostrcb_dma =
 			ioa_cfg->hostrcb_dma[i] + offsetof(struct ipr_hostrcb, hcam);
 		list_add_tail(&ioa_cfg->hostrcb[i]->queue, &ioa_cfg->hostrcb_free_q);
@@ -5565,19 +5567,35 @@ static int __devinit ipr_alloc_mem(struc
 				 IPR_NUM_TRACE_ENTRIES, GFP_KERNEL);
 
 	if (!ioa_cfg->trace)
-		goto cleanup;
+		goto out_free_hostrcb_dma;
 
 	memset(ioa_cfg->trace, 0,
 	       sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES);
 
+	rc = 0;
+out:
 	LEAVE;
-	return 0;
-
-cleanup:
-	ipr_free_mem(ioa_cfg);
+	return rc;
 
-	LEAVE;
-	return -ENOMEM;
+out_free_hostrcb_dma:
+	while (i-- > 0) {
+		pci_free_consistent(pdev, sizeof(struct ipr_hostrcb),
+				    ioa_cfg->hostrcb[i],
+				    ioa_cfg->hostrcb_dma[i]);
+	}
+	pci_free_consistent(pdev, sizeof(struct ipr_config_table),
+			    ioa_cfg->cfg_table, ioa_cfg->cfg_table_dma);
+out_free_host_rrq:
+	pci_free_consistent(pdev, sizeof(u32) * IPR_NUM_CMD_BLKS,
+			    ioa_cfg->host_rrq, ioa_cfg->host_rrq_dma);
+out_ipr_free_cmd_blocks:
+	ipr_free_cmd_blks(ioa_cfg);
+out_free_vpd_cbs:
+	pci_free_consistent(pdev, sizeof(struct ipr_misc_cbs),
+			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
+out_free_res_entries:
+	kfree(ioa_cfg->res_entries);
+	goto out;
 }
 
 /**
@@ -5678,7 +5696,7 @@ static int __devinit ipr_probe_ioa(struc
 
 	if ((rc = pci_enable_device(pdev))) {
 		dev_err(&pdev->dev, "Cannot enable adapter\n");
-		return rc;
+		goto out;
 	}
 
 	dev_info(&pdev->dev, "Found IOA with IRQ: %d\n", pdev->irq);
@@ -5687,7 +5705,8 @@ static int __devinit ipr_probe_ioa(struc
 
 	if (!host) {
 		dev_err(&pdev->dev, "call to scsi_host_alloc failed!\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out_disable;
 	}
 
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
@@ -5697,12 +5716,11 @@ static int __devinit ipr_probe_ioa(struc
 
 	ipr_regs_pci = pci_resource_start(pdev, 0);
 
-	if (!request_mem_region(ipr_regs_pci,
-				pci_resource_len(pdev, 0), IPR_NAME)) {
+	rc = pci_request_regions(pdev, IPR_NAME);
+	if (rc < 0) {
 		dev_err(&pdev->dev,
 			"Couldn't register memory range of registers\n");
-		scsi_host_put(host);
-		return -ENOMEM;
+		goto out_scsi_host_put;
 	}
 
 	ipr_regs = (unsigned long)ioremap(ipr_regs_pci,
@@ -5711,9 +5729,8 @@ static int __devinit ipr_probe_ioa(struc
 	if (!ipr_regs) {
 		dev_err(&pdev->dev,
 			"Couldn't map memory range of registers\n");
-		release_mem_region(ipr_regs_pci, pci_resource_len(pdev, 0));
-		scsi_host_put(host);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out_release_regions;
 	}
 
 	ioa_cfg->hdw_dma_regs = ipr_regs;
@@ -5723,11 +5740,10 @@ static int __devinit ipr_probe_ioa(struc
 	ipr_init_ioa_cfg(ioa_cfg, host, pdev);
 
 	pci_set_master(pdev);
-	rc = pci_set_dma_mask(pdev, 0xffffffff);
 
-	if (rc != PCIBIOS_SUCCESSFUL) {
+	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "Failed to set PCI DMA mask\n");
-		rc = -EIO;
 		goto cleanup_nomem;
 	}
 
@@ -5755,8 +5771,12 @@ static int __devinit ipr_probe_ioa(struc
 	if ((rc = ipr_set_pcix_cmd_reg(ioa_cfg)))
 		goto cleanup_nomem;
 
-	if ((rc = ipr_alloc_mem(ioa_cfg)))
-		goto cleanup;
+	rc = ipr_alloc_mem(ioa_cfg);
+	if (rc < 0) {
+		dev_err(&pdev->dev,
+			"Couldn't allocate enough memory for device driver!\n");
+		goto cleanup_nomem;
+	}
 
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	rc = request_irq(pdev->irq, ipr_isr, SA_SHIRQ, IPR_NAME, ioa_cfg);
@@ -5772,18 +5792,20 @@ static int __devinit ipr_probe_ioa(struc
 	spin_unlock(&ipr_driver_lock);
 
 	LEAVE;
-	return 0;
+out:
+	return rc;
 
-cleanup:
-	dev_err(&pdev->dev, "Couldn't allocate enough memory for device driver!\n");
 cleanup_nolog:
 	ipr_free_mem(ioa_cfg);
 cleanup_nomem:
 	iounmap((void *) ipr_regs);
-	release_mem_region(ipr_regs_pci, pci_resource_len(pdev, 0));
+out_release_regions:
+	pci_release_regions(pdev);
+out_scsi_host_put:
 	scsi_host_put(host);
-
-	return rc;
+out_disable:
+	pci_disable_device(pdev);
+	goto out;
 }
 
 /**
@@ -6009,16 +6031,14 @@ static struct pci_driver ipr_driver = {
  * ipr_init - Module entry point
  *
  * Return value:
- * 	0 on success / non-zero on failure
+ * 	0 on success / negative value on failure
  **/
 static int __init ipr_init(void)
 {
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
-	pci_register_driver(&ipr_driver);
-
-	return 0;
+	return pci_module_init(&ipr_driver);
 }
 
 /**

_
