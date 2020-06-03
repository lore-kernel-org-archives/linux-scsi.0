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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72CAC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4ED62077D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3Rzqkip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgFCJUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgFCJUT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 05:20:19 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7B7C05BD1E;
        Wed,  3 Jun 2020 02:20:19 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id q13so1143071edi.3;
        Wed, 03 Jun 2020 02:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xU7pX4nkK7ZQg7clUMzQ4yPEEjGSdbLLAvPKUl0GCPM=;
        b=L3RzqkippX2qj1i6eCQ5wpBKTfjAzeOGUJeZHSyz1uM5TAj9tfrJw7HGi6Nt8tPeIE
         J+Y+Q4PbcOq9uP1M9n0kW79eS+E4RC072dnehJlQfZ53T5Z2pGVdL9s3ewLRIAHGVCb8
         kvTybfqwvz5cwZfhsLLDljSa4VPfj/q+6ZYnUXqhbYScms91UK6MsBaklPeu2ANigvxu
         0H98xL64nCPH2SmWwPT3iO7NaHaV+YrGtcoWhDQGQWEi0at9lDye5cGIKaSsUsp0fSCJ
         CwV2EWzn9bICFXGHLXNgh7zgYcQhkJXAEH3Y2wQ4nrO3o5IYsXRRVodoOACobTgc54Ev
         lnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xU7pX4nkK7ZQg7clUMzQ4yPEEjGSdbLLAvPKUl0GCPM=;
        b=oTFPR155lYQNS1PUyUEcrwaVl7N8cvElTx35JR3zuL8FkpgPXqRiOC2SKxjgizQRhn
         qp5KrJ8Ti0AU5+72zOgkr50YX97APH7sRS7cLZOZp8g8PnSTRmQo112nb3+wq1xNQci0
         IAyrmUHLTWrlpWQIvfCueh/fSLiCvTR4rXjbbHi/PELt71vpL8lpP4zof7SEqgpbrYoC
         40oTFn9wtkyO17ClDnh4kbOuwskLb5rF74jECwx5a5qT1l4ndI6PJTPYDyXPBhvea204
         Ja8q559cUq0VYnotoBdmQvet8WgJQIxuGHSfzPLLHdfDWFg/P4Vr2kDpEwM9rdLt4aSc
         ZSRQ==
X-Gm-Message-State: AOAM533g9zyTxIJNpgPE+p5dmM4BgFNSSo678Eybfolf5adO7sg+XBUs
        vWkY7KIRtk8069sMn5RO+08=
X-Google-Smtp-Source: ABdhPJz65a3RCO/nFWS+lEzKjLuelstixw+3z5Wxj/AMi5H3E8W8EY5y9nAdTSz/0uTQdNP9ZDhMqQ==
X-Received: by 2002:a50:b2e1:: with SMTP id p88mr30552214edd.198.1591176017991;
        Wed, 03 Jun 2020 02:20:17 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:d00c:464c:92b:aecc:3637:dc7c])
        by smtp.gmail.com with ESMTPSA id 64sm865636eda.85.2020.06.03.02.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:20:17 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@outlook.com
Subject: [RESENT PATCH v5 2/5] scsi: ufs: delete ufshcd_read_desc()
Date:   Wed,  3 Jun 2020 11:19:56 +0200
Message-Id: <20200603091959.27618-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
References: <20200603091959.27618-1-huobean@gmail.com>
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
index 2cf077ab9dfd..c18c2aadbe14 100644
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
@@ -6711,8 +6700,8 @@ static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 	if (!desc_buf)
 		return;
 
-	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
-			desc_buf, buff_len);
+	ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_POWER, 0, 0,
+				     desc_buf, buff_len);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: Failed reading power descriptor.len = %d ret = %d",
@@ -6913,8 +6902,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
-			hba->desc_size.dev_desc);
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
+				     hba->desc_size.dev_desc);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7196,8 +7185,8 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
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

