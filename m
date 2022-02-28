Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83F3C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 11:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbiB1Lhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 06:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbiB1Lhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 06:37:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214C9710CA
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 03:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646048219; x=1677584219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MCxa/9T2gJPT5rU+GglOZrE1KSJzlWQp8QG0N44R7bw=;
  b=LrobI26UpyaD+3B3Sku0VD9updNMO30gbr/T8n1RtxK/zgLdYWJDfsli
   2d9X7dNThJlaQseN93QQrCLfVyn/Zx6wipLEG1lJCc9no8jbT6r5rjSyc
   sAXKFD7kMzO71oG89veZzIpqxBgM7YTo7BrKapr9GRGA+pbz/3sO6s4q9
   dUrXmEDUEf2j38PpMkw/RVr8tdzF5kTtM+xicNb6QCQNP6b7TppSsSkuU
   AFhmCc6ykLkB2Jwr+F5+ufWQnhx1QpKlNuO0bAfUQ0ZUY0BtFWzhyJmXv
   xux8q+GLSX0J7qptfHOr/eeou8ZGTe9fmNBQv7RmgZ/LNGMyV0oqitNje
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="252789328"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="252789328"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 03:36:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="629602646"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Feb 2022 03:36:56 -0800
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
Subject: [PATCH V4 1/2] scsi: Add quiet_suspend flag for SCSI devices to suppress some PM messages
Date:   Mon, 28 Feb 2022 13:36:51 +0200
Message-Id: <20220228113652.970857-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228113652.970857-1-adrian.hunter@intel.com>
References: <20220228113652.970857-1-adrian.hunter@intel.com>
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
unnecessary, so add a flag to suppress them. This flag is used by the UFS
driver in a subsequent patch.

Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V4:

	New separate patch for SCSI changes only, without UFS driver
	changes.

	Rename no_rst_sense_msg to quiet_suspend and use to make all
	messages conditional.


 drivers/scsi/scsi_error.c  | 9 +++++++--
 drivers/scsi/sd.c          | 6 ++++--
 include/scsi/scsi_device.h | 6 ++++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 60a6ae9d1219..602410bd5dd6 100644
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
+			if (!sdev->quiet_suspend)
+				sdev_printk(KERN_WARNING, sdev,
+					    "Power-on or device reset occurred\n");
 		}
 
 		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 62eb9921cc94..fefe8f1da422 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3752,7 +3752,8 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 		return 0;
 
 	if (sdkp->WCE && sdkp->media_present) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		if (!sdkp->device->quiet_suspend)
+			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp, &sshdr);
 
 		if (ret) {
@@ -3774,7 +3775,8 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	}
 
 	if (sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		if (!sdkp->device->quiet_suspend)
+			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
 		if (ignore_stop_errors)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 647c53b26105..9f5408b2d8d3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,12 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	/*
+	 * quiet_suspend to suppress messages due to runtime PM to avoid
+	 * never-ending cycles of messages written back to storage by user space
+	 * causing runtime resume, causing more messages and so on.
+	 */
+	unsigned quiet_suspend:1;	/* Do not print runtime PM related messages */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
-- 
2.25.1

