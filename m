Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F449CCA47C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiGLH6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiGLH6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:58:43 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EBCF0C;
        Tue, 12 Jul 2022 00:58:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 70so6849897pfx.1;
        Tue, 12 Jul 2022 00:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUNEBFmN+RgdAIiWgIKnwVs66l6z7a1wHw6JjJ0sTrw=;
        b=NdAnuBKMcCP/6Qj0SW3VSIKLhmcqyk1xk0J/2KqY0wXWyn3RxvQWuIIRB+Cf/el2BS
         HAoLCr1Z8UMSXopIx7pb9M4yXMyHCc5KkPxFv27gspEXIRp/3d44+YzUZAQOz4OQWHuZ
         1Qu1BX1Cda5hdeeNTG91kjGppGytT7leXD2izUi4+lItMWJhir6bLEkmtI+UE8qScQlu
         wbVVpFRW5XGSscDBFPm/RmH/iy1SNnuET5kTZZWhNdpPtogrT25hnTrHlJcQ29AiiMXZ
         Mj8zy2vMWc73lfEoEfXPiMz1A8iI0VB9OwFyUT8cvGqcCD4o16gmf5iYSUNS7LYYmiDm
         1zxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nUNEBFmN+RgdAIiWgIKnwVs66l6z7a1wHw6JjJ0sTrw=;
        b=Qla94Ud3aVY0ruU6Anm5SKUjK2td6dI3w1rNejG8qxq0RQ8MU99Y7rK56b6BUMc903
         7/Il8JLHaihrmopnQWKxKj5Cufgkk12eXTk7rJ/5gNeVHcwsseJMHGuLnhKB6NR5CQ3Z
         fyZh2aCDILwgVXiUi1AETIvIweNewsIOvXe+ofCOzk5JPF1D2V5oGLXWcfC7TF52RFw0
         WLbR72PHZSRO1e/noqORvmCW9QR1/eAWF+6r7YL1vFgAB0/pBWX6T/2EHkaRXC0Z3rPX
         ADWxFR8/nunoSfIuh2VkEuGlHCAcUeZgyfXBSXb9H0xPPOx9usriKMuMupp6/ShKDb+J
         2z9A==
X-Gm-Message-State: AJIora/HctWa8K1hha/BNU9Nj7WxFwpPHXo9JVIGyTaneRG6OYusY8Ec
        n9uMWwV2I/FuZr+A5Kd5Au2XvYUzm+M=
X-Google-Smtp-Source: AGRyM1urbb6QGwKxZg+ehk1jUBx2U6Lpw1ioZt575GZvIp+Txac0Q9pJcnZ20fj08YeYaBJ/BEoWSg==
X-Received: by 2002:a63:6703:0:b0:413:1f40:6cb5 with SMTP id b3-20020a636703000000b004131f406cb5mr19709822pgc.614.1657612719700;
        Tue, 12 Jul 2022 00:58:39 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id mv16-20020a17090b199000b001f021cdd73dsm5055429pjb.10.2022.07.12.00.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:58:39 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 5ECF23603F6; Tue, 12 Jul 2022 19:58:36 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 3/5] m68k - add MMIO ioremap support for mvme147
Date:   Tue, 12 Jul 2022 19:58:30 +1200
Message-Id: <20220712075832.23793-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712075832.23793-1-schmitzmic@gmail.com>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
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

