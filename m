Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDDAC33CB7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C692467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rBW0+V0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgASAOS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39197 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgASAOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so11160769wmj.4;
        Sat, 18 Jan 2020 16:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9q6DalID/6nJXKb+L/ud3IZ3fY2HNeLSUvnbsc/zVY4=;
        b=rBW0+V0t5FCD1BIk7j5dGm5ZUkGljoiF5+I7ac+RYDBAlOtKZIN5QPUD1BfDMcQzFP
         4Xumgkg6qbzFIk8gLGyzMG62wQSfcoU+viB9ciztzbq10/OV81h64q7Cz+UVdoAtXC5w
         pBPdeV633bRnhdmv6B88DAp0lk/S0GwR/l31BkW7V0Qt2gc9DhhiVsYo1Mf8gLMyXvak
         FA1tVtR+E/OY1iDuVqBhW99RvfFYRFvtH1rxXneaAwlEugQ2b2YdxM+gIdv04om/eHHj
         TkmlE8Ide0lmZ/J83K7tYlT5EPrNm400ssJxlHFqi6LuGtiA2CuQU3cbqO9Wu/Vd5KDM
         TtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9q6DalID/6nJXKb+L/ud3IZ3fY2HNeLSUvnbsc/zVY4=;
        b=tuDP/eNyO1b2qSR5BXeXBn2iw+J64UNBX2JhixgvKkYxLgb3CftSN+joZ5DfV2oq7B
         /uFT6MbW3cRAyiftHAvGS2FJqAtzzxqqZo3XJSCpGvR3DkuaC8c4y/q1L6CeGXd7ezsg
         P2lV0Ta/zfQbeVn5V80NqwY+I5ebQ6MOIh7UIb9SpSFYE3l77DF+nAwUomxCQR6uU0b6
         2zwZx7HSDoY3OdUACTLr4uHnRpRST/OoyhWjyqYALkZFE4pt155fKWgsZbhnop76iugy
         6jSIbmcu+LwYsP6USPn52ZIt2kwiLzVogbiWFHwE6Bm2E/aqL5y3gx4JOFGeCfRk28+s
         mh4g==
X-Gm-Message-State: APjAAAU6/BplXzG4HhuLs2UpR48i4qPfYBa2SgxeJpkHITWH6wcLwdWa
        KrB5steL1IW9OmOCac7OHeI=
X-Google-Smtp-Source: APXvYqy9BKWJ1epovLCQLXGM0AHNn5Pby7OpTpwIW/BY+A6+38viCy+Yyd9irIE0xi1/iiudcL9rsg==
X-Received: by 2002:a1c:6a07:: with SMTP id f7mr11651706wmc.171.1579392855132;
        Sat, 18 Jan 2020 16:14:15 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:14:14 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/8] scsi: ufs: Add max_lu_supported in struct ufs_dev_info
Date:   Sun, 19 Jan 2020 01:13:26 +0100
Message-Id: <20200119001327.29155-8-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add one new parameter max_lu_supported in struct ufs_dev_info,
which will be used to express exactly how many general LUs being
supported by UFS device, and initialize it during booting stage.
This patch also adds a new function ufshcd_init_device_geo_params()
for initialization of UFS device geometry descriptor related parameters.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
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
index 4f8fcbb5f92e..dd10558f4d01 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6858,6 +6858,37 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
 		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
+static int ufshcd_init_device_geo_params(struct ufs_hba *hba)
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
@@ -6931,9 +6962,17 @@ static int ufshcd_init_params(struct ufs_hba *hba)
 	bool flag;
 	int ret;
 
+	/* Clear any previous UFS device information */
+	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+
 	/* Init check for device descriptor sizes */
 	ufshcd_init_desc_sizes(hba);
 
+	/* Init UFS geometry descriptor related parameters */
+	ret = ufshcd_init_device_geo_params(hba);
+	if (ret)
+		goto out;
+
 	/* Check and apply UFS device quirks */
 	ret = ufs_get_device_desc(hba);
 	if (ret) {
@@ -6944,8 +6983,6 @@ static int ufshcd_init_params(struct ufs_hba *hba)
 
 	ufs_fixup_device_setup(hba);
 
-	/* Clear any previous UFS device information */
-	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
 	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
 			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 		hba->dev_info.f_power_on_wp_en = flag;
-- 
2.17.1

