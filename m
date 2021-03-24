Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7773C433F8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE4161A1D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhCXT3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbhCXT3L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:29:11 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642AAC061763;
        Wed, 24 Mar 2021 12:29:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u5so34798464ejn.8;
        Wed, 24 Mar 2021 12:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fZSR7K+/P2y30RZS/IlJubWHc1G48R3feXYi2cCY8tM=;
        b=jpxkJZquCiIBmYihY395TUfUubCDxx/3tsmyp2y+uqGhhOArc4cbps6SOH6mt5yBco
         jtt83PMl90rRsvuHq7ieU683BlXA6/k8T9Jdz3uVqwe9ECpkmefXIaz1SIYLLaB1n4zY
         PKGeodHVVkEzzgUvhEGKdwGwraFFIJGL+rZUD5jH2ohZ43/cpsfKa5Y6t7o+1FT0a7e5
         ZCZuQw9lBzSEfxzWDhtLG+DyWbkYxdNk7IgKFOYsN+DPzQmagEOrS+5Bb3sw6fT4e+Ym
         LO08VdWWFk1cpBaQkCjYZEGFLrcGe4cbA92C+sK2MNiK/KrDYeeURmQ5NigywD4V+msG
         5ZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fZSR7K+/P2y30RZS/IlJubWHc1G48R3feXYi2cCY8tM=;
        b=Th/ONPMqTDcyyb+EfrqE0rDiKV85zeGunv8cavL8Mt7rDQUIlw+E+V4c1ctRUwvNNY
         TtIAIwXxIEreCMenSLNnJv2QLJQh3tcPWz0ggzyghnARR2wqhfJnZ0DnsVQDH7gsNNFK
         FRYMmVnJX6ue+woGnAP+GpdkzWIQg50iEWs6TfP0hHZOLj7G4e1+f74RApAnQLAS3l5v
         X6X/e05vVJZoZdPxqXJaKdKm/+FHfR+uixTWnompayZACYy7iwa23jV70wyqCIGh5h3B
         oKOUeZVxvcOjvtchJwnYoPKwbf0Sr7YEObDGgIfHlSQ1Eyy5xbXehUClcb9imBeZQHR0
         a8tg==
X-Gm-Message-State: AOAM533W6Qq+p8682SVJkHkNjQTBltaPa1zTR3skQUynwzV5uM/2Aq0q
        DONmDsaVtRJngCuVcfwuTmCV2xnYG5Q=
X-Google-Smtp-Source: ABdhPJwYUUKW+vZZbEmS5idn0QxU6AXm/8AtHem+NsRhscf+SFAYq+bEdO3QxaRSGZjfCRx4F5ZJMg==
X-Received: by 2002:a17:907:2d89:: with SMTP id gt9mr5507056ejc.226.1616614150143;
        Wed, 24 Mar 2021 12:29:10 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id v8sm1593958edq.76.2021.03.24.12.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:29:09 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/6] scsi: target: tcmu: Remove function tcmu_get_block_page
Date:   Wed, 24 Mar 2021 20:28:40 +0100
Message-Id: <20210324192842.30446-5-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324192842.30446-1-bostroesser@gmail.com>
References: <20210324192842.30446-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After previous patch there is only one caller of
tcmu_get_block_page left. Since it is a one-liner,
we better remove the function.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3596346f362e..9b2bff450510 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -561,12 +561,6 @@ static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
 	return iov_cnt;
 }
 
-static inline struct page *
-tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dpi)
-{
-	return xa_load(&udev->data_pages, dpi);
-}
-
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
 	kfree(tcmu_cmd->dbi);
@@ -1786,7 +1780,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	struct page *page;
 
 	mutex_lock(&udev->cmdr_lock);
-	page = tcmu_get_block_page(udev, dpi);
+	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
-- 
2.12.3

