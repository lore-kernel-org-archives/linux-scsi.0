Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA5AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358378AbiDSXB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358375AbiDSXBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:23 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D6838781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:39 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id b15so193147pfm.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eta5PBC5X/Kb8I7p5YmauGvSBGUtRZFfJR+9ADQd7To=;
        b=n65W/CRgXZhpwfbr9PrCpcUTQkjBIKawWpbs+8j8oE5WhcclD0+mb8biOJpL3wIZo6
         tPmlV8dXuBf5/HP3ajwW7qAwvNtRu8hexOcm1KARZx5n4PmQhUn/dOCrSID4PoZo0TXF
         SADN3+/VYRd6+UFlnWbMvvhu9pK82G3MRQ1u1A2fP1k2HFo8JEkMFjSwG46e+vPByZxW
         JsCF0J5P/5v9US2Gy2z3zjdXfF5zbYMIWIBLefEoh/+4SAePhRxF6k9pBrNMg7Q/uB5C
         f8ilMcyqypH+raEWeOrOmmSGWj/YCFcwThc3B3xl+4M68W063BBgRK/7DkV4MZomFaPX
         nDIQ==
X-Gm-Message-State: AOAM530Vo/wU+pZbL2PWjBSOub/T81cGwRMe2FAmzDMMBxKlQMka0toL
        uVev5FLxvDzDajiPwSA61I5p0yrXfyh6QA==
X-Google-Smtp-Source: ABdhPJzZ4Dtr0puNtsX4V/tI8BsW00XbEoc2jCD1mmm3Z0gXI+TAi8aLDd0Igj0w/7OCiJNbMN7vIQ==
X-Received: by 2002:a05:6a00:178a:b0:50a:9c03:6e62 with SMTP id s10-20020a056a00178a00b0050a9c036e62mr3701398pfg.23.1650409119119;
        Tue, 19 Apr 2022 15:58:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 10/28] scsi: ufs: Declare the quirks array const
Date:   Tue, 19 Apr 2022 15:57:53 -0700
Message-Id: <20220419225811.4127248-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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
