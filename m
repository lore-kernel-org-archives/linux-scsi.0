From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 11/19] qla2xxx: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:43 +0900 (JST)
Message-ID: <20070512183903A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44911 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbXELKF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This converts qla2xxx to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    4 +-
 drivers/scsi/qla2xxx/qla_iocb.c |   96 +++++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_isr.c  |   44 +++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   |    4 +-
 4 files changed, 61 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f6ed696..996c47a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1411,9 +1411,9 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd
 		printk("0x%02x ", cmd->cmnd[i]);
 	}
 	printk("\n  seg_cnt=%d, allowed=%d, retries=%d\n",
-	    cmd->use_sg, cmd->allowed, cmd->retries);
+	       scsi_sg_count(cmd), cmd->allowed, cmd->retries);
 	printk("  request buffer=0x%p, request buffer len=0x%x\n",
-	    cmd->request_buffer, cmd->request_bufflen);
+	       scsi_sglist(cmd), scsi_bufflen(cmd));
 	printk("  tag=%d, transfersize=0x%x\n",
 	    cmd->tag, cmd->transfersize);
 	printk("  serial_number=%lx, SP=%p\n", cmd->serial_number, sp);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 77a6f86..0fbc8b3 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -155,8 +155,8 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 	uint32_t	*cur_dsd;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
-	struct scatterlist *cur_seg;
-	struct scatterlist *end_seg;
+	struct scatterlist *sg;
+	int i;
 
 	cmd = sp->cmd;
 
@@ -165,7 +165,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 	    __constant_cpu_to_le32(COMMAND_TYPE);
 
 	/* No data transfer */
-	if (cmd->request_bufflen == 0 || cmd->sc_data_direction == DMA_NONE) {
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
 		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
 		return;
 	}
@@ -180,10 +180,8 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 
 	/* Load data segments */
 
-	cur_seg = (struct scatterlist *)cmd->request_buffer;
-	end_seg = cur_seg + tot_dsds;
-	while (cur_seg < end_seg) {
-		cont_entry_t	*cont_pkt;
+	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
+		cont_entry_t *cont_pkt;
 
 		/* Allocate additional continuation packets? */
 		if (avail_dsds == 0) {
@@ -196,11 +194,9 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 			avail_dsds = 7;
 		}
 
-		*cur_dsd++ = cpu_to_le32(sg_dma_address(cur_seg));
-		*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+		*cur_dsd++ = cpu_to_le32(sg_dma_address(sg));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
 		avail_dsds--;
-
-		cur_seg++;
 	}
 }
 
@@ -219,8 +215,8 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 	uint32_t	*cur_dsd;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
-	struct scatterlist *cur_seg;
-	struct scatterlist *end_seg;
+	struct scatterlist *sg;
+	int i;
 
 	cmd = sp->cmd;
 
@@ -229,7 +225,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 	    __constant_cpu_to_le32(COMMAND_A64_TYPE);
 
 	/* No data transfer */
-	if (cmd->request_bufflen == 0 || cmd->sc_data_direction == DMA_NONE) {
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
 		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
 		return;
 	}
@@ -243,9 +239,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 	cur_dsd = (uint32_t *)&cmd_pkt->dseg_0_address;
 
 	/* Load data segments */
-	cur_seg = (struct scatterlist *)cmd->request_buffer;
-	end_seg = cur_seg + tot_dsds;
-	while (cur_seg < end_seg) {
+	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
 		dma_addr_t	sle_dma;
 		cont_a64_entry_t *cont_pkt;
 
@@ -260,13 +254,11 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 			avail_dsds = 5;
 		}
 
-		sle_dma = sg_dma_address(cur_seg);
+		sle_dma = sg_dma_address(sg);
 		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
 		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
-		*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
 		avail_dsds--;
-
-		cur_seg++;
 	}
 }
 
@@ -279,7 +271,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 int
 qla2x00_start_scsi(srb_t *sp)
 {
-	int		ret;
+	int		ret, nseg;
 	unsigned long   flags;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
@@ -287,7 +279,6 @@ qla2x00_start_scsi(srb_t *sp)
 	uint32_t        index;
 	uint32_t	handle;
 	cmd_entry_t	*cmd_pkt;
-	struct scatterlist *sg;
 	uint16_t	cnt;
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
@@ -325,13 +316,10 @@ qla2x00_start_scsi(srb_t *sp)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-		    cmd->sc_data_direction);
-		if (tot_dsds == 0)
-			goto queuing_error;
-	}
+	nseg = scsi_dma_map(&ha->pdev->dev, cmd);
+	if (nseg < 0)
+		goto queuing_error;
+	tot_dsds = nseg;
 
 	/* Calculate the number of request entries needed. */
 	req_cnt = ha->isp_ops.calc_req_entries(tot_dsds);
@@ -369,7 +357,7 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
-	cmd_pkt->byte_count = cpu_to_le32((uint32_t)cmd->request_bufflen);
+	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
 
 	/* Build IOCB segments */
 	ha->isp_ops.build_iocbs(sp, cmd_pkt, tot_dsds);
@@ -401,11 +389,9 @@ qla2x00_start_scsi(srb_t *sp)
 	return (QLA_SUCCESS);
 
 queuing_error:
-	if (cmd->use_sg && tot_dsds) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
-		    cmd->sc_data_direction);
-	}
+	if (tot_dsds)
+		scsi_dma_unmap(&ha->pdev->dev, cmd);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (QLA_FUNCTION_FAILED);
@@ -617,8 +603,8 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 	uint32_t	*cur_dsd;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
-	struct	scatterlist *cur_seg;
-	struct	scatterlist *end_seg;
+	struct scatterlist *sg;
+	int i;
 
 	cmd = sp->cmd;
 
@@ -627,7 +613,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 	    __constant_cpu_to_le32(COMMAND_TYPE_7);
 
 	/* No data transfer */
-	if (cmd->request_bufflen == 0 || cmd->sc_data_direction == DMA_NONE) {
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
 		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
 		return;
 	}
@@ -648,9 +634,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 
 	/* Load data segments */
 
-	cur_seg = (struct scatterlist *)cmd->request_buffer;
-	end_seg = cur_seg + tot_dsds;
-	while (cur_seg < end_seg) {
+	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
 		dma_addr_t	sle_dma;
 		cont_a64_entry_t *cont_pkt;
 
@@ -665,13 +649,11 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 			avail_dsds = 5;
 		}
 
-		sle_dma = sg_dma_address(cur_seg);
+		sle_dma = sg_dma_address(sg);
 		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
 		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
-		*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
 		avail_dsds--;
-
-		cur_seg++;
 	}
 }
 
@@ -685,7 +667,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, stru
 int
 qla24xx_start_scsi(srb_t *sp)
 {
-	int		ret;
+	int		ret, nseg;
 	unsigned long   flags;
 	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
@@ -693,7 +675,6 @@ qla24xx_start_scsi(srb_t *sp)
 	uint32_t        index;
 	uint32_t	handle;
 	struct cmd_type_7 *cmd_pkt;
-	struct scatterlist *sg;
 	uint16_t	cnt;
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
@@ -731,13 +712,10 @@ qla24xx_start_scsi(srb_t *sp)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-		    cmd->sc_data_direction);
-		if (tot_dsds == 0)
+	nseg = scsi_dma_map(&ha->pdev->dev, cmd);
+	if (nseg < 0)
 			goto queuing_error;
-	}
+	tot_dsds = nseg;
 
 	req_cnt = qla24xx_calc_iocbs(tot_dsds);
 	if (ha->req_q_cnt < (req_cnt + 2)) {
@@ -780,7 +758,7 @@ qla24xx_start_scsi(srb_t *sp)
 	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
 	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
 
-	cmd_pkt->byte_count = cpu_to_le32((uint32_t)cmd->request_bufflen);
+	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
 
 	/* Build IOCB segments */
 	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds);
@@ -812,11 +790,9 @@ qla24xx_start_scsi(srb_t *sp)
 	return QLA_SUCCESS;
 
 queuing_error:
-	if (cmd->use_sg && tot_dsds) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
-		    cmd->sc_data_direction);
-	}
+	if (tot_dsds)
+		scsi_dma_unmap(&ha->pdev->dev, cmd);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ca46346..ccc1712 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -889,19 +889,19 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		}
 		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
 			resid = resid_len;
-			cp->resid = resid;
+			scsi_resid(cp) = resid;
 			CMD_RESID_LEN(cp) = resid;
 
 			if (!lscsi_status &&
-			    ((unsigned)(cp->request_bufflen - resid) <
+			    ((unsigned)(scsi_bufflen(cp) - resid) <
 			     cp->underflow)) {
 				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
-				    cp->request_bufflen);
+					   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+					   "detected (%x of %x bytes)...returning "
+					   "error status.\n", ha->host_no,
+					   cp->device->channel, cp->device->id,
+					   cp->device->lun, resid,
+					   scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16;
 				break;
@@ -963,7 +963,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			resid = fw_resid_len;
 
 		if (scsi_status & SS_RESIDUAL_UNDER) {
-			cp->resid = resid;
+			scsi_resid(cp) = resid;
 			CMD_RESID_LEN(cp) = resid;
 		} else {
 			DEBUG2(printk(KERN_INFO
@@ -1042,26 +1042,26 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			 */
 			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
 				DEBUG2(printk("scsi(%ld:%d:%d:%d) Dropped "
-				    "frame(s) detected (%x of %x bytes)..."
-				    "retrying command.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
-				    cp->request_bufflen));
+					      "frame(s) detected (%x of %x bytes)..."
+					      "retrying command.\n", ha->host_no,
+					      cp->device->channel, cp->device->id,
+					      cp->device->lun, resid,
+					      scsi_bufflen(cp)));
 
 				cp->result = DID_BUS_BUSY << 16;
 				break;
 			}
 
 			/* Handle mid-layer underflow */
-			if ((unsigned)(cp->request_bufflen - resid) <
+			if ((unsigned)(scsi_bufflen(cp) - resid) <
 			    cp->underflow) {
 				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
-				    cp->request_bufflen);
+					   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+					   "detected (%x of %x bytes)...returning "
+					   "error status.\n", ha->host_no,
+					   cp->device->channel, cp->device->id,
+					   cp->device->lun, resid,
+					   scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16;
 				break;
@@ -1084,7 +1084,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		DEBUG2(printk(KERN_INFO
 		    "PID=0x%lx req=0x%x xtra=0x%x -- returning DID_ERROR "
 		    "status!\n",
-		    cp->serial_number, cp->request_bufflen, resid_len));
+		    cp->serial_number, scsi_bufflen(cp), resid_len));
 
 		cp->result = DID_ERROR << 16;
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c00cc01..776db19 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2426,9 +2426,7 @@ qla2x00_sp_free_dma(scsi_qla_host_t *ha,
 	struct scsi_cmnd *cmd = sp->cmd;
 
 	if (sp->flags & SRB_DMA_VALID) {
-		if (cmd->use_sg)
-			dma_unmap_sg(&ha->pdev->dev, cmd->request_buffer,
-				     cmd->use_sg, cmd->sc_data_direction);
+		scsi_dma_unmap(&ha->pdev->dev, cmd);
 		sp->flags &= ~SRB_DMA_VALID;
 	}
 	CMD_SP(cmd) = NULL;
-- 
1.4.3.2

