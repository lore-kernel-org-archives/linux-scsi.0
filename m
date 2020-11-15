Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CF8C2D0E4
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E9DF22314
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N1AYitqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgKOT1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbgKOT1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:15 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002D4C0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:14 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id y22so7034210plr.6
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Z50AzeFMCmfRVlCkemFQMME2ua/iVb4p74m5lWoh2OY=;
        b=N1AYitqLsuFD2753d0neOhiXUJ81pXEHtjWcwZP+zhTuNvlC8ctqZxSJHxgoQMbEhb
         AOjSvA5HIq8IMKbAE5TwoeZLPAIBSspIFPmDL3FL2jznB/5tK74IkSB8k3EnAv9SUpCY
         hfT35PdARSfBbLC0onKeH1GClbJJQIl+dpDzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Z50AzeFMCmfRVlCkemFQMME2ua/iVb4p74m5lWoh2OY=;
        b=LL5TX/NjovQUjk6hSLUf1dw7HC1jc8Wt6CUD5swDuMRm5JUj+e/halFoRUCuNCW7kR
         6/P/OclqiIttg8HXH+brOwiUNov5fiaJjQOP5Y9RTC6tXaEid2DhkmkWyjOS31f5/3WU
         +a6ptku3qeDZXklnOp0zVPqsQ41Zk0RNw1Suw03YuxjqpiptWpXtA02/f5TKcGJeI8uV
         whkcbNoIuFQNSw0kXTH+ox19//Bbckm7xMfcGiRDegZz2KzX+E5H/QXRSK1mB1chI3HG
         EmyYutc+rnJAjrYiycr2NLaBDUIm2i38O2J7iWoMFSkCA0D8hpj6+hcjcN5YFiZZ93kg
         aqdg==
X-Gm-Message-State: AOAM530Vno5Y8EUS59lP/fhzUicsHUrmbVgg1ukYmR5jj5KzWMzP5Odj
        OyCLqhJiq0cr8hanQzo9SUjgtUbbcoATE6/A2iH6TiZV1XpNdpMKkA1dML/3IKu6RCbEkDbLHQ8
        WrUH7r6+pbGd6cKnAq4S1GEcF3FZnTLyHluVdmj9MskwOaMxkkZ0nnVtLUqUIhMU6umnfNPiYRn
        n+nSc=
X-Google-Smtp-Source: ABdhPJxSUcuO9rbBckZtseE57r6K2CXp2uLVyScoV3kl4bmp6usQD7i6r4zy8Oy9yR4ksIKNbiXn7Q==
X-Received: by 2002:a17:902:c1cc:b029:d8:d2de:e523 with SMTP id c12-20020a170902c1ccb02900d8d2dee523mr9918485plc.67.1605468433544;
        Sun, 15 Nov 2020 11:27:13 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:12 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 14/17] lpfc: convert scsi io completions to sli-3 and sli-4 handlers
Date:   Sun, 15 Nov 2020 11:26:43 -0800
Message-Id: <20201115192646.12977-15-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b8ee3d05b42a3f53"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b8ee3d05b42a3f53
Content-Transfer-Encoding: 8bit

The current driver implementation uses sli-4 wqe to iocb conversion
before calling the cmpl callback function.

Rework the fcp io completion path to utilize the sli-4 wqe.

This patch converts the scsi io completion paths from the iocb-centric
interfaces to the routines are native for whether ios are iocb-based
(sli-3) or wqe-based (sli-4).

Most existing routines were iocb-based, so this creates a lot of SLI-4
specific routines to provide the functionality.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 490 +++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  |   5 +-
 2 files changed, 481 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4d6492faab81..0cd8f0b72605 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2882,6 +2882,150 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	}
 }
 
+/*
+ * This function checks for BlockGuard errors detected by
+ * the HBA.  In case of errors, the ASC/ASCQ fields in the
+ * sense buffer will be set accordingly, paired with
+ * ILLEGAL_REQUEST to signal to the kernel that the HBA
+ * detected corruption.
+ *
+ * Returns:
+ *  0 - No error found
+ *  1 - BlockGuard error found
+ * -1 - Internal error (bad profile, ...etc)
+ */
+static int
+lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
+		       struct lpfc_wcqe_complete *wcqe)
+{
+	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	int ret = 0;
+	u32 status = bf_get(lpfc_wcqe_c_status, wcqe);
+	u32 bghm = 0;
+	u32 bgstat = 0;
+	u64 failing_sector = 0;
+
+	if (status == CQE_STATUS_DI_ERROR) {
+		if (bf_get(lpfc_wcqe_c_bg_ge, wcqe)) /* Guard Check failed */
+			bgstat |= BGS_GUARD_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_ae, wcqe)) /* AppTag Check failed */
+			bgstat |= BGS_APPTAG_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_re, wcqe)) /* RefTag Check failed */
+			bgstat |= BGS_REFTAG_ERR_MASK;
+
+		/* Check to see if there was any good data before the error */
+		if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
+			bgstat |= BGS_HI_WATER_MARK_PRESENT_MASK;
+			bghm = wcqe->total_data_placed;
+		}
+
+		/*
+		 * Set ALL the error bits to indicate we don't know what
+		 * type of error it is.
+		 */
+		if (!bgstat)
+			bgstat |= (BGS_REFTAG_ERR_MASK | BGS_APPTAG_ERR_MASK |
+				BGS_GUARD_ERR_MASK);
+	}
+
+	if (lpfc_bgs_get_guard_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+					0x10, 0x1);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
+		phba->bg_guard_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9059 BLKGRD: Guard Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				blk_rq_sectors(cmd->request), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_reftag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+					0x10, 0x3);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
+
+		phba->bg_reftag_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9060 BLKGRD: Ref Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				blk_rq_sectors(cmd->request), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_apptag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+					0x10, 0x2);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
+
+		phba->bg_apptag_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9062 BLKGRD: App Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				blk_rq_sectors(cmd->request), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
+		/*
+		 * setup sense data descriptor 0 per SPC-4 as an information
+		 * field, and put the failing LBA in it.
+		 * This code assumes there was also a guard/app/ref tag error
+		 * indication.
+		 */
+		cmd->sense_buffer[7] = 0xc;   /* Additional sense length */
+		cmd->sense_buffer[8] = 0;     /* Information descriptor type */
+		cmd->sense_buffer[9] = 0xa;   /* Additional descriptor length */
+		cmd->sense_buffer[10] = 0x80; /* Validity bit */
+
+		/* bghm is a "on the wire" FC frame based count */
+		switch (scsi_get_prot_op(cmd)) {
+		case SCSI_PROT_READ_INSERT:
+		case SCSI_PROT_WRITE_STRIP:
+			bghm /= cmd->device->sector_size;
+			break;
+		case SCSI_PROT_READ_STRIP:
+		case SCSI_PROT_WRITE_INSERT:
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
+			bghm /= (cmd->device->sector_size +
+				sizeof(struct scsi_dif_tuple));
+			break;
+		}
+
+		failing_sector = scsi_get_lba(cmd);
+		failing_sector += bghm;
+
+		/* Descriptor Information */
+		put_unaligned_be64(failing_sector, &cmd->sense_buffer[12]);
+	}
+
+	if (!ret) {
+		/* No error was reported - problem in FW? */
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9068 BLKGRD: Unknown error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				blk_rq_sectors(cmd->request), bgstat, bghm);
+
+		/* Calcuate what type of error it was */
+		lpfc_calc_bg_err(phba, lpfc_cmd);
+	}
+	return ret;
+}
 
 /*
  * This function checks for BlockGuard errors detected by
@@ -3561,12 +3705,11 @@ lpfc_scsi_prep_cmnd_buf(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  **/
 static void
 lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
-		struct lpfc_io_buf *lpfc_cmd, struct lpfc_iocbq *rsp_iocb) {
+		struct lpfc_io_buf *lpfc_cmd, uint32_t fcpi_parm) {
 	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
 	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
 	uint32_t resp_info = fcprsp->rspStatus2;
 	uint32_t scsi_status = fcprsp->rspStatus3;
-	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
 	struct lpfc_fast_path_event *fast_path_evt = NULL;
 	struct lpfc_nodelist *pnode = lpfc_cmd->rdata->pnode;
 	unsigned long flags;
@@ -3681,13 +3824,11 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
  **/
 static void
 lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
-		    struct lpfc_iocbq *rsp_iocb)
+		    uint32_t fcpi_parm)
 {
-	struct lpfc_hba *phba = vport->phba;
 	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
 	struct fcp_cmnd *fcpcmd = lpfc_cmd->fcp_cmnd;
 	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
-	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
 	uint32_t resp_info = fcprsp->rspStatus2;
 	uint32_t scsi_status = fcprsp->rspStatus3;
 	uint32_t *lp;
@@ -3822,13 +3963,10 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 	 */
 	} else if (fcpi_parm) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
-				 "9029 FCP %s Check Error xri x%x  Data: "
+				 "9029 FCP %s Check Error Data: "
 				 "x%x x%x x%x x%x x%x\n",
 				 ((cmnd->sc_data_direction == DMA_FROM_DEVICE) ?
 				 "Read" : "Write"),
-				 ((phba->sli_rev == LPFC_SLI_REV4) ?
-				 lpfc_cmd->cur_iocbq.sli4_xritag :
-				 rsp_iocb->iocb.ulpContext),
 				 fcpDl, be32_to_cpu(fcprsp->rspResId),
 				 fcpi_parm, cmnd->cmnd[0], scsi_status);
 
@@ -3855,7 +3993,333 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 
  out:
 	cmnd->result = host_status << 16 | scsi_status;
-	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, rsp_iocb);
+	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, fcpi_parm);
+}
+
+/**
+ * lpfc_fcp_io_cmd_wqe_cmpl - Complete a FCP IO
+ * @phba: The hba for which this call is being executed.
+ * @pwqeIn: The command WQE for the scsi cmnd.
+ * @pwqeOut: The response WQE for the scsi cmnd.
+ *
+ * This routine assigns scsi command result by looking into response WQE
+ * status field appropriately. This routine handles QUEUE FULL condition as
+ * well by ramping down device queue depth.
+ **/
+static void
+lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
+			 struct lpfc_wcqe_complete *wcqe)
+{
+	struct lpfc_io_buf *lpfc_cmd =
+		(struct lpfc_io_buf *)pwqeIn->context1;
+	struct lpfc_vport *vport = pwqeIn->vport;
+	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
+	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct scsi_cmnd *cmd;
+	unsigned long flags;
+	struct lpfc_fast_path_event *fast_path_evt;
+	struct Scsi_Host *shost;
+	u32 logit = LOG_FCP;
+	u32 status, idx;
+	unsigned long iflags = 0;
+
+	/* Sanity check on return of outstanding command */
+	if (!lpfc_cmd) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				 "9032 Null lpfc_cmd pointer. No "
+				 "release, skip completion\n");
+		return;
+	}
+
+	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
+		/* TOREMOVE - currently this flag is checked during
+		 * the release of lpfc_iocbq. Remove once we move
+		 * to lpfc_wqe_job construct.
+		 *
+		 * This needs to be done outside buf_lock
+		 */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_EXCHANGE_BUSY;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+
+	/* Guard against abort handler being called at same time */
+	spin_lock(&lpfc_cmd->buf_lock);
+
+	/* Sanity check on return of outstanding command */
+	cmd = lpfc_cmd->pCmd;
+	if (!cmd || !phba) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				 "9042 IO completion: Not an active IO\n");
+		spin_unlock(&lpfc_cmd->buf_lock);
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+		return;
+	}
+	idx = lpfc_cmd->cur_iocbq.hba_wqidx;
+	if (phba->sli4_hba.hdwq)
+		phba->sli4_hba.hdwq[idx].scsi_cstat.io_cmpls++;
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
+		this_cpu_inc(phba->sli4_hba.c_stat->cmpl_io);
+#endif
+	shost = cmd->device->host;
+
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	lpfc_cmd->status = (status & LPFC_IOCB_STATUS_MASK);
+	lpfc_cmd->result = (wcqe->parameter & IOERR_PARAM_MASK);
+
+	lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
+	if (bf_get(lpfc_wcqe_c_xb, wcqe))
+		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (lpfc_cmd->prot_data_type) {
+		struct scsi_dif_tuple *src = NULL;
+
+		src =  (struct scsi_dif_tuple *)lpfc_cmd->prot_data_segment;
+		/*
+		 * Used to restore any changes to protection
+		 * data for error injection.
+		 */
+		switch (lpfc_cmd->prot_data_type) {
+		case LPFC_INJERR_REFTAG:
+			src->ref_tag =
+				lpfc_cmd->prot_data;
+			break;
+		case LPFC_INJERR_APPTAG:
+			src->app_tag =
+				(uint16_t)lpfc_cmd->prot_data;
+			break;
+		case LPFC_INJERR_GUARD:
+			src->guard_tag =
+				(uint16_t)lpfc_cmd->prot_data;
+			break;
+		default:
+			break;
+		}
+
+		lpfc_cmd->prot_data = 0;
+		lpfc_cmd->prot_data_type = 0;
+		lpfc_cmd->prot_data_segment = NULL;
+	}
+#endif
+	if (unlikely(lpfc_cmd->status)) {
+		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
+		    (lpfc_cmd->result & IOERR_DRVR_MASK))
+			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+		else if (lpfc_cmd->status >= IOSTAT_CNT)
+			lpfc_cmd->status = IOSTAT_DEFAULT;
+		if (lpfc_cmd->status == IOSTAT_FCP_RSP_ERROR &&
+		    !lpfc_cmd->fcp_rsp->rspStatus3 &&
+		    (lpfc_cmd->fcp_rsp->rspStatus2 & RESID_UNDER) &&
+		    !(vport->cfg_log_verbose & LOG_FCP_UNDER))
+			logit = 0;
+		else
+			logit = LOG_FCP | LOG_FCP_UNDER;
+		lpfc_printf_vlog(vport, KERN_WARNING, logit,
+				 "9034 FCP cmd x%x failed <%d/%lld> "
+				 "status: x%x result: x%x "
+				 "sid: x%x did: x%x oxid: x%x "
+				 "Data: x%x x%x x%x\n",
+				 cmd->cmnd[0],
+				 cmd->device ? cmd->device->id : 0xffff,
+				 cmd->device ? cmd->device->lun : 0xffff,
+				 lpfc_cmd->status, lpfc_cmd->result,
+				 vport->fc_myDID,
+				 (ndlp) ? ndlp->nlp_DID : 0,
+				 lpfc_cmd->cur_iocbq.sli4_xritag,
+				 wcqe->parameter, wcqe->total_data_placed,
+				 lpfc_cmd->cur_iocbq.iotag);
+	}
+
+	switch (lpfc_cmd->status) {
+	case IOSTAT_SUCCESS:
+		cmd->result = DID_OK << 16;
+		break;
+	case IOSTAT_FCP_RSP_ERROR:
+		lpfc_handle_fcp_err(vport, lpfc_cmd,
+				    pwqeIn->wqe.fcp_iread.total_xfer_len -
+				    wcqe->total_data_placed);
+		break;
+	case IOSTAT_NPORT_BSY:
+	case IOSTAT_FABRIC_BSY:
+		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+		fast_path_evt = lpfc_alloc_fast_evt(phba);
+		if (!fast_path_evt)
+			break;
+		fast_path_evt->un.fabric_evt.event_type =
+			FC_REG_FABRIC_EVENT;
+		fast_path_evt->un.fabric_evt.subcategory =
+			(lpfc_cmd->status == IOSTAT_NPORT_BSY) ?
+			LPFC_EVENT_PORT_BUSY : LPFC_EVENT_FABRIC_BUSY;
+		if (ndlp) {
+			memcpy(&fast_path_evt->un.fabric_evt.wwpn,
+			       &ndlp->nlp_portname,
+				sizeof(struct lpfc_name));
+			memcpy(&fast_path_evt->un.fabric_evt.wwnn,
+			       &ndlp->nlp_nodename,
+				sizeof(struct lpfc_name));
+		}
+		fast_path_evt->vport = vport;
+		fast_path_evt->work_evt.evt =
+			LPFC_EVT_FASTPATH_MGMT_EVT;
+		spin_lock_irqsave(&phba->hbalock, flags);
+		list_add_tail(&fast_path_evt->work_evt.evt_listp,
+			      &phba->work_list);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		lpfc_worker_wake_up(phba);
+		lpfc_printf_vlog(vport, KERN_WARNING, logit,
+				 "9035 Fabric/Node busy FCP cmd x%x failed"
+				 " <%d/%lld> "
+				 "status: x%x result: x%x "
+				 "sid: x%x did: x%x oxid: x%x "
+				 "Data: x%x x%x x%x\n",
+				 cmd->cmnd[0],
+				 cmd->device ? cmd->device->id : 0xffff,
+				 cmd->device ? cmd->device->lun : 0xffff,
+				 lpfc_cmd->status, lpfc_cmd->result,
+				 vport->fc_myDID,
+				 (ndlp) ? ndlp->nlp_DID : 0,
+				 lpfc_cmd->cur_iocbq.sli4_xritag,
+				 wcqe->parameter,
+				 wcqe->total_data_placed,
+				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
+		break;
+	case IOSTAT_REMOTE_STOP:
+		if (ndlp) {
+			/* This IO was aborted by the target, we don't
+			 * know the rxid and because we did not send the
+			 * ABTS we cannot generate and RRQ.
+			 */
+			lpfc_set_rrq_active(phba, ndlp,
+					    lpfc_cmd->cur_iocbq.sli4_lxritag,
+					    0, 0);
+		}
+		fallthrough;
+	case IOSTAT_LOCAL_REJECT:
+		if (lpfc_cmd->result & IOERR_DRVR_MASK)
+			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+		if (lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_ERROR ||
+		    lpfc_cmd->result ==
+		    IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
+		    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
+		    lpfc_cmd->result ==
+		    IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
+			cmd->result = DID_NO_CONNECT << 16;
+			break;
+		}
+		if (lpfc_cmd->result == IOERR_INVALID_RPI ||
+		    lpfc_cmd->result == IOERR_NO_RESOURCES ||
+		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
+		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
+			cmd->result = DID_REQUEUE << 16;
+			break;
+		}
+		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
+		     lpfc_cmd->result == IOERR_TX_DMA_FAILED) &&
+		     status == CQE_STATUS_DI_ERROR) {
+			if (scsi_get_prot_op(cmd) !=
+			    SCSI_PROT_NORMAL) {
+				/*
+				 * This is a response for a BG enabled
+				 * cmd. Parse BG error
+				 */
+				lpfc_sli4_parse_bg_err(phba, lpfc_cmd,
+						       wcqe);
+				break;
+			}
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				 "9040 non-zero BGSTAT on unprotected cmd\n");
+		}
+		lpfc_printf_vlog(vport, KERN_WARNING, logit,
+				 "9036 Local Reject FCP cmd x%x failed"
+				 " <%d/%lld> "
+				 "status: x%x result: x%x "
+				 "sid: x%x did: x%x oxid: x%x "
+				 "Data: x%x x%x x%x\n",
+				 cmd->cmnd[0],
+				 cmd->device ? cmd->device->id : 0xffff,
+				 cmd->device ? cmd->device->lun : 0xffff,
+				 lpfc_cmd->status, lpfc_cmd->result,
+				 vport->fc_myDID,
+				 (ndlp) ? ndlp->nlp_DID : 0,
+				 lpfc_cmd->cur_iocbq.sli4_xritag,
+				 wcqe->parameter,
+				 wcqe->total_data_placed,
+				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
+		fallthrough;
+	default:
+		if (lpfc_cmd->status >= IOSTAT_CNT)
+			lpfc_cmd->status = IOSTAT_DEFAULT;
+		cmd->result = DID_ERROR << 16;
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
+				 "9037 FCP Completion Error: xri %x "
+				 "status x%x result x%x [x%x] "
+				 "placed x%x\n",
+				 lpfc_cmd->cur_iocbq.sli4_xritag,
+				 lpfc_cmd->status, lpfc_cmd->result,
+				 wcqe->parameter,
+				 wcqe->total_data_placed);
+	}
+	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
+		u32 *lp = (u32 *)cmd->sense_buffer;
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+				 "9039 Iodone <%d/%llu> cmd x%p, error "
+				 "x%x SNS x%x x%x Data: x%x x%x\n",
+				 cmd->device->id, cmd->device->lun, cmd,
+				 cmd->result, *lp, *(lp + 3), cmd->retries,
+				 scsi_get_resid(cmd));
+	}
+
+	lpfc_update_stats(vport, lpfc_cmd);
+
+	if (vport->cfg_max_scsicmpl_time &&
+	    time_after(jiffies, lpfc_cmd->start_time +
+	    msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (ndlp) {
+			if (ndlp->cmd_qdepth >
+				atomic_read(&ndlp->cmd_pending) &&
+				(atomic_read(&ndlp->cmd_pending) >
+				LPFC_MIN_TGT_QDEPTH) &&
+				(cmd->cmnd[0] == READ_10 ||
+				cmd->cmnd[0] == WRITE_10))
+				ndlp->cmd_qdepth =
+					atomic_read(&ndlp->cmd_pending);
+
+			ndlp->last_change_time = jiffies;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
+	}
+	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (lpfc_cmd->ts_cmd_start) {
+		lpfc_cmd->ts_isr_cmpl = lpfc_cmd->cur_iocbq.isr_timestamp;
+		lpfc_cmd->ts_data_io = ktime_get_ns();
+		phba->ktime_last_cmd = lpfc_cmd->ts_data_io;
+		lpfc_io_ktime(phba, lpfc_cmd);
+	}
+#endif
+	lpfc_cmd->pCmd = NULL;
+	spin_unlock(&lpfc_cmd->buf_lock);
+
+	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
+	cmd->scsi_done(cmd);
+
+	/*
+	 * If there is an abort thread waiting for command completion
+	 * wake up the thread.
+	 */
+	spin_lock(&lpfc_cmd->buf_lock);
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
+	if (lpfc_cmd->waitq)
+		wake_up(lpfc_cmd->waitq);
+	spin_unlock(&lpfc_cmd->buf_lock);
+
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
 /**
@@ -3978,7 +4442,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		switch (lpfc_cmd->status) {
 		case IOSTAT_FCP_RSP_ERROR:
 			/* Call FCP RSP handler to determine result */
-			lpfc_handle_fcp_err(vport, lpfc_cmd, pIocbOut);
+			lpfc_handle_fcp_err(vport, lpfc_cmd,
+					    pIocbOut->iocb.un.fcpi.fcpi_parm);
 			break;
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
@@ -4305,8 +4770,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 	pwqeq->vport = vport;
 	pwqeq->context1 = lpfc_cmd;
 	pwqeq->hba_wqidx = lpfc_cmd->hdwq_no;
-	if (!pwqeq->iocb_cmpl)
-		pwqeq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
+	pwqeq->wqe_cmpl = lpfc_fcp_io_cmd_wqe_cmpl;
 
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2007835b6a5a..e58ad2ea11be 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14339,7 +14339,9 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 #endif
 	if (cmdiocbq->iocb_cmpl == NULL) {
 		if (cmdiocbq->wqe_cmpl) {
-			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+			/* For FCP the flag is cleared in wqe_cmpl */
+			if (!(cmdiocbq->iocb_flag & LPFC_IO_FCP) &&
+			    cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
 				spin_lock_irqsave(&phba->hbalock, iflags);
 				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 				spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -14356,6 +14358,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		return;
 	}
 
+	/* Only SLI4 non-IO commands stil use IOCB */
 	/* Fake the irspiocb and copy necessary response information */
 	lpfc_sli4_iocb_param_transfer(phba, &irspiocbq, cmdiocbq, wcqe);
 
-- 
2.26.2


--000000000000b8ee3d05b42a3f53
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg30RVm434uP+ns51Z
/uiv3kx1M6gHBHAu74N8xNMA2lQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzE0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGIS2eouxWMbcLFzksC3kkrStP6BEIBEUMiL
5l05uwMNPYdHNaBfdsx9XDyYVt53RDI8/XdhVv0Y8A8HK62ewK9A82tCJIo23VkBnETLhCsTkbEE
hjfqMF8F++xk13WXK+TnEh+6xTYfLl0Mh1N1qCk0yPUOQEuJFgPKEHMEloKr0Rcy05pAlwx9A2gt
2KaC85TmDd6qlA3CUnrsPl7tEgLUlJkRkjm7fl+Njir0DhgY/z01GdwE08Qe1tgPlha0yVKCIqXD
TQof3gqbaOWtLTVHUritHeCPSi2T8oIMfwfP2RkreVS9SlXtmUTkowrKHodaFJg3fSzL0HpX1axT
PRc=
--000000000000b8ee3d05b42a3f53--
