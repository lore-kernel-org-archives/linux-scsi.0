Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300F9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358680AbiDLSXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbiDLSXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:23:12 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3F74C41B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:54 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id s137so15277294pgs.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eta5PBC5X/Kb8I7p5YmauGvSBGUtRZFfJR+9ADQd7To=;
        b=nA8oQLeGfOKAGcMSrlJ5ZmZoYT1y+Zq5Ij4BCd9VsD9MxB1YhGMr6xQaprz7U6n3t4
         /PyoiQjM1FmEH85SRFL8aCjnVSSGMfihJuWmwNa99Pa1wzQ9YvmZ+P5ps8zQ+fuHnBsH
         Pv+SXi0YRYhl4mlXbVDpUd2L6qP5O9fYmk+6wTmAvdmb95bwlBLpT3GW8OoI7ov/6xjc
         yO000URN/vYn0jhw0YRpO/YElVZVacGgvHigPLizeHyk2mRXSV0fwGV3SMj6aXXn+y9E
         lNB+wN9fOQVFyRBj6Nf/bOWxnSRsISIgTENaaZ8lA5yDW3D97QhIx57lw9psbJRAXiae
         CyBg==
X-Gm-Message-State: AOAM532lB2C5AsYz5CLau/lx6ge9dE1XpnNzEaFadTH9akcj1+0Nim6C
        sQZMlQTTKZzzkhEReOeWxdw=
X-Google-Smtp-Source: ABdhPJw76kbDmdD3ACDizbVxG+F5GH4jIZMBdU5A1Hv2kBaaksclBIyFaLovB2v0Pi1caejy3w3Khw==
X-Received: by 2002:a05:6a00:1a52:b0:506:110:4ac6 with SMTP id h18-20020a056a001a5200b0050601104ac6mr3490779pfv.20.1649787654216;
        Tue, 12 Apr 2022 11:20:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:20:53 -0700 (PDT)
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
Subject: [PATCH v2 10/29] scsi: ufs: Declare the quirks array const
Date:   Tue, 12 Apr 2022 11:18:34 -0700
Message-Id: <20220412181853.3715080-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare the quirks array and also its 'model' member const to make it
explicit that these are not modified.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 2 +-
 drivers/scsi/ufs/ufs_quirks.h   | 2 +-
 drivers/scsi/ufs/ufshcd.c       | 7 ++++---
 drivers/scsi/ufs/ufshcd.h       | 3 ++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 217348dde6a6..9a4474210627 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -44,7 +44,7 @@
 #define ufs_mtk_device_reset_ctrl(high, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, high, res)
 
-static struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
+static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_MICRON,
 	  .model = UFS_ANY_MODEL,
 	  .quirk = UFS_DEVICE_QUIRK_DELAY_AFTER_LPM },
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index e38dec5f0351..bcb4f004bed5 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -25,7 +25,7 @@
  */
 struct ufs_dev_quirk {
 	u16 wmanufacturerid;
-	u8 *model;
+	const u8 *model;
 	unsigned int quirk;
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9df37c80308a..a1ebfbb6f1b9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -204,7 +204,7 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 	return UFS_PM_LVL_0;
 }
 
-static struct ufs_dev_quirk ufs_fixups[] = {
+static const struct ufs_dev_quirk ufs_fixups[] = {
 	/* UFS cards deviations table */
 	{ .wmanufacturerid = UFS_VENDOR_MICRON,
 	  .model = UFS_ANY_MODEL,
@@ -7624,9 +7624,10 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
 	}
 }
 
-void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_quirk *fixups)
+void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
+			     const struct ufs_dev_quirk *fixups)
 {
-	struct ufs_dev_quirk *f;
+	const struct ufs_dev_quirk *f;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
 	if (!fixups)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 3d18581afc2b..107d19e98d52 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1180,7 +1180,8 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
-void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_quirk *fixups);
+void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
+			     const struct ufs_dev_quirk *fixups);
 #define SD_ASCII_STD true
 #define SD_RAW false
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
