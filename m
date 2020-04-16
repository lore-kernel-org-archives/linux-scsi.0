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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347CCC352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A006206A2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bb4ixb4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgDPUby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 16:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729850AbgDPUbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 16:31:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F7FC061A0C;
        Thu, 16 Apr 2020 13:31:50 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d27so109941wra.1;
        Thu, 16 Apr 2020 13:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ErvFEMKqvUABuF+OXMSZ5E2o1lqXb+dXgSMBGHbqzAg=;
        b=bb4ixb4ZhhKUBs0oKMGZBaI0kDD3m8PIzzxadZ+5GQTPV4d16HjsHxAHF2l8xQe/NL
         DTPUdb0HabS/+QmIkXm6f5XzR79Clh3xIrVTJx0PFTvpSHWc1nOMpRMHjiHzWxz+qUK8
         Sx4xLr6v0fjWwKS0nDpARyDJdhH1ZNsmCocpPkLWK97245CwE/3W3yHGZDzC+4UkWa0c
         cV+jlT0Bz5vmFMmOcy6NK4xHjokTJUgF2tYD9UHxyLMh6ifZ1NHmDsbiJ6mGDtJxYK2E
         AncX4ORdq/l0/Fx4Se2L6N9nLjSZacYvAidFTEpPlCNeeasHLdB8WjFZdID3x+i92SOs
         vHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ErvFEMKqvUABuF+OXMSZ5E2o1lqXb+dXgSMBGHbqzAg=;
        b=ZQIT+TpBk3V44954DJRNKapY3q6cn1eBRmGXOTsxB1hAHXL7VdBIKNAhPfpiFXLzLa
         1M1+LpYlhagLaSfO665KlelxUYoZnGRBFkLuwn78kAQXH5LbGFmybqLB+wJqkbG9YoSw
         KWVDNNGG2clFv0mQ3nJyj65q+EFvACIN4v3t3QNE6DDSKuJQVtw2B4BX6Mhiu2fmtWeG
         7aFO3QrXKybnmUiIOYOzDNHC9LvFHfY/7LxlzvzVJ/r+q/cOeK5BrEViNx8y4H0Z3i7g
         4nMBgcesdnvrDmyVfy7pAUNIjG6l4NQMpN6xoIZnHnoZq/mQD/iTWG6quawScAO4YnBV
         GhtQ==
X-Gm-Message-State: AGi0PuZXQWiSatJZeDIJZQyKX6dZGXRnBGowqXyYbMHQUdt5INi9jN6e
        au5j/kHLsGhpj2uuzeKNj/w=
X-Google-Smtp-Source: APiQypKqyoQT6iNUhpqrAs/37j2O40X3p7qsqvY6ggm2qmSg5FUpUc6lUKbEqnzGCtsCccntibzyMA==
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr23313wrv.314.1587069109132;
        Thu, 16 Apr 2020 13:31:49 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id s9sm17638864wrg.27.2020.04.16.13.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:31:48 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] scsi: ufs: add ufs_features parameter in structure ufs_dev_info
Date:   Thu, 16 Apr 2020 22:31:24 +0200
Message-Id: <20200416203126.1210-4-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416203126.1210-1-beanhuo@micron.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
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

