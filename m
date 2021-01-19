Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D81C4161F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A648320776
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbhASQrr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbhASQk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:40:26 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6244EC0613CF;
        Tue, 19 Jan 2021 08:39:09 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id bx12so8286193edb.8;
        Tue, 19 Jan 2021 08:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WSF3D1UQd7f4AtR6+YB5wSyLd637YNH+sG8P7bFuhZ8=;
        b=IO7DWS0hMZa2HquUoaCMrOzIIrephnp+BO9YR+ZUYxeBMW8LVpYtiWGSllqnTa9JOf
         UnFUTL3D3u40smhNcr5SyDljYjizxAuTWcX7rqD8fuT2HXqgJ3a7rrZqgsWw5uYqgizk
         vp7UxVi6/wPH8ieUAlHsBuMIJE0MjYXnhQowmzn4Hxif4uHklUImpxSleOcIq9vbni4L
         gX0G9Lz4Iio6vln8E53LTJygRleQGYi69vLwUkHaSnmL77+Env2hMZeuHekRM2LUl20l
         /+fAP7p3Svi2dj/mAXqjB90p0NyfPv+5YBID2Zgra9kEfRPm91SUqO4Z9TLrk1RpUnh6
         Yz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WSF3D1UQd7f4AtR6+YB5wSyLd637YNH+sG8P7bFuhZ8=;
        b=b9HLUIcvjeMCq8ZKcaz3+AGHeyFK86mwBWcCnzhI2Kmg56CydK4MF5N2WDYbYPJL2A
         XbM2a2i5J52RAg8dcP18CzEK8XrPIhpugmbCfT3Cchr7tEVGYs6BQ52aR8OrhLwXFdfy
         Or8lW/Tj7drVqIdyWpbV4xhx8W7YIKga0v+/+YV1jkBXWjHHno738DbWSP0CP8+Y2Rv1
         dCWK9BsJNZg8n2uy9iLD+E+rC0lRwoGV5/rnTeIuKUCje7v4Iad+xdI0h1ZZGtHbpRu4
         LJiLnIyoUKt6Lpscr3X81h0U8HZKmA2LzlgHBbzGMXoT7Gr5P4dWGwpulDe0rI7H1XDc
         D1LQ==
X-Gm-Message-State: AOAM530iyGtSUAZkkGzaXNiSmcuyJxrdCOcC1ZRSpQn4AQMu7/YB2/U0
        5DvOEiwxDpCH2G0ca0O4iQo=
X-Google-Smtp-Source: ABdhPJyzOB79wuyvLUkeiuXVcyNCl9OrvATpN+1ylyZOWRwrgxuj0vhYeSGiQXkmreOFEZ21+Tzn6A==
X-Received: by 2002:a50:bf4a:: with SMTP id g10mr3954191edk.201.1611074348078;
        Tue, 19 Jan 2021 08:39:08 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:39:07 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 5/6] scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
Date:   Tue, 19 Jan 2021 17:38:46 +0100
Message-Id: <20210119163847.20165-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

UFS device-related flags should be grouped in ufs_dev_info. Take
wb_enabled and wb_buf_flush_enabled out from the struct ufs_hba,
group them to struct ufs_dev_info, and align the names of the structure
members vertically.

Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufs.h       | 27 ++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.c    | 21 ++++++++++-----------
 drivers/scsi/ufs/ufshcd.h    |  4 +---
 4 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 76db8593ca09..acc54f530f2d 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -214,7 +214,7 @@ static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
+	return sysfs_emit(buf, "%d\n", hba->dev_info.wb_enabled);
 }
 
 static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index a8000ed0017e..bf1897a72532 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -527,20 +527,25 @@ struct ufs_vreg_info {
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
+	u8	max_lu_supported;
+	u16	wmanufacturerid;
 	/*UFS device Product Name */
-	u8 *model;
-	u16 wspecversion;
-	u32 clk_gating_wait_us;
-	u8 b_wb_buffer_type;
-	bool b_rpm_dev_flush_capable;
-	u8 b_presrv_uspc_en;
+	u8	*model;
+	u16	wspecversion;
+	u32	clk_gating_wait_us;
+
+	/* UFS WB related flags */
+	bool    wb_enabled;
+	bool    wb_buf_flush_enabled;
+	u8	wb_dedicated_lu;
+	u8      wb_buffer_type;
+
+	bool	b_rpm_dev_flush_capable;
+	u8	b_presrv_uspc_en;
 };
 
 /*
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f6fe14b60eff..4f40891ea429 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -606,8 +606,8 @@ static void ufshcd_device_reset(struct ufs_hba *hba)
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
@@ -5421,7 +5421,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 	if (!ufshcd_is_wb_allowed(hba))
 		return 0;
 
-	if (!(enable ^ hba->wb_enabled))
+	if (!(enable ^ hba->dev_info.wb_enabled))
 		return 0;
 	if (enable)
 		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
@@ -5437,7 +5437,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 		return ret;
 	}
 
-	hba->wb_enabled = enable;
+	hba->dev_info.wb_enabled = enable;
 	dev_dbg(hba->dev, "%s write booster %s %d\n",
 			__func__, enable ? "enable" : "disable", ret);
 
@@ -5477,7 +5477,7 @@ static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba)
 	int ret;
 	u8 index;
 
-	if (!ufshcd_is_wb_allowed(hba) || hba->wb_buf_flush_enabled)
+	if (!ufshcd_is_wb_allowed(hba) || hba->dev_info.wb_buf_flush_enabled)
 		return 0;
 
 	index = ufshcd_wb_get_query_index(hba);
@@ -5488,7 +5488,7 @@ static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
 			__func__, ret);
 	else
-		hba->wb_buf_flush_enabled = true;
+		hba->dev_info.wb_buf_flush_enabled = true;
 
 	dev_dbg(hba->dev, "WB - Flush enabled: %d\n", ret);
 	return ret;
@@ -5499,7 +5499,7 @@ static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba)
 	int ret;
 	u8 index;
 
-	if (!ufshcd_is_wb_allowed(hba) || !hba->wb_buf_flush_enabled)
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_buf_flush_enabled)
 		return 0;
 
 	index = ufshcd_wb_get_query_index(hba);
@@ -5510,7 +5510,7 @@ static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba)
 		dev_warn(hba->dev, "%s: WB - buf flush disable failed %d\n",
 			 __func__, ret);
 	} else {
-		hba->wb_buf_flush_enabled = false;
+		hba->dev_info.wb_buf_flush_enabled = false;
 		dev_dbg(hba->dev, "WB - Flush disabled: %d\n", ret);
 	}
 
@@ -7299,13 +7299,12 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
 	 * buffer configured.
 	 */
-	dev_info->b_wb_buffer_type =
-		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
+	dev_info->wb_buffer_type = desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
 
 	dev_info->b_presrv_uspc_en =
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
 
-	if (dev_info->b_wb_buffer_type == WB_BUF_MODE_SHARED) {
+	if (dev_info->wb_buffer_type == WB_BUF_MODE_SHARED) {
 		if (!get_unaligned_be32(desc_buf +
 				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS))
 			goto wb_disabled;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ac0f03f69e42..a599d6bb5c8c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -818,8 +818,6 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
-	bool wb_buf_flush_enabled;
-	bool wb_enabled;
 	struct delayed_work rpm_dev_flush_recheck_work;
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
@@ -967,7 +965,7 @@ static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
 
 static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 {
-	if (hba->dev_info.b_wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
+	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
 		return hba->dev_info.wb_dedicated_lu;
 	return 0;
 }
-- 
2.17.1

