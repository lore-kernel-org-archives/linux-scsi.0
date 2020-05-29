Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A257C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B5F32077D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="otkk4MsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgE2QlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 12:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2QlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 12:41:24 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A09C03E969;
        Fri, 29 May 2020 09:41:23 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id n5so4365540wmd.0;
        Fri, 29 May 2020 09:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/iVfVdmH13jpJlRd9mjv8JKjfCbbit0p7BrDulSQioM=;
        b=otkk4MsXwbEgxYlni9vpgpBPRIAntHOtPorh+J0eGp13/thYuSLfUUdghhYF0P7E9X
         VDnlU1MuxQHDMySdYU1seLQgPxCBcyyoLoGJn8bCiYWjrx65uUiQkyRTj0LnXnXN3Kgn
         L3R6ztT03NlbxThWiGzTyWIyiQj3c0UIBsbHUc1q6edasOdvWjKTxq4ZvnMHCaU624PK
         sK+rXBYIczjhZ9HQgZRi6XXl8fu4FXWUxgs20bvfxE2ye4okzsIh7Ceo3V5v41aSjcc2
         YK9viiz07KTC7ZyAfE2L0YpRap4Wia2iz1gKtcsOTu4s5S/cpyw0GQBU+ZNScXn+cfFb
         rdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/iVfVdmH13jpJlRd9mjv8JKjfCbbit0p7BrDulSQioM=;
        b=st5Ubio9WeXCO7Pa7VJGH/gP1MLdaC/RYa2Lnt0GyQK0b6JcUUa/WRrkxj0wgNn3vM
         KjMiEz8s/FvwaQ/H5qE+ieyxjDq/E79OdIrzOP8vDuyq17P42OyfHzxjQzq2TqUnzpIL
         YvZFkQVzU6icmeUVlJDFLf1hueGZLi2CICMmgIQp7UA7fupYw4PTn6Lopp6mk5kwAnQD
         hHWrYFZ8sfux4zL/gAHN/xmhs5V9rLH+zBW9cqvFVh0jF98939nkN7F1PkSkRcJ+YehJ
         O3mGHD3PPaQy9ei1YnPtODCx6Kt3ExUpTrU4DW7oLxkeXSTqkwyCjJFRa2pWKCehOyKU
         Shlw==
X-Gm-Message-State: AOAM530yYmhxNYRCzJ+VwDQHhzdUgZhyuunZRT26U1b38o93iyl7627A
        f5KYAiINMUWsNXetQg71nME=
X-Google-Smtp-Source: ABdhPJzMksF1nB0PsUQ7/F3DR+ZE8clh+DwsW7xE2aan9WQIiEe0EQnezRPTcPi9gES2GmA1cwhyQQ==
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr8966111wmk.28.1590770482610;
        Fri, 29 May 2020 09:41:22 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id z25sm17344wmf.10.2020.05.29.09.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:41:22 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] scsi: ufs: delete ufshcd_read_desc()
Date:   Fri, 29 May 2020 18:40:52 +0200
Message-Id: <20200529164054.27552-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529164054.27552-1-huobean@gmail.com>
References: <20200529164054.27552-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_read_desc(). Instead, let caller directly call
ufshcd_read_desc_param().

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f57acfbf9d60..f7e8bfefe3d4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3221,16 +3221,6 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
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
@@ -3278,9 +3268,8 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
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
@@ -6684,8 +6673,8 @@ static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 	if (!desc_buf)
 		return;
 
-	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
-			desc_buf, buff_len);
+	ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_POWER, 0, 0,
+				     desc_buf, buff_len);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: Failed reading power descriptor.len = %d ret = %d",
@@ -6886,8 +6875,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
-			hba->desc_size.dev_desc);
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
+				     hba->desc_size.dev_desc);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7168,8 +7157,8 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0,
-			desc_buf, buff_len);
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_GEOMETRY, 0, 0,
+				     desc_buf, buff_len);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
 				__func__, err);
-- 
2.17.1

