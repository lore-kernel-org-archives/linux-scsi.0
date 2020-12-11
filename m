Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366CBC2BB9A
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 010D723ED2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405077AbgLKOBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395187AbgLKOBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:01:44 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6D2C06179C;
        Fri, 11 Dec 2020 06:00:52 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so12438136ejb.13;
        Fri, 11 Dec 2020 06:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r7avsLazbZX9dvU8Tg2nAQdER6pLqpE9+qG8bfjeftM=;
        b=dwmFFwZc99d/3nDJ/2pSBeVKX3qWS7FwI83wvV5vjwZfnhbuL9NQPZn8FYcnGs9q0P
         JPNyUO4CYhsg9PhmABjEj81priABl307EDrYEUt1HryOBWuCB1i6Y7OybmlpNhPXiPfo
         HRlBIBz1tjjFSr/7GAec/KjS8h+BCoMlkuHlf1+LFJowicy6WY2W8nHuTsZ5ecUm9t1j
         FCacKkF5+H5LYsxACrn0+x6dusOwuPlHAr4hTUofIcJaDHOQqVhtrbmOBOmOVCBYYoFc
         gSgm7UMTFYU6JUEmsdwx6uS5rSSL3DehuI4yl1XpS9ZmV5IoDAQAkPemUffv7eTeVhbw
         BhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r7avsLazbZX9dvU8Tg2nAQdER6pLqpE9+qG8bfjeftM=;
        b=DzFHfAuyeGsXqtPmgdkLvMq9rUrAR+99rcV6Nn/ZjMVT/URw3jP2azMni6vPtY82AH
         7icYlWgW7bPU3LsUisdKM44mkOFMMNNtZCg7Yj1qmhEz63cQHZWE64AVBs8gkgAlkxqe
         djWwe+3FDStnFWFDalbf9NV6sY4qaFlq8E0PUeqsXOW9X3OiNvW1I8fjNfPfmcTjL7nk
         T8nLbJlfxgRu91sFPNEjnQI6djFGAyZlpiLc3WW8sOJJeB5iTfH12+MoxQS151vbcWvz
         N1VPvZl6OQGJB0CwfzjpyiPYOZ6F4DdfUYHgJZpkeqFa9ErkOtg3mXhmpl2abu1hG1GZ
         yCcw==
X-Gm-Message-State: AOAM531IeoRtxBqhNc1lZ9WQC4c3sSX8Jrdl7jJLnAkaw19sV46FAGLw
        wH90AzZN186s4a4sE5CSoKg=
X-Google-Smtp-Source: ABdhPJwNuczM71eE2ghLGJvtL/gDQz7vkH5A+d+U47OsL6T1pHpoA+DlwF01CJfdCsBX8RMLuAYSuw==
X-Received: by 2002:a17:906:3881:: with SMTP id q1mr11245093ejd.490.1607695251484;
        Fri, 11 Dec 2020 06:00:51 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:51 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/6] scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
Date:   Fri, 11 Dec 2020 15:00:32 +0100
Message-Id: <20201211140035.20016-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211140035.20016-1-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

UFS device-related flags should be grouped in ufs_dev_info. Take
wb_enabled and wb_buf_flush_enabled out from the struct ufs_hba,
group them to struct ufs_dev_info, and align the names of the structure
members vertically

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufs.h       | 33 +++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.c    | 16 ++++++++--------
 drivers/scsi/ufs/ufshcd.h    |  2 --
 4 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 2b4e9fe935cc..4bd7e18bb486 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -194,7 +194,7 @@ static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->wb_enabled);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->dev_info.wb_enabled);
 }
 
 static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14dfda735adf..45bebca29fdd 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -527,22 +527,27 @@ struct ufs_vreg_info {
 };
 
 struct ufs_dev_info {
-	bool f_power_on_wp_en;
+	bool	f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
-	bool is_lu_power_on_wp;
+	bool	is_lu_power_on_wp;
 	/* Maximum number of general LU supported by the UFS device */
-	u8 max_lu_supported;
-	u8 wb_dedicated_lu;
-	u16 wmanufacturerid;
-	/*UFS device Product Name */
-	u8 *model;
-	u16 wspecversion;
-	u32 clk_gating_wait_us;
-	u32 d_ext_ufs_feature_sup;
-	u8 b_wb_buffer_type;
-	u32 d_wb_alloc_units;
-	bool b_rpm_dev_flush_capable;
-	u8 b_presrv_uspc_en;
+	u8	max_lu_supported;
+	u16	wmanufacturerid;
+	/* UFS device Product Name */
+	u8	*model;
+	u16	wspecversion;
+	u32	clk_gating_wait_us;
+	u32	d_ext_ufs_feature_sup;
+
+	/* UFS WB related flags */
+	bool	wb_enabled;
+	bool	wb_buf_flush_enabled;
+	u8	wb_dedicated_lu;
+	u8	b_wb_buffer_type;
+	u32	d_wb_alloc_units;
+
+	bool	b_rpm_dev_flush_capable;
+	u8	b_presrv_uspc_en;
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a5532b752aa..528c257df48c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -589,8 +589,8 @@ static void ufshcd_device_reset(struct ufs_hba *hba)
 	if (!err) {
 		ufshcd_set_ufs_dev_active(hba);
 		if (ufshcd_is_wb_allowed(hba)) {
-			hba->wb_enabled = false;
-			hba->wb_buf_flush_enabled = false;
+			hba->dev_info.wb_enabled = false;
+			hba->dev_info.wb_buf_flush_enabled = false;
 		}
 	}
 	if (err != -EOPNOTSUPP)
@@ -5359,7 +5359,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 	if (!ufshcd_is_wb_allowed(hba))
 		return 0;
 
-	if (!(enable ^ hba->wb_enabled))
+	if (!(enable ^ hba->dev_info.wb_enabled))
 		return 0;
 	if (enable)
 		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
@@ -5375,7 +5375,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 		return ret;
 	}
 
-	hba->wb_enabled = enable;
+	hba->dev_info.wb_enabled = enable;
 	dev_dbg(hba->dev, "%s write booster %s %d\n",
 			__func__, enable ? "enable" : "disable", ret);
 
@@ -5415,7 +5415,7 @@ static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba)
 	int ret;
 	u8 index;
 
-	if (!ufshcd_is_wb_allowed(hba) || hba->wb_buf_flush_enabled)
+	if (!ufshcd_is_wb_allowed(hba) || hba->dev_info.wb_buf_flush_enabled)
 		return 0;
 
 	index = ufshcd_wb_get_query_index(hba);
@@ -5426,7 +5426,7 @@ static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
 			__func__, ret);
 	else
-		hba->wb_buf_flush_enabled = true;
+		hba->dev_info.wb_buf_flush_enabled = true;
 
 	dev_dbg(hba->dev, "WB - Flush enabled: %d\n", ret);
 	return ret;
@@ -5437,7 +5437,7 @@ static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba)
 	int ret;
 	u8 index;
 
-	if (!ufshcd_is_wb_allowed(hba) || !hba->wb_buf_flush_enabled)
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_buf_flush_enabled)
 		return 0;
 
 	index = ufshcd_wb_get_query_index(hba);
@@ -5448,7 +5448,7 @@ static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba)
 		dev_warn(hba->dev, "%s: WB - buf flush disable failed %d\n",
 			 __func__, ret);
 	} else {
-		hba->wb_buf_flush_enabled = false;
+		hba->dev_info.wb_buf_flush_enabled = false;
 		dev_dbg(hba->dev, "WB - Flush disabled: %d\n", ret);
 	}
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2a97006a2c93..45c3eca88f0e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -805,8 +805,6 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
-	bool wb_buf_flush_enabled;
-	bool wb_enabled;
 	struct delayed_work rpm_dev_flush_recheck_work;
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
-- 
2.17.1

