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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D64AC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6446A2467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uRX+7+jO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgASAON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:13 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52230 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgASAOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so10913973wmc.2;
        Sat, 18 Jan 2020 16:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KQ+N4tgHIW2CTZZWICt6xNlWKRm3ezXQOgqUFuWPieE=;
        b=uRX+7+jO4sXPlkwbL6xZSMH/7riWE2GcLPUQNsega5krOcmjImsTlWLmdfKgm/9rWy
         BdXalv3nvsMsqM+xrH1il+d0v/l40kfUj5jHBd2L+slrW8avXfdN5n0qbWnLZYJv+6gz
         cUcloJFvBcVws8HIpGbL/5Y8fQ6YGdki/2jNASvbBu4DKW77/p5EnPuYwQWMe7LxGTwt
         PgOgJWa/tdbRiFMVOcVpxIqS91ZkOQWnlj6a1WzHBdgdGne+RPF8SFDBPbq4Rvrl7dRT
         71COKy/Wrh/QfCBGU8FtOzofSYBkdADftIlb7wxP55CDSWkZ+lel3a3nZvWtVfmf/vtW
         jhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KQ+N4tgHIW2CTZZWICt6xNlWKRm3ezXQOgqUFuWPieE=;
        b=FZ/AEukMzxwvhXi2daFGROx1Cwl3s0VoIGg5hgcW/9gwlvz8Oz6Prgh3zhy2GzHMCA
         4mLJKiMsgOw4gk98kR3BnpkCtahIp7ubf71acUyUEWId2TAKFYD+6CRl/ASFaPSdJyW0
         iRHzmf0PDg+v5DoThNxw8vczJEazbElWaEs0p+77rpxrbaa3HWV05ClhbRYRRAWMmC+q
         17lgVWAkb/aN3zIeaVRpVMqv6YvkbTNuq0DVSXwBr29XKGhK2lrx/buf7fH/mbjpX9Nk
         9lokKp0H8qFc+tYFEEkVJ2GVb4ICe+uOkzQKG1zqXmyPltU5vX9xRr7usTXj5W9gPSca
         CTxA==
X-Gm-Message-State: APjAAAV7qXIdlbinPZXg9SuPqtG4skO5Nv4yyWvCm4Zx3BpXOOGKXGiB
        XdbMVnj8ZILx8GZ1BNXPW+c=
X-Google-Smtp-Source: APXvYqzfQDxYFCAa2L7hVt9VbCi+P6vVJ7ErpDnBuDrE+db9/o0pi3qQvwRXwRhaaoLffxMDQu72BA==
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr11812175wmp.30.1579392850818;
        Sat, 18 Jan 2020 16:14:10 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:14:10 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] scsi: ufs: Inline two functions into their callers
Date:   Sun, 19 Jan 2020 01:13:24 +0100
Message-Id: <20200119001327.29155-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
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
index 925b31dc3110..5f3b0ad5135a 100644
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

