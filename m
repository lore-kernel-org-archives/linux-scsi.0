Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FCDC43600
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C6361574
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhENT5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhENT5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:19 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2C9C06174A
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:07 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t21so2704plo.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jywKkCpdSWM6OvRQXvv2OpZ29qfAX6oxAMS7rVmnUKM=;
        b=WUH8iJ9WQbF1LS7jaOiCz0QOIHsIoa6F2uW7qlaZpodZqfqWJ/LSYhbbNgvE+Ez6wL
         62UBfe8qsDNK4KvFswT0M2RU//Afr4zAM3A+2/+ONbk4yAmHhalgz/OEyVjaauUa1xUy
         rEnQuC8ctsPfVfbLrgLEb1IGscair9bbUmkseuGm+EITUfLcxGJAwktgeocz/sKt2f1q
         yrwliHB7nEM8t7QAhdawXrjXphP4drMA/D17TR34wy98s86B7PofuSXM9NULzpvuuzv1
         CQqNM2yqIziw4/3uajdwy8MRlGFUdIJiMMLCNaDWYcUGF1QPjVvgVtCAleyrWl6f7Yas
         2Y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jywKkCpdSWM6OvRQXvv2OpZ29qfAX6oxAMS7rVmnUKM=;
        b=KweRPk/sEp+deukRtgD3j1cwRFpAYzF0rCUEt9evEzNAZiUMj0uPgUBl7Vc1U+5HFx
         EZkP/Y8wg6WM0w8eNV1GBXyfUDegoEHZJPJ3puC0nl2BUqVQvq7rl6ovm7XAcKeMvqdZ
         ZPa7u2pQQJPcWLR5nFfNhmEHAOozDOxNmzlBMH1ExGdcc0FmopHQzqvTMEcan05ve2Yt
         yFN9+9pPI8csiW+dqxz2aNA/9tM9a9CLY3TRCYf6LvzGf6sWZWDoMOk3Ll2D9kTw+nFJ
         1y5u+SmvS/nb4hijcNW5/MZa8VITsfAYaltBhPD+D/nYV7qYzZiWHcm8xXyfw7Sx0Ui7
         PRKQ==
X-Gm-Message-State: AOAM5334uGB1FqiACSX1/uj2cihAa0989JeO9Tqs79K/3sHDkQMRYgPg
        2KkN/utxz9wxKUhzQsEwntXIs1VlDk0=
X-Google-Smtp-Source: ABdhPJw71rXTN0lxjFB3rdPU023Q21Sf0IrUCIN2mok8ZdIakow5UPxFbSg0HwPZyKD5TGqM1L74dA==
X-Received: by 2002:a17:90a:ab13:: with SMTP id m19mr13244704pjq.124.1621022167351;
        Fri, 14 May 2021 12:56:07 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/11] lpfc: Add ndlp kref accounting for resume rpi path
Date:   Fri, 14 May 2021 12:55:52 -0700
Message-Id: <20210514195559.119853-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is crashing due to a bad pointer during driver load due in
an adisc acc receive routine. The driver is missing node get/put in the
mbx_resume_rpi paths.

Fix by adding the proper gets and puts into the resume_rpi path.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c |  4 ++++
 drivers/scsi/lpfc/lpfc_sli.c       | 23 ++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 3dac116c405b..50cf23447104 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -662,6 +662,10 @@ lpfc_mbx_cmpl_resume_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, elsiocb,
 			ndlp, NULL);
 	}
+
+	/* This nlp_put pairs with lpfc_sli4_resume_rpi */
+	lpfc_nlp_put(ndlp);
+
 	kfree(elsiocb);
 	mempool_free(mboxq, phba->mbox_mem_pool);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index aefe16c6fe5c..f68fe6f2d3db 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2679,6 +2679,12 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		}
 	}
 
+	/* This nlp_put pairs with lpfc_sli4_resume_rpi */
+	if (pmb->u.mb.mbxCommand == MBX_RESUME_RPI) {
+		ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+		lpfc_nlp_put(ndlp);
+	}
+
 	/* Check security permission status on INIT_LINK mailbox command */
 	if ((pmb->u.mb.mbxCommand == MBX_INIT_LINK) &&
 	    (pmb->u.mb.mbxStatus == MBXERR_SEC_NO_PERMISSION))
@@ -19037,14 +19043,28 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
 	if (!mboxq)
 		return -ENOMEM;
 
+	/* If cmpl assigned, then this nlp_get pairs with
+	 * lpfc_mbx_cmpl_resume_rpi.
+	 *
+	 * Else cmpl is NULL, then this nlp_get pairs with
+	 * lpfc_sli_def_mbox_cmpl.
+	 */
+	if (!lpfc_nlp_get(ndlp)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"2122 %s: Failed to get nlp ref\n",
+				__func__);
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return -EIO;
+	}
+
 	/* Post all rpi memory regions to the port. */
 	lpfc_resume_rpi(mboxq, ndlp);
 	if (cmpl) {
 		mboxq->mbox_cmpl = cmpl;
 		mboxq->ctx_buf = arg;
-		mboxq->ctx_ndlp = ndlp;
 	} else
 		mboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	mboxq->ctx_ndlp = ndlp;
 	mboxq->vport = ndlp->vport;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
@@ -19052,6 +19072,7 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
 				"2010 Resume RPI Mailbox failed "
 				"status %d, mbxStatus x%x\n", rc,
 				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+		lpfc_nlp_put(ndlp);
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		return -EIO;
 	}
-- 
2.26.2

