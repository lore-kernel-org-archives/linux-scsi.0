Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC890C4725B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C66F20721
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMEexKN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgEDOUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbgEDOUu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:20:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187F5C061A0E;
        Mon,  4 May 2020 07:20:50 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h4so8668448wmb.4;
        Mon, 04 May 2020 07:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e82KDXd5ytTWPE1FY/zm/Yn+yGNuQqRobHdfZUxy9Xo=;
        b=YMEexKN/PoGfUuryPOYMz/0EKsYdUZXoLItcdVbdBwJLEncNgIr4UwxfEgmNl9Zajf
         V8jVUYq5BY4ccFmhJvY62nm5SnwgqdvSFayGs9uy5VTNV+7PgMpiYKAQuFpxICbFK3Uf
         7KXZ9GnYp1AUW/mWjxOTi2rW4FyW2vjXgWo4+54iUkOccrRbTBJ8jqMswmcwFojaqRTN
         v7VbdvRox+eooMknzshC646NI9cfOJbVqVKSF3snyCK5CD8dPfWZalr0gebXpu+jXW/U
         FGrNCbgBQA+UbkbSQA5np038+TXaqGsf418ZzN9bwiChZTIQQ3oV7R7zsBLhoWVRo4jC
         5uRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e82KDXd5ytTWPE1FY/zm/Yn+yGNuQqRobHdfZUxy9Xo=;
        b=Ds+CXBDV2k/QwRUcE5gAFBtpkbbP4GIC5hG9Iw/CAojfgrk+YTewvl3tJxY++iJD/j
         JaS/C6TFL/A+da++QFUdyjlKOf8vyed6PNmhA5yrwpuDL0rwiXPu2tnB45dioNOglN0K
         u2yqV+LNBY2z1MRj5QCE9JUsLhIp+x4pzc1tf6rUUv14Dt3TEoEaszdAX3r5la8uYgcT
         Rg2h1JODTBFDKkXP2ZYRrZvlzWuW/pJgwOXUg0wzhtZFaQ30SJlPZDkkP8NSX1l+HTV4
         Q8QsRPJjEGBlT7oDwS8B9XTE0e6RUpp5BgOSl0q9T+tZpUXd0mbcQErB+1btjjC2RVnh
         fkFQ==
X-Gm-Message-State: AGi0PuZtPjN7nSVgZcC5W50hplaf6VClYktQ5cU2M3xigfzcOtCuuS2U
        0woelW4eshQQVNTrs3Ngerw=
X-Google-Smtp-Source: APiQypKmTJY4b3A3bpY6R2H5HWPXZBrkmqVF1E1mJAHYVbHaHXp05+S6W+13SvcZ6v8JWDDatZhvKQ==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr15222663wmb.116.1588602048836;
        Mon, 04 May 2020 07:20:48 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id p7sm19196140wrf.31.2020.05.04.07.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:20:48 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [RESENT PATCH RFC v3 1/5] scsi; ufs: add device descriptor for Host Performance Booster
Date:   Mon,  4 May 2020 16:20:28 +0200
Message-Id: <20200504142032.16619-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504142032.16619-1-beanhuo@micron.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
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

