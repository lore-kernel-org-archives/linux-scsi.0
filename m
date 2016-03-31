From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 4/9] lpfc: Utilize embedded CDB logic to minimize IO
 latency
Date: Thu, 31 Mar 2016 14:12:30 -0700
Message-ID: <56fd92be.Qxlfv4sdz+2Qgmw4%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36627 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbcCaVMe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:34 -0400
Received: by mail-pa0-f43.google.com with SMTP id tt10so74175645pab.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:34 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id w20sm15505654pfi.31.2016.03.31.14.12.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Utilize embedded CDB logic to minimize IO latency

Pass cmd iu payloads inline to adapter job structure rather than as
separate dma buffers.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc.h      |   1 +
 drivers/scsi/lpfc/lpfc_attr.c |   1 -
 drivers/scsi/lpfc/lpfc_hw4.h  |   6 ++
 drivers/scsi/lpfc/lpfc_init.c |  20 ++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 128 ++++++++++++++++++++++++++++++++++++------
 5 files changed, 136 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 90a3ca5..da237d9 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -694,6 +694,7 @@ struct lpfc_hba {
 	uint8_t  wwnn[8];
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
+	uint32_t fcp_embed_io;
 
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 343ae94..d4559a6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5150,7 +5150,6 @@ lpfc_free_sysfs_attr(struct lpfc_vport *vport)
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_ctlreg_attr);
 }
 
-
 /*
  * Dynamic FC Host Attributes Support
  */
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 608f941..aea00f8 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2865,6 +2865,9 @@ struct lpfc_sli4_parameters {
 	uint32_t word17;
 	uint32_t word18;
 	uint32_t word19;
+#define cfg_ext_embed_cb_SHIFT			0
+#define cfg_ext_embed_cb_MASK			0x00000001
+#define cfg_ext_embed_cb_WORD			word19
 };
 
 struct lpfc_mbx_get_sli4_parameters {
@@ -3919,6 +3922,9 @@ union lpfc_wqe {
 union lpfc_wqe128 {
 	uint32_t words[32];
 	struct lpfc_wqe_generic generic;
+	struct fcp_icmnd64_wqe fcp_icmd;
+	struct fcp_iread64_wqe fcp_iread;
+	struct fcp_iwrite64_wqe fcp_iwrite;
 	struct xmit_seq64_wqe xmit_sequence;
 	struct gen_req64_wqe gen_req;
 };
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f57d02c..f0d0852 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7264,8 +7264,15 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_cq[idx] = qdesc;
 
 		/* Create Fast Path FCP WQs */
-		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
-					      phba->sli4_hba.wq_ecount);
+		if (phba->fcp_embed_io) {
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      LPFC_WQE128_SIZE,
+						      LPFC_WQE128_DEF_COUNT);
+		} else {
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      phba->sli4_hba.wq_esize,
+						      phba->sli4_hba.wq_ecount);
+		}
 		if (!qdesc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0503 Failed allocate fast-path FCP "
@@ -9510,6 +9517,15 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
 		sli4_params->sge_supp_len = LPFC_MAX_SGE_SIZE;
 
+	/*
+	 * Issue IOs with CDB embedded in WQE to minimized the number
+	 * of DMAs the firmware has to do. Setting this to 1 also forces
+	 * the driver to use 128 bytes WQEs for FCP IOs.
+	 */
+	if (bf_get(cfg_ext_embed_cb, mbx_sli4_parameters))
+		phba->fcp_embed_io = 1;
+	else
+		phba->fcp_embed_io = 0;
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 035105a..9c8368a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4689,6 +4689,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 
 		break;
 	}
+	phba->fcp_embed_io = 0;	/* SLI4 FC support only */
 
 	rc = lpfc_sli_config_port(phba, mode);
 
@@ -6321,10 +6322,12 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 
 	mqe = &mboxq->u.mqe;
 	phba->sli_rev = bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev);
-	if (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev))
+	if (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev)) {
 		phba->hba_flag |= HBA_FCOE_MODE;
-	else
+		phba->fcp_embed_io = 0;	/* SLI4 FC support only */
+	} else {
 		phba->hba_flag &= ~HBA_FCOE_MODE;
+	}
 
 	if (bf_get(lpfc_mbx_rd_rev_cee_ver, &mqe->un.read_rev) ==
 		LPFC_DCBX_CEE_MODE)
@@ -8219,12 +8222,15 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 	else
 		command_type = ELS_COMMAND_NON_FIP;
 
+	if (phba->fcp_embed_io)
+		memset(wqe, 0, sizeof(union lpfc_wqe128));
 	/* Some of the fields are in the right position already */
 	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
-	abort_tag = (uint32_t) iocbq->iotag;
-	xritag = iocbq->sli4_xritag;
 	wqe->generic.wqe_com.word7 = 0; /* The ct field has moved so reset */
 	wqe->generic.wqe_com.word10 = 0;
+
+	abort_tag = (uint32_t) iocbq->iotag;
+	xritag = iocbq->sli4_xritag;
 	/* words0-2 bpl convert bde */
 	if (iocbq->iocb.un.genreq64.bdl.bdeFlags == BUFF_TYPE_BLP_64) {
 		numBdes = iocbq->iocb.un.genreq64.bdl.bdeSize /
@@ -8373,11 +8379,9 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       iocbq->iocb.ulpFCP2Rcvy);
 		bf_set(wqe_lnk, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpXS);
 		/* Always open the exchange */
-		bf_set(wqe_xc, &wqe->fcp_iwrite.wqe_com, 0);
 		bf_set(wqe_iod, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_IOD_WRITE);
 		bf_set(wqe_lenloc, &wqe->fcp_iwrite.wqe_com,
 		       LPFC_WQE_LENLOC_WORD4);
-		bf_set(wqe_ebde_cnt, &wqe->fcp_iwrite.wqe_com, 0);
 		bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpPU);
 		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 1);
 		if (iocbq->iocb_flag & LPFC_IO_OAS) {
@@ -8388,6 +8392,35 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 				       (phba->cfg_XLanePriority << 1));
 			}
 		}
+		/* Note, word 10 is already initialized to 0 */
+
+		if (phba->fcp_embed_io) {
+			struct lpfc_scsi_buf *lpfc_cmd;
+			struct sli4_sge *sgl;
+			union lpfc_wqe128 *wqe128;
+			struct fcp_cmnd *fcp_cmnd;
+			uint32_t *ptr;
+
+			/* 128 byte wqe support here */
+			wqe128 = (union lpfc_wqe128 *)wqe;
+
+			lpfc_cmd = iocbq->context1;
+			sgl = (struct sli4_sge *)lpfc_cmd->fcp_bpl;
+			fcp_cmnd = lpfc_cmd->fcp_cmnd;
+
+			/* Word 0-2 - FCP_CMND */
+			wqe128->generic.bde.tus.f.bdeFlags =
+				BUFF_TYPE_BDE_IMMED;
+			wqe128->generic.bde.tus.f.bdeSize = sgl->sge_len;
+			wqe128->generic.bde.addrHigh = 0;
+			wqe128->generic.bde.addrLow =  88;  /* Word 22 */
+
+			bf_set(wqe_wqes, &wqe128->fcp_iwrite.wqe_com, 1);
+
+			/* Word 22-29  FCP CMND Payload */
+			ptr = &wqe128->words[22];
+			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
+		}
 		break;
 	case CMD_FCP_IREAD64_CR:
 		/* word3 iocb=iotag wqe=payload_offset_len */
@@ -8402,11 +8435,9 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       iocbq->iocb.ulpFCP2Rcvy);
 		bf_set(wqe_lnk, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpXS);
 		/* Always open the exchange */
-		bf_set(wqe_xc, &wqe->fcp_iread.wqe_com, 0);
 		bf_set(wqe_iod, &wqe->fcp_iread.wqe_com, LPFC_WQE_IOD_READ);
 		bf_set(wqe_lenloc, &wqe->fcp_iread.wqe_com,
 		       LPFC_WQE_LENLOC_WORD4);
-		bf_set(wqe_ebde_cnt, &wqe->fcp_iread.wqe_com, 0);
 		bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpPU);
 		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
 		if (iocbq->iocb_flag & LPFC_IO_OAS) {
@@ -8417,6 +8448,35 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 				       (phba->cfg_XLanePriority << 1));
 			}
 		}
+		/* Note, word 10 is already initialized to 0 */
+
+		if (phba->fcp_embed_io) {
+			struct lpfc_scsi_buf *lpfc_cmd;
+			struct sli4_sge *sgl;
+			union lpfc_wqe128 *wqe128;
+			struct fcp_cmnd *fcp_cmnd;
+			uint32_t *ptr;
+
+			/* 128 byte wqe support here */
+			wqe128 = (union lpfc_wqe128 *)wqe;
+
+			lpfc_cmd = iocbq->context1;
+			sgl = (struct sli4_sge *)lpfc_cmd->fcp_bpl;
+			fcp_cmnd = lpfc_cmd->fcp_cmnd;
+
+			/* Word 0-2 - FCP_CMND */
+			wqe128->generic.bde.tus.f.bdeFlags =
+				BUFF_TYPE_BDE_IMMED;
+			wqe128->generic.bde.tus.f.bdeSize = sgl->sge_len;
+			wqe128->generic.bde.addrHigh = 0;
+			wqe128->generic.bde.addrLow =  88;  /* Word 22 */
+
+			bf_set(wqe_wqes, &wqe128->fcp_iread.wqe_com, 1);
+
+			/* Word 22-29  FCP CMND Payload */
+			ptr = &wqe128->words[22];
+			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
+		}
 		break;
 	case CMD_FCP_ICMND64_CR:
 		/* word3 iocb=iotag wqe=payload_offset_len */
@@ -8428,13 +8488,11 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		/* word3 iocb=IO_TAG wqe=reserved */
 		bf_set(wqe_pu, &wqe->fcp_icmd.wqe_com, 0);
 		/* Always open the exchange */
-		bf_set(wqe_xc, &wqe->fcp_icmd.wqe_com, 0);
 		bf_set(wqe_dbde, &wqe->fcp_icmd.wqe_com, 1);
 		bf_set(wqe_iod, &wqe->fcp_icmd.wqe_com, LPFC_WQE_IOD_WRITE);
 		bf_set(wqe_qosd, &wqe->fcp_icmd.wqe_com, 1);
 		bf_set(wqe_lenloc, &wqe->fcp_icmd.wqe_com,
 		       LPFC_WQE_LENLOC_NONE);
-		bf_set(wqe_ebde_cnt, &wqe->fcp_icmd.wqe_com, 0);
 		bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
 		       iocbq->iocb.ulpFCP2Rcvy);
 		if (iocbq->iocb_flag & LPFC_IO_OAS) {
@@ -8445,6 +8503,35 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 				       (phba->cfg_XLanePriority << 1));
 			}
 		}
+		/* Note, word 10 is already initialized to 0 */
+
+		if (phba->fcp_embed_io) {
+			struct lpfc_scsi_buf *lpfc_cmd;
+			struct sli4_sge *sgl;
+			union lpfc_wqe128 *wqe128;
+			struct fcp_cmnd *fcp_cmnd;
+			uint32_t *ptr;
+
+			/* 128 byte wqe support here */
+			wqe128 = (union lpfc_wqe128 *)wqe;
+
+			lpfc_cmd = iocbq->context1;
+			sgl = (struct sli4_sge *)lpfc_cmd->fcp_bpl;
+			fcp_cmnd = lpfc_cmd->fcp_cmnd;
+
+			/* Word 0-2 - FCP_CMND */
+			wqe128->generic.bde.tus.f.bdeFlags =
+				BUFF_TYPE_BDE_IMMED;
+			wqe128->generic.bde.tus.f.bdeSize = sgl->sge_len;
+			wqe128->generic.bde.addrHigh = 0;
+			wqe128->generic.bde.addrLow =  88;  /* Word 22 */
+
+			bf_set(wqe_wqes, &wqe128->fcp_icmd.wqe_com, 1);
+
+			/* Word 22-29  FCP CMND Payload */
+			ptr = &wqe128->words[22];
+			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
+		}
 		break;
 	case CMD_GEN_REQUEST64_CR:
 		/* For this command calculate the xmit length of the
@@ -8676,12 +8763,19 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			 struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	struct lpfc_sglq *sglq;
-	union lpfc_wqe wqe;
+	union lpfc_wqe *wqe;
+	union lpfc_wqe128 wqe128;
 	struct lpfc_queue *wq;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
 
 	lockdep_assert_held(&phba->hbalock);
 
+	/*
+	 * The WQE can be either 64 or 128 bytes,
+	 * so allocate space on the stack assuming the largest.
+	 */
+	wqe = (union lpfc_wqe *)&wqe128;
+
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
@@ -8728,7 +8822,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			return IOCB_ERROR;
 	}
 
-	if (lpfc_sli4_iocb2wqe(phba, piocb, &wqe))
+	if (lpfc_sli4_iocb2wqe(phba, piocb, wqe))
 		return IOCB_ERROR;
 
 	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
@@ -8738,12 +8832,12 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 		} else {
 			wq = phba->sli4_hba.oas_wq;
 		}
-		if (lpfc_sli4_wq_put(wq, &wqe))
+		if (lpfc_sli4_wq_put(wq, wqe))
 			return IOCB_ERROR;
 	} else {
 		if (unlikely(!phba->sli4_hba.els_wq))
 			return IOCB_ERROR;
-		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
+		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, wqe))
 			return IOCB_ERROR;
 	}
 	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
@@ -8758,9 +8852,9 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
  * pointer from the lpfc_hba struct.
  *
  * Return codes:
- * 	IOCB_ERROR - Error
- * 	IOCB_SUCCESS - Success
- * 	IOCB_BUSY - Busy
+ * IOCB_ERROR - Error
+ * IOCB_SUCCESS - Success
+ * IOCB_BUSY - Busy
  **/
 int
 __lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
-- 
2.5.0

