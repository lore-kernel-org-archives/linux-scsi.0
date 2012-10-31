From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/7] lpfc 8.3.36: Update DIF support for
 passthru/strip/insert
Date: Wed, 31 Oct 2012 14:44:49 -0400
Message-ID: <1351709089.957.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:15757 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2JaSpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:45:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update DIF support for passthru/strip/insert


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |    3 +++
 lpfc_scsi.c |   16 +++++++++++++++-
 lpfc_sli.c  |   16 ++++++++--------
 lpfc_sli.h  |    4 +++-
 4 files changed, 29 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-10-23 09:51:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-10-29 11:18:40.486033030 -0400
@@ -3219,6 +3219,9 @@ struct wqe_common {
 #define wqe_dif_SHIFT         0
 #define wqe_dif_MASK          0x00000003
 #define wqe_dif_WORD          word7
+#define LPFC_WQE_DIF_PASSTHRU	1
+#define LPFC_WQE_DIF_STRIP	2
+#define LPFC_WQE_DIF_INSERT	3
 #define wqe_ct_SHIFT          2
 #define wqe_ct_MASK           0x00000003
 #define wqe_ct_WORD           word7
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-10-29 11:18:35.053032906 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-10-29 11:18:40.501033031 -0400
@@ -3227,6 +3227,21 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc
 		}
 	}
 
+	switch (scsi_get_prot_op(scsi_cmnd)) {
+	case SCSI_PROT_WRITE_STRIP:
+	case SCSI_PROT_READ_STRIP:
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_STRIP;
+		break;
+	case SCSI_PROT_WRITE_INSERT:
+	case SCSI_PROT_READ_INSERT:
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_INSERT;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+	case SCSI_PROT_READ_PASS:
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_PASS;
+		break;
+	}
+
 	fcpdl = lpfc_bg_scsi_adjust_dl(phba, lpfc_cmd);
 
 	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
@@ -3236,7 +3251,6 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc
 	 * we need to set word 4 of IOCB here
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
-	lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF;
 
 	return 0;
 err:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-10-23 09:51:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-10-29 11:18:40.506033031 -0400
@@ -8068,10 +8068,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		       LPFC_WQE_LENLOC_WORD4);
 		bf_set(wqe_ebde_cnt, &wqe->fcp_iwrite.wqe_com, 0);
 		bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpPU);
-		if (iocbq->iocb_flag & LPFC_IO_DIF) {
-			iocbq->iocb_flag &= ~LPFC_IO_DIF;
-			bf_set(wqe_dif, &wqe->generic.wqe_com, 1);
-		}
 		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 1);
 		break;
 	case CMD_FCP_IREAD64_CR:
@@ -8091,10 +8087,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		       LPFC_WQE_LENLOC_WORD4);
 		bf_set(wqe_ebde_cnt, &wqe->fcp_iread.wqe_com, 0);
 		bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpPU);
-		if (iocbq->iocb_flag & LPFC_IO_DIF) {
-			iocbq->iocb_flag &= ~LPFC_IO_DIF;
-			bf_set(wqe_dif, &wqe->generic.wqe_com, 1);
-		}
 		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
 		break;
 	case CMD_FCP_ICMND64_CR:
@@ -8304,6 +8296,14 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		break;
 	}
 
+	if (iocbq->iocb_flag & LPFC_IO_DIF_PASS)
+		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
+	else if (iocbq->iocb_flag & LPFC_IO_DIF_STRIP)
+		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_STRIP);
+	else if (iocbq->iocb_flag & LPFC_IO_DIF_INSERT)
+		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_INSERT);
+	iocbq->iocb_flag &= ~(LPFC_IO_DIF_PASS | LPFC_IO_DIF_STRIP |
+			      LPFC_IO_DIF_INSERT);
 	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
 	bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
 	wqe->generic.wqe_com.abort_tag = abort_tag;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2012-10-29 11:18:40.517033031 -0400
@@ -69,7 +69,9 @@ struct lpfc_iocbq {
 #define LPFC_USE_FCPWQIDX	0x80    /* Submit to specified FCPWQ index */
 #define DSS_SECURITY_OP		0x100	/* security IO */
 #define LPFC_IO_ON_TXCMPLQ	0x200	/* The IO is still on the TXCMPLQ */
-#define LPFC_IO_DIF		0x400	/* T10 DIF IO */
+#define LPFC_IO_DIF_PASS	0x400	/* T10 DIF IO pass-thru prot */
+#define LPFC_IO_DIF_STRIP	0x800	/* T10 DIF IO strip prot */
+#define LPFC_IO_DIF_INSERT	0x1000	/* T10 DIF IO insert prot */
 
 #define LPFC_FIP_ELS_ID_MASK	0xc000	/* ELS_ID range 0-3, non-shifted mask */
 #define LPFC_FIP_ELS_ID_SHIFT	14



