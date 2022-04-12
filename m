Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CF5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358681AbiDLSW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345988AbiDLSW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:22:57 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A2D49F1F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:38 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id r66so18010684pgr.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+wbkoJU6O11IaEcR5GZXDjnJxvOiYhlZmVn4u8Ccdj0=;
        b=qX+vZo+oNE7lj4N2kOIzcuQo8W7rwUn3IYIUZqzzpljgF7HLs6bMAPCL6b0x1DJVPZ
         bBzH+HNau2RynC9YoVRXQHRBqxUi8DylSz6LhMg2FrU/nMiPM01GThNAwabiqcIxqvcR
         8EgZ4ZOHu1OpxXvvtT5n7eZziZBn++XK860vYZsBli9ARt6zxtTLpVWqbfvM9F8ZWysd
         CpfimTZ3pxwELVq0HHXKxqAqeIka5fG7u9c+vRceFpyZUl4AcD60+8s/bH2PKWs801nT
         GeHc1KlrNSYcvnTXX6POWdCJktSTf1orKCpuwtkLSuzCpbA8xmHvbeC4cqMBBfTcJRGp
         RaiQ==
X-Gm-Message-State: AOAM5333JifWcxW6vhmsOyWws6agUh+TvnPX/raFC7KWakqnOJ01Jkge
        4nZK16CyFQ9Rby5ai3iamSg=
X-Google-Smtp-Source: ABdhPJwkSlP3O9EWhhS5FYcegH/Mz7oRzGluGJS1c10bl0JKWtkOyF900MnELsqrlEmZgI6UUGZx4A==
X-Received: by 2002:a63:cf0b:0:b0:39d:40ee:56b with SMTP id j11-20020a63cf0b000000b0039d40ee056bmr11397272pgg.342.1649787638202;
        Tue, 12 Apr 2022 11:20:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:20:36 -0700 (PDT)
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
Subject: [PATCH v2 09/29] scsi: ufs: Rename struct ufs_dev_fix into ufs_dev_quirk
Date:   Tue, 12 Apr 2022 11:18:33 -0700
Message-Id: <20220412181853.3715080-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
