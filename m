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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD69C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD2E61CD2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhGGSqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhGGSqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:44 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BD3C061760
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:04 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b12so3039245pfv.6
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5383wP3xm3p3hPyRePRbf0QNR7YyzZs+d9KNbeJOtIU=;
        b=OaDGylTvyTjs0ZEPz0Yq4YH6lLNvHE61Th7cwUg3ejhvCH91juQwymU//E4GI+pV0E
         gi9Pe36HHAWNcbEpW4RHn4hrJjsP2XnL4zSJocUcNMEUKWVEOfYx4Ij4WKAOplPP2XCJ
         TqmkmCW57X0swtaym9vcvo7BKX4jU4wI7OwZhhpDVudWhjyAihYRubPiYBJ6ElS6o594
         PQqcg3LHfs4L3j8Pg4WpDa87bEubmjlWHcXANJmwCLcGIwNW1oreFZN+yiUoOi7aHM+C
         +Ms+FiunQeGkFPemh37cBVj/pO5BWaozmuv9oGKJq50f7JHjY4ih781N+gT+Ut4r6B7c
         glpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5383wP3xm3p3hPyRePRbf0QNR7YyzZs+d9KNbeJOtIU=;
        b=KE9OWyvFw9RXOCJoxDL6X1s6jseBIxjw0EhjlfFdqsfYFPkaKsxqUSKUuCTOK7Elx9
         v7TW8CH3J6y75Bmt6HLlqhpObBcAFiwiSS8Z+fTSB1gQETwHFiynVyNChTG72MEVf9Br
         ZHw9VLgijwlxt23lOCH/4aF0G0PmMmB6WeNOCy+Y7yNoFNQ7YEhPEX949rab76nW2SN1
         R5dr2DHuykPsAfuyby+2NZiLUnXYPCOTda5GXjeJFwmBaYT+PIIJ5GAYS/iC8KEWMgjU
         Kqgel31LNOtQPo8I9WpykGQ3e91t6L6ce1wzwYfGz9nuaN/ESlLw3CBpR3nCziyS8I9W
         /SUw==
X-Gm-Message-State: AOAM530AIGj/7/9euidnL7J8tmMAF9bl5m1blf1s/eZrGDEqTC621LIf
        7f2lYyrBOZSJO0wc8z3/uhqSBFY/XvM=
X-Google-Smtp-Source: ABdhPJw47N/bnoDQYyAgDNmE8cgRFrRAxXmD/CwsfMg9wdoMoPyKQGw5KmTxv7Jm2c6i0oi0cL2R2g==
X-Received: by 2002:a05:6a00:1903:b029:31d:f720:133f with SMTP id y3-20020a056a001903b029031df720133fmr18867178pfi.46.1625683443970;
        Wed, 07 Jul 2021 11:44:03 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:03 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 13/20] lpfc: Use PBDE feature enabled bit to determine PBDE support
Date:   Wed,  7 Jul 2021 11:43:44 -0700
Message-Id: <20210707184351.67872-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SLI4 interface changed in the manner to indicate PBDE support.
Rework the driver to check for PBDE support via the PBDE feature bit
in COMMON_GET_SLI4_PARAMETERS.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 11 +++++++----
 drivers/scsi/lpfc/lpfc_init.c |  7 ++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 7d4d179fb534..4d9233de9ead 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3334,17 +3334,20 @@ struct lpfc_sli4_parameters {
 #define cfg_nosr_SHIFT				9
 #define cfg_nosr_MASK				0x00000001
 #define cfg_nosr_WORD				word19
-
 #define cfg_bv1s_SHIFT                          10
 #define cfg_bv1s_MASK                           0x00000001
 #define cfg_bv1s_WORD                           word19
-#define cfg_pvl_SHIFT				13
-#define cfg_pvl_MASK				0x00000001
-#define cfg_pvl_WORD				word19
 
 #define cfg_nsler_SHIFT                         12
 #define cfg_nsler_MASK                          0x00000001
 #define cfg_nsler_WORD                          word19
+#define cfg_pvl_SHIFT				13
+#define cfg_pvl_MASK				0x00000001
+#define cfg_pvl_WORD				word19
+
+#define cfg_pbde_SHIFT				20
+#define cfg_pbde_MASK				0x00000001
+#define cfg_pbde_WORD				word19
 
 	uint32_t word20;
 #define cfg_max_tow_xri_SHIFT			0
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index bd3742035e76..b06b2f847df2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12268,9 +12268,10 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
 		phba->cfg_sg_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
 
-	/* Only embed PBDE for if_type 6, PBDE support requires xib be set */
-	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
-	    LPFC_SLI_INTF_IF_TYPE_6) || (!bf_get(cfg_xib, mbx_sli4_parameters)))
+	/* Enable embedded Payload BDE if support is indicated */
+	if (bf_get(cfg_pbde, mbx_sli4_parameters))
+		phba->cfg_enable_pbde = 1;
+	else
 		phba->cfg_enable_pbde = 0;
 
 	/*
-- 
2.26.2

