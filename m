Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48143C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248C92085B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CN0ZbGb9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgGIRrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgGIRqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E12DC08E6DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j4so3274482wrp.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xgee6VNOxowtnDCzKQ+Sz5+2OlEHHNxO9R7xXG9/C34=;
        b=CN0ZbGb9MRi59LyH9zB97Z++En4BiFKyZiVJ381/Rg/kN/CRIXsIj5dOBuPWrgWYll
         GCC4SY1ommscxO/xbHRiJsP9m9mTbUb2zqVnoKobE1zycNVZF9pMLQqAmgqs3iCBMDj4
         tDbRDBRq4ZQRPQBorsXefezGStUApK5AxTRyQtAbm85q8fD1uo7odg1823GwPU+gV5yt
         0SC9pcojni05hKi+ADI2yzgZxOiIPevQSlW3k4b1/rqwedTXMU50EHrMi83xNzoig7L1
         ZybfqqQJhVnLjtajD4lEeBaUZ7Ul7+fvz67bHXfJmT/Z5PkKToKPczVj85D1Ap2DGimO
         cbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xgee6VNOxowtnDCzKQ+Sz5+2OlEHHNxO9R7xXG9/C34=;
        b=fqzHsfWAMmUFLC3lTTL9q1oNcqwTiJMLCiqz46BQLRyQe1gykRBTWhFNTcniI06ex+
         kSSrHMXUgZ0ITSkREYMGrwKbYIcQbUXvfdMSU1CaslPywfx5qXwqDEFgYu/sUkSsynhZ
         4NqhUoEXShdnkQgB7M9srsnVG+figdoWXNSLgLNbEkot+N/V4tQI9BHpn+p2RuEumv/n
         pZ5FVAve6z5HbfVV6zpaBwuUYtfwWCeqXaA+R9fsqOhaatwAqfKm0IgRZAvE1Psm6Sx0
         tLOYGPp9mpZCCOM0XyDOfqBTq9rIEIszTSzHhqSRXzgn1dhOvyzJlMxvA5ETRtlATVVn
         tFtg==
X-Gm-Message-State: AOAM533CFECu8v0kBA7sQXc4uzCsJpRxj1JiPdZG2Uwnj01jFT8bkbbe
        dLf2vf/8gK1ZJLFKenim575vYw==
X-Google-Smtp-Source: ABdhPJxXg1VXnP+XIMR+kFM9aoY9RsEO6ZeabXxiOPXeOKB4exk4yDDPWKj2LiaG2tte5nqk/5Ja2A==
X-Received: by 2002:a5d:4687:: with SMTP id u7mr68300611wrq.357.1594316764208;
        Thu, 09 Jul 2020 10:46:04 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 05/24] scsi: aacraid: dpcsup: Demote partially documented function header
Date:   Thu,  9 Jul 2020 18:45:37 +0100
Message-Id: <20200709174556.7651-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This should be populated by someone who knows the meaning of all the params.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/dpcsup.c:272: warning: Function parameter or member 'isAif' not described in 'aac_intr_normal'
 drivers/scsi/aacraid/dpcsup.c:272: warning: Function parameter or member 'isFastResponse' not described in 'aac_intr_normal'
 drivers/scsi/aacraid/dpcsup.c:272: warning: Function parameter or member 'aif_fib' not described in 'aac_intr_normal'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/dpcsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 749f8e740ece1..fbe334c59f376 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -258,7 +258,7 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
 }
 
 
-/**
+/*
  *	aac_intr_normal	-	Handle command replies
  *	@dev: Device
  *	@index: completion reference
-- 
2.25.1

