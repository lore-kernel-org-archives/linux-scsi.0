Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D585824A1D
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668176; cv=none; b=PS9rY7EwTFLQlC2tuOgbodQTtiJ8CPoJaVkYM1n8WH9W8b+FM8pJJ9LQhaS1VWc0Dpq0SyhimMK2+nD7G16Y57UNHySHKilESzaBs+/lCthtumxyuMDGPH8vACpC+IqAGbTb/pqfg8lpQRYURlVzyz6hVDMsirXhaQ0ypzyqnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668176; c=relaxed/simple;
	bh=haI7AaOnLd2eVdeEJL6FyAT/Gj1A7sZakq2LrkbtXno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FvtIbcUYLV4PMUNLuAFCE6lnLEvsAzvgWmxYtqv94P5vEEMkzQc0nu9c3fmGr//omrvyY3B0Iv7sijwqGtgTizeE4vQAmicztRjOur2vi9CkZVkZVJwRd5j1D+kGubnlAAX5QYMMjJ4D3r7AIWMwgQ3zTE5oPpSUecvtHIzAIcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NyyFxgfg; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NyyFxgfg"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-21eab2bd67bso342941fac.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668174; x=1710272974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2VYahat/fLILDC//SS9hGapUtLeYQGcYDcx0qSxOKg=;
        b=NyyFxgfgH70t0nKeYwBh7CSTT/8O4I+UVGy8SEL3DaKpVxk4QbPhGravRK4o1RaaFi
         +yJC8h3IpC2eJsiw4mB2WQ6n6Kf79mSj/Qu2lzaaXgU6djAfrI2dgZY6RyzasrXWNFcr
         CxVUFS1HRc+z/h3Hi3bcUx5rwMMrltPzcap/mCkuuzuwb6q5gNplI3m9kWufjPsFLNA8
         GimZpXKjtI8LkvtR9gjGxdaqjpRV6W0cNSpruqTI1WZmq0p0WZPygKJyVNqBj78mcNfF
         boLJGB3t/TH18aSUv3aX2DxwXshBGgoWxzSsejbwm3TNS+n1A5fXI0106rJ75usT8t/i
         6oOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668174; x=1710272974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r2VYahat/fLILDC//SS9hGapUtLeYQGcYDcx0qSxOKg=;
        b=VVfX1TDsoV2f8W6Q8a7InU0Wsq7mHsNSANHcz+PYCeikIxOmtk0t2XuTZWAEUzW3tU
         A31eSed/zAo8oB5lfvQ6n4xLXumjJz5mY+2WXE+1MgSkE3lDr78Tbuyj1LEEmGBZr8q3
         s+28FTeEfnyKka1AIH9DuN6pE6hoZArsR2eoi/HHfOMfjFeCQbaHBU5JJIJO9YzAEBWL
         pJnY7yyL15GsBVOiWKO8YiTZHk9e/ugeGSBrcEuIaRiL9iMziafT5qrkiReJbnVjZIad
         /LDA0qvNZMejXfwxe3nBtF7AorGQeaLO5AHofKqNseldJNz63NSZLEzCtTo/4x6hQyUz
         m9yA==
X-Gm-Message-State: AOJu0YwipD3/B6frvTnaJ1v7yiyscI/qYH6yNW0Fa3cSB+TZr32Ul4Jz
	2gXWPgoZjjpQ2XV3og1r7nzMhN2vDJrQt1f40AlYcxFodDUrNNsEGkcqczMk
X-Google-Smtp-Source: AGHT+IHwFbCQAYcgYMTK5uSj+KIk17T9h7GIJVKJEoEsmrJ3yiIZpQhGJ0OPHAMI5k7l50YGkn0ZCw==
X-Received: by 2002:a05:6870:2143:b0:221:b2a:3beb with SMTP id g3-20020a056870214300b002210b2a3bebmr1006711oae.2.1709668173944;
        Tue, 05 Mar 2024 11:49:33 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:33 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/12] lpfc: Define types in a union for generic void *context3 ptr
Date: Tue,  5 Mar 2024 12:05:01 -0800
Message-Id: <20240305200503.57317-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In LPFC_MBOXQ_t, the void *context3 ptr is used for various paths.  It is
treated as a generic pointer, and is type casted during its usage.

The issue with this is that it can sometimes get confusing when reading
code as to what the context3 ptr is being used for and mistakenly be reused
in a different context.

Rename context3 to ctx_u, and declare it as a union of defined ptr types.
From now on, the ctx_u ptr may be used only if users define the use case
type.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       | 12 ++++++------
 drivers/scsi/lpfc/lpfc_els.c       | 17 ++++++++---------
 drivers/scsi/lpfc/lpfc_mbox.c      | 15 ++++++---------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  6 +++---
 drivers/scsi/lpfc/lpfc_sli.c       | 15 ++++++++-------
 drivers/scsi/lpfc/lpfc_sli.h       | 20 +++++++++++++++++---
 drivers/scsi/lpfc/lpfc_sli4.h      |  5 +++--
 7 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index f784dc9b602a..bfa63091902b 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3376,7 +3376,7 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	unsigned long flags;
 	uint8_t *pmb, *pmb_buf;
 
-	dd_data = pmboxq->context3;
+	dd_data = pmboxq->ctx_u.dd_data;
 
 	/*
 	 * The outgoing buffer is readily referred from the dma buffer,
@@ -3553,7 +3553,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	uint8_t *pmbx;
 
-	dd_data = pmboxq->context3;
+	dd_data = pmboxq->ctx_u.dd_data;
 
 	/* Determine if job has been aborted */
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -3940,7 +3940,7 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 	pmboxq->mbox_cmpl = lpfc_bsg_issue_read_mbox_ext_cmpl;
 
 	/* context fields to callback function */
-	pmboxq->context3 = dd_data;
+	pmboxq->ctx_u.dd_data = dd_data;
 	dd_data->type = TYPE_MBOX;
 	dd_data->set_job = job;
 	dd_data->context_un.mbox.pmboxq = pmboxq;
@@ -4112,7 +4112,7 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 		pmboxq->mbox_cmpl = lpfc_bsg_issue_write_mbox_ext_cmpl;
 
 		/* context fields to callback function */
-		pmboxq->context3 = dd_data;
+		pmboxq->ctx_u.dd_data = dd_data;
 		dd_data->type = TYPE_MBOX;
 		dd_data->set_job = job;
 		dd_data->context_un.mbox.pmboxq = pmboxq;
@@ -4460,7 +4460,7 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 		pmboxq->mbox_cmpl = lpfc_bsg_issue_write_mbox_ext_cmpl;
 
 		/* context fields to callback function */
-		pmboxq->context3 = dd_data;
+		pmboxq->ctx_u.dd_data = dd_data;
 		dd_data->type = TYPE_MBOX;
 		dd_data->set_job = job;
 		dd_data->context_un.mbox.pmboxq = pmboxq;
@@ -4875,7 +4875,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	pmboxq->mbox_cmpl = lpfc_bsg_issue_mbox_cmpl;
 
 	/* setup context field to pass wait_queue pointer to wake function */
-	pmboxq->context3 = dd_data;
+	pmboxq->ctx_u.dd_data = dd_data;
 	dd_data->type = TYPE_MBOX;
 	dd_data->set_job = job;
 	dd_data->context_un.mbox.pmboxq = pmboxq;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fdb0540fa492..f7c28dc73bf6 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7238,7 +7238,7 @@ lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 		goto rdp_fail;
 	mbox->vport = rdp_context->ndlp->vport;
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a0;
-	mbox->context3 = (struct lpfc_rdp_context *)rdp_context;
+	mbox->ctx_u.rdp = rdp_context;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
@@ -7498,9 +7498,9 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	int rc;
 
 	mb = &pmb->u.mb;
-	lcb_context = (struct lpfc_lcb_context *)pmb->context3;
+	lcb_context = pmb->ctx_u.lcb;
 	ndlp = lcb_context->ndlp;
-	pmb->context3 = NULL;
+	memset(&pmb->ctx_u, 0, sizeof(pmb->ctx_u));
 	pmb->ctx_buf = NULL;
 
 	shdr = (union lpfc_sli4_cfg_shdr *)
@@ -7640,7 +7640,7 @@ lpfc_sli4_set_beacon(struct lpfc_vport *vport,
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
 			 LPFC_MBOX_OPCODE_SET_BEACON_CONFIG, len,
 			 LPFC_SLI4_MBX_EMBED);
-	mbox->context3 = (void *)lcb_context;
+	mbox->ctx_u.lcb = lcb_context;
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_els_lcb_rsp;
 	bf_set(lpfc_mbx_set_beacon_port_num, &mbox->u.mqe.un.beacon_config,
@@ -8637,9 +8637,9 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mb = &pmb->u.mb;
 
 	ndlp = pmb->ctx_ndlp;
-	rxid = (uint16_t)((unsigned long)(pmb->context3) & 0xffff);
-	oxid = (uint16_t)(((unsigned long)(pmb->context3) >> 16) & 0xffff);
-	pmb->context3 = NULL;
+	rxid = (uint16_t)(pmb->ctx_u.ox_rx_id & 0xffff);
+	oxid = (uint16_t)((pmb->ctx_u.ox_rx_id >> 16) & 0xffff);
+	memset(&pmb->ctx_u, 0, sizeof(pmb->ctx_u));
 	pmb->ctx_ndlp = NULL;
 
 	if (mb->mbxStatus) {
@@ -8743,8 +8743,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
 	if (mbox) {
 		lpfc_read_lnk_stat(phba, mbox);
-		mbox->context3 = (void *)((unsigned long)
-					 (ox_id << 16 | ctx));
+		mbox->ctx_u.ox_rx_id = ox_id << 16 | ctx;
 		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
 		if (!mbox->ctx_ndlp)
 			goto node_err;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index eaa3f89458ec..e98f1c2b2220 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1809,7 +1809,7 @@ lpfc_sli4_mbox_cmd_free(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 	}
 	/* Reinitialize the context pointers to avoid stale usage. */
 	mbox->ctx_buf = NULL;
-	mbox->context3 = NULL;
+	memset(&mbox->ctx_u, 0, sizeof(mbox->ctx_u));
 	kfree(mbox->sge_array);
 	/* Finally, free the mailbox command itself */
 	mempool_free(mbox, phba->mbox_mem_pool);
@@ -2359,8 +2359,7 @@ lpfc_mbx_cmpl_rdp_link_stat(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	MAILBOX_t *mb;
 	int rc = FAILURE;
-	struct lpfc_rdp_context *rdp_context =
-			(struct lpfc_rdp_context *)(mboxq->context3);
+	struct lpfc_rdp_context *rdp_context = mboxq->ctx_u.rdp;
 
 	mb = &mboxq->u.mb;
 	if (mb->mbxStatus)
@@ -2379,8 +2378,7 @@ static void
 lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	struct lpfc_dmabuf *mp = mbox->ctx_buf;
-	struct lpfc_rdp_context *rdp_context =
-			(struct lpfc_rdp_context *)(mbox->context3);
+	struct lpfc_rdp_context *rdp_context = mbox->ctx_u.rdp;
 
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
 		goto error_mbox_free;
@@ -2394,7 +2392,7 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	/* Save the dma buffer for cleanup in the final completion. */
 	mbox->ctx_buf = mp;
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_link_stat;
-	mbox->context3 = (struct lpfc_rdp_context *)rdp_context;
+	mbox->ctx_u.rdp = rdp_context;
 	if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) == MBX_NOT_FINISHED)
 		goto error_mbox_free;
 
@@ -2410,8 +2408,7 @@ lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	int rc;
 	struct lpfc_dmabuf *mp = mbox->ctx_buf;
-	struct lpfc_rdp_context *rdp_context =
-			(struct lpfc_rdp_context *)(mbox->context3);
+	struct lpfc_rdp_context *rdp_context = mbox->ctx_u.rdp;
 
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
 		goto error;
@@ -2441,7 +2438,7 @@ lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a2;
-	mbox->context3 = (struct lpfc_rdp_context *)rdp_context;
+	mbox->ctx_u.rdp = rdp_context;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		goto error;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index c6b76c3d0f70..c4172791c267 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -300,7 +300,7 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 	int rc;
 
 	ndlp = login_mbox->ctx_ndlp;
-	save_iocb = login_mbox->context3;
+	save_iocb = login_mbox->ctx_u.save_iocb;
 
 	if (mb->mbxStatus == MBX_SUCCESS) {
 		/* Now that REG_RPI completed successfully,
@@ -640,7 +640,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!login_mbox->ctx_ndlp)
 		goto out;
 
-	login_mbox->context3 = save_iocb; /* For PLOGI ACC */
+	login_mbox->ctx_u.save_iocb = save_iocb; /* For PLOGI ACC */
 
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
@@ -682,7 +682,7 @@ lpfc_mbx_cmpl_resume_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	struct lpfc_nodelist *ndlp;
 	uint32_t cmd;
 
-	elsiocb = mboxq->context3;
+	elsiocb = mboxq->ctx_u.save_iocb;
 	ndlp = mboxq->ctx_ndlp;
 	vport = mboxq->vport;
 	cmd = elsiocb->drvrTimeout;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index aa746cb08841..a028e008dd1e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2830,7 +2830,7 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	 */
 	pmboxq->mbox_flag |= LPFC_MBX_WAKE;
 	spin_lock_irqsave(&phba->hbalock, drvr_flag);
-	pmbox_done = (struct completion *)pmboxq->context3;
+	pmbox_done = pmboxq->ctx_u.mbox_wait;
 	if (pmbox_done)
 		complete(pmbox_done);
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
@@ -13262,9 +13262,9 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq,
 	/* setup wake call as IOCB callback */
 	pmboxq->mbox_cmpl = lpfc_sli_wake_mbox_wait;
 
-	/* setup context3 field to pass wait_queue pointer to wake function  */
+	/* setup ctx_u field to pass wait_queue pointer to wake function  */
 	init_completion(&mbox_done);
-	pmboxq->context3 = &mbox_done;
+	pmboxq->ctx_u.mbox_wait = &mbox_done;
 	/* now issue the command */
 	retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
 	if (retval == MBX_BUSY || retval == MBX_SUCCESS) {
@@ -13272,7 +13272,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq,
 					    msecs_to_jiffies(timeout * 1000));
 
 		spin_lock_irqsave(&phba->hbalock, flag);
-		pmboxq->context3 = NULL;
+		pmboxq->ctx_u.mbox_wait = NULL;
 		/*
 		 * if LPFC_MBX_WAKE flag is set the mailbox is completed
 		 * else do not free the resources.
@@ -19821,14 +19821,15 @@ lpfc_sli4_remove_rpis(struct lpfc_hba *phba)
  * lpfc_sli4_resume_rpi - Remove the rpi bitmask region
  * @ndlp: pointer to lpfc nodelist data structure.
  * @cmpl: completion call-back.
- * @arg: data to load as MBox 'caller buffer information'
+ * @iocbq: data to load as mbox ctx_u information
  *
  * This routine is invoked to remove the memory region that
  * provided rpi via a bitmask.
  **/
 int
 lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
-	void (*cmpl)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *arg)
+		     void (*cmpl)(struct lpfc_hba *, LPFC_MBOXQ_t *),
+		     struct lpfc_iocbq *iocbq)
 {
 	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_hba *phba = ndlp->phba;
@@ -19857,7 +19858,7 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
 	lpfc_resume_rpi(mboxq, ndlp);
 	if (cmpl) {
 		mboxq->mbox_cmpl = cmpl;
-		mboxq->context3 = arg;
+		mboxq->ctx_u.save_iocb = iocbq;
 	} else
 		mboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	mboxq->ctx_ndlp = ndlp;
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 29fdccd689af..39f78ef291f7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -188,9 +188,23 @@ typedef struct lpfcMboxq {
 					 * cmds.  Not a generic pointer.
 					 * Use for storing virtual address.
 					 */
-	void *context3;			/* a generic pointer.  Code must
-					 * accommodate the actual datatype.
-					 */
+
+	/* Pointers that are seldom used during mbox execution, but require
+	 * a saved context.
+	 */
+	union {
+		unsigned long ox_rx_id;		/* Used in els_rsp_rls_acc */
+		struct lpfc_rdp_context *rdp;	/* Used in get_rdp_info */
+		struct lpfc_lcb_context *lcb;	/* Used in set_beacon */
+		struct completion *mbox_wait;	/* Used in issue_mbox_wait */
+		struct bsg_job_data *dd_data;	/* Used in bsg_issue_mbox_cmpl
+						 * and
+						 * bsg_issue_mbox_ext_handle_job
+						 */
+		struct lpfc_iocbq *save_iocb;	/* Used in defer_plogi_acc and
+						 * lpfc_mbx_cmpl_resume_rpi
+						 */
+	} ctx_u;
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
 	uint8_t mbox_flag;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 2541a8fba093..37d9ead7a7c0 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1118,8 +1118,9 @@ void lpfc_sli4_free_rpi(struct lpfc_hba *, int);
 void lpfc_sli4_remove_rpis(struct lpfc_hba *);
 void lpfc_sli4_async_event_proc(struct lpfc_hba *);
 void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
-int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
-			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
+int lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
+			 void (*cmpl)(struct lpfc_hba *, LPFC_MBOXQ_t *),
+			 struct lpfc_iocbq *iocbq);
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba);
 void lpfc_sli4_nvme_pci_offline_aborted(struct lpfc_hba *phba,
 					struct lpfc_io_buf *lpfc_ncmd);
-- 
2.38.0

