From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V2 4/5] scsi: ufs: Logical Unit (LU) command queue depth
Date: Tue, 22 Jul 2014 17:23:49 +0300
Message-ID: <1406039030-14246-5-git-send-email-draviv@codeaurora.org>
References: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39233 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaGVOYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2014 10:24:25 -0400
In-Reply-To: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>

Some of the UFS devices may support different number of commands
that can be queued per LU. At the current implementation,
SW configure each of the UFS devices LU's according to the
controller capability.

In this patch we read the queue depth available per LU and update
the LU's SW structure.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h    | 21 +++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 1545cd7..fafcf5e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -132,6 +132,27 @@ enum desc_idn {
 	QUERY_DESC_IDN_RFU_2		= 0x9,
 };
 
+#define UNIT_DESC_MAX_SIZE       0x22
+/* Unit descriptor parameters offsets in bytes*/
+enum unit_desc_param {
+	UNIT_DESC_PARAM_LEN			= 0x0,
+	UNIT_DESC_PARAM_TYPE			= 0x1,
+	UNIT_DESC_PARAM_UNIT_INDEX		= 0x2,
+	UNIT_DESC_PARAM_LU_ENABLE		= 0x3,
+	UNIT_DESC_PARAM_BOOT_LUN_ID		= 0x4,
+	UNIT_DESC_PARAM_LU_WR_PROTECT		= 0x5,
+	UNIT_DESC_PARAM_LU_Q_DEPTH		= 0x6,
+	UNIT_DESC_PARAM_MEM_TYPE		= 0x8,
+	UNIT_DESC_PARAM_DATA_RELIABILITY	= 0x9,
+	UNIT_DESC_PARAM_LOGICAL_BLK_SIZE	= 0xA,
+	UNIT_DESC_PARAM_LOGICAL_BLK_COUNT	= 0xB,
+	UNIT_DESC_PARAM_ERASE_BLK_SIZE		= 0x13,
+	UNIT_DESC_PARAM_PROVISIONING_TYPE	= 0x17,
+	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
+	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
+	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+};
+
 /* Exception event mask values */
 enum {
 	MASK_EE_STATUS		= 0xFFFF,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d3b17cd..7ea4b4d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -110,6 +110,8 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
+static int ufshcd_read_sdev_qdepth(struct ufs_hba *hba,
+					struct scsi_device *sdev);
 
 /*
  * ufshcd_wait_for_register - wait for register value to change
@@ -1979,6 +1981,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 static int ufshcd_slave_alloc(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
+	int lun_qdepth;
 
 	hba = shost_priv(sdev->host);
 	sdev->tagged_supported = 1;
@@ -1989,6 +1992,14 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 
 	/* allow SCSI layer to restart the device in case of errors */
 	sdev->allow_restart = 1;
+	lun_qdepth = ufshcd_read_sdev_qdepth(hba, sdev);
+	if (lun_qdepth == 0 || lun_qdepth > hba->nutrs) {
+		dev_info(hba->dev, "%s, lun %d queue depth is %d\n", __func__,
+				sdev->lun, lun_qdepth);
+		lun_qdepth = hba->nutrs;
+	} else if (lun_qdepth < 0) {
+		lun_qdepth = 1;
+	}
 
 	/*
 	 * Inform SCSI Midlayer that the LUN queue depth is same as the
@@ -1997,7 +2008,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	 * SAM_STAT_TASK_SET_FULL, the LUN queue depth will be adjusted
 	 * with scsi_adjust_queue_depth.
 	 */
-	scsi_activate_tcq(sdev, hba->nutrs);
+	scsi_activate_tcq(sdev, lun_qdepth);
 	return 0;
 }
 
@@ -3072,6 +3083,38 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /**
+ * ufshcd_read_sdev_qdepth - read the lun command queue depth
+ * @hba: Pointer to adapter instance
+ * @sdev: pointer to SCSI device
+ *
+ * Return in case of success the lun's queue depth else error.
+ */
+static int ufshcd_read_sdev_qdepth(struct ufs_hba *hba,
+				struct scsi_device *sdev)
+{
+	int ret;
+	int buff_len = UNIT_DESC_MAX_SIZE;
+	u8 desc_buf[UNIT_DESC_MAX_SIZE];
+
+	ret = ufshcd_query_descriptor(hba, UPIU_QUERY_OPCODE_READ_DESC,
+			QUERY_DESC_IDN_UNIT, sdev->lun, 0, desc_buf, &buff_len);
+
+	if (ret || (buff_len < UNIT_DESC_PARAM_LU_Q_DEPTH)) {
+		dev_err(hba->dev,
+			"%s:Failed reading unit descriptor. len = %d ret = %d"
+			, __func__, buff_len, ret);
+		if (!ret)
+			ret = -EINVAL;
+
+		goto out;
+	}
+
+	ret = desc_buf[UNIT_DESC_PARAM_LU_Q_DEPTH] & 0xFF;
+out:
+	return ret;
+}
+
+/**
  * ufshcd_async_scan - asynchronous execution for link startup
  * @data: data pointer to pass to this function
  * @cookie: cookie data
-- 
1.8.5.2

--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

