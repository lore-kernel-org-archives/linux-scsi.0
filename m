Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F142C7EE2D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbjEWSWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbjEWSWc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:32 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19854130
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-25377d67da9so3542a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866149; x=1687458149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLULlYFvxj2hTCdmnUxw/843WxOyeStyjIrF2s2xfc4=;
        b=f7MhpTwFfAVFh0ilZ10lodhMf+8PL6WTkvv8ByRCZWWuNSGP4XUHuIpIxtk3TPbcKX
         b7y9vWaI9/OrwLC4IafKxKjWjNMqGRQT4pIpfHMixiQAfRwuyXx+gS3RbXYXIiUx2yIk
         mdZEYjb8ip79wtAHQH36b2Z+cr01aNjxQ1fZbNacUED2oz7g5l36WXQQDqmVUKtkxAdA
         VnKMkdxzIV66OUCOXyIH67MpifPKePpMKFNXFRIakHsElegB4asQdfIv1bUN1XV0xLWe
         b3zQw/wr7nFGjmSyNQafAFgcKKHOH1jKcUYNLdI9FAgRgPCzXAPOUGgIUR1kZQg2QFvu
         4Jlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866149; x=1687458149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLULlYFvxj2hTCdmnUxw/843WxOyeStyjIrF2s2xfc4=;
        b=OdNgGqqmhHC6KUa4s0MK+28e2pArKJ1eHD6ENk0A4YtYHV2owbF8HSpG0Hpbiv8M4X
         O2S45NmTZzVzgQqnH8SzMwTi5yKumyhamTzRchnAh1N4RpKy0L3f+EFXtVGzE8yTUDa0
         FHS9IPJwy+jycvqbzBc+rTy0VWdGHavM2zo1OzMVK6vHu9QYsE/aecTMO3v4S54VBnmt
         vOxgjOosiXbDPLGyBvel4onei6ernkpkMOl55dAl4417lQxi7kRRsTVRH74Og+WKz+Z+
         G+nmdx9aDmwBe2V++FmBXfJcEBVuSCgwry6sCeNk8t5cAQWX27Df5Ox10jVZhmj6WzOJ
         egIA==
X-Gm-Message-State: AC+VfDxeduUbQ/DD1YcWVtim/gnxZcVH2SdhNYWsWQzWAkRDlc0XulXX
        e35clZdRQ8BTOBU4U2AHM4viBV5Aqx4=
X-Google-Smtp-Source: ACHHUZ6FrpJtMxKkCATUfBP66Rmus+gZ85ck7PHBKVVgY7nemLb4qZ6uhcYYgJmiYK7GJZEE8rt74g==
X-Received: by 2002:a17:902:dac6:b0:1af:b80a:b964 with SMTP id q6-20020a170902dac600b001afb80ab964mr56833plx.5.1684866149220;
        Tue, 23 May 2023 11:22:29 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:28 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/9] lpfc: Clean up SLI-4 CQE status handling
Date:   Tue, 23 May 2023 11:32:03 -0700
Message-Id: <20230523183206.7728-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is mishandling of SLI-4 CQE status values larger than what is
allowed by the LPFC_IOCB_STATUS_MASK of 4 bits.  The LPFC_IOCB_STATUS_MASK
is a leftover SLI-3 construct and serves no purpose in SLI-4 path.

Remove the LPFC_IOCB_STATUS_MASK and clean up general CQE status handling
in SLI-4 completion paths.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h       |  2 --
 drivers/scsi/lpfc/lpfc_hw4.h   |  3 --
 drivers/scsi/lpfc/lpfc_nvme.c  | 17 +++++----
 drivers/scsi/lpfc/lpfc_nvmet.c |  4 +--
 drivers/scsi/lpfc/lpfc_scsi.c  | 65 +++++++++++++++-------------------
 5 files changed, 41 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 5e3a93d13a91..dcb87bb5f88b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -932,8 +932,6 @@ struct lpfc_hba {
 	void (*__lpfc_sli_release_iocbq)(struct lpfc_hba *,
 			 struct lpfc_iocbq *);
 	int (*lpfc_hba_down_post)(struct lpfc_hba *phba);
-	void (*lpfc_scsi_cmd_iocb_cmpl)
-		(struct lpfc_hba *, struct lpfc_iocbq *, struct lpfc_iocbq *);
 
 	/* MBOX interface function jump table entries */
 	int (*lpfc_sli_issue_mbox)
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 082f8a109e55..5d4f9f27084d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -395,9 +395,6 @@ struct lpfc_cqe {
 #define CQE_STATUS_NEED_BUFF_ENTRY	0xf
 #define CQE_STATUS_DI_ERROR		0x16
 
-/* Used when mapping CQE status to IOCB */
-#define LPFC_IOCB_STATUS_MASK		0xf
-
 /* Status returned by hardware (valid only if status = CQE_STATUS_SUCCESS). */
 #define CQE_HW_STATUS_NO_ERR		0x0
 #define CQE_HW_STATUS_UNDERRUN		0x1
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 82730a89ecb5..8db7cb99903d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -310,20 +310,20 @@ lpfc_nvme_handle_lsreq(struct lpfc_hba *phba,
  * for the LS request.
  **/
 void
-__lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
+__lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_vport *vport,
 			struct lpfc_iocbq *cmdwqe,
 			struct lpfc_wcqe_complete *wcqe)
 {
 	struct nvmefc_ls_req *pnvme_lsreq;
 	struct lpfc_dmabuf *buf_ptr;
 	struct lpfc_nodelist *ndlp;
-	uint32_t status;
+	int status;
 
 	pnvme_lsreq = cmdwqe->context_un.nvme_lsreq;
 	ndlp = cmdwqe->ndlp;
 	buf_ptr = cmdwqe->bpl_dmabuf;
 
-	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			 "6047 NVMEx LS REQ x%px cmpl DID %x Xri: %x "
@@ -343,14 +343,17 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 		kfree(buf_ptr);
 		cmdwqe->bpl_dmabuf = NULL;
 	}
-	if (pnvme_lsreq->done)
+	if (pnvme_lsreq->done) {
+		if (status != CQE_STATUS_SUCCESS)
+			status = -ENXIO;
 		pnvme_lsreq->done(pnvme_lsreq, status);
-	else
+	} else {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6046 NVMEx cmpl without done call back? "
 				 "Data x%px DID %x Xri: %x status %x\n",
 				pnvme_lsreq, ndlp ? ndlp->nlp_DID : 0,
 				cmdwqe->sli4_xritag, status);
+	}
 	if (ndlp) {
 		lpfc_nlp_put(ndlp);
 		cmdwqe->ndlp = NULL;
@@ -367,7 +370,7 @@ lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	uint32_t status;
 	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
-	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
 
 	if (vport->localport) {
 		lport = (struct lpfc_nvme_lport *)vport->localport->private;
@@ -1040,7 +1043,7 @@ lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		nCmd->rcv_rsplen = LPFC_NVME_ERSP_LEN;
 		nCmd->transferred_length = nCmd->payload_length;
 	} else {
-		lpfc_ncmd->status = (status & LPFC_IOCB_STATUS_MASK);
+		lpfc_ncmd->status = status;
 		lpfc_ncmd->result = (wcqe->parameter & IOERR_PARAM_MASK);
 
 		/* For NVME, the only failure path that results in an
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 7517dd55fe91..ce201465dc6f 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -300,7 +300,7 @@ __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	struct nvmefc_ls_rsp *ls_rsp = &axchg->ls_rsp;
 	uint32_t status, result;
 
-	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
 	result = wcqe->parameter;
 
 	if (axchg->state != LPFC_NVME_STE_LS_RSP || axchg->entry_cnt != 2) {
@@ -350,7 +350,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	if (!phba->targetport)
 		goto finish;
 
-	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
 	result = wcqe->parameter;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 49aa86c477c6..a62e091894f6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4026,7 +4026,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost;
 	u32 logit = LOG_FCP;
-	u32 status, idx;
+	u32 idx;
 	u32 lat;
 	u8 wait_xb_clr = 0;
 
@@ -4061,8 +4061,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 #endif
 	shost = cmd->device->host;
 
-	status = bf_get(lpfc_wcqe_c_status, wcqe);
-	lpfc_cmd->status = (status & LPFC_IOCB_STATUS_MASK);
+	lpfc_cmd->status = bf_get(lpfc_wcqe_c_status, wcqe);
 	lpfc_cmd->result = (wcqe->parameter & IOERR_PARAM_MASK);
 
 	lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
@@ -4104,11 +4103,6 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	}
 #endif
 	if (unlikely(lpfc_cmd->status)) {
-		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
-		    (lpfc_cmd->result & IOERR_DRVR_MASK))
-			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-		else if (lpfc_cmd->status >= IOSTAT_CNT)
-			lpfc_cmd->status = IOSTAT_DEFAULT;
 		if (lpfc_cmd->status == IOSTAT_FCP_RSP_ERROR &&
 		    !lpfc_cmd->fcp_rsp->rspStatus3 &&
 		    (lpfc_cmd->fcp_rsp->rspStatus2 & RESID_UNDER) &&
@@ -4133,16 +4127,16 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	}
 
 	switch (lpfc_cmd->status) {
-	case IOSTAT_SUCCESS:
+	case CQE_STATUS_SUCCESS:
 		cmd->result = DID_OK << 16;
 		break;
-	case IOSTAT_FCP_RSP_ERROR:
+	case CQE_STATUS_FCP_RSP_FAILURE:
 		lpfc_handle_fcp_err(vport, lpfc_cmd,
 				    pwqeIn->wqe.fcp_iread.total_xfer_len -
 				    wcqe->total_data_placed);
 		break;
-	case IOSTAT_NPORT_BSY:
-	case IOSTAT_FABRIC_BSY:
+	case CQE_STATUS_NPORT_BSY:
+	case CQE_STATUS_FABRIC_BSY:
 		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 		fast_path_evt = lpfc_alloc_fast_evt(phba);
 		if (!fast_path_evt)
@@ -4185,7 +4179,27 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				 wcqe->total_data_placed,
 				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
 		break;
-	case IOSTAT_REMOTE_STOP:
+	case CQE_STATUS_DI_ERROR:
+		if (bf_get(lpfc_wcqe_c_bg_edir, wcqe))
+			lpfc_cmd->result = IOERR_RX_DMA_FAILED;
+		else
+			lpfc_cmd->result = IOERR_TX_DMA_FAILED;
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_BG,
+				 "9048 DI Error xri x%x status x%x DI ext "
+				 "status x%x data placed x%x\n",
+				 lpfc_cmd->cur_iocbq.sli4_xritag,
+				 lpfc_cmd->status, wcqe->parameter,
+				 wcqe->total_data_placed);
+		if (scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
+			/* BG enabled cmd. Parse BG error */
+			lpfc_parse_bg_err(phba, lpfc_cmd, pwqeOut);
+			break;
+		}
+		cmd->result = DID_ERROR << 16;
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				 "9040 DI Error on unprotected cmd\n");
+		break;
+	case CQE_STATUS_REMOTE_STOP:
 		if (ndlp) {
 			/* This I/O was aborted by the target, we don't
 			 * know the rxid and because we did not send the
@@ -4196,7 +4210,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 					    0, 0);
 		}
 		fallthrough;
-	case IOSTAT_LOCAL_REJECT:
+	case CQE_STATUS_LOCAL_REJECT:
 		if (lpfc_cmd->result & IOERR_DRVR_MASK)
 			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		if (lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_ERROR ||
@@ -4217,24 +4231,6 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			break;
 		}
-		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
-		     lpfc_cmd->result == IOERR_TX_DMA_FAILED) &&
-		     status == CQE_STATUS_DI_ERROR) {
-			if (scsi_get_prot_op(cmd) !=
-			    SCSI_PROT_NORMAL) {
-				/*
-				 * This is a response for a BG enabled
-				 * cmd. Parse BG error
-				 */
-				lpfc_parse_bg_err(phba, lpfc_cmd, pwqeOut);
-				break;
-			} else {
-				lpfc_printf_vlog(vport, KERN_WARNING,
-						 LOG_BG,
-						 "9040 non-zero BGSTAT "
-						 "on unprotected cmd\n");
-			}
-		}
 		lpfc_printf_vlog(vport, KERN_WARNING, logit,
 				 "9036 Local Reject FCP cmd x%x failed"
 				 " <%d/%lld> "
@@ -4253,10 +4249,8 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
 		fallthrough;
 	default:
-		if (lpfc_cmd->status >= IOSTAT_CNT)
-			lpfc_cmd->status = IOSTAT_DEFAULT;
 		cmd->result = DID_ERROR << 16;
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "9037 FCP Completion Error: xri %x "
 				 "status x%x result x%x [x%x] "
 				 "placed x%x\n",
@@ -5010,7 +5004,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		return -ENODEV;
 	}
 	phba->lpfc_rampdown_queue_depth = lpfc_rampdown_queue_depth;
-	phba->lpfc_scsi_cmd_iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	return 0;
 }
 
-- 
2.38.0

