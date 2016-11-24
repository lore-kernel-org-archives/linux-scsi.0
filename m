From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 06/11] scsi: ufs: ensure that host pa_tactivate is higher than device
Date: Wed, 23 Nov 2016 16:32:08 -0800
Message-ID: <1479947528-7136-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935925AbcKXAcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 19:32:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Some UFS devices require host PA_TACTIVATE to be higher than
device PA_TACTIVATE otherwise it may get stuck during hibern8 sequence.
This change allows this by using quirk.

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs_quirks.h |  9 ++++++
 drivers/scsi/ufs/ufshcd.c     | 73 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/unipro.h     |  4 +++
 3 files changed, 86 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 22f881e..f798305 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -128,6 +128,13 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM	(1 << 6)
 
+/*
+ * Some UFS devices require host PA_TACTIVATE to be lower than device
+ * PA_TACTIVATE, enabling this quirk ensure this.
+ */
+#define UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE	(1 << 7)
+
+
 struct ufs_hba;
 void ufs_advertise_fixup_device(struct ufs_hba *hba);
 
@@ -140,6 +147,8 @@ struct ufs_dev_fix {
 		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_NO_FASTAUTO),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 393f6d5..28cbca2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5089,6 +5089,76 @@ static int ufshcd_tune_pa_hibern8time(struct ufs_hba *hba)
 	return ret;
 }
 
+/**
+ * ufshcd_quirk_tune_host_pa_tactivate - Ensures that host PA_TACTIVATE is
+ * less than device PA_TACTIVATE time.
+ * @hba: per-adapter instance
+ *
+ * Some UFS devices require host PA_TACTIVATE to be lower than device
+ * PA_TACTIVATE, we need to enable UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE quirk
+ * for such devices.
+ *
+ * Returns zero on success, non-zero error value on failure.
+ */
+static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
+{
+	int ret = 0;
+	u32 granularity, peer_granularity;
+	u32 pa_tactivate, peer_pa_tactivate;
+	u32 pa_tactivate_us, peer_pa_tactivate_us;
+	u8 gran_to_us_table[] = {1, 4, 8, 16, 32, 100};
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+				  &granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+				  &peer_granularity);
+	if (ret)
+		goto out;
+
+	if ((granularity < PA_GRANULARITY_MIN_VAL) ||
+	    (granularity > PA_GRANULARITY_MAX_VAL)) {
+		dev_err(hba->dev, "%s: invalid host PA_GRANULARITY %d",
+			__func__, granularity);
+		return -EINVAL;
+	}
+
+	if ((peer_granularity < PA_GRANULARITY_MIN_VAL) ||
+	    (peer_granularity > PA_GRANULARITY_MAX_VAL)) {
+		dev_err(hba->dev, "%s: invalid device PA_GRANULARITY %d",
+			__func__, peer_granularity);
+		return -EINVAL;
+	}
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &pa_tactivate);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_TACTIVATE),
+				  &peer_pa_tactivate);
+	if (ret)
+		goto out;
+
+	pa_tactivate_us = pa_tactivate * gran_to_us_table[granularity - 1];
+	peer_pa_tactivate_us = peer_pa_tactivate *
+			     gran_to_us_table[peer_granularity - 1];
+
+	if (pa_tactivate_us > peer_pa_tactivate_us) {
+		u32 new_peer_pa_tactivate;
+
+		new_peer_pa_tactivate = pa_tactivate_us /
+				      gran_to_us_table[peer_granularity - 1];
+		new_peer_pa_tactivate++;
+		ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_TACTIVATE),
+					  new_peer_pa_tactivate);
+	}
+
+out:
+	return ret;
+}
+
 static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 {
 	if (ufshcd_is_unipro_pa_params_tuning_req(hba)) {
@@ -5099,6 +5169,9 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_TACTIVATE)
 		/* set 1ms timeout for PA_TACTIVATE */
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 10);
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
+		ufshcd_quirk_tune_host_pa_tactivate(hba);
 }
 
 /**
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index eff8b56..23129d7 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -123,6 +123,7 @@
 #define PA_MAXRXHSGEAR		0x1587
 #define PA_RXHSUNTERMCAP	0x15A5
 #define PA_RXLSTERMCAP		0x15A6
+#define PA_GRANULARITY		0x15AA
 #define PA_PACPREQTIMEOUT	0x1590
 #define PA_PACPREQEOBTIMEOUT	0x1591
 #define PA_HIBERN8TIME		0x15A7
@@ -158,6 +159,9 @@
 #define VS_DEBUGOMC		0xD09E
 #define VS_POWERSTATE		0xD083
 
+#define PA_GRANULARITY_MIN_VAL	1
+#define PA_GRANULARITY_MAX_VAL	6
+
 /* PHY Adapter Protocol Constants */
 #define PA_MAXDATALANES	4
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

