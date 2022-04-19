Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F935C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358376AbiDSXBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiDSXBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:21 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0F8387A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:37 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso3264657pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+wbkoJU6O11IaEcR5GZXDjnJxvOiYhlZmVn4u8Ccdj0=;
        b=W1k1x1ay1S++DxdICyWVhIEFxMKOzputDnjiRhBlj0q+DmMQ6nxOegvyzIhnPZm75B
         5cIDM5FpaXZNg34Ae6J7rKX1B/hy3IMqkSbDHL9N8mXfMF48/Citm4rszl7fVFsVSGN7
         mtwztdd2RKPxdX1SRiATCTGHvpSfxblPhVmJH/5lxWS65G5DkG4hPreKFEOoT213IH4O
         6bGn9uL/p71Iocrfn5TDVa6/6BdXQRqUq+UxcrQOeGUSPJ1aonfx8z8isLg3Fk+TBIm/
         cPWckJFcdMJltRLT2aWXPyUbACZiqJalbPhA320dUUJsI/8G4m7gLkV7UIH83spbB35m
         zkSQ==
X-Gm-Message-State: AOAM531UOuae9NYecf3NuMRrAK13pgf7JPWMtmb90n0cxRh3Ye0necvr
        litXv4gPu6NjbHtDqYMHwec=
X-Google-Smtp-Source: ABdhPJzA4gpB6xSiXDXtmYgORB3JISBat7oAeU2tAsKWcWKvmVCzF9VimGwbB5valFFQrSBZcUP+4A==
X-Received: by 2002:a17:902:8217:b0:156:9c4f:90eb with SMTP id x23-20020a170902821700b001569c4f90ebmr17339596pln.121.1650409116820;
        Tue, 19 Apr 2022 15:58:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 09/28] scsi: ufs: Rename struct ufs_dev_fix into ufs_dev_quirk
Date:   Tue, 19 Apr 2022 15:57:52 -0700
Message-Id: <20220419225811.4127248-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since struct ufs_dev_fix contains quirk information, rename it into struct
ufs_dev_quirk.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 2 +-
 drivers/scsi/ufs/ufs_quirks.h   | 4 ++--
 drivers/scsi/ufs/ufshcd.c       | 6 +++---
 drivers/scsi/ufs/ufshcd.h       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index b275b440f027..217348dde6a6 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -44,7 +44,7 @@
 #define ufs_mtk_device_reset_ctrl(high, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, high, res)
 
-static struct ufs_dev_fix ufs_mtk_dev_fixups[] = {
+static struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_MICRON,
 	  .model = UFS_ANY_MODEL,
 	  .quirk = UFS_DEVICE_QUIRK_DELAY_AFTER_LPM },
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index e6c535c77527..e38dec5f0351 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -19,11 +19,11 @@
 #define UFS_VENDOR_WDC         0x145
 
 /**
- * ufs_dev_fix - ufs device quirk info
+ * ufs_dev_quirk - ufs device quirk info
  * @card: ufs card details
  * @quirk: device quirk
  */
-struct ufs_dev_fix {
+struct ufs_dev_quirk {
 	u16 wmanufacturerid;
 	u8 *model;
 	unsigned int quirk;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5fa93be246a5..9df37c80308a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -204,7 +204,7 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 	return UFS_PM_LVL_0;
 }
 
-static struct ufs_dev_fix ufs_fixups[] = {
+static struct ufs_dev_quirk ufs_fixups[] = {
 	/* UFS cards deviations table */
 	{ .wmanufacturerid = UFS_VENDOR_MICRON,
 	  .model = UFS_ANY_MODEL,
@@ -7624,9 +7624,9 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
 	}
 }
 
-void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
+void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_quirk *fixups)
 {
-	struct ufs_dev_fix *f;
+	struct ufs_dev_quirk *f;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
 	if (!fixups)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b9f17219ca18..3d18581afc2b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1180,7 +1180,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
-void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups);
+void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_quirk *fixups);
 #define SD_ASCII_STD true
 #define SD_RAW false
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
