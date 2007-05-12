From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 13/19] lpfc: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:44 +0900 (JST)
Message-ID: <20070512184036J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55499 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbXELKF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This converts lpfc to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   55 ++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4ffaa79..96120ec 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -175,7 +175,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	dma_addr_t physaddr;
 	uint32_t i, num_bde = 0;
-	int datadir = scsi_cmnd->sc_data_direction;
+	int nseg, datadir = scsi_cmnd->sc_data_direction;
 
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use
@@ -184,26 +184,22 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 	 * data bde entry.
 	 */
 	bpl += 2;
-	if (scsi_cmnd->use_sg) {
+	nseg = scsi_dma_map(&phba->pcidev->dev, scsi_cmnd);
+	if (nseg > 0) {
 		/*
 		 * The driver stores the segment count returned from pci_map_sg
 		 * because this a count of dma-mappings used to map the use_sg
 		 * pages.  They are not guaranteed to be the same for those
 		 * architectures that implement an IOMMU.
 		 */
-		sgel = (struct scatterlist *)scsi_cmnd->request_buffer;
-		lpfc_cmd->seg_cnt = dma_map_sg(&phba->pcidev->dev, sgel,
-						scsi_cmnd->use_sg, datadir);
-		if (lpfc_cmd->seg_cnt == 0)
-			return 1;
 
+		lpfc_cmd->seg_cnt = nseg;
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
 			printk(KERN_ERR "%s: Too many sg segments from "
 			       "dma_map_sg.  Config %d, seg_cnt %d",
 			       __FUNCTION__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
-			dma_unmap_sg(&phba->pcidev->dev, sgel,
-				     lpfc_cmd->seg_cnt, datadir);
+			scsi_dma_unmap(&phba->pcidev->dev, scsi_cmnd);
 			return 1;
 		}
 
@@ -213,7 +209,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 		 * single scsi command.  Just run through the seg_cnt and format
 		 * the bde's.
 		 */
-		for (i = 0; i < lpfc_cmd->seg_cnt; i++) {
+		scsi_for_each_sg(scsi_cmnd, sgel, nseg, i) {
 			physaddr = sg_dma_address(sgel);
 			bpl->addrLow = le32_to_cpu(putPaddrLow(physaddr));
 			bpl->addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
@@ -224,10 +220,10 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 				bpl->tus.f.bdeFlags = BUFF_USE_RCV;
 			bpl->tus.w = le32_to_cpu(bpl->tus.w);
 			bpl++;
-			sgel++;
 			num_bde++;
 		}
-	}
+	} else if (nseg < 0)
+		return 1;
 
 	/*
 	 * Finish initializing those IOCB fields that are dependent on the
@@ -240,7 +236,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 		(num_bde * sizeof (struct ulp_bde64));
 	iocb_cmd->ulpBdeCount = 1;
 	iocb_cmd->ulpLe = 1;
-	fcp_cmnd->fcpDl = be32_to_cpu(scsi_cmnd->request_bufflen);
+	fcp_cmnd->fcpDl = be32_to_cpu(scsi_bufflen(scsi_cmnd));
 	return 0;
 }
 
@@ -253,9 +249,8 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba
 	 * a request buffer, but did not request use_sg.  There is a third
 	 * case, but it does not require resource deallocation.
 	 */
-	if ((psb->seg_cnt > 0) && (psb->pCmd->use_sg))
-		dma_unmap_sg(&phba->pcidev->dev, psb->pCmd->request_buffer,
-			     psb->seg_cnt, psb->pCmd->sc_data_direction);
+	if (psb->seg_cnt > 0)
+		scsi_dma_unmap(&phba->pcidev->dev, psb->pCmd);
 }
 
 static void
@@ -316,14 +311,14 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 		}
 	}
 
-	cmnd->resid = 0;
+	scsi_resid(cmnd) = 0;
 	if (resp_info & RESID_UNDER) {
-		cmnd->resid = be32_to_cpu(fcprsp->rspResId);
+		scsi_resid(cmnd) = be32_to_cpu(fcprsp->rspResId);
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
 				"%d:0716 FCP Read Underrun, expected %d, "
 				"residual %d Data: x%x x%x x%x\n", phba->brd_no,
-				be32_to_cpu(fcpcmd->fcpDl), cmnd->resid,
+				be32_to_cpu(fcpcmd->fcpDl), scsi_resid(cmnd),
 				fcpi_parm, cmnd->cmnd[0], cmnd->underflow);
 
 		/*
@@ -333,15 +328,15 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 		 */
 		if ((cmnd->sc_data_direction == DMA_FROM_DEVICE) &&
 			fcpi_parm &&
-			(cmnd->resid != fcpi_parm)) {
+			(scsi_resid(cmnd) != fcpi_parm)) {
 			lpfc_printf_log(phba, KERN_WARNING,
 				LOG_FCP | LOG_FCP_ERROR,
 				"%d:0735 FCP Read Check Error and Underrun "
 				"Data: x%x x%x x%x x%x\n", phba->brd_no,
 				be32_to_cpu(fcpcmd->fcpDl),
-				cmnd->resid,
+				scsi_resid(cmnd),
 				fcpi_parm, cmnd->cmnd[0]);
-			cmnd->resid = cmnd->request_bufflen;
+			scsi_resid(cmnd) = scsi_bufflen(cmnd);
 			host_status = DID_ERROR;
 		}
 		/*
@@ -352,13 +347,13 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 		 */
 		if (!(resp_info & SNS_LEN_VALID) &&
 		    (scsi_status == SAM_STAT_GOOD) &&
-		    (cmnd->request_bufflen - cmnd->resid) < cmnd->underflow) {
+		    (scsi_bufflen(cmnd) - scsi_resid(cmnd) < cmnd->underflow)) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
 					"%d:0717 FCP command x%x residual "
 					"underrun converted to error "
 					"Data: x%x x%x x%x\n", phba->brd_no,
-					cmnd->cmnd[0], cmnd->request_bufflen,
-					cmnd->resid, cmnd->underflow);
+					cmnd->cmnd[0], scsi_bufflen(cmnd),
+					scsi_resid(cmnd), cmnd->underflow);
 
 			host_status = DID_ERROR;
 		}
@@ -367,7 +362,7 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 				"%d:0720 FCP command x%x residual "
 				"overrun error. Data: x%x x%x \n",
 				phba->brd_no, cmnd->cmnd[0],
-				cmnd->request_bufflen, cmnd->resid);
+				scsi_bufflen(cmnd), scsi_resid(cmnd));
 		host_status = DID_ERROR;
 
 	/*
@@ -383,7 +378,7 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 			be32_to_cpu(fcprsp->rspResId),
 			fcpi_parm, cmnd->cmnd[0]);
 		host_status = DID_ERROR;
-		cmnd->resid = cmnd->request_bufflen;
+		scsi_resid(cmnd) = scsi_bufflen(cmnd);
 	}
 
  out:
@@ -450,7 +445,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 				"SNS x%x x%x Data: x%x x%x\n",
 				phba->brd_no, cmd->device->id,
 				cmd->device->lun, cmd, cmd->result,
-				*lp, *(lp + 3), cmd->retries, cmd->resid);
+				*lp, *(lp + 3), cmd->retries, scsi_resid(cmd));
 	}
 
 	result = cmd->result;
@@ -559,7 +554,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 	 * bumping the bpl beyond the fcp_cmnd and fcp_rsp regions to the first
 	 * data bde entry.
 	 */
-	if (scsi_cmnd->use_sg) {
+	if (scsi_sg_count(scsi_cmnd)) {
 		if (datadir == DMA_TO_DEVICE) {
 			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
 			iocb_cmd->un.fcpi.fcpi_parm = 0;
@@ -570,7 +565,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 			iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			iocb_cmd->un.fcpi.fcpi_parm =
-				scsi_cmnd->request_bufflen;
+				scsi_bufflen(scsi_cmnd);
 			fcp_cmnd->fcpCntl3 = READ_DATA;
 			phba->fc4InputRequests++;
 		}
-- 
1.4.3.2

