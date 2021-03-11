Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A818CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 04:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD8A64FC9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 04:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCKEbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 23:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCKEbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 23:31:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3E1C061574;
        Wed, 10 Mar 2021 20:31:12 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso8710994pjb.4;
        Wed, 10 Mar 2021 20:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mEjDV/O8l5hDdxOQbn3qkabPboaV3CHH0IKXvxVr6bQ=;
        b=q+n8E4ae/oeU7oMJJFh+ctPIJwKYKPutmyWF2dw16K4RUeCfZxA6VsQdMvsJBBf8FS
         Tw0ukLPQQJxbYlR0ghOC04QH147x4xbNWl69fi9fibBgo564zzo3pOA1jCLV1fonFHox
         OkV+COdD/dVxpAWF8E6yAct8YqrDbN+Bz3vVMhu05EtIN025Q0mq2J+LTzTX8dvxzm0z
         MXeex5Z9b5gB4vF/54B3MpUOjG3ocyua7NvOzxrHi+q27zgGvOCinGubwsT8n3SNdCle
         GIAtHpVSrccOYo0hHjqUE8AIadKMA7/UP3ruQlcAs7Tg5D32/FogpS4Uy4gEiWS5JJ0m
         DkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mEjDV/O8l5hDdxOQbn3qkabPboaV3CHH0IKXvxVr6bQ=;
        b=T2H1bF1EN8wZJSum/HTytwQGFldo8RFNdy7T+2zVbOSY+DU4YugY4sJlRppRoq4o0n
         ONP6aEf/4TxnBiHASi20xp45XiSxl36KUD5rpQSeUHEM+M/dnpWHX0zSfKdxhJ9Vi60M
         /e85f7LAsBYW/nUHz2ERbMh1gMOIushkF4xZ59tTxtZgehc1T/jskGJeZTCtdpLggiRV
         6Knz7sBdgual4FYNOrT/U6dIkCLPvSI9z13sQ8EBm9fykJkg1iw648cQBmkqGgVgTo2a
         DnxzqSC6lVGb9OFJ21SCSqitioqPiOW5/FHKBAJ6Q/6hvGscFqiZLPswb9TWOe04m4ZD
         BvmQ==
X-Gm-Message-State: AOAM532nXipdSBdr7RGEfyVnEfVM6P9k/NSWT4m7vnzDgJsk8Zb+77HY
        5l+EHcBkFTC92l1HVAi3FSY=
X-Google-Smtp-Source: ABdhPJyKkGBhUvNBvON2p54DRI54gv3FLdFP3S4fEfbnek3untuPtrLF4y8ZWzT5FygwuKLmN4KSkw==
X-Received: by 2002:a17:902:7407:b029:e4:9b2c:528b with SMTP id g7-20020a1709027407b02900e49b2c528bmr6441234pll.6.1615437072252;
        Wed, 10 Mar 2021 20:31:12 -0800 (PST)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id a19sm886923pff.186.2021.03.10.20.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:31:11 -0800 (PST)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, krzk@kernel.org, kwmad.kim@samsung.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-samsung-soc@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com,
        zhangwen@yulong.com
Subject: [PATCH] scsi: ufs: ufs-exynos: Remove pwr_max from parameters list of exynos_ufs_post_pwr_mode()
Date:   Thu, 11 Mar 2021 12:28:33 +0800
Message-Id: <20210311042833.1381-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

We don't care pwr_max for post change of power mode.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 267943a1..70647ea 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -652,7 +652,6 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 
 #define PWR_MODE_STR_LEN	64
 static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
-				struct ufs_pa_layer_attr *pwr_max,
 				struct ufs_pa_layer_attr *pwr_req)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -1155,7 +1154,7 @@ static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
 					      dev_req_params);
 		break;
 	case POST_CHANGE:
-		ret = exynos_ufs_post_pwr_mode(hba, NULL, dev_req_params);
+		ret = exynos_ufs_post_pwr_mode(hba, dev_req_params);
 		break;
 	}
 
-- 
1.9.1

