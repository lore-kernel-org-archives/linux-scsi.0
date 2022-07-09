Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D663CCA47B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiGIAKd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiGIAKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:10:31 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239357AB35;
        Fri,  8 Jul 2022 17:10:28 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id i190so242271pge.7;
        Fri, 08 Jul 2022 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QSLBth1UAZoBdoCqm60VueY2vh2tMmMd00GyQMuP4pM=;
        b=fyqQ0kmQym1qJMzxFDJcXdWrvlEeq/kKMKzXoSjgTwx+lxne5bQloX9z7FWl3Ivvs4
         LvRV1PCTOMHl5I8UouFypkEEgOvFW6vF6kbLDFE/oer1jzVi01eAwnmtplhgM1Hvz5J+
         QOglfCtgzqi+B6xKzhMGinG5P7EADMOvQGyI+1oMBBcviZw8xq+gokFVtO+DjgL5G+vk
         yj+gWQkw3NaYbw89LqQVRn+m5leMlArKIHVJZBPHjUy3g94eYyC9zBAJ+BYKSxgoZzLB
         +GEl2qzJyiYrTejkLRz1RfPd4Bw3zBY/JkJQ5180FEsdNXGvF2fKxzPpzCWYhS1PCmgU
         MHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QSLBth1UAZoBdoCqm60VueY2vh2tMmMd00GyQMuP4pM=;
        b=hs41R1aCd5a/xIu+YvsMnTOQAkgK4k1pQvA1dnskpoo0+vgptrBJwXuTM9f9rfHwsd
         NJA6zjjwXL5BgB4gtYWZ96hHHG1kOULbvOxqf9FYVj7rUf2IcDJyKfNUNcHQ2bAP9x0o
         LHbfGKI6L4Zw1M3AXzH0M0mvTMg2cTWBRQkdFGy5q/otur09P0OpGo0wrEfBHrwwtpHl
         mGYZHwDQBJKGxIo7FA02S1ocvTD1BovaTbA62Cws18i4OvnxWrYAqOELwXilUXgyH4f8
         ft2TaxIy7GGYjVqZHEu93rESIghltYnOEmpPDHBW7rSUpgJbvry4fi8Q33hFKXkaP5wl
         Os5w==
X-Gm-Message-State: AJIora+DjWgpdOP+OHju5Ha7iGok4oMfJVuy5nTH6K6+RvD989ziSTqP
        /Sba5+c3F/9eV+8iTPLyaTOcJzMbgak=
X-Google-Smtp-Source: AGRyM1vBVCVVGdL5Ri1rNTj/rq6K2W59YePwQ6w+jAmwdPF2BYg7xmdVjCx1ygpAXAJDnfifPZQTtg==
X-Received: by 2002:a65:6bc4:0:b0:3c2:2f7c:cc74 with SMTP id e4-20020a656bc4000000b003c22f7ccc74mr5380188pgw.307.1657325425939;
        Fri, 08 Jul 2022 17:10:25 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id y11-20020aa79aeb000000b0052ab3039c4esm176297pfp.8.2022.07.08.17.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 17:10:25 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 2742C360331; Sat,  9 Jul 2022 12:10:22 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 1/4] m68k - add MVME147 SCSI base address to mvme147hw.h
Date:   Sat,  9 Jul 2022 12:10:16 +1200
Message-Id: <20220709001019.11149-2-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220709001019.11149-1-schmitzmic@gmail.com>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The base address for the WD33C93 SCSI host adapter on mvme147
boards is missing from mvme147hw.h. This information will be
needed for platform device conversion of the mvme147_scsi
driver, so add it here.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 arch/m68k/include/asm/mvme147hw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index e28eb1c0e0bf..fd8c1e4fc7be 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -93,6 +93,7 @@ struct pcc_regs {
 #define M147_SCC_B_ADDR		0xfffe3000
 #define M147_SCC_PCLK		5000000
 
+#define MVME147_SCSI_BASE	0xfffe4000
 #define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x45)
 #define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x46)
 
-- 
2.17.1

