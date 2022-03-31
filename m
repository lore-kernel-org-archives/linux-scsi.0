Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190D1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiCaWiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242608AbiCaWh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:37:57 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CCB1C8A8E
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:09 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so806792pjf.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOu9TTvkhqZToMPY3iNQ/TbdFvweB4Dc3z8iZilqYmA=;
        b=rdRmuQnLqf2A++kXwWSyRQtmtrZAWZ1vQ8I6eKh7KndynGa6r8al+eF+hgTOI4UwlP
         lWOauchnKxhURIN9R7rjEWTJMAwQ4dQ6iTLzNe5/JjHRP05pr/CfB54XxlUa8fm7NjJV
         qBh+o9/ZLtTAGBT88s0lQNzF8glGOQfEkG81cfoJFqy2ffo6bCPXbNpIu7Xvja8mtKuB
         SMV45D893sBUfL0r5QZ4XI4jxHMLIkE+Fr4I6q5NJGiLqLRt7iYYzD3G6suVH/eebdK1
         HYLISPjWz18VNh7HolPozuXxLMhHyOWRoA9uI4ZzlYSMJQbt8qsBiMwVTaIxwf9VQ04k
         Tp8g==
X-Gm-Message-State: AOAM530RYqs4ufFMw0LPQaJYVopVZ50jDngDnOd5jTnNi5llt38rh/u7
        3eIk9uKSNTziaioCfx2NBkw=
X-Google-Smtp-Source: ABdhPJyy3kbP2eHIvXnLQkLbaLhSwN0+gr7gBL3Ff0eiLtPCUe9oelwH7xrCv3+gDHCYqDaYBLp47Q==
X-Received: by 2002:a17:90b:38d1:b0:1c9:ba10:353b with SMTP id nn17-20020a17090b38d100b001c9ba10353bmr8458260pjb.9.1648766169292;
        Thu, 31 Mar 2022 15:36:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:36:08 -0700 (PDT)
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
Subject: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Date:   Thu, 31 Mar 2022 15:34:04 -0700
Message-Id: <20220331223424.1054715-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare the quirks array and also its 'model' member const to make it
explicit that these are not modified.

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
index 97b9b2b77593..931ce620fc34 100644
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
