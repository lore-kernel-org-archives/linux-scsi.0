Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748EFC54EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 23:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjALXnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjALXnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 18:43:16 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BDF13F97
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:43:15 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id 17so21819514pll.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:43:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=odjet1nvQzuOAlS4LvhxN9LGiz4ybZNsAPnnYL7GZyU=;
        b=JTqRGFTDah/29QKBi+Uz4LBe/nYU64col8SzYbT2w0fFlApKJ60aHcsRa/t9ueav+h
         bk6WtOgHCourFd7Yc5XD6KZuaQkRUqFm9spVRxy0QHuq2RYqzCUONI96iWzYKib5s6Xw
         FNNufXo8z/DmQNKy8TyrD31+mjDbKv1EE0+4MYyFvFUtSF5JtKmmPHeukEQCBBYF2H7g
         yyWDOxOE1tRz3xSN8GfDRkjb2ciUabtLG+wOOTcBPJJjyRaQXoKS0+82U4y/nFJ2vdUp
         XBYh47jDsn4E9SZIWl091vpCXv8iKu5hVHv8HhKZ4DMPgqJlWbC9I9MJcatwxucmaOcT
         7ADA==
X-Gm-Message-State: AFqh2koFpa38F9lkT7KmbfmpaUBrZsCt2JlV+WeBFYGemdmb+BxVI/JV
        yxy8QxWZKx92zO16XIQZkVw=
X-Google-Smtp-Source: AMrXdXsMNJCzri8wGm8CVCVm8IippmGILAOqZNmnt99Dn9JDdpYYg2zc1++3rgmCU0ICsvlW/i6B8A==
X-Received: by 2002:a17:902:d587:b0:194:457d:6dca with SMTP id k7-20020a170902d58700b00194457d6dcamr11085436plh.44.1673566995083;
        Thu, 12 Jan 2023 15:43:15 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3345:7bfe:9541:882b])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090322c300b0017f8094a52asm12764795plg.29.2023.01.12.15.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 15:43:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 2/3] scsi: ufs: Exynos: Fix the maximum segment size
Date:   Thu, 12 Jan 2023 15:42:14 -0800
Message-Id: <20230112234215.2630817-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230112234215.2630817-1-bvanassche@acm.org>
References: <20230112234215.2630817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for enabling DMA clustering and also for supporting
PAGE_SIZE != 4096 by declaring explicitly that the maximum segment
size is 4096 bytes for Exynos UFS host controllers. Add this code
in exynos_ufs_hce_enable_notify() such that it happens after
scsi_host_alloc() and before __scsi_init_queue() is called by the
LUN scanning code.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-exynos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3cdac89a28b8..7c985fc38db1 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1300,6 +1300,14 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
+		/*
+		 * The maximum segment size must be set after scsi_host_alloc()
+		 * has been called and before LUN scanning starts
+		 * (ufshcd_async_scan()). Note: this callback may also be called
+		 * from other functions than ufshcd_init().
+		 */
+		hba->host->max_segment_size = 4096;
+
 		if (ufs->drv_data->pre_hce_enable) {
 			ret = ufs->drv_data->pre_hce_enable(ufs);
 			if (ret)
