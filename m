Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8B9C433B4
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BEB613C2
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEIVja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:39:30 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:43754 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhEIVj3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:39:29 -0400
Received: by mail-pf1-f182.google.com with SMTP id b21so5153293pft.10
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/JcfK5vkUKwzub5mM4cUAmzpRjVpH15IPiwXnuTeJgk=;
        b=EuBZis4n2z07nUNpzGKq4DJ+ZSqCWqx14qFX589GlGYWl8xP1PfDi+FVB7Oic46YGn
         AAsEh0CoJwVAC5D39+Y+ghtQnTk71eAymNWavBvpnag5hqet0f1WcX3JUcHM04ejcOlP
         R0gZ+n/VUv7spK5KCaYUijsuQUS9SzlBb8LDhoMdhoy1D/gc7sRFitaWd4RcMHtpVVoU
         FbQ5uAGN/bUv+l+Xs+hLH34eYKuFpnKuRz5T9tLBVA2SdGmUFLV2uTC1b1IQGnusbxZ9
         zjYPUks3ESn/BaTfzT3oUBrt23ZjaJKSCLViI4fjv2a73RhYeZgO582PRQ7yrUUJzF5T
         iUnQ==
X-Gm-Message-State: AOAM530ZFxuzy9SB726thQlIQxfFevyVuYD8SBJ1bzqfgdcWxZfb5d+O
        lBK0lqfbDtsaS1QPHHpDkD0=
X-Google-Smtp-Source: ABdhPJxxzVmaju1F/Gmsp1PI6juUDLGSZHJy5AckbvDRlyqnDIw783WcHLH0d6FwWJUaq69sehTyFQ==
X-Received: by 2002:aa7:9395:0:b029:2b4:6011:9ec2 with SMTP id t21-20020aa793950000b02902b460119ec2mr8198616pfe.16.1620596304842;
        Sun, 09 May 2021 14:38:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id i22sm9374807pgj.90.2021.05.09.14.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:38:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH] ufs-exynos: Move definitions from .h to .c
Date:   Sun,  9 May 2021 14:38:17 -0700
Message-Id: <20210509213817.4348-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the Linux kernel definitions of data structures should occur in .c
files. Hence move the exynos7_uic_attr definition from a .h into a .c
file. Additionally, declare exynos_ufs_drvs static. This patch fixes the
following two sparse warnings:

drivers/scsi/ufs/ufs-exynos.h:248:28: warning: symbol 'exynos_ufs_drvs' was not declared. Should it be static?
drivers/scsi/ufs/ufs-exynos.h:250:28: warning: symbol 'exynos7_uic_attr' was not declared. Should it be static?

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-exynos.c | 27 ++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufs-exynos.h | 26 --------------------------
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 70647eacf195..4c38689ecdd2 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -107,6 +107,7 @@ enum {
 
 #define CNTR_DIV_VAL 40
 
+static struct exynos_ufs_drv_data exynos_ufs_drvs;
 static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en);
 static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en);
 
@@ -1231,8 +1232,32 @@ static int exynos_ufs_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct exynos_ufs_drv_data exynos_ufs_drvs = {
+static struct exynos_ufs_uic_attr exynos7_uic_attr = {
+	.tx_trailingclks		= 0x10,
+	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
+	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
+	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
+	.tx_base_unit_nsec		= 100000,	/* unit: ns */
+	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
+	.tx_sleep_cnt			= 1000,		/* unit: ns */
+	.tx_min_activatetime		= 0xa,
+	.rx_filler_enable		= 0x2,
+	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
+	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
+	.rx_base_unit_nsec		= 100000,	/* unit: ns */
+	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
+	.rx_sleep_cnt			= 1280,		/* unit: ns */
+	.rx_stall_cnt			= 320,		/* unit: ns */
+	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
+	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
+	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
+	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
+	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
+	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
+	.pa_dbg_option_suite		= 0x30103,
+};
 
+static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.compatible		= "samsung,exynos7-ufs",
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 06ee565f7eb0..67505fe32ebf 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -245,30 +245,4 @@ static inline void exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);
 }
 
-struct exynos_ufs_drv_data exynos_ufs_drvs;
-
-struct exynos_ufs_uic_attr exynos7_uic_attr = {
-	.tx_trailingclks		= 0x10,
-	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
-	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
-	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
-	.tx_base_unit_nsec		= 100000,	/* unit: ns */
-	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
-	.tx_sleep_cnt			= 1000,		/* unit: ns */
-	.tx_min_activatetime		= 0xa,
-	.rx_filler_enable		= 0x2,
-	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
-	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
-	.rx_base_unit_nsec		= 100000,	/* unit: ns */
-	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
-	.rx_sleep_cnt			= 1280,		/* unit: ns */
-	.rx_stall_cnt			= 320,		/* unit: ns */
-	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
-	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
-	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
-	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
-	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
-	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
-	.pa_dbg_option_suite		= 0x30103,
-};
 #endif /* _UFS_EXYNOS_H_ */
