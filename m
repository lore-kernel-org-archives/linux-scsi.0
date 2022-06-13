Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC38BC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 10:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbiFMKOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241564AbiFMKOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 06:14:37 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687B7CE0D
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:14:34 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kq6so10163251ejb.11
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M46PCkjJ2OifC0xaqwZJ7l8A4H9uAcmd8SjFaU1ZI3o=;
        b=RY32gASyfk41ROBUhtm7wusGacyUTe5+H8ZMqeHzaR2h7UknN9RbikleB7Vzgo5/aN
         qHO37sPTq+UUwbHnakGMJafJ/JOPPxwhitAGUBF7n3OFEe8P/NIS8p3OKqL8wv5L2GIm
         6pmPjIwLKMU/A/b+7TQ7do/4KVOWgOcRYxiDNnXKTC7AbDxvfdT7qkwHZZCd9Da5M9tm
         Pg5VYi16kYv/RuHVaWdSDEDq6EYXAVHufR0D7nSyMF0Bs8vEl4bfLQR3ROEeR8UyOydk
         edovqXodfaCVZd4CRsKBjgskDrH+K/lf4hbinJJ9aGdKVUvI8n9islLSU7QV7+kJXNWP
         4c0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M46PCkjJ2OifC0xaqwZJ7l8A4H9uAcmd8SjFaU1ZI3o=;
        b=UiGsHGAbWzW+H/oCWdVzaEOOCDYeH7wY2egFf90/exuhHC4TBjXjWShjLH2/vpUlxW
         niQOgLeQGPwvc2q+xLFdkwfqzP1fE6RU7Nd1zJ9Ljm1i3+e0uQhnSMCqClafRzAOZ8rV
         b0+j4rVQDxcArlUuJlDCL39J6Y6DNW8ff5KaLLp6hvUDrogL2Y/Z22MacKf0HVajXVQx
         lLUtc96Lvn9LZtJG9JjCt0uQ8VnNFRPdryyedYVxrP0JgcSzoMOWuq3kDUma/p92qjHJ
         EDd1ht2LkieoGWiycHfNeYm1eGfEZ7p8ig6BJ5XvbHjIdT/iql0EnAIWuBRaoGX8Skhh
         n4dA==
X-Gm-Message-State: AOAM531B46CJgfPrnz+yVNWtQboBr65mXqE4YarfQjNL6O6uYLnGpb4d
        2hTGugh0Hp50jVqFT5sNPYQ25tI76Dr12g==
X-Google-Smtp-Source: ABdhPJw63RL7dYHdoDbusyEcWLmssYal+r5BY4+7+lRfm3Z0XJfoRLsIaSNcWuOfIbK+EpvPFW1/aQ==
X-Received: by 2002:a17:907:6e8f:b0:710:865b:9c90 with SMTP id sh15-20020a1709076e8f00b00710865b9c90mr39900307ejc.27.1655115272913;
        Mon, 13 Jun 2022 03:14:32 -0700 (PDT)
Received: from krzk-bin.monzoon.net (80-254-69-65.dynamic.monzoon.net. [80.254.69.65])
        by smtp.gmail.com with ESMTPSA id y9-20020a170906524900b006fec69696a0sm3639863ejm.220.2022.06.13.03.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:14:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: exynos: constify driver data
Date:   Mon, 13 Jun 2022 12:14:29 +0200
Message-Id: <20220613101429.114449-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Constify the drv data because it should not be modified (used by
multiple devices).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index a81d8cbd542f..9fef706d896e 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -157,7 +157,6 @@ enum {
 
 #define CNTR_DIV_VAL 40
 
-static struct exynos_ufs_drv_data exynos_ufs_drvs;
 static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en);
 static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en);
 
@@ -1473,7 +1472,7 @@ static int exynosauto_ufs_vh_init(struct ufs_hba *hba)
 	return 0;
 }
 
-static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
+static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
 	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
@@ -1545,7 +1544,7 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.pa_dbg_option_suite		= 0x30103,
 };
 
-static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
+static const struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
@@ -1561,7 +1560,7 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
 };
 
-static struct exynos_ufs_drv_data exynosauto_ufs_vh_drvs = {
+static const struct exynos_ufs_drv_data exynosauto_ufs_vh_drvs = {
 	.vops			= &ufs_hba_exynosauto_vh_ops,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
@@ -1573,7 +1572,7 @@ static struct exynos_ufs_drv_data exynosauto_ufs_vh_drvs = {
 	.opts			= EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
 };
 
-static struct exynos_ufs_drv_data exynos_ufs_drvs = {
+static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
 				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
-- 
2.34.1

