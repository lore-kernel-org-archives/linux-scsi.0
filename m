Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA02C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F223207D8
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="su2Qt1GV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETS7r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 14:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETS7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 14:59:47 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09521C061A0E;
        Wed, 20 May 2020 11:59:47 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r3so2359056wrn.11;
        Wed, 20 May 2020 11:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vNhGfRsHJxyNSVytpWaTAQlFuK0phfz6fCM2jfbdfio=;
        b=su2Qt1GVxQEbh7ppB2mE7orClcNCq4h92tdLzWwMzSWDjwZrlyuc159qkTxQ7WK2aB
         WCo6bW/B4ZUhogMEZMgJaKCO2gjHMnlJ5prYiD6FIuZREwJnLGqjsue6cwQ3CmrKoqbI
         ZlZ2gRfexacJgQT2TExOhvklrsbT17HtNaGH7Y3ttrwvvLUYkA6oDa+wrSkYPtqgmN9Z
         OVnUb9umUFpx58skc44gioUaNCgL7gHJYu56wjIpiQfkVWRikq+hLefL7baRqTokk8q6
         wlof4iJZ2j4v1dj34qS0VoNCMrlA/dskBDnx4Mq8raKB/LNbpJKy63aWChLfUSketq35
         f7vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNhGfRsHJxyNSVytpWaTAQlFuK0phfz6fCM2jfbdfio=;
        b=iWZfbtOIDAJDwg7XUWTaN5zM1B8j3cAOpkSip6NVuCvXeKAEt4RFsTjCLIfOoMGvwl
         Qwi8OqNJycO7DVpLB1QGN+fAGBL2um+LmL2bARMRyKw187QAm/k+KDO0niU1VipofWO6
         1yIo0VKcLq9qtU9RA6q59y/nXwlAGSjOYKOY+lupJijhaD3GNlDFYvCq0K+ZzVBGTv89
         gAhgars7wkbELO/8rymRC/bAwwjm/1Aqy8g+xETJgM3t81rdm1NjVHDXucW/c4KUNa3f
         SYluBoyrcchydQy1ZSJUqWCPw8/6kUblLf4rtcvp3SPLfqCHzTa+cpcHfGQgbkMnrSfD
         vvyA==
X-Gm-Message-State: AOAM532VGgpYvLt9njjVG1GBSb/h+Nd2CLjSlBtGC8BclNkHDbJ+5h0F
        nS/tz/IaspO4AZxekIfIAhk=
X-Google-Smtp-Source: ABdhPJzv+8R3/sgNT/uHYcXElV/E9t20Y8v5lB2YPPBHzXSV48cCvJz5fw6PaZN/r0PE4qfwtAASdA==
X-Received: by 2002:a5d:6803:: with SMTP id w3mr5288598wru.151.1590001185754;
        Wed, 20 May 2020 11:59:45 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id c19sm3896483wrb.89.2020.05.20.11.59.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:59:45 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        paul.ely@broadcom.com, hare@suse.de, jejb@linux.ibm.com,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@infradead.org,
        dan.carpenter@oracle.com, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 1/3] lpfc: Fix pointer checks and comments in LS receive refactoring
Date:   Wed, 20 May 2020 11:59:27 -0700
Message-Id: <20200520185929.48779-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200520185929.48779-1-jsmart2021@gmail.com>
References: <20200520185929.48779-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Additional testing encountered null pointers that weren't fully qualified
in lpfc_nvmet_xmt_ls_abort_cmp() and lpfc_nvmet_unsol_issue_abort().

The same error was detected and reported by static checker reporting:
  drivers/scsi/lpfc/lpfc_sli.c:2905 lpfc_nvme_unsol_ls_handler()
  error: we previously assumed 'phba->targetport' could be null
    (see line 2837)

Fix by making phba->nvmet_support and phba->targetport validity checks
in lpfc_nvmet_xmt_ls_abort_cmp() and lpfc_nvmet_unsol_issue_abort().

Fixes: 3a8070c567aaa (“lpfc: Refactor NVME LS receive handling”)
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paul Ely <paul.ely@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 1c6bbbba70b5..bccf9da302ee 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3207,8 +3207,10 @@ lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
 
-	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	atomic_inc(&tgtp->xmt_ls_abort_cmpl);
+	if (phba->nvmet_support) {
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		atomic_inc(&tgtp->xmt_ls_abort_cmpl);
+	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6083 Abort cmpl: ctx x%px WCQE:%08x %08x %08x %08x\n",
@@ -3244,7 +3246,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 			     struct lpfc_async_xchg_ctx *ctxp,
 			     uint32_t sid, uint16_t xri)
 {
-	struct lpfc_nvmet_tgtport *tgtp;
+	struct lpfc_nvmet_tgtport *tgtp = NULL;
 	struct lpfc_iocbq *abts_wqeq;
 	union lpfc_wqe128 *wqe_abts;
 	struct lpfc_nodelist *ndlp;
@@ -3253,13 +3255,15 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 			"6067 ABTS: sid %x xri x%x/x%x\n",
 			sid, xri, ctxp->wqeq->sli4_xritag);
 
-	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (phba->nvmet_support && phba->targetport)
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 
 	ndlp = lpfc_findnode_did(phba->pport, sid);
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
-		atomic_inc(&tgtp->xmt_abort_rsp_error);
+		if (tgtp)
+			atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 				"6134 Drop ABTS - wrong NDLP state x%x.\n",
 				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
@@ -3538,7 +3542,7 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 				struct lpfc_async_xchg_ctx *ctxp,
 				uint32_t sid, uint16_t xri)
 {
-	struct lpfc_nvmet_tgtport *tgtp;
+	struct lpfc_nvmet_tgtport *tgtp = NULL;
 	struct lpfc_iocbq *abts_wqeq;
 	unsigned long flags;
 	int rc;
@@ -3555,7 +3559,9 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 		ctxp->state = LPFC_NVME_STE_LS_ABORT;
 	}
 
-	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (phba->nvmet_support && phba->targetport)
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+
 	if (!ctxp->wqeq) {
 		/* Issue ABTS for this WQE based on iotag */
 		ctxp->wqeq = lpfc_sli_get_iocbq(phba);
@@ -3582,11 +3588,13 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	rc = lpfc_sli4_issue_wqe(phba, ctxp->hdwq, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (rc == WQE_SUCCESS) {
-		atomic_inc(&tgtp->xmt_abort_unsol);
+		if (tgtp)
+			atomic_inc(&tgtp->xmt_abort_unsol);
 		return 0;
 	}
 out:
-	atomic_inc(&tgtp->xmt_abort_rsp_error);
+	if (tgtp)
+		atomic_inc(&tgtp->xmt_abort_rsp_error);
 	abts_wqeq->context2 = NULL;
 	abts_wqeq->context3 = NULL;
 	lpfc_sli_release_iocbq(phba, abts_wqeq);
-- 
2.26.1

