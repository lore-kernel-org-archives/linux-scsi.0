Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD22C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiGIAKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiGIAKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:10:31 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6887CB43;
        Fri,  8 Jul 2022 17:10:28 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g4so283827pgc.1;
        Fri, 08 Jul 2022 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=llxMpF9nJlCaL45HHzQOxFiHqiNr+0CVyGM12/RbJls=;
        b=Hdgmru4azIMCHkiN7WWiKRHznIdDne2GBhYrDXJ89u8nbvR1APuC4Kf4ifKi2Ed/MW
         NOb/b2juQIHSw6VWfzi4qE83Y7a0OwoSF6wK5DxbhiNc5Fy5X56BrM0hF+rxwyl0QdRZ
         QysmeBSEFy9hjb9bEJlOdMnuo+KXniu+uS1H9ePzv+UiLmgeB5qJATN5k6FET7gaOt10
         AtRBrcY2fVENx2WRPxsOjuPyDdPXFG98NXfITJ/rnNNsjN29mC6wMW55QPSCm/hlnCyV
         BJ7Cllef+SL0O3GLi57Q4sFTsxSsc/6oeBNIOzeHPRA7w3paTWlronus2w4Opy6jGmj8
         ii0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=llxMpF9nJlCaL45HHzQOxFiHqiNr+0CVyGM12/RbJls=;
        b=tvnNKatjEWgxHhDzB/cacNBTYR6lqBLGbCxX+cYidA2VXkHK8xsKEiLhvvhaJ3f6f4
         Hd235D+cb80gyndLucxgDY3u9/aIYcmNPbG11Gl1xo4rc7Motrf5/5kHFTjR3+bYnn/F
         X+HSXj7e5qIDWbk2tw0Wi4YYxzHQP7nLiumK0rUXvAmU72jOc0buFfzDK60gfigOVrXH
         qaQlu1TGBojxt/WJhJJ5M5vGdupbPpjZVeOjfH38l5Y+qXtb1d+8YQqEH/d4/J9NLUAw
         JiZRnD6Q9LiG6bb0SmyEmiHk9mrE6dpxG20cOGumkNrX4/ZHP1/HancXmiwvsaY8mHa7
         icCw==
X-Gm-Message-State: AJIora8cf22cctPd4ZGZZhhM+BXicJwhkn7NysRq6WDBrj1Vwb6JdZsd
        fvhx1C9aP39vZiVCDiEqpwo=
X-Google-Smtp-Source: AGRyM1s2vof3t0moifI8p42i6NgbdqmXAsLOiroR+B91T6gAajr8uSb2d1SJdxCgF12VpE+fi+5J+A==
X-Received: by 2002:a05:6a00:c92:b0:525:8782:71f2 with SMTP id a18-20020a056a000c9200b00525878271f2mr6509820pfv.50.1657325426791;
        Fri, 08 Jul 2022 17:10:26 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id a10-20020aa78e8a000000b00528c22038f5sm179850pfr.14.2022.07.08.17.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 17:10:26 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D07F4360333; Sat,  9 Jul 2022 12:10:22 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 2/4] m68k - set up platform device for mvme147_scsi
Date:   Sat,  9 Jul 2022 12:10:17 +1200
Message-Id: <20220709001019.11149-3-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220709001019.11149-1-schmitzmic@gmail.com>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set up a platform device for the mvme147_scsi driver. The
platform device is required for conversion of the driver to
the DMA API.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 arch/m68k/mvme147/config.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 4e6218115f43..c6e7dfe3eb54 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -21,6 +21,7 @@
 #include <linux/console.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/platform_device.h>
 #include <linux/major.h>
 #include <linux/rtc.h>
 #include <linux/interrupt.h>
@@ -188,3 +189,23 @@ int mvme147_hwclk(int op, struct rtc_time *t)
 	}
 	return 0;
 }
+
+static const struct resource mvme147_scsi_rsrc[] __initconst = {
+	DEFINE_RES_MEM(MVME147_SCSI_BASE, 0xff),
+	DEFINE_RES_IRQ(MVME147_IRQ_SCSI_PORT),
+};
+
+int __init mvme147_platform_init(void)
+{
+	struct platform_device *pdev;
+	int rv = 0;
+
+	pdev = platform_device_register_simple("mvme147-scsi", -1,
+		mvme147_scsi_rsrc, ARRAY_SIZE(mvme147_scsi_rsrc));
+	if (IS_ERR(pdev))
+		rv = PTR_ERR(pdev);
+
+	return rv;
+}
+
+arch_initcall(mvme147_platform_init);
-- 
2.17.1

