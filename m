Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AD8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiCaWmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiCaWmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:42:13 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5B51C2DAA
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:40:25 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id s72so904465pgc.5
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkOfiLe55vTb+/gyHZpy0iK9/Y4nwQo5Bj5lB1sQnjI=;
        b=2bZsz8fYEJhmNQP1b7wzY3ukbEWHphD408TLWWTILkUP15I6w1BFpgqBjzCwlObIpZ
         6KmDBclNatApCp8NhDSWnEopNBDsv10ltr4WQWBoGR8UTX6W1Jem+RztsOPqhmiZ0/2Y
         vjFSBO7/yjYp7LzRokgXHbF6jlrEiMfVFJHSRlFMepEKGB8bni/1hn7h9xznwNjfyrRW
         9PUyPm800rFwSK8U7eyezoXCR9EugZLKd7l2sHqr1U+o75UmmgWgGvCzvlLNyyJ1InX2
         LnHDKNJt/pDrGtaRGkm/TWy5lscVyFRDllUCCFQwDiRfkV/E2Yguv4sBzAOZYBKsvJ63
         df+g==
X-Gm-Message-State: AOAM533dhp8stCLZrrOLD5rXcsCoieJJawSJ74Hfw2AWGpUFa9RtwgGD
        0WVTF5WGB+Ge3FwiTWQDKlU=
X-Google-Smtp-Source: ABdhPJzdwqoJ767zAcsRt5LEpNdLY4KsA0Vtfr1RUiQVPbbwHyO7QPUrysIRLvobuWUOCAm+dVNUog==
X-Received: by 2002:a63:af47:0:b0:398:4be1:ce1d with SMTP id s7-20020a63af47000000b003984be1ce1dmr12625546pgo.514.1648766425177;
        Thu, 31 Mar 2022 15:40:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:40:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 28/29] scsi: ufs: Move the ufs_is_valid_unit_desc_lun() definition
Date:   Thu, 31 Mar 2022 15:34:23 -0700
Message-Id: <20220331223424.1054715-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
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
index 4ceb0c63aa15..de699b969aa6 100644
--- a/drivers/scsi/ufs/ufshcd-priv.h
+++ b/drivers/scsi/ufs/ufshcd-priv.h
@@ -274,4 +274,23 @@ static inline int ufshcd_rpm_put(struct ufs_hba *hba)
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
