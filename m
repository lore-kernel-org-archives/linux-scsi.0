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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DD3C11F66
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B87961CCD
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhGGSql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhGGSqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:39 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F1AC06175F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y2so1564279plc.8
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1gxjOzlQ6knQQqEHTUDa6isoqPdVaG9gPW6rV1r+7Is=;
        b=jkydFR+ak9LSqHYSzKfxL6Vraodn9UaqGW6sKG6WTSrgFqGqXupBxLQEVjm5H1nwGd
         h42EKDe+e+d4A3WzS0Ctevof6V71PSdBvq2mxW/6AyVRGgn0Bt/JHH2BYrA9FOgtzJ/Q
         jkCRHzkSL4M56MBjquqLwZgTc/0+MmfSuxYEQoe6z0CtAcPweoa4xR8q5f4H8um9mFou
         c3HTrb0WOCg3RTDEUYhe2/o+iNYEZhiPJb7E7iTmDalv9Utj/ahZB/130lP0IJ3wkYNM
         xVvUUFT7BVU9DH/iaSw7zs+o/I3Xh0Bklg8LS2VYc4NomSCfJz/55Y/eTHx8EbvRHIaj
         5ZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gxjOzlQ6knQQqEHTUDa6isoqPdVaG9gPW6rV1r+7Is=;
        b=iL3wLTFYUHn2Luk9zklkwa8nlKvtvj02Yw5UwKsWO2qMtNaHcbYwdA+aovAV4jBDi2
         e3H+ri8eJlAy3bhIBFOOr5nrMBR1nKldBxN0gMuKTlwD6VKlUp03ZAAOjlREhTxHibVO
         aPNeLVT8CX77sCgjoKaoBv8hXheckknhene1mNMYjXpR7pZniDiFytabi+jIurcoh1RS
         NhgxJlNqnoWL9/8a+vQFaWCBkgpNSEkmaAfZQ1YXafniws1WGwJeUGVYdcS8masW/hGe
         Hhn1GGK++3L1RzKapDrYz/vVbs4CsdAApUio3cJbohJopo9zg1LDnK1R/cK+1UmZXfjU
         281Q==
X-Gm-Message-State: AOAM533IEYvBDLElVGdq0LnjtjhcpGIpTWFkDR3lw4HYdhyG5Cpj2/NS
        tq++uEd52fU0g0VyR/rGqEa2L5YMxdU=
X-Google-Smtp-Source: ABdhPJzYOnoCN1XEeUBeg9HPZcdKBvNDgsgWy6ar6cxWOLlh6FuCP3xx9c/j6JrGBGssVXYgIkbfrA==
X-Received: by 2002:a17:90b:384f:: with SMTP id nl15mr27841422pjb.88.1625683438661;
        Wed, 07 Jul 2021 11:43:58 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:58 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/20] lpfc: Discovery state machine fixes for LOGO handling
Date:   Wed,  7 Jul 2021 11:43:36 -0700
Message-Id: <20210707184351.67872-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- If a LOGO is received for a node that is in the NPR state, post a
  DEVICE_RM event to allow clean up of the logged out node.

- Clearing the NLP_NPR_2B_DISC flag upon receipt of a LOGO ACC may cause
  skipping of processing outstanding PLOGIs triggered by parallel RSCN
  events.  If an outstanding PLOGI is being retried and receipt of a
  LOGO ACC occurs, then allow the discovery state machine's PLOGI
  completion to clean up the node.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e481f5fe29d7..b0c443a0cf92 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4612,6 +4612,15 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
+
+		/* If PLOGI is being retried, PLOGI completion will cleanup the
+		 * node. The NLP_NPR_2B_DISC flag needs to be retained to make
+		 * progress on nodes discovered from last RSCN.
+		 */
+		if ((ndlp->nlp_flag & NLP_DELAY_TMO) &&
+		    (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
+			goto out;
+
 		/* NPort Recovery mode or node is just allocated */
 		if (!lpfc_nlp_not_used(ndlp)) {
 			/* A LOGO is completing and the node is in NPR state.
@@ -8948,6 +8957,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb, NLP_EVT_RCV_LOGO);
+		if (newnode)
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_PRLO:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
-- 
2.26.2

