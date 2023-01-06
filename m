Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF88C61DB3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Jan 2023 21:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAFV6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFV6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2023 16:58:46 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7E96B5F0
        for <linux-scsi@vger.kernel.org>; Fri,  6 Jan 2023 13:58:46 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id d15so3093886pls.6
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2023 13:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4fJCGE9oYdlm1zb/TUVhyb89V4A1QfzgYBtlpKexdU=;
        b=71VD5469havz8dNLyJmTVN7e6FvK9rtil5o8MqfV5fT5kD59MdXJ69xn+Yl824OyIj
         JChtc2aNW4iHRHpzKVZ2Nvo8JwvMwkd6YlHW5WHAw7mtGOyEW6IgfEAXjVOYpq8NcegT
         npuB8oqT6o450hk3aWB8e4no1+SsoeF/A2hfdxAT7T/H8AQkXhDXUDQtIBNQ9TSqiICC
         I3wV3BzFuGvtofsD7d8M/mIyu6DmpS3s5DaX4EYSem+jfd9CeSnF1UeNQksooVErSVFV
         /ygR0SwTw+dt9YdjDb36rCcqrsBHpPmvgVaxWavg3bylnCJW8WUNiFo3K9BSUSqJJoBg
         uxPg==
X-Gm-Message-State: AFqh2kp0jWt0oBERQSOixK2ghXVTAp/os1c4AHklsFonn1U8bUb525co
        s4H5fW8GDgCyueNH/vaWKwY=
X-Google-Smtp-Source: AMrXdXsW9r2sPa9kaEmdpOJhWseGNlvrUzCBfVkxeOWGX1vtZf+PP68u7JtrnaNirtysfJ9NiiR7ig==
X-Received: by 2002:a17:902:8481:b0:192:b5b3:b800 with SMTP id c1-20020a170902848100b00192b5b3b800mr25604120plo.39.1673042325310;
        Fri, 06 Jan 2023 13:58:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:23c3:f25b:a19d:c75a])
        by smtp.gmail.com with ESMTPSA id ij30-20020a170902ab5e00b00193198ffeddsm281154plb.30.2023.01.06.13.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 13:58:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 1/3] scsi: ufs: Exynos: Fix DMA alignment for PAGE_SIZE != 4096
Date:   Fri,  6 Jan 2023 13:57:58 -0800
Message-Id: <20230106215800.2249344-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230106215800.2249344-1-bvanassche@acm.org>
References: <20230106215800.2249344-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Exynos UFS controller only supports scatter/gather list elements
that are aligned on a 4 KiB boundary. Fix DMA alignment in case
PAGE_SIZE != 4096. Rename UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE into
UFSHCD_QUIRK_4KB_DMA_ALIGNMENT.

Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Fixes: 2b2bfc8aa519 ("scsi: ufs: Introduce a quirk to allow only page-aligned sg entries")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c     | 4 ++--
 drivers/ufs/host/ufs-exynos.c | 2 +-
 include/ufs/ufshcd.h          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 99ca5b035028..be18edf4ef7f 100644
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
index dd5912b4db77..583611444f12 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -567,9 +567,9 @@ enum ufshcd_quirks {
 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
 
 	/*
-	 * This quirk allows only sg entries aligned with page size.
+	 * Align DMA SG entries on a 4 KiB boundary.
 	 */
-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 << 14,
 
 	/*
 	 * This quirk needs to be enabled if the host controller does not
