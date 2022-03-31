Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8128C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiCaWjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242356AbiCaWjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:01 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D21FC9CE
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:12 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id z128so912407pgz.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oZWCD/UfrW8/H8uuuzeBe5XwOK9FoktmUsSzLfUqBg=;
        b=3QZcpXFLhRo43JEKE8PEdoADfR68HLxHTYddkNvNd2FSlYUAhS/HOmZTDH6dVidKlj
         w4RhV9gpQBCEIok1uvNkv3+nCVESz5hGV3GQREom7Y9+5en4zN3OCCkojoOtUlGKgDKr
         MeQbL89Tt9OEqMsPrUCdfT3CmGj8YWnq6NqBwbPW8dMN/6pDLscbp8tOI1bLD9b1VkCf
         T+vI7u65ZLzDL9kB0KCxj3/dItSpWLr4bS3pkrsyixNZNpXwNUvh+hFZMmRc96qA0mCx
         WOgeE0sa9H++/YKQqzW+RNYvZjGShNv5cvkxFb/u+paPyyx249u5gf2MHHYxH5sn233y
         TI1Q==
X-Gm-Message-State: AOAM531mnK7nFJAyDtDENCr/5NJnzXkpS256FFC7yUVJf8yeaGZyvxhQ
        4tOlAWpbY6eUUo3k9nlad0I=
X-Google-Smtp-Source: ABdhPJyglM2Z0eMi4k5+8bedc3YU0yKIy7HOmyHp5tEPBJMUK71VT8zgnmH4Lhd8o3TpHjIhvPa49A==
X-Received: by 2002:a63:481b:0:b0:378:9b24:5163 with SMTP id v27-20020a63481b000000b003789b245163mr12400455pga.224.1648766232373;
        Thu, 31 Mar 2022 15:37:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:37:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 16/29] scsi: ufs: Rename sdev_ufs_device into ufs_device_wlun
Date:   Thu, 31 Mar 2022 15:34:11 -0700
Message-Id: <20220331223424.1054715-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name reflects the role of this member variable better: a WLUN
through which the power mode of the UFS device is controlled.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 48 +++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h | 17 ++++++--------
 2 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9d433d2c616d..c36658d97774 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -540,7 +540,7 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
-	struct scsi_device *sdev_ufs = hba->sdev_ufs_device;
+	struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
 
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
 	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
@@ -4195,7 +4195,7 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (update &&
-	    !pm_runtime_suspended(&hba->sdev_ufs_device->sdev_gendev)) {
+	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba, false);
 		ufshcd_auto_hibern8_enable(hba);
@@ -4911,13 +4911,13 @@ static void ufshcd_setup_links(struct ufs_hba *hba, struct scsi_device *sdev)
 	 * Device wlun is the supplier & rest of the luns are consumers.
 	 * This ensures that device wlun suspends after all other luns.
 	 */
-	if (hba->sdev_ufs_device) {
+	if (hba->ufs_device_wlun) {
 		link = device_link_add(&sdev->sdev_gendev,
-				       &hba->sdev_ufs_device->sdev_gendev,
+				       &hba->ufs_device_wlun->sdev_gendev,
 				       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
 		if (!link) {
 			dev_err(&sdev->sdev_gendev, "Failed establishing link - %s\n",
-				dev_name(&hba->sdev_ufs_device->sdev_gendev));
+				dev_name(&hba->ufs_device_wlun->sdev_gendev));
 			return;
 		}
 		hba->luns_avail--;
@@ -5053,15 +5053,15 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->sdev_ufs_device = NULL;
+		hba->ufs_device_wlun = NULL;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	} else if (hba->sdev_ufs_device) {
+	} else if (hba->ufs_device_wlun) {
 		struct device *supplier = NULL;
 
 		/* Ensure UFS Device WLUN exists and does not disappear */
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (hba->sdev_ufs_device) {
-			supplier = &hba->sdev_ufs_device->sdev_gendev;
+		if (hba->ufs_device_wlun) {
+			supplier = &hba->ufs_device_wlun->sdev_gendev;
 			get_device(supplier);
 		}
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -6037,7 +6037,7 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
 	ufshcd_rpm_get_sync(hba);
-	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
+	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
 	    hba->is_sys_suspended) {
 		enum ufs_pm_op pm_op;
 
@@ -6082,7 +6082,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 {
 	return (!hba->is_powered || hba->shutting_down ||
-		!hba->sdev_ufs_device ||
+		!hba->ufs_device_wlun ||
 		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
 		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
 		   ufshcd_is_link_broken(hba))));
@@ -6101,7 +6101,7 @@ static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 	 * Set RPM status of wlun device to RPM_ACTIVE,
 	 * this also clears its runtime error.
 	 */
-	ret = pm_runtime_set_active(&hba->sdev_ufs_device->sdev_gendev);
+	ret = pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
 
 	/* hba device might have a runtime error otherwise */
 	if (ret)
@@ -7495,20 +7495,20 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	int ret = 0;
 	struct scsi_device *sdev_boot, *sdev_rpmb;
 
-	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
+	hba->ufs_device_wlun = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
-	if (IS_ERR(hba->sdev_ufs_device)) {
-		ret = PTR_ERR(hba->sdev_ufs_device);
-		hba->sdev_ufs_device = NULL;
+	if (IS_ERR(hba->ufs_device_wlun)) {
+		ret = PTR_ERR(hba->ufs_device_wlun);
+		hba->ufs_device_wlun = NULL;
 		goto out;
 	}
-	scsi_device_put(hba->sdev_ufs_device);
+	scsi_device_put(hba->ufs_device_wlun);
 
 	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
 	if (IS_ERR(sdev_rpmb)) {
 		ret = PTR_ERR(sdev_rpmb);
-		goto remove_sdev_ufs_device;
+		goto remove_ufs_device_wlun;
 	}
 	ufshcd_blk_pm_runtime_init(sdev_rpmb);
 	scsi_device_put(sdev_rpmb);
@@ -7523,8 +7523,8 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	}
 	goto out;
 
-remove_sdev_ufs_device:
-	scsi_remove_device(hba->sdev_ufs_device);
+remove_ufs_device_wlun:
+	scsi_remove_device(hba->ufs_device_wlun);
 out:
 	return ret;
 }
@@ -8660,7 +8660,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	int ret, retries;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	sdp = hba->sdev_ufs_device;
+	sdp = hba->ufs_device_wlun;
 	if (sdp) {
 		ret = scsi_device_get(sdp);
 		if (!ret && !scsi_device_online(sdp)) {
@@ -9437,7 +9437,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
-	if (hba->sdev_ufs_device)
+	if (hba->ufs_device_wlun)
 		ufshcd_rpm_get_sync(hba);
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
@@ -9765,7 +9765,7 @@ EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
 
 static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
 {
-	struct device *dev = &hba->sdev_ufs_device->sdev_gendev;
+	struct device *dev = &hba->ufs_device_wlun->sdev_gendev;
 	enum ufs_dev_pwr_mode dev_pwr_mode;
 	enum uic_link_state link_state;
 	unsigned long flags;
@@ -9794,7 +9794,7 @@ int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
 	 * if it's runtime suspended. But ufs doesn't follow that.
 	 * Refer ufshcd_resume_complete()
 	 */
-	if (hba->sdev_ufs_device) {
+	if (hba->ufs_device_wlun) {
 		/* Prevent runtime suspend */
 		ufshcd_rpm_get_noresume(hba);
 		/*
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 49edbdb5ffd6..14414225faa1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -732,6 +732,7 @@ struct ufs_hba_monitor {
  * @utmrdl_dma_addr: UTMRDL DMA address
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
+ * @ufs_device_wlun: WLUN that controls the entire UFS device.
  * @lrb: local reference block
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_lock: Protects @outstanding_reqs.
@@ -799,11 +800,7 @@ struct ufs_hba {
 
 	struct Scsi_Host *host;
 	struct device *dev;
-	/*
-	 * This field is to keep a reference to "scsi_device" corresponding to
-	 * "UFS device" W-LU.
-	 */
-	struct scsi_device *sdev_ufs_device;
+	struct scsi_device *ufs_device_wlun;
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
@@ -1407,27 +1404,27 @@ static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
 
 static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
 {
-	return pm_runtime_get_sync(&hba->sdev_ufs_device->sdev_gendev);
+	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
 {
-	return pm_runtime_put_sync(&hba->sdev_ufs_device->sdev_gendev);
+	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
 
 static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba)
 {
-	pm_runtime_get_noresume(&hba->sdev_ufs_device->sdev_gendev);
+	pm_runtime_get_noresume(&hba->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
 {
-	return pm_runtime_resume(&hba->sdev_ufs_device->sdev_gendev);
+	return pm_runtime_resume(&hba->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_put(struct ufs_hba *hba)
 {
-	return pm_runtime_put(&hba->sdev_ufs_device->sdev_gendev);
+	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
 }
 
 #endif /* End of Header */
