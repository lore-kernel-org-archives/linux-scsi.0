Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B66C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358373AbiDSXBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353858AbiDSXBT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:19 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A53038781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:35 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id n11-20020a17090a73cb00b001d1d3a7116bso2580439pjk.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q6RgkMDfw/nJyjAPJS/L3T3rA3g8xfDxZjeiiE7pbto=;
        b=p/PYVMjXjKJniDke6ntVHe3X+dfz9qt0uXw1kXzclGXRtxY4mLdoy+rhEnUNKFHzcB
         4fOpTsMoMcOAHcjzq6XFq0BkWDIyindc0Cg+8lb1Jnqi9rQhxPFZyt6rQWLsUEKVSQkq
         Tr51kO0xnIiQop5kyvZPTfal+aZreMoYevFi2VrxoaGrbnYi46Oz6xeXwJqBpxjUh9nG
         wVSm2MoPpxtuVkCDzqfDTaD6LKw7wwp/hI1eeySSoYXcX5DHtHTBZmTL8njTMuswny9Z
         3E24/Wr59/cBk4p+Q938DRiMWMdKuuNS88SLHteLQX98RSa3zyg1NwY2Xq0x6J3UNcCx
         AYqg==
X-Gm-Message-State: AOAM533ojR1fiVgAEtpY3u1OjiH+mmkX8XRYDkmfJcZznvPIc178Hf0z
        u7d8GvycZeH18qRb806Giyw=
X-Google-Smtp-Source: ABdhPJyInv6OKbuaouuQqq0ch0wzIiVszFY17VQuYBvdPcT3Yssj4EYqqC/+fLXHi7HndtKPCao7+g==
X-Received: by 2002:a17:90b:1b03:b0:1d2:a577:d52 with SMTP id nu3-20020a17090b1b0300b001d2a5770d52mr991503pjb.58.1650409114996;
        Tue, 19 Apr 2022 15:58:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 08/28] scsi: ufs: Remove the UFS_FIX() and END_FIX() macros
Date:   Tue, 19 Apr 2022 15:57:51 -0700
Message-Id: <20220419225811.4127248-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since these two macros reduce code readability, remove these two macros.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 12 +++++----
 drivers/scsi/ufs/ufs_quirks.h   |  9 -------
 drivers/scsi/ufs/ufshcd.c       | 43 +++++++++++++++++++--------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 86a938075f30..b275b440f027 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -45,11 +45,13 @@
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, high, res)
 
 static struct ufs_dev_fix ufs_mtk_dev_fixups[] = {
-	UFS_FIX(UFS_VENDOR_MICRON, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_AFTER_LPM),
-	UFS_FIX(UFS_VENDOR_SKHYNIX, "H9HQ21AFAMZDAR",
-		UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES),
-	END_FIX
+	{ .wmanufacturerid = UFS_VENDOR_MICRON,
+	  .model = UFS_ANY_MODEL,
+	  .quirk = UFS_DEVICE_QUIRK_DELAY_AFTER_LPM },
+	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
+	  .model = "H9HQ21AFAMZDAR",
+	  .quirk = UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES },
+	{}
 };
 
 static const struct of_device_id ufs_mtk_of_match[] = {
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 35ec9ea79869..e6c535c77527 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -29,15 +29,6 @@ struct ufs_dev_fix {
 	unsigned int quirk;
 };
 
-#define END_FIX { }
-
-/* add specific device quirk */
-#define UFS_FIX(_vendor, _model, _quirk) { \
-	.wmanufacturerid = (_vendor),\
-	.model = (_model),		   \
-	.quirk = (_quirk),		   \
-}
-
 /*
  * Some vendor's UFS device sends back to back NACs for the DL data frames
  * causing the host controller to raise the DFES error status. Sometimes
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3ec26c9eb1be..5fa93be246a5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -206,24 +206,31 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 
 static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
-	UFS_FIX(UFS_VENDOR_MICRON, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
-		UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
-		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
-		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
-	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
-	UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
-		UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
-		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
-		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	END_FIX
+	{ .wmanufacturerid = UFS_VENDOR_MICRON,
+	  .model = UFS_ANY_MODEL,
+	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
+		   UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ },
+	{ .wmanufacturerid = UFS_VENDOR_SAMSUNG,
+	  .model = UFS_ANY_MODEL,
+	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
+		   UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
+		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS },
+	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
+	  .model = UFS_ANY_MODEL,
+	  .quirk = UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME },
+	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
+	  .model = "hB8aL1" /*H28U62301AMR*/,
+	  .quirk = UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = UFS_ANY_MODEL,
+	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGLF2G9C8KBADG",
+	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGLF2G9D8KBADG",
+	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{}
 };
 
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
