Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD0DCCA47F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiGMC4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGMC4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:56:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EBDB1C1;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso1357267pjj.5;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QSLBth1UAZoBdoCqm60VueY2vh2tMmMd00GyQMuP4pM=;
        b=IRRFCg80RU+w9f0X+XxlSoVhJ7/4eI+x/vtRy3PQEkVAIVMJVO3ATeZ13hF5sn0QSw
         Vb1snU6QN6YM8qhmlOImscDFIXBeVivmMgiIeACm0ZUGz5GOp9tzs05rPFdP4T3FuKmj
         zi1avPiztEuzdMFaJ6Wdlvl0juVyfQ4jRG0RKZE21ZacnYduPYs7dnHqEe+MYmGztDmA
         ZfA1k3BMVEkTKsNM2VRCCw6jdkEZHpOyFFJUhGof4rSo2Tta4K8eS15mAayMQrIbb2zp
         ct/hFJQqmitvYQxm5q1oxfjKl1WxikB4kAA4p7eflePuntTIRE3/KLlDhictIPAMBBuK
         E2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QSLBth1UAZoBdoCqm60VueY2vh2tMmMd00GyQMuP4pM=;
        b=mpXmFq8mvdiH2iOnzR9S2BQ5olTIrCio/wgL32cbQB+4y9o24dDjOOOD41LwUS4j0D
         S8fQP4w/MsAHVEtx09fwlcIqhdP6k0NJ9YROTMH1QogtOZ2qPC3aHCiMBxhfQo/w0tbw
         4BS9YdZRsFk+B5AF//urfN0fuxjjYnOnYOI5c0Gga9vS0LIqhMU0Jz/aKij1CtP9FB/6
         xi4Ovg1fYqysCCCqgvTUXby0ViquDqAHJicjPM+bRDdOOOE4bnoXlJbUIRM0pF/813Uz
         ogFAHH82CbmQk/C+3L9wsHv3GjMe8d5LaiFS33DGNP1Bz12lJx3HdZnY+ha0+5c1CdXh
         6LuQ==
X-Gm-Message-State: AJIora/kOlfMRxj1Vc2+fS+qQJSs5D4p4m9RdLto3hM2D+ynTWqWYlMC
        qzYkEnCkN3tVwncD3KljZgI=
X-Google-Smtp-Source: AGRyM1uSq/a6KNVSKlDEhqx0DplbDaKewcz0F9SFJOneDFPX3m2A/kifPbBWiPyvCwVsMZVEriUDfQ==
X-Received: by 2002:a17:902:db04:b0:16c:5568:d73e with SMTP id m4-20020a170902db0400b0016c5568d73emr1093083plx.46.1657680967016;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id w81-20020a627b54000000b0050dc7628178sm7492070pfc.82.2022.07.12.19.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 19:56:06 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 7C0F1360331; Wed, 13 Jul 2022 14:56:03 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v3 1/5] m68k - add MVME147 SCSI base address to mvme147hw.h
Date:   Wed, 13 Jul 2022 14:55:57 +1200
Message-Id: <20220713025601.22584-2-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220713025601.22584-1-schmitzmic@gmail.com>
References: <20220713025601.22584-1-schmitzmic@gmail.com>
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

