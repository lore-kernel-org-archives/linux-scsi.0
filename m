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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8FCC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9BD21548
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxc1oLmB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389286AbgE1MHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 08:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388805AbgE1L4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 07:56:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A167C08C5C5;
        Thu, 28 May 2020 04:56:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s8so27527922wrt.9;
        Thu, 28 May 2020 04:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9UwLraUvWSGxTL8/w/Jkm4qi5C2Agi4iehso91sVdME=;
        b=fxc1oLmBo1WXMuBKvAkrLl7rHqdG9bsNZXFBaJZtWGrLH5q5v89kJSMJh3GoB5yIme
         11vmAKEhc1+M791N13eA1YZVqx+1UI6anSRkY3Eqdb+Gqy4GFZ7Wtxx7jsoeY7jembJe
         EocRdg3r93uoM0XuulIXfaE23Y845OuotnQER+o5C+LQ5B+ota5xjbWnZdHYKmh0JCwr
         +lUga9fs3bLUk6gKvNgjyvhNkaNKER+y9noWPQN+JVTWPJR6n71AH6tOYEMMiC4OVA6y
         qcVOSs6YMkkMJ5FAYa7SCWJAfJsOUDByZJGRLYAnd1y71/7NHZ9m8b5i83X5/tEq5Cqd
         JsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9UwLraUvWSGxTL8/w/Jkm4qi5C2Agi4iehso91sVdME=;
        b=huRIwtH8To9FdwKKG5e+lHLqVx9ZTC25AYU8KlT61MwVyHgHlrOfv8Ua8K4pCNXnnl
         Bg1fPx1DPBL/Kxy6j/3fOgd/BQBYcRScBDQdBhIk3T6bSusBW2TiuHH++XP6N3h1W8Qk
         awI0l+2upCoEeTQUnCJ2RvdICShScxC9ijYFlbzHf+MJ641CVFPKXLiWuLBnLCaMsgAb
         SRYefUV01iiUWqX0edfyaRhuRUIkBu8skr8HgY7GWUn0i5+HxnbJotVfYCPuzM5lWlgo
         6Fijb/K4HqkocbT36rR2pqOyX1XhlChfAKlHVy1dutbE8W74B7gEPN5YWC0I03NCMJQa
         4DgA==
X-Gm-Message-State: AOAM5318aEbxRW94PhIUL65tOKVml2htXJr6IvrEeVUpP8Zyso9dDoeK
        n0eZcHLxEWLZ3DJXOhs2I34=
X-Google-Smtp-Source: ABdhPJzWouZ5p9oOg1oYEbxXHI9AGgOwQUFfCqK/grNWTJV0udRVhTV0lskpt9HCgLXIlrTftKH4JQ==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr3173653wrq.151.1590667003156;
        Thu, 28 May 2020 04:56:43 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id y37sm6589178wrd.55.2020.05.28.04.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:56:42 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: ufs: delete ufshcd_read_desc()
Date:   Thu, 28 May 2020 13:56:15 +0200
Message-Id: <20200528115616.9949-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528115616.9949-1-huobean@gmail.com>
References: <20200528115616.9949-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_read_desc(). Instead, let caller directly call
ufshcd_read_desc_param().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0f8c7e05df29..0a95f0a5ab73 100644
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
@@ -6888,8 +6877,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
-			hba->desc_size.dev_desc);
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
+				     hba->desc_size.dev_desc);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7170,8 +7159,8 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
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

