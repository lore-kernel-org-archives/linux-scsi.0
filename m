Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04786C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiBYCXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiBYCXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:23:53 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD01C74D2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id iq13-20020a17090afb4d00b001bc4437df2cso3591618pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HTy8GzndXPjotqAT7/U10Mz6LbumoP6rzmM0DtR3/Mg=;
        b=Hkw+7X8AmjwSdfn/chp1l/0kdIow0ENh/ionTt+C4BO5CH26CIeHfJWVrcPGbe1eSb
         ZBZtxE3MZrUoNd5IuuOhN5EiZAvmwv8crMu2IJRaLuFi0PedrS19qUWsNsunG0ajNgNw
         lg/FxVaIuebokFubfQcKtiKB9PH8pX1oX9spWlLLpMEZpuzPpzMi/fJcQ39A4ACgix9n
         8IHRi4iGTIUZCiCXD+fWj1ZnVxWKGrN4bkrIRzjg6ZNvd6dEyXLNVexA1q9CnhuTLkFm
         9STa81y2vSbu1JWXNPElDdopZEhfjQiWYFOj93dwDxRlJ+9DSHcTgTzEed67tyJCCi4Q
         ppug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HTy8GzndXPjotqAT7/U10Mz6LbumoP6rzmM0DtR3/Mg=;
        b=VTCy40xDG+LaDesg7ilqMoE5W097som/iUA+PmD0gNnumjE6UoUBFSD7LnMQUSDtX9
         5KkAKMpB+BtBSVdtkDlab/nDu7Nhnj8NajWUL2Py3TQxv0myFOx07Wp1BkpF+wNZhfVY
         HZ54mXOCFgv8XztmcY4HjWZNpFah7aFjpmhb5FEIgF31bjp5sXRF1NFmg+b3uFV2RGxQ
         OkH82FFPmiVTFi9/8tTEm26FSqpuzLTgGqhtciZqgXaQZXYeaiyJQyFfPNJR8kz5hlnL
         6YfTPeDLXqV7wCezKA3RydinlT/t1tDcj8YB2nhxZ9LbbFZ5IVzCMQOF79yGqvYvU4eE
         Zfxg==
X-Gm-Message-State: AOAM530a8d6moFiTDOPQTQ45uXJHEdj4a5qp8coPBexPG5Bs3LjEI1G+
        mKS9iUY5JJqueBGTjEcTdqbtpDXapDg=
X-Google-Smtp-Source: ABdhPJyCeEb9dkYpal49MjMVFb9rlcZkAcR3R8a8bMHaUszM3myDsBk5jecriqVEqfpAdVtYyTH3Jw==
X-Received: by 2002:a17:902:ea01:b0:150:760:bfd9 with SMTP id s1-20020a170902ea0100b001500760bfd9mr5324861plg.4.1645755799918;
        Thu, 24 Feb 2022 18:23:19 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:19 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/17] lpfc: SLI path split: introduce lpfc_prep_wqe
Date:   Thu, 24 Feb 2022 18:22:54 -0800
Message-Id: <20220225022308.16486-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce lpfc_prep_wqe routine for use in this patchset.

The lpfc_prep_wqe() routine is used with lpfc_sli_issue_iocb() and
lpfc_sli_issue_iocb_wait(). The routine performs additional SLI-4 wqe
field setting that the generic routines did not perform as they kept
their actions compatible with both sli3 and sli4.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  |   1 +
 drivers/scsi/lpfc/lpfc_crtn.h |   1 +
 drivers/scsi/lpfc/lpfc_ct.c   |   1 +
 drivers/scsi/lpfc/lpfc_els.c  |   2 +
 drivers/scsi/lpfc/lpfc_sli.c  | 197 +++++++++++++++++++++++++++++++++-
 5 files changed, 200 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6688a575904f..1a97426e72de 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3290,6 +3290,7 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 	cmdiocbq->cmd_flag |= LPFC_IO_LOOPBACK;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->cmd_cmpl = NULL;
+
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 					     rspiocbq, (phba->fc_ratov * 2) +
 					     LPFC_DRVR_TIMEOUT);
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 435428fdaa6e..51febb73e9a6 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -191,6 +191,7 @@ void lpfc_els_timeout_handler(struct lpfc_vport *);
 struct lpfc_iocbq *lpfc_prep_els_iocb(struct lpfc_vport *, uint8_t, uint16_t,
 				      uint8_t, struct lpfc_nodelist *,
 				      uint32_t, uint32_t);
+void lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job);
 void lpfc_hb_timeout_handler(struct lpfc_hba *);
 
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 19e2f8086a6d..8a19e9908811 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -659,6 +659,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	geniocb->context_un.ndlp = lpfc_nlp_get(ndlp);
 	if (!geniocb->context_un.ndlp)
 		goto out;
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
 
 	if (rc == IOCB_ERROR) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f13037273616..6474a46c294a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2862,6 +2862,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue ADISC:   did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3086,6 +3087,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue LOGO:      did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c87d902862c6..6867933c6ab6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11251,6 +11251,8 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 	int rc;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
+		lpfc_sli_prep_wqe(phba, piocb);
+
 		eq = phba->sli4_hba.hdwq[piocb->hba_wqidx].hba_eq;
 
 		pring = lpfc_sli4_calc_ring(phba, piocb);
@@ -13074,9 +13076,11 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	unsigned long iflags;
 	bool iocb_completed = true;
 
-	if (phba->sli_rev >= LPFC_SLI_REV4)
+	if (phba->sli_rev >= LPFC_SLI_REV4) {
+		lpfc_sli_prep_wqe(phba, piocb);
+
 		pring = lpfc_sli4_calc_ring(phba, piocb);
-	else
+	} else
 		pring = &phba->sli.sli3_ring[ring_number];
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
@@ -22448,3 +22452,192 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 
 	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 }
+
+/**
+ * lpfc_sli_prep_wqe - Prepare WQE for the command to be posted
+ * @phba: phba object
+ * @job: job entry of the command to be posted.
+ *
+ * Fill the common fields of the wqe for each of the command.
+ *
+ * Return codes:
+ *	None
+ **/
+void
+lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
+{
+	u8 cmnd;
+	u32 *pcmd;
+	u32 if_type = 0;
+	u32 fip, abort_tag;
+	struct lpfc_nodelist *ndlp = NULL;
+	union lpfc_wqe128 *wqe = &job->wqe;
+	struct lpfc_dmabuf *context2;
+	u32 els_id = LPFC_ELS_ID_DEFAULT;
+	u8 command_type = ELS_COMMAND_NON_FIP;
+
+	fip = phba->hba_flag & HBA_FIP_SUPPORT;
+	/* The fcp commands will set command type */
+	if (job->cmd_flag &  LPFC_IO_FCP)
+		command_type = FCP_COMMAND;
+	else if (fip && (job->cmd_flag & LPFC_FIP_ELS_ID_MASK))
+		command_type = ELS_COMMAND_FIP;
+	else
+		command_type = ELS_COMMAND_NON_FIP;
+
+	abort_tag = job->iotag;
+	cmnd = bf_get(wqe_cmnd, &wqe->els_req.wqe_com);
+
+	switch (cmnd) {
+	case CMD_ELS_REQUEST64_WQE:
+		if (job->cmd_flag & LPFC_IO_LIBDFC)
+			ndlp = job->context_un.ndlp;
+		else
+			ndlp = (struct lpfc_nodelist *)job->context1;
+
+		/* CCP CCPE PV PRI in word10 were set in the memcpy */
+		if (command_type == ELS_COMMAND_FIP)
+			els_id = ((job->cmd_flag & LPFC_FIP_ELS_ID_MASK)
+				  >> LPFC_FIP_ELS_ID_SHIFT);
+
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
+			context2 = (struct lpfc_dmabuf *)job->context2;
+			pcmd = (u32 *)context2->virt;
+			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
+				     *pcmd == ELS_CMD_SCR ||
+				     *pcmd == ELS_CMD_RDF ||
+				     *pcmd == ELS_CMD_EDC ||
+				     *pcmd == ELS_CMD_RSCN_XMT ||
+				     *pcmd == ELS_CMD_FDISC ||
+				     *pcmd == ELS_CMD_LOGO ||
+				     *pcmd == ELS_CMD_QFPA ||
+				     *pcmd == ELS_CMD_UVEM ||
+				     *pcmd == ELS_CMD_PLOGI)) {
+				bf_set(els_req64_sp, &wqe->els_req, 1);
+				bf_set(els_req64_sid, &wqe->els_req,
+				       job->vport->fc_myDID);
+
+				if ((*pcmd == ELS_CMD_FLOGI) &&
+				    !(phba->fc_topology ==
+				      LPFC_TOPOLOGY_LOOP))
+					bf_set(els_req64_sid, &wqe->els_req, 0);
+
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+				       phba->vpi_ids[job->vport->vpi]);
+			} else if (pcmd) {
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+				       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+			}
+		}
+
+		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+
+		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
+		bf_set(wqe_dbde, &wqe->els_req.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->els_req.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->els_req.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->els_req.wqe_com, LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->els_req.wqe_com, 0);
+		break;
+	case CMD_XMIT_ELS_RSP64_WQE:
+		ndlp = (struct lpfc_nodelist *)job->context1;
+
+		/* word4 */
+		wqe->xmit_els_rsp.word4 = 0;
+
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
+			if (job->vport->fc_flag & FC_PT2PT) {
+				bf_set(els_rsp64_sp, &wqe->xmit_els_rsp, 1);
+				bf_set(els_rsp64_sid, &wqe->xmit_els_rsp,
+				       job->vport->fc_myDID);
+				if (job->vport->fc_myDID == Fabric_DID) {
+					bf_set(wqe_els_did,
+					       &wqe->xmit_els_rsp.wqe_dest, 0);
+				}
+			}
+		}
+
+		bf_set(wqe_dbde, &wqe->xmit_els_rsp.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_els_rsp.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_qosd, &wqe->xmit_els_rsp.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->xmit_els_rsp.wqe_com,
+		       LPFC_WQE_LENLOC_WORD3);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
+
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+			bf_set(els_rsp64_sp, &wqe->xmit_els_rsp, 1);
+			bf_set(els_rsp64_sid, &wqe->xmit_els_rsp,
+			       job->vport->fc_myDID);
+			bf_set(wqe_ct, &wqe->xmit_els_rsp.wqe_com, 1);
+		}
+
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp,
+			       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+
+			if (bf_get(wqe_ct, &wqe->xmit_els_rsp.wqe_com))
+				bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+				       phba->vpi_ids[job->vport->vpi]);
+		}
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_GEN_REQUEST64_WQE:
+		/* Word 10 */
+		bf_set(wqe_dbde, &wqe->gen_req.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->gen_req.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->gen_req.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->gen_req.wqe_com, LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->gen_req.wqe_com, 0);
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_XMIT_SEQUENCE64_WQE:
+		if (phba->link_flag & LS_LOOPBACK_MODE)
+			bf_set(wqe_xo, &wqe->xmit_sequence.wge_ctl, 1);
+
+		wqe->xmit_sequence.rsvd3 = 0;
+		bf_set(wqe_pu, &wqe->xmit_sequence.wqe_com, 0);
+		bf_set(wqe_dbde, &wqe->xmit_sequence.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_sequence.wqe_com,
+		       LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_lenloc, &wqe->xmit_sequence.wqe_com,
+		       LPFC_WQE_LENLOC_WORD12);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_sequence.wqe_com, 0);
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_XMIT_BLS_RSP64_WQE:
+		bf_set(xmit_bls_rsp64_seqcnthi, &wqe->xmit_bls_rsp, 0xffff);
+		bf_set(wqe_xmit_bls_pt, &wqe->xmit_bls_rsp.wqe_dest, 0x1);
+		bf_set(wqe_ct, &wqe->xmit_bls_rsp.wqe_com, 1);
+		bf_set(wqe_ctxt_tag, &wqe->xmit_bls_rsp.wqe_com,
+		       phba->vpi_ids[phba->pport->vpi]);
+		bf_set(wqe_qosd, &wqe->xmit_bls_rsp.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->xmit_bls_rsp.wqe_com,
+		       LPFC_WQE_LENLOC_NONE);
+		/* Overwrite the pre-set comnd type with OTHER_COMMAND */
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_FCP_ICMND64_WQE:	/* task mgmt commands */
+	case CMD_ABORT_XRI_WQE:		/* abort iotag */
+	case CMD_SEND_FRAME:		/* mds loopback */
+		/* cases already formatted for sli4 wqe - no chgs necessary */
+		return;
+	default:
+		dump_stack();
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"6207 Invalid command 0x%x\n",
+				cmnd);
+		break;
+	}
+
+	wqe->generic.wqe_com.abort_tag = abort_tag;
+	bf_set(wqe_reqtag, &wqe->generic.wqe_com, job->iotag);
+	bf_set(wqe_cmd_type, &wqe->generic.wqe_com, command_type);
+	bf_set(wqe_cqid, &wqe->generic.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+}
-- 
2.26.2

