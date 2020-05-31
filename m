Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F1CC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2752207DF
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/A4dMsd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgEaPIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgEaPIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 11:08:47 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDB0C05BD43;
        Sun, 31 May 2020 08:08:46 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a2so6766728ejb.10;
        Sun, 31 May 2020 08:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/iVfVdmH13jpJlRd9mjv8JKjfCbbit0p7BrDulSQioM=;
        b=M/A4dMsdA7oB6kxYWqouN9nahc4JHTXW0VazjPUHZBSHVyQL+y+Vjmv5vxlctK3mJY
         dnlxbqLkCXmOwropflL3WBpglEKKxmo0PC6WAcTXPJaM/ulC0IGc9gRDQZMTtTLsSmhL
         y/wQI9uNmKwqXsCCMz4Nlzv3J4F3O7uTlVqU44mD+0s4NmwX5sjcS5nBaJkBN9a4vBrJ
         TRSaKPuFLcYfc55eCm/iJAKkqFB7UtxgJZuzd4OwuO5XcAPOtLvi9PLkclgTnm5JCNjJ
         OXaAanLwMgp7ncaEN4jGeiIEVAcf+VgrsqgGF8B9S9uWSxQhMrHbrFo4jMZGRhtiklVs
         +SlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/iVfVdmH13jpJlRd9mjv8JKjfCbbit0p7BrDulSQioM=;
        b=ACXLWvj80TTpX6ZtCsV4nIxeyKAnPcEOlafghtmFMmXsFU3t1DMvufXq5ioesdS7KY
         vjtAzwuSwpV9RmnPjmQ9+ahxxyNkC0QdcysSF4S+R23Eq8evqn92y8u0Gb7aZKxWOofs
         ICStbp4tcar/QCcKe0Y4bbjoS26SwrSw4k8lGqNh6Tz4aGbXNyNfTbYp8mqALB5KW9YN
         MqHsQgG3hPyuoJgmbfM1aM/f2S41d7vNES/OlN36bjM3eUDpbUHX0L8QuWx4rR0lNzRi
         HchgTaE+HcmK20ApjImh2w1qnuL/+oXoCS2C7V27o+gzu8Nc1kxmERyGdZtdrrM59l9v
         IOBw==
X-Gm-Message-State: AOAM530/MbBSbJZ4hqLVQdt0Kaq4vVHYU9CcZKA2elCfHELWTASDLjgE
        ugI7Bdz1cjB+UYOa18MwGNg=
X-Google-Smtp-Source: ABdhPJwj5bRavswqPW99VjIlO003CrdkKjCdgvvYy8Dvx07Hn7dV1wRJeUJZkMl/GOfFG4jBKeaBlg==
X-Received: by 2002:a17:906:264a:: with SMTP id i10mr2617046ejc.210.1590937725546;
        Sun, 31 May 2020 08:08:45 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id a62sm9564928edf.38.2020.05.31.08.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 08:08:45 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] scsi: ufs: delete ufshcd_read_desc()
Date:   Sun, 31 May 2020 17:08:28 +0200
Message-Id: <20200531150831.9946-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531150831.9946-1-huobean@gmail.com>
References: <20200531150831.9946-1-huobean@gmail.com>
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

