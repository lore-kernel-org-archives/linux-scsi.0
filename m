Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BA6C54EBE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 23:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjALXn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjALXnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 18:43:25 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB6C13F97
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:43:25 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id jn22so21746636plb.13
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=in8QxhKYqG4kGyNbhqnqAwe065UiH75TZ6GdzajJjfQ=;
        b=khRgZ8mksKdPXDcJY5HjJKgsONf49wkeKaMkFgPx/E0F76/ZJEUCytQsfQMuxOEe5V
         X4RBYVrz/Z97dSiGk1QzW1sYEZ/i4ERQIEIA6mUje87Zs8XqQNTqTwQ0vBl9D9zt24J1
         8M3LRU8mUUTW2BIjxVvoQpV3EOwDcOv8ze+3vJGZxhxx8Tqa+kpwamgKoPdIAE+cfnI9
         QPgsmpyKfXbRYsaqNq/M88wO1IYiViIGvynA7yY5Qgbxafi0QRudrEyY/bEBiI7vJ2JO
         F/I9A8MPqrjBv/FomJiR3ETqRbbC0FxwlGCi7pn6lEvbGeUqKss3sFtXP3bjQ674sk/N
         WEtA==
X-Gm-Message-State: AFqh2koZAlLvBlOCzEkHKggXRYGnoEBp/OF933TTa8pIGV1JTfHE0eVQ
        G4VaC8bj1RQOO9LGuIXMQ04=
X-Google-Smtp-Source: AMrXdXsWv7djADvhLeL3Jz8sp1DHg7SVro9ttUF/jVCCILfK+cCFzMMgvqWoNEUCWriBnZZtNFWlsQ==
X-Received: by 2002:a17:903:40c9:b0:194:45d0:3b21 with SMTP id t9-20020a17090340c900b0019445d03b21mr10796347pld.4.1673567004468;
        Thu, 12 Jan 2023 15:43:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3345:7bfe:9541:882b])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090322c300b0017f8094a52asm12764795plg.29.2023.01.12.15.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 15:43:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 3/3] scsi: ufs: Enable DMA clustering
Date:   Thu, 12 Jan 2023 15:42:15 -0800
Message-Id: <20230112234215.2630817-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230112234215.2630817-1-bvanassche@acm.org>
References: <20230112234215.2630817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All UFS host controllers support DMA clustering. Hence enable DMA
clustering.

Notes:
- The max_segment_size parameter implements the 256 KiB limit for the
  PRDT. The dma_boundary parameter represents a boundary that must not
  be crossed by DMA scatter/gather lists. I'm not aware of any
  restrictions on DMA scatter/gather lists in the UFSHCI specification
  other than the 256 KiB limit for the PRDT and the 32-bit address
  restriction for controllers that only support 32-bits DMA. The latter
  restriction is already handled by ufshcd_set_dma_mask().
- Without patch "Exynos: Fix the maximum segment size", this patch
  breaks support for the Exynos controller.

The history of the dma_boundary parameter in the UFS driver is as
follows:
* The initial UFS driver did not set the dma_boundary parameter.
* Commit 4dd4130a722f ("scsi: make sure all drivers set the
  use_clustering flag") set the .use_clustering flag.
* Commit 4af14d113bcf ("scsi: remove the use_clustering flag") removed
  the use_clustering flag and set the dma_boundary parameter instead.

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5fdbc983ce2e..d28b44a1ffcf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8460,7 +8460,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
-	.dma_boundary		= PAGE_SIZE - 1,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
 
