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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E11DC433E6
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E124207A5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbhACARh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbhACARh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:17:37 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A13C0613D3
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:16:57 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id c132so5099639pga.3
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bF+LLoISezu6HwbNRhKJS34/2RQL1+vrdsMuFtElc6c=;
        b=iYb2XfCqP66WqqsG/Y7WSG5J6UarIjaNR1B83rEVidZaM6KSVohtCXPhPOzHuO7dFI
         FMDqTWn1p7axxOKMmjEWP/YKoTSfUNI1k4lODPTHDF+LYRBXV84KL0RtNQ/egWCHzlNx
         YwqKb/i8E/L4peslWCWlC+8EGVtnFqHIdOQGbhtcIIYVBh04CWUg2ncMamEgeZskWJd4
         6HNZ/3nKW+6CKOWCBipg3+SXurX/xmnlquiNJubeXlf9mo/kDy/aE2xiOePWyJuQ9cgO
         WoUWmZSRnmJlS/BKSPmRfQ0QFmUZzPTowslN0geUDqVbMjWs5vxH4cUqSwBDyTRpM//u
         aIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bF+LLoISezu6HwbNRhKJS34/2RQL1+vrdsMuFtElc6c=;
        b=My+tsDBbcaGq36Pr9Np1dQn5SeXR0XTmDiwwSKBBy1XSeqDP880LDSVReYQLNUS3/8
         9p0lv8eGmgyH/ysGGxlhJibQ8mkc9YguRk0wOt2S4Cj/UCH/Pf6kyauu4OkmCReyq8oO
         IuHCORb13mmP4fzvKgGbZBpIn5YywFZm7BXR2c1hsAS/eHny8xSVH4TsvcAwp5jwOynG
         H8dQqmOm2Lf2kC3UtM7nVu/A9JHedHjzGRRb2gMut0mLN2xS8UjUJO+X5eRgO/Tln7mn
         ySYjY3HO5CwaJZEo9yAuQsj5i/fiz1hK7pil3SpIR50evo3NJT53aidjeZFOrd6CYSOX
         GGyg==
X-Gm-Message-State: AOAM533hj9bt37kYV9ZsnNTLvUZGfXa4357NR39urV008XBfWaAaAttM
        dBBnmeIafVwP8++bQx1VyjJSRc49jBM=
X-Google-Smtp-Source: ABdhPJxkJvsBoWvjJhTRXMRgFBat+OI8JuH7CvQe6XrL5mrhDBNwJjZ5jpmf2qkRwuqLi4pv6SbJSw==
X-Received: by 2002:a62:543:0:b029:19e:5627:1c4d with SMTP id 64-20020a6205430000b029019e56271c4dmr39026000pff.31.1609633016568;
        Sat, 02 Jan 2021 16:16:56 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:16:56 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/15] lpfc: Refresh ndlp when a new PRLI is received in the PRLI issue state
Date:   Sat,  2 Jan 2021 16:16:27 -0800
Message-Id: <20210103001639.1995-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Testing with target ports coming and going, the driver eventually reached
a state where it no longer discovered the target. When the driver has
issued a PRLI and receives a PRLI from the target, it is not proper
updating the node's initiator/target role flags. Thus, when a subsequent
RSCN is received for a target loss, the driver mis-identifies the target
as an initiator and does not initiate lun scanning.

Fix by always refreshing the ndlp with the latest PRLI state information
whenever a PRLI is processed.  Also clear the ndlp flags when processing
a PLOGI so that there is no carry over through a re-login.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 1ac855640fc5..4961a8a55844 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -471,6 +471,15 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 */
 		if (!(ndlp->nlp_type & NLP_FABRIC) &&
 		    !(phba->nvmet_support)) {
+			/* Clear ndlp info, since follow up PRLI may have
+			 * updated ndlp information
+			 */
+			ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
+			ndlp->nlp_type &= ~(NLP_NVME_TARGET | NLP_NVME_INITIATOR);
+			ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+			ndlp->nlp_nvme_info &= ~NLP_NVME_NSLER;
+			ndlp->nlp_flag &= ~NLP_FIRSTBURST;
+
 			lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb,
 					 ndlp, NULL);
 			return 1;
@@ -499,6 +508,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 	ndlp->nlp_type &= ~(NLP_NVME_TARGET | NLP_NVME_INITIATOR);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+	ndlp->nlp_nvme_info &= ~NLP_NVME_NSLER;
 	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
 
 	login_mbox = NULL;
@@ -2107,6 +2117,7 @@ lpfc_rcv_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (!lpfc_rcv_prli_support_check(vport, ndlp, cmdiocb))
 		return ndlp->nlp_state;
+	lpfc_rcv_prli(vport, ndlp, cmdiocb);
 	lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
 	return ndlp->nlp_state;
 }
-- 
2.26.2

