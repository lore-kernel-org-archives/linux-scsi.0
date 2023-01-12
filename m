Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5844C54EBE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 23:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjALXnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjALXnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 18:43:05 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB8313F97
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:43:04 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id d15so21775220pls.6
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:43:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/N+/ruISyJ/QTuV3Pc3v3ZnyxN1K341VKQia5HxB1Zk=;
        b=KsX2d3BrXKPe72QTQoIDaKS2tPhcR4nUIhMjsteaQ+FHBYXAPNe+xne2Fdx0sP7I/6
         kmHGxl9H6FER5EawCQO0zmphFiFiu7G5MZhAR9ae5EmRPTnzy2Lr+3AaiPz7AQSvySfX
         1LMiSVtEskj1MpmyJgJQFlQTKIzHrjU3ZvVAHqRGN+xRbPuTRDKKWij8lhfDKwwVvfdF
         rGsPTdaJeFeNIGT6E6dyJ2n474D2XqL5J0GyN+OhpEANt+CiVyOYdqyuvvS5hObfG4ao
         F8jq/MWWMSQ5pKljplfGmXkLQvHdOWUsfYXBKjFzYPP7oMvL25HaxIS1jDh5qk1CX3kB
         uU/g==
X-Gm-Message-State: AFqh2krohv7bzCM8hycG1ulH/6c8zMZVE8mGO0nqNeLVsA/luCdO2TED
        DbNXSBP/U0WrViOEPzroVuokoPPlMbU=
X-Google-Smtp-Source: AMrXdXtAYGu8VRbLoQlMwdQWZcSGAQO34UoPDZEulXs11jF7Eg/sVgcvW0Qp7XUuw4tyM+AtenL+JQ==
X-Received: by 2002:a17:902:ec89:b0:18b:ed3f:c6ca with SMTP id x9-20020a170902ec8900b0018bed3fc6camr107067107plg.12.1673566983800;
        Thu, 12 Jan 2023 15:43:03 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3345:7bfe:9541:882b])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090322c300b0017f8094a52asm12764795plg.29.2023.01.12.15.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 15:43:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 1/3] scsi: ufs: Exynos: Fix DMA alignment for PAGE_SIZE != 4096
Date:   Thu, 12 Jan 2023 15:42:13 -0800
Message-Id: <20230112234215.2630817-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230112234215.2630817-1-bvanassche@acm.org>
References: <20230112234215.2630817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Exynos UFS controller only supports scatter/gather list elements
that are aligned on a 4 KiB boundary. Fix DMA alignment in case
PAGE_SIZE != 4096. Rename UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE into
UFSHCD_QUIRK_4KB_DMA_ALIGNMENT.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Fixes: 2b2bfc8aa519 ("scsi: ufs: Introduce a quirk to allow only page-aligned sg entries")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c     | 4 ++--
 drivers/ufs/host/ufs-exynos.c | 2 +-
 include/ufs/ufshcd.h          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0514669e03be..5fdbc983ce2e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5029,8 +5029,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	ufshcd_hpb_configure(hba, sdev);
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
-	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
-		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
+	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
+		blk_queue_update_dma_alignment(q, 4096 - 1);
 	/*
 	 * Block runtime-pm until all consumers are added.
 	 * Refer ufshcd_setup_links().
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index c3628a8645a5..3cdac89a28b8 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1673,7 +1673,7 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
 				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
 				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING |
-				  UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE,
+				  UFSHCD_QUIRK_4KB_DMA_ALIGNMENT,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index fc7373a1a15e..ca32df0ce6ba 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -570,9 +570,9 @@ enum ufshcd_quirks {
 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
 
 	/*
-	 * This quirk allows only sg entries aligned with page size.
+	 * Align DMA SG entries on a 4 KiB boundary.
 	 */
-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 << 14,
 
 	/*
 	 * This quirk needs to be enabled if the host controller does not
