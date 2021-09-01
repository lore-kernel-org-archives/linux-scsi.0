Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2758DC43216
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10D2D6115B
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345108AbhIAMkp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:40:45 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42670 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344174AbhIAMjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 08:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630499899; x=1662035899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=acXOXl6f171r3xjXGOHp//YkIK3zeBR5dh3oHNFOwmk=;
  b=VMVbCrg4UbR9cM3nZi2djgg8X8fpsdCIZ7F7nHG5UBNno6yHoOKKlLdV
   RRKPbKdnSfkTeWwLbCVYNtY+B6OmknTu6eHinewwPYuyHq4TFrVpH7jZC
   c95lKYYvBxLST9HLJOsAVKtkkPiA0ZQ+NzzLfCVkSqysEXf8cKweUNmhb
   uxEHjNsTV9SeyC20LkMvzBnntne2o96BllIxKLDvqhxo9FYsORjv+9Ip7
   rwiPfmiCsuYyRmgyBxnQcIaVD0gvsS4joQMlFDWrQcQ2jY13Sg8vH2Tm7
   Y9O8dnfQNixPsSH+OwV1CPwWvheh8WClIel7Ko4wcg2EAkaduuvbZ0ZOO
   w==;
X-IronPort-AV: E=Sophos;i="5.84,369,1620662400"; 
   d="scan'208";a="183729689"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2021 20:38:19 +0800
IronPort-SDR: nCfzlD5gzCqODt3w2EXWXjagCe1HEAwEdc7ANIAzC0B4QESqgutvs0fkHHm+Q5DSM8Oahr9a2B
 e8yQ1ACdU1b+P2uVI0r9vOiplrKGdfxN6r4DbB3/pa1OFl3XeMJYbQOlEh29xqlDFKnXjrInK4
 aukxUSFyDRFNSLmQET/+iP57bWYUNy65pZpgtHN2AELpFQfuF8wVufplrxa0nn3I0ub11p4+OV
 1wcPycUj5O3a6tBMPR8mnl6/4oeFj4Ib6r8ZhT7ORv9JP/wwcE8XZCBq4RSycQu0HlKNYu4nBN
 DzbQnNWK3kqVIzE5tyJtHq31
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 05:15:07 -0700
IronPort-SDR: N9xpnGymTAS5VSDPvi1/q4V5nETrIOGTDT0iEkST7nG76GigU6JVZYoi+VzTNetwjnSUXwJZwF
 khnboCDnQo1mCIJ6wxdQ0trM91u2ZiMYNavX8xRVheguf3fiGa+pZ/Z2z3GQoVaDlRaBD4LFpz
 H7bT+Rv+KpDQ7aPYmJlGnj2umJdB2gXOGsQeUe9rqvukmBi8yJULlqgxkA6uVKc1E0/n4oh2Th
 iLSHclB68ZiHkmNCoRuRGVoaIrSkPSrIgF2wUc+AOEtjNLy28yh+T9K1iWjBFHXk+Tg7jGAcUA
 RSU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Sep 2021 05:38:18 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/3] scsi: ufs: Probe for temperature notification support
Date:   Wed,  1 Sep 2021 15:37:05 +0300
Message-Id: <20210901123707.5014-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210901123707.5014-1-avri.altman@wdc.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Probe the dExtendedUFSFeaturesSupport register for the device's
temperature notification support.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h    |  7 +++++++
 drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h | 22 ++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8c6b38b1b142..dee897ef9631 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -338,6 +338,9 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
@@ -604,6 +607,10 @@ struct ufs_dev_info {
 
 	bool	b_rpm_dev_flush_capable;
 	u8	b_presrv_uspc_en;
+
+	/* temperature notification */
+	bool high_temp_notif;
+	bool low_temp_notif;
 };
 
 /*
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..6ad51ae764c5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7469,6 +7469,22 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	hba->caps &= ~UFSHCD_CAP_WB_EN;
 }
 
+static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
+{
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+	u32 ext_ufs_feature;
+
+	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
+	    dev_info->wspecversion < 0x300)
+		return;
+
+	ext_ufs_feature = get_unaligned_be32(desc_buf +
+					DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+
+	dev_info->low_temp_notif = ext_ufs_feature & UFS_DEV_LOW_TEMP_NOTIF;
+	dev_info->high_temp_notif = ext_ufs_feature & UFS_DEV_HIGH_TEMP_NOTIF;
+}
+
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
 {
 	struct ufs_dev_fix *f;
@@ -7564,6 +7580,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_wb_probe(hba, desc_buf);
 
+	ufshcd_temp_notif_probe(hba, desc_buf);
+
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b18..467affbaec80 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -653,6 +653,12 @@ enum ufshcd_caps {
 	 * in order to exit DeepSleep state.
 	 */
 	UFSHCD_CAP_DEEPSLEEP				= 1 << 10,
+
+	/*
+	 * This capability allows the host controller driver to use temperature
+	 * notification if it is supported by the UFS device.
+	 */
+	UFSHCD_CAP_TEMP_NOTIF				= 1 << 11,
 };
 
 struct ufs_hba_variant_params {
@@ -972,6 +978,22 @@ static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 	return !hba->shutting_down;
 }
 
+static inline bool ufshcd_is_high_temp_notif_allowed(struct ufs_hba *hba)
+{
+	return hba->dev_info.high_temp_notif;
+}
+
+static inline bool ufshcd_is_low_temp_notif_allowed(struct ufs_hba *hba)
+{
+	return hba->dev_info.low_temp_notif;
+}
+
+static inline bool ufshcd_is_temp_notif_allowed(struct ufs_hba *hba)
+{
+	return ufshcd_is_high_temp_notif_allowed(hba) ||
+	       ufshcd_is_high_temp_notif_allowed(hba);
+}
+
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
-- 
2.17.1

