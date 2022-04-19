Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C49C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358390AbiDSXBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358387AbiDSXBg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:36 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D5038781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:52 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id k14so25476346pga.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvy83NFDlypGK3KJlA/toH8UX9vzBdAcOUh51JSZ2OY=;
        b=ainafHovZ0wWMcD8er0xoB8MoQT4zlYPddwtGl+96bpKAXgmFqlu/cJYyCB0J9PRs/
         w1jWKazZ6zPu+2m/BJ1UMI6rDFqQ5ZGUDtO3qF9frXdETdd+xT9CKxATN/IREEhL3thm
         zhCkZ5b4xVccjahhI87jn7YfJfTlo+ZY4FnljA9b1W0FLQr69x7OP4bUDYtPB0NC9lut
         q4UfZ9End/qgYOS0hzzU3akia0k2YnULsBesbSGu4UYEwWA687/cIQ2AZJ3pna1kB0y8
         zxf5BXcfh1MNZG2ejjT9gagjuRZZpgtksjlLgNGWuKG10DVZdiAHIL+Bj5qdlwqycaOJ
         cI+w==
X-Gm-Message-State: AOAM532u3Q9tjNMgRbsRcU6jhtsg6OLaqQtaR77P7r1gWxXV4pXPH3K1
        1QWw3ylLQEF/19S8UBzTwP4=
X-Google-Smtp-Source: ABdhPJzO1v7wFXx5euEdu8k55WWARRvRNiY16r+NE5G1m3HaSTZPthgW+gg+DlCacmrd9jYdfWw96Q==
X-Received: by 2002:a63:7745:0:b0:3aa:4db4:3cc6 with SMTP id s66-20020a637745000000b003aa4db43cc6mr2478639pgc.24.1650409131445;
        Tue, 19 Apr 2022 15:58:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 16/28] scsi: ufs: Rename sdev_ufs_device into ufs_device_wlun
Date:   Tue, 19 Apr 2022 15:57:59 -0700
Message-Id: <20220419225811.4127248-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name reflects the role of this member variable better: a WLUN
through which the power mode of the UFS device is controlled.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 50 +++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h | 17 ++++++-------
 2 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 912c3ecb8d7a..e0535e4d8669 100644
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
@@ -9224,7 +9224,7 @@ static void ufshcd_wl_shutdown(struct device *dev)
 	ufshcd_rpm_get_sync(hba);
 	scsi_device_quiesce(sdev);
 	shost_for_each_device(sdev, hba->host) {
-		if (sdev == hba->sdev_ufs_device)
+		if (sdev == hba->ufs_device_wlun)
 			continue;
 		scsi_device_quiesce(sdev);
 	}
@@ -9445,7 +9445,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
-	if (hba->sdev_ufs_device)
+	if (hba->ufs_device_wlun)
 		ufshcd_rpm_get_sync(hba);
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
@@ -9773,7 +9773,7 @@ EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
 
 static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
 {
-	struct device *dev = &hba->sdev_ufs_device->sdev_gendev;
+	struct device *dev = &hba->ufs_device_wlun->sdev_gendev;
 	enum ufs_dev_pwr_mode dev_pwr_mode;
 	enum uic_link_state link_state;
 	unsigned long flags;
@@ -9802,7 +9802,7 @@ int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
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
