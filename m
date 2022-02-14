Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A38CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 12:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352861AbiBNMTx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 07:19:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbiBNMTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 07:19:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C5B488B4
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 04:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644841185; x=1676377185;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tNuBZGGIrokzUo/bvAy9rhBfmTZ4s8ac/9IlWMdoQwM=;
  b=mOWmL4XSFFM44cWPNsFTRFWusEbvX87lbmY/N0qdovRJPyC9hlogEzF3
   BQnGuUdTPDoWJ0A/0Af/6MxLWMNRxXGAF1FSuAVsCyX9X6aVQil8RP/AM
   9W5fhMJmCxHF3bmpggtEGV5ZdWO+y2Zu0P6snaWQVk4ZVY57hkV3LeufA
   2FYK0KrykWJlqddUai0ezYQbxyD+Evc+/xOC7oU7TIZFbe1RXgbKKBed7
   7yJTzGH+gi+fw+AUD+sJ7fCIcR0qdAVNfblL7zKQyqg4BkJePTfkDR1oC
   GL5z13HQiUe+7HLSQUaajbfuE5+UWTz7A6lKw2Yz6WCRbmg8UYy9Vhqe3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="230715549"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="230715549"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 04:19:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="775122675"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga005.fm.intel.com with ESMTP; 14 Feb 2022 04:19:42 -0800
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
Subject: [PATCH V2] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Mon, 14 Feb 2022 14:19:41 +0200
Message-Id: <20220214121941.296034-1-adrian.hunter@intel.com>
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


Changes in V2:

	Remove offending SCSI messages
	Use dev_dbg for offending UFSHCD messages


 drivers/scsi/scsi_error.c | 10 ++++++++--
 drivers/scsi/sd.c         |  7 +++++--
 drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++--
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 60a6ae9d1219..e177dc5cc69a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -484,8 +484,14 @@ static void scsi_report_sense(struct scsi_device *sdev,
 
 		if (sshdr->asc == 0x29) {
 			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
-			sdev_printk(KERN_WARNING, sdev,
-				    "Power-on or device reset occurred\n");
+			/*
+			 * Do not print a message here because reset can be an
+			 * expected side-effect of runtime PM. Do not print
+			 * messages due to runtime PM to avoid never-ending
+			 * cycles of messages written back to storage by user
+			 * space causing runtime resume, causing more messages
+			 * and so on.
+			 */
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
index 50b12d60dc1b..27d5b9f75644 100644
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
@@ -7339,7 +7344,13 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 
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
-- 
2.25.1

