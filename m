Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1684CC4332B
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFEE02076F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BuvGKePY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgCUAmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:42:10 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46132 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgCUAmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 20:42:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id j17so6166616wru.13;
        Fri, 20 Mar 2020 17:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xHUO/4IT5EnvhgOpN3mwFYB9rTRPPJARUg4TrZ/FZw4=;
        b=BuvGKePY7cenH+sgMOaxA/jmWptkN3I4GHbk74FWG1sQvoYWra2cpKKuvY2FN7koGL
         nNP0b2XwxvOONK+YVreUi2GytyHhL1X0nDKC4bmY5qesGln4Kj0JNtdDnpq6lQYoSpbI
         oMGQhNXE+shzk3aGlEd8GES5SkPXb6Br4CBCSfGyfqI/t7DYWnst5q9TObjU2r9FKKDr
         q4DfgmtIJBOsBeeCh4FvZHcXjEDEFyBNE56Ljh7hgAJorQ5Hn6O+rkgbibP39OZFqF2r
         LBxC5OI21TqWWXDCvy00cBMVK0FjML2K9bjpa2244YbxTjX4L9e49HbsgcsVR2di3HK6
         UmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xHUO/4IT5EnvhgOpN3mwFYB9rTRPPJARUg4TrZ/FZw4=;
        b=jQxJFn0BnOuCrjqU6t968AOw942ivxw0++ZK9hy8txrfCEGrjhK+oF2OvThaYm/Yhn
         tmekR6gYBSNaVFd/YdKB2hgB/TIMCUOLuqzYdrABlAf9JPJYWYxTIaVDx3rXkKihqFer
         HsWLwlXJmHo0IvMJ9QtLFHKozYNNd6bsv/0Xyr+MvO7nYL8D9rUl97e0Iu91e75Na2l8
         4v9TEWLMe+zPCQFw71mXLMvOHI6BD06ZuxfH27UY3EK+I1zWf3C4+8h2jItsQZqMPT+t
         e9DvZhWLjJlmSECLiQzFWJq+24iZJFXs4xWr9q2yBvY02/jsuhsgeDngWgO/2xrKXRPI
         IUTg==
X-Gm-Message-State: ANhLgQ2Z/+pnzW5A+U97bvXYl2e/LVH9b8eUsEFkD1NaFo3T3PG4Bqfk
        FgepaodFpN+CKjK9ClcY2x8=
X-Google-Smtp-Source: ADFU+vtkpcQNuQD2RQ3kIznAFVzrW3aHBbsH/LfU8OtLlVRAVlwdoIWDAzeABtYPJlyD3NwceMIeVA==
X-Received: by 2002:a5d:6386:: with SMTP id p6mr13853115wru.194.1584751328595;
        Fri, 20 Mar 2020 17:42:08 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id j6sm8194982wrb.4.2020.03.20.17.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:42:08 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ymhungry.lee@samsung.com, j-young.choi@samsung.com
Subject: [PATCH v1 1/5] scsi; ufs: add device descriptor for Host Performance Booster
Date:   Sat, 21 Mar 2020 01:41:52 +0100
Message-Id: <20200321004156.23364-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200321004156.23364-1-beanhuo@micron.com>
References: <20200321004156.23364-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

HPB support is specified by Bit7 of bUFSFeatureSupport,
HPB version is indicated by wHPBVersion and the HPB Control
Mode is specified by bHPBControl in UFS device descriptor.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    | 10 ++++++++++
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b7fec5c73688..31011d86610b 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -258,6 +258,12 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
 	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
+	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
+	DEVICE_DESC_PARAM_HPB_CTRL_MODE		= 0x42,
+	DEVICE_DESC_PARAM_EXT_UFS_FEAT		= 0x4F,
+	DEVICE_DESC_PARAM_WBB_USER_SPEC_EN	= 0x53,
+	DEVICE_DESC_PARAM_WBB_TYPE		= 0x54,
+	DEVICE_DESC_PARAM_WBB_SHARED_NUM	= 0x55,
 };
 
 /* Interconnect descriptor parameters offsets in bytes*/
@@ -537,6 +543,10 @@ struct ufs_dev_info {
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
index 2a2a63b68a67..492e4685e587 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6559,6 +6559,17 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
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

