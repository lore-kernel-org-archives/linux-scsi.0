Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C33BC63697
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 04:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E1621D40
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 04:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hEfpldQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgKUEsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 23:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgKUEsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 23:48:09 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F83C0613CF
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2020 20:48:07 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id s18so11869048oih.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2020 20:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5tuY8DghcZBvhcmNZ1QBUM0wOMXflva60dOunjBFlM=;
        b=hEfpldQOix/WT+Po0WGDlXh6hu4sjFQXHsfMLWLFHo/G9OEdGqxAbZqPPQwYx1FZmx
         I3ZjlJl21PCfzGVogb4UhgsLsAv+2qoreIvLIFQxX1IxPcsgbSw4lEZRBDls6WjhL/g/
         6pOxExIBguvb0AgbjSaiHDd3Vyim10/H68RS/hcR9HzUMCA7kFYWxvKNEx/hZFcAQHwK
         RdaGb3b2uBMVORGB1hPZ5MK9Dg2L2QV93WRtLG6Z1/p3TPyLir36KHYX9KtGLZ3tKKe2
         8+qYQTzLc45hrb8ff0E7tqjlYjnb50Xmu2TKQWhTen/KFC8PYy72xNOI6Qrx0SH2+7Dm
         ABqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5tuY8DghcZBvhcmNZ1QBUM0wOMXflva60dOunjBFlM=;
        b=P2Bo7kKj1glspzh35tFWwkDydXvSJi676LWcOMohL6SA7Cnx7CgS5Hm3tbXpsHBaaU
         irl7act+bOXaQKFChRtQv4Aeow1mI83wVr8wkWc+KusHO5ax4hBVLJa/Wjp72DBsJ9zc
         7UXqcEoBtXvDgXw9mFFKcw/Vqo6ulzEonMANZsJVKpDiGjlESTV8PFwAXhvA8qhCldq7
         2VW70jjT9BrAYNixj/Cne7HVXruaxErV8ClKn1hpCB31uLWCCJfSFxH5kIU/h2fLnvoG
         hT8sP9RmwOLc9dsVsvA0vrcs9vozzgpmBNeLQGVZnOJYPdpfF8u+GwEjz+DurBIlWBJd
         PDXw==
X-Gm-Message-State: AOAM530lU8e82ryFrz1y8Wy8RHrKJ8Y6oh6bcccu6kRa3wMRGpyekg9n
        0qD3dbs69p05Dv658kXi0ZaQLQ==
X-Google-Smtp-Source: ABdhPJzPZMaQkLsy6sCEJGtV7eRVF/ZWjoSa7tpvgaAqhe01hBeXktkYzZLQurCVbDvJibTDsCRJIg==
X-Received: by 2002:a05:6808:301:: with SMTP id i1mr8853175oie.49.1605934086863;
        Fri, 20 Nov 2020 20:48:06 -0800 (PST)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id g3sm2875800oif.26.2020.11.20.20.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 20:48:06 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] scsi: ufs: Adjust logic in common ADAPT helper
Date:   Fri, 20 Nov 2020 20:48:10 -0800
Message-Id: <20201121044810.507288-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The introduction of ufshcd_dme_configure_adapt() refactored out
duplication from the Mediatek and Qualcomm drivers.

Both these implementations had the logic of:
    gear_tx == UFS_HS_G4 => PA_INITIAL_ADAPT
    gear_tx != UFS_HS_G4 => PA_NO_ADAPT

but now both implementations pass PA_INITIAL_ADAPT as "adapt_val" and if
gear_tx is not UFS_HS_G4 that is replaced with PA_INITIAL_ADAPT. In
other words, it's PA_INITIAL_ADAPT in both above cases.

The result is that e.g. Qualcomm SM8150 has no longer functional UFS, so
adjust the logic to match the previous implementation.

Fixes: fc85a74e28fe ("scsi: ufs: Refactor ADAPT configuration function")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52e077aa3efe..13281c74cb4f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3618,7 +3618,7 @@ int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
 	int ret;
 
 	if (agreed_gear != UFS_HS_G4)
-		adapt_val = PA_INITIAL_ADAPT;
+		adapt_val = PA_NO_ADAPT;
 
 	ret = ufshcd_dme_set(hba,
 			     UIC_ARG_MIB(PA_TXHSADAPTTYPE),
-- 
2.28.0

