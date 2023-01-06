Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C9BC61DB3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Jan 2023 21:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjAFV7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjAFV7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2023 16:59:07 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71697FEEF
        for <linux-scsi@vger.kernel.org>; Fri,  6 Jan 2023 13:59:06 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id jn22so3062941plb.13
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2023 13:59:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MzMXRQF74lhnOR3E1rjd7Vd2RzD+3XuXhhoIpu7qYc=;
        b=oRodCmLAZb5c+WCIaa51mp6sL6FBoxntqYYtu5bimkKidJcVhubP/5WWzMP3Hw5tsl
         ngJe2H4oKmTLXM41c1ixQ8zSw4yPZoa10TdN52/0UyS57Vd882iSZ3ASSzCFHGvj4i6J
         Gw0gWHCt1GnHY1vs+PfDAw9q64eBmocprRddetzkMjdhW45PH05/RQ3ZgKjm9FIxUZaN
         fX+mr1S0FSJXXU9sZV5zJp80F65g7jjeGh+vWul1nCNZ+iJXRiaXlLIrki/SIm7dN0kp
         OkTKLLeTeMz3F8wOHHUfWiPkZVXTneSt3lSCivUMnbDr2utbmXdvpTy8NDjPXT4wMU5M
         BQzg==
X-Gm-Message-State: AFqh2kp26mV3tdIXyFPJBjh8MZO9qNID5S752GAj3ywV1ZDKC+2Teb1w
        2F5eMMdbxHzD75mXEx06P14=
X-Google-Smtp-Source: AMrXdXvfSQ9iGZy9FrnagdWi2sQD4Gy+VXKvCFgbf/kCytd2M/aUoM3F9B1LgDB9j6r2pT1UXOgzTw==
X-Received: by 2002:a17:902:d386:b0:192:feec:5f7b with SMTP id e6-20020a170902d38600b00192feec5f7bmr6232622pld.54.1673042346287;
        Fri, 06 Jan 2023 13:59:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:23c3:f25b:a19d:c75a])
        by smtp.gmail.com with ESMTPSA id ij30-20020a170902ab5e00b00193198ffeddsm281154plb.30.2023.01.06.13.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 13:59:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 3/3] scsi: ufs: Enable DMA clustering
Date:   Fri,  6 Jan 2023 13:58:00 -0800
Message-Id: <20230106215800.2249344-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230106215800.2249344-1-bvanassche@acm.org>
References: <20230106215800.2249344-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All UFS host controllers support DMA clustering. Hence enable DMA
clustering.

Note: without patch "Exynos: Fix the maximum segment size", this patch
breaks support for the Exynos controller.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index be18edf4ef7f..fe83fdda8d23 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8429,7 +8429,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
-	.dma_boundary		= PAGE_SIZE - 1,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
 
