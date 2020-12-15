Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A64DC2BBCF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2B0423718
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgLOXOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731269AbgLOXG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E184C0617B0;
        Tue, 15 Dec 2020 15:05:37 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id cm17so22855893edb.4;
        Tue, 15 Dec 2020 15:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qJVIUYjiIMDP3ufzjlA1AMlylGNTKsAGLwNk6au5m3A=;
        b=ltb4vz86FRnKJFLBpaB+UgoxVwCSZc//5z6LA5UbrILd4AecMhSSwi/CQLTeneEcZN
         0IklsvQ6oXlV8CCQS9e7mEQUOSqeodias+tDrl882L4+P+Kjwy7rNpoepfqV8Dq2CzDv
         sfo8+tLBRUtW16kSUu9C/2BgXecJs8BcyuXqWuokp2i2lgfJl00Qd8HgAMgaocXXmuEA
         zfcFGEhrXlSoF5qcy01QbRJeP1iQSdWMMRjfs0m8wwFzWiHAYhnFEkijQpGbi4scYlWo
         WmfIxvpNpFiervHOSB5ZmM7jJXx0uyT4hZ5dlsnDvdMOr+Nu5pjRCMUEHzxzp4wLgzgk
         v5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qJVIUYjiIMDP3ufzjlA1AMlylGNTKsAGLwNk6au5m3A=;
        b=cVf21KMOrROiqecHODcc5p/7k9tfiOlmW384q8FpDKQysO1vKJp1guPbW2a00METME
         aq3l2VVRCDghBuo6jKsjwSebQfX18WlzsyzLhKDgwxrBAQkKstD+SSuxmhDhsXGKgqUo
         pGQjlWKXezr2sGKvq3p3Hm+Qks81KchF3ZNAIUDVhkxJlLdZLsDzpGWL4dNv3lmwR7th
         vxH/4MlA08CWINKOaN7SwP2uNeM/WqhkKHNfDk/pORBv6HxQZW9jOfHgx7qT9gF4wus2
         D66iEckvhT8RcriZGOrPKZtkC8Gai+AlrN54BYhygDmS/IPVpdUUf3f4bUQYI6cEGrmP
         lRgA==
X-Gm-Message-State: AOAM5326h96W5s8poHWoZZwTSZ0H4lEyythiC2e59EzDq+Pn3seZJ4JG
        QuYrbcF1EdkWFSw+6EpvPcQ=
X-Google-Smtp-Source: ABdhPJx8n2tt99c7wQqBpQI0GD+jaIMSHkIicqWSGZY/CCBNYTIl+EPZ6nH5akRhLP+AOGIV9wLotA==
X-Received: by 2002:a05:6402:139a:: with SMTP id b26mr31613765edv.47.1608073536068;
        Tue, 15 Dec 2020 15:05:36 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:35 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/7] scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
Date:   Wed, 16 Dec 2020 00:05:17 +0100
Message-Id: <20201215230519.15158-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215230519.15158-1-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

UFS device-related flags should be grouped in ufs_dev_info. Take
wb_enabled and wb_buf_flush_enabled out from the struct ufs_hba,
group them to struct ufs_dev_info, and align the names of the structure
members vertically.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufs.h       | 27 ++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.c    | 21 ++++++++++-----------
 drivers/scsi/ufs/ufshcd.h    |  4 +---
 4 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index f3ca3d6b82c4..9a9acc722a37 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -194,7 +194,7 @@ static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
+	return sysfs_emit(buf, "%d\n", hba->dev_info.wb_enabled);
 }
 
 static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index a789e074ae3f..ec74cf360b1f 100644
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
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f08f4a59a17..466a85051d54 100644
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
 
@@ -7236,13 +7236,12 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
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
index 2a97006a2c93..ee97068158e2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -805,8 +805,6 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
-	bool wb_buf_flush_enabled;
-	bool wb_enabled;
 	struct delayed_work rpm_dev_flush_recheck_work;
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
@@ -946,7 +944,7 @@ static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
 
 static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 {
-	if (hba->dev_info.b_wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
+	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
 		return hba->dev_info.wb_dedicated_lu;
 	return 0;
 }
-- 
2.17.1

