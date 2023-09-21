Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE8EE7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 19:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjIUTZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjIUTZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 15:25:25 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA318EA634
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:18 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3add83c9043so767580b6e.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324318; x=1695929118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YHs+ElUAcwdj8rHsrp4RPTRq4upkwDSCio/mlO9YgZ4=;
        b=Gqh/iz//Z8/l/XXJ2B85nL/GnOU4qfUEdbHfl5u3Bo+8uCCIjDEmq4LHWihiA+sulR
         o+rfHE4HgJYhhY7ee3IeD9r2nHhVYVY7Dme9kkUGxEZD1W1JMsEXt1yJzgcM+ppigXxO
         cV1TOpNMeYV4DI6SwzQ8zQ3pDnUnYxqAAjGuBsLLooXDrtgYk5EQVRqQblvF4dx5sxem
         FFtuZLM3nUhytjJZiHL4K+EZEyZhY9KgwNwRlBASyT7Mvz5PuFVNnSS243SUMzqq08Xn
         YEu91NuZAQekVKw3/Zcz/AjlrKs8MFPHiJZz9+MHPygmG7WYjuRQUh0ZGmaBCVQUyS4A
         qUQA==
X-Gm-Message-State: AOJu0YynqJr578e5c0Oy4nh5680Y3BYceNdQZA3usb1XJe0dSmv2wFYU
        /ljuEzaK3ViitStH/J3x/RA=
X-Google-Smtp-Source: AGHT+IHqlDgzd03DiTiNNrBh0wOEAwIKwElKbkT3JtH9C8U+yvz6VS+QCoSNHq47oeXv1I4UY3oEZQ==
X-Received: by 2002:a05:6808:d4d:b0:3a6:febf:fb with SMTP id w13-20020a0568080d4d00b003a6febf00fbmr7654317oik.22.1695324317924;
        Thu, 21 Sep 2023 12:25:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id fm1-20020a056a002f8100b00679a4b56e41sm1760061pfb.43.2023.09.21.12.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:25:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 2/4] scsi: ufs: Move the 4K alignment code into the Exynos driver
Date:   Thu, 21 Sep 2023 12:22:47 -0700
Message-ID: <20230921192335.676924-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230921192335.676924-1-bvanassche@acm.org>
References: <20230921192335.676924-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The DMA alignment for the Exynos controller follows directly from the
PRDT segment size configured in ufs-exynos.c. Hence, move the DMA
alignment code into the Exynos driver source code.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c     | 6 ++++--
 drivers/ufs/host/ufs-exynos.c | 9 +++++++--
 include/ufs/ufshcd.h          | 7 ++-----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f48a65fa3bf7..379229d51f04 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5095,8 +5095,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
-	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
-		blk_queue_update_dma_alignment(q, SZ_4K - 1);
+
 	/*
 	 * Block runtime-pm until all consumers are added.
 	 * Refer ufshcd_setup_links().
@@ -5112,6 +5111,9 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	 */
 	sdev->silence_suspend = 1;
 
+	if (hba->vops && hba->vops->config_scsi_dev)
+		hba->vops->config_scsi_dev(sdev);
+
 	ufshcd_crypto_register(hba, q);
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3396e0388512..e5d145a2676e 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1511,6 +1511,11 @@ static int fsd_ufs_pre_link(struct exynos_ufs *ufs)
 	return 0;
 }
 
+static void exynos_ufs_config_scsi_dev(struct scsi_device *sdev)
+{
+	blk_queue_update_dma_alignment(sdev->request_queue, SZ_4K - 1);
+}
+
 static int fsd_ufs_post_link(struct exynos_ufs *ufs)
 {
 	int i;
@@ -1579,6 +1584,7 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.config_scsi_dev		= exynos_ufs_config_scsi_dev,
 };
 
 static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
@@ -1680,8 +1686,7 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
 				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
-				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING |
-				  UFSHCD_QUIRK_4KB_DMA_ALIGNMENT,
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7d07b256e906..e0d6590d163d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -28,6 +28,7 @@
 
 #define UFSHCD "ufshcd"
 
+struct scsi_device;
 struct ufs_hba;
 
 enum dev_cmd_type {
@@ -371,6 +372,7 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
+	void	(*config_scsi_dev)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
@@ -596,11 +598,6 @@ enum ufshcd_quirks {
 	 */
 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
 
-	/*
-	 * Align DMA SG entries on a 4 KiB boundary.
-	 */
-	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 << 14,
-
 	/*
 	 * This quirk needs to be enabled if the host controller does not
 	 * support UIC command
