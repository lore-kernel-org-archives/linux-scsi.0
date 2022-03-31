Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111A7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiCaWhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240705AbiCaWha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:37:30 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53421C8A86
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:42 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id y16so748322pju.4
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2UKik1AvdjsgVOSYU+mAWlcydI1TmampoecGih7letE=;
        b=St4QeGJ78FctPm94TJqYlvy2ner+DLru84rprTa28ipfAxbebIrxUgTazP8d6o4Pfu
         O9ol3SV+tVIG78SiW+ArE2f1BUdh/vZPoA23tUvMZplTHbjhyjtEdz0ZaKJEwqXliHZh
         MwaqBIbgcWmGSpa83n7sVuGVxmP6gj3cJMkkGqp+Anv1G5KHCJzAk66jygyQVAmSmZpW
         mS2GphNdtrQRfv19jhkjitpeogsRKuxnmS+2ljoKE+pgPQfuY4TBNLm+yfmNU0YrtsNp
         fdvqiLpwcD0ZhU5wIzQIArWoL1OrVFN6i9zNrhmufuXxoCnfVw3iXqXZ2JgrLuolz5WD
         Pm0A==
X-Gm-Message-State: AOAM530gRjWWGbavJIbPrTTSHjBEQwDloDHRi5iSl6Mn3mh+Fqp0EsDv
        lI+WM6i2nRcz1BR3cVKPpQm+MV0Cn0U=
X-Google-Smtp-Source: ABdhPJxNSfsNgBi+xDdi2MCKLtML1TMYQbDwbnqrppOKpcdK9Xj0AKXx2qlhL0+urDyQQkeQpM8Z1g==
X-Received: by 2002:a17:90b:4f8e:b0:1c7:3652:21bc with SMTP id qe14-20020a17090b4f8e00b001c7365221bcmr8461026pjb.38.1648766142072;
        Thu, 31 Mar 2022 15:35:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 07/29] scsi: ufs: Remove the UFS_FIX() and END_FIX() macros
Date:   Thu, 31 Mar 2022 15:34:02 -0700
Message-Id: <20220331223424.1054715-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since these two macros reduce code readability, remove these two macros.

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
index 016734e987bf..b7cfe2dca705 100644
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
