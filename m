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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6410CC07E9B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530BF61CCE
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhGGSqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhGGSqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE2EC061760
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:07 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 17so3060808pfz.4
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q2+jTCdmK1CyvXp8vVBUgDilW7nXpcJW8iITvEhfUhU=;
        b=VgpWYxcz5OrHwQhU7bxnJMqT1SPPL4JonlRCYEh7zG1dAUE7vw7H5TNrNTLnN8kDIC
         x9cNk0X4JB0fsyXpas3W0OqHxZmzmJSQIZXASLO1ipZHwQ7vd8csOtb1kf5mFTj3RYJ7
         3n+iZHsZXzu4aayt72AmD/ThgrAOsFlxSQh7CcnCknL2B9snZHuP7kfV1yEzWMi6Ad/Y
         GfClNogEmLJe0cW7BLGU8J9BwFHFd+VG0hAtVKK3LD2Ci7ey/Z7tGjmtVWG8yIRhx3bp
         yBLseslVP/fWxaOeB2LYsv3MvoA86Z3vQ1hd9aTp/a2VCQ8jlsPnjxbngenUw3YwxDUf
         FWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q2+jTCdmK1CyvXp8vVBUgDilW7nXpcJW8iITvEhfUhU=;
        b=ZfJEgb+qvZrDEdzTgUz3vD+/jQ6pCZCLcXxBo3DVOWiNIOZDLuBlEPN6AxMzELJ6gP
         YKAm+d2u1OxqXuOu53HPE9uN+dvM4AluLR2ELc+qmJsx3rFaDw7PKetL2LaLmIMU63Sb
         W1Yq33ewkeNGKc3f0qv8WKoTfS7xhSG+Uhgu7Nu8bmo+vF2aqxHDPemPvMbT1dxCpApG
         avcatg6xZXhzyTot8Zg36rQLbt5Yj6zJceO/sOi7Yjaf60BiLbeTgfUpq9YSeeefQ7zo
         Y+uFeZjVS5kEo58prqXPHaIqZ2EmApTHnhPrfsPV+ftkw+3J+TU0DYxRjA/ZN1OA5ZEW
         3Fbw==
X-Gm-Message-State: AOAM531Dz1MxOMi11goyU2J2JHHBEgBOAscS7ww25B6KCm6tNmRlTrYE
        7Uyz1W8/9zqxe9VkUp+vpL9ZSXgSLCg=
X-Google-Smtp-Source: ABdhPJxhfVRPsXeFKx5X6CEn76BmksDrK32gztCF8i+NXvYHL2olMwZO1TT34guBKpA9NC4uOnhpmw==
X-Received: by 2002:aa7:921a:0:b029:2cf:b55b:9d52 with SMTP id 26-20020aa7921a0000b02902cfb55b9d52mr26441635pfo.35.1625683447419;
        Wed, 07 Jul 2021 11:44:07 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 18/20] lpfc: Skip issuing ADISC when node is in NPR state
Date:   Wed,  7 Jul 2021 11:43:49 -0700
Message-Id: <20210707184351.67872-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a node moves to NPR state due to a device recovery event, the
nlp_fc4_types in the node are cleared. An ADISC received for a node in
the NPR state triggers an ADISC. Without fc4 types being known, the
calls to register with the transport are no-op'd, thus no additional
references are placed on the node by transport re-registrations. A
subsequent RSCN could trigger another unregister request, which will
decrement the reference counts, leading to the ref count hitting zero
and the node being freed while futher discovery on the node is being
attempted by the RSCN event handling.

Fix by skipping the trigger of an ADISC when in NPR state. The normal
ADISC process will kick off in the regular discovery path after receiving
a response from name server.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 34 +++++++++++++++++-------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 46c1905f6f39..27263f02ab9f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -736,9 +736,13 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * is already in MAPPED or UNMAPPED state.  Catch this
 		 * condition and don't set the nlp_state again because
 		 * it causes an unnecessary transport unregister/register.
+		 *
+		 * Nodes marked for ADISC will move MAPPED or UNMAPPED state
+		 * after issuing ADISC
 		 */
 		if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET)) {
-			if (ndlp->nlp_state != NLP_STE_MAPPED_NODE)
+			if ((ndlp->nlp_state != NLP_STE_MAPPED_NODE) &&
+			    !(ndlp->nlp_flag & NLP_NPR_ADISC))
 				lpfc_nlp_set_state(vport, ndlp,
 						   NLP_STE_MAPPED_NODE);
 		}
@@ -2646,14 +2650,13 @@ lpfc_rcv_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
-		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			spin_unlock_irq(&ndlp->lock);
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
-			lpfc_issue_els_adisc(vport, ndlp, 0);
-		} else {
+		/*
+		 * ADISC nodes will be handled in regular discovery path after
+		 * receiving response from NS.
+		 *
+		 * For other nodes, Send PLOGI to trigger an implicit LOGO.
+		 */
+		if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
@@ -2686,12 +2689,13 @@ lpfc_rcv_padisc_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 */
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC)) {
-		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
-			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
-			lpfc_issue_els_adisc(vport, ndlp, 0);
-		} else {
+		/*
+		 * ADISC nodes will be handled in regular discovery path after
+		 * receiving response from NS.
+		 *
+		 * For other nodes, Send PLOGI to trigger an implicit LOGO.
+		 */
+		if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
-- 
2.26.2

