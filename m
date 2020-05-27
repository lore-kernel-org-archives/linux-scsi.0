Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2794FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017AB20835
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJHs9YGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391050AbgE0Q00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389726AbgE0Q0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 12:26:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8662C05BD1E;
        Wed, 27 May 2020 09:26:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v19so4921wmj.0;
        Wed, 27 May 2020 09:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UzaKLPucVtHkzJXAAR27OUqG6xUVbQvO8OAEkOJ/keA=;
        b=IJHs9YGRFbdtsuFQZlqKZEe+sQC30g8ONDeoWunDKU/b9HJIEi0dzhub65muu927jV
         Z88wygrp8KzgQSeSagmfnwEmZks0vDTL1XxkA70lMEnNaYfI8b7lKnqVfk98YhqHeML0
         IK+xZFpbfmM4lSra/T1VO/sLf5N6u7km4bfSm+gCa7cUm1JkPVm0JVDb9oli6NYqmrBh
         BP8vtAP14npPqP18bdkxGdw/AHi+Kgl+19r+tApciGxCJ35qKRhzD0fIxm5R0nhrH9mc
         smH+L4qPMbIXUDyIbjF7A30LvMU9LJoGc9SHC3R0Xx+x1rznpCXrXWbrrb4/OYPIVK4k
         jiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UzaKLPucVtHkzJXAAR27OUqG6xUVbQvO8OAEkOJ/keA=;
        b=bgkEcsQJDX3kZ0TOh/aHg4lwPNdBFf+vrSwv6TXCAGzbkea0T7Vl32rwkYoSn+F7/7
         WzWCiv87o9R6Gcksqh7KNWWL2nQfVehCcBeOMf/+f0J3LO0ZXknQiEvA4a5mop0PVJOr
         ogG+ryJvFPJSplLbuusuI+0rB/wd6SX+qbJ3iiHS3axHhklNouTEdVijGjImRvPMdfKe
         7g3k9myUtWNxi8ugBu96+bJjcxsebKZqz9Tf5F4Wpp2dIDZ3NV1vH8n+dC55/TSf1HdU
         C3H13SCaXy6Ol745SNdktg7o8YTI/5t1xK+iHWrGhjdlwJa8YT6/9km2srrtcUGy9TjR
         XgYw==
X-Gm-Message-State: AOAM532dtocz2D0Y7pbqTc6NqSzdp+QMGW3a8w8jdhDAdsnnXimeb9HT
        5HvmwsPBTXNTo7oNB8nBbuh6UvOZEpE=
X-Google-Smtp-Source: ABdhPJxRXy0K8FxUCCBReVJvA4eG29wneEqy7eSYfPhxMAKP0kpIkeWxncAPJgWcqDhN8z1XQxoPZQ==
X-Received: by 2002:a7b:c0c8:: with SMTP id s8mr5275859wmh.134.1590596783563;
        Wed, 27 May 2020 09:26:23 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id b185sm4578440wmd.3.2020.05.27.09.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:26:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] scsi: ufs: cleanup ufs initialization path
Date:   Wed, 27 May 2020 18:25:59 +0200
Message-Id: <20200527162559.1752-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

At UFS initialization stage, to get the length of the descriptor,
ufshcd_read_desc_length() being called 6 times, this is exactly
useless. This patch is to delete unnecessary reductant code, remove
ufshcd_read_desc_length() and boost UFS initialization.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 165 ++++++++------------------------------
 drivers/scsi/ufs/ufshcd.h |  12 +--
 2 files changed, 34 insertions(+), 143 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aca50ed39844..6687f03ca897 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3052,47 +3052,6 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 	return err;
 }
 
-/**
- * ufshcd_read_desc_length - read the specified descriptor length from header
- * @hba: Pointer to adapter instance
- * @desc_id: descriptor idn value
- * @desc_index: descriptor index
- * @desc_length: pointer to variable to read the length of descriptor
- *
- * Return 0 in case of success, non-zero otherwise
- */
-static int ufshcd_read_desc_length(struct ufs_hba *hba,
-	enum desc_idn desc_id,
-	int desc_index,
-	int *desc_length)
-{
-	int ret;
-	u8 header[QUERY_DESC_HDR_SIZE];
-	int header_len = QUERY_DESC_HDR_SIZE;
-
-	if (desc_id >= QUERY_DESC_IDN_MAX)
-		return -EINVAL;
-
-	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
-					desc_id, desc_index, 0, header,
-					&header_len);
-
-	if (ret) {
-		dev_err(hba->dev, "%s: Failed to get descriptor header id %d",
-			__func__, desc_id);
-		return ret;
-	} else if (desc_id != header[QUERY_DESC_DESC_TYPE_OFFSET]) {
-		dev_warn(hba->dev, "%s: descriptor header id %d and desc_id %d mismatch",
-			__func__, header[QUERY_DESC_DESC_TYPE_OFFSET],
-			desc_id);
-		ret = -EINVAL;
-	}
-
-	*desc_length = header[QUERY_DESC_LENGTH_OFFSET];
-	return ret;
-
-}
-
 /**
  * ufshcd_map_desc_id_to_length - map descriptor IDN to its length
  * @hba: Pointer to adapter instance
@@ -3101,46 +3060,27 @@ static int ufshcd_read_desc_length(struct ufs_hba *hba,
  *
  * Return 0 in case of success, non-zero otherwise
  */
-int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
-	enum desc_idn desc_id, int *desc_len)
+int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
+				 int *desc_len)
 {
-	switch (desc_id) {
-	case QUERY_DESC_IDN_DEVICE:
-		*desc_len = hba->desc_size.dev_desc;
-		break;
-	case QUERY_DESC_IDN_POWER:
-		*desc_len = hba->desc_size.pwr_desc;
-		break;
-	case QUERY_DESC_IDN_GEOMETRY:
-		*desc_len = hba->desc_size.geom_desc;
-		break;
-	case QUERY_DESC_IDN_CONFIGURATION:
-		*desc_len = hba->desc_size.conf_desc;
-		break;
-	case QUERY_DESC_IDN_UNIT:
-		*desc_len = hba->desc_size.unit_desc;
-		break;
-	case QUERY_DESC_IDN_INTERCONNECT:
-		*desc_len = hba->desc_size.interc_desc;
-		break;
-	case QUERY_DESC_IDN_STRING:
-		*desc_len = QUERY_DESC_MAX_SIZE;
-		break;
-	case QUERY_DESC_IDN_HEALTH:
-		*desc_len = hba->desc_size.hlth_desc;
-		break;
-	case QUERY_DESC_IDN_RFU_0:
-	case QUERY_DESC_IDN_RFU_1:
-		*desc_len = 0;
-		break;
-	default:
+	if (desc_id >= QUERY_DESC_IDN_MAX) {
 		*desc_len = 0;
 		return -EINVAL;
 	}
+
+	*desc_len = hba->desc_size[desc_id];
 	return 0;
 }
 EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
 
+static void ufshcd_update_desc_length(struct ufs_hba *hba,
+				      enum desc_idn desc_id, int desc_len)
+{
+	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
+	    desc_id != QUERY_DESC_IDN_STRING)
+		hba->desc_size[desc_id] = desc_len;
+}
+
 /**
  * ufshcd_read_desc_param - read the specified descriptor parameter
  * @hba: Pointer to adapter instance
@@ -3209,6 +3149,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
+	ufshcd_update_desc_length(hba, desc_id,
+				  desc_buf[QUERY_DESC_LENGTH_OFFSET]);
+
 	/* Check wherher we will not copy more data, than available */
 	if (is_kmalloc && param_size > buff_len)
 		param_size = buff_len;
@@ -3221,16 +3164,6 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	return ret;
 }
 
-static inline int ufshcd_read_desc(struct ufs_hba *hba,
-				   enum desc_idn desc_id,
-				   int desc_index,
-				   void *buf,
-				   u32 size)
-{
-	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
-}
-
-
 /**
  * struct uc_string_id - unicode string
  *
@@ -3278,9 +3211,8 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 	if (!uc_str)
 		return -ENOMEM;
 
-	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_STRING,
-			       desc_index, uc_str,
-			       QUERY_DESC_MAX_SIZE);
+	ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_STRING, desc_index, 0,
+				     (u8 *)uc_str, QUERY_DESC_MAX_SIZE);
 	if (ret < 0) {
 		dev_err(hba->dev, "Reading String Desc failed after %d retries. err = %d\n",
 			QUERY_REQ_RETRIES, ret);
@@ -6676,7 +6608,7 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 {
 	int ret;
-	int buff_len = hba->desc_size.pwr_desc;
+	int buff_len = hba->desc_size[QUERY_DESC_IDN_POWER];
 	u8 *desc_buf;
 	u32 icc_level;
 
@@ -6684,8 +6616,8 @@ static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 	if (!desc_buf)
 		return;
 
-	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
-			desc_buf, buff_len);
+	ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_POWER, 0, 0,
+				     desc_buf, buff_len);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: Failed reading power descriptor.len = %d ret = %d",
@@ -6794,7 +6726,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
 
-	if (hba->desc_size.dev_desc < DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
+	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
+	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
 	hba->dev_info.d_ext_ufs_feature_sup =
@@ -6881,7 +6814,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	u8 *desc_buf;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
-	buff_len = max_t(size_t, hba->desc_size.dev_desc,
+	buff_len = max_t(size_t, hba->desc_size[QUERY_DESC_IDN_DEVICE],
 			 QUERY_DESC_MAX_SIZE + 1);
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf) {
@@ -6889,8 +6822,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
-			hba->desc_size.dev_desc);
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
+				     hba->desc_size[QUERY_DESC_IDN_DEVICE]);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7120,42 +7053,10 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 
 static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
 {
-	int err;
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_DEVICE, 0,
-		&hba->desc_size.dev_desc);
-	if (err)
-		hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_POWER, 0,
-		&hba->desc_size.pwr_desc);
-	if (err)
-		hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_INTERCONNECT, 0,
-		&hba->desc_size.interc_desc);
-	if (err)
-		hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_CONFIGURATION, 0,
-		&hba->desc_size.conf_desc);
-	if (err)
-		hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_UNIT, 0,
-		&hba->desc_size.unit_desc);
-	if (err)
-		hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_GEOMETRY, 0,
-		&hba->desc_size.geom_desc);
-	if (err)
-		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
+	int i;
 
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
-		&hba->desc_size.hlth_desc);
-	if (err)
-		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
+	for (i = 0; i < QUERY_DESC_IDN_MAX; i++)
+		hba->desc_size[i] = QUERY_DESC_MAX_SIZE;
 }
 
 static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
@@ -7164,15 +7065,15 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	size_t buff_len;
 	u8 *desc_buf;
 
-	buff_len = hba->desc_size.geom_desc;
+	buff_len = hba->desc_size[QUERY_DESC_IDN_GEOMETRY];
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0,
-			desc_buf, buff_len);
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_GEOMETRY, 0, 0,
+				     desc_buf, buff_len);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
 				__func__, err);
@@ -7265,7 +7166,7 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 	/* Clear any previous UFS device information */
 	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
 
-	/* Init check for device descriptor sizes */
+	/* Init device descriptor sizes */
 	ufshcd_init_desc_sizes(hba);
 
 	/* Init UFS geometry descriptor related parameters */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e3dfb48e669e..b966d9b0eb3d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -236,16 +236,6 @@ struct ufs_dev_cmd {
 	struct ufs_query query;
 };
 
-struct ufs_desc_size {
-	int dev_desc;
-	int pwr_desc;
-	int geom_desc;
-	int interc_desc;
-	int unit_desc;
-	int conf_desc;
-	int hlth_desc;
-};
-
 /**
  * struct ufs_clk_info - UFS clock related info
  * @list: list headed by hba->clk_list_head
@@ -738,7 +728,7 @@ struct ufs_hba {
 	bool is_urgent_bkops_lvl_checked;
 
 	struct rw_semaphore clk_scaling_lock;
-	struct ufs_desc_size desc_size;
+	u8 desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
 
 	struct device		bsg_dev;
-- 
2.17.1

