Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A24C2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7184022464
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/PYAoVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgATNKC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:10:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36811 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:10:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so29524397wru.3;
        Mon, 20 Jan 2020 05:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pVtO//JnmpJEbBOinshMosCxkhLujL8jfc98AaizHQs=;
        b=h/PYAoVbPVkUylg7wmqeOlfd98AFbSFhV8pn/QBmjZRAP2c5WQDX7WbrVW2/bo5VzG
         XGWHBOuGuAHfvLIxyfKTmnJ8MFDkCoApK8woVBMu+09RlVkAbGMXApJtekJLTMBOgHli
         d2THVSje3krzlyXSE/wZ1mUnb3wRc1fnKW8O7KVT3uoYt9ML2hkHKGi8ble1NAl8VK3d
         +KzwFYIVNJGE6za30vHJ/TG75AD5P2fCfhzLsqoPunRIZrg6+kPSRPwrCkDO/0tgM+Of
         ON3ElLa5CixH8NhYZLP9JisBAFxw89U3X9rYQRj2QCeWSVag9qOgmVaQ5SnIUs+rWaxm
         S6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pVtO//JnmpJEbBOinshMosCxkhLujL8jfc98AaizHQs=;
        b=lsK0F9nm10nbI8pbGJMQ+H843YBravaYSiPVrKTtnIYh2UnE7G79xofIqXWAkmGJ6H
         8S4+2Z6++U0IlsBfGcKY8NA5HDGl6BvJHGZdtFh5l5I7TT4IDgN+yJ6QH0eB9uakrvLC
         RGvFB+tuy275/N+jfRDr8VD/xPQWpOMS329H9XZXg9tooIs+NUKh1sKLo2T8uCM3Dw8u
         ksDJNPh6ZwI402lB8vU6Z59NdY2gRUrYDZX7vmfRLUCvm1n71cecJsS7xl3bCYF9Z3g2
         uZAzHRWCTxcpqVvNezH2ENhppaYJqHlMMn9EcBz4XWSxI7+TSw0rWsjmU2dIieR/Py0k
         yU3A==
X-Gm-Message-State: APjAAAWITaKFniaYRXroZ2qaAG0GLhSoJnnC16MnNiRILRRZ5zEsWZWa
        llHNdCzhJ2yyVRWyDFpSm8Q=
X-Google-Smtp-Source: APXvYqwr4VIDu6lmmNzjy8SSwl7QxKRgCEDKwrloWmxrg3BuKTubmHg8Y2Zjjp3SWHBOttVU6efOjw==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr17981235wrs.222.1579525799650;
        Mon, 20 Jan 2020 05:09:59 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:09:59 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/8] scsi: ufs: Add max_lu_supported in struct ufs_dev_info
Date:   Mon, 20 Jan 2020 14:08:19 +0100
Message-Id: <20200120130820.1737-8-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add one new parameter max_lu_supported in struct ufs_dev_info,
which will be used to express exactly how many general LUs being
supported by UFS device, and initialize it during booting stage.
This patch also adds a new function ufshcd_device_geo_params_init()
for initialization of UFS device geometry descriptor related parameters.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  2 ++
 drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index fcc9b4d4e56f..c982bcc94662 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -530,6 +530,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
+	/* Maximum number of general LU supported by the UFS device */
+	u8 max_lu_supported;
 	u16 wmanufacturerid;
 	/*UFS device Product Name */
 	u8 *model;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c859f239d1c..1d2812ad8742 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6858,6 +6858,37 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
 		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
+static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
+{
+	int err;
+	size_t buff_len;
+	u8 *desc_buf;
+
+	buff_len = hba->desc_size.geom_desc;
+	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	if (!desc_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0,
+			desc_buf, buff_len);
+	if (err) {
+		dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 1)
+		hba->dev_info.max_lu_supported = 32;
+	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
+		hba->dev_info.max_lu_supported = 8;
+
+out:
+	kfree(desc_buf);
+	return err;
+}
+
 static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
 	{19200000, REF_CLK_FREQ_19_2_MHZ},
 	{26000000, REF_CLK_FREQ_26_MHZ},
@@ -6931,9 +6962,17 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 	bool flag;
 	int ret;
 
+	/* Clear any previous UFS device information */
+	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+
 	/* Init check for device descriptor sizes */
 	ufshcd_init_desc_sizes(hba);
 
+	/* Init UFS geometry descriptor related parameters */
+	ret = ufshcd_device_geo_params_init(hba);
+	if (ret)
+		goto out;
+
 	/* Check and apply UFS device quirks */
 	ret = ufs_get_device_desc(hba);
 	if (ret) {
@@ -6944,8 +6983,6 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 
 	ufs_fixup_device_setup(hba);
 
-	/* Clear any previous UFS device information */
-	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
 	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
 			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 		hba->dev_info.f_power_on_wp_en = flag;
-- 
2.17.1

