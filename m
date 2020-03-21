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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA25C43333
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728772070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVLI0Tbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgCUAmV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:42:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39696 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgCUAmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 20:42:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id a9so5212176wmj.4;
        Fri, 20 Mar 2020 17:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lVP2XNgIJeklriVWAYTHlxvdjCHLV2eQDDvuhSH0R3k=;
        b=WVLI0TbrFE42mo/7bRpATDTpoUWPChiIkpdu6uOObz5FzHBnWHnTocEEfQWUQjgctF
         hqKX20yqWo0V7MxaatQ2hX43xjwJ/FPBs439K+oqwxuR9uELkOquF74/Zr5fUvvUyhkc
         y3L21dYD9CSHkO3oa1SIdBPUwuevEKjITJdRS8EA00Cu+7NziuKcmBr2sFhixxu+6vEY
         KAHkwrReWr43rh/5zmtqBtf1x3SQfQ5rAq8Sx+UQm7gG3jTL9hRZHUlJ2td0Y4GYHx3q
         wddvHIpdd80XHgUBQIMLDNN54tgzqsHVLtYRin6eJTRA1nLeBZhlMh7KmACmoD2jiCFL
         v5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lVP2XNgIJeklriVWAYTHlxvdjCHLV2eQDDvuhSH0R3k=;
        b=dvlGMJi3roCO2p52fG3MiZiAckHulr3pcTS3g6QcxeJs6zBFiyqdSpaw99BldoT1mp
         IhQyfnQk9BhHH3GSnndePW7AfNu77m/TcJucB6cqgUk/NN0ntRv5OQgcKiAACjRtgYdf
         aP6hiypTj4KVFo9yruxHZYl9bCGtqCYwQKcBA0nCMsY+8W0i1vS9jRjbNWXO1OZb6B85
         X2ybfHnWmHDAOCJs2NqhjtfwbcOpTNsHjwXTiecl8KAuz1s1E9d6s+zrL8UmZ3MAhmW9
         F9APdC2Qm+7HHSfX76j0KHpYN5RhRtlbNpv4HbR5k2nvq3tvxGHi6TYleELZairTFldx
         lsqg==
X-Gm-Message-State: ANhLgQ2bCJL33ss2VXQn+xaF3Byd1hOmhbNOPIITVCiLZT3Uu+2YguPh
        CaLtAdXCCHsK6os3yl6gmDQ=
X-Google-Smtp-Source: ADFU+vvud2KuqkqZJeCp/1DyGzpd4IcD3pRwmenHWdnkopxhmGTIWxVipAVEg6eJCQOtrqiOUoGLPw==
X-Received: by 2002:a1c:9693:: with SMTP id y141mr12870089wmd.23.1584751331082;
        Fri, 20 Mar 2020 17:42:11 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id j6sm8194982wrb.4.2020.03.20.17.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:42:10 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ymhungry.lee@samsung.com, j-young.choi@samsung.com
Subject: [PATCH v1 3/5] scsi: ufs: add ufs_features parameter in structure ufs_dev_info
Date:   Sat, 21 Mar 2020 01:41:54 +0100
Message-Id: <20200321004156.23364-4-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200321004156.23364-1-beanhuo@micron.com>
References: <20200321004156.23364-1-beanhuo@micron.com>
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
index 31011d86610b..1a0053133a04 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -547,6 +547,8 @@ struct ufs_dev_info {
 	u16 hpb_ver;
 	/* bHPBControl */
 	u8 hpb_control_mode;
+	/* bUFSFeaturesSupport */
+	u8 ufs_features;
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a40023ad1336..8c7a89c73188 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6557,6 +6557,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
+
 	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
 		hba->dev_info.hpb_control_mode =
 			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
-- 
2.17.1

