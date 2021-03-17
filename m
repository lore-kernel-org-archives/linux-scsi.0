Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A7FC432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFD664F3C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhCQI56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhCQI5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:21 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02892C061762
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:13 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo804630wmq.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QUcUbYzVq4WAbYCHC6A4U/IWUbOjJbgRMpmZlOoFPaU=;
        b=D0YkNBCYTamiXrgPRgqVt+oGtaNIahNih1zVi3JKpExNJovdhGEzRski9jHwxTVYsS
         oZsaTDTrC+reO7lrS5Vk7P4YhRpbgdpgxDPYZ311JVftUG04ixF8ZvUW9GHagMdn9Ypa
         1paDvFYIvxO/+sD5a076CFTNSSaxqghBAR4e5zPEIehRkZvm6loUtHO4SW4AIbczZzad
         5ozQpPUQD0HjK3zxPE+Y4on2H2VdeJ38f/opy4xsRZzgAvIoa836WgjLO6FmhIWBsIFq
         JFKSAxClEw4wclve1ds0Ni6hI5VcExEUynhWwogfo+xLSzBJpu66LmnGz1NS4GOd3Flj
         aFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QUcUbYzVq4WAbYCHC6A4U/IWUbOjJbgRMpmZlOoFPaU=;
        b=bAT+VNtVZ//ZhBXd08NvbNlmS/zQmbcZ+JmgZZrVo7WJiybP8tUJWUF68p67KOUitj
         5aqWZ91T6ndV4WWT3GVq4Hbk/XundgWOM8XRJSj9nNr9IN83JoQDthsoIAerhOVRZm7u
         gQYQvXvY5E23qk459izMPqtJOIY01H3vBqoIQWejmP5RskV19Ylnmdi5ZkiDh3awrrkq
         HF+jKDz1yNU5nnVW/rH6ZxqslYnsCo2EKMnaT/bxM0folxukLUeofFuJhuKzyfjN/gne
         2G6EV1CAstKP42X2u/jqSmRnBanUFbvtnqatHHwfzK8l01YPdQObK760H7dSre1tQ1nT
         kk3w==
X-Gm-Message-State: AOAM533EtTA/cll1oGHiUJFiUm7DZa518HkaGPXwXO9dJInBCkAe5hVv
        t1kssVHmTupJGOHhOXUwXtzugg==
X-Google-Smtp-Source: ABdhPJwcugoR+ehbObpRf84pGmeg8jmjF9eXyBPY2141WPr9ws3tvsLgZGZSUPCd3OkkDPm0sai2Ww==
X-Received: by 2002:a1c:7406:: with SMTP id p6mr2599861wmc.103.1615971431794;
        Wed, 17 Mar 2021 01:57:11 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gotom@debian.org, linux-scsi@vger.kernel.org
Subject: [PATCH 06/18] scsi: nsp32: Supply __printf(x, y) formatting for nsp32_message()
Date:   Wed, 17 Mar 2021 08:56:49 +0000
Message-Id: <20210317085701.2891231-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
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

