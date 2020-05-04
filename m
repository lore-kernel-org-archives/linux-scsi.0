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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E122C4725A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37BAF2075A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qgix53e3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgEDOUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbgEDOUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:20:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C81C061A0F;
        Mon,  4 May 2020 07:20:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z6so9296654wml.2;
        Mon, 04 May 2020 07:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ErvFEMKqvUABuF+OXMSZ5E2o1lqXb+dXgSMBGHbqzAg=;
        b=Qgix53e3HeujOhrnlznsYKEK4vClo6IDxrfA1TV2FsvQ1IC6oNegc3jjMdUIFIbe+3
         t7VX2JF+2VEz2tcBjQCC3jxE8j/m5PjLCmNINc7mFBXbtbovlW/r2iXj75af0d+M4Md3
         czYp3jyPAvezsXMMSNYw7z+yBCg9+ox+Q0kX6LmjCy1dhJcNNtb0SpU1jUp02iq79Pq8
         orEtUa4KcE9BfoHon/4D01Gf0YOVgteJhArE+1apKXu7gJKU0rd5oCfTxCe76m1cJDgg
         93k837IF5NrIF1SVoIzXXUVVSCH9J1OTH30duBZ49vnT2W9PP6JwyJIIhzb1Tce9Wbph
         ao3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ErvFEMKqvUABuF+OXMSZ5E2o1lqXb+dXgSMBGHbqzAg=;
        b=t+gLTKG3kJFvqSE/Z3RIlaRgBCY6H57stJzH14pe/LE7pS1HJaiHvjh4TDSS82MuM9
         H+SNiy0o1QG6yORgl3NUhAlQWB0dVbbYGxoEMKa5OfywN5Pq1U5AgtHX0n7yW8/0U0Wn
         wx99cAuTHlWSZcgsB/qW/MSk/i0KmmxFESHzHR9RgESMVUuRDTfnwHmAluCZlLyM0YnL
         EiIWG/wFQOrWLc7YBoDtGT5GTAmypdUz2pb6ONQaWT+criRpQwskI/aTl+KWCJO7rJ7G
         fdEs2t5wzV9ICvrBzZyNLoO5/4udvM5RCVhpgfno8yWzZO297D7fbdQnyjzUno8qBpUP
         wuGA==
X-Gm-Message-State: AGi0PubzhATONIYWhqRndZlzTDiTSl+ZzhTWvdvj7hw239MQ93x4pPAH
        Qx3JsBftxs7qg6gd2oCKcrM=
X-Google-Smtp-Source: APiQypKB6teEWDukrxueZT+Lwwp9xQXVRL096NDUlFRo3XPyD6JnSYhtjn7xt239Sw4VXEEzwUZTWA==
X-Received: by 2002:a1c:bd8b:: with SMTP id n133mr15932447wmf.175.1588602051377;
        Mon, 04 May 2020 07:20:51 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id p7sm19196140wrf.31.2020.05.04.07.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:20:50 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [RESENT PATCH RFC v3 3/5] scsi: ufs: add ufs_features parameter in structure ufs_dev_info
Date:   Mon,  4 May 2020 16:20:30 +0200
Message-Id: <20200504142032.16619-4-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504142032.16619-1-beanhuo@micron.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
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

