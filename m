Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DDBC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFDC2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzQDhOKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgF3VuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgF3VuS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8E4C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:18 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q15so20209895wmj.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DMd24yOxaUUWs1I7jX6i8JWTPv5492Wi5I4AM21WjyM=;
        b=HzQDhOKLW35gIyzcWa17BSqdpAM4LqKcIo7fkB3Xiuodgj5ZnLtdQDWjRZ4d4T+Myx
         JnkJWg0aNpSP4ez9O8xaEojlGptab1fwbdXcbUxS7hnBBl7aI95rEV6UWCN0wSyork9W
         LvGBKviKIC/2IU4SHLPgB8cNLxBonAqCIHcFAlkJOfasfmmSxMiddWle3pXy5vyqIMyF
         xz41HtU3cxL92i6DqFcyjFQ+aemwIvyxbA25TmYUvQfM+X67wO5ezxJUclylndqOatYX
         PwX0F/5A4ddTrnmNV0AVRIHRATSD3/2ScyYIGvZDOVcdPCRAnCajkIc7FJqEPSgv7f9j
         5EEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DMd24yOxaUUWs1I7jX6i8JWTPv5492Wi5I4AM21WjyM=;
        b=FRfVd2CngW622BF2xkavfkbt7Zzs038pQx4RhHfMvaMkQ3ME8ipHZLVi6Ox04mrxaU
         tBUq62hmW54nEd7ast9oys75TEy8NRzP0MahYINZMJYW1JVzgEJawZSkYWU7lTINCMAl
         ClisKz97NElRCE/JwAJhWItnen6bwwn2CO/T0RAN1qg61YK9IpKhtOJJBb0a4pBh131V
         4aVNNb/lwRt25RmRqnG9ERurZB9MjvI3TS+RZYkxSoLW6UH/XcG18YBZNpirP8H9haAe
         u4h4k9AW7sjhMZ8fLrOKLhBAPCtDvibIbd9K2R0wM++biRxw8IOo1aDktk/rHDS1l/gI
         EAww==
X-Gm-Message-State: AOAM5301AZ9T6k4ilTGNtkWWdBfzmbCZNzjHPsSZPVzYRwSGdnfxsa6s
        10g+z5RCfrblGoFORRhQ2wxXpKqj
X-Google-Smtp-Source: ABdhPJwkWKWz1tnktj5BA2iis9Lc+JEvWuM1yf7jm3bZmPGw3fODBIru9kVCevJoW8MHA3NS2vDtxw==
X-Received: by 2002:a05:600c:2108:: with SMTP id u8mr25348346wml.189.1593553815868;
        Tue, 30 Jun 2020 14:50:15 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/14] lpfc: Fix first-burst driver implementation.
Date:   Tue, 30 Jun 2020 14:49:50 -0700
Message-Id: <20200630215001.70793-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current implementation of the driver's first-burst behavior had
a module parameter setting a first burst size that was then used
unconditionally on all targets and was ignorant of any limits that the
targets have.  The driver should have been determining the capability
of each target and enforced target-specific limits.

The following changes were made:
- lpfc_first_burst_size parameter is now an enable/disable value.
- Upon PRLI completion, if first-burst is enabled and the target supports
  first burst, the driver will issue a modesense6 scsi command to obtain
  the disconnect-reconnect page that has transport specific limits. This
  page reports the max first-burst size supported on the target. The size
  supported is saved in the target node structure.
- The saved first burst size was increased to 32bits so that 64k could
  be supported.
- Fix:Ensure that first burst size requested isn't larger than the io
  itself.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h      |   4 +
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       |   4 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   4 +
 drivers/scsi/lpfc/lpfc_nportdisc.c |  16 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 296 ++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.h      |  24 +++
 drivers/scsi/lpfc/lpfc_sli.c       |  31 ++-
 drivers/scsi/lpfc/lpfc_sli.h       |   1 +
 9 files changed, 365 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 9ee6b930a655..c832a7d26e86 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -591,6 +591,10 @@ struct lpfc_io_buf *lpfc_get_io_buf(struct lpfc_hba *phba,
 				int);
 void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd,
 			 struct lpfc_sli4_hdw_queue *qp);
+void lpfc_mode_sense_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *p_io_in,
+			  struct lpfc_iocbq *p_io_out);
+int lpfc_issue_scsi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+			struct lpfc_scsi_io_req *cmd_req);
 void lpfc_io_ktime(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd);
 void lpfc_nvme_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 482e4a888dae..42b6327cc3a4 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -115,6 +115,7 @@ struct lpfc_nodelist {
 	u8		nlp_nvme_info;	        /* NVME NSLER Support */
 #define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
 
+	uint32_t        first_burst;	/* First Burst size for ndlp */
 	uint16_t        nlp_usg_map;	/* ndlp management usage bitmap */
 #define NLP_USG_NODE_ACT_BIT	0x1	/* Indicate ndlp is actively used */
 #define NLP_USG_IACT_REQ_BIT	0x2	/* Request to inactivate ndlp */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3d670568a276..a7bbe628bc52 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2425,7 +2425,9 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		npr->estabImagePair = 1;
 		npr->readXferRdyDis = 1;
-		if (vport->cfg_first_burst_size)
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    !(phba->hba_flag & HBA_FCOE_MODE) &&
+		    vport->cfg_first_burst_size)
 			npr->writeXferRdyDis = 1;
 
 		/* For FCP support */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4084f7f2b821..47259970907d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4279,6 +4279,10 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* FCP and NVME Transport interface */
 	if ((old_state == NLP_STE_MAPPED_NODE ||
 	     old_state == NLP_STE_UNMAPPED_NODE)) {
+		/* SCSI-FCP first burst needs to be renegotiated on the
+		 * next successful PRLI completion.
+		 */
+		ndlp->first_burst = 0;
 		if (ndlp->rport) {
 			vport->phba->nport_event_cnt++;
 			lpfc_unregister_remote_port(ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d8501bd959e7..2871c9b0cbfa 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2160,7 +2160,9 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	IOCB_t *irsp;
 	PRLI *npr;
 	struct lpfc_nvme_prli *nvpr;
+	struct lpfc_scsi_io_req cmd_req;
 	void *temp_ptr;
+	int ret = 0;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
@@ -2200,16 +2202,26 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				 "6028 FCP NPR PRLI Cmpl Init %d Target %d\n",
 				 npr->initiatorFunc,
 				 npr->targetFunc);
+
 		if (npr->initiatorFunc)
 			ndlp->nlp_type |= NLP_FCP_INITIATOR;
 		if (npr->targetFunc) {
 			ndlp->nlp_type |= NLP_FCP_TARGET;
-			if (npr->writeXferRdyDis)
+			if (npr->writeXferRdyDis) {
 				ndlp->nlp_flag |= NLP_FIRSTBURST;
+				cmd_req.cmd_id = MODE_SENSE;
+				cmd_req.dev_id = CTRL_ID;
+				cmd_req.cmd_cmpl = lpfc_mode_sense_cmpl;
+				ret = lpfc_issue_scsi_cmd(vport, ndlp,
+							  &cmd_req);
+				lpfc_printf_vlog(vport, KERN_INFO,
+						 LOG_FCP | LOG_FCP_ERROR,
+						 "6334 FB issue returns %d\n",
+						 ret);
+			}
 		}
 		if (npr->Retry)
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
-
 	} else if (nvpr &&
 		   (bf_get_be32(prli_acc_rsp_code, nvpr) ==
 		    PRLI_REQ_EXECUTED) &&
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ad62fb3f3a54..a003b7bf000b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2527,7 +2527,6 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	int prot_group_type = 0;
 	int fcpdl;
 	int ret = 1;
-	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the bpl beyond fcp_cmnd
@@ -2649,7 +2648,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	 * length for DIF
 	 */
 	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
-	    (fcpdl < vport->cfg_first_burst_size))
+	    (fcpdl < lpfc_cmd->ndlp->first_burst))
 		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
 
 	return 0;
@@ -3265,7 +3264,6 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	int prot_group_type = 0;
 	int fcpdl;
 	int ret = 1;
-	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the sgl beyond fcp_cmnd
@@ -3402,7 +3400,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	 * length for DIF
 	 */
 	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
-	    (fcpdl < vport->cfg_first_burst_size))
+	    (fcpdl < lpfc_cmd->ndlp->first_burst))
 		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
 
 	/*
@@ -4127,14 +4125,12 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 		if (datadir == DMA_TO_DEVICE) {
 			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
-			if (vport->cfg_first_burst_size &&
+			if (pnode->first_burst &&
 			    (pnode->nlp_flag & NLP_FIRSTBURST)) {
+				u32 xrdy_len;
 				fcpdl = scsi_bufflen(scsi_cmnd);
-				if (fcpdl < vport->cfg_first_burst_size)
-					piocbq->iocb.un.fcpi.fcpi_XRdy = fcpdl;
-				else
-					piocbq->iocb.un.fcpi.fcpi_XRdy =
-						vport->cfg_first_burst_size;
+				xrdy_len = min(fcpdl, pnode->first_burst);
+				piocbq->iocb.un.fcpi.fcpi_XRdy = xrdy_len;
 			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
 			if (hdwq)
@@ -4708,6 +4704,286 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	return 0;
 }
 
+/* lpfc_mode_sense_cmpl.
+ *
+ * This is the completion routine for a driver-issued mode sense
+ * used to determine if an FCP target supports first_burst.  This
+ * routine could be used for other mode sense data values.
+ */
+void
+lpfc_mode_sense_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *p_io_in,
+		       struct lpfc_iocbq *p_io_out)
+{
+	struct lpfc_io_buf *lpfc_cmd = p_io_in->context1;
+	u32 resp_info = lpfc_cmd->fcp_rsp->rspStatus2;
+	struct sli4_sge *sgl;
+	struct lpfc_nodelist *ndlp = lpfc_cmd->ndlp;
+	u32 status = p_io_out->iocb.ulpStatus;
+	u32 result = p_io_out->iocb.un.ulpWord[4] & IOERR_PARAM_MASK;
+	u32 fb = 0;
+	int ret_val;
+	struct lpfc_first_burst_page *p_data;
+
+	/* Make sure the driver's remoteport state is still valid. If the
+	 * reference put results in an invalid remoteport, just exit.
+	 */
+	ret_val = lpfc_nlp_put(ndlp);
+	if (ret_val) {
+		ret_val = -ENOMEM;
+		goto out;
+	}
+
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	    ndlp->nlp_state != NLP_STE_MAPPED_NODE) {
+		ret_val = -ENXIO;
+		goto out;
+	}
+
+	/* Only accept a successful IO or an IO with an underflow status
+	 * because any other FCP RSP error indicates the IO had some other
+	 * error.
+	 */
+	if (status &&
+	    !(status == IOSTAT_FCP_RSP_ERROR && resp_info & RESID_UNDER)) {
+		ret_val = -EIO;
+		goto out;
+	}
+
+	/* No errors.  clear the return value. */
+	ret_val = 0;
+
+	/* Skip over the SGEs and headers to get the response data region. */
+	sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
+	sgl += 4;
+	p_data = (struct lpfc_first_burst_page *)(((u32 *)sgl) + 3);
+
+	/* Validate the correct page code response and the number of bytes
+	 * available before reading the first burst size. Initialize
+	 * the first_burst in case the response doesn't have a value.
+	 */
+	ndlp->first_burst = 0;
+	if (p_data->page_code == 0x2 && p_data->page_len == 0xe) {
+		fb = be16_to_cpu(p_data->first_burst);
+		ndlp->first_burst = min((u32)(fb * 512), (u32)LPFC_FCP_FB_MAX);
+	} else {
+		lpfc_printf_vlog(phba->pport, KERN_INFO,
+				 LOG_FCP | LOG_FCP_ERROR,
+				 "6332 Clear first burst value "
+				 "Code x%x Len x%x\n", p_data->page_code,
+				 p_data->page_len);
+	}
+
+	lpfc_printf_vlog(phba->pport, KERN_INFO,
+			 LOG_FCP | LOG_FCP_ERROR,
+			 "6336 FB Rsp: DID x%x Data: x%x x%x x%x x%x x%x x%x "
+			 "x%x\n", ndlp->nlp_DID, fb, ndlp->first_burst,
+			 status, result, resp_info,
+			 lpfc_cmd->cur_iocbq.iocb_flag, ret_val);
+
+	/* Pick up SLI4 exhange busy status from HBA */
+	if (p_io_out->iocb_flag & LPFC_EXCHANGE_BUSY)
+		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+	else
+		lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
+
+ out:
+	/* Push a driver message only if the IO completion is in error. */
+	if (ret_val)
+		lpfc_printf_vlog(phba->pport, KERN_INFO,
+				 LOG_FCP_UNDER | LOG_FCP_ERROR,
+				 "6331 FB err %d  <x%x/x%x> resp_info x%x\n",
+				 ret_val, status, result, resp_info);
+
+	p_io_in->context2 = NULL;
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_IO_DRVR_INIT;
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
+}
+
+/**
+ * lpfc_init_scsi_cmd - Initiatize SCSI command-specific fields.
+ * @vport: The virtual port for which this call being executed.
+ * @lpfc_cmd: The lpfc_io_buf containing this command.
+ * @dev_id - device identifier for this command
+ * @cmd_id:  SCSI command used to format the driver io and CDB
+ * @data_len: Number of bytes available for data.
+ *
+ * This routine initializes an lpfc_io_buf for the specified @cmd_id to
+ * the specified @dev_id for @data_len bytes.
+ *
+ * Returns:
+ *   0 - on success
+ *   A negative error value in the form -Exxxx otherwise.
+ *
+ **/
+static int
+lpfc_init_scsi_cmd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
+		   struct lpfc_scsi_io_req *cmd_req, u32 data_len)
+{
+	int ret = 0;
+	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+
+	/* Set command-independent values. */
+	lpfc_cmd->fcp_cmnd->fcpCdb[0] = cmd_req->cmd_id;
+	lpfc_cmd->fcp_cmnd->fcpCdb[4] = data_len;
+	lpfc_cmd->cur_iocbq.iocb_cmpl = cmd_req->cmd_cmpl;
+	lpfc_cmd->fcp_cmnd->fcpDl = cpu_to_be32(data_len);
+	int_to_scsilun(cmd_req->dev_id, &lpfc_cmd->fcp_cmnd->fcp_lun);
+
+	/* SCSI Command specific initialization. */
+	switch (cmd_req->cmd_id) {
+	case MODE_SENSE:
+		/* Send the DISCONNECT-RECONNECT page code */
+		lpfc_cmd->fcp_cmnd->fcpCdb[2] = 0x2;
+		lpfc_cmd->fcp_cmnd->fcpCntl3 = READ_DATA;
+		lpfc_cmd->cur_iocbq.context2 = NULL;
+		iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
+		iocb_cmd->ulpPU = PARM_READ_CHECK;
+		break;
+	default:
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP | LOG_FCP_ERROR,
+				 "6335 Unsupported CMD x%x\n", cmd_req->cmd_id);
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+/**
+ * lpfc_issue_scsi_cmd - Send a driver initiated SCSI cmd
+ * @vport: The virtual port for which this call being executed.
+ * @ndlp - Pointer to lpfc_nodelist instance.
+ * @scsi_io_req - pointer to a job structure with the command, device ids,
+ *                and the associated completion routine.
+ *
+ * The driver calls this function to dynamically determine if an FCP
+ * target suppports a particular feature.  The caller needs to specify
+ * what command is needed to what device.
+ *
+ * Returns:
+ *   0 - on success
+ *   A negative error value in the form -Exxxx otherwise.
+ *
+ **/
+int
+lpfc_issue_scsi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+		    struct lpfc_scsi_io_req *cmd_req)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_io_buf *lpfc_cmd = NULL;
+	struct sli4_sge *sgl;
+	dma_addr_t pdma_phys_data;
+	IOCB_t *iocb_cmd;
+	int err = 0;
+
+	/* Requirements must be met. */
+	if (phba->sli_rev != LPFC_SLI_REV4 ||
+	    phba->hba_flag == HBA_FCOE_MODE ||
+	    !phba->pport->cfg_first_burst_size)
+		return -EPERM;
+
+	/* Because the driver potentially sends an FCP and NVME PRLI, the
+	 * caller is required to ensure an FCP PRLI has been successfully
+	 * completed.
+	 */
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return -EINVAL;
+
+	lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp, NULL);
+	if (!lpfc_cmd)
+		return -EIO;
+
+	/*
+	 * Every lpfc_io_buf is partially setup for the IO - an FCP Cmd SGE
+	 * and an FCP RSP SGE.  This routine configures two more - one for
+	 * this scsi command and an empty SGE. A 256 byte data area follows
+	 * for the command payload data.
+	 */
+	sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
+	sgl++;
+	bf_set(lpfc_sli4_sge_last, sgl, 0);
+	sgl++;
+
+	/* SGE for the SCSI command */
+	pdma_phys_data = lpfc_cmd->dma_handle + (4 * sizeof(struct sli4_sge));
+	sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_data));
+	sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_data));
+	sgl->word2 = le32_to_cpu(sgl->word2);
+	bf_set(lpfc_sli4_sge_last, sgl, 1);
+	bf_set(lpfc_sli4_sge_offset, sgl, 0);
+	bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_DATA);
+	sgl->word2 = cpu_to_le32(sgl->word2);
+	sgl->sge_len = cpu_to_le32(LPFC_DATA_SIZE);
+	sgl++;
+
+	/* Empty SGE.  Clear to prevent stale data errors. */
+	sgl->addr_hi = 0;
+	sgl->addr_lo = 0;
+	sgl->word2 = 0;
+	sgl->sge_len = 0;
+
+	/* Finish prepping the command, response and scsi command. */
+	memset(lpfc_cmd->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
+	memset((void *)lpfc_cmd->fcp_rsp, 0, sizeof(struct fcp_rsp));
+	err = lpfc_init_scsi_cmd(vport, lpfc_cmd, cmd_req, LPFC_DATA_SIZE);
+	if (err) {
+		err = -EPERM;
+		goto out_err;
+	}
+
+	/* This is an FCP IO the driver tracks so don't let it stay
+	 * outstanding forever - provide a generous 16 sec TMO.
+	 */
+	lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
+	lpfc_cmd->cur_iocbq.context1 = lpfc_cmd;
+	lpfc_cmd->cur_iocbq.vport = vport;
+	lpfc_cmd->timeout = LPFC_DRVR_TIMEOUT;
+	lpfc_cmd->pCmd = NULL;
+	lpfc_cmd->seg_cnt = 1;
+
+	/* Get an ndlp reference.  Ignore rdata as this IO is driver owned. */
+	lpfc_cmd->ndlp = lpfc_nlp_get(ndlp);
+	if (!lpfc_cmd->ndlp) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	iocb_cmd->un.fcpi.fcpi_parm = LPFC_DATA_SIZE;
+	iocb_cmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+	if (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE)
+		iocb_cmd->ulpFCP2Rcvy = 1;
+	iocb_cmd->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
+	iocb_cmd->ulpTimeout = lpfc_cmd->timeout;
+
+	err = lpfc_sli_issue_iocb(phba, LPFC_FCP_RING, &lpfc_cmd->cur_iocbq,
+				  SLI_IOCB_RET_IOCB);
+	if (err) {
+		err = -EIO;
+		lpfc_nlp_put(ndlp);
+		goto out_err;
+	}
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP | LOG_FCP_ERROR,
+			 "6333 Issue cmd x%x to 0x%06x status %d "
+			 "flag x%x iotag x%x xri x%x\n",
+			 cmd_req->cmd_id, ndlp->nlp_DID, err,
+			 lpfc_cmd->cur_iocbq.iocb_flag,
+			 lpfc_cmd->cur_iocbq.iotag,
+			 lpfc_cmd->cur_iocbq.sli4_xritag);
+
+	if (phba->cfg_xri_rebalancing)
+		lpfc_keep_pvt_pool_above_lowwm(phba, lpfc_cmd->hdwq_no);
+	return 0;
+
+ out_err:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP | LOG_FCP_ERROR,
+			 "6337 Could not issue cmd x%x err %d\n",
+			 cmd_req->cmd_id, err);
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_IO_DRVR_INIT;
+	lpfc_cmd->rdata = NULL;
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
+	return err;
+}
 
 /**
  * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index f76667b7da7b..964d0081fbb2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -24,6 +24,9 @@
 
 struct lpfc_hba;
 #define LPFC_FCP_CDB_LEN 16
+#define CTRL_ID 0
+#define LPFC_DATA_SIZE 255
+#define LPFC_FCP_FB_MAX 65536
 
 #define list_remove_head(list, entry, type, member)		\
 	do {							\
@@ -130,6 +133,27 @@ struct lpfc_scsicmd_bkt {
 	uint32_t cmd_count;
 };
 
+struct lpfc_scsi_io_req {
+	u32 dev_id;
+	u32 cmd_id;
+	void (*cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *p_io_in,
+			 struct lpfc_iocbq *p_io_out);
+};
+
+struct lpfc_first_burst_page {
+	u8 page_code;
+	u8 page_len;
+	u8 buf_full_r;
+	u8 buf_mt_r;
+	__be16 bus_inact_lmt;
+	__be16 disc_tmo;
+	__be16 conn_tmo;
+	__be16 max_burst;
+	u8 byte12;
+	u8 rsvd;
+	__be16 first_burst;
+};
+
 #define LPFC_SCSI_DMA_EXT_SIZE	264
 #define LPFC_BPL_SIZE		1024
 #define MDAC_DIRECT_CMD		0x22
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1575fccc8b0c..3c61a6d72a1a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9467,6 +9467,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 	struct lpfc_nodelist *ndlp;
 	uint32_t *pcmd;
 	uint32_t if_type;
+	struct lpfc_io_buf *lpfc_cmd;
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
@@ -9481,6 +9482,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		memset(wqe, 0, sizeof(union lpfc_wqe128));
 	/* Some of the fields are in the right position already */
 	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
+
 	/* The ct field has moved so reset */
 	wqe->generic.wqe_com.word7 = 0;
 	wqe->generic.wqe_com.word10 = 0;
@@ -9625,6 +9627,14 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(wqe_ebde_cnt, &wqe->xmit_bcast64.wqe_com, 0);
 		break;
 	case CMD_FCP_IWRITE64_CR:
+		lpfc_cmd = iocbq->context1;
+
+		/* The ndlp indicates if first burst support is supported. */
+		if (iocbq->iocb_flag & LPFC_IO_LIBDFC)
+			ndlp = iocbq->context_un.ndlp;
+		else
+			ndlp = lpfc_cmd->ndlp;
+
 		command_type = FCP_COMMAND_DATA_OUT;
 		/* word3 iocb=iotag wqe=payload_offset_len */
 		/* Add the FCP_CMD and FCP_RSP sizes to get the offset */
@@ -9632,8 +9642,19 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       xmit_len + sizeof(struct fcp_rsp));
 		bf_set(cmd_buff_len, &wqe->fcp_iwrite,
 		       0);
-		/* word4 iocb=parameter wqe=total_xfer_length memcpy */
-		/* word5 iocb=initial_xfer_len wqe=initial_xfer_len memcpy */
+
+		/* Set first-burst provided it was successfully negotiated */
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    iocbq->iocb_flag & LPFC_IO_FCP &&
+		    !(phba->hba_flag & HBA_FCOE_MODE) && ndlp->first_burst) {
+			u32 init_len;
+
+			total_len = be32_to_cpu(lpfc_cmd->fcp_cmnd->fcpDl);
+			init_len = min(total_len, ndlp->first_burst);
+			wqe->fcp_iwrite.initial_xfer_len = init_len;
+			wqe->fcp_iwrite.total_xfer_len = total_len;
+		}
+
 		bf_set(wqe_erp, &wqe->fcp_iwrite.wqe_com,
 		       iocbq->iocb.ulpFCP2Rcvy);
 		bf_set(wqe_lnk, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpXS);
@@ -9663,7 +9684,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 0);
 
 		if (phba->fcp_embed_io) {
-			struct lpfc_io_buf *lpfc_cmd;
 			struct sli4_sge *sgl;
 			struct fcp_cmnd *fcp_cmnd;
 			uint32_t *ptr;
@@ -10031,6 +10051,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 	bf_set(wqe_cmnd, &wqe->generic.wqe_com, cmnd);
 	bf_set(wqe_class, &wqe->generic.wqe_com, iocbq->iocb.ulpClass);
 	bf_set(wqe_cqid, &wqe->generic.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+
 	return 0;
 }
 
@@ -20452,6 +20473,10 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
 	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
+	/* First Burst initial and total transfer length must be zeroed. */
+	lpfc_ncmd->cur_iocbq.wqe.words[4] = 0;
+	lpfc_ncmd->cur_iocbq.wqe.words[5] = 0;
+
 	if (phba->cfg_xpsgl && !phba->nvmet_support &&
 	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
 		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 93d976ea8c5d..d6207974abf4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -100,6 +100,7 @@ struct lpfc_iocbq {
 #define LPFC_IO_NVME	        0x200000 /* NVME FCP command */
 #define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
 #define LPFC_IO_NVMET		0x800000 /* NVMET command */
+#define LPFC_IO_DRVR_INIT       0x80000000
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
-- 
2.25.0

