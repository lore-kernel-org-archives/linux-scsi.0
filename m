Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CA1C07E9B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6581A61CC8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhGGSqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbhGGSqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1805C061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso2216729pjp.5
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HpTK0Ngh8TzknRVT34FEqY8VYWrDYSmyhcMUIVCJs4k=;
        b=EcSXSy4e6HndTKpb3MdY4Zwsxc0Wky50OtQViKdxxx6Kps6lznl06xkKjINKtikr8t
         R5+JnIZwdl5XVMMehsGLmXEO1kGJCzjL3Es5iC2L7JAuKi+hejiRbDtNMXiUAvcFot4V
         pKdwfYsoOF6yAvd4QVtwaz+QfvxMw7FhL2Ii8irfd6aynwqdJ3UZmSz28Hxm99TOWbxP
         ztIMm9zpWvTkZOCBedbTwRcBJG0GSfq/hNqrVQMf7vE3toJk+4l+JflSrGphReKZ1XiE
         DAzDpflk3NTmU+i3PIJeKuR9x9VUOq+d5+sERbhRzoVP1LQIpQT2DttzrsVVhbEGQ1D5
         1V5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HpTK0Ngh8TzknRVT34FEqY8VYWrDYSmyhcMUIVCJs4k=;
        b=eJ8HaVn8YUfVPzz1Cmqfy3vRQP6Sne+zqOJwYHq7Oxzh4LKwtoYkCGEmjMvENcQpB/
         aRLg1geuD0ejdMQi+CHs5PjCtNZ92DgxgE7zZxYW9CV6+cnIT8sFCkS6cWS27r2tboRg
         eJJ0JsMLNm8+Qxbt+MjDdbwOi5PXMDzvFfUR3Bqlh8eksA7yPJ2d6JJAr5bLEFNaWVIy
         VBuHmGq0iSeo+6itivSOFyxOVPwscGCYtn8AB6kTC15Iad6RcK8EG8lmiLQYSxOMZQsN
         ujmqIPNpfTOMGYTsefRzEsaP4fhZZlMGQme9oWHjv5Vv62tN46Bna6fJWc/BbobozsSR
         LW3A==
X-Gm-Message-State: AOAM5328bxWsdwEPOOyXvYEamlIi3COx8YBL/qrhZRKY30YV3NiSbpBP
        WVREwI2ljk8PF04T5SB0ovhyRgyUU+k=
X-Google-Smtp-Source: ABdhPJxQMChuMIkpzAZghviaxtq8zPpzPJPgcX/uXLkdqRZ5GpX+ZP1TrKUakUVpCxN7VHJ2z+hBZA==
X-Received: by 2002:a17:902:dad0:b029:129:c3fa:715 with SMTP id q16-20020a170902dad0b0290129c3fa0715mr4099845plx.45.1625683439348;
        Wed, 07 Jul 2021 11:43:59 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/20] lpfc: Fix target reset handler from falsely returning FAILURE
Date:   Wed,  7 Jul 2021 11:43:37 -0700
Message-Id: <20210707184351.67872-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Previous logic accidentally overrides the status variable to
FAILURE when target reset status is SUCCESS.

Refactor the non-SUCCESS logic of lpfc_vmid_vport_cleanup(), which
resolves the false override.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 68 +++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1b248c237be1..10002a13c5c6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6273,6 +6273,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
+	u32 dev_loss_tmo = vport->cfg_devloss_tmo;
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
@@ -6314,39 +6315,44 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 
 	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 					FCP_TARGET_RESET);
-	if (status != SUCCESS)
-		logit =  LOG_TRACE_EVENT;
-	spin_lock_irqsave(&pnode->lock, flags);
-	if (status != SUCCESS &&
-	    (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)) &&
-	     !pnode->logo_waitq) {
-		pnode->logo_waitq = &waitq;
-		pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-		pnode->nlp_flag |= NLP_ISSUE_LOGO;
-		pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
-		spin_unlock_irqrestore(&pnode->lock, flags);
-		lpfc_unreg_rpi(vport, pnode);
-		wait_event_timeout(waitq,
-				   (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)),
-				    msecs_to_jiffies(vport->cfg_devloss_tmo *
-				    1000));
-
-		if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				"0725 SCSI layer TGTRST failed & LOGO TMO "
-				" (%d, %llu) return x%x\n", tgt_id,
-				 lun_id, status);
-			spin_lock_irqsave(&pnode->lock, flags);
-			pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+	if (status != SUCCESS) {
+		logit = LOG_TRACE_EVENT;
+
+		/* Issue LOGO, if no LOGO is outstanding */
+		spin_lock_irqsave(&pnode->lock, flags);
+		if (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO) &&
+		    !pnode->logo_waitq) {
+			pnode->logo_waitq = &waitq;
+			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+			pnode->nlp_flag |= NLP_ISSUE_LOGO;
+			pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
+			spin_unlock_irqrestore(&pnode->lock, flags);
+			lpfc_unreg_rpi(vport, pnode);
+			wait_event_timeout(waitq,
+					   (!(pnode->upcall_flags &
+					      NLP_WAIT_FOR_LOGO)),
+					   msecs_to_jiffies(dev_loss_tmo *
+							    1000));
+
+			if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
+				lpfc_printf_vlog(vport, KERN_ERR, logit,
+						 "0725 SCSI layer TGTRST "
+						 "failed & LOGO TMO (%d, %llu) "
+						 "return x%x\n",
+						 tgt_id, lun_id, status);
+				spin_lock_irqsave(&pnode->lock, flags);
+				pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+			} else {
+				spin_lock_irqsave(&pnode->lock, flags);
+			}
+			pnode->logo_waitq = NULL;
+			spin_unlock_irqrestore(&pnode->lock, flags);
+			status = SUCCESS;
+
 		} else {
-			spin_lock_irqsave(&pnode->lock, flags);
+			spin_unlock_irqrestore(&pnode->lock, flags);
+			status = FAILED;
 		}
-		pnode->logo_waitq = NULL;
-		spin_unlock_irqrestore(&pnode->lock, flags);
-		status = SUCCESS;
-	} else {
-		status = FAILED;
-		spin_unlock_irqrestore(&pnode->lock, flags);
 	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, logit,
-- 
2.26.2

