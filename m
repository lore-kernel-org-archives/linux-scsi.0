Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2F0C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F1842075B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n7Gok1cd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389587AbgAPWAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:00:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51650 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733113AbgAPWAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 17:00:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so5396168wmd.1;
        Thu, 16 Jan 2020 14:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cvyBO8ofWpOor0eSM7A0Vaig+SAs1cZyp6W64LRJl1E=;
        b=n7Gok1cd/0ppWSxDVNQKPsBS3SFNYgIa0WqI0UeVT4y8AocCkJjNRZPATCp+LyzjgB
         kR/nMP1gshJLI6ja27/DrvvD/G9iIZ6mjt6qTUNOPGp3DXZA2ZQrgxWjooqFLQk8ZB/d
         +dGnW06ZCoYJfOiU2YqquA6iWZH9jaVQrJKs3lh3WvAq7jFh+qDmBW4274JoqJCRTmcf
         p+vG+NYv3/S/rAGvH8xpUdYbGw7Ok5jDv0xP2pG2dyAbkc1k2O5JtsBuee2DDNSP9t73
         jJbMyipInDQwpCkXrgBwysrkpojNXiJw3D3/mop24ewjU3186uNgBHMyNdN4vwrjDAIK
         LO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cvyBO8ofWpOor0eSM7A0Vaig+SAs1cZyp6W64LRJl1E=;
        b=LcjXA5HB10uE3Lf+ofkKvbEXCY6MGBmrfChoem2724XA43qn0BfT0+tRWSmFxwxbry
         qLrFxWp/v01bSY7B4gd3BJB6O4H/RgC8KU5uXVL+11NDNbR7gIv0i60KtI0jcoCURpNl
         zGbnzyHFs2ki3+L4YAoxDWsrXfuvqzXzdS9AHE4aiUzk9F61r4yMDywIRhjfdXUnpYo/
         W1NB3vWjotuGZNJTnR5NvifCjO4dFjvOsEX14Q1h0MIzYUE51ofaa+2e8vRq56Eu+TVF
         PM8Ul4Dssm4ADfWfPUm4zVwk4/f2TWLtYd3FAOctqjG23Qgrjn+ruZHW+tGaiJjxEnp2
         ruUw==
X-Gm-Message-State: APjAAAUoINcJDydI4r12MjJ9hrkqYxTYxWfm5H1jHUmn714iZM3O/Gs7
        PaI147B6Wto5Yk8Ve6xtzR8=
X-Google-Smtp-Source: APXvYqxoocNxUQX6HqT1UK6MOSXDbzVmTp5Bq1l3ENddfoVQsCqfZBSE6dSEqTbHCNYKQ0O57HM0WQ==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr1151471wmh.71.1579212033457;
        Thu, 16 Jan 2020 14:00:33 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.14.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 14:00:32 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] scsi: ufs: Initialize max_lu_supported
Date:   Thu, 16 Jan 2020 22:59:13 +0100
Message-Id: <20200116215914.16015-9-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116215914.16015-1-huobean@gmail.com>
References: <20200116215914.16015-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch is to initialize max_lu_supported, it also adds a new
function ufshcd_init_device_geo_params() for initialization of UFS
device geometry descriptor related parameters which are used by
driver. In this version patch, there is only dev_info.max_lu_supported
being initialized.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 31b6e2a7c166..0c4fb5d447da 100644
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
@@ -6931,9 +6962,17 @@ static int ufs_init_params(struct ufs_hba *hba)
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
@@ -6944,8 +6983,6 @@ static int ufs_init_params(struct ufs_hba *hba)
 
 	ufs_fixup_device_setup(hba);
 
-	/* Clear any previous UFS device information */
-	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
 	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
 			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 		hba->dev_info.f_power_on_wp_en = flag;
-- 
2.17.1

