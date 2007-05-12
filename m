From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 12/19] lpfc: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:44 +0900 (JST)
Message-ID: <20070512184034Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44889 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXELKFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   52 +---------------------------------------
 1 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 9a12d05..4ffaa79 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -176,7 +176,6 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 	dma_addr_t physaddr;
 	uint32_t i, num_bde = 0;
 	int datadir = scsi_cmnd->sc_data_direction;
-	int dma_error;
 
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use
@@ -228,31 +227,6 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 			sgel++;
 			num_bde++;
 		}
-	} else if (scsi_cmnd->request_buffer && scsi_cmnd->request_bufflen) {
-		physaddr = dma_map_single(&phba->pcidev->dev,
-					  scsi_cmnd->request_buffer,
-					  scsi_cmnd->request_bufflen,
-					  datadir);
-		dma_error = dma_mapping_error(physaddr);
-		if (dma_error) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-				"%d:0718 Unable to dma_map_single "
-				"request_buffer: x%x\n",
-				phba->brd_no, dma_error);
-			return 1;
-		}
-
-		lpfc_cmd->nonsg_phys = physaddr;
-		bpl->addrLow = le32_to_cpu(putPaddrLow(physaddr));
-		bpl->addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
-		bpl->tus.f.bdeSize = scsi_cmnd->request_bufflen;
-		if (datadir == DMA_TO_DEVICE)
-			bpl->tus.f.bdeFlags = 0;
-		else
-			bpl->tus.f.bdeFlags = BUFF_USE_RCV;
-		bpl->tus.w = le32_to_cpu(bpl->tus.w);
-		num_bde = 1;
-		bpl++;
 	}
 
 	/*
@@ -279,16 +253,9 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba
 	 * a request buffer, but did not request use_sg.  There is a third
 	 * case, but it does not require resource deallocation.
 	 */
-	if ((psb->seg_cnt > 0) && (psb->pCmd->use_sg)) {
+	if ((psb->seg_cnt > 0) && (psb->pCmd->use_sg))
 		dma_unmap_sg(&phba->pcidev->dev, psb->pCmd->request_buffer,
-				psb->seg_cnt, psb->pCmd->sc_data_direction);
-	} else {
-		 if ((psb->nonsg_phys) && (psb->pCmd->request_bufflen)) {
-			dma_unmap_single(&phba->pcidev->dev, psb->nonsg_phys,
-						psb->pCmd->request_bufflen,
-						psb->pCmd->sc_data_direction);
-		 }
-	}
+			     psb->seg_cnt, psb->pCmd->sc_data_direction);
 }
 
 static void
@@ -607,21 +574,6 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 			fcp_cmnd->fcpCntl3 = READ_DATA;
 			phba->fc4InputRequests++;
 		}
-	} else if (scsi_cmnd->request_buffer && scsi_cmnd->request_bufflen) {
-		if (datadir == DMA_TO_DEVICE) {
-			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
-			iocb_cmd->un.fcpi.fcpi_parm = 0;
-			iocb_cmd->ulpPU = 0;
-			fcp_cmnd->fcpCntl3 = WRITE_DATA;
-			phba->fc4OutputRequests++;
-		} else {
-			iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
-			iocb_cmd->ulpPU = PARM_READ_CHECK;
-			iocb_cmd->un.fcpi.fcpi_parm =
-				scsi_cmnd->request_bufflen;
-			fcp_cmnd->fcpCntl3 = READ_DATA;
-			phba->fc4InputRequests++;
-		}
 	} else {
 		iocb_cmd->ulpCommand = CMD_FCP_ICMND64_CR;
 		iocb_cmd->un.fcpi.fcpi_parm = 0;
-- 
1.4.3.2

