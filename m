Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BADBC47254
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3856620757
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stjHdQdv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgEDOGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbgEDOFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:05:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C465C061A0F;
        Mon,  4 May 2020 07:05:50 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z6so9220741wml.2;
        Mon, 04 May 2020 07:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ErvFEMKqvUABuF+OXMSZ5E2o1lqXb+dXgSMBGHbqzAg=;
        b=stjHdQdvYoqhgxBBTq1T0JVz+IpRPw3DwhxZVt77BBjfklLpXZmbshjACzLHyezrJl
         7tWVPq06eclo5G9xuhPc5dNpMorhZ4ENiE6FaDfZZOaiF33/vGbgrLcLFjmQB/n+9Dqp
         iaOipRXFCDhvWjadn0a/dvY+r7rE8BPO4IiCh4jp3YjXX4yHSoG7Ix7X37r+fiJWXNjT
         hRgdpjBSZ+q2xUFYu2NoSmKipYDSI3mbvzbJIeLFuDvFXro/6W+OFO+pP17zLkeVybxo
         fB/AkFcGUTAQ6CFtjyA/r4bsrOe1pIPbFoBvf+agxWBLVCuv+NPewAMe0GfF1869vzpB
         imEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ErvFEMKqvUABuF+OXMSZ5E2o1lqXb+dXgSMBGHbqzAg=;
        b=FT1AZ6xL1jJY2vtTS4T4uWcmZxE511Jf4Iu5jzY29VvUzonV823n5TIQupMc52tVVe
         PMTKi1Y9DvN+oCbGEj8+CCweyapYY0Whunv3LARHzPih62P93fzBS67IUL2/ha0YvduK
         QyJjeN/KKkxOFw32+mVCMskC3zmk/vlV0q29R/LZTDtT6iIJsa2vuwHLVVXraaQTGpCi
         Q6g5i01D6qIy+KKDQzXXqQ9X1RDAxy5486TEdyHP0ME3RHm0T1f8/QaPsmXkIblreJ37
         kGdLVI59++rQfhIGDw1bYLDbu0mBxYisGkVbVst1IzGVBxKY5O26ZUNDrjxstnVIZjbF
         ZYnA==
X-Gm-Message-State: AGi0PuYlwEDQLQalHzsD7PjBqq40haaGWM+MJq0pc/MaBOrHcBVqvf2E
        05XsqvP5Z8N6EICDwSw4pYg=
X-Google-Smtp-Source: APiQypKAQLLE2mjpAFWf4KcJIDw1JyCgSZma3SQ0vneWyKk94EX80M9q+Lo2cdiGxevlFoolf15bbw==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr15887120wmg.183.1588601149013;
        Mon, 04 May 2020 07:05:49 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id h137sm273832wme.0.2020.05.04.07.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:05:48 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [PATCH RFC v3 3/5] scsi: ufs: add ufs_features parameter in structure ufs_dev_info
Date:   Mon,  4 May 2020 16:05:29 +0200
Message-Id: <20200504140531.16260-4-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504140531.16260-1-beanhuo@micron.com>
References: <20200504140531.16260-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Make a copy of bUFSFeaturesSupport, name it ufs_features, add it
to structure ufs_dev_info.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    | 2 ++
 drivers/scsi/ufs/ufshcd.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 53a5e263f7c8..1f2d4b4950b8 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -543,6 +543,8 @@ struct ufs_dev_info {
 	u16 hpb_ver;
 	/* bHPBControl */
 	u8 hpb_control_mode;
+	/* bUFSFeaturesSupport */
+	u8 ufs_features;
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 83ed2879d930..1fe7ffc1a75a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6625,6 +6625,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
+
 	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
 		hba->dev_info.hpb_control_mode =
 			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
-- 
2.17.1

