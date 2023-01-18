Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087E2C38147
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjARWzd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjARWzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:11 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F33B468;
        Wed, 18 Jan 2023 14:55:11 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id d3so566319plr.10;
        Wed, 18 Jan 2023 14:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4iBtXHjSJgcJqJAuc3ZI/3Wh+WcZqDuUJSQ66mgoGQ=;
        b=7BtFzqL3fmAmgJyx6xo4SAoRIuFxQ8uykPMYDjUuGmxeqOvX7PSaJ2bpjdaA5XXcDo
         N5UzQ0eIGVvkuWP4a8B7UFYgu3aFAujY5mABwPJc+stS1RK/dZTryaD+6nD9e45NuiQF
         YvKlWbTTtwI8CoOUUvuDEW9sVedjgpuKgDHDu4rNvbiKaevpe+EzJbV4MRyGJWyF9KMZ
         uDpFoA+2jPtrzPyrsTT7czBSKk4rJcRYZSAQoVvJSVRF5MB3tPMg+AJBD5QuxmYFZ6ML
         ju6TRmwXxpvjkZ91fjWvj669k8Du04lxh6Zz1go5B1P1PYOp3/hnMHedStm2QqRY+GqZ
         RqsA==
X-Gm-Message-State: AFqh2kq2UmHYoh5GhSqozbsXK52aSzazmsga34/mrjB3YVH4BzMdro+v
        qGd64Ck3Vlttbr+1pEtS+CE=
X-Google-Smtp-Source: AMrXdXs478pkhRkiVXxjniYY/Ww1GTTsv4PcTU8Ab9oYSqljYBV19BC4RHPZlTH4dDBaIRS+PadWuQ==
X-Received: by 2002:a17:903:32c1:b0:194:7c95:dc3c with SMTP id i1-20020a17090332c100b001947c95dc3cmr12594316plr.12.1674082510455;
        Wed, 18 Jan 2023 14:55:10 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:55:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 9/9] scsi: ufs: exynos: Select CONFIG_BLK_SUB_PAGE_SEGMENTS for lage page sizes
Date:   Wed, 18 Jan 2023 14:54:47 -0800
Message-Id: <20230118225447.2809787-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the maximum segment size supported by the Exynos controller is 4
KiB, this controller needs CONFIG_BLK_SUB_PAGE_SEGMENTS if the page size
exceeds 4 KiB.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 4cc2dbd79ed0..376a4039912d 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -117,6 +117,7 @@ config SCSI_UFS_TI_J721E
 config SCSI_UFS_EXYNOS
 	tristate "Exynos specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
+	select BLK_SUB_PAGE_SEGMENTS if PAGE_SIZE > 4096
 	help
 	  This selects the Samsung Exynos SoC specific additions to UFSHCD
 	  platform driver.  UFS host on Samsung Exynos SoC includes HCI and
