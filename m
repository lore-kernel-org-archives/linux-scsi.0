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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D080C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A46061A27
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhCXT67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbhCXT6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:58:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9D5C061763;
        Wed, 24 Mar 2021 12:58:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e7so28974728edu.10;
        Wed, 24 Mar 2021 12:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fZSR7K+/P2y30RZS/IlJubWHc1G48R3feXYi2cCY8tM=;
        b=ITidWFPMxD40MgvbjfDHb5i+Qkkt2nvaKKsVD5x8XhXz4ohksRaH2sun00xGxND8/v
         nItwDDbs1r3QnDVkyIS5AKQ+lDMenxamIsQnBGetAwrRHI4pFQAXat7acYVuD046B7JV
         gbfJkC7dQCYTFlJoihCD8Ld1p94rBUamEymHh7hoBqH2iebv3WrJkz7vtEF8oFJI7lkN
         Ghvv1Tuvhm2/c1RIBEL0+IOXJtRL9/IhxCX04c27db72j7R8SjLtK5z/dl6W2LRH68rt
         zzNDUb+ca5cQC6QhXBtHRq90M8nAnzaPKQjfhjGd72t92lrdOokOH0VaGvgBaKMvr4hN
         eknQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fZSR7K+/P2y30RZS/IlJubWHc1G48R3feXYi2cCY8tM=;
        b=bi4Ez3RXBpsPsiRsdb0VB2xO1oSs1kwTID+gG60y/mv6wja98K4Hz/TZVI8hCESMdK
         +O/ThMlNZmfgon7XOQEoRftO0SjhOMpm6HBMworZDZL/ELycaeHHa1pWY7yirSD205iz
         7PLx92W9ITvn/YftDNeMoYCefhTmwHODtZsdR1QeRF8vdsBLbDaa9wNfJw8iRTmNmJMH
         JlqHax5KNy+LaB9smYE391KmNDMItvtVxx3qdVxXLDxltnksvs0YR2NMYlCnKzn8U4uB
         bi7p+z7YRiCzwFtBhJNI1kFe2Rx6nnD53Xp0D8CkMBlVjS0/2X5FUHXsL23a4Xf14rox
         oHpA==
X-Gm-Message-State: AOAM533QMb2kx69AiTSi5uJgql4fOiznJ5W8NJb8NQev87t+PJ8j7+qO
        st1Ez/sh8aVwK3iFjNgt7LZoLPsDkGo=
X-Google-Smtp-Source: ABdhPJysg+oRYpXQXQpzJ76ukfpckwjpKvh5Dt4BymbLbID4bhymndVUsXzOy69mhdexSugC4Y9y9w==
X-Received: by 2002:a05:6402:350f:: with SMTP id b15mr5317615edd.6.1616615924880;
        Wed, 24 Mar 2021 12:58:44 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id u24sm1630470edt.85.2021.03.24.12.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:58:44 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 4/6] scsi: target: tcmu: Remove function tcmu_get_block_page
Date:   Wed, 24 Mar 2021 20:57:56 +0100
Message-Id: <20210324195758.2021-5-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324195758.2021-1-bostroesser@gmail.com>
References: <20210324195758.2021-1-bostroesser@gmail.com>
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

