Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D578C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D93BE20897
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwjBX5yH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgE2Ql2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 12:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2Ql1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 12:41:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D97C03E969;
        Fri, 29 May 2020 09:41:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x13so4442737wrv.4;
        Fri, 29 May 2020 09:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9bVBT0aZbmB/hF7sO6Le8A1yrPasSowI+6xR4HW0gLs=;
        b=DwjBX5yH1nF7KeYejJEVqaYclmSn8n7+34nTc4XbKH8bS1wrBjP/O1SPXI7Fmg+G+C
         jLpKXK8Zg8r6wnxl3887ieF+JNiWFJP8gBVtjdF0drrteV8+yHh8aSejGRuCb4rIPOtS
         CnZVKHM0hPswvSDonCwpSDoUjeHbWym+yhnOO5SnUr3A6RQGUrIaL0gNlY37LOeZsXMO
         1KdmlnJ4enjoMX9+D7t4z8WdwdCT+B4Jg/tjV/vXBV8yE7hfyWgv3o9T9+O87zLXVKzt
         h0IeHZ0F/yZxEWYuSzPr8Yt+zLQrFnm8Y0OesHsWZ/ofxz97Zbc2qvxGN6Re0LmDghBi
         8poA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9bVBT0aZbmB/hF7sO6Le8A1yrPasSowI+6xR4HW0gLs=;
        b=kWZciPfNSFmpVjnr7yLmUwRVy/7uxUpbzqZnMGezI4TQg/+lp6lMEE/OnUJR/ng7T5
         /UY8SaWKVIPmQbFASxnA/FfuYxDTuAbs+oV2UJR3Jgadz7+T7wcDrd2wUVdHh5i1S24G
         AFAUEYBccahYTV43ACipSx6O3GA11qJQGHuap/+vu5TVTb79mEBsHF5qaFv+SUXggTle
         ESkL1NF58OpqIq/X//KrLezTQt6zfZyjgO5UEd7W1Z7WCvw5PUcOhLKzf7GsQGfLxZ8y
         iK9tzjljLGcjapRnoSbPeEzk5TnVLfvWB3/4QY26tXdanh0YNReUBoOepG52IvSNuq7+
         ZR/w==
X-Gm-Message-State: AOAM530hLaz6aHj0zD1nf+YhD+4P6oEJ0B9sFPMuENOsaaoPosQFr+hZ
        OD7hJmhQtD2g/o2V8tcRjqY=
X-Google-Smtp-Source: ABdhPJyaGltRLGWAu0gIaBXvsmEu7oXsBCS41zFRaoi7AaJDbQ4/+MoDCSoMcGhM955uH1S3N6/MuQ==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr9230752wrn.373.1590770486130;
        Fri, 29 May 2020 09:41:26 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id z25sm17344wmf.10.2020.05.29.09.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:41:25 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] scsi: ufs: cleanup ufs initialization path
Date:   Fri, 29 May 2020 18:40:53 +0200
Message-Id: <20200529164054.27552-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529164054.27552-1-huobean@gmail.com>
References: <20200529164054.27552-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

At UFS initialization stage, to get the length of the descriptor,
ufshcd_read_desc_length() being called 6 times. Instead, we will
capture the descriptor size the first time  we'll read it.

Delete unnecessary redundant code, remove ufshcd_read_desc_length(),
ufshcd_init_desc_sizes(), and boost UFS initialization.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs.h     |  10 ---
 drivers/scsi/ufs/ufs_bsg.c |   5 +-
 drivers/scsi/ufs/ufshcd.c  | 165 +++++++------------------------------
 drivers/scsi/ufs/ufshcd.h  |  16 +---
 4 files changed, 36 insertions(+), 160 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index fadba3a3bbcd..6548ef102eb9 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -200,16 +200,6 @@ enum desc_header_offset {
 	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
 };
 
-enum ufs_desc_def_size {
-	QUERY_DESC_DEVICE_DEF_SIZE		= 0x59,
-	QUERY_DESC_CONFIGURATION_DEF_SIZE	= 0x90,
-	QUERY_DESC_UNIT_DEF_SIZE		= 0x2D,
-	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
-	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x48,
-	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
-	QUERY_DESC_HEALTH_DEF_SIZE		= 0x25,
-};
-
 /* Unit descriptor parameters offsets in bytes*/
 enum unit_desc_param {
 	UNIT_DESC_PARAM_LEN			= 0x0,
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 53dd87628cbe..27f54615ee84 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -11,13 +11,12 @@ static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
 {
 	int desc_size = be16_to_cpu(qr->length);
 	int desc_id = qr->idn;
-	int ret;
 
 	if (desc_size <= 0)
 		return -EINVAL;
 
-	ret = ufshcd_map_desc_id_to_length(hba, desc_id, desc_len);
-	if (ret || !*desc_len)
+	ufshcd_map_desc_id_to_length(hba, desc_id, desc_len);
+	if (!*desc_len)
 		return -EINVAL;
 
 	*desc_len = min_t(int, *desc_len, desc_size);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f7e8bfefe3d4..951e52babf65 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3052,95 +3052,32 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
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
  * @desc_id: descriptor idn value
  * @desc_len: mapped desc length (out)
  *
- * Return 0 in case of success, non-zero otherwise
  */
-int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
-	enum desc_idn desc_id, int *desc_len)
+void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
+				  int *desc_len)
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
+	if (desc_id == QUERY_DESC_IDN_RFU_0 || desc_id == QUERY_DESC_IDN_RFU_1)
 		*desc_len = 0;
-		break;
-	default:
-		*desc_len = 0;
-		return -EINVAL;
-	}
-	return 0;
+	else
+		*desc_len = hba->desc_size[desc_id];
 }
 EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
 
+static void ufshcd_update_desc_length(struct ufs_hba *hba,
+				      enum desc_idn desc_id,
+				      unsigned char desc_len)
+{
+	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
+	    desc_id != QUERY_DESC_IDN_STRING)
+		hba->desc_size[desc_id] = desc_len;
+}
+
 /**
  * ufshcd_read_desc_param - read the specified descriptor parameter
  * @hba: Pointer to adapter instance
@@ -3168,16 +3105,11 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	if (desc_id >= QUERY_DESC_IDN_MAX || !param_size)
 		return -EINVAL;
 
-	/* Get the max length of descriptor from structure filled up at probe
-	 * time.
-	 */
-	ret = ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
-
-	/* Sanity checks */
-	if (ret || !buff_len) {
-		dev_err(hba->dev, "%s: Failed to get full descriptor length",
-			__func__);
-		return ret;
+	/* Get the length of descriptor */
+	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
+	if (!buff_len) {
+		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
+		return -EINVAL;
 	}
 
 	/* Check whether we need temp memory */
@@ -3209,6 +3141,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
+	ufshcd_update_desc_length(hba, desc_id,
+				  desc_buf[QUERY_DESC_LENGTH_OFFSET]);
+
 	/* Check wherher we will not copy more data, than available */
 	if (is_kmalloc && param_size > buff_len)
 		param_size = buff_len;
@@ -6665,7 +6600,7 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 {
 	int ret;
-	int buff_len = hba->desc_size.pwr_desc;
+	int buff_len = hba->desc_size[QUERY_DESC_IDN_POWER];
 	u8 *desc_buf;
 	u32 icc_level;
 
@@ -6783,7 +6718,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
 
-	if (hba->desc_size.dev_desc < DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
+	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
+	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
 	hba->dev_info.d_ext_ufs_feature_sup =
@@ -6876,7 +6812,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	}
 
 	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
-				     hba->desc_size.dev_desc);
+				     hba->desc_size[QUERY_DESC_IDN_DEVICE]);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7104,53 +7040,13 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 	hba->req_abort_count = 0;
 }
 
-static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
-{
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
-
-	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
-		&hba->desc_size.hlth_desc);
-	if (err)
-		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
-}
-
 static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 {
 	int err;
 	size_t buff_len;
 	u8 *desc_buf;
 
-	buff_len = hba->desc_size.geom_desc;
+	buff_len = hba->desc_size[QUERY_DESC_IDN_GEOMETRY];
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
@@ -7246,13 +7142,14 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
 static int ufshcd_device_params_init(struct ufs_hba *hba)
 {
 	bool flag;
-	int ret;
+	int ret, i;
 
 	/* Clear any previous UFS device information */
 	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
 
-	/* Init check for device descriptor sizes */
-	ufshcd_init_desc_sizes(hba);
+	/* Init device descriptor sizes */
+	for (i = 0; i < QUERY_DESC_IDN_MAX; i++)
+		hba->desc_size[i] = QUERY_DESC_MAX_SIZE;
 
 	/* Init UFS geometry descriptor related parameters */
 	ret = ufshcd_device_geo_params_init(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e3dfb48e669e..5ea090d82ddc 100644
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
+	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
 
 	struct device		bsg_dev;
@@ -975,8 +965,8 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
-int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
-	int *desc_length);
+void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
+				  int *desc_length);
 
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
-- 
2.17.1

