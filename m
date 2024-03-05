Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB305C5FD
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668171; cv=none; b=GQaLqFX7Z+0wYLoNp13r49Qbq2gu59Rffg2w9OwFuISz29OPaVkETInwAXsC6JQir+O58CgPeVIsOFw/1Jk5QTUSZsvmqWrhytZ0AcyqjBCX2YvfrHyz1Fi9vBzZHnrWXslMqkaWSh4sVefaf372sGPrz5OWcT8VgT5JZC3ToXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668171; c=relaxed/simple;
	bh=7pl08Ohq0BpM7jsMJA/DrBuxUS8JyV2+ty72sxwSjKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qgrOC2WRqnlF59ukqh3bkvOyXRU78unFrN3MmcYzTkWO8XYWVc78Gg2SlZdi4OgtsbuyVe494QT8jb7N4xGS785tfnSP5QOBBq6B7/3PPWsHWfhfnyqwWvHGVsq0GhifGVqe912ZeqCRa7m112nRlYFyVe7Wi1jhx+JcyNCR4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAnwo3j4; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAnwo3j4"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a1358e7e16so663290eaf.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668168; x=1710272968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Kebv9LHLIarQcTYXttD6K6uy2ZggB3Ri0rxU3pEn7o=;
        b=QAnwo3j4RiSMHpmgPC5q1dRDOgQIUR64kCcasBVLSr9chJsFx9n5UjHGnZeCw3xWWy
         ekSdjtGXk9zxFOn/M/I/m8vd7h7q1tXfUFMyiqs8P8frO4JpPnQa36MB5ifKfNG4kU1h
         pn7ctO1/1cqczWpWszrOsGRFR40IMScQkpb1fuoLscXv+GOoGiHhCSgUA/qE3c79eFcT
         DQLMPnMCWkvJeAoyc1yyEdeExdU5uANV4dCkTJ0UuVS9vGXzQwEds94rsLdy7S4wHGtB
         hvU2iqe8wHPVsSIZUXUv2ChMCYjkMC73HzaiaTWcvOSD0Cp87wlIh+Mgpmp5+t5DfTrA
         3jGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668168; x=1710272968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Kebv9LHLIarQcTYXttD6K6uy2ZggB3Ri0rxU3pEn7o=;
        b=AtqsXzGyp8AsHk5dGjg+QmXakZDEpLd76Wq1YfZCHvuwHi5FwPcbGorIo6Je3Vkw4v
         9iJOt9QI8DwXIT1FeOj+55Gp6MlvLtj5pjspdLo7FjJz7TW4MzBP67Kqz66OgUyLlZtG
         +m9rQ8M5lTflXq4+w9XwnsAZcgXz45cLqOsN6FtAO28yKLbZ2gCgJ7n5ljVq7sLwc1Do
         vCUxWDHJ6Dcbh183HQlTcQoZxw10cCV7K09t89RUqTmGZ5wbOi5VLuG/xmb/z+htBcTu
         MixIx5uxTXU0aXYOnqG5Nzl/T2r/CwFto/8qB3UtuVCeDiI7HC0Oj3vhsBLuzQu6WmNu
         +RTA==
X-Gm-Message-State: AOJu0Ywi4qW48Xwob44BrrA+u+YhvE9Zykc+FvBN6DM3iSZmimfnKH/0
	pLxzwr40z8ybBiWl1lR4GVd8jwdFkNydPPP0hcicfidJFRUOygqAprjtWmN9
X-Google-Smtp-Source: AGHT+IHGARHjvRcgyexIniE7ehm8VoUi7y0jV2t4AyDUK7JyKbZ7E3Oe+ZipEO8PQNTCfRtnjoXr2Q==
X-Received: by 2002:a05:6870:9713:b0:220:c9cd:b2b9 with SMTP id n19-20020a056870971300b00220c9cdb2b9mr1583060oaq.4.1709668168154;
        Tue, 05 Mar 2024 11:49:28 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:20 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/12] lpfc: Define lpfc_dmabuf type for ctx_buf ptr
Date: Tue,  5 Mar 2024 12:05:00 -0800
Message-Id: <20240305200503.57317-10-justintee8345@gmail.com>
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

In LPFC_MBOXQ_t, the ctx_buf ptr shouldn't be defined as a generic void
*ptr.  It is named ctx_buf and it should only be used as an lpfc_dmabuf
*ptr.  Due to the void* declaration, there have been abuses of ctx_buf for
things not related to lpfc_dmabuf.

So, set the ptr type for *ctx_buf as lpfc_dmabuf.  Remove all type casts on
ctx_buf because it is no longer a void *ptr.  Convert the abuse of ctx_buf
for something not related to lpfc_dmabuf to use the void *context3 ptr.

A particular abuse of the ctx_buf warranted a new void *ext_buf ptr.
However, the usage of this new void *ext_buf is not generic.  It is
intended to only hold virtual addresses for extended mailbox commands.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       | 12 +++++-----
 drivers/scsi/lpfc/lpfc_els.c       | 14 ++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 10 ++++-----
 drivers/scsi/lpfc/lpfc_init.c      |  8 +++----
 drivers/scsi/lpfc/lpfc_mbox.c      | 15 ++++---------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 35 +++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.h       |  6 ++++-
 drivers/scsi/lpfc/lpfc_vport.c     |  2 +-
 9 files changed, 50 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 03605b827f3a..f784dc9b602a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2513,7 +2513,7 @@ static int lpfcdiag_loop_self_reg(struct lpfc_hba *phba, uint16_t *rpi)
 		return -ENOMEM;
 	}
 
-	dmabuff = (struct lpfc_dmabuf *)mbox->ctx_buf;
+	dmabuff = mbox->ctx_buf;
 	mbox->ctx_buf = NULL;
 	mbox->ctx_ndlp = NULL;
 	status = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
@@ -3553,7 +3553,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	uint8_t *pmbx;
 
-	dd_data = pmboxq->ctx_buf;
+	dd_data = pmboxq->context3;
 
 	/* Determine if job has been aborted */
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -3940,7 +3940,7 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 	pmboxq->mbox_cmpl = lpfc_bsg_issue_read_mbox_ext_cmpl;
 
 	/* context fields to callback function */
-	pmboxq->ctx_buf = dd_data;
+	pmboxq->context3 = dd_data;
 	dd_data->type = TYPE_MBOX;
 	dd_data->set_job = job;
 	dd_data->context_un.mbox.pmboxq = pmboxq;
@@ -4112,7 +4112,7 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 		pmboxq->mbox_cmpl = lpfc_bsg_issue_write_mbox_ext_cmpl;
 
 		/* context fields to callback function */
-		pmboxq->ctx_buf = dd_data;
+		pmboxq->context3 = dd_data;
 		dd_data->type = TYPE_MBOX;
 		dd_data->set_job = job;
 		dd_data->context_un.mbox.pmboxq = pmboxq;
@@ -4460,7 +4460,7 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 		pmboxq->mbox_cmpl = lpfc_bsg_issue_write_mbox_ext_cmpl;
 
 		/* context fields to callback function */
-		pmboxq->ctx_buf = dd_data;
+		pmboxq->context3 = dd_data;
 		dd_data->type = TYPE_MBOX;
 		dd_data->set_job = job;
 		dd_data->context_un.mbox.pmboxq = pmboxq;
@@ -4747,7 +4747,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	if (mbox_req->inExtWLen || mbox_req->outExtWLen) {
 		from = pmbx;
 		ext = from + sizeof(MAILBOX_t);
-		pmboxq->ctx_buf = ext;
+		pmboxq->ext_buf = ext;
 		pmboxq->in_ext_byte_len =
 			mbox_req->inExtWLen * sizeof(uint32_t);
 		pmboxq->out_ext_byte_len =
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1c0ca5de7e1e..fdb0540fa492 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7290,7 +7290,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->in_ext_byte_len = DMP_SFF_PAGE_A0_SIZE;
 		mbox->out_ext_byte_len = DMP_SFF_PAGE_A0_SIZE;
 		mbox->mbox_offset_word = 5;
-		mbox->ctx_buf = virt;
+		mbox->ext_buf = virt;
 	} else {
 		bf_set(lpfc_mbx_memory_dump_type3_length,
 		       &mbox->u.mqe.un.mem_dump_type3, DMP_SFF_PAGE_A0_SIZE);
@@ -7306,7 +7306,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
+		mp = mbox->ctx_buf;
 	else
 		mp = mpsave;
 
@@ -7349,7 +7349,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->in_ext_byte_len = DMP_SFF_PAGE_A2_SIZE;
 		mbox->out_ext_byte_len = DMP_SFF_PAGE_A2_SIZE;
 		mbox->mbox_offset_word = 5;
-		mbox->ctx_buf = virt;
+		mbox->ext_buf = virt;
 	} else {
 		bf_set(lpfc_mbx_memory_dump_type3_length,
 		       &mbox->u.mqe.un.mem_dump_type3, DMP_SFF_PAGE_A2_SIZE);
@@ -8637,9 +8637,9 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mb = &pmb->u.mb;
 
 	ndlp = pmb->ctx_ndlp;
-	rxid = (uint16_t)((unsigned long)(pmb->ctx_buf) & 0xffff);
-	oxid = (uint16_t)(((unsigned long)(pmb->ctx_buf) >> 16) & 0xffff);
-	pmb->ctx_buf = NULL;
+	rxid = (uint16_t)((unsigned long)(pmb->context3) & 0xffff);
+	oxid = (uint16_t)(((unsigned long)(pmb->context3) >> 16) & 0xffff);
+	pmb->context3 = NULL;
 	pmb->ctx_ndlp = NULL;
 
 	if (mb->mbxStatus) {
@@ -8743,7 +8743,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
 	if (mbox) {
 		lpfc_read_lnk_stat(phba, mbox);
-		mbox->ctx_buf = (void *)((unsigned long)
+		mbox->context3 = (void *)((unsigned long)
 					 (ox_id << 16 | ctx));
 		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
 		if (!mbox->ctx_ndlp)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c1cc2850ba71..e42fa9c822b5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3428,7 +3428,7 @@ static void
 lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	MAILBOX_t *mb = &pmb->u.mb;
-	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+	struct lpfc_dmabuf *mp = pmb->ctx_buf;
 	struct lpfc_vport  *vport = pmb->vport;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct serv_parm *sp = &vport->fc_sparam;
@@ -3736,7 +3736,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_mbx_read_top *la;
 	struct lpfc_sli_ring *pring;
 	MAILBOX_t *mb = &pmb->u.mb;
-	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
+	struct lpfc_dmabuf *mp = pmb->ctx_buf;
 	uint8_t attn_type;
 
 	/* Unblock ELS traffic */
@@ -3850,7 +3850,7 @@ void
 lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport  *vport = pmb->vport;
-	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+	struct lpfc_dmabuf *mp = pmb->ctx_buf;
 	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 
 	/* The driver calls the state machine with the pmb pointer
@@ -4065,7 +4065,7 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 		 * the dump routine is a single-use construct.
 		 */
 		if (pmb->ctx_buf) {
-			mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+			mp = pmb->ctx_buf;
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			kfree(mp);
 			pmb->ctx_buf = NULL;
@@ -4088,7 +4088,7 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			byte_count = pmb->u.mqe.un.mb_words[5];
-			mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+			mp = pmb->ctx_buf;
 			if (byte_count > sizeof(struct static_vport_info) -
 					offset)
 				byte_count = sizeof(struct static_vport_info)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c4c305472285..f7a0aa3625f4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -460,7 +460,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 		return -EIO;
 	}
 
-	mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+	mp = pmb->ctx_buf;
 
 	/* This dmabuf was allocated by lpfc_read_sparam. The dmabuf is no
 	 * longer needed.  Prevent unintended ctx_buf access as the mbox is
@@ -2217,7 +2217,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	/* Cleanup any outstanding ELS commands */
 	lpfc_els_flush_all_cmd(phba);
 	psli->slistat.link_event++;
-	lpfc_read_topology(phba, pmb, (struct lpfc_dmabuf *)pmb->ctx_buf);
+	lpfc_read_topology(phba, pmb, pmb->ctx_buf);
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = vport;
 	/* Block ELS IOCBs until we have processed this mbox command */
@@ -5454,7 +5454,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	phba->sli.slistat.link_event++;
 
 	/* Create lpfc_handle_latt mailbox command from link ACQE */
-	lpfc_read_topology(phba, pmb, (struct lpfc_dmabuf *)pmb->ctx_buf);
+	lpfc_read_topology(phba, pmb, pmb->ctx_buf);
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = phba->pport;
 
@@ -6347,7 +6347,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	phba->sli.slistat.link_event++;
 
 	/* Create lpfc_handle_latt mailbox command from link ACQE */
-	lpfc_read_topology(phba, pmb, (struct lpfc_dmabuf *)pmb->ctx_buf);
+	lpfc_read_topology(phba, pmb, pmb->ctx_buf);
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = phba->pport;
 
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index d4c9a537f834..eaa3f89458ec 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -102,7 +102,7 @@ lpfc_mbox_rsrc_cleanup(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
 {
 	struct lpfc_dmabuf *mp;
 
-	mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+	mp = mbox->ctx_buf;
 	mbox->ctx_buf = NULL;
 
 	/* Release the generic BPL buffer memory.  */
@@ -204,10 +204,8 @@ lpfc_dump_mem(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, uint16_t offset,
 		uint16_t region_id)
 {
 	MAILBOX_t *mb;
-	void *ctx;
 
 	mb = &pmb->u.mb;
-	ctx = pmb->ctx_buf;
 
 	/* Setup to dump VPD region */
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
@@ -219,7 +217,6 @@ lpfc_dump_mem(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, uint16_t offset,
 	mb->un.varDmp.word_cnt = (DMP_RSP_SIZE / sizeof (uint32_t));
 	mb->un.varDmp.co = 0;
 	mb->un.varDmp.resp_offset = 0;
-	pmb->ctx_buf = ctx;
 	mb->mbxOwner = OWN_HOST;
 	return;
 }
@@ -236,11 +233,8 @@ void
 lpfc_dump_wakeup_param(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	MAILBOX_t *mb;
-	void *ctx;
 
 	mb = &pmb->u.mb;
-	/* Save context so that we can restore after memset */
-	ctx = pmb->ctx_buf;
 
 	/* Setup to dump VPD region */
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
@@ -254,7 +248,6 @@ lpfc_dump_wakeup_param(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mb->un.varDmp.word_cnt = WAKE_UP_PARMS_WORD_SIZE;
 	mb->un.varDmp.co = 0;
 	mb->un.varDmp.resp_offset = 0;
-	pmb->ctx_buf = ctx;
 	return;
 }
 
@@ -372,7 +365,7 @@ lpfc_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb,
 	/* Save address for later completion and set the owner to host so that
 	 * the FW knows this mailbox is available for processing.
 	 */
-	pmb->ctx_buf = (uint8_t *)mp;
+	pmb->ctx_buf = mp;
 	mb->mbxOwner = OWN_HOST;
 	return (0);
 }
@@ -2385,7 +2378,7 @@ lpfc_mbx_cmpl_rdp_link_stat(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 static void
 lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
-	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+	struct lpfc_dmabuf *mp = mbox->ctx_buf;
 	struct lpfc_rdp_context *rdp_context =
 			(struct lpfc_rdp_context *)(mbox->context3);
 
@@ -2416,7 +2409,7 @@ void
 lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	int rc;
-	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
+	struct lpfc_dmabuf *mp = mbox->ctx_buf;
 	struct lpfc_rdp_context *rdp_context =
 			(struct lpfc_rdp_context *)(mbox->context3);
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8878f3c3cc2a..c6b76c3d0f70 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -682,7 +682,7 @@ lpfc_mbx_cmpl_resume_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	struct lpfc_nodelist *ndlp;
 	uint32_t cmd;
 
-	elsiocb = (struct lpfc_iocbq *)mboxq->ctx_buf;
+	elsiocb = mboxq->context3;
 	ndlp = mboxq->ctx_ndlp;
 	vport = mboxq->vport;
 	cmd = elsiocb->drvrTimeout;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 236b4e7e1de1..aa746cb08841 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2885,7 +2885,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
 	    pmb->u.mb.mbxCommand == MBX_REG_LOGIN64 &&
 	    !pmb->u.mb.mbxStatus) {
-		mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+		mp = pmb->ctx_buf;
 		if (mp) {
 			pmb->ctx_buf = NULL;
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
@@ -5819,7 +5819,7 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba)
 		goto out_free_mboxq;
 	}
 
-	mp = (struct lpfc_dmabuf *)mboxq->ctx_buf;
+	mp = mboxq->ctx_buf;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
@@ -8766,7 +8766,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 
 	mboxq->vport = vport;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	mp = (struct lpfc_dmabuf *)mboxq->ctx_buf;
+	mp = mboxq->ctx_buf;
 	if (rc == MBX_SUCCESS) {
 		memcpy(&vport->fc_sparam, mp->virt, sizeof(struct serv_parm));
 		rc = 0;
@@ -9548,8 +9548,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		}
 
 		/* Copy the mailbox extension data */
-		if (pmbox->in_ext_byte_len && pmbox->ctx_buf) {
-			lpfc_sli_pcimem_bcopy(pmbox->ctx_buf,
+		if (pmbox->in_ext_byte_len && pmbox->ext_buf) {
+			lpfc_sli_pcimem_bcopy(pmbox->ext_buf,
 					      (uint8_t *)phba->mbox_ext,
 					      pmbox->in_ext_byte_len);
 		}
@@ -9562,10 +9562,10 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 				= MAILBOX_HBA_EXT_OFFSET;
 
 		/* Copy the mailbox extension data */
-		if (pmbox->in_ext_byte_len && pmbox->ctx_buf)
+		if (pmbox->in_ext_byte_len && pmbox->ext_buf)
 			lpfc_memcpy_to_slim(phba->MBslimaddr +
 				MAILBOX_HBA_EXT_OFFSET,
-				pmbox->ctx_buf, pmbox->in_ext_byte_len);
+				pmbox->ext_buf, pmbox->in_ext_byte_len);
 
 		if (mbx->mbxCommand == MBX_CONFIG_PORT)
 			/* copy command data into host mbox for cmpl */
@@ -9688,9 +9688,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 			lpfc_sli_pcimem_bcopy(phba->mbox, mbx,
 						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
-			if (pmbox->out_ext_byte_len && pmbox->ctx_buf) {
+			if (pmbox->out_ext_byte_len && pmbox->ext_buf) {
 				lpfc_sli_pcimem_bcopy(phba->mbox_ext,
-						      pmbox->ctx_buf,
+						      pmbox->ext_buf,
 						      pmbox->out_ext_byte_len);
 			}
 		} else {
@@ -9698,9 +9698,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 			lpfc_memcpy_from_slim(mbx, phba->MBslimaddr,
 						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
-			if (pmbox->out_ext_byte_len && pmbox->ctx_buf) {
+			if (pmbox->out_ext_byte_len && pmbox->ext_buf) {
 				lpfc_memcpy_from_slim(
-					pmbox->ctx_buf,
+					pmbox->ext_buf,
 					phba->MBslimaddr +
 					MAILBOX_HBA_EXT_OFFSET,
 					pmbox->out_ext_byte_len);
@@ -13813,10 +13813,10 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 					lpfc_sli_pcimem_bcopy(mbox, pmbox,
 							MAILBOX_CMD_SIZE);
 					if (pmb->out_ext_byte_len &&
-						pmb->ctx_buf)
+						pmb->ext_buf)
 						lpfc_sli_pcimem_bcopy(
 						phba->mbox_ext,
-						pmb->ctx_buf,
+						pmb->ext_buf,
 						pmb->out_ext_byte_len);
 				}
 				if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
@@ -13830,8 +13830,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 						pmbox->un.varWords[0], 0);
 
 					if (!pmbox->mbxStatus) {
-						mp = (struct lpfc_dmabuf *)
-							(pmb->ctx_buf);
+						mp = pmb->ctx_buf;
 						ndlp = pmb->ctx_ndlp;
 
 						/* Reg_LOGIN of dflt RPI was
@@ -14339,7 +14338,7 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 				      mcqe_status,
 				      pmbox->un.varWords[0], 0);
 		if (mcqe_status == MB_CQE_STATUS_SUCCESS) {
-			mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
+			mp = pmb->ctx_buf;
 			ndlp = pmb->ctx_ndlp;
 
 			/* Reg_LOGIN of dflt RPI was successful. Mark the
@@ -19858,7 +19857,7 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
 	lpfc_resume_rpi(mboxq, ndlp);
 	if (cmpl) {
 		mboxq->mbox_cmpl = cmpl;
-		mboxq->ctx_buf = arg;
+		mboxq->context3 = arg;
 	} else
 		mboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	mboxq->ctx_ndlp = ndlp;
@@ -20675,7 +20674,7 @@ lpfc_sli4_get_config_region23(struct lpfc_hba *phba, char *rgn23_data)
 	if (lpfc_sli4_dump_cfg_rg23(phba, mboxq))
 		goto out;
 	mqe = &mboxq->u.mqe;
-	mp = (struct lpfc_dmabuf *)mboxq->ctx_buf;
+	mp = mboxq->ctx_buf;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 	if (rc)
 		goto out;
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 60332de27f44..29fdccd689af 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -183,7 +183,11 @@ typedef struct lpfcMboxq {
 	} u;
 	struct lpfc_vport *vport; /* virtual port pointer */
 	struct lpfc_nodelist *ctx_ndlp;	/* caller ndlp pointer */
-	void *ctx_buf;			/* caller buffer information */
+	struct lpfc_dmabuf *ctx_buf;	/* caller buffer information */
+	void *ext_buf;			/* extended buffer for extended mbox
+					 * cmds.  Not a generic pointer.
+					 * Use for storing virtual address.
+					 */
 	void *context3;			/* a generic pointer.  Code must
 					 * accommodate the actual datatype.
 					 */
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 9850080ee33d..4439167a5188 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -166,7 +166,7 @@ lpfc_vport_sparm(struct lpfc_hba *phba, struct lpfc_vport *vport)
 		}
 	}
 
-	mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+	mp = pmb->ctx_buf;
 	memcpy(&vport->fc_sparam, mp->virt, sizeof (struct serv_parm));
 	memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
 	       sizeof (struct lpfc_name));
-- 
2.38.0

