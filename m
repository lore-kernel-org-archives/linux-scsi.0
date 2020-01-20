Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38BDC33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7542422464
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAVJFFl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgATNJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:09:37 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56087 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:09:36 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so14414096wmj.5;
        Mon, 20 Jan 2020 05:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1bT3vENVZeYpp+haao00mI36dnBC8eHxtO2LeOFswtI=;
        b=aAVJFFl7ZELS5PIjvPDZtyNlr0izcvY5VVefRz0mpoo7eZDb3mFy1F94t3Jh+lWtku
         gAKe9srJCghI2cXO4yWFMPWfbIyfM5LZNEX0k49BPl3CtumP3B8B4IuTMBgam0IUsvpr
         zv3qgnd083jNVEFFWHlHsfPjJZLH9gYlfzFE16CGXkdsH7OfFBMuURuov7Z7IilZf2g2
         cVXr8fQlvEIyHXAvl2QF2D8oXAP0HlPNR8P3ztx4RELRkv6wGSXsvNW7qMIq9P2NBkQ3
         fk5AKx2XozIiL8bZh8KT7KBElQjK0OeuYwQnT3SD39oOEM6nxjyGFY6xhq0/4p0CZFst
         LXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1bT3vENVZeYpp+haao00mI36dnBC8eHxtO2LeOFswtI=;
        b=J40tcdI8ggevvZUbk/2BeIbheGTGyy7+DRFu4OpbaMklWmSy/l13qmNM7bdqaoyETI
         AEZvyJxdgpCYn1O8TuzE6tHrTrTERiAqvC+nyjLEDjRFissXokdkxWJslSLqmheRhJR5
         MLI7G3VLVAa8lpeeRUdMHRrIQqUem+nv7rLnwXcSbi+DFuIbRVpzezXa3v3LF8LVUa7q
         zQd9MxBzZIST0HUU6IwS+1gbrCFBwmmn0F/oP0sokXHW8B9XeJJM7RFOtbpv7arluFsi
         ANfrS1Mh/dEA/2L6rVNE3D12IXGot9UGJWq/6jVbleK6POAYZeLke04jBCF19MSlYxG5
         7erQ==
X-Gm-Message-State: APjAAAVzaSWivwoCboW3dw9PToT7LjLKGstnGAHC+JhSseNKXvMikMqK
        AcZkxzLVvjWEd/GWnsXKB+w=
X-Google-Smtp-Source: APXvYqxmGKMcFu8t8gw01m2HD90Q0vucQqmelZpqAYrYAIpzXeB9laO/B9FMW0gF+z/YtBdqN2P8WQ==
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr18710947wmm.1.1579525773583;
        Mon, 20 Jan 2020 05:09:33 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:09:33 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/8] scsi: ufs: Delete struct ufs_dev_desc
Date:   Mon, 20 Jan 2020 14:08:14 +0100
Message-Id: <20200120130820.1737-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

In consideration of UFS host driver uses parameters of struct
ufs_dev_desc, move its parameters to struct ufs_dev_info,
delete struct ufs_dev_desc.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-mediatek.c |  7 ++---
 drivers/scsi/ufs/ufs-qcom.c     |  3 +--
 drivers/scsi/ufs/ufs.h          | 11 +-------
 drivers/scsi/ufs/ufs_quirks.h   |  9 ++++---
 drivers/scsi/ufs/ufshcd.c       | 47 +++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.h       |  7 +++--
 6 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 8d999c0e60fe..514a9b85fe0a 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -406,10 +406,11 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
-static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba,
-				    struct ufs_dev_desc *card)
+static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 {
-	if (card->wmanufacturerid == UFS_VENDOR_SAMSUNG)
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+
+	if (dev_info->wmanufacturerid == UFS_VENDOR_SAMSUNG)
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
 
 	return 0;
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index ebb5c66e069f..c69c29a1ceb9 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -949,8 +949,7 @@ static int ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
 	return err;
 }
 
-static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba,
-				     struct ufs_dev_desc *card)
+static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba)
 {
 	int err = 0;
 
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index c89f21698629..fcc9b4d4e56f 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -530,17 +530,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
-};
-
-#define MAX_MODEL_LEN 16
-/**
- * ufs_dev_desc - ufs device details from the device descriptor
- *
- * @wmanufacturerid: card details
- * @model: card model
- */
-struct ufs_dev_desc {
 	u16 wmanufacturerid;
+	/*UFS device Product Name */
 	u8 *model;
 };
 
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index fe6cad9b2a0d..d0ab147f98d3 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -22,16 +22,17 @@
  * @quirk: device quirk
  */
 struct ufs_dev_fix {
-	struct ufs_dev_desc card;
+	u16 wmanufacturerid;
+	u8 *model;
 	unsigned int quirk;
 };
 
-#define END_FIX { { 0 }, 0 }
+#define END_FIX { }
 
 /* add specific device quirk */
 #define UFS_FIX(_vendor, _model, _quirk) { \
-	.card.wmanufacturerid = (_vendor),\
-	.card.model = (_model),		   \
+	.wmanufacturerid = (_vendor),\
+	.model = (_model),		   \
 	.quirk = (_quirk),		   \
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9a9085a7bcc5..58ef45b80cb0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6583,16 +6583,13 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	return ret;
 }
 
-static int ufs_get_device_desc(struct ufs_hba *hba,
-			       struct ufs_dev_desc *dev_desc)
+static int ufs_get_device_desc(struct ufs_hba *hba)
 {
 	int err;
 	size_t buff_len;
 	u8 model_index;
 	u8 *desc_buf;
-
-	if (!dev_desc)
-		return -EINVAL;
+	struct ufs_dev_info *dev_info = &hba->dev_info;
 
 	buff_len = max_t(size_t, hba->desc_size.dev_desc,
 			 QUERY_DESC_MAX_SIZE + 1);
@@ -6613,12 +6610,12 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 	 * getting vendor (manufacturerID) and Bank Index in big endian
 	 * format
 	 */
-	dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
+	dev_info->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
 				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 	err = ufshcd_read_string_desc(hba, model_index,
-				      &dev_desc->model, SD_ASCII_STD);
+				      &dev_info->model, SD_ASCII_STD);
 	if (err < 0) {
 		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
 			__func__, err);
@@ -6636,23 +6633,25 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 	return err;
 }
 
-static void ufs_put_device_desc(struct ufs_dev_desc *dev_desc)
+static void ufs_put_device_desc(struct ufs_hba *hba)
 {
-	kfree(dev_desc->model);
-	dev_desc->model = NULL;
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+
+	kfree(dev_info->model);
+	dev_info->model = NULL;
 }
 
-static void ufs_fixup_device_setup(struct ufs_hba *hba,
-				   struct ufs_dev_desc *dev_desc)
+static void ufs_fixup_device_setup(struct ufs_hba *hba)
 {
 	struct ufs_dev_fix *f;
+	struct ufs_dev_info *dev_info = &hba->dev_info;
 
 	for (f = ufs_fixups; f->quirk; f++) {
-		if ((f->card.wmanufacturerid == dev_desc->wmanufacturerid ||
-		     f->card.wmanufacturerid == UFS_ANY_VENDOR) &&
-		     ((dev_desc->model &&
-		       STR_PRFX_EQUAL(f->card.model, dev_desc->model)) ||
-		      !strcmp(f->card.model, UFS_ANY_MODEL)))
+		if ((f->wmanufacturerid == dev_info->wmanufacturerid ||
+		     f->wmanufacturerid == UFS_ANY_VENDOR) &&
+		     ((dev_info->model &&
+		       STR_PRFX_EQUAL(f->model, dev_info->model)) ||
+		      !strcmp(f->model, UFS_ANY_MODEL)))
 			hba->dev_quirks |= f->quirk;
 	}
 }
@@ -6804,8 +6803,7 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
-				      struct ufs_dev_desc *card)
+static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 {
 	if (ufshcd_is_unipro_pa_params_tuning_req(hba)) {
 		ufshcd_tune_pa_tactivate(hba);
@@ -6819,7 +6817,7 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
 
-	ufshcd_vops_apply_dev_quirks(hba, card);
+	ufshcd_vops_apply_dev_quirks(hba);
 }
 
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
@@ -6945,7 +6943,6 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
  */
 static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
-	struct ufs_dev_desc card = {0};
 	int ret;
 	ktime_t start = ktime_get();
 
@@ -6974,16 +6971,15 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* Init check for device descriptor sizes */
 	ufshcd_init_desc_sizes(hba);
 
-	ret = ufs_get_device_desc(hba, &card);
+	ret = ufs_get_device_desc(hba);
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
 			__func__, ret);
 		goto out;
 	}
 
-	ufs_fixup_device_setup(hba, &card);
-	ufshcd_tune_unipro_params(hba, &card);
-	ufs_put_device_desc(&card);
+	ufs_fixup_device_setup(hba);
+	ufshcd_tune_unipro_params(hba);
 
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
@@ -7544,6 +7540,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
+		ufs_put_device_desc(hba);
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b1a1c65be8b1..32b6714f25a5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -320,7 +320,7 @@ struct ufs_hba_variant_ops {
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
-	int	(*apply_dev_quirks)(struct ufs_hba *, struct ufs_dev_desc *);
+	int	(*apply_dev_quirks)(struct ufs_hba *hba);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -1054,11 +1054,10 @@ static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
 		return hba->vops->hibern8_notify(hba, cmd, status);
 }
 
-static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba,
-					       struct ufs_dev_desc *card)
+static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->apply_dev_quirks)
-		return hba->vops->apply_dev_quirks(hba, card);
+		return hba->vops->apply_dev_quirks(hba);
 	return 0;
 }
 
-- 
2.17.1

