Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F7FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358410AbiDSXCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358403AbiDSXB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:58 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7374C38BF8
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:14 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id n8so121530plh.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wL8r/dkKyV4Y/mikFzmlbqWC8R98dUB/Oz42MtzPdL4=;
        b=z1ROCS9qru8myhOarMAQnAjIExZweM19TDh3UHHuPm+zuqLBFrWfOD9hYndPV5jRTD
         drMR4DhwJFDwq7301yMIOI81jAgQ8nUlLZ8UKnK2pN8UCVDp11L3BNeWoX4Sx6PLI906
         Iwqt7ie9SL/tQ3JVlrxS0LRxr5ucLlsS78Ln+aW1RZJkZYHku02f+x+QaTT+/5kNDYoL
         JC1ekAjONYOEB1aaAl7QNqN0jzdrcN+K0nK0PC3w1xEYq6JgjsJ/TgSaRkzmk4H4/FU/
         1KY09dRYUrvxfNa9uQlUmU6CmecFRc7Knjv7GAXniyYsmu7ogu3+lpEBAgBjb/rzdwbG
         Houg==
X-Gm-Message-State: AOAM532oG5OtRE23NGGS8OPdVDUsqnZj3L8NN0dRRkRrg3Hgjvc0Jv2+
        LlXyK9IeN1r6kUhh3nkJKE4=
X-Google-Smtp-Source: ABdhPJx8MdZhyjQnAYdp86QJIdRetujvfaahK1Tjh9sfLEz6nzlkJom/QBUcPH+R2zitLzCFWIopfw==
X-Received: by 2002:a17:90a:c70f:b0:1bf:3e2d:6cfa with SMTP id o15-20020a17090ac70f00b001bf3e2d6cfamr1015158pjt.70.1650409153943;
        Tue, 19 Apr 2022 15:59:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:59:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 28/28] scsi: ufs: Move the ufs_is_valid_unit_desc_lun() definition
Date:   Tue, 19 Apr 2022 15:58:11 -0700
Message-Id: <20220419225811.4127248-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of this function from a public into a private header
file since it is only used inside the UFS core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs.h         | 19 -------------------
 drivers/scsi/ufs/ufshcd-priv.h | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index f52173b8ad96..1bba3fead2ce 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -620,23 +620,4 @@ enum ufs_trace_tsf_t {
 	UFS_TSF_CDB, UFS_TSF_OSF, UFS_TSF_TM_INPUT, UFS_TSF_TM_OUTPUT
 };
 
-/**
- * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
- * @dev_info: pointer of instance of struct ufs_dev_info
- * @lun: LU number to check
- * @return: true if the lun has a matching unit descriptor, false otherwise
- */
-static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
-		u8 lun, u8 param_offset)
-{
-	if (!dev_info || !dev_info->max_lu_supported) {
-		pr_err("Max General LU supported by UFS isn't initialized\n");
-		return false;
-	}
-	/* WB is available only for the logical unit from 0 to 7 */
-	if (param_offset == UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
-		return lun < UFS_UPIU_MAX_WB_LUN_ID;
-	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
-}
-
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs/ufshcd-priv.h
index 3fa8ab94e4e1..38bc77d3dbbd 100644
--- a/drivers/scsi/ufs/ufshcd-priv.h
+++ b/drivers/scsi/ufs/ufshcd-priv.h
@@ -276,4 +276,23 @@ static inline int ufshcd_rpm_put(struct ufs_hba *hba)
 	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
 }
 
+/**
+ * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
+ * @dev_info: pointer of instance of struct ufs_dev_info
+ * @lun: LU number to check
+ * @return: true if the lun has a matching unit descriptor, false otherwise
+ */
+static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
+		u8 lun, u8 param_offset)
+{
+	if (!dev_info || !dev_info->max_lu_supported) {
+		pr_err("Max General LU supported by UFS isn't initialized\n");
+		return false;
+	}
+	/* WB is available only for the logical unit from 0 to 7 */
+	if (param_offset == UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
+		return lun < UFS_UPIU_MAX_WB_LUN_ID;
+	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
+}
+
 #endif /* _UFSHCD_PRIV_H_ */
