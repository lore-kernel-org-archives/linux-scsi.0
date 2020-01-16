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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C231BC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BAF2075B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtABQGCf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbgAPWAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:00:17 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33338 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730816AbgAPWAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 17:00:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id d139so8116196wmd.0;
        Thu, 16 Jan 2020 14:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x6sXuUhwD78rNMwCezwf2SJFMuo48cD5mQHoToWvu1I=;
        b=GtABQGCfpaKRoI5woC8t2sbkj2+IZczrtiwOMqw8JtdlNz9Dg8taQzlJcEcpW9AJv9
         6s9jtxT1FMMyPqtMLlcNL8/ETc9x3+ab1TdT7l34kDOaMDR48QdTqzMG0dxL2PsU3zzK
         xnvi7PYOoDg5gDVT1C60Tv5UcP9gg54Cg7eObhtYMDbnFUT8FYWnzL3A6Ec+xq6sF2C8
         BqBj9suGjLSOy9ndfMA22l1CETNnu7f0SLMOc0JQH/T3Achtdi9Wc1ofatLGk0Ws+sgC
         lx1t76aqqDt3uKy3tnmy8a2U5YSti3KLw/kiCDxyUEzf3f9iYms/ZbCV07Kwen2S0aI0
         gtbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x6sXuUhwD78rNMwCezwf2SJFMuo48cD5mQHoToWvu1I=;
        b=p9wIxr6giRrkEoBeGsmFnI9ySMHSfIr8gWyjitWkMCY8hcNl2yhr6t93Bx9ljF+mfN
         Qpr8R8QcqoGu++hQG0tGIS/McuJKtcuvnkCLQ7uYdMPzZUe47D7gnnqubrz/T7c2z4Of
         q2RyQUwN1H8LCjRaJtL6If21G+LQhOeeTRdrvjdcGc5boVoRsF2y3k3EfnuR6ARHJuHo
         j85qvOoQih0MU55Y0L9k1my9voURBrtRVBqtS+sSrBgaKHo0uFJowKqpr3oYMaAuGK7/
         vHwKr2GDB9N5qU6JTJIO7uuif9sAEFF3XtJF8CZmiKwcMMzcqa4Y0Z6VB19WlaecJpqK
         CkBA==
X-Gm-Message-State: APjAAAXU/IL4ekXtsBDYDeIjkNWCuHozPwMmzDY0PaN1W3iebMSP64pg
        EphBVgrGD9BmdPre5EPFOjc=
X-Google-Smtp-Source: APXvYqzZyuE5HX2fSiGO4yJ1gQ+1GFaTzyM+VZpbZ1g0gMSFlt0w+MbeEFYNLiRA0fz04c1YY2fgLA==
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr1166731wmj.39.1579212016105;
        Thu, 16 Jan 2020 14:00:16 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.14.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 14:00:15 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/9] scsi: ufs: Delete two unnecessary functions
Date:   Thu, 16 Jan 2020 22:59:10 +0100
Message-Id: <20200116215914.16015-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116215914.16015-1-huobean@gmail.com>
References: <20200116215914.16015-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_read_power_desc() and ufshcd_read_device_desc(), directly
inline ufshcd_read_desc() into its callers.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 087fd894a01b..44b7c0a44b8d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3146,17 +3146,6 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
 	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
 }
 
-static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
-					 u8 *buf,
-					 u32 size)
-{
-	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
-}
-
-static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
-{
-	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
-}
 
 /**
  * struct uc_string_id - unicode string
@@ -6493,7 +6482,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 	if (!desc_buf)
 		return;
 
-	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
+	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
+			desc_buf, buff_len);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: Failed reading power descriptor.len = %d ret = %d",
@@ -6599,7 +6589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_device_desc(hba, desc_buf, hba->desc_size.dev_desc);
+	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
+			hba->desc_size.dev_desc);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
-- 
2.17.1

