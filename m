Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E115C15506
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE9E64EEC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355613AbhCDAcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358743AbhCCOsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:35 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBA0C0613A7
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:59 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id u187so5390566wmg.4
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vp3LPfDWxhdq4CveN15ZDZ5FBUzcaMZimN4dQHLGxEA=;
        b=U0t3uAQ1g04sV8BV3udjZX3FLFf7m9474Vpho7imY1X2KE7eofeW6q49vDhw/hQz+Y
         QClDNQdYSGdtzEjKxmTwHqipmi56/yu0l1y6dq72qV4dBoRXIx0DTSpTMkSLOSbaW/gg
         2mlTzK/hAtuoXindUm6/q579w/4/xdH6VWao6xlLmQHyTuejaumQfYdNtlTx3Pv64CsO
         +jcf71+zePwLC00WaR+8AMQXM6PKHGkWNbs2mAQeJJSrrAvZTCXL6z1+DWwnwAXQx0+/
         Rp28RPvUhO0iKKGfjR7ufQz64mM69E2bMD8kWgUfwfGDva7dYsgwxXdASdbWjSGt5Lqa
         ICaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vp3LPfDWxhdq4CveN15ZDZ5FBUzcaMZimN4dQHLGxEA=;
        b=GjFx3Fx6aYbKobjOeL5QZ0NFz6Gpf/6vw71Ph2+Z5plAzSHCxl2J4rtKd6hYrOYCGf
         QM517c5qrUy8tdf9jFPM3axKN/XIQGh/Z5/Q7kB43X4EownbZXUjCCtqqio8NyBfbVJU
         1/eA1tjClayVJbF5r8nBvJRv94HcXk1FxQv3/rbDbehBknFwv93lIy+W9zTGcRaQmsgJ
         NpJBW4SWsbHHjKeAxWYeC8lJ+Np31vgSJCVvdZ0hcJ2/tdthKEkKgVNsbHYb1QLM/rgD
         AoI71glk+Dq0pNG4LIL521majVcQ1lfn4IJnst/K+pt3notzTOLgvLXFKzXiUNXnx1Ne
         mUvw==
X-Gm-Message-State: AOAM5311rUt/i1G6PyzDEfzIW/Buv2BIavMZVewid96n/b5OIbDB010m
        NDIl+CGfDAR4mgEa9ph2V21C6g==
X-Google-Smtp-Source: ABdhPJzy1ig3CiMz5pH8IM8oo6QRsHmv3YgS8sVxcDf9UGyBapGjgLkMoSQUT8Fxn/34Lvdo/cjCxg==
X-Received: by 2002:a1c:e184:: with SMTP id y126mr9487057wmg.163.1614782818007;
        Wed, 03 Mar 2021 06:46:58 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:55 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Prakash Gollapudi <bprakash@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 10/30] scsi: bnx2fc: bnx2fc_hwi: Fix typo in bnx2fc_indicate_kcqe()
Date:   Wed,  3 Mar 2021 14:46:11 +0000
Message-Id: <20210303144631.3175331-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2fc/bnx2fc_hwi.c:1344: warning: expecting prototype for bnx2fc_indicae_kcqe(). Prototype was for bnx2fc_indicate_kcqe() instead

Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index b37b0a9ec12de..0103f811cc252 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1331,7 +1331,7 @@ static void bnx2fc_init_failure(struct bnx2fc_hba *hba, u32 err_code)
 }
 
 /**
- * bnx2fc_indicae_kcqe - process KCQE
+ * bnx2fc_indicate_kcqe() - process KCQE
  *
  * @context:	adapter structure pointer
  * @kcq:	kcqe pointer
-- 
2.27.0

