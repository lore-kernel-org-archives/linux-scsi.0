From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/19] ipr: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:42 +0900 (JST)
Message-ID: <20070512182919T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55464 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbXELKFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ipr.c |  122 +++++++++++++++++----------------------------------
 1 files changed, 41 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 4baa79e..8390bce 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -552,17 +552,10 @@ static void ipr_unmap_sglist(struct ipr_
 {
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 
-	if (ipr_cmd->dma_use_sg) {
-		if (scsi_cmd->use_sg > 0) {
-			pci_unmap_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
-				     scsi_cmd->use_sg,
-				     scsi_cmd->sc_data_direction);
-		} else {
-			pci_unmap_single(ioa_cfg->pdev, ipr_cmd->dma_handle,
-					 scsi_cmd->request_bufflen,
-					 scsi_cmd->sc_data_direction);
-		}
-	}
+	if (ipr_cmd->dma_use_sg)
+		pci_unmap_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
+			     scsi_cmd->use_sg,
+			     scsi_cmd->sc_data_direction);
 }
 
 /**
@@ -4285,7 +4278,7 @@ static irqreturn_t ipr_isr(int irq, void
 static int ipr_build_ioadl(struct ipr_ioa_cfg *ioa_cfg,
 			   struct ipr_cmnd *ipr_cmd)
 {
-	int i;
+	int i, nseg;
 	struct scatterlist *sglist;
 	u32 length;
 	u32 ioadl_flags = 0;
@@ -4294,84 +4287,51 @@ static int ipr_build_ioadl(struct ipr_io
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 
 	length = scsi_cmd->request_bufflen;
-
-	if (length == 0)
+	if (!length)
 		return 0;
 
-	if (scsi_cmd->use_sg) {
-		ipr_cmd->dma_use_sg = pci_map_sg(ioa_cfg->pdev,
-						 scsi_cmd->request_buffer,
-						 scsi_cmd->use_sg,
-						 scsi_cmd->sc_data_direction);
-
-		if (scsi_cmd->sc_data_direction == DMA_TO_DEVICE) {
-			ioadl_flags = IPR_IOADL_FLAGS_WRITE;
-			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
-			ioarcb->write_data_transfer_length = cpu_to_be32(length);
-			ioarcb->write_ioadl_len =
-				cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
-		} else if (scsi_cmd->sc_data_direction == DMA_FROM_DEVICE) {
-			ioadl_flags = IPR_IOADL_FLAGS_READ;
-			ioarcb->read_data_transfer_length = cpu_to_be32(length);
-			ioarcb->read_ioadl_len =
-				cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
-		}
+	nseg = pci_map_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
+			  scsi_cmd->use_sg, scsi_cmd->sc_data_direction);
 
-		sglist = scsi_cmd->request_buffer;
+	if (nseg < 0) {
+		dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
+		return -1;
+	}
 
-		if (ipr_cmd->dma_use_sg <= ARRAY_SIZE(ioarcb->add_data.u.ioadl)) {
-			ioadl = ioarcb->add_data.u.ioadl;
-			ioarcb->write_ioadl_addr =
-				cpu_to_be32(be32_to_cpu(ioarcb->ioarcb_host_pci_addr) +
-					    offsetof(struct ipr_ioarcb, add_data));
-			ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
-		}
+	ipr_cmd->dma_use_sg = nseg;
 
-		for (i = 0; i < ipr_cmd->dma_use_sg; i++) {
-			ioadl[i].flags_and_data_len =
-				cpu_to_be32(ioadl_flags | sg_dma_len(&sglist[i]));
-			ioadl[i].address =
-				cpu_to_be32(sg_dma_address(&sglist[i]));
-		}
+	if (scsi_cmd->sc_data_direction == DMA_TO_DEVICE) {
+		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
+		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
+		ioarcb->write_data_transfer_length = cpu_to_be32(length);
+		ioarcb->write_ioadl_len =
+			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
+	} else if (scsi_cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		ioadl_flags = IPR_IOADL_FLAGS_READ;
+		ioarcb->read_data_transfer_length = cpu_to_be32(length);
+		ioarcb->read_ioadl_len =
+			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
+	}
 
-		if (likely(ipr_cmd->dma_use_sg)) {
-			ioadl[i-1].flags_and_data_len |=
-				cpu_to_be32(IPR_IOADL_FLAGS_LAST);
-			return 0;
-		} else
-			dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
-	} else {
-		if (scsi_cmd->sc_data_direction == DMA_TO_DEVICE) {
-			ioadl_flags = IPR_IOADL_FLAGS_WRITE;
-			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
-			ioarcb->write_data_transfer_length = cpu_to_be32(length);
-			ioarcb->write_ioadl_len = cpu_to_be32(sizeof(struct ipr_ioadl_desc));
-		} else if (scsi_cmd->sc_data_direction == DMA_FROM_DEVICE) {
-			ioadl_flags = IPR_IOADL_FLAGS_READ;
-			ioarcb->read_data_transfer_length = cpu_to_be32(length);
-			ioarcb->read_ioadl_len = cpu_to_be32(sizeof(struct ipr_ioadl_desc));
-		}
+	sglist = scsi_cmd->request_buffer;
 
-		ipr_cmd->dma_handle = pci_map_single(ioa_cfg->pdev,
-						     scsi_cmd->request_buffer, length,
-						     scsi_cmd->sc_data_direction);
-
-		if (likely(!pci_dma_mapping_error(ipr_cmd->dma_handle))) {
-			ioadl = ioarcb->add_data.u.ioadl;
-			ioarcb->write_ioadl_addr =
-				cpu_to_be32(be32_to_cpu(ioarcb->ioarcb_host_pci_addr) +
-					    offsetof(struct ipr_ioarcb, add_data));
-			ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
-			ipr_cmd->dma_use_sg = 1;
-			ioadl[0].flags_and_data_len =
-				cpu_to_be32(ioadl_flags | length | IPR_IOADL_FLAGS_LAST);
-			ioadl[0].address = cpu_to_be32(ipr_cmd->dma_handle);
-			return 0;
-		} else
-			dev_err(&ioa_cfg->pdev->dev, "pci_map_single failed!\n");
+	if (ipr_cmd->dma_use_sg <= ARRAY_SIZE(ioarcb->add_data.u.ioadl)) {
+		ioadl = ioarcb->add_data.u.ioadl;
+		ioarcb->write_ioadl_addr =
+			cpu_to_be32(be32_to_cpu(ioarcb->ioarcb_host_pci_addr) +
+				    offsetof(struct ipr_ioarcb, add_data));
+		ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
 	}
 
-	return -1;
+	for (i = 0; i < ipr_cmd->dma_use_sg; i++) {
+		ioadl[i].flags_and_data_len =
+			cpu_to_be32(ioadl_flags | sg_dma_len(&sglist[i]));
+		ioadl[i].address =
+			cpu_to_be32(sg_dma_address(&sglist[i]));
+	}
+
+	ioadl[i-1].flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
+	return 0;
 }
 
 /**
-- 
1.4.3.2

