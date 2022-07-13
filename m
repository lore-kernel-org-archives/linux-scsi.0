Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD84CCA482
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiGMC4K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiGMC4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:56:08 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E832765E8;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a15so10147008pjs.0;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=75FoxV++GMxu2VY3OA67v9tSA2fW6OiCjpFilQU8+z0=;
        b=mBraN3CtR2uv4o4h0uKSDjkreswPojLXzTsdDanjn7ax7w3YQ26lXfzrIf6uv+s5il
         BEQzoCcUIFfuAHEXhPItechiWn6OxD6YtzVdML/E1tuvV1OYLfemgUOllYrl4FtALIOH
         bvv07TcukGRm2ycfpfq1fuwd4iv9jgmU/8u9k2sOogV5GvHeSditB1I4h7bf/LmdDl1o
         bufURjAFrIrQeqJswIzKCweaCkQj0w7SH8GS6wKt4GmkBOlgx0V6oiUWUryLeh4gQW2U
         JbxT/FbWPzvxIwRia/nIXWkLVool573Rw28zFM7sQUzP6xs8+U9YUfCCnswq0+RPXFTG
         5aPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=75FoxV++GMxu2VY3OA67v9tSA2fW6OiCjpFilQU8+z0=;
        b=54zy1LMqyYeHywBsg8SFsiiwz9nGtcm/ouQmTS83eMNz5wUcsgV1pZdGNuWJaNVrYH
         bCkara5NwL7x7hOlGfX5r5JVMTbuEv3WkJLGReUULZ1SNDbl1HzUVncHqYIt7cXvvBPQ
         J3nvBCdWrYkvLdLdO4E/9dT6gnls5dmuPiW5LJ6RnJPpZjGW6ZAxw8kxxHBq1tRYLr7T
         xiyo0KIy4SQcFGr72Ww4VFL9Jt7Thbg2ssu8Xm+hjSoMVV0wRPjOCOoaS95q7z9GStlf
         0LFMXJXJdQ6ljcIiQk3jXUovCmKUJ/L+jW+OIgqVnt9pztdG3+xXQI5SvjJ+SToS8ULK
         G5qg==
X-Gm-Message-State: AJIora/41Y+97gejooNRhgQ6Fo9IQFc3W/pxofEL7ozDTolqs/3rbOU/
        M5WasegZiUdzBZlT+hWYJAE=
X-Google-Smtp-Source: AGRyM1tS0VkYMLVNXv0Jm9vuBvlmKnaCNNuWmv3fLvF2vUSvKW8kH8V4Yw7KrfMXJwJWw6Wv9A7AIQ==
X-Received: by 2002:a17:90b:3e8a:b0:1f0:6e06:92e7 with SMTP id rj10-20020a17090b3e8a00b001f06e0692e7mr4927111pjb.155.1657680967560;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79592000000b0052abfc4b4a4sm6897113pfj.12.2022.07.12.19.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 055A0360333; Wed, 13 Jul 2022 14:56:03 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v3 2/5] m68k - set up platform device for mvme147_scsi
Date:   Wed, 13 Jul 2022 14:55:58 +1200
Message-Id: <20220713025601.22584-3-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220713025601.22584-1-schmitzmic@gmail.com>
References: <20220713025601.22584-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set up a platform device for the mvme147_scsi driver. The
platform device is required for conversion of the driver to
the DMA API.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--

Changes from v2:

Arnd Bergmann:
- correct resource size
---
 arch/m68k/mvme147/config.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 4e6218115f43..7e3d4dc139c7 100644
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
+	DEFINE_RES_MEM(MVME147_SCSI_BASE, 0x100),
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

