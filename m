Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74FEEE4998
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359492AbjHRTqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379866AbjHRTpx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:45:53 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949B44B5;
        Fri, 18 Aug 2023 12:45:32 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bee82fad0fso9942025ad.2;
        Fri, 18 Aug 2023 12:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387860; x=1692992660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FAIQKgLHklFdKNw8QYfKTGv+/r8dWNnrRjcsYXO8i4g=;
        b=Gyl5zbWTt8PaIJhBMVgG3kAL7gfMLAI32nlTJQ9eZQ3MXF0iUqHqcwVl6yrVbbGZpk
         BAC64ttGM6o2Aqc152xCeR1UvsZCGpqmH7rgVmbyztgohcFW4ppy486VY2DRomO3RrBK
         xq778UyCHMqSt1OxLga8TpzVFh49DSS99ZOCb/oHsV/dgQWoRNfGf5ZbSKRiGd+WwbWJ
         tUFImqBOHuTbrX/Qa+ffmqJRg4UH0GaSCBzV5PNk7kC+OjH+ZorWt02o/YlVKHACQ9Oo
         uCgKTq5wbNT1W8fzlBUXu6XY1CK2b3GcRIpcd7b8d38WXx1UipuH6ggICRhvSnvre6hR
         0dBw==
X-Gm-Message-State: AOJu0YwLKZkgrpj3vwxPivvSc0GqNx9x1RuLdMHu+lYiHjDDpMCBc2cv
        +Vtx0TE0YTMDzVGWB03bVhw=
X-Google-Smtp-Source: AGHT+IGJSJR3wKxhjL++9jaUMFFqASt4AEGcsOW2dxNGxK55rffvi+frwODR8BinIKDeRJAWQlspnA==
X-Received: by 2002:a17:902:da81:b0:1be:e7eb:32fe with SMTP id j1-20020a170902da8100b001bee7eb32femr47409plx.45.1692387859794;
        Fri, 18 Aug 2023 12:44:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:44:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Zhe Wang <zhe.wang1@unisoc.com>
Subject: [PATCH v10 14/18] scsi: ufs: sprd: Rework the code for disabling auto-hibernation
Date:   Fri, 18 Aug 2023 12:34:17 -0700
Message-ID: <20230818193546.2014874-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call ufshcd_auto_hibern8_update() instead of writing directly into the
auto-hibernation control register. This patch is part of an effort to
move all auto-hibernation register changes into the UFSHCI driver core.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-sprd.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 2bad75dd6d58..15a1876656a7 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -180,15 +180,8 @@ static int sprd_ufs_pwr_change_notify(struct ufs_hba *hba,
 static int ufs_sprd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 			    enum ufs_notify_change_status status)
 {
-	unsigned long flags;
-
-	if (status == PRE_CHANGE) {
-		if (ufshcd_is_auto_hibern8_supported(hba)) {
-			spin_lock_irqsave(hba->host->host_lock, flags);
-			ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
-		}
-	}
+	if (status == PRE_CHANGE)
+		WARN_ON_ONCE(ufshcd_auto_hibern8_update(hba, 0) != 0);
 
 	return 0;
 }
