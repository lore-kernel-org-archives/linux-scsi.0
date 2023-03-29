Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D945CC74A5B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 20:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjC2Uz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC2UzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 16:55:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998641994
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680123279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OQ6DIn1YEzF2eFVCrxeziQbpL44t5tqKpOV+4H9/a0M=;
        b=YlvnIGETziQyuEKqZwi2YDX8f3dt58Sioku/zhZjaPUkl2Gpad/b6XWeoIpWsjj5pepULB
        6BqC16zDV3WuGqRFkwu4XfzQgZys7DjT4eYcsBhimvJFI+lBGRoTCfiPAiaTES6tjwV1mM
        OLVJ4hj0uy01dEZTMJMD6aEZytRWJ4E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-F5PrYeAFNLyHxzBCS5Fcbg-1; Wed, 29 Mar 2023 16:54:38 -0400
X-MC-Unique: F5PrYeAFNLyHxzBCS5Fcbg-1
Received: by mail-qt1-f200.google.com with SMTP id bp6-20020a05622a1b8600b003e62de3e64aso1017209qtb.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680123277;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQ6DIn1YEzF2eFVCrxeziQbpL44t5tqKpOV+4H9/a0M=;
        b=ejSWO9IJjij+dkGbKOmUrQAo4oMMyFPnzBoqVbFqbZHdxL6poKr/Cljp153fmbBpER
         imAScAqAnmBx059Y5oOEQ0MWIBJHdNwvQScEgI+cY+U7malkbuaesoGAixYh7sW1jybG
         1yvrGi0jOG4AUn0YCHTugDEreUuiF9CjDVDsnBVsb9rBzLUNyfhD9Z6Pc4KbNpsANrS+
         XvB6vpgV4b60C2Y/KFdql3brn7cgNuVvLB+Z/XxrQbnymiOS89fABYJI1xVsaMLjK4ty
         TU/94q82TGkVt0qUmP5rxcW1bwu0QC4iv6VMdoM+UbW09isl+Zkw0eUEHy07jgYSYxeV
         OhCg==
X-Gm-Message-State: AAQBX9dE9PqqzEly5m9oHXftYBgvw/RxiXpsyixGQhBJPlnEonliLsk/
        cbYJMOYhs02y8BklKNAhOtHeI75l/LDviqTQPfrA2fSwPBrZr27LWp3BnRI2FvBqqW6sbrH+MTM
        X3hsKUXNKJ3D+Un4JK0W/9Q==
X-Received: by 2002:ac8:7d8d:0:b0:3e3:8ed5:a47e with SMTP id c13-20020ac87d8d000000b003e38ed5a47emr33817179qtd.10.1680123277714;
        Wed, 29 Mar 2023 13:54:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set9anI3P1EloWen7CTscugPdBA5vmKtkdwJZiuO4gwYDMbs9IZSnD7zHHGigKH2C6wQZlmFAlw==
X-Received: by 2002:ac8:7d8d:0:b0:3e3:8ed5:a47e with SMTP id c13-20020ac87d8d000000b003e38ed5a47emr33817154qtd.10.1680123277427;
        Wed, 29 Mar 2023 13:54:37 -0700 (PDT)
Received: from fedora.redhat.com (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id r20-20020a37a814000000b00746ae84ea6csm8719866qke.3.2023.03.29.13.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 13:54:36 -0700 (PDT)
From:   Adrien Thierry <athierry@redhat.com>
To:     Stanley Chu <chu.stanley@gmail.com>, peter.wang@mediatek.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adrien Thierry <athierry@redhat.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] Revert "scsi: ufs: core: Initialize devfreq synchronously"
Date:   Wed, 29 Mar 2023 16:54:25 -0400
Message-Id: <20230329205426.46393-1-athierry@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit 7dafc3e007918384c8693ff8d70381b5c1e9c247.

This patch introduced a regression [1] where hba->pwr_info is used
before being initialized, which could create issues in
ufshcd_scale_gear(). Revert it until a better solution is found.

[1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Signed-off-by: Adrien Thierry <athierry@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 47 +++++++++++++--------------------------
 include/ufs/ufshcd.h      |  1 -
 2 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 37e178a9ac47..70b112038792 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1409,13 +1409,6 @@ static int ufshcd_devfreq_target(struct device *dev,
 	struct ufs_clk_info *clki;
 	unsigned long irq_flags;
 
-	/*
-	 * Skip devfreq if UFS initialization is not finished.
-	 * Otherwise ufs could be in a inconsistent state.
-	 */
-	if (!smp_load_acquire(&hba->logical_unit_scan_finished))
-		return 0;
-
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
 
@@ -8399,6 +8392,22 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	/* Initialize devfreq after UFS device is detected */
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		memcpy(&hba->clk_scaling.saved_pwr_info.info,
+			&hba->pwr_info,
+			sizeof(struct ufs_pa_layer_attr));
+		hba->clk_scaling.saved_pwr_info.is_valid = true;
+		hba->clk_scaling.is_allowed = true;
+
+		ret = ufshcd_devfreq_init(hba);
+		if (ret)
+			goto out;
+
+		hba->clk_scaling.is_enabled = true;
+		ufshcd_init_clk_scaling_sysfs(hba);
+	}
+
 	ufs_bsg_probe(hba);
 	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
@@ -8670,12 +8679,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_hba_exit(hba);
-	} else {
-		/*
-		 * Make sure that when reader code sees UFS initialization has finished,
-		 * all initialization steps have really been executed.
-		 */
-		smp_store_release(&hba->logical_unit_scan_finished, true);
 	}
 }
 
@@ -10316,30 +10319,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
-	/* Initialize devfreq */
-	if (ufshcd_is_clkscaling_supported(hba)) {
-		memcpy(&hba->clk_scaling.saved_pwr_info.info,
-			&hba->pwr_info,
-			sizeof(struct ufs_pa_layer_attr));
-		hba->clk_scaling.saved_pwr_info.is_valid = true;
-		hba->clk_scaling.is_allowed = true;
-
-		err = ufshcd_devfreq_init(hba);
-		if (err)
-			goto rpm_put_sync;
-
-		hba->clk_scaling.is_enabled = true;
-		ufshcd_init_clk_scaling_sysfs(hba);
-	}
-
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
 	device_enable_async_suspend(dev);
 	return 0;
 
-rpm_put_sync:
-	pm_runtime_put_sync(dev);
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 25aab8ec4f86..431c3afb2ce0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -979,7 +979,6 @@ struct ufs_hba {
 	struct completion *uic_async_done;
 
 	enum ufshcd_state ufshcd_state;
-	bool logical_unit_scan_finished;
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
-- 
2.39.2

