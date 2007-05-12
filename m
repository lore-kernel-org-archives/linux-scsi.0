From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 10/19] qla2xxx: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:44 +0900 (JST)
Message-ID: <20070512183907J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44918 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbXELKGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:06:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla2xxx/qla_iocb.c |  192 +++++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_os.c   |    8 +-
 2 files changed, 76 insertions(+), 124 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c5b3c61..77a6f86 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -155,6 +155,8 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 	uint32_t	*cur_dsd;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
+	struct scatterlist *cur_seg;
+	struct scatterlist *end_seg;
 
 	cmd = sp->cmd;
 
@@ -177,35 +179,28 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 	cur_dsd = (uint32_t *)&cmd_pkt->dseg_0_address;
 
 	/* Load data segments */
-	if (cmd->use_sg != 0) {
-		struct	scatterlist *cur_seg;
-		struct	scatterlist *end_seg;
-
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		end_seg = cur_seg + tot_dsds;
-		while (cur_seg < end_seg) {
-			cont_entry_t	*cont_pkt;
-
-			/* Allocate additional continuation packets? */
-			if (avail_dsds == 0) {
-				/*
-				 * Seven DSDs are available in the Continuation
-				 * Type 0 IOCB.
-				 */
-				cont_pkt = qla2x00_prep_cont_type0_iocb(ha);
-				cur_dsd = (uint32_t *)&cont_pkt->dseg_0_address;
-				avail_dsds = 7;
-			}
-
-			*cur_dsd++ = cpu_to_le32(sg_dma_address(cur_seg));
-			*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
-			avail_dsds--;
-
-			cur_seg++;
+
+	cur_seg = (struct scatterlist *)cmd->request_buffer;
+	end_seg = cur_seg + tot_dsds;
+	while (cur_seg < end_seg) {
+		cont_entry_t	*cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			 * Seven DSDs are available in the Continuation
+			 * Type 0 IOCB.
+			 */
+			cont_pkt = qla2x00_prep_cont_type0_iocb(ha);
+			cur_dsd = (uint32_t *)&cont_pkt->dseg_0_address;
+			avail_dsds = 7;
 		}
-	} else {
-		*cur_dsd++ = cpu_to_le32(sp->dma_handle);
-		*cur_dsd++ = cpu_to_le32(cmd->request_bufflen);
+
+		*cur_dsd++ = cpu_to_le32(sg_dma_address(cur_seg));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+		avail_dsds--;
+
+		cur_seg++;
 	}
 }
 
@@ -224,6 +219,8 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 	uint32_t	*cur_dsd;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
+	struct scatterlist *cur_seg;
+	struct scatterlist *end_seg;
 
 	cmd = sp->cmd;
 
@@ -246,39 +243,30 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 	cur_dsd = (uint32_t *)&cmd_pkt->dseg_0_address;
 
 	/* Load data segments */
-	if (cmd->use_sg != 0) {
-		struct	scatterlist *cur_seg;
-		struct	scatterlist *end_seg;
-
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		end_seg = cur_seg + tot_dsds;
-		while (cur_seg < end_seg) {
-			dma_addr_t	sle_dma;
-			cont_a64_entry_t *cont_pkt;
-
-			/* Allocate additional continuation packets? */
-			if (avail_dsds == 0) {
-				/*
-				 * Five DSDs are available in the Continuation
-				 * Type 1 IOCB.
-				 */
-				cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
-				cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
-				avail_dsds = 5;
-			}
-
-			sle_dma = sg_dma_address(cur_seg);
-			*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
-			*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
-			*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
-			avail_dsds--;
-
-			cur_seg++;
+	cur_seg = (struct scatterlist *)cmd->request_buffer;
+	end_seg = cur_seg + tot_dsds;
+	while (cur_seg < end_seg) {
+		dma_addr_t	sle_dma;
+		cont_a64_entry_t *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			 * Five DSDs are available in the Continuation
+			 * Type 1 IOCB.
+			 */
+			cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
+			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
+			avail_dsds = 5;
 		}
-	} else {
-		*cur_dsd++ = cpu_to_le32(LSD(sp->dma_handle));
-		*cur_dsd++ = cpu_to_le32(MSD(sp->dma_handle));
-		*cur_dsd++ = cpu_to_le32(cmd->request_bufflen);
+
+		sle_dma = sg_dma_address(cur_seg);
+		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+		avail_dsds--;
+
+		cur_seg++;
 	}
 }
 
@@ -343,16 +331,6 @@ qla2x00_start_scsi(srb_t *sp)
 		    cmd->sc_data_direction);
 		if (tot_dsds == 0)
 			goto queuing_error;
-	} else if (cmd->request_bufflen) {
-		dma_addr_t	req_dma;
-
-		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
-		    cmd->request_bufflen, cmd->sc_data_direction);
-		if (dma_mapping_error(req_dma))
-			goto queuing_error;
-
-		sp->dma_handle = req_dma;
-		tot_dsds = 1;
 	}
 
 	/* Calculate the number of request entries needed. */
@@ -427,9 +405,6 @@ queuing_error:
 		sg = (struct scatterlist *) cmd->request_buffer;
 		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
 		    cmd->sc_data_direction);
-	} else if (tot_dsds) {
-		pci_unmap_single(ha->pdev, sp->dma_handle,
-		    cmd->request_bufflen, cmd->sc_data_direction);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -642,6 +617,8 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 	uint32_t	*cur_dsd;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
+	struct	scatterlist *cur_seg;
+	struct	scatterlist *end_seg;
 
 	cmd = sp->cmd;
 
@@ -670,39 +647,31 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 	cur_dsd = (uint32_t *)&cmd_pkt->dseg_0_address;
 
 	/* Load data segments */
-	if (cmd->use_sg != 0) {
-		struct	scatterlist *cur_seg;
-		struct	scatterlist *end_seg;
-
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		end_seg = cur_seg + tot_dsds;
-		while (cur_seg < end_seg) {
-			dma_addr_t	sle_dma;
-			cont_a64_entry_t *cont_pkt;
-
-			/* Allocate additional continuation packets? */
-			if (avail_dsds == 0) {
-				/*
-				 * Five DSDs are available in the Continuation
-				 * Type 1 IOCB.
-				 */
-				cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
-				cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
-				avail_dsds = 5;
-			}
-
-			sle_dma = sg_dma_address(cur_seg);
-			*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
-			*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
-			*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
-			avail_dsds--;
-
-			cur_seg++;
+
+	cur_seg = (struct scatterlist *)cmd->request_buffer;
+	end_seg = cur_seg + tot_dsds;
+	while (cur_seg < end_seg) {
+		dma_addr_t	sle_dma;
+		cont_a64_entry_t *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			 * Five DSDs are available in the Continuation
+			 * Type 1 IOCB.
+			 */
+			cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
+			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
+			avail_dsds = 5;
 		}
-	} else {
-		*cur_dsd++ = cpu_to_le32(LSD(sp->dma_handle));
-		*cur_dsd++ = cpu_to_le32(MSD(sp->dma_handle));
-		*cur_dsd++ = cpu_to_le32(cmd->request_bufflen);
+
+		sle_dma = sg_dma_address(cur_seg);
+		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+		avail_dsds--;
+
+		cur_seg++;
 	}
 }
 
@@ -768,16 +737,6 @@ qla24xx_start_scsi(srb_t *sp)
 		    cmd->sc_data_direction);
 		if (tot_dsds == 0)
 			goto queuing_error;
-	} else if (cmd->request_bufflen) {
-		dma_addr_t      req_dma;
-
-		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
-		    cmd->request_bufflen, cmd->sc_data_direction);
-		if (dma_mapping_error(req_dma))
-			goto queuing_error;
-
-		sp->dma_handle = req_dma;
-		tot_dsds = 1;
 	}
 
 	req_cnt = qla24xx_calc_iocbs(tot_dsds);
@@ -857,9 +816,6 @@ queuing_error:
 		sg = (struct scatterlist *) cmd->request_buffer;
 		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
 		    cmd->sc_data_direction);
-	} else if (tot_dsds) {
-		pci_unmap_single(ha->pdev, sp->dma_handle,
-		    cmd->request_bufflen, cmd->sc_data_direction);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dd076da..c00cc01 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2426,13 +2426,9 @@ qla2x00_sp_free_dma(scsi_qla_host_t *ha,
 	struct scsi_cmnd *cmd = sp->cmd;
 
 	if (sp->flags & SRB_DMA_VALID) {
-		if (cmd->use_sg) {
+		if (cmd->use_sg)
 			dma_unmap_sg(&ha->pdev->dev, cmd->request_buffer,
-			    cmd->use_sg, cmd->sc_data_direction);
-		} else if (cmd->request_bufflen) {
-			dma_unmap_single(&ha->pdev->dev, sp->dma_handle,
-			    cmd->request_bufflen, cmd->sc_data_direction);
-		}
+				     cmd->use_sg, cmd->sc_data_direction);
 		sp->flags &= ~SRB_DMA_VALID;
 	}
 	CMD_SP(cmd) = NULL;
-- 
1.4.3.2

