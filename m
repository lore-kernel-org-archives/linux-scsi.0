Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395D5C433EB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC75206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n5oWnYYL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgGWMZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgGWMZW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F9AC0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o8so4783587wmh.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqthC3CkjpgCokdg5o2ILnbULpGQcoT03/Lw3SH2/KA=;
        b=n5oWnYYLwx2Uu3i0alq76U1+jMa5X1KgGKPO/TNSL8K0wCitWVNvpCZmEgRyCTF22e
         h+QUo9VHUERd2wQnBkOJ3k6VTgAw5A2dFbwJABl/FuRVTBPxCjlNnAA+f2o+1E+fJsJT
         NC+b82QbEKW/d8kVIilYYP2tOz6oE4BZzcrxrb9ar0oreWLlsrB6EFmwCO/Fm7fQanQg
         hTwY6y7bKzzKEWT2XgLSxGCHtR0VfB0Vbm4iESRb8sygG+CI2sQDIM7oA3GzMhJL6Q5l
         fzIoPpLdiKP1oXZL87RCDcfxpDeeWn0legNEtDCSSEItKTHt+FzTlh5iOYSlrv9YJuTC
         K1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqthC3CkjpgCokdg5o2ILnbULpGQcoT03/Lw3SH2/KA=;
        b=ZecaVGHvZ5K/PkAnLQG+ZS220y8gPKdAtpU9PJO8mI+RfH8O33/fD3Eg/prL/xGSSD
         KCR4MO8BAKfcdpoGnf/yPzwgQBie7/kB1zrl+EVWO8Vcf1lCaxL7YGTJLebog+dwizeI
         hFI5ilf8yQSnQFCkpQc6rrynBxEzIK971s5od45qg0Wa58qJrV61WTqM8Egm7CD43aAr
         dnZJi3nPyefst+hZYflLUYkL2iTTTF9a6seIN1G9b+Tnzi+rium8guo+tRFZshx889hC
         R/2yg7cQlL673pnGL5M76K3kFEG5A3AsT5qpUkhnXhhTo5CQyk5m8yQnWrsaUAEff7W0
         xH4w==
X-Gm-Message-State: AOAM53354hYV6kfSPxezyygwe7GFEnSvnquqzzo0kWTYKHbyfoi0oHq2
        sq3qoB6tQ1xM2zIfDHfsYu6EA2BIXqs=
X-Google-Smtp-Source: ABdhPJzZGFpzQjekGSiOCnQqa+8ff+FTdUMkmof33vvNKFnGPSmFf+6Fzjt+89if1+VbwoFioQwP+g==
X-Received: by 2002:a1c:f407:: with SMTP id z7mr3953367wma.8.1595507121244;
        Thu, 23 Jul 2020 05:25:21 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/40] scsi: mvsas: mv_init: Place 'core_nr' inside correct clause
Date:   Thu, 23 Jul 2020 13:24:32 +0100
Message-Id: <20200723122446.1329773-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'core_nr' should be inside the 'ifndef' "if *not* defined", as it is
utilised inside the 'else' of the following 'ifdef' "if *is* defined"
clause.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mvsas/mv_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 3b450319cc11e..978f5283c8835 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -182,7 +182,6 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 	struct sas_ha_struct *sha = opaque;
 #ifndef CONFIG_SCSI_MVSAS_TASKLET
 	u32 i;
-#else
 	u32 core_nr;
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
-- 
2.25.1

