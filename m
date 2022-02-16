Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C80C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 07:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiBPHxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 02:53:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiBPHxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 02:53:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3C4FABE1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 23:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644997962; x=1676533962;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F7AMvO2hlDDn6QozkFOiWTZou9tAQmHJMihkvPn2NAY=;
  b=e7An6E4rkbob5+SZqq0lQXA6sA3n7RFiBjgbyLPrfvkzN4NjiBOqQPTf
   rSAOhc910fFdq5X6jHXZVy6s2rusBwOCCktCDrj3CgJvaaRl9r1GiJWEa
   eyK9IURpDm4JuaOIBaTtntU6fucZbcm6uhQeVIAKdUeypoZ1hpUmG+iX6
   TXshHzP9dh/BTUuU4eLrOLd3j+PKq5XyIeVSCzsif67QVXpM3lXZ5qQV+
   yjEc9SNLuXDZrY8HmcbjB8QL0rYUtgALBJ3NE5WKmDcZpdCyVcRhGoiWi
   Qk20zT2eND2uvK3yjnKLBQfgEA0cq6JKKLrTz7IiWjwb1VN+7bEGArhYN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="234084577"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="234084577"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 23:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="588262896"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2022 23:51:23 -0800
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
Subject: [PATCH V3] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Wed, 16 Feb 2022 09:51:22 +0200
Message-Id: <20220216075122.370532-1-adrian.hunter@intel.com>
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

UFS driver messages are changes to from dev_err() to dev_dbg() which means
they will not display unless activated by dynamic debug of building
with -DDEBUG.

sd_suspend_common() messages are removed.

scsi_report_sense() "Power-on or device reset occurred" message is
suppressed only for UFS.  Note, that message appears when the LUN is
accessed after runtime PM, not during runtime PM.

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


Changes in V3:

	Keep reset sense message for non-UFS devices

Changes in V2:

	Remove offending SCSI messages
	Use dev_dbg for offending UFSHCD messages


 drivers/scsi/scsi_error.c  |  9 +++++++--
 drivers/scsi/sd.c          |  7 +++++--
 drivers/scsi/ufs/ufshcd.c  | 21 +++++++++++++++++++--
 include/scsi/scsi_device.h |  1 +
 4 files changed, 32 insertions(+), 6 deletions(-)

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
index 62eb9921cc94..18cdf5f9415a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3742,6 +3742,11 @@ static void sd_shutdown(struct device *dev)
 	}
 }
 
+/*
+ * Do not print messages during runtime PM to avoid never-ending cycles of
+ * messages written back to storage by user space causing runtime resume,
+ * causing more messages and so on.
+ */
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
@@ -3752,7 +3757,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 		return 0;
 
 	if (sdkp->WCE && sdkp->media_present) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp, &sshdr);
 
 		if (ret) {
@@ -3774,7 +3778,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	}
 
 	if (sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
 		if (ignore_stop_errors)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 50b12d60dc1b..294e55955a76 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -585,7 +585,12 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hba)
 		"INVALID MODE",
 	};
 
-	dev_err(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
+	/*
+	 * Using dev_dbg to avoid messages during runtime PM to avoid
+	 * never-ending cycles of messages written back to storage by user space
+	 * causing runtime resume, causing more messages and so on.
+	 */
+	dev_dbg(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
 		 __func__,
 		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
 		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
@@ -5024,6 +5029,12 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
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
 
@@ -7339,7 +7350,13 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 
 	if (!hba->vreg_info.vcc || !hba->vreg_info.vccq ||
 						!hba->vreg_info.vccq2) {
-		dev_err(hba->dev,
+		/*
+		 * Using dev_dbg to avoid messages during runtime PM to avoid
+		 * never-ending cycles of messages written back to storage by
+		 * user space causing runtime resume, causing more messages and
+		 * so on.
+		 */
+		dev_dbg(hba->dev,
 			"%s: Regulator capability was not set, actvIccLevel=%d",
 							__func__, icc_level);
 		goto out;
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

