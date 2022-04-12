Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AC0C4167E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiDLXgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiDLXcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3F4C6258
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 2so83485pjw.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYc50toYgZMG620J8YLmhjANL06QCRGhOt9Zd647K5Q=;
        b=mJa1cLdDQFyxCy27m1O6QSDcp70V3A8gJQE1LIh9KNzkwVeW7zLtryHKhD7oozgMOb
         6csRH/EJWAB/f76jgUxLdGi/g3Jo6aOKmVAxdUBXvIrGn6A50ypMF2PuLh24JMs5i0qn
         kI8wbtPkNMGQRIUn5gB5aKYDEDJgrpO85o8AwaBAGHNgCmCcB8SmdrRivE/Y3ymjx7mP
         dGL8UwhdK/ZQYX4lzO7Ta+dWpye0KdXK3pCTkCdlAVTjfWWSk657mSdEfNHw2ttU1b1x
         jL8It9zVsAqelyxYMjcB5XWpjygEJE1uww8cis0L2i+RpHS3tMr2cUYSyBWZb9RAsinE
         HQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYc50toYgZMG620J8YLmhjANL06QCRGhOt9Zd647K5Q=;
        b=WZpJPU16IlCwwclo4kKANEwvOPnOw1viLjyCqFPF0pHrWEhHIW0d0Is/sdigG16QDt
         kEDlXfBeeq+R97IShkG8KqmMAjFDsjz+n7Kg0RwmJ39av+CG8nktiH5DvrpJjYrjuDBU
         IAeQVHC+EcvwaA7qX2bK7pV8cUrSvv0cD+EasLxYgPmZBD0DZHF3Jijg/rFYp0yy0k/U
         pmEIJ/8hkTEDQAwJjo/9nWtHlvq0nuVh2s/ZpAD26Sth8EgLk624hq+ZAr51m81I9nAo
         +2HwHFH2Ust0AhEIpneusAAoT7M7SsVhtkaYcu0Kx5FhaOMR88C4Z6Lb1bU3I2zjgzT8
         uCew==
X-Gm-Message-State: AOAM53377qLQTbG9k77W2m+3PmD7UJ2iAz783pAcy8/9ysWuH/LxQje5
        8i6diA3gkE4lsosQSgThw6KUo+5A9Hk=
X-Google-Smtp-Source: ABdhPJxr4dFYiEJYsEGetI6lKOF6CjjfVZLBOfOTpC1xqctg4FGaucx+2nIo0x9mEKUS2OSwprvcCQ==
X-Received: by 2002:a17:90b:3ec5:b0:1c7:77ab:3854 with SMTP id rm5-20020a17090b3ec500b001c777ab3854mr7296247pjb.156.1649802030509;
        Tue, 12 Apr 2022 15:20:30 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 20/26] lpfc: Fix field overload in lpfc_iocbq data structure
Date:   Tue, 12 Apr 2022 15:20:02 -0700
Message-Id: <20220412222008.126521-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The lpfc_iocbq data structure has void * pointers that are overloaded to be
as many as 8 different data types and the driver translates the void * by
casting.  This patch removes the void * pointers by declaring the specific
types needed by the driver.  It also expands the context_un to include more
seldom used pointer types to save structure bytes.  It also groups the u8
types together to pack the 8 bytes needed.  This work allows the lpfc_iocbq
data structure to be more strongly types and keeps it allocated from the
512 byte slab.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |  79 +++--
 drivers/scsi/lpfc/lpfc_ct.c        | 148 +++++-----
 drivers/scsi/lpfc/lpfc_els.c       | 443 ++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   8 +-
 drivers/scsi/lpfc/lpfc_init.c      |  12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  32 +--
 drivers/scsi/lpfc/lpfc_nvme.c      |  31 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  73 ++---
 drivers/scsi/lpfc/lpfc_scsi.c      |  17 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 120 ++++----
 drivers/scsi/lpfc/lpfc_sli.h       |  28 +-
 11 files changed, 490 insertions(+), 501 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 8b586fa90f70..ae46383b13bf 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -310,7 +310,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	int rc = 0;
 	u32 ulp_status, ulp_word4, total_data_placed;
 
-	dd_data = cmdiocbq->context1;
+	dd_data = cmdiocbq->context_un.dd_data;
 
 	/* Determine if job has been aborted */
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -328,10 +328,10 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	iocb = &dd_data->context_un.iocb;
-	ndlp = iocb->cmdiocbq->context_un.ndlp;
+	ndlp = iocb->cmdiocbq->ndlp;
 	rmp = iocb->rmp;
-	cmp = cmdiocbq->context2;
-	bmp = cmdiocbq->context3;
+	cmp = cmdiocbq->cmd_dmabuf;
+	bmp = cmdiocbq->bpl_dmabuf;
 	ulp_status = get_job_ulpstatus(phba, rspiocbq);
 	ulp_word4 = get_job_word4(phba, rspiocbq);
 	total_data_placed = get_job_data_placed(phba, rspiocbq);
@@ -470,14 +470,12 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 
 	cmdiocbq->num_bdes = num_entry;
 	cmdiocbq->vport = phba->pport;
-	cmdiocbq->context2 = cmp;
-	cmdiocbq->context3 = bmp;
+	cmdiocbq->cmd_dmabuf = cmp;
+	cmdiocbq->bpl_dmabuf = bmp;
 	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
 
 	cmdiocbq->cmd_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
-	cmdiocbq->context1 = dd_data;
-	cmdiocbq->context2 = cmp;
-	cmdiocbq->context3 = bmp;
+	cmdiocbq->context_un.dd_data = dd_data;
 
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
@@ -495,8 +493,8 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	cmdiocbq->context_un.ndlp = lpfc_nlp_get(ndlp);
-	if (!cmdiocbq->context_un.ndlp) {
+	cmdiocbq->ndlp = lpfc_nlp_get(ndlp);
+	if (!cmdiocbq->ndlp) {
 		rc = -ENODEV;
 		goto free_rmp;
 	}
@@ -573,9 +571,9 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	int rc = 0;
 	u32 ulp_status, ulp_word4, total_data_placed;
 
-	dd_data = cmdiocbq->context1;
+	dd_data = cmdiocbq->context_un.dd_data;
 	ndlp = dd_data->context_un.iocb.ndlp;
-	cmdiocbq->context1 = ndlp;
+	cmdiocbq->ndlp = ndlp;
 
 	/* Determine if job has been aborted */
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -595,7 +593,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	ulp_status = get_job_ulpstatus(phba, rspiocbq);
 	ulp_word4 = get_job_word4(phba, rspiocbq);
 	total_data_placed = get_job_data_placed(phba, rspiocbq);
-	pcmd = (struct lpfc_dmabuf *)cmdiocbq->context2;
+	pcmd = cmdiocbq->cmd_dmabuf;
 	prsp = (struct lpfc_dmabuf *)pcmd->list.next;
 
 	/* Copy the completed job data or determine the job status if job is
@@ -711,8 +709,8 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	/* Transfer the request payload to allocated command dma buffer */
 	sg_copy_to_buffer(job->request_payload.sg_list,
 			  job->request_payload.sg_cnt,
-			  ((struct lpfc_dmabuf *)cmdiocbq->context2)->virt,
-			  job->request_payload.payload_len);
+			  cmdiocbq->cmd_dmabuf->virt,
+			  cmdsize);
 
 	rpi = ndlp->nlp_rpi;
 
@@ -722,8 +720,8 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	else
 		cmdiocbq->iocb.ulpContext = rpi;
 	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
-	cmdiocbq->context1 = dd_data;
-	cmdiocbq->context_un.ndlp = ndlp;
+	cmdiocbq->context_un.dd_data = dd_data;
+	cmdiocbq->ndlp = ndlp;
 	cmdiocbq->cmd_cmpl = lpfc_bsg_rport_els_cmp;
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
@@ -742,8 +740,8 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	cmdiocbq->context1 = lpfc_nlp_get(ndlp);
-	if (!cmdiocbq->context1) {
+	cmdiocbq->ndlp = lpfc_nlp_get(ndlp);
+	if (!cmdiocbq->ndlp) {
 		rc = -EIO;
 		goto linkdown_err;
 	}
@@ -917,8 +915,8 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct ulp_bde64 *bde;
 	dma_addr_t dma_addr;
 	int i;
-	struct lpfc_dmabuf *bdeBuf1 = piocbq->context2;
-	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
+	struct lpfc_dmabuf *bdeBuf1 = piocbq->cmd_dmabuf;
+	struct lpfc_dmabuf *bdeBuf2 = piocbq->bpl_dmabuf;
 	struct lpfc_sli_ct_request *ct_req;
 	struct bsg_job *job = NULL;
 	struct fc_bsg_reply *bsg_reply;
@@ -985,9 +983,8 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		list_for_each_entry(iocbq, &head, list) {
 			size = 0;
 			if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
-				bdeBuf1 = iocbq->context2;
-				bdeBuf2 = iocbq->context3;
-
+				bdeBuf1 = iocbq->cmd_dmabuf;
+				bdeBuf2 = iocbq->bpl_dmabuf;
 			}
 			if (phba->sli_rev == LPFC_SLI_REV4)
 				bde_count = iocbq->wcqe_cmpl.word3;
@@ -1384,7 +1381,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	int rc = 0;
 	u32 ulp_status, ulp_word4;
 
-	dd_data = cmdiocbq->context1;
+	dd_data = cmdiocbq->context_un.dd_data;
 
 	/* Determine if job has been aborted */
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -1401,8 +1398,8 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	ndlp = dd_data->context_un.iocb.ndlp;
-	cmp = cmdiocbq->context2;
-	bmp = cmdiocbq->context3;
+	cmp = cmdiocbq->cmd_dmabuf;
+	bmp = cmdiocbq->bpl_dmabuf;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocbq);
 	ulp_word4 = get_job_word4(phba, rspiocbq);
@@ -1529,10 +1526,10 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 
 	ctiocb->cmd_flag |= LPFC_IO_LIBDFC;
 	ctiocb->vport = phba->pport;
-	ctiocb->context1 = dd_data;
-	ctiocb->context2 = cmp;
-	ctiocb->context3 = bmp;
-	ctiocb->context_un.ndlp = ndlp;
+	ctiocb->context_un.dd_data = dd_data;
+	ctiocb->cmd_dmabuf = cmp;
+	ctiocb->bpl_dmabuf = bmp;
+	ctiocb->ndlp = ndlp;
 	ctiocb->cmd_cmpl = lpfc_issue_ct_rsp_cmp;
 
 	dd_data->type = TYPE_IOCB;
@@ -2671,7 +2668,7 @@ static int lpfcdiag_loop_get_xri(struct lpfc_hba *phba, uint16_t rpi,
 	ctreq->CommandResponse.bits.CmdRsp = ELX_LOOPBACK_XRI_SETUP;
 	ctreq->CommandResponse.bits.Size = 0;
 
-	cmdiocbq->context3 = dmabuf;
+	cmdiocbq->bpl_dmabuf = dmabuf;
 	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->cmd_cmpl = NULL;
@@ -3231,7 +3228,7 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 	cmdiocbq->cmd_flag |= LPFC_IO_LOOPBACK;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->cmd_cmpl = NULL;
-	cmdiocbq->context3 = txbmp;
+	cmdiocbq->bpl_dmabuf = txbmp;
 
 	if (phba->sli_rev < LPFC_SLI_REV4) {
 		lpfc_sli_prep_xmit_seq64(phba, cmdiocbq, txbmp, 0, txxri,
@@ -3384,7 +3381,7 @@ lpfc_bsg_get_dfc_rev(struct bsg_job *job)
  * This is completion handler function for mailbox commands issued from
  * lpfc_bsg_issue_mbox function. This function is called by the
  * mailbox event handler function with no lock held. This function
- * will wake up thread waiting on the wait queue pointed by context1
+ * will wake up thread waiting on the wait queue pointed by dd_data
  * of the mailbox.
  **/
 static void
@@ -5034,9 +5031,9 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	unsigned int rsp_size;
 	int rc = 0;
 
-	dd_data = cmdiocbq->context1;
-	cmp = cmdiocbq->context2;
-	bmp = cmdiocbq->context3;
+	dd_data = cmdiocbq->context_un.dd_data;
+	cmp = cmdiocbq->cmd_dmabuf;
+	bmp = cmdiocbq->bpl_dmabuf;
 	menlo = &dd_data->context_un.menlo;
 	rmp = menlo->rmp;
 	rsp = &rspiocbq->iocb;
@@ -5233,9 +5230,9 @@ lpfc_menlo_cmd(struct bsg_job *job)
 	/* We want the firmware to timeout before we do */
 	cmd->ulpTimeout = MENLO_TIMEOUT - 5;
 	cmdiocbq->cmd_cmpl = lpfc_bsg_menlo_cmd_cmp;
-	cmdiocbq->context1 = dd_data;
-	cmdiocbq->context2 = cmp;
-	cmdiocbq->context3 = bmp;
+	cmdiocbq->context_un.dd_data = dd_data;
+	cmdiocbq->cmd_dmabuf = cmp;
+	cmdiocbq->bpl_dmabuf = bmp;
 	if (menlo_cmd->cmd == LPFC_BSG_VENDOR_MENLO_CMD) {
 		cmd->ulpCommand = CMD_GEN_REQUEST64_CR;
 		cmd->ulpPU = MENLO_PU; /* 3 */
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c74833ed78c6..6cda8ee25d4f 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -118,22 +118,22 @@ lpfc_ct_unsol_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *mp, *bmp;
 
-	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	ndlp = cmdiocb->ndlp;
 	if (ndlp)
 		lpfc_nlp_put(ndlp);
 
-	mp = cmdiocb->context2;
-	bmp = cmdiocb->context3;
+	mp = cmdiocb->rsp_dmabuf;
+	bmp = cmdiocb->bpl_dmabuf;
 	if (mp) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
-		cmdiocb->context2 = NULL;
+		cmdiocb->rsp_dmabuf = NULL;
 	}
 
 	if (bmp) {
 		lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 		kfree(bmp);
-		cmdiocb->context3 = NULL;
+		cmdiocb->bpl_dmabuf = NULL;
 	}
 
 	lpfc_sli_release_iocbq(phba, cmdiocb);
@@ -232,18 +232,17 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 	}
 
 	/* Save for completion so we can release these resources */
-	cmdiocbq->context2 = (uint8_t *)mp;
-	cmdiocbq->context3 = (uint8_t *)bmp;
+	cmdiocbq->rsp_dmabuf = mp;
+	cmdiocbq->bpl_dmabuf = bmp;
 	cmdiocbq->cmd_cmpl = lpfc_ct_unsol_cmpl;
 	tmo = (3 * phba->fc_ratov);
 
 	cmdiocbq->retry = 0;
 	cmdiocbq->vport = vport;
-	cmdiocbq->context_un.ndlp = NULL;
 	cmdiocbq->drvrTimeout = tmo + LPFC_DRVR_TIMEOUT;
 
-	cmdiocbq->context1 = lpfc_nlp_get(ndlp);
-	if (!cmdiocbq->context1)
+	cmdiocbq->ndlp = lpfc_nlp_get(ndlp);
+	if (!cmdiocbq->ndlp)
 		goto ct_no_ndlp;
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
@@ -310,8 +309,8 @@ lpfc_ct_handle_mibreq(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocbq)
 		return;
 	}
 
-	ct_req = ((struct lpfc_sli_ct_request *)
-		 (((struct lpfc_dmabuf *)ctiocbq->context2)->virt));
+	ct_req = (struct lpfc_sli_ct_request *)ctiocbq->cmd_dmabuf->virt;
+
 	mi_cmd = ct_req->CommandResponse.bits.CmdRsp;
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "6442 : MI Cmd : x%x Not Supported\n", mi_cmd);
@@ -347,14 +346,14 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	uint32_t size;
 	struct list_head head;
 	struct lpfc_sli_ct_request *ct_req;
-	struct lpfc_dmabuf *bdeBuf1 = ctiocbq->context2;
-	struct lpfc_dmabuf *bdeBuf2 = ctiocbq->context3;
+	struct lpfc_dmabuf *bdeBuf1 = ctiocbq->cmd_dmabuf;
+	struct lpfc_dmabuf *bdeBuf2 = ctiocbq->bpl_dmabuf;
 	u32 status, parameter, bde_count = 0;
 	struct lpfc_wcqe_complete *wcqe_cmpl = NULL;
 
-	ctiocbq->context1 = NULL;
-	ctiocbq->context2 = NULL;
-	ctiocbq->context3 = NULL;
+	ctiocbq->cmd_dmabuf = NULL;
+	ctiocbq->rsp_dmabuf = NULL;
+	ctiocbq->bpl_dmabuf = NULL;
 
 	wcqe_cmpl = &ctiocbq->wcqe_cmpl;
 	status = get_job_ulpstatus(phba, ctiocbq);
@@ -382,12 +381,11 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if (bde_count == 0)
 		return;
 
-	ctiocbq->context2 = bdeBuf1;
+	ctiocbq->cmd_dmabuf = bdeBuf1;
 	if (bde_count == 2)
-		ctiocbq->context3 = bdeBuf2;
+		ctiocbq->bpl_dmabuf = bdeBuf2;
 
-	ct_req = ((struct lpfc_sli_ct_request *)
-		 (((struct lpfc_dmabuf *)ctiocbq->context2)->virt));
+	ct_req = (struct lpfc_sli_ct_request *)ctiocbq->cmd_dmabuf->virt;
 
 	if (ct_req->FsType == SLI_CT_MANAGEMENT_SERVICE &&
 	    ct_req->FsSubType == SLI_CT_MIB_Subtypes) {
@@ -408,8 +406,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 			if (!bde_count)
 				continue;
-			bdeBuf1 = iocb->context2;
-			iocb->context2 = NULL;
+			bdeBuf1 = iocb->cmd_dmabuf;
+			iocb->cmd_dmabuf = NULL;
 			if (phba->sli_rev == LPFC_SLI_REV4)
 				size = iocb->wqe.gen_req.bde.tus.f.bdeSize;
 			else
@@ -417,8 +415,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			lpfc_ct_unsol_buffer(phba, ctiocbq, bdeBuf1, size);
 			lpfc_in_buf_free(phba, bdeBuf1);
 			if (bde_count == 2) {
-				bdeBuf2 = iocb->context3;
-				iocb->context3 = NULL;
+				bdeBuf2 = iocb->bpl_dmabuf;
+				iocb->bpl_dmabuf = NULL;
 				if (phba->sli_rev == LPFC_SLI_REV4)
 					size = iocb->unsol_rcv_len;
 				else
@@ -549,24 +547,25 @@ lpfc_ct_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocb)
 {
 	struct lpfc_dmabuf *buf_ptr;
 
-	/* I/O job is complete so context is now invalid*/
-	ctiocb->context_un.ndlp = NULL;
-	if (ctiocb->context1) {
-		buf_ptr = (struct lpfc_dmabuf *) ctiocb->context1;
+	/* IOCBQ job structure gets cleaned during release.  Just release
+	 * the dma buffers here.
+	 */
+	if (ctiocb->cmd_dmabuf) {
+		buf_ptr = ctiocb->cmd_dmabuf;
 		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
 		kfree(buf_ptr);
-		ctiocb->context1 = NULL;
+		ctiocb->cmd_dmabuf = NULL;
 	}
-	if (ctiocb->context2) {
-		lpfc_free_ct_rsp(phba, (struct lpfc_dmabuf *) ctiocb->context2);
-		ctiocb->context2 = NULL;
+	if (ctiocb->rsp_dmabuf) {
+		lpfc_free_ct_rsp(phba, ctiocb->rsp_dmabuf);
+		ctiocb->rsp_dmabuf = NULL;
 	}
 
-	if (ctiocb->context3) {
-		buf_ptr = (struct lpfc_dmabuf *) ctiocb->context3;
+	if (ctiocb->bpl_dmabuf) {
+		buf_ptr = ctiocb->bpl_dmabuf;
 		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
 		kfree(buf_ptr);
-		ctiocb->context3 = NULL;
+		ctiocb->bpl_dmabuf = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, ctiocb);
 	return 0;
@@ -605,11 +604,11 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	/* Update the num_entry bde count */
 	geniocb->num_bdes = num_entry;
 
-	geniocb->context3 = (uint8_t *) bmp;
+	geniocb->bpl_dmabuf = bmp;
 
 	/* Save for completion so we can release these resources */
-	geniocb->context1 = (uint8_t *) inp;
-	geniocb->context2 = (uint8_t *) outp;
+	geniocb->cmd_dmabuf = inp;
+	geniocb->rsp_dmabuf = outp;
 
 	geniocb->event_tag = event_tag;
 
@@ -635,8 +634,8 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	geniocb->drvrTimeout = tmo + LPFC_DRVR_TIMEOUT;
 	geniocb->vport = vport;
 	geniocb->retry = retry;
-	geniocb->context_un.ndlp = lpfc_nlp_get(ndlp);
-	if (!geniocb->context_un.ndlp)
+	geniocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!geniocb->ndlp)
 		goto out;
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
@@ -926,13 +925,12 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int rc, type;
 
 	/* First save ndlp, before we overwrite it */
-	ndlp = cmdiocb->context_un.ndlp;
+	ndlp = cmdiocb->ndlp;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
-
-	inp = (struct lpfc_dmabuf *) cmdiocb->context1;
-	outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+	cmdiocb->rsp_iocb = rspiocb;
+	inp = cmdiocb->cmd_dmabuf;
+	outp = cmdiocb->rsp_dmabuf;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 		 "GID_FT cmpl:     status:x%x/x%x rtry:%d",
@@ -1143,12 +1141,12 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int rc;
 
 	/* First save ndlp, before we overwrite it */
-	ndlp = cmdiocb->context_un.ndlp;
+	ndlp = cmdiocb->ndlp;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
-	inp = (struct lpfc_dmabuf *)cmdiocb->context1;
-	outp = (struct lpfc_dmabuf *)cmdiocb->context2;
+	cmdiocb->rsp_iocb = rspiocb;
+	inp = cmdiocb->cmd_dmabuf;
+	outp = cmdiocb->rsp_dmabuf;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 			      "GID_PT cmpl:     status:x%x/x%x rtry:%d",
@@ -1346,8 +1344,8 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_dmabuf *inp = (struct lpfc_dmabuf *) cmdiocb->context1;
-	struct lpfc_dmabuf *outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+	struct lpfc_dmabuf *inp = cmdiocb->cmd_dmabuf;
+	struct lpfc_dmabuf *outp = cmdiocb->rsp_dmabuf;
 	struct lpfc_sli_ct_request *CTrsp;
 	int did, rc, retry;
 	uint8_t fbits;
@@ -1426,7 +1424,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 cmdiocb->retry, did);
 				if (rc == 0) {
 					/* success */
-					free_ndlp = cmdiocb->context_un.ndlp;
+					free_ndlp = cmdiocb->ndlp;
 					lpfc_ct_free_iocb(phba, cmdiocb);
 					lpfc_nlp_put(free_ndlp);
 					return;
@@ -1483,7 +1481,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 iocb_free:
-	free_ndlp = cmdiocb->context_un.ndlp;
+	free_ndlp = cmdiocb->ndlp;
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
 	return;
@@ -1494,8 +1492,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct lpfc_dmabuf *inp = (struct lpfc_dmabuf *)cmdiocb->context1;
-	struct lpfc_dmabuf *outp = (struct lpfc_dmabuf *)cmdiocb->context2;
+	struct lpfc_dmabuf *inp = cmdiocb->cmd_dmabuf;
+	struct lpfc_dmabuf *outp = cmdiocb->rsp_dmabuf;
 	struct lpfc_sli_ct_request *CTrsp;
 	int did;
 	struct lpfc_nodelist *ndlp = NULL;
@@ -1519,7 +1517,7 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 	/* Preserve the nameserver node to release the reference. */
-	ns_ndlp = cmdiocb->context_un.ndlp;
+	ns_ndlp = cmdiocb->ndlp;
 
 	if (ulp_status == IOSTAT_SUCCESS) {
 		/* Good status, continue checking */
@@ -1605,13 +1603,13 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 
 	/* First save ndlp, before we overwrite it */
-	ndlp = cmdiocb->context_un.ndlp;
+	ndlp = cmdiocb->ndlp;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
+	cmdiocb->rsp_iocb = rspiocb;
 
-	inp = (struct lpfc_dmabuf *) cmdiocb->context1;
-	outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+	inp = cmdiocb->cmd_dmabuf;
+	outp = cmdiocb->rsp_dmabuf;
 
 	cmdcode = be16_to_cpu(((struct lpfc_sli_ct_request *) inp->virt)->
 					CommandResponse.bits.CmdRsp);
@@ -1672,8 +1670,8 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		struct lpfc_dmabuf *outp;
 		struct lpfc_sli_ct_request *CTrsp;
 
-		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
-		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		outp = cmdiocb->rsp_dmabuf;
+		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
 			vport->ct_flags |= FC_CT_RFT_ID;
@@ -1693,7 +1691,7 @@ lpfc_cmpl_ct_cmd_rnn_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		struct lpfc_dmabuf *outp;
 		struct lpfc_sli_ct_request *CTrsp;
 
-		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		outp = cmdiocb->rsp_dmabuf;
 		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
@@ -1714,8 +1712,8 @@ lpfc_cmpl_ct_cmd_rspn_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		struct lpfc_dmabuf *outp;
 		struct lpfc_sli_ct_request *CTrsp;
 
-		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
-		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		outp = cmdiocb->rsp_dmabuf;
+		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
 			vport->ct_flags |= FC_CT_RSPN_ID;
@@ -1735,7 +1733,7 @@ lpfc_cmpl_ct_cmd_rsnn_nn(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		struct lpfc_dmabuf *outp;
 		struct lpfc_sli_ct_request *CTrsp;
 
-		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		outp = cmdiocb->rsp_dmabuf;
 		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
@@ -1768,8 +1766,8 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		struct lpfc_dmabuf *outp;
 		struct lpfc_sli_ct_request *CTrsp;
 
-		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
-		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		outp = cmdiocb->rsp_dmabuf;
+		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
 			vport->ct_flags |= FC_CT_RFF_ID;
@@ -1865,7 +1863,7 @@ lpfc_get_gidft_type(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb)
 	struct lpfc_dmabuf *mp;
 	uint32_t type;
 
-	mp = cmdiocb->context1;
+	mp = cmdiocb->cmd_dmabuf;
 	if (mp == NULL)
 		return 0;
 	CtReq = (struct lpfc_sli_ct_request *)mp->virt;
@@ -2171,8 +2169,8 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		       struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct lpfc_dmabuf *inp = cmdiocb->context1;
-	struct lpfc_dmabuf *outp = cmdiocb->context2;
+	struct lpfc_dmabuf *inp = cmdiocb->cmd_dmabuf;
+	struct lpfc_dmabuf *outp = cmdiocb->rsp_dmabuf;
 	struct lpfc_sli_ct_request *CTcmd = inp->virt;
 	struct lpfc_sli_ct_request *CTrsp = outp->virt;
 	uint16_t fdmi_cmd = CTcmd->CommandResponse.bits.CmdRsp;
@@ -2226,7 +2224,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ulp_word4);
 	}
 
-	free_ndlp = cmdiocb->context_un.ndlp;
+	free_ndlp = cmdiocb->ndlp;
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
 
@@ -3812,8 +3810,8 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		      struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct lpfc_dmabuf *inp = cmdiocb->context1;
-	struct lpfc_dmabuf *outp = cmdiocb->context2;
+	struct lpfc_dmabuf *inp = cmdiocb->cmd_dmabuf;
+	struct lpfc_dmabuf *outp = cmdiocb->rsp_dmabuf;
 	struct lpfc_sli_ct_request *ctcmd = inp->virt;
 	struct lpfc_sli_ct_request *ctrsp = outp->virt;
 	u16 rsp = ctrsp->CommandResponse.bits.CmdRsp;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3801c39b62d4..469c3cadffdd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -152,7 +152,7 @@ lpfc_els_chk_latt(struct lpfc_vport *vport)
  * Buffer Descriptor Entries (BDEs), allocates buffers for both command
  * payload and response payload (if expected). The reference count on the
  * ndlp is incremented by 1 and the reference to the ndlp is put into
- * context1 of the IOCB data structure for this IOCB to hold the ndlp
+ * ndlp of the IOCB data structure for this IOCB to hold the ndlp
  * reference for the command's callback function to access later.
  *
  * Return code
@@ -279,8 +279,8 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, u8 expect_rsp,
 		bpl->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
 	}
 
-	elsiocb->context2 = pcmd;
-	elsiocb->context3 = pbuflist;
+	elsiocb->cmd_dmabuf = pcmd;
+	elsiocb->bpl_dmabuf = pbuflist;
 	elsiocb->retry = retry;
 	elsiocb->vport = vport;
 	elsiocb->drvrTimeout = (phba->fc_ratov << 1) + LPFC_DRVR_TIMEOUT;
@@ -959,9 +959,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_nodelist *ndlp = cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	IOCB_t *irsp;
-	struct lpfc_dmabuf *pcmd = cmdiocb->context2, *prsp;
+	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf, *prsp;
 	struct serv_parm *sp;
 	uint16_t fcf_index;
 	int rc;
@@ -1231,7 +1231,7 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t cmd;
 	u32 ulp_status, ulp_word4;
 
-	pcmd = (uint32_t *)(((struct lpfc_dmabuf *)cmdiocb->context2)->virt);
+	pcmd = (uint32_t *)cmdiocb->cmd_dmabuf->virt;
 	cmd = *pcmd;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
@@ -1264,7 +1264,7 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * out FLOGI ELS command with one outstanding fabric IOCB at a time.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the FLOGI ELS command.
  *
  * Return code
@@ -1294,7 +1294,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 1;
 
 	wqe = &elsiocb->wqe;
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	icmd = &elsiocb->iocb;
 
 	/* For FLOGI request, remainder of payload is service parameters */
@@ -1371,8 +1371,8 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"Issue FLOGI:     opt:x%x",
 		phba->sli3_options, 0, 0);
 
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -1473,7 +1473,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
 		ulp_command = get_job_cmnd(phba, iocb);
 		if (ulp_command == CMD_ELS_REQUEST64_CR) {
-			ndlp = (struct lpfc_nodelist *)(iocb->context1);
+			ndlp = iocb->ndlp;
 			if (ndlp && ndlp->nlp_DID == Fabric_DID) {
 				if ((phba->pport->fc_flag & FC_PT2PT) &&
 				    !(phba->pport->fc_flag & FC_PT2PT_PLOGI))
@@ -1918,14 +1918,14 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct lpfc_nodelist *ndlp = cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_node_rrq *rrq;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	rrq = cmdiocb->context_un.rrq;
-	cmdiocb->context_un.rsp_iocb = rspiocb;
+	cmdiocb->rsp_iocb = rspiocb;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"RRQ cmpl:      status:x%x/x%x did:x%x",
@@ -1994,7 +1994,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
+	cmdiocb->rsp_iocb = rspiocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -2097,8 +2097,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						NLP_EVT_DEVICE_RM);
 	} else {
 		/* Good status, call state machine */
-		prsp = list_entry(((struct lpfc_dmabuf *)
-				   cmdiocb->context2)->list.next,
+		prsp = list_entry(cmdiocb->cmd_dmabuf->list.next,
 				  struct lpfc_dmabuf, list);
 		ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);
 
@@ -2143,7 +2142,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 out_freeiocb:
 	/* Release the reference on the original I/O request. */
-	free_ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	free_ndlp = cmdiocb->ndlp;
 
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
@@ -2163,7 +2162,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * the lpfc_sli_issue_iocb() routine to send out PLOGI ELS command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding
- * the ndlp and the reference to ndlp will be stored into the context1 field
+ * the ndlp and the reference to ndlp will be stored into the ndlp field
  * of the IOCB for the completion callback function to the PLOGI ELS command.
  *
  * Return code
@@ -2214,7 +2213,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	ndlp->nlp_flag &= ~NLP_FCP_PRLI_RJT;
 	spin_unlock_irq(&ndlp->lock);
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	/* For PLOGI request, remainder of payload is service parameters */
 	*((uint32_t *) (pcmd)) = ELS_CMD_PLOGI;
@@ -2266,8 +2265,8 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue PLOGI:     did:x%x refcnt %d",
 			      did, kref_read(&ndlp->kref), 0);
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -2308,9 +2307,9 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
+	cmdiocb->rsp_iocb = rspiocb;
 
-	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	ndlp = cmdiocb->ndlp;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -2423,7 +2422,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * routine lpfc_sli_issue_iocb() to send out PRLI command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the PRLI ELS command.
  *
  * Return code
@@ -2498,7 +2497,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	/* For PRLI request, remainder of payload is service parameters */
 	memset(pcmd, 0, cmdsize);
@@ -2576,8 +2575,8 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue PRLI:  did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -2762,9 +2761,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
+	cmdiocb->rsp_iocb = rspiocb;
 
-	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	ndlp = cmdiocb->ndlp;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -2863,7 +2862,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * to issue the ADISC ELS command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the ADISC ELS command.
  *
  * Return code
@@ -2887,7 +2886,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	/* For ADISC request, remainder of payload is service parameters */
 	*((uint32_t *) (pcmd)) = ELS_CMD_ADISC;
@@ -2905,8 +2904,8 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_ADISC_SND;
 	spin_unlock_irq(&ndlp->lock);
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto err;
 	}
@@ -2946,7 +2945,7 @@ static void
 lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_vport *vport = ndlp->vport;
 	IOCB_t *irsp;
 	unsigned long flags;
@@ -2957,7 +2956,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 tmo;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
-	cmdiocb->context_un.rsp_iocb = rspiocb;
+	cmdiocb->rsp_iocb = rspiocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -3099,7 +3098,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * lpfc_sli_issue_iocb() routine to send out the LOGO ELS command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the LOGO ELS command.
  *
  * Callers of this routine are expected to unregister the RPI first
@@ -3131,7 +3130,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_LOGO;
 	pcmd += sizeof(uint32_t);
 
@@ -3146,8 +3145,8 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	ndlp->nlp_flag &= ~NLP_ISSUE_LOGO;
 	spin_unlock_irq(&ndlp->lock);
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto err;
 	}
@@ -3225,7 +3224,7 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check to see if link went down during discovery */
 	lpfc_els_chk_latt(vport);
 
-	free_ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	free_ndlp = cmdiocb->ndlp;
 
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
@@ -3341,7 +3340,7 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_dmabuf *pcmd, *prsp;
 	u32 *pdata;
 	u32 cmd;
-	struct lpfc_nodelist *ndlp = cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
@@ -3366,7 +3365,7 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 "0217 ELS cmd tag x%x completes Data: x%x x%x x%x x%x\n",
 			 iotag, ulp_status, ulp_word4, tmo, cmdiocb->retry);
 
-	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	if (!pcmd)
 		goto out;
 
@@ -3456,7 +3455,7 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * routine is invoked to send the SCR IOCB.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the SCR ELS command.
  *
  * Return code
@@ -3498,7 +3497,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 			return 1;
 		}
 	}
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_SCR;
 	pcmd += sizeof(uint32_t);
@@ -3513,8 +3512,8 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 
 	phba->fc_stat.elsXmitSCR++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -3545,7 +3544,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
  *  replay the RSCN to registered recipients.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the RSCN ELS command.
  *
  * Return code
@@ -3595,7 +3594,7 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	if (!elsiocb)
 		return 1;
 
-	event = ((struct lpfc_dmabuf *)elsiocb->context2)->virt;
+	event = elsiocb->cmd_dmabuf->virt;
 
 	event->rscn.rscn_cmd = ELS_RSCN;
 	event->rscn.rscn_page_len = sizeof(struct fc_els_rscn_page);
@@ -3610,8 +3609,8 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 
 	phba->fc_stat.elsXmitRSCN++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_cmd;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -3644,7 +3643,7 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
  * lpfc_sli_issue_iocb() routine is invoked to send the FARPR ELS command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the FARPR ELS command.
  *
  * Return code
@@ -3679,7 +3678,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_FARPR;
 	pcmd += sizeof(uint32_t);
@@ -3709,8 +3708,8 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 
 	phba->fc_stat.elsXmitFARPR++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_cmd;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -3741,7 +3740,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
  * for diagnostic functions.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the RDF ELS command.
  *
  * Return code
@@ -3778,8 +3777,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 		return -ENOMEM;
 
 	/* Configure the payload for the supported FPIN events. */
-	prdf = (struct lpfc_els_rdf_req *)
-		(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	prdf = (struct lpfc_els_rdf_req *)elsiocb->cmd_dmabuf->virt;
 	memset(prdf, 0, cmdsize);
 	prdf->rdf.fpin_cmd = ELS_RDF;
 	prdf->rdf.desc_len = cpu_to_be32(sizeof(struct lpfc_els_rdf_req) -
@@ -3800,8 +3798,8 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 
 	phba->cgn_fpin_frequency = LPFC_FPIN_INIT_FREQ;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return -EIO;
 	}
@@ -3990,7 +3988,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp;
 	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	ndlp = cmdiocb->context1;
+	ndlp = cmdiocb->ndlp;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -4014,7 +4012,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			"4201 EDC cmd tag x%x completes Data: x%x x%x x%x\n",
 			iotag, ulp_status, ulp_word4, tmo);
 
-	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	if (!pcmd)
 		goto out;
 
@@ -4263,7 +4261,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 		goto try_rdf;
 
 	/* Configure the payload for the supported Diagnostics capabilities. */
-	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	pcmd = (u8 *)elsiocb->cmd_dmabuf->virt;
 	memset(pcmd, 0, cmdsize);
 	edc_req = (struct lpfc_els_edc_req *)pcmd;
 	edc_req->edc.desc_len = cpu_to_be32(cgn_desc_size);
@@ -4282,8 +4280,8 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 			 phba->cgn_reg_fpin);
 
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return -EIO;
 	}
@@ -4561,8 +4559,8 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	union lpfc_wqe128 *irsp = &rspiocb->wqe;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
-	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
+	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf;
 	uint32_t *elscmd;
 	struct ls_rjt stat;
 	int retry = 0, maxretry = lpfc_max_els_tries, delay = 0;
@@ -4574,7 +4572,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 
 
-	/* Note: context2 may be 0 for internal driver abort
+	/* Note: cmd_dmabuf may be 0 for internal driver abort
 	 * of delays ELS command.
 	 */
 
@@ -5068,10 +5066,10 @@ lpfc_els_free_bpl(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr)
  * command IOCB data structure contains the reference to various associated
  * resources, these fields must be set to NULL if the associated reference
  * not present:
- *   context1 - reference to ndlp
- *   context2 - reference to cmd
- *   context2->next - reference to rsp
- *   context3 - reference to bpl
+ *   cmd_dmabuf - reference to cmd.
+ *   cmd_dmabuf->next - reference to rsp
+ *   rsp_dmabuf - unused
+ *   bpl_dmabuf - reference to bpl
  *
  * It first properly decrements the reference count held on ndlp for the
  * IOCB completion callback function. If LPFC_DELAY_MEM_FREE flag is not
@@ -5091,19 +5089,19 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
 
-	/* The I/O iocb is complete.  Clear the context1 data. */
-	elsiocb->context1 = NULL;
+	/* The I/O iocb is complete.  Clear the node and first dmbuf */
+	elsiocb->ndlp = NULL;
 
-	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
-	if (elsiocb->context2) {
+	/* cmd_dmabuf = cmd,  cmd_dmabuf->next = rsp, bpl_dmabuf = bpl */
+	if (elsiocb->cmd_dmabuf) {
 		if (elsiocb->cmd_flag & LPFC_DELAY_MEM_FREE) {
 			/* Firmware could still be in progress of DMAing
 			 * payload, so don't free data buffer till after
 			 * a hbeat.
 			 */
 			elsiocb->cmd_flag &= ~LPFC_DELAY_MEM_FREE;
-			buf_ptr = elsiocb->context2;
-			elsiocb->context2 = NULL;
+			buf_ptr = elsiocb->cmd_dmabuf;
+			elsiocb->cmd_dmabuf = NULL;
 			if (buf_ptr) {
 				buf_ptr1 = NULL;
 				spin_lock_irq(&phba->hbalock);
@@ -5122,16 +5120,16 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 				spin_unlock_irq(&phba->hbalock);
 			}
 		} else {
-			buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
+			buf_ptr1 = elsiocb->cmd_dmabuf;
 			lpfc_els_free_data(phba, buf_ptr1);
-			elsiocb->context2 = NULL;
+			elsiocb->cmd_dmabuf = NULL;
 		}
 	}
 
-	if (elsiocb->context3) {
-		buf_ptr = (struct lpfc_dmabuf *) elsiocb->context3;
+	if (elsiocb->bpl_dmabuf) {
+		buf_ptr = elsiocb->bpl_dmabuf;
 		lpfc_els_free_bpl(phba, buf_ptr);
-		elsiocb->context3 = NULL;
+		elsiocb->bpl_dmabuf = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, elsiocb);
 	return 0;
@@ -5147,7 +5145,7 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
  * Accept (ACC) Response ELS command. This routine is invoked to indicate
  * the completion of the LOGO process. It invokes the lpfc_nlp_not_used() to
  * release the ndlp if it has the last reference remaining (reference count
- * is 1). If succeeded (meaning ndlp released), it sets the IOCB context1
+ * is 1). If succeeded (meaning ndlp released), it sets the iocb ndlp
  * field to NULL to inform the following lpfc_els_free_iocb() routine no
  * ndlp reference count needs to be decremented. Otherwise, the ndlp
  * reference use-count shall be decremented by the lpfc_els_free_iocb()
@@ -5158,7 +5156,7 @@ static void
 lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		       struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_vport *vport = cmdiocb->vport;
 	u32 ulp_status, ulp_word4;
 
@@ -5204,7 +5202,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			/* Indicate the node has already released, should
 			 * not reference to it from within lpfc_els_free_iocb.
 			 */
-			cmdiocb->context1 = NULL;
+			cmdiocb->ndlp = NULL;
 		}
 	}
  out:
@@ -5233,7 +5231,7 @@ void
 lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 	u32 mbx_flag = pmb->mbox_flag;
 	u32 mbx_cmd = pmb->u.mb.mbxCommand;
 
@@ -5285,7 +5283,7 @@ static void
 lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_vport *vport = ndlp ? ndlp->vport : NULL;
 	struct Scsi_Host  *shost = vport ? lpfc_shost_from_vport(vport) : NULL;
 	IOCB_t  *irsp;
@@ -5459,7 +5457,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * mailbox command to the HBA later when callback is invoked.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the corresponding
  * response ELS IOCB command.
  *
@@ -5516,7 +5514,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 				oldcmd->unsli3.rcvsli3.ox_id;
 		}
 
-		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+		pcmd = elsiocb->cmd_dmabuf->virt;
 		*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 		pcmd += sizeof(uint32_t);
 
@@ -5551,7 +5549,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 				oldcmd->unsli3.rcvsli3.ox_id;
 		}
 
-		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+		pcmd = (u8 *)elsiocb->cmd_dmabuf->virt;
 
 		if (mbox)
 			elsiocb->context_un.mbox = mbox;
@@ -5629,9 +5627,9 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 				oldcmd->unsli3.rcvsli3.ox_id;
 		}
 
-		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+		pcmd = (u8 *) elsiocb->cmd_dmabuf->virt;
 
-		memcpy(pcmd, ((struct lpfc_dmabuf *) oldiocb->context2)->virt,
+		memcpy(pcmd, oldiocb->cmd_dmabuf->virt,
 		       sizeof(uint32_t) + sizeof(PRLO));
 		*((uint32_t *) (pcmd)) = ELS_CMD_PRLO_ACC;
 		els_pkt_ptr = (ELS_PKT *) pcmd;
@@ -5667,7 +5665,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 				oldcmd->unsli3.rcvsli3.ox_id;
 		}
 
-		pcmd = (((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+		pcmd = (u8 *)elsiocb->cmd_dmabuf->virt;
 		rdf_resp = (struct fc_els_rdf_resp *)pcmd;
 		memset(rdf_resp, 0, sizeof(*rdf_resp));
 		rdf_resp->acc_hdr.la_cmd = ELS_LS_ACC;
@@ -5695,8 +5693,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	}
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -5733,7 +5731,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
  * to issue to the HBA later.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the reject response
  * ELS IOCB command.
  *
@@ -5774,7 +5772,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
 	}
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_LS_RJT;
 	pcmd += sizeof(uint32_t);
@@ -5797,8 +5795,8 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -5870,8 +5868,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		icmd->unsli3.rcvsli3.ox_id = cmd->unsli3.rcvsli3.ox_id;
 	}
 
-	pcmd = (((struct lpfc_dmabuf *)elsiocb->context2)->virt);
-
+	pcmd = elsiocb->cmd_dmabuf->virt;
 	memset(pcmd, 0, cmdsize);
 
 	edc_rsp = (struct lpfc_els_edc_rsp *)pcmd;
@@ -5891,8 +5888,8 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -5927,7 +5924,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * and invokes the lpfc_sli_issue_iocb() routine to send out the command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the ADISC Accept response
  * ELS IOCB command.
  *
@@ -5980,7 +5977,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 			 elsiocb->iotag, ulp_context,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t);
@@ -5997,8 +5994,8 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -6024,7 +6021,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
  * and invokes the lpfc_sli_issue_iocb() routine to send out the command.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the PRLI Accept response
  * ELS IOCB command.
  *
@@ -6054,7 +6051,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	/* Need the incoming PRLI payload to determine if the ACC is for an
 	 * FC4 or NVME PRLI type.  The PRLI type is at word 1.
 	 */
-	req_buf = (struct lpfc_dmabuf *)oldiocb->context2;
+	req_buf = oldiocb->cmd_dmabuf;
 	req_payload = (((uint32_t *)req_buf->virt) + 1);
 
 	/* PRLI type payload is at byte 3 for FCP or NVME. */
@@ -6102,7 +6099,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 			 elsiocb->iotag, ulp_context,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	memset(pcmd, 0, cmdsize);
 
 	*((uint32_t *)(pcmd)) = elsrspcmd;
@@ -6175,8 +6172,8 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
-	elsiocb->context1 =  lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp =  lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -6204,7 +6201,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
  * issue the response.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function.
  *
  * Return code
@@ -6255,7 +6252,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0132 Xmit RNID ACC response tag x%x xri x%x\n",
 			 elsiocb->iotag, ulp_context);
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t);
 
@@ -6289,8 +6286,8 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -6325,7 +6322,7 @@ lpfc_els_clear_rrq(struct lpfc_vport *vport,
 	struct lpfc_node_rrq *prrq;
 
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) iocb->context2)->virt);
+	pcmd = (uint8_t *)iocb->cmd_dmabuf->virt;
 	pcmd += sizeof(uint32_t);
 	rrq = (struct RRQ *)pcmd;
 	rrq->rrq_exchg = be32_to_cpu(rrq->rrq_exchg);
@@ -6412,7 +6409,7 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2876 Xmit ECHO ACC response tag x%x xri x%x\n",
 			 elsiocb->iotag, ulp_context);
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t);
 	memcpy(pcmd, data, cmdsize - sizeof(uint32_t));
@@ -6423,8 +6420,8 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
-	elsiocb->context1 =  lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp =  lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -7048,9 +7045,8 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 			elsiocb->iotag, ulp_context,
 			ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			ndlp->nlp_rpi);
-	rdp_res = (struct fc_rdp_res_frame *)
-		(((struct lpfc_dmabuf *) elsiocb->context2)->virt);
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	rdp_res = (struct fc_rdp_res_frame *)elsiocb->cmd_dmabuf->virt;
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	memset(pcmd, 0, sizeof(struct fc_rdp_res_frame));
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 
@@ -7101,15 +7097,14 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 
 	/* Now that we know the true size of the payload, update the BPL */
-	bpl = (struct ulp_bde64 *)
-		(((struct lpfc_dmabuf *)(elsiocb->context3))->virt);
+	bpl = (struct ulp_bde64 *)elsiocb->bpl_dmabuf->virt;
 	bpl->tus.f.bdeSize = len;
 	bpl->tus.f.bdeFlags = 0;
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto free_rdp_context;
 	}
@@ -7143,7 +7138,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 		icmd->unsli3.rcvsli3.ox_id = rdp_context->ox_id;
 	}
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_LS_RJT;
 	stat = (struct ls_rjt *)(pcmd + sizeof(uint32_t));
@@ -7151,8 +7146,8 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto free_rdp_context;
 	}
@@ -7248,7 +7243,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		goto error;
 	}
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	rdp_req = (struct fc_rdp_req_frame *) pcmd->virt;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -7360,8 +7355,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (!elsiocb)
 		goto free_lcb_context;
 
-	lcb_res = (struct fc_lcb_res_frame *)
-		(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	lcb_res = (struct fc_lcb_res_frame *)elsiocb->cmd_dmabuf->virt;
 
 	memset(lcb_res, 0, sizeof(struct fc_lcb_res_frame));
 
@@ -7376,7 +7370,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		icmd->unsli3.rcvsli3.ox_id = lcb_context->ox_id;
 	}
 
-	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *)(pcmd)) = ELS_CMD_ACC;
 	lcb_res->lcb_sub_command = lcb_context->sub_command;
 	lcb_res->lcb_type = lcb_context->type;
@@ -7386,8 +7380,8 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto out;
 	}
@@ -7421,7 +7415,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		icmd->unsli3.rcvsli3.ox_id = lcb_context->ox_id;
 	}
 
-	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	*((uint32_t *)(pcmd)) = ELS_CMD_LS_RJT;
 	stat = (struct ls_rjt *)(pcmd + sizeof(uint32_t));
@@ -7432,8 +7426,8 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitLSRJT++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto free_lcb_context;
 	}
@@ -7545,7 +7539,7 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	u8 state, rjt_err = 0;
 	struct ls_rjt stat;
 
-	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint8_t *)pcmd->virt;
 	beacon = (struct fc_lcb_request_frame *)pcmd->virt;
 
@@ -7791,7 +7785,7 @@ lpfc_send_rscn_event(struct lpfc_vport *vport,
 	uint32_t payload_len;
 	struct lpfc_rscn_event_header *rscn_event_data;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	payload_ptr = (uint32_t *) pcmd->virt;
 	payload_len = be32_to_cpu(*payload_ptr & ~ELS_CMD_MASK);
 
@@ -7851,7 +7845,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	int rscn_id = 0, hba_id = 0;
 	int i, tmo;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
 
 	payload_len = be32_to_cpu(*lp++ & ~ELS_CMD_MASK);
@@ -7953,7 +7947,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	/* Get the array count after successfully have the token */
 	rscn_cnt = vport->fc_rscn_id_cnt;
 	/* If we are already processing an RSCN, save the received
-	 * RSCN payload buffer, cmdiocb->context2 to process later.
+	 * RSCN payload buffer, cmdiocb->cmd_dmabuf to process later.
 	 */
 	if (vport->fc_flag & (FC_RSCN_MODE | FC_NDISC_ACTIVE)) {
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -7987,10 +7981,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			} else {
 				vport->fc_rscn_id_list[rscn_cnt] = pcmd;
 				vport->fc_rscn_id_cnt++;
-				/* If we zero, cmdiocb->context2, the calling
+				/* If we zero, cmdiocb->cmd_dmabuf, the calling
 				 * routine will not try to free it.
 				 */
-				cmdiocb->context2 = NULL;
+				cmdiocb->cmd_dmabuf = NULL;
 			}
 			/* Deferred RSCN */
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
@@ -8028,10 +8022,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	/* Indicate we are done walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 0;
 	/*
-	 * If we zero, cmdiocb->context2, the calling routine will
+	 * If we zero, cmdiocb->cmd_dmabuf, the calling routine will
 	 * not try to free it.
 	 */
-	cmdiocb->context2 = NULL;
+	cmdiocb->cmd_dmabuf = NULL;
 	lpfc_set_disctmo(vport);
 	/* Send back ACC */
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
@@ -8155,7 +8149,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf;
 	uint32_t *lp = (uint32_t *) pcmd->virt;
 	union lpfc_wqe128 *wqe = &cmdiocb->wqe;
 	struct serv_parm *sp;
@@ -8322,7 +8316,7 @@ lpfc_els_rcv_rnid(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	RNID *rn;
 	struct ls_rjt stat;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
 
 	lp++;
@@ -8363,7 +8357,7 @@ lpfc_els_rcv_echo(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	uint8_t *pcmd;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
+	pcmd = (uint8_t *)cmdiocb->cmd_dmabuf->virt;
 
 	/* skip over first word of echo command to find echo data */
 	pcmd += sizeof(uint32_t);
@@ -8439,7 +8433,7 @@ lpfc_els_rcv_rrq(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * response to the RLS.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the RLS Accept Response
  * ELS IOCB command.
  *
@@ -8462,7 +8456,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	mb = &pmb->u.mb;
 
-	ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	ndlp = pmb->ctx_ndlp;
 	rxid = (uint16_t)((unsigned long)(pmb->ctx_buf) & 0xffff);
 	oxid = (uint16_t)(((unsigned long)(pmb->ctx_buf) >> 16) & 0xffff);
 	pmb->ctx_buf = NULL;
@@ -8498,7 +8492,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		icmd->unsli3.rcvsli3.ox_id = oxid;
 	}
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t); /* Skip past command */
 	rls_rsp = (struct RLS_RSP *)pcmd;
@@ -8519,8 +8513,8 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 ndlp->nlp_rpi);
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return;
 	}
@@ -8611,7 +8605,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * Value (RTV) unsolicited IOCB event.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the RTV Accept Response
  * ELS IOCB command.
  *
@@ -8646,7 +8640,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t); /* Skip past command */
 
@@ -8684,8 +8678,8 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			rtv_rsp->ratov, rtv_rsp->edtov, rtv_rsp->qtov);
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 0;
 	}
@@ -8741,7 +8735,7 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	/* For RRQ request, remainder of payload is Exchange IDs */
 	*((uint32_t *) (pcmd)) = ELS_CMD_RRQ;
@@ -8761,8 +8755,11 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	elsiocb->context_un.rrq = rrq;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rrq;
 
-	lpfc_nlp_get(ndlp);
-	elsiocb->context1 = ndlp;
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (ret == IOCB_ERROR)
@@ -8813,7 +8810,7 @@ lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
  * It is to be called by the lpfc_els_rcv_rpl() routine to accept the RPL.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the RPL Accept Response
  * ELS command.
  *
@@ -8854,7 +8851,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 		icmd->unsli3.rcvsli3.ox_id = get_job_rcvoxid(phba, oldiocb);
 	}
 
-	pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint16_t);
 	*((uint16_t *)(pcmd)) = be16_to_cpu(cmdsize);
@@ -8878,8 +8875,8 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 			 ndlp->nlp_rpi);
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -8934,7 +8931,7 @@ lpfc_els_rcv_rpl(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		return 0;
 	}
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
 	rpl = (RPL *) (lp + 1);
 	maxsize = be32_to_cpu(rpl->maxsize);
@@ -8986,7 +8983,7 @@ lpfc_els_rcv_farp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t cnt, did;
 
 	did = get_job_els_rsp64_did(vport->phba, cmdiocb);
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
 
 	lp++;
@@ -9056,8 +9053,8 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t did;
 
 	did = get_job_els_rsp64_did(vport->phba, cmdiocb);
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
-	lp = (uint32_t *) pcmd->virt;
+	pcmd = cmdiocb->cmd_dmabuf;
+	lp = (uint32_t *)pcmd->virt;
 
 	lp++;
 	/* FARP-RSP received from DID <did> */
@@ -9097,7 +9094,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	FAN *fp;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS, "0265 FAN received\n");
-	lp = (uint32_t *)((struct lpfc_dmabuf *)cmdiocb->context2)->virt;
+	lp = (uint32_t *)cmdiocb->cmd_dmabuf->virt;
 	fp = (FAN *) ++lp;
 	/* FAN received; Fan does not have a reply sequence */
 	if ((vport == phba->pport) &&
@@ -9146,7 +9143,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	int desc_cnt = 0, bytes_remain;
 	bool rcv_cap_desc = false;
 
-	payload = ((struct lpfc_dmabuf *)cmdiocb->context2)->virt;
+	payload = cmdiocb->cmd_dmabuf->virt;
 
 	edc_req = (struct fc_els_edc *)payload;
 	bytes_remain = be32_to_cpu(edc_req->desc_len);
@@ -9331,7 +9328,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 		if (piocb->vport != vport)
 			continue;
 
-		pcmd = (struct lpfc_dmabuf *) piocb->context2;
+		pcmd = piocb->cmd_dmabuf;
 		if (pcmd)
 			els_command = *(uint32_t *) (pcmd->virt);
 
@@ -9586,7 +9583,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 	uint32_t *pcmd;
 	u32 ulp_status, ulp_word4;
 
-	ndlp = cmdiocbp->context1;
+	ndlp = cmdiocbp->ndlp;
 	if (!ndlp)
 		return;
 
@@ -9600,8 +9597,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 			sizeof(struct lpfc_name));
 		memcpy(lsrjt_event.header.wwnn, &ndlp->nlp_nodename,
 			sizeof(struct lpfc_name));
-		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
-			cmdiocbp->context2)->virt);
+		pcmd = (uint32_t *)cmdiocbp->cmd_dmabuf->virt;
 		lsrjt_event.command = (pcmd != NULL) ? *pcmd : 0;
 		stat.un.ls_rjt_error_be = cpu_to_be32(ulp_word4);
 		lsrjt_event.reason_code = stat.un.b.lsRjtRsnCode;
@@ -10135,12 +10131,12 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_wcqe_complete *wcqe_cmpl = NULL;
 	LPFC_MBOXQ_t *mbox;
 
-	if (!vport || !(elsiocb->context2))
+	if (!vport || !elsiocb->cmd_dmabuf)
 		goto dropit;
 
 	newnode = 0;
 	wcqe_cmpl = &elsiocb->wcqe_cmpl;
-	payload = ((struct lpfc_dmabuf *)elsiocb->context2)->virt;
+	payload = elsiocb->cmd_dmabuf->virt;
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		payload_len = wcqe_cmpl->total_data_placed;
 	else
@@ -10201,8 +10197,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	}
 	spin_unlock_irq(&ndlp->lock);
 
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp)
 		goto dropit;
 	elsiocb->vport = vport;
 
@@ -10558,8 +10554,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	}
 
 	/* Release the reference on this elsiocb, not the ndlp. */
-	lpfc_nlp_put(elsiocb->context1);
-	elsiocb->context1 = NULL;
+	lpfc_nlp_put(elsiocb->ndlp);
+	elsiocb->ndlp = NULL;
 
 	/* Special case.  Driver received an unsolicited command that
 	 * unsupportable given the driver's current state.  Reset the
@@ -10613,13 +10609,13 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	u32 ulp_command, status, parameter, bde_count = 0;
 	IOCB_t *icmd;
 	struct lpfc_wcqe_complete *wcqe_cmpl = NULL;
-	struct lpfc_dmabuf *bdeBuf1 = elsiocb->context2;
-	struct lpfc_dmabuf *bdeBuf2 = elsiocb->context3;
+	struct lpfc_dmabuf *bdeBuf1 = elsiocb->cmd_dmabuf;
+	struct lpfc_dmabuf *bdeBuf2 = elsiocb->bpl_dmabuf;
 	dma_addr_t paddr;
 
-	elsiocb->context1 = NULL;
-	elsiocb->context2 = NULL;
-	elsiocb->context3 = NULL;
+	elsiocb->cmd_dmabuf = NULL;
+	elsiocb->rsp_dmabuf = NULL;
+	elsiocb->bpl_dmabuf = NULL;
 
 	wcqe_cmpl = &elsiocb->wcqe_cmpl;
 	ulp_command = get_job_cmnd(phba, elsiocb);
@@ -10663,38 +10659,39 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* Account for SLI2 or SLI3 and later unsolicited buffering */
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
-		elsiocb->context2 = bdeBuf1;
+		elsiocb->cmd_dmabuf = bdeBuf1;
 		if (bde_count == 2)
-			elsiocb->context3 = bdeBuf2;
+			elsiocb->bpl_dmabuf = bdeBuf2;
 	} else {
 		icmd = &elsiocb->iocb;
 		paddr = getPaddr(icmd->un.cont64[0].addrHigh,
 				 icmd->un.cont64[0].addrLow);
-		elsiocb->context2 = lpfc_sli_ringpostbuf_get(phba, pring,
-							     paddr);
+		elsiocb->cmd_dmabuf = lpfc_sli_ringpostbuf_get(phba, pring,
+							       paddr);
 		if (bde_count == 2) {
 			paddr = getPaddr(icmd->un.cont64[1].addrHigh,
 					 icmd->un.cont64[1].addrLow);
-			elsiocb->context3 = lpfc_sli_ringpostbuf_get(phba,
-								       pring,
-								       paddr);
+			elsiocb->bpl_dmabuf = lpfc_sli_ringpostbuf_get(phba,
+									pring,
+									paddr);
 		}
 	}
 
 	lpfc_els_unsol_buffer(phba, pring, vport, elsiocb);
 	/*
 	 * The different unsolicited event handlers would tell us
-	 * if they are done with "mp" by setting context2 to NULL.
+	 * if they are done with "mp" by setting cmd_dmabuf to NULL.
 	 */
-	if (elsiocb->context2) {
-		lpfc_in_buf_free(phba, (struct lpfc_dmabuf *)elsiocb->context2);
-		elsiocb->context2 = NULL;
+	if (elsiocb->cmd_dmabuf) {
+		lpfc_in_buf_free(phba, elsiocb->cmd_dmabuf);
+		elsiocb->cmd_dmabuf = NULL;
 	}
 
-	if (elsiocb->context3) {
-		lpfc_in_buf_free(phba, elsiocb->context3);
-		elsiocb->context3 = NULL;
+	if (elsiocb->bpl_dmabuf) {
+		lpfc_in_buf_free(phba, elsiocb->bpl_dmabuf);
+		elsiocb->bpl_dmabuf = NULL;
 	}
+
 }
 
 static void
@@ -10805,7 +10802,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 	MAILBOX_t *mb = &pmb->u.mb;
 	int rc;
 
@@ -11070,11 +11067,11 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_nodelist *np;
 	struct lpfc_nodelist *next_np;
 	struct lpfc_iocbq *piocb;
-	struct lpfc_dmabuf *pcmd = cmdiocb->context2, *prsp;
+	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf, *prsp;
 	struct serv_parm *sp;
 	uint8_t fabric_param_changed;
 	u32 ulp_status, ulp_word4;
@@ -11212,7 +11209,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * IOCB will be sent off HBA at any given time.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the FDISC ELS command.
  *
  * Return code
@@ -11257,7 +11254,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		icmd->ulpCt_l = 0;
 	}
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_FDISC;
 	pcmd += sizeof(uint32_t); /* CSP Word 1 */
 	memcpy(pcmd, &vport->phba->pport->fc_sparam, sizeof(struct serv_parm));
@@ -11289,8 +11286,8 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"Issue FDISC:     did:x%x",
 		did, 0, 0);
 
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp)
 		goto err_out;
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
@@ -11334,7 +11331,7 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	u32 ulp_status, ulp_word4, did, tmo;
 
-	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	ndlp = cmdiocb->ndlp;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -11392,7 +11389,7 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * This routine issues a LOGO ELS command to an @ndlp off a @vport.
  *
  * Note that the ndlp reference count will be incremented by 1 for holding the
- * ndlp and the reference to ndlp will be stored into the context1 field of
+ * ndlp and the reference to ndlp will be stored into the ndlp field of
  * the IOCB for the completion callback function to the LOGO ELS command.
  *
  * Return codes
@@ -11414,7 +11411,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (!elsiocb)
 		return 1;
 
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 	*((uint32_t *) (pcmd)) = ELS_CMD_LOGO;
 	pcmd += sizeof(uint32_t);
 
@@ -11431,8 +11428,8 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	spin_unlock_irq(&ndlp->lock);
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		goto err;
 	}
@@ -11991,12 +11988,12 @@ lpfc_cmpl_els_qfpa(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_dmabuf *prsp = NULL;
 	struct lpfc_vmid_priority_range *vmid_range = NULL;
 	u32 *data;
-	struct lpfc_dmabuf *dmabuf = cmdiocb->context2;
+	struct lpfc_dmabuf *dmabuf = cmdiocb->cmd_dmabuf;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	u8 *pcmd, max_desc;
 	u32 len, i;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 
 	prsp = list_get_first(&dmabuf->list, struct lpfc_dmabuf, list);
 	if (!prsp)
@@ -12092,15 +12089,15 @@ int lpfc_issue_els_qfpa(struct lpfc_vport *vport)
 	if (!elsiocb)
 		return -ENOMEM;
 
-	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	pcmd = (u8 *)elsiocb->cmd_dmabuf->virt;
 
 	*((u32 *)(pcmd)) = ELS_CMD_QFPA;
 	pcmd += 4;
 
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_qfpa;
 
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(vport->phba, elsiocb);
 		return -ENXIO;
 	}
@@ -12147,7 +12144,7 @@ lpfc_vmid_uvem(struct lpfc_vport *vport,
 	vmid_context->nlp = ndlp;
 	vmid_context->instantiated = instantiated;
 	elsiocb->vmid_tag.vmid_context = vmid_context;
-	pcmd = (u8 *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	pcmd = (u8 *)elsiocb->cmd_dmabuf->virt;
 
 	if (uuid_is_null((uuid_t *)vport->lpfc_vmid_host_uuid))
 		memcpy(vport->lpfc_vmid_host_uuid, vmid->host_vmid,
@@ -12182,8 +12179,8 @@ lpfc_vmid_uvem(struct lpfc_vport *vport,
 
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_uvem;
 
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
+	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(vport->phba, elsiocb);
 		goto out;
 	}
@@ -12209,12 +12206,12 @@ lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struct lpfc_iocbq *icmdiocb,
 	struct lpfc_dmabuf *prsp = NULL;
 	struct lpfc_vmid_context *vmid_context =
 	    icmdiocb->vmid_tag.vmid_context;
-	struct lpfc_nodelist *ndlp = icmdiocb->context1;
+	struct lpfc_nodelist *ndlp = icmdiocb->ndlp;
 	u8 *pcmd;
 	u32 *data;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
-	struct lpfc_dmabuf *dmabuf = icmdiocb->context2;
+	struct lpfc_dmabuf *dmabuf = icmdiocb->cmd_dmabuf;
 	struct lpfc_vmid *vmid;
 
 	vmid = vmid_context->vmp;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d6ff864b132b..46a01801186b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5156,7 +5156,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 	if (pring->ringno == LPFC_ELS_RING) {
 		switch (ulp_command) {
 		case CMD_GEN_REQUEST64_CR:
-			if (iocb->context_un.ndlp == ndlp)
+			if (iocb->ndlp == ndlp)
 				return 1;
 			fallthrough;
 		case CMD_ELS_REQUEST64_CR:
@@ -5164,7 +5164,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 				return 1;
 			fallthrough;
 		case CMD_XMIT_ELS_RSP64_CX:
-			if (iocb->context1 == (uint8_t *) ndlp)
+			if (iocb->ndlp == ndlp)
 				return 1;
 		}
 	} else if (pring->ringno == LPFC_FCP_RING) {
@@ -6099,7 +6099,7 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	 */
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-		if (iocb->context1 != ndlp)
+		if (iocb->ndlp != ndlp)
 			continue;
 
 		ulp_command = get_job_cmnd(phba, iocb);
@@ -6113,7 +6113,7 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 
 	/* Next check the txcmplq */
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-		if (iocb->context1 != ndlp)
+		if (iocb->ndlp != ndlp)
 			continue;
 
 		ulp_command = get_job_cmnd(phba, iocb);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 578e9947125b..9efe26b5b77a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4323,9 +4323,10 @@ lpfc_sli4_io_sgl_update(struct lpfc_hba *phba)
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"6074 Current allocated XRI sgl count:%d, "
-			"maximum XRI count:%d\n",
+			"maximum XRI count:%d els_xri_cnt:%d\n\n",
 			phba->sli4_hba.io_xri_cnt,
-			phba->sli4_hba.io_xri_max);
+			phba->sli4_hba.io_xri_max,
+			els_xri_cnt);
 
 	cnt = lpfc_io_buf_flush(phba, &io_sgl_list);
 
@@ -4464,12 +4465,11 @@ lpfc_new_io_buf(struct lpfc_hba *phba, int num_to_alloc)
 		}
 		pwqeq->sli4_lxritag = lxri;
 		pwqeq->sli4_xritag = phba->sli4_hba.xri_ids[lxri];
-		pwqeq->context1 = lpfc_ncmd;
 
 		/* Initialize local short-hand pointers. */
 		lpfc_ncmd->dma_sgl = lpfc_ncmd->data;
 		lpfc_ncmd->dma_phys_sgl = lpfc_ncmd->dma_handle;
-		lpfc_ncmd->cur_iocbq.context1 = lpfc_ncmd;
+		lpfc_ncmd->cur_iocbq.io_buf = lpfc_ncmd;
 		spin_lock_init(&lpfc_ncmd->buf_lock);
 
 		/* add the nvme buffer to a post list */
@@ -4478,7 +4478,9 @@ lpfc_new_io_buf(struct lpfc_hba *phba, int num_to_alloc)
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
 			"6114 Allocate %d out of %d requested new NVME "
-			"buffers\n", bcnt, num_to_alloc);
+			"buffers of size x%lx bytes\n", bcnt, num_to_alloc,
+			sizeof(*lpfc_ncmd));
+
 
 	/* post the list of nvme buffer sgls to port if available */
 	if (!list_empty(&post_nblist))
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e7b1174a057f..fbfa3252be7a 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -173,9 +173,9 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	void     *ptr = NULL;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 
-	/* For lpfc_els_abort, context2 could be zero'ed to delay
+	/* For lpfc_els_abort, cmd_dmabuf could be zero'ed to delay
 	 * freeing associated memory till after ABTS completes.
 	 */
 	if (pcmd) {
@@ -343,7 +343,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 remote_did;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
 	if (wwn_to_u64(sp->portName.u.wwn) == 0) {
@@ -716,7 +716,7 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t *lp;
 	uint32_t cmd;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
 
 	cmd = *lp++;
@@ -924,7 +924,7 @@ lpfc_rcv_prli_support_check(struct lpfc_vport *vport,
 	uint32_t *payload;
 	uint32_t cmd;
 
-	payload = ((struct lpfc_dmabuf *)cmdiocb->context2)->virt;
+	payload = cmdiocb->cmd_dmabuf->virt;
 	cmd = *payload;
 	if (vport->phba->nvmet_support) {
 		/* Must be a NVME PRLI */
@@ -961,9 +961,9 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct fc_rport *rport = ndlp->rport;
 	u32 roles;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
-	lp = (uint32_t *) pcmd->virt;
-	npr = (PRLI *) ((uint8_t *) lp + sizeof (uint32_t));
+	pcmd = cmdiocb->cmd_dmabuf;
+	lp = (uint32_t *)pcmd->virt;
+	npr = (PRLI *)((uint8_t *)lp + sizeof(uint32_t));
 
 	if ((npr->prliType == PRLI_FCP_TYPE) ||
 	    (npr->prliType == PRLI_NVME_TYPE)) {
@@ -1224,7 +1224,7 @@ lpfc_rcv_plogi_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb = arg;
-	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf;
 	uint32_t *lp = (uint32_t *) pcmd->virt;
 	struct serv_parm *sp = (struct serv_parm *) (lp + 1);
 	struct ls_rjt stat;
@@ -1345,7 +1345,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	u32 did;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	rspiocb = cmdiocb->context_un.rsp_iocb;
+	rspiocb = cmdiocb->rsp_iocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 
@@ -1357,7 +1357,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	if (ulp_status)
 		goto out;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	pcmd = cmdiocb->cmd_dmabuf;
 
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
 	if (!prsp)
@@ -1703,7 +1703,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	rspiocb = cmdiocb->context_un.rsp_iocb;
+	rspiocb = cmdiocb->rsp_iocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 
@@ -2157,7 +2157,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	rspiocb = cmdiocb->context_un.rsp_iocb;
+	rspiocb = cmdiocb->rsp_iocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 
@@ -2777,7 +2777,7 @@ lpfc_cmpl_plogi_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	rspiocb = cmdiocb->context_un.rsp_iocb;
+	rspiocb = cmdiocb->rsp_iocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 
@@ -2796,7 +2796,7 @@ lpfc_cmpl_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	rspiocb = cmdiocb->context_un.rsp_iocb;
+	rspiocb = cmdiocb->rsp_iocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 
@@ -2832,7 +2832,7 @@ lpfc_cmpl_adisc_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	rspiocb = cmdiocb->context_un.rsp_iocb;
+	rspiocb = cmdiocb->rsp_iocb;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 699b79d4f496..376f6c0265c0 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -319,8 +319,10 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 	struct lpfc_nodelist *ndlp;
 	uint32_t status;
 
-	pnvme_lsreq = (struct nvmefc_ls_req *)cmdwqe->context2;
-	ndlp = (struct lpfc_nodelist *)cmdwqe->context1;
+	pnvme_lsreq = cmdwqe->context_un.nvme_lsreq;
+	ndlp = cmdwqe->ndlp;
+	buf_ptr = cmdwqe->bpl_dmabuf;
+
 	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
@@ -330,16 +332,16 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 			 pnvme_lsreq, ndlp ? ndlp->nlp_DID : 0,
 			 cmdwqe->sli4_xritag, status,
 			 (wcqe->parameter & 0xffff),
-			 cmdwqe, pnvme_lsreq, cmdwqe->context3, ndlp);
+			 cmdwqe, pnvme_lsreq, cmdwqe->bpl_dmabuf,
+			 ndlp);
 
 	lpfc_nvmeio_data(phba, "NVMEx LS CMPL: xri x%x stat x%x parm x%x\n",
 			 cmdwqe->sli4_xritag, status, wcqe->parameter);
 
-	if (cmdwqe->context3) {
-		buf_ptr = (struct lpfc_dmabuf *)cmdwqe->context3;
+	if (buf_ptr) {
 		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
 		kfree(buf_ptr);
-		cmdwqe->context3 = NULL;
+		cmdwqe->bpl_dmabuf = NULL;
 	}
 	if (pnvme_lsreq->done)
 		pnvme_lsreq->done(pnvme_lsreq, status);
@@ -351,7 +353,7 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 				cmdwqe->sli4_xritag, status);
 	if (ndlp) {
 		lpfc_nlp_put(ndlp);
-		cmdwqe->context1 = NULL;
+		cmdwqe->ndlp = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, cmdwqe);
 }
@@ -407,19 +409,19 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	/* Initialize only 64 bytes */
 	memset(wqe, 0, sizeof(union lpfc_wqe));
 
-	genwqe->context3 = (uint8_t *)bmp;
+	genwqe->bpl_dmabuf = bmp;
 	genwqe->cmd_flag |= LPFC_IO_NVME_LS;
 
 	/* Save for completion so we can release these resources */
-	genwqe->context1 = lpfc_nlp_get(ndlp);
-	if (!genwqe->context1) {
+	genwqe->ndlp = lpfc_nlp_get(ndlp);
+	if (!genwqe->ndlp) {
 		dev_warn(&phba->pcidev->dev,
 			 "Warning: Failed node ref, not sending LS_REQ\n");
 		lpfc_sli_release_iocbq(phba, genwqe);
 		return 1;
 	}
 
-	genwqe->context2 = (uint8_t *)pnvme_lsreq;
+	genwqe->context_un.nvme_lsreq = pnvme_lsreq;
 	/* Fill in payload, bp points to frame payload */
 
 	if (!tmo)
@@ -730,7 +732,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	spin_lock_irq(&phba->hbalock);
 	spin_lock(&pring->ring_lock);
 	list_for_each_entry_safe(wqe, next_wqe, &pring->txcmplq, list) {
-		if (wqe->context2 == pnvme_lsreq) {
+		if (wqe->context_un.nvme_lsreq == pnvme_lsreq) {
 			wqe->cmd_flag |= LPFC_DRIVER_ABORTED;
 			foundit = true;
 			break;
@@ -929,8 +931,7 @@ static void
 lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		      struct lpfc_iocbq *pwqeOut)
 {
-	struct lpfc_io_buf *lpfc_ncmd =
-		(struct lpfc_io_buf *)pwqeIn->context1;
+	struct lpfc_io_buf *lpfc_ncmd = pwqeIn->io_buf;
 	struct lpfc_wcqe_complete *wcqe = &pwqeOut->wcqe_cmpl;
 	struct lpfc_vport *vport = pwqeIn->vport;
 	struct nvmefc_fcp_req *nCmd;
@@ -2717,7 +2718,7 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	struct lpfc_wcqe_complete wcqe;
 	struct lpfc_wcqe_complete *wcqep = &wcqe;
 
-	lpfc_ncmd = (struct lpfc_io_buf *)pwqeIn->context1;
+	lpfc_ncmd = pwqeIn->io_buf;
 	if (!lpfc_ncmd) {
 		lpfc_sli_release_iocbq(phba, pwqeIn);
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 95438265fb16..c0ee0b39075d 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -295,7 +295,7 @@ void
 __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			   struct lpfc_iocbq *rspwqe)
 {
-	struct lpfc_async_xchg_ctx *axchg = cmdwqe->context2;
+	struct lpfc_async_xchg_ctx *axchg = cmdwqe->context_un.axchg;
 	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 	struct nvmefc_ls_rsp *ls_rsp = &axchg->ls_rsp;
 	uint32_t status, result;
@@ -317,9 +317,9 @@ __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			"6038 NVMEx LS rsp cmpl: %d %d oxid x%x\n",
 			status, result, axchg->oxid);
 
-	lpfc_nlp_put(cmdwqe->context1);
-	cmdwqe->context2 = NULL;
-	cmdwqe->context3 = NULL;
+	lpfc_nlp_put(cmdwqe->ndlp);
+	cmdwqe->context_un.axchg = NULL;
+	cmdwqe->bpl_dmabuf = NULL;
 	lpfc_sli_release_iocbq(phba, cmdwqe);
 	ls_rsp->done(ls_rsp);
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
@@ -728,7 +728,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	int id;
 #endif
 
-	ctxp = cmdwqe->context2;
+	ctxp = cmdwqe->context_un.axchg;
 	ctxp->flag &= ~LPFC_NVME_IO_INP;
 
 	rsp = &ctxp->hdlrctx.fcp_req;
@@ -903,7 +903,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	/* Save numBdes for bpl2sgl */
 	nvmewqeq->num_bdes = 1;
 	nvmewqeq->hba_wqidx = 0;
-	nvmewqeq->context3 = &dmabuf;
+	nvmewqeq->bpl_dmabuf = &dmabuf;
 	dmabuf.virt = &bpl;
 	bpl.addrLow = nvmewqeq->wqe.xmit_sequence.bde.addrLow;
 	bpl.addrHigh = nvmewqeq->wqe.xmit_sequence.bde.addrHigh;
@@ -917,7 +917,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	 */
 
 	nvmewqeq->cmd_cmpl = xmt_ls_rsp_cmp;
-	nvmewqeq->context2 = axchg;
+	nvmewqeq->context_un.axchg = axchg;
 
 	lpfc_nvmeio_data(phba, "NVMEx LS RSP: xri x%x wqidx x%x len x%x\n",
 			 axchg->oxid, nvmewqeq->hba_wqidx, ls_rsp->rsplen);
@@ -925,7 +925,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	rc = lpfc_sli4_issue_wqe(phba, axchg->hdwq, nvmewqeq);
 
 	/* clear to be sure there's no reference */
-	nvmewqeq->context3 = NULL;
+	nvmewqeq->bpl_dmabuf = NULL;
 
 	if (rc == WQE_SUCCESS) {
 		/*
@@ -942,7 +942,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 
 	rc = -ENXIO;
 
-	lpfc_nlp_put(nvmewqeq->context1);
+	lpfc_nlp_put(nvmewqeq->ndlp);
 
 out_free_buf:
 	/* Give back resources */
@@ -1075,7 +1075,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	}
 
 	nvmewqeq->cmd_cmpl = lpfc_nvmet_xmt_fcp_op_cmp;
-	nvmewqeq->context2 = ctxp;
+	nvmewqeq->context_un.axchg = ctxp;
 	nvmewqeq->cmd_flag |=  LPFC_IO_NVMET;
 	ctxp->wqeq->hba_wqidx = rsp->hwqid;
 
@@ -1119,8 +1119,8 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 			ctxp->oxid, rc);
 
 	ctxp->wqeq->hba_wqidx = 0;
-	nvmewqeq->context2 = NULL;
-	nvmewqeq->context3 = NULL;
+	nvmewqeq->context_un.axchg = NULL;
+	nvmewqeq->bpl_dmabuf = NULL;
 	rc = -EBUSY;
 aerr:
 	return rc;
@@ -1590,7 +1590,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 		/* Initialize WQE */
 		memset(wqe, 0, sizeof(union lpfc_wqe));
 
-		ctx_buf->iocbq->context1 = NULL;
+		ctx_buf->iocbq->cmd_dmabuf = NULL;
 		spin_lock(&phba->sli4_hba.sgl_list_lock);
 		ctx_buf->sglq = __lpfc_sli_get_nvmet_sglq(phba, ctx_buf->iocbq);
 		spin_unlock(&phba->sli4_hba.sgl_list_lock);
@@ -2025,7 +2025,7 @@ lpfc_nvmet_wqfull_flush(struct lpfc_hba *phba, struct lpfc_queue *wq,
 				 &wq->wqfull_list, list) {
 		if (ctxp) {
 			/* Checking for a specific IO to flush */
-			if (nvmewqeq->context2 == ctxp) {
+			if (nvmewqeq->context_un.axchg == ctxp) {
 				list_del(&nvmewqeq->list);
 				spin_unlock_irqrestore(&pring->ring_lock,
 						       iflags);
@@ -2071,7 +2071,7 @@ lpfc_nvmet_wqfull_process(struct lpfc_hba *phba,
 		list_remove_head(&wq->wqfull_list, nvmewqeq, struct lpfc_iocbq,
 				 list);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
-		ctxp = (struct lpfc_async_xchg_ctx *)nvmewqeq->context2;
+		ctxp = nvmewqeq->context_un.axchg;
 		rc = lpfc_sli4_issue_wqe(phba, ctxp->hdwq, nvmewqeq);
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		if (rc == -EBUSY) {
@@ -2617,10 +2617,10 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	ctxp->wqeq = nvmewqe;
 
 	/* prevent preparing wqe with NULL ndlp reference */
-	nvmewqe->context1 = lpfc_nlp_get(ndlp);
-	if (nvmewqe->context1 == NULL)
+	nvmewqe->ndlp = lpfc_nlp_get(ndlp);
+	if (!nvmewqe->ndlp)
 		goto nvme_wqe_free_wqeq_exit;
-	nvmewqe->context2 = ctxp;
+	nvmewqe->context_un.axchg = ctxp;
 
 	wqe = &nvmewqe->wqe;
 	memset(wqe, 0, sizeof(union lpfc_wqe));
@@ -2692,8 +2692,9 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	return nvmewqe;
 
 nvme_wqe_free_wqeq_exit:
-	nvmewqe->context2 = NULL;
-	nvmewqe->context3 = NULL;
+	nvmewqe->context_un.axchg = NULL;
+	nvmewqe->ndlp = NULL;
+	nvmewqe->bpl_dmabuf = NULL;
 	lpfc_sli_release_iocbq(phba, nvmewqe);
 	return NULL;
 }
@@ -2995,7 +2996,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	nvmewqe->retry = 1;
 	nvmewqe->vport = phba->pport;
 	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
-	nvmewqe->context1 = ndlp;
+	nvmewqe->ndlp = ndlp;
 
 	for_each_sg(rsp->sg, sgel, nsegs, i) {
 		physaddr = sg_dma_address(sgel);
@@ -3053,7 +3054,7 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	bool released = false;
 	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
-	ctxp = cmdwqe->context2;
+	ctxp = cmdwqe->context_un.axchg;
 	result = wcqe->parameter;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
@@ -3084,8 +3085,8 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			wcqe->word0, wcqe->total_data_placed,
 			result, wcqe->word3);
 
-	cmdwqe->context2 = NULL;
-	cmdwqe->context3 = NULL;
+	cmdwqe->rsp_dmabuf = NULL;
+	cmdwqe->bpl_dmabuf = NULL;
 	/*
 	 * if transport has released ctx, then can reuse it. Otherwise,
 	 * will be recycled by transport release call.
@@ -3123,7 +3124,7 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	bool released = false;
 	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
-	ctxp = cmdwqe->context2;
+	ctxp = cmdwqe->context_un.axchg;
 	result = wcqe->parameter;
 
 	if (!ctxp) {
@@ -3169,8 +3170,8 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			wcqe->word0, wcqe->total_data_placed,
 			result, wcqe->word3);
 
-	cmdwqe->context2 = NULL;
-	cmdwqe->context3 = NULL;
+	cmdwqe->rsp_dmabuf = NULL;
+	cmdwqe->bpl_dmabuf = NULL;
 	/*
 	 * if transport has released ctx, then can reuse it. Otherwise,
 	 * will be recycled by transport release call.
@@ -3203,7 +3204,7 @@ lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	uint32_t result;
 	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
-	ctxp = cmdwqe->context2;
+	ctxp = cmdwqe->context_un.axchg;
 	result = wcqe->parameter;
 
 	if (phba->nvmet_support) {
@@ -3234,8 +3235,8 @@ lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
 	}
 
-	cmdwqe->context2 = NULL;
-	cmdwqe->context3 = NULL;
+	cmdwqe->rsp_dmabuf = NULL;
+	cmdwqe->bpl_dmabuf = NULL;
 	lpfc_sli_release_iocbq(phba, cmdwqe);
 	kfree(ctxp);
 }
@@ -3322,9 +3323,9 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	       OTHER_COMMAND);
 
 	abts_wqeq->vport = phba->pport;
-	abts_wqeq->context1 = ndlp;
-	abts_wqeq->context2 = ctxp;
-	abts_wqeq->context3 = NULL;
+	abts_wqeq->ndlp = ndlp;
+	abts_wqeq->context_un.axchg = ctxp;
+	abts_wqeq->bpl_dmabuf = NULL;
 	abts_wqeq->num_bdes = 0;
 	/* hba_wqidx should already be setup from command we are aborting */
 	abts_wqeq->iocb.ulpCommand = CMD_XMIT_SEQUENCE64_CR;
@@ -3477,7 +3478,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
 	abts_wqeq->cmd_cmpl = lpfc_nvmet_sol_fcp_abort_cmp;
 	abts_wqeq->cmd_flag |= LPFC_IO_NVME;
-	abts_wqeq->context2 = ctxp;
+	abts_wqeq->context_un.axchg = ctxp;
 	abts_wqeq->vport = phba->pport;
 	if (!ctxp->hdwq)
 		ctxp->hdwq = &phba->sli4_hba.hdwq[abts_wqeq->hba_wqidx];
@@ -3630,8 +3631,8 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 out:
 	if (tgtp)
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
-	abts_wqeq->context2 = NULL;
-	abts_wqeq->context3 = NULL;
+	abts_wqeq->rsp_dmabuf = NULL;
+	abts_wqeq->bpl_dmabuf = NULL;
 	lpfc_sli_release_iocbq(phba, abts_wqeq);
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"6056 Failed to Issue ABTS. Status x%x\n", rc);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a949fe53651a..1959c58d22f8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -433,7 +433,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		iocb->ulpClass = CLASS3;
 		psb->status = IOSTAT_SUCCESS;
 		/* Put it back into the SCSI buffer list */
-		psb->cur_iocbq.context1  = psb;
+		psb->cur_iocbq.io_buf = psb;
 		spin_lock_init(&psb->buf_lock);
 		lpfc_release_scsi_buf_s3(phba, psb);
 
@@ -4082,8 +4082,7 @@ static void
 lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			 struct lpfc_iocbq *pwqeOut)
 {
-	struct lpfc_io_buf *lpfc_cmd =
-		(struct lpfc_io_buf *)pwqeIn->context1;
+	struct lpfc_io_buf *lpfc_cmd = pwqeIn->io_buf;
 	struct lpfc_wcqe_complete *wcqe = &pwqeOut->wcqe_cmpl;
 	struct lpfc_vport *vport = pwqeIn->vport;
 	struct lpfc_rport_data *rdata;
@@ -4421,7 +4420,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			struct lpfc_iocbq *pIocbOut)
 {
 	struct lpfc_io_buf *lpfc_cmd =
-		(struct lpfc_io_buf *) pIocbIn->context1;
+		(struct lpfc_io_buf *) pIocbIn->io_buf;
 	struct lpfc_vport      *vport = pIocbIn->vport;
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
@@ -4744,7 +4743,7 @@ static int lpfc_scsi_prep_cmnd_buf_s3(struct lpfc_vport *vport,
 		piocbq->iocb.ulpFCP2Rcvy = 0;
 
 	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
-	piocbq->context1  = lpfc_cmd;
+	piocbq->io_buf  = lpfc_cmd;
 	if (!piocbq->cmd_cmpl)
 		piocbq->cmd_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	piocbq->iocb.ulpTimeout = tmo;
@@ -4856,8 +4855,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 	bf_set(wqe_reqtag, &wqe->generic.wqe_com, pwqeq->iotag);
 
 	pwqeq->vport = vport;
-	pwqeq->vport = vport;
-	pwqeq->context1 = lpfc_cmd;
+	pwqeq->io_buf = lpfc_cmd;
 	pwqeq->hba_wqidx = lpfc_cmd->hdwq_no;
 	pwqeq->cmd_cmpl = lpfc_fcp_io_cmd_wqe_cmpl;
 
@@ -5098,8 +5096,7 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
 			struct lpfc_iocbq *cmdiocbq,
 			struct lpfc_iocbq *rspiocbq)
 {
-	struct lpfc_io_buf *lpfc_cmd =
-		(struct lpfc_io_buf *) cmdiocbq->context1;
+	struct lpfc_io_buf *lpfc_cmd = cmdiocbq->io_buf;
 	if (lpfc_cmd)
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 	return;
@@ -5916,7 +5913,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		goto out_unlock_ring;
 	}
 
-	BUG_ON(iocb->context1 != lpfc_cmd);
+	WARN_ON(iocb->io_buf != lpfc_cmd);
 
 	/* abort issued in recovery is still in progress */
 	if (iocb->cmd_flag & LPFC_DRIVER_ABORTED) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3b9359c1ee1c..ae26a004552d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1254,19 +1254,19 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 
 	cmnd = get_job_cmnd(phba, piocbq);
 
-	if (piocbq->cmd_flag &  LPFC_IO_FCP) {
-		lpfc_cmd = (struct lpfc_io_buf *) piocbq->context1;
+	if (piocbq->cmd_flag & LPFC_IO_FCP) {
+		lpfc_cmd = piocbq->io_buf;
 		ndlp = lpfc_cmd->rdata->pnode;
 	} else  if ((cmnd == CMD_GEN_REQUEST64_CR) &&
 			!(piocbq->cmd_flag & LPFC_IO_LIBDFC)) {
-		ndlp = piocbq->context_un.ndlp;
+		ndlp = piocbq->ndlp;
 	} else  if (piocbq->cmd_flag & LPFC_IO_LIBDFC) {
 		if (piocbq->cmd_flag & LPFC_IO_LOOPBACK)
 			ndlp = NULL;
 		else
-			ndlp = piocbq->context_un.ndlp;
+			ndlp = piocbq->ndlp;
 	} else {
-		ndlp = piocbq->context1;
+		ndlp = piocbq->ndlp;
 	}
 
 	spin_lock(&phba->sli4_hba.sgl_list_lock);
@@ -1996,9 +1996,9 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 
 	sync_buf->vport = phba->pport;
 	sync_buf->cmd_cmpl = lpfc_cmf_sync_cmpl;
-	sync_buf->context1 = NULL;
-	sync_buf->context2 = NULL;
-	sync_buf->context3 = NULL;
+	sync_buf->cmd_dmabuf = NULL;
+	sync_buf->rsp_dmabuf = NULL;
+	sync_buf->bpl_dmabuf = NULL;
 	sync_buf->sli4_xritag = NO_XRI;
 
 	sync_buf->cmd_flag |= LPFC_IO_CMF;
@@ -3197,7 +3197,7 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 	uint32_t oxid, sid, did, fctl, size;
 	int ret = 1;
 
-	d_buf = piocb->context2;
+	d_buf = piocb->cmd_dmabuf;
 
 	nvmebuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 	fc_hdr = nvmebuf->hbuf.virt;
@@ -3478,9 +3478,9 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		if (irsp->ulpBdeCount != 0) {
-			saveq->context2 = lpfc_sli_get_buff(phba, pring,
+			saveq->cmd_dmabuf = lpfc_sli_get_buff(phba, pring,
 						irsp->un.ulpWord[3]);
-			if (!saveq->context2)
+			if (!saveq->cmd_dmabuf)
 				lpfc_printf_log(phba,
 					KERN_ERR,
 					LOG_SLI,
@@ -3490,9 +3490,9 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					irsp->un.ulpWord[3]);
 		}
 		if (irsp->ulpBdeCount == 2) {
-			saveq->context3 = lpfc_sli_get_buff(phba, pring,
+			saveq->bpl_dmabuf = lpfc_sli_get_buff(phba, pring,
 						irsp->unsli3.sli3Words[7]);
-			if (!saveq->context3)
+			if (!saveq->bpl_dmabuf)
 				lpfc_printf_log(phba,
 					KERN_ERR,
 					LOG_SLI,
@@ -3504,10 +3504,10 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		list_for_each_entry(iocbq, &saveq->list, list) {
 			irsp = &iocbq->iocb;
 			if (irsp->ulpBdeCount != 0) {
-				iocbq->context2 = lpfc_sli_get_buff(phba,
+				iocbq->cmd_dmabuf = lpfc_sli_get_buff(phba,
 							pring,
 							irsp->un.ulpWord[3]);
-				if (!iocbq->context2)
+				if (!iocbq->cmd_dmabuf)
 					lpfc_printf_log(phba,
 						KERN_ERR,
 						LOG_SLI,
@@ -3517,10 +3517,10 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						irsp->un.ulpWord[3]);
 			}
 			if (irsp->ulpBdeCount == 2) {
-				iocbq->context3 = lpfc_sli_get_buff(phba,
+				iocbq->bpl_dmabuf = lpfc_sli_get_buff(phba,
 						pring,
 						irsp->unsli3.sli3Words[7]);
-				if (!iocbq->context3)
+				if (!iocbq->bpl_dmabuf)
 					lpfc_printf_log(phba,
 						KERN_ERR,
 						LOG_SLI,
@@ -3534,12 +3534,12 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	} else {
 		paddr = getPaddr(irsp->un.cont64[0].addrHigh,
 				 irsp->un.cont64[0].addrLow);
-		saveq->context2 = lpfc_sli_ringpostbuf_get(phba, pring,
+		saveq->cmd_dmabuf = lpfc_sli_ringpostbuf_get(phba, pring,
 							     paddr);
 		if (irsp->ulpBdeCount == 2) {
 			paddr = getPaddr(irsp->un.cont64[1].addrHigh,
 					 irsp->un.cont64[1].addrLow);
-			saveq->context3 = lpfc_sli_ringpostbuf_get(phba,
+			saveq->bpl_dmabuf = lpfc_sli_ringpostbuf_get(phba,
 								   pring,
 								   paddr);
 		}
@@ -10342,8 +10342,7 @@ __lpfc_sli_issue_fcp_io_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			   struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	int rc;
-	struct lpfc_io_buf *lpfc_cmd =
-		(struct lpfc_io_buf *)piocb->context1;
+	struct lpfc_io_buf *lpfc_cmd = piocb->io_buf;
 
 	lpfc_prep_embed_io(phba, lpfc_cmd);
 	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
@@ -10989,7 +10988,7 @@ lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 		 * be setup based on what work queue we used.
 		 */
 		if (!(piocb->cmd_flag & LPFC_USE_FCPWQIDX)) {
-			lpfc_cmd = (struct lpfc_io_buf *)piocb->context1;
+			lpfc_cmd = piocb->io_buf;
 			piocb->hba_wqidx = lpfc_cmd->hdwq_no;
 		}
 		return phba->sli4_hba.hdwq[piocb->hba_wqidx].io_wq->pring;
@@ -12063,7 +12062,7 @@ void
 lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		     struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_nodelist *ndlp = NULL;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	IOCB_t *irsp;
 	LPFC_MBOXQ_t *mbox;
 	struct lpfc_dmabuf *mp;
@@ -12098,20 +12097,17 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"0139 Ignoring ELS cmd code x%x completion Data: "
-			"x%x x%x x%x\n",
-			ulp_command, ulp_status, ulp_word4, iotag);
-
+			"x%x x%x x%x x%px\n",
+			ulp_command, ulp_status, ulp_word4, iotag,
+			cmdiocb->ndlp);
 	/*
 	 * Deref the ndlp after free_iocb. sli_release_iocb will access the ndlp
 	 * if exchange is busy.
 	 */
-	if (ulp_command == CMD_GEN_REQUEST64_CR) {
-		ndlp = cmdiocb->context_un.ndlp;
+	if (ulp_command == CMD_GEN_REQUEST64_CR)
 		lpfc_ct_free_iocb(phba, cmdiocb);
-	} else {
-		ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	else
 		lpfc_els_free_iocb(phba, cmdiocb);
-	}
 
 	lpfc_nlp_put(ndlp);
 }
@@ -12192,7 +12188,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	} else {
 		iotag = cmdiocb->iocb.ulpIoTag;
 		if (pring->ringno == LPFC_ELS_RING) {
-			ndlp = (struct lpfc_nodelist *)(cmdiocb->context1);
+			ndlp = cmdiocb->ndlp;
 			ulp_context = ndlp->nlp_rpi;
 		} else {
 			ulp_context = cmdiocb->iocb.ulpContext;
@@ -12650,7 +12646,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		} else {
 			iotag = iocbq->iocb.ulpIoTag;
 			if (pring->ringno == LPFC_ELS_RING) {
-				ndlp = (struct lpfc_nodelist *)(iocbq->context1);
+				ndlp = iocbq->ndlp;
 				ulp_context = ndlp->nlp_rpi;
 			} else {
 				ulp_context = iocbq->iocb.ulpContext;
@@ -12755,8 +12751,8 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 
 	/* Copy the contents of the local rspiocb into the caller's buffer. */
 	cmdiocbq->cmd_flag |= LPFC_IO_WAKE;
-	if (cmdiocbq->context2 && rspiocbq)
-		memcpy((char *)cmdiocbq->context2 + offset,
+	if (cmdiocbq->rsp_iocb && rspiocbq)
+		memcpy((char *)cmdiocbq->rsp_iocb + offset,
 		       (char *)rspiocbq + offset, sizeof(*rspiocbq) - offset);
 
 	/* Set the exchange busy flag for task management commands */
@@ -12864,13 +12860,13 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	} else
 		pring = &phba->sli.sli3_ring[ring_number];
 	/*
-	 * If the caller has provided a response iocbq buffer, then context2
+	 * If the caller has provided a response iocbq buffer, then rsp_iocb
 	 * is NULL or its an error.
 	 */
 	if (prspiocbq) {
-		if (piocb->context2)
+		if (piocb->rsp_iocb)
 			return IOCB_ERROR;
-		piocb->context2 = prspiocbq;
+		piocb->rsp_iocb = prspiocbq;
 	}
 
 	piocb->wait_cmd_cmpl = piocb->cmd_cmpl;
@@ -12954,7 +12950,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	}
 
 	if (prspiocbq)
-		piocb->context2 = NULL;
+		piocb->rsp_iocb = NULL;
 
 	piocb->context_un.wait_queue = NULL;
 	piocb->cmd_cmpl = NULL;
@@ -18528,11 +18524,8 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc_hba *phba,
 			     struct lpfc_iocbq *cmd_iocbq,
 			     struct lpfc_iocbq *rsp_iocbq)
 {
-	struct lpfc_nodelist *ndlp;
-
 	if (cmd_iocbq) {
-		ndlp = (struct lpfc_nodelist *)cmd_iocbq->context1;
-		lpfc_nlp_put(ndlp);
+		lpfc_nlp_put(cmd_iocbq->ndlp);
 		lpfc_sli_release_iocbq(phba, cmd_iocbq);
 	}
 
@@ -18616,8 +18609,8 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	/* Extract the F_CTL field from FC_HDR */
 	fctl = sli4_fctl_from_fc_hdr(fc_hdr);
 
-	ctiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!ctiocb->context1) {
+	ctiocb->ndlp = lpfc_nlp_get(ndlp);
+	if (!ctiocb->ndlp) {
 		lpfc_sli_release_iocbq(phba, ctiocb);
 		return;
 	}
@@ -18708,7 +18701,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 				 ctiocb->abort_rctl, oxid,
 				 phba->link_state);
 		lpfc_nlp_put(ndlp);
-		ctiocb->context1 = NULL;
+		ctiocb->ndlp = NULL;
 		lpfc_sli_release_iocbq(phba, ctiocb);
 	}
 }
@@ -18860,8 +18853,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		tot_len = bf_get(lpfc_rcqe_length,
 				 &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
 
-		first_iocbq->context2 = &seq_dmabuf->dbuf;
-		first_iocbq->context3 = NULL;
+		first_iocbq->cmd_dmabuf = &seq_dmabuf->dbuf;
+		first_iocbq->bpl_dmabuf = NULL;
 		/* Keep track of the BDE count */
 		first_iocbq->wcqe_cmpl.word3 = 1;
 
@@ -18885,8 +18878,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			lpfc_in_buf_free(vport->phba, d_buf);
 			continue;
 		}
-		if (!iocbq->context3) {
-			iocbq->context3 = d_buf;
+		if (!iocbq->bpl_dmabuf) {
+			iocbq->bpl_dmabuf = d_buf;
 			iocbq->wcqe_cmpl.word3++;
 			/* We need to get the size out of the right CQE */
 			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
@@ -18912,8 +18905,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 			len = bf_get(lpfc_rcqe_length,
 				       &hbq_buf->cq_event.cqe.rcqe_cmpl);
-			iocbq->context2 = d_buf;
-			iocbq->context3 = NULL;
+			iocbq->cmd_dmabuf = d_buf;
+			iocbq->bpl_dmabuf = NULL;
 			iocbq->wcqe_cmpl.word3 = 1;
 
 			if (len > LPFC_DATA_BUF_SIZE)
@@ -18978,7 +18971,7 @@ static void
 lpfc_sli4_mds_loopback_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			    struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_dmabuf *pcmd = cmdiocb->context2;
+	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf;
 
 	if (pcmd && pcmd->virt)
 		dma_pool_free(phba->lpfc_drb_pool, pcmd->virt, pcmd->phys);
@@ -19029,7 +19022,7 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 	/* copyin the payload */
 	memcpy(pcmd->virt, dmabuf->dbuf.virt, frame_len);
 
-	iocbq->context2 = pcmd;
+	iocbq->cmd_dmabuf = pcmd;
 	iocbq->vport = vport;
 	iocbq->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
 	iocbq->cmd_flag |= LPFC_USE_FCPWQIDX;
@@ -20904,8 +20897,8 @@ lpfc_wqe_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeq,
 		 * have not been byteswapped yet so there is no
 		 * need to swap them back.
 		 */
-		if (pwqeq->context3)
-			dmabuf = (struct lpfc_dmabuf *)pwqeq->context3;
+		if (pwqeq->bpl_dmabuf)
+			dmabuf = pwqeq->bpl_dmabuf;
 		else
 			return xritag;
 
@@ -21057,7 +21050,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 		wq = qp->io_wq;
 		pring = wq->pring;
 
-		ctxp = pwqe->context2;
+		ctxp = pwqe->context_un.axchg;
 		sglq = ctxp->ctxbuf->sglq;
 		if (pwqe->sli4_xritag ==  NO_XRI) {
 			pwqe->sli4_lxritag = sglq->sli4_lxritag;
@@ -22252,7 +22245,6 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 	u32 fip, abort_tag;
 	struct lpfc_nodelist *ndlp = NULL;
 	union lpfc_wqe128 *wqe = &job->wqe;
-	struct lpfc_dmabuf *context2;
 	u32 els_id = LPFC_ELS_ID_DEFAULT;
 	u8 command_type = ELS_COMMAND_NON_FIP;
 
@@ -22270,10 +22262,7 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 
 	switch (cmnd) {
 	case CMD_ELS_REQUEST64_WQE:
-		if (job->cmd_flag & LPFC_IO_LIBDFC)
-			ndlp = job->context_un.ndlp;
-		else
-			ndlp = (struct lpfc_nodelist *)job->context1;
+		ndlp = job->ndlp;
 
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
 		if (command_type == ELS_COMMAND_FIP)
@@ -22283,8 +22272,7 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 		if_type = bf_get(lpfc_sli_intf_if_type,
 				 &phba->sli4_hba.sli_intf);
 		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
-			context2 = (struct lpfc_dmabuf *)job->context2;
-			pcmd = (u32 *)context2->virt;
+			pcmd = (u32 *)job->cmd_dmabuf->virt;
 			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
 				     *pcmd == ELS_CMD_SCR ||
 				     *pcmd == ELS_CMD_RDF ||
@@ -22307,7 +22295,7 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 				       phba->vpi_ids[job->vport->vpi]);
-			} else if (pcmd) {
+			} else if (pcmd && ndlp) {
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 				       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
@@ -22325,7 +22313,7 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 		bf_set(wqe_ebde_cnt, &wqe->els_req.wqe_com, 0);
 		break;
 	case CMD_XMIT_ELS_RSP64_WQE:
-		ndlp = (struct lpfc_nodelist *)job->context1;
+		ndlp = job->ndlp;
 
 		/* word4 */
 		wqe->xmit_els_rsp.word4 = 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 663cc90a8798..776eb4ab52d2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -77,11 +77,15 @@ struct lpfc_iocbq {
 
 	u32 unsol_rcv_len;	/* Receive len in usol path */
 
-	uint8_t num_bdes;
-	uint8_t abort_bls;	/* ABTS by initiator or responder */
-	u8 abort_rctl;		/* ACC or RJT flag */
-	uint8_t priority;	/* OAS priority */
-	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
+	/* Pack the u8's together and make them module-4. */
+	u8 num_bdes;	/* Number of BDEs */
+	u8 abort_bls;	/* ABTS by initiator or responder */
+	u8 abort_rctl;	/* ACC or RJT flag */
+	u8 priority;	/* OAS priority */
+	u8 retry;	/* retry counter for IOCB cmd - if needed */
+	u8 rsvd1;       /* Pad for u32 */
+	u8 rsvd2;       /* Pad for u32 */
+	u8 rsvd3;	/* Pad for u32 */
 
 	u32 cmd_flag;
 #define LPFC_IO_LIBDFC		1	/* libdfc iocb */
@@ -116,18 +120,22 @@ struct lpfc_iocbq {
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
-	void *context1;		/* caller context information */
-	void *context2;		/* caller context information */
-	void *context3;		/* caller context information */
+	struct lpfc_dmabuf *cmd_dmabuf;
+	struct lpfc_dmabuf *rsp_dmabuf;
+	struct lpfc_dmabuf *bpl_dmabuf;
 	uint32_t event_tag;	/* LA Event tag */
 	union {
 		wait_queue_head_t    *wait_queue;
-		struct lpfc_iocbq    *rsp_iocb;
 		struct lpfcMboxq     *mbox;
-		struct lpfc_nodelist *ndlp;
 		struct lpfc_node_rrq *rrq;
+		struct nvmefc_ls_req *nvme_lsreq;
+		struct lpfc_async_xchg_ctx *axchg;
+		struct bsg_job_data *dd_data;
 	} context_un;
 
+	struct lpfc_io_buf *io_buf;
+	struct lpfc_iocbq *rsp_iocb;
+	struct lpfc_nodelist *ndlp;
 	union lpfc_vmid_tag vmid_tag;
 	void (*fabric_cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
 				struct lpfc_iocbq *rsp);
-- 
2.26.2

