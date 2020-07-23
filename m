Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C3DC433EA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E3622BEA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GrbtluSJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgGWM0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgGWMZQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E5FC0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o8so4783277wmh.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Va/Ff5G2hEmAhvKYYGy2WjvjWoULU+Qfw6mOj+wkLgk=;
        b=GrbtluSJbKvXB3XVk94LANq0j8olHPMHyQJC8heK46kTGaizDW8xkyyCRV2sy9pwlO
         NasEXqqYQqCkCgZO0ZucEKCaIWJnxD/tqbrOLCncdpe4cvDbP7k6BQRTtUbG/NSQe+oT
         L83Mn0nJOjCPAmTCkeQMCxWoiPpP8Inh6/UGZZpWCOy25u2GUSx2WhoqplwC6orcnj0M
         aM9oFpQj+subQFcUjh2krxgDuvQf1dbVE6y1/+jQjR2YEbKkQoRikCw/CEL3QFjkPURz
         0o1bHAHoxtzm8Huk5Gx3SI+LnKiR0z+DwrgcwFjez73AGGZ15h7Vy8jhvbTFO18BKka1
         xTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Va/Ff5G2hEmAhvKYYGy2WjvjWoULU+Qfw6mOj+wkLgk=;
        b=ebU6l5Li/u6jHU9TvFQVeQOw2QjrCU8zzMSqXyDEEp6YTq19DALsUYXT9mRhfDEh75
         fYLYhvKcJLLUPXTbQLd9in+prrv0b+L+pCxNFLZwHbLLEU2OY3AmjHZNjsySd56kLQyQ
         i6h1pM14XvkbHhCZh7Q9zcWg6wYkppwMT7scXOGbxQgai9L4H9H3pKQPqD8I+CZxU1Qa
         z2sWc0X/XCEngGcDST23sRroK7FJHcHocoW2TeFvBirlWhv1Y47YcfO60rksqpw1saJD
         A5VKvUGYUGWbPjbpqZ0x2xCnL7a4AcEDrwvnQnTeQtkKOfoCYaoNjVyVEL7Ua9T0JlC8
         wRoA==
X-Gm-Message-State: AOAM531bpDhNYt6WDZeNwAy+NFRt5Zd2EVt6S2Nirhu9ejj7hzaBAD3U
        v6hnzxPwC60GuE3ILQ3SWR596Q==
X-Google-Smtp-Source: ABdhPJxYMy4WI54kPr1zV3EGU+isVVMYiwRBNr7dqikp5ChiLWLv5GhFemXzv/nugVl78RxJzX5jXg==
X-Received: by 2002:a1c:790c:: with SMTP id l12mr3922082wme.50.1595507114637;
        Thu, 23 Jul 2020 05:25:14 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
Subject: [PATCH 21/40] scsi: csiostor: csio_hw: Mark known unused variable as __always_unused
Date:   Thu, 23 Jul 2020 13:24:27 +0100
Message-Id: <20200723122446.1329773-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/csiostor/csio_hw.c: In function ‘csio_hw_get_vpd_params’:
 drivers/scsi/csiostor/csio_hw.c:309:8: warning: variable ‘s’ set but not used [-Wunused-but-set-variable]

Cc: Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/csiostor/csio_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 950f9cdf0577f..98d4d39aaa572 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -306,7 +306,7 @@ csio_hw_get_vpd_params(struct csio_hw *hw, struct csio_vpd *p)
 	uint8_t *vpd, csum;
 	const struct t4_vpd_hdr *v;
 	/* To get around compilation warning from strstrip */
-	char *s;
+	char __always_unused *s;
 
 	if (csio_is_valid_vpd(hw))
 		return 0;
-- 
2.25.1

