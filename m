Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860D5C388F9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 10:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DAA02231B
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 10:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HoSR/w39"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgKBKZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 05:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgKBKZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 05:25:58 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7FBC0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 02:25:58 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 205so1197379wma.4
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 02:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3H4ECss9j64M9/DgBBB+UTVHgBY3NUG4+bvVfh0cN/I=;
        b=HoSR/w39rJuiecht1ygijSGfa4XlnF9cC/ivdmb3z2ZeTQXJLEcTWfGC51PSRt9Xe1
         dHNqYxrx/izLdx0fqrocT7tVsOgQPde6tZDAawtHde515wDMgwBgYLZ7zEIHkev7YR/7
         6ld8RCHsqws5z/i4GXDRRtAl75RNu+Ro83U2Z9XccSZs8lVNj1khP+Qv+mxmPfGJlJ7d
         waTi4k8APAMKyJ3LSMJeuMM1G/nRHxKw884PmImuVXfML/1ylfBPcVr3iLhD6IyX2tJ0
         rhs3/6kXiMZ8h2H7AUgu6+8KzLIJ4xsi4ONYRRhHXKpsEmshz/APuVViXFgqOlVXGu0d
         O46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3H4ECss9j64M9/DgBBB+UTVHgBY3NUG4+bvVfh0cN/I=;
        b=nn7o5E3WPWx3vpoUcU4Iv1p6ZbHDnotNFRtleGulRdEnVet8g7gUpn8Gx0MM2k0Hp4
         Ge8IwwBUK6SQJeK4rmfaVRrEeylhzNgVxnTU/2fieunfLjm8XAOxmclvI+4OZOc8sy72
         VQl4MYCOo7mg8farbp7cW/XLmPslUMr/4asJlZ1r66Ig7FA5CBSC99vJ3z6MexwClANI
         cw6WQkhKSayRhm+ZCza8qzKuVQr4uF5ir82YHDy1bZ1J/RwA2caYaXd0AVXyyGsU6Npq
         CPn/RZUVcqBfQbePjv3hrlQL9hcCFxrdLaHIyttdDvcOiytvQb/KgBM1cWYuJz0CvylW
         k0ag==
X-Gm-Message-State: AOAM532yZgL59r9O89k8y8171hzxDohLtTu6QIN99DeSaWQwdOYNnFMq
        6UA1dDT5rKOim/HZcy8DP/HDeg==
X-Google-Smtp-Source: ABdhPJydm3PV+VbDKFvxHMR122TwsTt83llpIYfSiY7TCAzdcBmix5sc5NMqlV0v6/5dzWHbUSKiMA==
X-Received: by 2002:a1c:b70b:: with SMTP id h11mr13256458wmf.185.1604312756936;
        Mon, 02 Nov 2020 02:25:56 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id o7sm21766730wrp.23.2020.11.02.02.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:25:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        support@areca.com.tw
Subject: [PATCH 1/3] scsi: arcmsr: arcmsr_hba: Stop __builtin_strncpy complaining about a lack of space for NUL
Date:   Mon,  2 Nov 2020 10:25:42 +0000
Message-Id: <20201102102544.1018706-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

inqdata is not NUL terminated.

Fixes the following W=1 kernel build warning(s):

 In file included from include/linux/bitmap.h:9,
 from include/linux/nodemask.h:95,
 from include/linux/mmzone.h:17,
 from include/linux/gfp.h:6,
 from include/linux/umh.h:4,
 from include/linux/kmod.h:9,
 from include/linux/module.h:16,
 from drivers/scsi/arcmsr/arcmsr_hba.c:47:
 In function ‘strncpy’,
 inlined from ‘arcmsr_handle_virtual_command’ at drivers/scsi/arcmsr/arcmsr_hba.c:3055:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~
 In function ‘strncpy’,
 inlined from ‘arcmsr_handle_virtual_command’ at drivers/scsi/arcmsr/arcmsr_hba.c:3053:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output truncated before terminating nul copying 16 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~
 In function ‘strncpy’,
 inlined from ‘arcmsr_handle_virtual_command’ at drivers/scsi/arcmsr/arcmsr_hba.c:3051:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output truncated before terminating nul copying 8 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~

Cc: support@areca.com.tw
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 127fe50e6b120..f241ae15496a2 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3201,11 +3201,11 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		/* ISO, ECMA, & ANSI versions */
 		inqdata[4] = 31;
 		/* length of additional data */
-		strncpy(&inqdata[8], "Areca   ", 8);
+		memcpy(&inqdata[8], "Areca   ", 8);
 		/* Vendor Identification */
-		strncpy(&inqdata[16], "RAID controller ", 16);
+		memcpy(&inqdata[16], "RAID controller ", 16);
 		/* Product Identification */
-		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
+		memcpy(&inqdata[32], "R001", 4); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
 		buffer = kmap_atomic(sg_page(sg)) + sg->offset;
-- 
2.25.1

