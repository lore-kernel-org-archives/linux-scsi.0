Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AD5C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiGMC4Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiGMC4J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:56:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB49E65E8;
        Tue, 12 Jul 2022 19:56:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso1436865pjo.0;
        Tue, 12 Jul 2022 19:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUNEBFmN+RgdAIiWgIKnwVs66l6z7a1wHw6JjJ0sTrw=;
        b=BsxmFzifF9BIo8cMy5rhxaqn6OqhSSsd4NQ9sDFAqTy3iTNaE/i2bfH+YsvGniBI55
         afq2RHyn5VmuLVdhJ+ALiovOdN4P33NCFsqtbpf3nsAZ+A6YvaYUjgVvSnVurZYZxrHo
         u460pEmwGOZH5o6mB3xwWbveIXKu9H7qTZk1lPvOsN/lznwCtxK3YzdvZcDBZ86GPgZE
         mnDUIVvd3ID8LuDezzxamHcP8/6BUcF0f6JJ/jff0GfGbjOq2x5DbuySKCY6CVoHnUGD
         fgZRK9lWLGmmu70z4EKXCecY39Y8novon4CzOXFTIHKmeBniqptE/48YP5kGEe3Lg38p
         WqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nUNEBFmN+RgdAIiWgIKnwVs66l6z7a1wHw6JjJ0sTrw=;
        b=oipODcYDBlJWgDfAC1Z1k6m+eiSjfKEAjHYPVMLrjy2/sL9Qp9t9+Z1k/7igVePWoy
         gsiOToCoy/36CHoiEhY2AMwy0ge1vdbdr0P8i92Izjrvy0LBPUJLolT63bWl2EwugGjZ
         y03Z9T/8xlbb2LniL84JOZv1L3gu0znTx3LYWCVZeVhGR9YSOr5UmDJnvrwLd9Srj6By
         LJiRqtRwJxBgbIpOVifdaM/L4BUK22inV5dnl/WTU/2r6DPB6QyS1HOXEKT0zLvsmUip
         TDocXy/n6jndG8sPVPrtaLt76BbInDASp2zLgJuWMl5dDk+7N2qgzVHAdNXt2XD2vts9
         tH1Q==
X-Gm-Message-State: AJIora9WWhN5JDk/F26MrqiuKX2ckHI+Vhzgtg8wPa+Hlyv/5YPcoxJf
        nJz7GMaW92RvKhEYmIZBEJM=
X-Google-Smtp-Source: AGRyM1tR+rED7WQH5LviMXHraoT4TCdfyxa+gvs8nVKFLp7VbFyuuNuaBdF+0W9Dm6U8UFSxkJdxFA==
X-Received: by 2002:a17:90b:3b8a:b0:1ef:b87d:309d with SMTP id pc10-20020a17090b3b8a00b001efb87d309dmr1376493pjb.176.1657680968253;
        Tue, 12 Jul 2022 19:56:08 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id jd9-20020a170903260900b0016a109c7606sm7492487plb.259.2022.07.12.19.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 87A333603F6; Wed, 13 Jul 2022 14:56:04 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v3 3/5] m68k - add MMIO ioremap support for mvme147
Date:   Wed, 13 Jul 2022 14:55:59 +1200
Message-Id: <20220713025601.22584-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220713025601.22584-1-schmitzmic@gmail.com>
References: <20220713025601.22584-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Converting the mvme147 SCSI driver to the DMA API requires use of
ioremap() in order to get the kernel virtual address of the WD
chip registers.

Add support for transparent mapping of the mvme147 MMIO region to
arch/m68k/mm/kmap.c to enable use of ioremap() in that driver.

Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 arch/m68k/mm/kmap.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
index 7594a945732b..2bcede2af902 100644
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -185,6 +185,13 @@ void __iomem *__ioremap(unsigned long physaddr, unsigned long size, int cachefla
 			return (void __iomem *)physaddr;
 	}
 #endif
+#ifdef CONFIG_MVME147
+	if (MACH_IS_MVME147) {
+		if (physaddr >= 0xe0000000 && cacheflag == IOMAP_NOCACHE_SER)
+			return (void __iomem *)physaddr;
+	}
+#endif
+
 #ifdef CONFIG_COLDFIRE
 	if (__cf_internalio(physaddr))
 		return (void __iomem *) physaddr;
@@ -308,6 +315,10 @@ void iounmap(void __iomem *addr)
 	if (MACH_IS_VIRT && (unsigned long)addr >= 0xff000000)
 		return;
 #endif
+#ifdef CONFIG_MVME147
+	if (MACH_IS_MVME147 && (unsigned long)addr >= 0xe000000)
+		return;
+#endif
 #ifdef CONFIG_COLDFIRE
 	if (cf_internalio(addr))
 		return;
-- 
2.17.1

