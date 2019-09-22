Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2664DC3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE0AE20820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oDb5InnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfIVD7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35111 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfIVD7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id z6so9417447otb.2
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+KHm8gVWESYG/B0hB5Y9H34NE2Ag9n2ALYPvFFCLJe0=;
        b=oDb5InnD+aJwG4Mfe+JqVbCnAo5p7Hqbs9UnnZj7lLKrLNqLlfUXaq1Vg1E4sEUlZX
         JlaQUa0UqqE9RDhseFFRblrrCb0UiIEIggAjD+iv3ef98gb3ScIvNivZ9OveU8vzKxOv
         1ntsFTTaUCPQzZCpKY9mVFCf1inxDvCA3usb7ved1BhU0coN/ribT7NlASA0DvKPgM2m
         OLP1yo/IKbHoZteZqPdJmIcls4wcnHrrQ3YUFfahwNF/c3ebfyThFzygzoAWV6De1Uoq
         BpU9lg7CwxQsjxw7JC7FMwMMIAsv42sT15UIxUmwnvyaQUohEgy32Owv49etuV9HJrve
         /t6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+KHm8gVWESYG/B0hB5Y9H34NE2Ag9n2ALYPvFFCLJe0=;
        b=tR0kZn0NsExhAEJGed1oQXN6SRLBJ0ktJbV19sFdmUsIMf3keQlNt9ofc9Yuqy9+Qi
         KcKGG3iivmk7XoYGH4Hi461ZcyW8qemyIaNtDrX1yySk3Bf3TfHUxhJJDfGdM6Nrcf1S
         ALZaCpzsL5DHG5U8wKun8aql/L/D0iY7+siMyfJVo86B/xqss1lxGPXCBnb+4OZnuitW
         6vXTmI2z8UOTXY4+L9EHsiCtorjlLw0lhikiIB+9wDX8+ooIYoVCOfRAd/0uLVOyhAR/
         /n/ehvgIm46MmyiGp0i1EdXOFuwHIFx78pseBDn5qOxAT9i5vfZOnj0RrnqxKDjphYKN
         G6FA==
X-Gm-Message-State: APjAAAUeLFKOxr6KhQi0szw3aToiNVTTxjzjFzaCqK/VfsuwogjZf4On
        w8wp1cFpjKFyX0gXdCdlct+lPWco
X-Google-Smtp-Source: APXvYqyqvS9C5gf6JCh+eePxKlBdpjOV0biUUJlz5Z3cIEbcyJjPPgEyruD0+RBBOTUO5tHcK6UtKw==
X-Received: by 2002:a05:6830:1d8:: with SMTP id r24mr2205816ota.217.1569124755695;
        Sat, 21 Sep 2019 20:59:15 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/20] lpfc: Fix pt2pt discovery on SLI3 HBAs
Date:   Sat, 21 Sep 2019 20:58:47 -0700
Message-Id: <20190922035906.10977-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After exchanging PLOGI on an SLI-3 adapter, the PRLI
exchange failed.  Link trace showed the port was
assigned a non-zero n_port_id, but didn't use the address
on the PRLI. The assigned address is set on the port
by the CONFIG_LINK mailbox command. The driver responded
to the PRLI before the mailbox command completed. Thus the
PRLI response used the old n_port_id.

Defer the PRLI response until CONFIG_LINK completes.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 141 ++++++++++++++++++++++++++++++-------
 1 file changed, 115 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f4b879d25fe9..4e96d28cba39 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -279,6 +279,55 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
 }
 
+/* lpfc_defer_pt2pt_acc - Complete SLI3 pt2pt processing on link up
+ * @phba: pointer to lpfc hba data structure.
+ * @link_mbox: pointer to CONFIG_LINK mailbox object
+ *
+ * This routine is only called if we are SLI3, direct connect pt2pt
+ * mode and the remote NPort issues the PLOGI after link up.
+ */
+void
+lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
+{
+	LPFC_MBOXQ_t *login_mbox;
+	MAILBOX_t *mb = &link_mbox->u.mb;
+	struct lpfc_iocbq *save_iocb;
+	struct lpfc_nodelist *ndlp;
+	int rc;
+
+	ndlp = link_mbox->ctx_ndlp;
+	login_mbox = link_mbox->context3;
+	save_iocb = login_mbox->context3;
+	link_mbox->context3 = NULL;
+	login_mbox->context3 = NULL;
+
+	/* Check for CONFIG_LINK error */
+	if (mb->mbxStatus) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"4575 CONFIG_LINK fails pt2pt discovery: %x\n",
+				mb->mbxStatus);
+		mempool_free(login_mbox, phba->mbox_mem_pool);
+		mempool_free(link_mbox, phba->mbox_mem_pool);
+		lpfc_sli_release_iocbq(phba, save_iocb);
+		return;
+	}
+
+	/* Now that CONFIG_LINK completed, and our SID is configured,
+	 * we can now proceed with sending the PLOGI ACC.
+	 */
+	rc = lpfc_els_rsp_acc(link_mbox->vport, ELS_CMD_PLOGI,
+			      save_iocb, ndlp, login_mbox);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"4576 PLOGI ACC fails pt2pt discovery: %x\n",
+				rc);
+		mempool_free(login_mbox, phba->mbox_mem_pool);
+	}
+
+	mempool_free(link_mbox, phba->mbox_mem_pool);
+	lpfc_sli_release_iocbq(phba, save_iocb);
+}
+
 static int
 lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	       struct lpfc_iocbq *cmdiocb)
@@ -291,10 +340,12 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	IOCB_t *icmd;
 	struct serv_parm *sp;
 	uint32_t ed_tov;
-	LPFC_MBOXQ_t *mbox;
+	LPFC_MBOXQ_t *link_mbox;
+	LPFC_MBOXQ_t *login_mbox;
+	struct lpfc_iocbq *save_iocb;
 	struct ls_rjt stat;
 	uint32_t vid, flag;
-	int rc;
+	int rc, defer_acc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -343,6 +394,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else
 		ndlp->nlp_fcp_info |= CLASS3;
 
+	defer_acc = 0;
 	ndlp->nlp_class_sup = 0;
 	if (sp->cls1.classValid)
 		ndlp->nlp_class_sup |= FC_COS_CLASS1;
@@ -354,7 +406,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ndlp->nlp_class_sup |= FC_COS_CLASS4;
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
-
 	/* if already logged in, do implicit logout */
 	switch (ndlp->nlp_state) {
 	case  NLP_STE_NPR_NODE:
@@ -396,6 +447,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
 
+	login_mbox = NULL;
+	link_mbox = NULL;
+	save_iocb = NULL;
+
 	/* Check for Nport to NPort pt2pt protocol */
 	if ((vport->fc_flag & FC_PT2PT) &&
 	    !(vport->fc_flag & FC_PT2PT_PLOGI)) {
@@ -423,17 +478,22 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			lpfc_issue_reg_vfi(vport);
 		else {
-			mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-			if (mbox == NULL)
+			defer_acc = 1;
+			link_mbox = mempool_alloc(phba->mbox_mem_pool,
+						  GFP_KERNEL);
+			if (!link_mbox)
 				goto out;
-			lpfc_config_link(phba, mbox);
-			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-			mbox->vport = vport;
-			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-			if (rc == MBX_NOT_FINISHED) {
-				mempool_free(mbox, phba->mbox_mem_pool);
+			lpfc_config_link(phba, link_mbox);
+			link_mbox->mbox_cmpl = lpfc_defer_pt2pt_acc;
+			link_mbox->vport = vport;
+			link_mbox->ctx_ndlp = ndlp;
+
+			save_iocb = lpfc_sli_get_iocbq(phba);
+			if (!save_iocb)
 				goto out;
-			}
+			/* Save info from cmd IOCB used in rsp */
+			memcpy((uint8_t *)save_iocb, (uint8_t *)cmdiocb,
+			       sizeof(struct lpfc_iocbq));
 		}
 
 		lpfc_can_disctmo(vport);
@@ -448,8 +508,8 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			ndlp->nlp_flag |= NLP_SUPPRESS_RSP;
 	}
 
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
+	login_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!login_mbox)
 		goto out;
 
 	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
@@ -457,21 +517,19 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_unreg_rpi(vport, ndlp);
 
 	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
-			    (uint8_t *) sp, mbox, ndlp->nlp_rpi);
-	if (rc) {
-		mempool_free(mbox, phba->mbox_mem_pool);
+			    (uint8_t *)sp, login_mbox, ndlp->nlp_rpi);
+	if (rc)
 		goto out;
-	}
 
 	/* ACC PLOGI rsp command needs to execute first,
-	 * queue this mbox command to be processed later.
+	 * queue this login_mbox command to be processed later.
 	 */
-	mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
+	login_mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 	/*
-	 * mbox->ctx_ndlp = lpfc_nlp_get(ndlp) deferred until mailbox
+	 * login_mbox->ctx_ndlp = lpfc_nlp_get(ndlp) deferred until mailbox
 	 * command issued in lpfc_cmpl_els_acc().
 	 */
-	mbox->vport = vport;
+	login_mbox->vport = vport;
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
 	spin_unlock_irq(shost->host_lock);
@@ -504,16 +562,47 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
-			ndlp, mbox);
+			ndlp, login_mbox);
 		if (rc)
-			mempool_free(mbox, phba->mbox_mem_pool);
+			mempool_free(login_mbox, phba->mbox_mem_pool);
 		return 1;
 	}
-	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
+	if (defer_acc) {
+		/* So the order here should be:
+		 * Issue CONFIG_LINK mbox
+		 * CONFIG_LINK cmpl
+		 * Issue PLOGI ACC
+		 * PLOGI ACC cmpl
+		 * Issue REG_LOGIN mbox
+		 */
+
+		/* Save the REG_LOGIN mbox for and rcv IOCB copy later */
+		link_mbox->context3 = login_mbox;
+		login_mbox->context3 = save_iocb;
+
+		/* Start the ball rolling by issuing CONFIG_LINK here */
+		rc = lpfc_sli_issue_mbox(phba, link_mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED)
+			goto out;
+		return 1;
+	}
+
+	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, login_mbox);
 	if (rc)
-		mempool_free(mbox, phba->mbox_mem_pool);
+		mempool_free(login_mbox, phba->mbox_mem_pool);
 	return 1;
 out:
+	if (defer_acc)
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"4577 pt2pt discovery failure: %p %p %p\n",
+				save_iocb, link_mbox, login_mbox);
+	if (save_iocb)
+		lpfc_sli_release_iocbq(phba, save_iocb);
+	if (link_mbox)
+		mempool_free(link_mbox, phba->mbox_mem_pool);
+	if (login_mbox)
+		mempool_free(login_mbox, phba->mbox_mem_pool);
+
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_OUT_OF_RESOURCE;
 	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
-- 
2.13.7

