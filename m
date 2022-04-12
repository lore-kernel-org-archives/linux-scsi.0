Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22E2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiDLSWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358729AbiDLSWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:22:40 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D014474F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:22 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id bx5so19236492pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q6RgkMDfw/nJyjAPJS/L3T3rA3g8xfDxZjeiiE7pbto=;
        b=fTfJumjUOabNzpZTmuLP+jQBhR7AX5/a96Uff4ulcRLxdHguyI/zS9P+E/5oEazLI8
         DPnl4cCq4apDafErgL0CXDD/yC+gqaBkESVahOpbEJLtFMj4CKrx1ZcdTjNh54LJLWWL
         TINgQ0JRpcFxZytn9WjRU9AYa0PwxJvPdS7+jW6hfGLcGVDdG2RVqc2DNm7GPIww/xzg
         bZeZGZrJDt9F1dgPsACtCSXBSmqv6mmSdygAaLgHIlF3UVbjdRzVEzBEZKNIAoU2i0hE
         JLVKFwxfzQq09irn/IADU3Iiu1IowIQ13dmJfSU9PWbL/pAagOF2RVhmiy1ucoGwVMag
         IJwg==
X-Gm-Message-State: AOAM532VbMEzedtm/wzjmdeKhk6UDBYYOxKYKcVPhetAf77/VuhFLeus
        CaBwuuhe9N/JeYcwGrrEt4w=
X-Google-Smtp-Source: ABdhPJy8k0ZHH4xnopgnX/fKbd/itKjEPPZauCDTsq19ImWZDuXA6IUixcP/dvMRTqeO6nE1pvVR6w==
X-Received: by 2002:a17:902:8490:b0:156:9846:240 with SMTP id c16-20020a170902849000b0015698460240mr38233030plo.141.1649787621535;
        Tue, 12 Apr 2022 11:20:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:20:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 08/29] scsi: ufs: Remove the UFS_FIX() and END_FIX() macros
Date:   Tue, 12 Apr 2022 11:18:32 -0700
Message-Id: <20220412181853.3715080-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
