Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF11C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C2660F51
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhG0Mgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:36:45 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:65233 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhG0Mgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 08:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627389404; x=1658925404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=XLlR3TBwvAId3GFwFU6XBIXH72v88cus8s8lFXx1h78=;
  b=gWMEakf/dVkbGr0NNsvpyrbGeot7iUnp85AzTlc1sHOwTu79fM4pgck2
   FXxFbLOcPZBItoDbDXgR2YMShF20lCl7xX6RxDvpUvN8/BQFhwvPtuEev
   ZpUpzePsP3XqKjB0/6r3dQUd99UtUe+RnTDqqVFrM9OEZRbovmFaKbpuI
   KKpbYBgDgzW265MwCnVYzTR1oOUFQsgRxYtRLxClzN2MlIwKtATVihuUA
   dua2kDfgcFSkaCaH6pToF46yOWsm8Wtkf1PPVJ431EC2cGGWAr3X39Z2o
   3+r9I2Kg1CF3zWjoSOIiwhHaD/awDBTU63raqUc43Gf206EgdK0b9Qtil
   w==;
X-IronPort-AV: E=Sophos;i="5.84,273,1620662400"; 
   d="scan'208";a="287155367"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 20:36:44 +0800
IronPort-SDR: k2p/yuqsKkOWn4gYfsI85sgHsFPQcnuKkJ9/KJKGEnYiZh2ucov6E0GUu/Il0FrqH4HZnD1ar/
 muojwTZmFocT+6aWR6RM2wKTjxEu9JJJC0T4wDVRUpWs7I81wntKV4er74ntqOBlO7vtVJlYaA
 CycvrMz2HaZp9TKAJgojIXLTF4iZfZJ76OdYtRkBx/7IPvkdEkij0t8bpzBOiHBSDP0eSVlQqe
 p1GsXurx0h+LyrGszL8VjdCk4flyk1S2PJhyBVQifjzZd0wPIMiHlvfmoRffRZpGL47OMIdfoN
 w2qQ6BDwnJ6bSXAJR3h7LA7Y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 05:12:39 -0700
IronPort-SDR: wMSmSfZ7+qHTxLKXRPIIFBVOqFInEjXwW1Rt6lv910MHw1ZVjPBL3u0LWA5AQACjTUF+1axDJT
 wTsT1jOURvkPFfcZfEuUGvZUUw3RVAOzVGOUhPEsy9VXjodAL5c0X3cSC0Wb1DewD26APqvwnt
 0/kPTnAXLlEC5lpN7QuWo4Y5Vxaub2totJhF3ZvLCSkQxqYVr3wDRqFlMSUWJxv1GwsebyCvUj
 yz6FVBu0jQHotBuKOqAC1jGFdIcxsaskjECHkIgJuTPHb0KZsqY7QPWddrqrlmnfGRihZOWJ//
 3sE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jul 2021 05:36:42 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 3/3] scsi: ufs: Generalize ufs_is_valid_unit_desc_lun()
Date:   Tue, 27 Jul 2021 15:35:46 +0300
Message-Id: <20210727123546.17228-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727123546.17228-1-avri.altman@wdc.com>
References: <20210727123546.17228-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufs_is_valid_unit_desc_lun() test for specific wb offset case, and does
not verify that the requested field does not exceed the descriptor size.

So do that, and while at it, move it to ufshcd.h where it should be.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufs.h       | 19 -------------------
 drivers/scsi/ufs/ufshcd.c    |  2 +-
 drivers/scsi/ufs/ufshcd.h    | 25 +++++++++++++++++++++++++
 4 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 52bd807f7940..0d6dfaa70d2f 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -1136,7 +1136,7 @@ static ssize_t _pname##_show(struct device *dev,			\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	struct ufs_hba *hba = shost_priv(sdev->host);			\
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
-	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun,		\
+	if (!ufs_is_valid_unit_desc_lun(hba, lun,			\
 				_duname##_DESC_PARAM##_puname))		\
 		return -EINVAL;						\
 	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index d0be8d4c8091..366ece129a4d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -571,23 +571,4 @@ enum ufs_trace_tsf_t {
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
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eec1bc95391b..7f4c8f0c0459 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3555,7 +3555,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun, param_offset))
+	if (!ufs_is_valid_unit_desc_lun(hba, lun, param_offset))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c77bef77ec87..395c1f5ecf9d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1122,6 +1122,31 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_suspend_prepare(struct device *dev);
 void ufshcd_resume_complete(struct device *dev);
 
+/**
+ * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
+ * @dev_info: pointer of instance of struct ufs_dev_info
+ * @lun: LU number to check
+ * @return: true if the lun has a matching unit descriptor, false otherwise
+ */
+static inline bool ufs_is_valid_unit_desc_lun(struct ufs_hba *hba, u8 lun,
+					      u8 param_offset)
+{
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+	u8 desc_size = lun == UFS_UPIU_RPMB_WLUN ?
+			hba->desc_size[QUERY_DESC_IDN_UNIT_RPMB] :
+			hba->desc_size[QUERY_DESC_IDN_UNIT];
+
+	if (!dev_info || !dev_info->max_lu_supported) {
+		pr_err("Max General LU supported by UFS isn't initialized\n");
+		return false;
+	}
+
+	if (param_offset >= desc_size)
+		return false;
+
+	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
+}
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.17.1

