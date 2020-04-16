Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41740C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1875D206A2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbLQGmH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgDPUbu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 16:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728880AbgDPUbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 16:31:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F4AC061A0C;
        Thu, 16 Apr 2020 13:31:47 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so45801wrv.10;
        Thu, 16 Apr 2020 13:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e82KDXd5ytTWPE1FY/zm/Yn+yGNuQqRobHdfZUxy9Xo=;
        b=fbLQGmH060SUxuiJXgFOK9u5htf1EMwb3O3t9XcTaqIeBRKXe1T8OAT0xtqyU1Sw58
         HQrHcTpV1+TqofzLRyEfxwicePTcvbZMeccmQ/KykjZNSn9WwOMLrfl1m0kCLKn5ZZbQ
         FafwCKHnc2idNjQic3oJuBM6c9Dmt/td6ry1+EYKpciQwC7nOoutM1WCBNOlJise8pW0
         EjgDCZKfwpFSK9s/+Or70Ht3yG8Fpe9ahzNMvdXjtzHGMyxY0bFym7nQbWFFNSLuhH68
         3caKHl21e8LMlL+hQKOqUWvCmEFgI/fmfFFtvJNQbXYQ86Gq0hJB5iAc+p3ihdHsymjD
         JuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e82KDXd5ytTWPE1FY/zm/Yn+yGNuQqRobHdfZUxy9Xo=;
        b=r8DcWQXZ0dA/HXjmbmEJllVaevv1OsKkJwuK5x9XU3gDkclTJyMACCM3W0aViJsNl9
         dAUjt38jfT4xKD+UVi/xeD9wSZvyqPCpm2fppLxTv8e97YxvRDKi6xVxZiYNzfkP2R2H
         0O28m13mn/nYo0MM6SpL/3qgeRdjKA/H6ZwBkD1ckZ1CVTzgqN9c7FPwf3+hVSiVTMOd
         bW9aYXFmFNqkEyOf015KN11XahwW++oKmqF/ch69Mt1/XfLQ5gn2M7XVKKSg7LU6qD3y
         grePLOD9MGfYzKTnoi+J1yMZ10wdC9S75+uVMF+I1uTi2NGgsEz9pRuFwBMujy5HqWSS
         tTGA==
X-Gm-Message-State: AGi0PuYLNB43BBaCQavOriijvHCpbF3BEOBeB9pXxFLhCdSyVaML/mKX
        okSKZpB5CryAyWxT09fvz0sAF0hU
X-Google-Smtp-Source: APiQypKI5WWL7tR02tmS9O9V9xwhJMBHAAKYX7gzZu/UxCyMHcdRTQ/hquWlT+mCgWQH3gCbkgx7Fg==
X-Received: by 2002:adf:9e8c:: with SMTP id a12mr35563836wrf.273.1587069105614;
        Thu, 16 Apr 2020 13:31:45 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id s9sm17638864wrg.27.2020.04.16.13.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:31:44 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] scsi; ufs: add device descriptor for Host Performance Booster
Date:   Thu, 16 Apr 2020 22:31:22 +0200
Message-Id: <20200416203126.1210-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416203126.1210-1-beanhuo@micron.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add HPB related attributes in devivce descriptor. HPB support is specified
by Bit7 of bUFSFeatureSupport, HPB version is indicated by wHPBVersion and
the HPB Control Mode is specified by bHPBControl in UFS device descriptor.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  6 ++++++
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b7fec5c73688..53a5e263f7c8 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -258,6 +258,8 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
 	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
+	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
+	DEVICE_DESC_PARAM_HPB_CTRL_MODE		= 0x42,
 };
 
 /* Interconnect descriptor parameters offsets in bytes*/
@@ -537,6 +539,10 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
+	/* HPB Version */
+	u16 hpb_ver;
+	/* bHPBControl */
+	u8 hpb_control_mode;
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..de13d2333f1f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6627,6 +6627,17 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
+		hba->dev_info.hpb_control_mode =
+			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
+		hba->dev_info.hpb_ver =
+			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] << 8) |
+			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];
+		dev_info(hba->dev, "HPB Version: 0x%2x\n",
+			 hba->dev_info.hpb_ver);
+		dev_info(hba->dev, "HPB control mode: %d\n",
+			 hba->dev_info.hpb_control_mode);
+	}
 	/*
 	 * getting vendor (manufacturerID) and Bank Index in big endian
 	 * format
-- 
2.17.1

