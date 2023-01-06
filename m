Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E55C54EBD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Jan 2023 21:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjAFV7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjAFV66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2023 16:58:58 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD646B5F0
        for <linux-scsi@vger.kernel.org>; Fri,  6 Jan 2023 13:58:57 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so6578508pjg.5
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2023 13:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l8HHyTcD4fX3Frcts/+Zyxq+18lILRtslKksnoq1yls=;
        b=cB0bdOcAXc4w3JzHQ+9gOwIGv75qOQztaDBgEFdlZa3DrMvNlxfcJdYM7XwsFLqGR7
         NpOvuTy2o0OxF4rTiwmBD5Up1EXCi7JPuJPMXgkT9C+dXTGixAVVc5L5zDZHR1omaX8b
         Og7v3iPLxFVfsdGO6rGbe24W6l7trcQ44VJg1fArUUKWbxrLKPXfZvjmbpEcdpNhD071
         iicErcbD5J9sz2ag7GpIXZYHucIOmPCAT7/Y9YHcaEPdOil4uxtPWNk6LA7iLgQtMSCp
         AnhykdkwYY7xvsSzjmUIs+e48uuzEmp+m5DElLGX69bxQLJmRlpKF8VqcEc1DAsdmqHI
         3UMg==
X-Gm-Message-State: AFqh2kqBPzQqVpazycAQ8P+soiG+ECcHtYRBrPftsfuLpSvW1XO7aQ7v
        vvHAnGGehA2LwPZOvids+wI=
X-Google-Smtp-Source: AMrXdXvyXMZXFe/xAlH2OQcPZT1iwIiY9GXtZ+1J1mckICIW82IwUhCPnXs76Fk33xuxAsBoJkzCtA==
X-Received: by 2002:a17:902:680e:b0:192:4d1a:c51d with SMTP id h14-20020a170902680e00b001924d1ac51dmr58349676plk.32.1673042337069;
        Fri, 06 Jan 2023 13:58:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:23c3:f25b:a19d:c75a])
        by smtp.gmail.com with ESMTPSA id ij30-20020a170902ab5e00b00193198ffeddsm281154plb.30.2023.01.06.13.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 13:58:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 2/3] scsi: ufs: Exynos: Fix the maximum segment size
Date:   Fri,  6 Jan 2023 13:57:59 -0800
Message-Id: <20230106215800.2249344-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230106215800.2249344-1-bvanassche@acm.org>
References: <20230106215800.2249344-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for enabling DMA clustering and also for supporting
PAGE_SIZE != 4096 by declaring explicitly that the maximum segment
size is 4096 bytes for Exynos UFS host controllers.

Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-exynos.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3cdac89a28b8..821c000ca6b0 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1586,15 +1586,21 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 	const struct ufs_hba_variant_ops *vops = &ufs_hba_exynos_ops;
 	const struct exynos_ufs_drv_data *drv_data =
 		device_get_match_data(dev);
+	struct ufs_hba *hba;
 
 	if (drv_data && drv_data->vops)
 		vops = drv_data->vops;
 
 	err = ufshcd_pltfrm_init(pdev, vops);
-	if (err)
+	if (err) {
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+		return err;
+	}
+
+	hba = dev_get_drvdata(dev);
+	hba->host->max_segment_size = 4096;
 
-	return err;
+	return 0;
 }
 
 static int exynos_ufs_remove(struct platform_device *pdev)
