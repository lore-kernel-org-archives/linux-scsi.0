Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B38C46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjIRQ2N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjIRQ1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:27:49 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC6F21EB0
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:22:05 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c3bd829b86so34075455ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695054091; x=1695658891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DxhRYQyu6qLWzaGH/ogzDEcSbv33IcCjbAZcuyI4vOA=;
        b=CSkZ7Tlvxk8EkI+DS9oYjHpf52ZN//oasPhhy/+/APUYiYvlH6YHX+ON1aQPhF6GSk
         DDi2YXptloqr2xIxkxN8rJLKT383ZW0WK091btzo3RiWiBJ+BRb9NpCe9PwlElsgTGka
         //XHJ7zytQyCpMV8hNJ0NP2cMS/Grq99wAWanZTQyPY1HBCxq3gRMZdZK/H8IcRcPcXL
         Klv5SxC68Qn57HJJiiQBNy5Kh1FCjZ+alDxMjHZpln0VFrk88UyqauT5ZD+yVYWLCWgM
         BxAIAcznyJKMhR/N09BaSm6VB4PG5+Ugzht0Qro3r/B3jp+iVogbx7AJ065npV20nbdy
         xb5w==
X-Gm-Message-State: AOJu0YxBZZU6IpzSL+zG0ZrVE/3XtNaddETdTLDdgWcq6+Kl1s8Z7O8E
        6rIRCIw32YuVeo2H2ZHX7u4=
X-Google-Smtp-Source: AGHT+IGZmWtcgFBwW4BoYgrS7yq1L7CtuMir503EO4Fsuf8mT8/xge80k6uGRBNq7+QI13AYEyL9fg==
X-Received: by 2002:a17:903:2643:b0:1bf:703d:cc6b with SMTP id je3-20020a170903264300b001bf703dcc6bmr6884009plb.10.1695054091292;
        Mon, 18 Sep 2023 09:21:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902d54e00b001bd28b9c3ddsm8489414plf.299.2023.09.18.09.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:21:30 -0700 (PDT)
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
Subject: [PATCH 2/4] scsi: ufs: Move the 4K alignment code into the Exynos driver
Date:   Mon, 18 Sep 2023 09:20:13 -0700
Message-ID: <20230918162058.1562033-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918162058.1562033-1-bvanassche@acm.org>
References: <20230918162058.1562033-1-bvanassche@acm.org>
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
index 5fccec3c1091..100729981738 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5098,8 +5098,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
-	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
-		blk_queue_update_dma_alignment(q, SZ_4K - 1);
+
 	/*
 	 * Block runtime-pm until all consumers are added.
 	 * Refer ufshcd_setup_links().
@@ -5115,6 +5114,9 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
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
