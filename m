Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3A6C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F5A20784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbhADSDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbhADSDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:03:38 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0666C061795
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:02:58 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id v3so14924412plz.13
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bF+LLoISezu6HwbNRhKJS34/2RQL1+vrdsMuFtElc6c=;
        b=d9DvaeA+JBtI29f72W6RfBsK2aMjXsO6RKCfxjACPgQ8DGyy0hnILibpw9MZp67aX2
         qruqt6OKbuvxtvSzbsQShdKvd5oVWn5hQjV4a1jg52irGoEiVLl1oB6+Jc6Sc09co1LR
         nLOY6l9zZTSyFQk03zte0GYqVLeWHwHZj7otS2r/g6EThzWtoph4/D83GdX7SYlkekQM
         z7TQo9zQdT3Jnxohf/3iDnKaTr9l+L8cNx1G9lgJoTAafPRCLIbwwZVOpCMdYpOtAuVB
         g7NW37c/9FskIhlOGpRIY8kCNkaJF3joo/++Xiizy7T029VmZylybzw157XHkhnYF8mB
         hyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bF+LLoISezu6HwbNRhKJS34/2RQL1+vrdsMuFtElc6c=;
        b=fSxXuld6OsV69EAwdT2On2e2Z0L7b+T1jhPMS8VP6kWhtLLiPv87pH+TFE17bLN7e6
         Zxs21hxM0/Nhw/njgku5xmtKR35hyewFJng1KhMxr0aic4FAf5gekHoeatRRbGWhJaF1
         vDdxp0XGIazCvcgPKraq9vmwLw1DqMaiWED6gI7XkqxYJAQEaaas0ENKTJlF5yIa2pJn
         GWyD9zkFTNbKq7WclD+4LJwVq+7NgOAIXNjtAQGN7PvC+c8nYFmhv/eSuCIJQOV3+53L
         1QNKeweKZK3OzLMpe63i3DmHoVHrqiWQis0B/VUusmjGC7n0LczxuL1wRngNIalk8r8V
         Sj5g==
X-Gm-Message-State: AOAM532TVS57DtWs1qSVcE/wUS5x5rMfJdmSg4ktwVceDwXiIofDGwTe
        MsGBtKcSkWiVE6M/VGx1PJ64mAfAU20=
X-Google-Smtp-Source: ABdhPJzakTNB+p4fXV8W5soxKGKSImKyLdyTT6CKi73OXJeUWHLt4Qd9WW3XZsxI0ebuvJf9vX9OAQ==
X-Received: by 2002:a17:902:ec03:b029:dc:f27:dd4a with SMTP id l3-20020a170902ec03b02900dc0f27dd4amr73652811pld.9.1609783378115;
        Mon, 04 Jan 2021 10:02:58 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:02:57 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 03/15] lpfc: Refresh ndlp when a new PRLI is received in the PRLI issue state
Date:   Mon,  4 Jan 2021 10:02:28 -0800
Message-Id: <20210104180240.46824-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
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

