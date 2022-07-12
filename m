Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC76CCCA485
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiGLH6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiGLH6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:58:43 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E1BF08;
        Tue, 12 Jul 2022 00:58:39 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 23so6876409pgc.8;
        Tue, 12 Jul 2022 00:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=llxMpF9nJlCaL45HHzQOxFiHqiNr+0CVyGM12/RbJls=;
        b=AN/H6CFNSjoacRTIRRQQM+uydc/ayghIqGV8Ud+eMpbzEVavCk7xKrvKv+ofUocuNS
         FjLkrP8NCeH9diD46prKSnBnwHH7uOTxW+lV/kgIbEl0H6V8glN4KuMWJ+iA0P8JQ/vw
         Eo+zm12zj6+Fb3rF9UquVmAFOAl6P21jcEf5ful5QcMrSb3Kixp6WKwy+xO6T0rmfMMR
         CHZZBSBOK1VWdy8PHWrI+Hf5YF/jp5PQjoShU/SNazaxCCrbdJAIpmlN+LxZyUpiHeMd
         5P0dlXaPrAR9QV99feJFxFOi2LU76zeo0HdaMhjACN4bcxrTsQWr4ezKvM0ZPgRF+ZPq
         w/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=llxMpF9nJlCaL45HHzQOxFiHqiNr+0CVyGM12/RbJls=;
        b=2+49VHHduwCd6sMgCsnyMh2+1Mc+hMzWbRhKpIwsicw47u6Gj4gDPryYA6qlxRedNK
         +swD+XAIb+NbyV7dbUbBbjfmfYEW1zoor5M50XTKANnka2PTT8lrwMmKDfFqKWk8oRBO
         iLilGKrvFkV5nPdLLVXArOZ7o6zHM/qmjZnsbufpNfm9ek5O71KD95ETUzpkc6xJraDL
         Y/sk87bzyOUGgH9rleOO5lNucdU0toee3FiR1k6keWx5B1h+Qce8CKA9M6H755/YsoOx
         Wmyyj6ol+7Lx7V4KLJFudM/k3ERFJ0LYYbRN+jpC4VgY1acjq4l9RSbdXEqSNr2vFFn8
         +UoA==
X-Gm-Message-State: AJIora/Oy171OUujeDpI1GXA3Bf12PsIqS9G/gQXGANYf7CcEPWXXsE6
        fRRTzDU8er2IUN8bHJxarAN+/Asw4Mg=
X-Google-Smtp-Source: AGRyM1vgHY4Wc1JH22i97c3EV21O/3M2QUZu+htOIwtkKMqIQPkK9rjX5x1DUH+HhZ1jw0Ht0nXJRQ==
X-Received: by 2002:a05:6a00:1da9:b0:52a:c339:c520 with SMTP id z41-20020a056a001da900b0052ac339c520mr13318010pfw.70.1657612719146;
        Tue, 12 Jul 2022 00:58:39 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id z6-20020a170903018600b0016be5f24aaesm6189097plg.163.2022.07.12.00.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id B6348360333; Tue, 12 Jul 2022 19:58:35 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 2/5] m68k - set up platform device for mvme147_scsi
Date:   Tue, 12 Jul 2022 19:58:29 +1200
Message-Id: <20220712075832.23793-3-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712075832.23793-1-schmitzmic@gmail.com>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
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

