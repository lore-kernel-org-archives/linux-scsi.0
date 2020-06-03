Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C538C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAE6D2077D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SeNdPsHw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgFCJU1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCJUY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 05:20:24 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185B2C05BD43;
        Wed,  3 Jun 2020 02:20:23 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o15so1363911ejm.12;
        Wed, 03 Jun 2020 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Aoi3xuxMLMW4MC5IHy+PLceD1Is3GSCaMCdwd+7OIME=;
        b=SeNdPsHw6XwsXsv77rt/xMzy8O+EBxYxaL9hwlt1a2RT/XNbSLSyUscJFx9yY4Qyi2
         UP423qI8PvG25VsCTkMxRpJ28qqca1ufrVbqr/8J3XEQSwi4y8Tg2cbpxJLV8DVHsyjS
         V8GpFCqry643qWy9YgzdFjlA9AVzaePHx4hjHsW4REl1E7wojxBCYHkqFLSIERC/GfaG
         La9BSiaTlqolous+KbQWncTQe/nIZe4H9qav4gUZG/MOov4QMovk2GwNHpYALEWLmwLt
         V8dhzo0OCPNJLvDKnT8cDrPOGIIo5/0vzXY4dYcNXjEa6doiV7AeiQK+CPY5vnb7XW1I
         LypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Aoi3xuxMLMW4MC5IHy+PLceD1Is3GSCaMCdwd+7OIME=;
        b=ap9wv8n5Nut9c3pbpySkz9DFSC+D501zHg89d1ghXF5URGn7q8psA4tVM8KcBEkxnU
         bJKpVLs3iqo1bQonT4mxxJdNPfdUYBpxIrsSn2LUd1EOIkb7JZ/d/NRpPkcIEXmdFtjG
         uq5lKvME10gofgECTQ2GrH8noSsWWtwvMhVYXmDs/9dYu/KU4hY4V5rYdA3cXn37cjpf
         0xBj2upPDi+vmzrkeCuTIxLaqLZT4H1trcHleAHbrXMAOLIm/yY/oNq4xqysMaWigc3/
         Zet6ougNUgVdEGeZxmzgaPDsHLIw8cONx7HnU/ABrbDi2c/kA46ww21YwjUmT1Ve6bU6
         dRzA==
X-Gm-Message-State: AOAM532uBrtV8rnzxpJGENPQMHGFeGGdc3ucyP7DeL+bOVPHIGwps9bx
        1aSQ56x9Mh9GLag9JxFpqM4=
X-Google-Smtp-Source: ABdhPJxZCnLl2BNH2XhAaNDHIO/GMzS7uMOvWkThmpoCdAf38vP8Tg1EEdQKP6sSrc3OaPwtcBxfOA==
X-Received: by 2002:a17:906:31d2:: with SMTP id f18mr16498098ejf.110.1591176021774;
        Wed, 03 Jun 2020 02:20:21 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:d00c:464c:92b:aecc:3637:dc7c])
        by smtp.gmail.com with ESMTPSA id 64sm865636eda.85.2020.06.03.02.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:20:21 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@outlook.com
Subject: [RESENT PATCH v5 4/5] scsi: ufs: cleanup ufs initialization path
Date:   Wed,  3 Jun 2020 11:19:58 +0200
Message-Id: <20200603091959.27618-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
References: <20200603091959.27618-1-huobean@gmail.com>
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
 drivers/scsi/ufs/ufshcd.c  | 168 ++++++++-----------------------------
 drivers/scsi/ufs/ufshcd.h  |  16 +---
 4 files changed, 38 insertions(+), 161 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index c70845d41449..8770255b5dc0 100644
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
index 7163b268ed0b..5ad0eebccc98 100644
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
- *
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
-		*desc_len = 0;
-		break;
-	default:
+	if (desc_id >= QUERY_DESC_IDN_MAX || desc_id == QUERY_DESC_IDN_RFU_0 ||
+	    desc_id == QUERY_DESC_IDN_RFU_1)
 		*desc_len = 0;
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
@@ -3209,6 +3141,10 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
+	/* Update descriptor length */
+	buff_len = desc_buf[QUERY_DESC_LENGTH_OFFSET];
+	ufshcd_update_desc_length(hba, desc_id, buff_len);
+
 	/* Check wherher we will not copy more data, than available */
 	if (is_kmalloc && (param_offset + param_size) > buff_len)
 		param_size = buff_len - param_offset;
@@ -6692,7 +6628,7 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 {
 	int ret;
-	int buff_len = hba->desc_size.pwr_desc;
+	int buff_len = hba->desc_size[QUERY_DESC_IDN_POWER];
 	u8 *desc_buf;
 	u32 icc_level;
 
@@ -6810,7 +6746,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
 
-	if (hba->desc_size.dev_desc < DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
+	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
+	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
 	hba->dev_info.d_ext_ufs_feature_sup =
@@ -6903,7 +6840,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	}
 
 	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
-				     hba->desc_size.dev_desc);
+				     hba->desc_size[QUERY_DESC_IDN_DEVICE]);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7132,53 +7069,13 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
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
@@ -7274,10 +7171,11 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
 static int ufshcd_device_params_init(struct ufs_hba *hba)
 {
 	bool flag;
-	int ret;
+	int ret, i;
 
-	/* Init check for device descriptor sizes */
-	ufshcd_init_desc_sizes(hba);
+	 /* Init device descriptor sizes */
+	for (i = 0; i < QUERY_DESC_IDN_MAX; i++)
+		hba->desc_size[i] = QUERY_DESC_MAX_SIZE;
 
 	/* Init UFS geometry descriptor related parameters */
 	ret = ufshcd_device_geo_params_init(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bf97d616e597..2b62869fa459 100644
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
@@ -976,8 +966,8 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
-int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
-	int *desc_length);
+void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
+				  int *desc_length);
 
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
-- 
2.17.1

