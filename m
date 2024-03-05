Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527198664F
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668162; cv=none; b=OeYSvnv8i1q2FQJBV3eZO/hh+c61sfN96uugVEEcruEAEhpxMMRidJpAk6E3WnPU8Zt0OqZM01cAktDjV+XcyV0qZWK7tQMOJEOm3UKPOM8XjZ0mAHkTXRjR3rg2NPYgFVsG/gUi8v+7XDLIwmeIhrww5GLus1uSfuXNPDrIoGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668162; c=relaxed/simple;
	bh=JBDYrl9Rs7SwlIyy5qv0Utf0GUdWaKES/CKNLRp/+Uo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cUB35K2iGbfP+mz05+qSSkmn2X+DQ7HBA+hJZ1mEl/Jhe+UAbpYSLrTtMa1dAuoElEEzXmHE5K9LvxLQXpZKaiO07+zOV+G2MiR9oDO+RiuO0hVT5Vl9gY0wXsDXaWeiyk4squ5pZmVHQtTRtVKhgzJ5voh2pM1bMz6blsDBlXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J39bGTiN; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J39bGTiN"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-788251ac2f5so16310885a.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668159; x=1710272959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zVNEEZPp8/XxtbvJiWqdZKMg/0wsT0cYyOt5Z1PzU8=;
        b=J39bGTiN3uYDF/Vu59hOCxOtdYq6okWTsAzYRZNCotIemKXji9zSU/FtW0yyWSiuLP
         WYQYDD1las7BE4+K/NdiAxpbDlOBYDLmenSboVCBpNR2sDTV1LTsoJ2Mv/aoo8/2kF5G
         jhSECCChZB+1vZAOf0rCsTLvI+Zm1j7caba3SLWug7TN0T0mIv8hpatqlMm6goQJA4hH
         phZ6HP5jnn/GzIVGcUd0aGfwKHzr6QadztgwPm9/eoXnepbWvHKLVISBL3xvNpfPp/35
         Wi8gqUQm1cbh1if9NTOQxlGJ+4Bi0/yM2EQHmGr1fXI8pCJFqBqFzLeTsn/pJDhFdN74
         3gPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668159; x=1710272959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zVNEEZPp8/XxtbvJiWqdZKMg/0wsT0cYyOt5Z1PzU8=;
        b=urffCKN41T9Ot0Ex/UkAR6v3Lua0ULLa4Gtbiw7UT8B39s8LmYfGh+7BKtNErkn+Vl
         P01JV0WpLc0RqvSeCQHolklfzGW4PCMa5y8HpfBHifG++h71he/ggMvOsuD9uHCoWo95
         ruweghvHBUsyZUanwF0EgTEcGNRbZPpIGD1ALoqj31UtJDRTwFqq76hSeMjrkM/U/SEW
         Y9XEFjncLBt/2SRMZAnU2O5sO0qmy6eXqFe++Wjv8sP1Ia/UbllBZuK/3OsEb31rTlhr
         EnmBLp4kh1b/i16LRxUXGzxvtG4yMQ+yHX8nxuC1ofi125AIiFsLLW6RL8GXzxJ0Z+OY
         uysA==
X-Gm-Message-State: AOJu0Yzu3WQs4AzME1+SxvVwZoELna/P586UnTLcyHq1IjcpVI66K7zY
	PQhYpd+3bXTp/6kXpiuEOyGmdGHcb0Lsdn1q2bb7PuHY2fgSYGdrbU6/rNnj
X-Google-Smtp-Source: AGHT+IHBwv39yVeJxBQurqQey0HRCZTkHXGPjko2iOg2rbeSNPxrEMIe7iBasWmcthjiSZx6kUp+rg==
X-Received: by 2002:a05:620a:471e:b0:788:2c10:3ef3 with SMTP id bs30-20020a05620a471e00b007882c103ef3mr1288038qkb.4.1709668159209;
        Tue, 05 Mar 2024 11:49:19 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:18 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/12] lpfc: Define lpfc_nodelist type for ctx_ndlp ptr
Date: Tue,  5 Mar 2024 12:04:59 -0800
Message-Id: <20240305200503.57317-9-justintee8345@gmail.com>
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

In LPFC_MBOXQ_t data structure, the ctx_ndlp ptr shouldn't be defined as a
generic void *ptr.  It is named ctx_ndlp and it should only be used as an
lpfc_nodelist *ptr.  Due to the void* declaration, there have been abuses
of ctx_ndlp for things not related to ndlp.

So, set the ptr type for *ctx_ndlp as lpfc_nodelist.  Remove all type casts
on ctx_ndlp because it is no longer a void *ptr.  Convert the abuse of
ctx_ndlp for things not related to ndlps to use the void *context3 ptr.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |  4 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 10 ++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 18 +++++++++---------
 drivers/scsi/lpfc/lpfc_mbox.c      | 10 +++++-----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  6 +++---
 drivers/scsi/lpfc/lpfc_sli.c       | 17 ++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h       | 10 +++++-----
 7 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index fee485e47041..03605b827f3a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3376,7 +3376,7 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	unsigned long flags;
 	uint8_t *pmb, *pmb_buf;
 
-	dd_data = pmboxq->ctx_ndlp;
+	dd_data = pmboxq->context3;
 
 	/*
 	 * The outgoing buffer is readily referred from the dma buffer,
@@ -4875,7 +4875,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	pmboxq->mbox_cmpl = lpfc_bsg_issue_mbox_cmpl;
 
 	/* setup context field to pass wait_queue pointer to wake function */
-	pmboxq->ctx_ndlp = dd_data;
+	pmboxq->context3 = dd_data;
 	dd_data->type = TYPE_MBOX;
 	dd_data->set_job = job;
 	dd_data->context_un.mbox.pmboxq = pmboxq;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 157a910666db..1c0ca5de7e1e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7238,7 +7238,7 @@ lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 		goto rdp_fail;
 	mbox->vport = rdp_context->ndlp->vport;
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a0;
-	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
+	mbox->context3 = (struct lpfc_rdp_context *)rdp_context;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
@@ -7298,7 +7298,6 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
 	mbox->vport = phba->pport;
-	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
 
 	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
 	if (rc == MBX_NOT_FINISHED) {
@@ -7358,7 +7357,6 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
 
-	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
 	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
@@ -7500,9 +7498,9 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	int rc;
 
 	mb = &pmb->u.mb;
-	lcb_context = (struct lpfc_lcb_context *)pmb->ctx_ndlp;
+	lcb_context = (struct lpfc_lcb_context *)pmb->context3;
 	ndlp = lcb_context->ndlp;
-	pmb->ctx_ndlp = NULL;
+	pmb->context3 = NULL;
 	pmb->ctx_buf = NULL;
 
 	shdr = (union lpfc_sli4_cfg_shdr *)
@@ -7642,7 +7640,7 @@ lpfc_sli4_set_beacon(struct lpfc_vport *vport,
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
 			 LPFC_MBOX_OPCODE_SET_BEACON_CONFIG, len,
 			 LPFC_SLI4_MBX_EMBED);
-	mbox->ctx_ndlp = (void *)lcb_context;
+	mbox->context3 = (void *)lcb_context;
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_els_lcb_rsp;
 	bf_set(lpfc_mbx_set_beacon_port_num, &mbox->u.mqe.un.beacon_config,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2ab51397f4a6..c1cc2850ba71 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3851,7 +3851,7 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 
 	/* The driver calls the state machine with the pmb pointer
 	 * but wants to make sure a stale ctx_buf isn't acted on.
@@ -4168,7 +4168,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
 	MAILBOX_t *mb = &pmb->u.mb;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 
 	pmb->ctx_ndlp = NULL;
 
@@ -4306,7 +4306,7 @@ void
 lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	MAILBOX_t *mb = &pmb->u.mb;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 	struct lpfc_vport *vport = pmb->vport;
 	int rc;
 
@@ -4430,7 +4430,7 @@ lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
 	MAILBOX_t *mb = &pmb->u.mb;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 
 	pmb->ctx_ndlp = NULL;
 	if (mb->mbxStatus) {
@@ -5173,7 +5173,7 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_nodelist *ndlp;
 
-	ndlp = (struct lpfc_nodelist *)(pmb->ctx_ndlp);
+	ndlp = pmb->ctx_ndlp;
 	if (!ndlp)
 		return;
 	lpfc_issue_els_logo(vport, ndlp, 0);
@@ -5495,7 +5495,7 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if ((mb = phba->sli.mbox_active)) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   !(mb->mbox_flag & LPFC_MBX_IMED_UNREG) &&
-		   (ndlp == (struct lpfc_nodelist *)mb->ctx_ndlp)) {
+		   (ndlp == mb->ctx_ndlp)) {
 			mb->ctx_ndlp = NULL;
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		}
@@ -5506,7 +5506,7 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	list_for_each_entry(mb, &phba->sli.mboxq_cmpl, list) {
 		if ((mb->u.mb.mbxCommand != MBX_REG_LOGIN64) ||
 			(mb->mbox_flag & LPFC_MBX_IMED_UNREG) ||
-			(ndlp != (struct lpfc_nodelist *)mb->ctx_ndlp))
+			(ndlp != mb->ctx_ndlp))
 			continue;
 
 		mb->ctx_ndlp = NULL;
@@ -5516,7 +5516,7 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   !(mb->mbox_flag & LPFC_MBX_IMED_UNREG) &&
-		    (ndlp == (struct lpfc_nodelist *)mb->ctx_ndlp)) {
+		    (ndlp == mb->ctx_ndlp)) {
 			list_del(&mb->list);
 			lpfc_mbox_rsrc_cleanup(phba, mb, MBOX_THD_LOCKED);
 
@@ -6356,7 +6356,7 @@ void
 lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	MAILBOX_t *mb = &pmb->u.mb;
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
 	struct lpfc_vport    *vport = pmb->vport;
 
 	pmb->ctx_ndlp = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index f7c41958036b..d4c9a537f834 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2367,7 +2367,7 @@ lpfc_mbx_cmpl_rdp_link_stat(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	MAILBOX_t *mb;
 	int rc = FAILURE;
 	struct lpfc_rdp_context *rdp_context =
-			(struct lpfc_rdp_context *)(mboxq->ctx_ndlp);
+			(struct lpfc_rdp_context *)(mboxq->context3);
 
 	mb = &mboxq->u.mb;
 	if (mb->mbxStatus)
@@ -2387,7 +2387,7 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
 	struct lpfc_rdp_context *rdp_context =
-			(struct lpfc_rdp_context *)(mbox->ctx_ndlp);
+			(struct lpfc_rdp_context *)(mbox->context3);
 
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
 		goto error_mbox_free;
@@ -2401,7 +2401,7 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	/* Save the dma buffer for cleanup in the final completion. */
 	mbox->ctx_buf = mp;
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_link_stat;
-	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
+	mbox->context3 = (struct lpfc_rdp_context *)rdp_context;
 	if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) == MBX_NOT_FINISHED)
 		goto error_mbox_free;
 
@@ -2418,7 +2418,7 @@ lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	int rc;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
 	struct lpfc_rdp_context *rdp_context =
-			(struct lpfc_rdp_context *)(mbox->ctx_ndlp);
+			(struct lpfc_rdp_context *)(mbox->context3);
 
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
 		goto error;
@@ -2448,7 +2448,7 @@ lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a2;
-	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
+	mbox->context3 = (struct lpfc_rdp_context *)rdp_context;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		goto error;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8e425be7c7c9..8878f3c3cc2a 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -683,7 +683,7 @@ lpfc_mbx_cmpl_resume_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint32_t cmd;
 
 	elsiocb = (struct lpfc_iocbq *)mboxq->ctx_buf;
-	ndlp = (struct lpfc_nodelist *)mboxq->ctx_ndlp;
+	ndlp = mboxq->ctx_ndlp;
 	vport = mboxq->vport;
 	cmd = elsiocb->drvrTimeout;
 
@@ -1875,7 +1875,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
 	if ((mb = phba->sli.mbox_active)) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
-		   (ndlp == (struct lpfc_nodelist *)mb->ctx_ndlp)) {
+		   (ndlp == mb->ctx_ndlp)) {
 			ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 			lpfc_nlp_put(ndlp);
 			mb->ctx_ndlp = NULL;
@@ -1886,7 +1886,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
-		   (ndlp == (struct lpfc_nodelist *)mb->ctx_ndlp)) {
+		   (ndlp == mb->ctx_ndlp)) {
 			ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 			lpfc_nlp_put(ndlp);
 			list_del(&mb->list);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7f87046e64b7..236b4e7e1de1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2914,12 +2914,12 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	if (pmb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
-		ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+		ndlp = pmb->ctx_ndlp;
 		lpfc_nlp_put(ndlp);
 	}
 
 	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) {
-		ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+		ndlp = pmb->ctx_ndlp;
 
 		/* Check to see if there are any deferred events to process */
 		if (ndlp) {
@@ -2952,7 +2952,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	/* This nlp_put pairs with lpfc_sli4_resume_rpi */
 	if (pmb->u.mb.mbxCommand == MBX_RESUME_RPI) {
-		ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+		ndlp = pmb->ctx_ndlp;
 		lpfc_nlp_put(ndlp);
 	}
 
@@ -13832,8 +13832,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 					if (!pmbox->mbxStatus) {
 						mp = (struct lpfc_dmabuf *)
 							(pmb->ctx_buf);
-						ndlp = (struct lpfc_nodelist *)
-							pmb->ctx_ndlp;
+						ndlp = pmb->ctx_ndlp;
 
 						/* Reg_LOGIN of dflt RPI was
 						 * successful. new lets get
@@ -14341,7 +14340,7 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 				      pmbox->un.varWords[0], 0);
 		if (mcqe_status == MB_CQE_STATUS_SUCCESS) {
 			mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
-			ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+			ndlp = pmb->ctx_ndlp;
 
 			/* Reg_LOGIN of dflt RPI was successful. Mark the
 			 * node as having an UNREG_LOGIN in progress to stop
@@ -21035,7 +21034,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 			(mb->u.mb.mbxCommand == MBX_REG_VPI))
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
-			act_mbx_ndlp = (struct lpfc_nodelist *)mb->ctx_ndlp;
+			act_mbx_ndlp = mb->ctx_ndlp;
 
 			/* This reference is local to this routine.  The
 			 * reference is removed at routine exit.
@@ -21064,7 +21063,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
-				ndlp = (struct lpfc_nodelist *)mb->ctx_ndlp;
+				ndlp = mb->ctx_ndlp;
 				/* Unregister the RPI when mailbox complete */
 				mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
 				restart_loop = 1;
@@ -21084,7 +21083,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 	while (!list_empty(&mbox_cmd_list)) {
 		list_remove_head(&mbox_cmd_list, mb, LPFC_MBOXQ_t, list);
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
-			ndlp = (struct lpfc_nodelist *)mb->ctx_ndlp;
+			ndlp = mb->ctx_ndlp;
 			mb->ctx_ndlp = NULL;
 			if (ndlp) {
 				spin_lock(&ndlp->lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index c911a39cb46b..60332de27f44 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -182,11 +182,11 @@ typedef struct lpfcMboxq {
 		struct lpfc_mqe mqe;
 	} u;
 	struct lpfc_vport *vport; /* virtual port pointer */
-	void *ctx_ndlp;		  /* an lpfc_nodelist pointer */
-	void *ctx_buf;		  /* an lpfc_dmabuf pointer */
-	void *context3;           /* a generic pointer.  Code must
-				   * accommodate the actual datatype.
-				   */
+	struct lpfc_nodelist *ctx_ndlp;	/* caller ndlp pointer */
+	void *ctx_buf;			/* caller buffer information */
+	void *context3;			/* a generic pointer.  Code must
+					 * accommodate the actual datatype.
+					 */
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
 	uint8_t mbox_flag;
-- 
2.38.0

