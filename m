Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE23FC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9814364F41
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhCQJLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhCQJLb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:31 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74595C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:31 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so827784wmf.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QUcUbYzVq4WAbYCHC6A4U/IWUbOjJbgRMpmZlOoFPaU=;
        b=qSOrLft8oGs6hVSsCNmwZZTMED/qFbTW9EEw6QlFA09kUTI6BcJSa3donspZaTB2pI
         amz9oxFTpQ422j9x6M6PFn1eJDxKD29Y6EJd9jOuVD3T9vhuu9nn28QJJtJQK/5AZ6AH
         OG4LR0YoM4fpF6IzoyCmXsBHLOhf1RQgaeTD6cibhWx+XomtwVuDJ9S/ZNwRK1b93eq9
         m7QyE7x+orCiUZQXGRX/xULU9vT0jCmB2iOM3oSVWA3AtaWwpSyGt5E1t2eD30eM9h0w
         0UY1CVO8Rwf5QZn6LjG9C4ySTXoasW47tR4zp2iHUTQjMzFWzXMffLZ+c14xmz9YHTac
         UjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QUcUbYzVq4WAbYCHC6A4U/IWUbOjJbgRMpmZlOoFPaU=;
        b=XLLpGrvkFXWgPtb2qfYS/aM5fKLTNgbpXzlZMwUYsHjlYaZiK/kPnN82wSmXlxY49Z
         ZrO0ZtbzPUHsqufpeNP7UtoLB2/lLBDU/Laj6nNg1WYkEiPNxwK43CtsiKtVVdzjGYUK
         /AB76p8mPtGp694V2t8LPCpQ04h5LRUovRjjE3XePo/7Qa1SuyXT6THS3VeltIrMpJ23
         upXmAJQkDmH7lJ99vgDfUSLxgd7dWFs7FhBl5Hiccz2N+KJSc4vRpHgU8kgrkr/LNhkd
         9jx27QOs9QFt8s1P5xD4H3ChlxU2C2+4zAEZyk6n7vOnp2XKRATBFMk4t3oCUVU0srkA
         9aOw==
X-Gm-Message-State: AOAM533Mx9tibIRTvx3MYMBSi5nnxb0U0hRepoo52nW5jnskvm1rFtmr
        w5OCueGJr6DV7aHHAoOrtqPPlg==
X-Google-Smtp-Source: ABdhPJxTLCXw7Of2OV/8m9UKxF4p99Sy2ikd/ONYtccHhh1kz7XgJ8hxg7z/qgCghEcNy2cIEKGu4w==
X-Received: by 2002:a1c:3954:: with SMTP id g81mr2766758wma.170.1615972290211;
        Wed, 17 Mar 2021 02:11:30 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gotom@debian.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/8] scsi: nsp32: Supply __printf(x, y) formatting for nsp32_message()
Date:   Wed, 17 Mar 2021 09:11:19 +0000
Message-Id: <20210317091125.2910058-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/nsp32.c: In function ‘nsp32_message’:
 drivers/scsi/nsp32.c:318:2: warning: function ‘nsp32_message’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]

Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: gotom@debian.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/nsp32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index e44b1a0f67099..d5aa96f05bce4 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -309,6 +309,7 @@ static struct scsi_host_template nsp32_template = {
 
 #define NSP32_DEBUG_BUF_LEN		100
 
+__printf(4, 5)
 static void nsp32_message(const char *func, int line, char *type, char *fmt, ...)
 {
 	va_list args;
-- 
2.27.0

