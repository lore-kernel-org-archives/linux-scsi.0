Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AA8C47254
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E3D820757
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qJGDUr1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgEDOFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgEDOFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:05:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BB4C061A0E;
        Mon,  4 May 2020 07:05:47 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i10so21064976wrv.10;
        Mon, 04 May 2020 07:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e82KDXd5ytTWPE1FY/zm/Yn+yGNuQqRobHdfZUxy9Xo=;
        b=qJGDUr1b6TYDBapIzNQLxe5Ts1cfVojH/THrk5sefQ6nFHNOqhMRez6jGTA1SmC1c8
         fFnKM8q1pFooJviiLPuPv5zFccfe/JH29i7xbW8d11+ezDfH1sl7376SZsGNsGja4fkv
         K0zq8B4cNRNZ02o5Z0iRLOxWxa070OuKSnEfcavO9XZPO/7FLzxRtVkNM50re1Jhihmn
         RJsrRpeeFxWdaE5GVoC1Q6DAeaXJ2DehTGSmwpCyghPtQIJvp4RyiIAHLZtA44IDey5b
         xhcvjuKBz9wO//GwPTSU+HGvcwJNe1f3OQTXmEF7lEvGdIjLVFN0githgviBF/Bx10ic
         Ocrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e82KDXd5ytTWPE1FY/zm/Yn+yGNuQqRobHdfZUxy9Xo=;
        b=cTo3eKEeAHldo7K7N8bnKc+dy/tyuUHgjPQjXvBYXKX+B9pOLm+vrPnlIhtqHA8Yki
         8KoGTRvHDl70RGqmsUfOxVTD/XXuaGEs1BygWabobh+Jo+PLQCsmgJZsTD63BshF7sND
         38AiYVzan0T7I6ga++HRzOeWZCkXa72YBwy1/XydxqmWOQ79WcSeEklkKo3RCct444xu
         vOQQXAYx4p2lpm5iMqvUhp/oEV9oBkfDX81ga8UOw/5ste9y4ZLwaD4kWgFEL4rXl1fr
         KwRmpSWXKg87SghCLa78FHu/nfz3rdTG4CYZpMyvA4MrV5yq+KBtKs9tGiLJOdPi+AOd
         ttRw==
X-Gm-Message-State: AGi0PuZJROrw0hnklsOStx2M2DS+QB66kcndKb9Osr8aQFitlAJcLEjs
        J27FIVEdd7isL1bBgQpy8XM=
X-Google-Smtp-Source: APiQypLVboZXFfoMl7KADxwhjz2Ecizo8lj07+8q0K5y3Dvb0tLzXm3z7P6k8QVBjJ1TETuJxD1s4w==
X-Received: by 2002:a5d:4c4b:: with SMTP id n11mr2763227wrt.139.1588601145815;
        Mon, 04 May 2020 07:05:45 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id h137sm273832wme.0.2020.05.04.07.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:05:45 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [PATCH RFC v3 1/5] scsi; ufs: add device descriptor for Host Performance Booster
Date:   Mon,  4 May 2020 16:05:27 +0200
Message-Id: <20200504140531.16260-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504140531.16260-1-beanhuo@micron.com>
References: <20200504140531.16260-1-beanhuo@micron.com>
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

