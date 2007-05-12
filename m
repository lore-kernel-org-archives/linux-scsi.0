From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/19] ipr: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:42 +0900 (JST)
Message-ID: <20070512182921I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55473 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbXELKFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This converts ipr to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ipr.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 8390bce..8002ecc 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -550,12 +550,7 @@ struct ipr_cmnd *ipr_get_free_ipr_cmnd(s
 static void ipr_unmap_sglist(struct ipr_ioa_cfg *ioa_cfg,
 			     struct ipr_cmnd *ipr_cmd)
 {
-	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
-
-	if (ipr_cmd->dma_use_sg)
-		pci_unmap_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
-			     scsi_cmd->use_sg,
-			     scsi_cmd->sc_data_direction);
+	scsi_dma_unmap(&ioa_cfg->pdev->dev, ipr_cmd->scsi_cmd);
 }
 
 /**
@@ -4279,20 +4274,18 @@ static int ipr_build_ioadl(struct ipr_io
 			   struct ipr_cmnd *ipr_cmd)
 {
 	int i, nseg;
-	struct scatterlist *sglist;
+	struct scatterlist *sg;
 	u32 length;
 	u32 ioadl_flags = 0;
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 
-	length = scsi_cmd->request_bufflen;
+	length = scsi_bufflen(scsi_cmd);
 	if (!length)
 		return 0;
 
-	nseg = pci_map_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
-			  scsi_cmd->use_sg, scsi_cmd->sc_data_direction);
-
+	nseg = scsi_dma_map(&ioa_cfg->pdev->dev, scsi_cmd);
 	if (nseg < 0) {
 		dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
 		return -1;
@@ -4313,8 +4306,6 @@ static int ipr_build_ioadl(struct ipr_io
 			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
 	}
 
-	sglist = scsi_cmd->request_buffer;
-
 	if (ipr_cmd->dma_use_sg <= ARRAY_SIZE(ioarcb->add_data.u.ioadl)) {
 		ioadl = ioarcb->add_data.u.ioadl;
 		ioarcb->write_ioadl_addr =
@@ -4323,11 +4314,10 @@ static int ipr_build_ioadl(struct ipr_io
 		ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
 	}
 
-	for (i = 0; i < ipr_cmd->dma_use_sg; i++) {
+	scsi_for_each_sg(scsi_cmd, sg, ipr_cmd->dma_use_sg, i) {
 		ioadl[i].flags_and_data_len =
-			cpu_to_be32(ioadl_flags | sg_dma_len(&sglist[i]));
-		ioadl[i].address =
-			cpu_to_be32(sg_dma_address(&sglist[i]));
+			cpu_to_be32(ioadl_flags | sg_dma_len(sg));
+		ioadl[i].address = cpu_to_be32(sg_dma_address(sg));
 	}
 
 	ioadl[i-1].flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
@@ -4793,7 +4783,7 @@ static void ipr_scsi_done(struct ipr_cmn
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
 
-	scsi_cmd->resid = be32_to_cpu(ipr_cmd->ioasa.residual_data_len);
+	scsi_resid(scsi_cmd) = be32_to_cpu(ipr_cmd->ioasa.residual_data_len);
 
 	if (likely(IPR_IOASC_SENSE_KEY(ioasc) == 0)) {
 		ipr_unmap_sglist(ioa_cfg, ipr_cmd);
-- 
1.4.3.2

