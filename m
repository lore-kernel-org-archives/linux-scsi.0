Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF8CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA20321548
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vY/9Udeq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgE1MGs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 08:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388824AbgE1L4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 07:56:47 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79589C05BD1E;
        Thu, 28 May 2020 04:56:47 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f185so1735101wmf.3;
        Thu, 28 May 2020 04:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GEgKx5eP8l8U94wh2CmUXTGJ7VZWqKoSJtZlOzZjkW4=;
        b=vY/9UdeqWRtBkgXPlFsFBdQrY+7TWQLw3or/WOLXER7GTOp04ukIkUPOUWKPjPgvJB
         lKB6+7NjiROBK5b00sT86oS03M+mfM0ynPxWquQwY2qB6u4KLkfoRXSRRAAHHVb9jQvN
         CPSPge9w3LG9xlfyZkzpScNDH78n+AtNO7vrVIGoAC+ngF/ilPPjWGZVxmwnZGWqcNQq
         ohPR+on7m759W0lTgcbQ945z38qibz0GT/oFLF1K4KI8IQp5/oQ8tmU6iz7YKjqAxtzh
         LUJAVv81YvkfJYF/+sLCnnkSF0Ls1vIC83JQe3GO/TIl6/NguB+z4DNrugFDBW0+sQaj
         5z3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GEgKx5eP8l8U94wh2CmUXTGJ7VZWqKoSJtZlOzZjkW4=;
        b=Kh7wE/QuLLjpCWkMl9ZAZrg46dF4xhXzTw2xfS2h5qOqit0CnOFJCIbaWLdaG2vLoP
         +eZ55YNgQgtm2Fa3+l1lPXGRCu95hdf8or4cvUTeaDGPza7aUmD7LfNYccTCkBdoUS9x
         zzye8GqV8KTAe+8B9pnh3buFgL2g9dQkj455umaAimjs+uGuEcNryV7roxTsDzrv5M79
         mG7i7noSoc6culxE9i+NGwxRxmID1gXa2EhC4f1IX1jcRT9Yt6UP72UGaRRrOB+Q/9l9
         x9VTsVFLwQJqgR/QGBoXEtqZNGQiVhMVElblv3HP9IA9E+FLZIxjWH5U6AHAv+y+QAU0
         vOKQ==
X-Gm-Message-State: AOAM531jZZ/7EpMWZyrvC62CdpaD9JEH7IBqtpN/1lKC6Lhu3DSjUCkY
        RBYlgb7ZOvyYybDMKB2c2H8=
X-Google-Smtp-Source: ABdhPJy5fdw4YiGVeHlQ9pF3dHduYUxtBDKvapThItXXGMrRUXseKO3kw69Dl+PKya0QhgQJI5qZHA==
X-Received: by 2002:a1c:a508:: with SMTP id o8mr3278680wme.117.1590667006175;
        Thu, 28 May 2020 04:56:46 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id y37sm6589178wrd.55.2020.05.28.04.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:56:45 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: ufs: cleanup ufs initialization path
Date:   Thu, 28 May 2020 13:56:16 +0200
Message-Id: <20200528115616.9949-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528115616.9949-1-huobean@gmail.com>
References: <20200528115616.9949-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

At UFS initialization stage, to get the length of the descriptor,
ufshcd_read_desc_length() being called 6 times. This patch is to
delete unnecessary reduntant code, remove ufshcd_read_desc_length()
and boost UFS initialization.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 138 +++++++-------------------------------
 drivers/scsi/ufs/ufshcd.h |  12 +---
 2 files changed, 26 insertions(+), 124 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0a95f0a5ab73..c47f4584c0f4 100644
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
@@ -6665,7 +6608,7 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 {
 	int ret;
-	int buff_len = hba->desc_size.pwr_desc;
+	int buff_len = hba->desc_size[QUERY_DESC_IDN_POWER];
 	u8 *desc_buf;
 	u32 icc_level;
 
@@ -6783,7 +6726,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
 
-	if (hba->desc_size.dev_desc < DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
+	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
+	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
 	hba->dev_info.d_ext_ufs_feature_sup =
@@ -6878,7 +6822,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	}
 
 	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
-				     hba->desc_size.dev_desc);
+				     hba->desc_size[QUERY_DESC_IDN_DEVICE]);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7108,42 +7052,10 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 
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
@@ -7152,7 +7064,7 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	size_t buff_len;
 	u8 *desc_buf;
 
-	buff_len = hba->desc_size.geom_desc;
+	buff_len = hba->desc_size[QUERY_DESC_IDN_GEOMETRY];
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
@@ -7253,7 +7165,7 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
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

