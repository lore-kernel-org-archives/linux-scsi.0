Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71994C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242538AbiCaWho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242516AbiCaWhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:37:43 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B4D1EDA1E
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:56 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id j8so854665pll.11
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWKR4FmwBXpogmlC5503V7TOK4itKJX6I5bP+X/OiGU=;
        b=hxKGz/nUTBNsyKV2dMLlDZL88IKTIGRVrKMbVwAnwSHQ/XAGWEcOAji2Zp6l21j2H6
         lhQVWCDBf73vKRc+VHk/YieGKloDguHSLTxuIdaExZeUUZt1LmV1JRLfI9uG0NLEdPW5
         gH21PUTAz7GK5M6fE7JalppBY/eNYpTFh91zr6ROFZ9gbiFTgEOS7TPPA88rvpSQx2Ed
         2HTFpl6QxUwSeRcWpOmcESb/ZOf5AxdVwPo4rPir6VjMMMIkI9Xokq38yPtK0/P8K+CX
         63BdQjKv8UgNH29Zajz9O7OwhXwe1+FuLa5st5w5wiZgTYVk6xKynwSc6eUz5VbwAEGA
         2hHQ==
X-Gm-Message-State: AOAM533sp31U+QdlM1+lkP3l/uefCl+YBOMlKrpcN+wN69Ym8ixk5nax
        qbsN9mns2V+QiX9TumGrSo0=
X-Google-Smtp-Source: ABdhPJw8iaDRes4VlnNId9lDHEFCDXxbdBL14IEAY07QZ8EpIVYxBaGQgdH0AXfZK6OYTFwH5JIxZQ==
X-Received: by 2002:a17:902:70c1:b0:156:16c0:dc7b with SMTP id l1-20020a17090270c100b0015616c0dc7bmr21308805plt.85.1648766155569;
        Thu, 31 Mar 2022 15:35:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:54 -0700 (PDT)
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
Subject: [PATCH 08/29] scsi: ufs: Rename struct ufs_dev_fix into ufs_dev_quirk
Date:   Thu, 31 Mar 2022 15:34:03 -0700
Message-Id: <20220331223424.1054715-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since struct ufs_dev_fix contains quirk information, rename it into struct
ufs_dev_quirk.

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
index b7cfe2dca705..97b9b2b77593 100644
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
