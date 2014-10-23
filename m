From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 1/6] scsi: ufs: fix reference counting of W-LUs
Date: Thu, 23 Oct 2014 13:25:12 +0300
Message-ID: <1414059917-13831-2-git-send-email-draviv@codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60770 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWKZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 06:25:33 -0400
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

From: Akinobu Mita <akinobu.mita@gmail.com>

UFS driver adds three well known LUs in the initialization, but those
reference counts are not decremented, so it makes ufshcd module
impossible to unload.

This fixes it by putting scsi_device_put() in the initalization, and in
order to protect concurrent access to hba->sdev_ufs_device (UFS Device
W-LU) from manual delete, increment the reference count while requesting
device power mode setting.

The rest of W-LUs (hba->sdev_boot and hba->sdev_rpmb) are not directly
used from driver, so these references in struct ufs_hba are removed.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 497c38a..59b6544 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2844,8 +2844,13 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	hba = shost_priv(sdev->host);
 	scsi_deactivate_tcq(sdev, hba->nutrs);
 	/* Drop the reference as it won't be needed anymore */
-	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN)
+	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
+		unsigned long flags;
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->sdev_ufs_device = NULL;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 }
 
 /**
@@ -4062,6 +4067,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
 	int ret = 0;
+	struct scsi_device *sdev_rpmb;
+	struct scsi_device *sdev_boot;
 
 	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
@@ -4070,26 +4077,27 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 		hba->sdev_ufs_device = NULL;
 		goto out;
 	}
+	scsi_device_put(hba->sdev_ufs_device);
 
-	hba->sdev_boot = __scsi_add_device(hba->host, 0, 0,
+	sdev_boot = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
-	if (IS_ERR(hba->sdev_boot)) {
-		ret = PTR_ERR(hba->sdev_boot);
-		hba->sdev_boot = NULL;
+	if (IS_ERR(sdev_boot)) {
+		ret = PTR_ERR(sdev_boot);
 		goto remove_sdev_ufs_device;
 	}
+	scsi_device_put(sdev_boot);
 
-	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
+	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
-	if (IS_ERR(hba->sdev_rpmb)) {
-		ret = PTR_ERR(hba->sdev_rpmb);
-		hba->sdev_rpmb = NULL;
+	if (IS_ERR(sdev_rpmb)) {
+		ret = PTR_ERR(sdev_rpmb);
 		goto remove_sdev_boot;
 	}
+	scsi_device_put(sdev_rpmb);
 	goto out;
 
 remove_sdev_boot:
-	scsi_remove_device(hba->sdev_boot);
+	scsi_remove_device(sdev_boot);
 remove_sdev_ufs_device:
 	scsi_remove_device(hba->sdev_ufs_device);
 out:
@@ -4097,30 +4105,6 @@ out:
 }
 
 /**
- * ufshcd_scsi_remove_wlus - Removes the W-LUs which were added by
- *			     ufshcd_scsi_add_wlus()
- * @hba: per-adapter instance
- *
- */
-static void ufshcd_scsi_remove_wlus(struct ufs_hba *hba)
-{
-	if (hba->sdev_ufs_device) {
-		scsi_remove_device(hba->sdev_ufs_device);
-		hba->sdev_ufs_device = NULL;
-	}
-
-	if (hba->sdev_boot) {
-		scsi_remove_device(hba->sdev_boot);
-		hba->sdev_boot = NULL;
-	}
-
-	if (hba->sdev_rpmb) {
-		scsi_remove_device(hba->sdev_rpmb);
-		hba->sdev_rpmb = NULL;
-	}
-}
-
-/**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
  *
@@ -4675,11 +4659,25 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 {
 	unsigned char cmd[6] = { START_STOP };
 	struct scsi_sense_hdr sshdr;
-	struct scsi_device *sdp = hba->sdev_ufs_device;
+	struct scsi_device *sdp;
+	unsigned long flags;
 	int ret;
 
-	if (!sdp || !scsi_device_online(sdp))
-		return -ENODEV;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	sdp = hba->sdev_ufs_device;
+	if (sdp) {
+		ret = scsi_device_get(sdp);
+		if (!ret && !scsi_device_online(sdp)) {
+			ret = -ENODEV;
+			scsi_device_put(sdp);
+		}
+	} else {
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (ret)
+		return ret;
 
 	/*
 	 * If scsi commands fail, the scsi mid-layer schedules scsi error-
@@ -4718,6 +4716,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	if (!ret)
 		hba->curr_dev_pwr_mode = pwr_mode;
 out:
+	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
 	return ret;
 }
@@ -5231,7 +5230,6 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	scsi_remove_host(hba->host);
-	ufshcd_scsi_remove_wlus(hba);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 58ecdff..4a574aa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -392,8 +392,6 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
-	struct scsi_device *sdev_rpmb;
-	struct scsi_device *sdev_boot;
 
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

