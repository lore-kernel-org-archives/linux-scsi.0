Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42DFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354301AbiDLS17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiDLS16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:27:58 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297CD4E3BC
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:25:40 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so3813546pjn.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wL8r/dkKyV4Y/mikFzmlbqWC8R98dUB/Oz42MtzPdL4=;
        b=IP1xcWq2Kl0swYTPIcO/6CHDbE3dd3UJcG6ZiXtJC4YMaQ3De6UDVzhg1TMrPlFjkc
         iGZgCJISPVR2zi/82gcxeoURnjSIG2qse9LZ3ccInHVcFalwUtScCicLmsmTmDS51MAR
         /P7Aw16QmfLmXwCbR+TVhB4lO0b4mmQeL0C0RZ7dYjmgbhLP9ZbO98Nn3r/Fv8/W2eRN
         5ovQyb1nl4U9uFQZTIIO6U7832Xki2QURT22qmfaQwBPECo0LQ3lJQC9el+QYuUdNqDh
         TSSbHyfL8XkZ5KMCO0kdRpIbphA8DWqiUbhBDNyrnFkXc6DEpnno2uKpOzL7Qn9iYTyc
         ADJg==
X-Gm-Message-State: AOAM530vqxsIlcihkAIKvhA3m52NjlEwe85j8ZlfbULuynsoVM/dlSeh
        Z6V9zpqusZCof2I/xeB2mnQ=
X-Google-Smtp-Source: ABdhPJzHccBYK1T3VPziciNPFtBkDaQaJLb5C/l/2TOQtF7APbwP4fKZWiwFOENtaYVBIMidobnHPw==
X-Received: by 2002:a17:903:2406:b0:158:72dc:2d73 with SMTP id e6-20020a170903240600b0015872dc2d73mr9023896plo.46.1649787939610;
        Tue, 12 Apr 2022 11:25:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:25:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 28/29] scsi: ufs: Move the ufs_is_valid_unit_desc_lun() definition
Date:   Tue, 12 Apr 2022 11:18:52 -0700
Message-Id: <20220412181853.3715080-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
