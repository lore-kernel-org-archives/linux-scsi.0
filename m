Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A66C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 11:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiBKLRe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 06:17:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349401AbiBKLRd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 06:17:33 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D52E87
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 03:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644578252; x=1676114252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1TKmoZQ3s9GekwouvTNKpWvxQocchYIj1gO39mSdmnk=;
  b=gwGZKXC4Af3V+2mVZD6Dpc+yHhxiw133yJktHHJoRcm+bldzDx6ejTvm
   UDrjSVuexpPI64Zcswl+amwJ4SeYwfJe8dXJj/kf3FxWfO68rRigrbScL
   4M8RwwccOT8/ulDHudU9CFCvrTTHMx8ASKwAwauOCMKjj+CDmXcte1hFR
   Y+Of6fdHVpwi8PU63/Dtyg0dfSiX+CnWzkKmWgaNWfRSR9qD9uE4wSmGL
   lh6UnQZNQ4hc3wp1OxgDU0DRasX+gPMAxZwitqnkfSipjaN0IDFwx1DG2
   c81dC2WqGzjfZ4SdOVpCPGWJKhBvlh4DXS6LnJ8RQteLKJJdFrxvz2Zk/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="248546056"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="248546056"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 03:17:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="542048610"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga008.jf.intel.com with ESMTP; 11 Feb 2022 03:17:28 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Fri, 11 Feb 2022 13:17:27 +0200
Message-Id: <20220211111727.161799-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel messages produced during runtime PM can cause a never-ending
cycle because user space utilities (e.g. journald or rsyslog) write the
messages back to storage, causing runtime resume, more messages, and so
on.

Messages that tell of things that are expected to happen, are arguably
unnecessary, so suppress them.

 Example messages from Ubuntu 21.10:

 $ dmesg | tail
 [ 1620.380071] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
 [ 1620.408825] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
 [ 1620.409020] ufshcd 0000:00:12.5: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
 [ 1620.409524] sd 0:0:0:0: Power-on or device reset occurred
 [ 1622.938794] sd 0:0:0:0: [sda] Synchronizing SCSI cache
 [ 1622.939184] ufs_device_wlun 0:0:0:49488: Power-on or device reset occurred
 [ 1625.183175] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
 [ 1625.208041] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
 [ 1625.208311] ufshcd 0000:00:12.5: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
 [ 1625.209035] sd 0:0:0:0: Power-on or device reset occurred

Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/scsi_error.c  |  9 ++++++--
 drivers/scsi/sd.c          | 17 ++++++++++----
 drivers/scsi/ufs/ufshcd.c  | 47 ++++++++++++++++++++++++++++++--------
 include/scsi/scsi_device.h |  1 +
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 60a6ae9d1219..c944600f7931 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -484,8 +484,13 @@ static void scsi_report_sense(struct scsi_device *sdev,
 
 		if (sshdr->asc == 0x29) {
 			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
-			sdev_printk(KERN_WARNING, sdev,
-				    "Power-on or device reset occurred\n");
+			/*
+			 * Do not print message if it is an expected side-effect
+			 * of runtime PM.
+			 */
+			if (!sdev->no_rst_sense_msg)
+				sdev_printk(KERN_WARNING, sdev,
+					    "Power-on or device reset occurred\n");
 		}
 
 		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 62eb9921cc94..fcfbadf1c42a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3742,7 +3742,7 @@ static void sd_shutdown(struct device *dev)
 	}
 }
 
-static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
+static int sd_suspend_common(struct device *dev, bool ignore_stop_errors, bool quiet)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	struct scsi_sense_hdr sshdr;
@@ -3752,7 +3752,8 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 		return 0;
 
 	if (sdkp->WCE && sdkp->media_present) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		if (!quiet)
+			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp, &sshdr);
 
 		if (ret) {
@@ -3774,7 +3775,8 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	}
 
 	if (sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		if (!quiet)
+			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
 		if (ignore_stop_errors)
@@ -3789,12 +3791,17 @@ static int sd_suspend_system(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return sd_suspend_common(dev, true);
+	return sd_suspend_common(dev, true, false);
 }
 
 static int sd_suspend_runtime(struct device *dev)
 {
-	return sd_suspend_common(dev, false);
+	/*
+	 * Do not print messages during runtime PM to avoid never-ending cycles
+	 * of messages written back to storage by user space causing runtime
+	 * resume, causing more messages and so on.
+	 */
+	return sd_suspend_common(dev, false, true);
 }
 
 static int sd_resume(struct device *dev)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 50b12d60dc1b..75fc3e15774e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -585,13 +585,30 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hba)
 		"INVALID MODE",
 	};
 
-	dev_err(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
-		 __func__,
-		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
-		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
-		 names[hba->pwr_info.pwr_rx],
-		 names[hba->pwr_info.pwr_tx],
-		 hba->pwr_info.hs_rate);
+	/*
+	 * Do not print messages during runtime PM to avoid never-ending cycles
+	 * of messages written back to storage by user space causing runtime
+	 * resume, causing more messages and so on.
+	 */
+	if (hba->pm_op_in_progress) {
+		dev_dbg(hba->dev,
+			"%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
+			 __func__,
+			 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
+			 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
+			 names[hba->pwr_info.pwr_rx],
+			 names[hba->pwr_info.pwr_tx],
+			 hba->pwr_info.hs_rate);
+	} else {
+		dev_err(hba->dev,
+			"%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
+			 __func__,
+			 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
+			 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
+			 names[hba->pwr_info.pwr_rx],
+			 names[hba->pwr_info.pwr_tx],
+			 hba->pwr_info.hs_rate);
+	}
 }
 
 static void ufshcd_device_reset(struct ufs_hba *hba)
@@ -5024,6 +5041,12 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 		pm_runtime_get_noresume(&sdev->sdev_gendev);
 	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
+	/*
+	 * Do not print messages during runtime PM to avoid never-ending cycles
+	 * of messages written back to storage by user space causing runtime
+	 * resume, causing more messages and so on.
+	 */
+	sdev->no_rst_sense_msg = 1;
 
 	ufshcd_crypto_register(hba, q);
 
@@ -7339,8 +7362,14 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 
 	if (!hba->vreg_info.vcc || !hba->vreg_info.vccq ||
 						!hba->vreg_info.vccq2) {
-		dev_err(hba->dev,
-			"%s: Regulator capability was not set, actvIccLevel=%d",
+		/*
+		 * Do not print messages during runtime PM to avoid never-ending
+		 * cycles of messages written back to storage by user space
+		 * causing runtime resume, causing more messages and so on.
+		 */
+		if (!hba->pm_op_in_progress)
+			dev_err(hba->dev,
+				"%s: Regulator capability was not set, actvIccLevel=%d",
 							__func__, icc_level);
 		goto out;
 	}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 647c53b26105..785dbf6e3e24 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	unsigned no_rst_sense_msg:1;	/* Do not print reset sense message */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
-- 
2.25.1

