From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ipr: Convert to generic DMA API
Date: Thu, 30 Oct 2014 17:27:08 -0500
Message-ID: <201410302227.s9UMR8qs008773@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:37956 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019AbaJ3W1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 18:27:13 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 30 Oct 2014 16:27:12 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id F292738C8039
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 18:20:30 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9UMRA4v61669618
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 22:27:10 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9UMR9VM008817
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 18:27:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, anton@samba.org


From: Anton Blanchard <anton@samba.org>

Even though the ipr driver is only used on PCI, convert it
to use the generic DMA API.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  103 +++++++++++++++++++++++++++--------------------------
 drivers/scsi/ipr.h |    2 -
 2 files changed, 54 insertions(+), 51 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_convert_to_generic_DMA_API drivers/scsi/ipr.c
--- scsi-queue/drivers/scsi/ipr.c~ipr_convert_to_generic_DMA_API	2014-10-30 17:15:26.135856602 -0500
+++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-10-30 17:15:26.144856521 -0500
@@ -3942,8 +3942,9 @@ static int ipr_update_ioa_ucode(struct i
 		return -EIO;
 	}
 
-	sglist->num_dma_sg = pci_map_sg(ioa_cfg->pdev, sglist->scatterlist,
-					sglist->num_sg, DMA_TO_DEVICE);
+	sglist->num_dma_sg = dma_map_sg(&ioa_cfg->pdev->dev,
+					sglist->scatterlist, sglist->num_sg,
+					DMA_TO_DEVICE);
 
 	if (!sglist->num_dma_sg) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -5585,7 +5586,7 @@ static int ipr_build_ioadl64(struct ipr_
 	nseg = scsi_dma_map(scsi_cmd);
 	if (nseg < 0) {
 		if (printk_ratelimit())
-			dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
+			dev_err(&ioa_cfg->pdev->dev, "scsi_dma_map failed!\n");
 		return -1;
 	}
 
@@ -5636,7 +5637,7 @@ static int ipr_build_ioadl(struct ipr_io
 
 	nseg = scsi_dma_map(scsi_cmd);
 	if (nseg < 0) {
-		dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
+		dev_err(&ioa_cfg->pdev->dev, "scsi_dma_map failed!\n");
 		return -1;
 	}
 
@@ -8431,7 +8432,7 @@ static int ipr_reset_ucode_download_done
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_sglist *sglist = ioa_cfg->ucode_sglist;
 
-	pci_unmap_sg(ioa_cfg->pdev, sglist->scatterlist,
+	dma_unmap_sg(&ioa_cfg->pdev->dev, sglist->scatterlist,
 		     sglist->num_sg, DMA_TO_DEVICE);
 
 	ipr_cmd->job_step = ipr_reset_alert;
@@ -8871,7 +8872,7 @@ static void ipr_free_cmd_blks(struct ipr
 
 	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
 		if (ioa_cfg->ipr_cmnd_list[i])
-			pci_pool_free(ioa_cfg->ipr_cmd_pool,
+			dma_pool_free(ioa_cfg->ipr_cmd_pool,
 				      ioa_cfg->ipr_cmnd_list[i],
 				      ioa_cfg->ipr_cmnd_list_dma[i]);
 
@@ -8879,7 +8880,7 @@ static void ipr_free_cmd_blks(struct ipr
 	}
 
 	if (ioa_cfg->ipr_cmd_pool)
-		pci_pool_destroy(ioa_cfg->ipr_cmd_pool);
+		dma_pool_destroy(ioa_cfg->ipr_cmd_pool);
 
 	kfree(ioa_cfg->ipr_cmnd_list);
 	kfree(ioa_cfg->ipr_cmnd_list_dma);
@@ -8900,25 +8901,24 @@ static void ipr_free_mem(struct ipr_ioa_
 	int i;
 
 	kfree(ioa_cfg->res_entries);
-	pci_free_consistent(ioa_cfg->pdev, sizeof(struct ipr_misc_cbs),
-			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
+	dma_free_coherent(&ioa_cfg->pdev->dev, sizeof(struct ipr_misc_cbs),
+			  ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
 	ipr_free_cmd_blks(ioa_cfg);
 
 	for (i = 0; i < ioa_cfg->hrrq_num; i++)
-		pci_free_consistent(ioa_cfg->pdev,
-					sizeof(u32) * ioa_cfg->hrrq[i].size,
-					ioa_cfg->hrrq[i].host_rrq,
-					ioa_cfg->hrrq[i].host_rrq_dma);
+		dma_free_coherent(&ioa_cfg->pdev->dev,
+				  sizeof(u32) * ioa_cfg->hrrq[i].size,
+				  ioa_cfg->hrrq[i].host_rrq,
+				  ioa_cfg->hrrq[i].host_rrq_dma);
 
-	pci_free_consistent(ioa_cfg->pdev, ioa_cfg->cfg_table_size,
-			    ioa_cfg->u.cfg_table,
-			    ioa_cfg->cfg_table_dma);
+	dma_free_coherent(&ioa_cfg->pdev->dev, ioa_cfg->cfg_table_size,
+			  ioa_cfg->u.cfg_table, ioa_cfg->cfg_table_dma);
 
 	for (i = 0; i < IPR_NUM_HCAMS; i++) {
-		pci_free_consistent(ioa_cfg->pdev,
-				    sizeof(struct ipr_hostrcb),
-				    ioa_cfg->hostrcb[i],
-				    ioa_cfg->hostrcb_dma[i]);
+		dma_free_coherent(&ioa_cfg->pdev->dev,
+				  sizeof(struct ipr_hostrcb),
+				  ioa_cfg->hostrcb[i],
+				  ioa_cfg->hostrcb_dma[i]);
 	}
 
 	ipr_free_dump(ioa_cfg);
@@ -8979,7 +8979,7 @@ static int ipr_alloc_cmd_blks(struct ipr
 	dma_addr_t dma_addr;
 	int i, entries_each_hrrq, hrrq_id = 0;
 
-	ioa_cfg->ipr_cmd_pool = pci_pool_create(IPR_NAME, ioa_cfg->pdev,
+	ioa_cfg->ipr_cmd_pool = dma_pool_create(IPR_NAME, &ioa_cfg->pdev->dev,
 						sizeof(struct ipr_cmnd), 512, 0);
 
 	if (!ioa_cfg->ipr_cmd_pool)
@@ -9029,7 +9029,7 @@ static int ipr_alloc_cmd_blks(struct ipr
 	}
 
 	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
-		ipr_cmd = pci_pool_alloc(ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
+		ipr_cmd = dma_pool_alloc(ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
 
 		if (!ipr_cmd) {
 			ipr_free_cmd_blks(ioa_cfg);
@@ -9100,9 +9100,10 @@ static int ipr_alloc_mem(struct ipr_ioa_
 		ioa_cfg->res_entries[i].ioa_cfg = ioa_cfg;
 	}
 
-	ioa_cfg->vpd_cbs = pci_alloc_consistent(ioa_cfg->pdev,
-						sizeof(struct ipr_misc_cbs),
-						&ioa_cfg->vpd_cbs_dma);
+	ioa_cfg->vpd_cbs = dma_alloc_coherent(&pdev->dev,
+					      sizeof(struct ipr_misc_cbs),
+					      &ioa_cfg->vpd_cbs_dma,
+					      GFP_KERNEL);
 
 	if (!ioa_cfg->vpd_cbs)
 		goto out_free_res_entries;
@@ -9111,13 +9112,14 @@ static int ipr_alloc_mem(struct ipr_ioa_
 		goto out_free_vpd_cbs;
 
 	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
-		ioa_cfg->hrrq[i].host_rrq = pci_alloc_consistent(ioa_cfg->pdev,
+		ioa_cfg->hrrq[i].host_rrq = dma_alloc_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
-					&ioa_cfg->hrrq[i].host_rrq_dma);
+					&ioa_cfg->hrrq[i].host_rrq_dma,
+					GFP_KERNEL);
 
 		if (!ioa_cfg->hrrq[i].host_rrq)  {
 			while (--i > 0)
-				pci_free_consistent(pdev,
+				dma_free_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
 					ioa_cfg->hrrq[i].host_rrq,
 					ioa_cfg->hrrq[i].host_rrq_dma);
@@ -9126,17 +9128,19 @@ static int ipr_alloc_mem(struct ipr_ioa_
 		ioa_cfg->hrrq[i].ioa_cfg = ioa_cfg;
 	}
 
-	ioa_cfg->u.cfg_table = pci_alloc_consistent(ioa_cfg->pdev,
-						    ioa_cfg->cfg_table_size,
-						    &ioa_cfg->cfg_table_dma);
+	ioa_cfg->u.cfg_table = dma_alloc_coherent(&pdev->dev,
+						  ioa_cfg->cfg_table_size,
+						  &ioa_cfg->cfg_table_dma,
+						  GFP_KERNEL);
 
 	if (!ioa_cfg->u.cfg_table)
 		goto out_free_host_rrq;
 
 	for (i = 0; i < IPR_NUM_HCAMS; i++) {
-		ioa_cfg->hostrcb[i] = pci_alloc_consistent(ioa_cfg->pdev,
-							   sizeof(struct ipr_hostrcb),
-							   &ioa_cfg->hostrcb_dma[i]);
+		ioa_cfg->hostrcb[i] = dma_alloc_coherent(&pdev->dev,
+							 sizeof(struct ipr_hostrcb),
+							 &ioa_cfg->hostrcb_dma[i],
+							 GFP_KERNEL);
 
 		if (!ioa_cfg->hostrcb[i])
 			goto out_free_hostrcb_dma;
@@ -9160,25 +9164,24 @@ out:
 
 out_free_hostrcb_dma:
 	while (i-- > 0) {
-		pci_free_consistent(pdev, sizeof(struct ipr_hostrcb),
-				    ioa_cfg->hostrcb[i],
-				    ioa_cfg->hostrcb_dma[i]);
-	}
-	pci_free_consistent(pdev, ioa_cfg->cfg_table_size,
-			    ioa_cfg->u.cfg_table,
-			    ioa_cfg->cfg_table_dma);
+		dma_free_coherent(&pdev->dev, sizeof(struct ipr_hostrcb),
+				  ioa_cfg->hostrcb[i],
+				  ioa_cfg->hostrcb_dma[i]);
+	}
+	dma_free_coherent(&pdev->dev, ioa_cfg->cfg_table_size,
+			  ioa_cfg->u.cfg_table, ioa_cfg->cfg_table_dma);
 out_free_host_rrq:
 	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
-		pci_free_consistent(pdev,
-				sizeof(u32) * ioa_cfg->hrrq[i].size,
-				ioa_cfg->hrrq[i].host_rrq,
-				ioa_cfg->hrrq[i].host_rrq_dma);
+		dma_free_coherent(&pdev->dev,
+				  sizeof(u32) * ioa_cfg->hrrq[i].size,
+				  ioa_cfg->hrrq[i].host_rrq,
+				  ioa_cfg->hrrq[i].host_rrq_dma);
 	}
 out_ipr_free_cmd_blocks:
 	ipr_free_cmd_blks(ioa_cfg);
 out_free_vpd_cbs:
-	pci_free_consistent(pdev, sizeof(struct ipr_misc_cbs),
-			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
+	dma_free_coherent(&pdev->dev, sizeof(struct ipr_misc_cbs),
+			  ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
 out_free_res_entries:
 	kfree(ioa_cfg->res_entries);
 	goto out;
@@ -9618,13 +9621,13 @@ static int ipr_probe_ioa(struct pci_dev 
 	ipr_init_regs(ioa_cfg);
 
 	if (ioa_cfg->sis64) {
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+		rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (rc < 0) {
 			dev_dbg(&pdev->dev, "Failed to set 64 bit PCI DMA mask\n");
-			rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+			rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		}
 	} else
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Failed to set PCI DMA mask\n");
diff -puN drivers/scsi/ipr.h~ipr_convert_to_generic_DMA_API drivers/scsi/ipr.h
--- scsi-queue/drivers/scsi/ipr.h~ipr_convert_to_generic_DMA_API	2014-10-30 17:15:26.138856575 -0500
+++ scsi-queue-bjking1/drivers/scsi/ipr.h	2014-10-30 17:15:26.148856485 -0500
@@ -1549,7 +1549,7 @@ struct ipr_ioa_cfg {
 	struct ipr_misc_cbs *vpd_cbs;
 	dma_addr_t vpd_cbs_dma;
 
-	struct pci_pool *ipr_cmd_pool;
+	struct dma_pool *ipr_cmd_pool;
 
 	struct ipr_cmnd *reset_cmd;
 	int (*reset) (struct ipr_cmnd *);
_

