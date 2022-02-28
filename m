Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A655C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 11:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiB1Lhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 06:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiB1Lhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 06:37:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27599710E0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 03:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646048222; x=1677584222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9zsaimGdbeqLm7fafiv9/F1lNcRW3sYaJUlJg0xuQqM=;
  b=oFZr4INjK4TnPMmJevSk8BDXDr9XHhpe2Gw6huCCsvDW09EtyKJmaqsA
   b7bssF8PE9dglEUZKa6ozdGZ13dg54wRGo+DXzkOu/XxzYOfWG63ePKJB
   el1iuuaxiUiuSFkeIjmPhv6uH3UYDemE/y4LAdp1cvutINobqvBcHA9dO
   PuZduwhMxd7a2O6CQZvQFSmHd2beU3I5BcLeOwas7oUtrwsf+M0BCKPDA
   9coyJJJvRfJZqOsUnPvFe1XjnGGouRwWyBVEsLJ490O8xwyIst9iHMT7S
   vTUTdtywNGMSwgJp//fLTVZywObpneorN+Zhkxj++fKV9MyjS5csUSg9D
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="252789336"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="252789336"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 03:37:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="629602652"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Feb 2022 03:36:58 -0800
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
Subject: [PATCH V4 2/2] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Mon, 28 Feb 2022 13:36:52 +0200
Message-Id: <20220228113652.970857-3-adrian.hunter@intel.com>
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
unnecessary, so suppress them.

UFS driver messages are changes to from dev_err() to dev_dbg() which means
they will not display unless activated by dynamic debug of building
with -DDEBUG.

sdev->quiet_suspend is set to skip messages from sd_suspend_common()
"Synchronizing SCSI cache", "Stopping disk" and scsi_report_sense()
"Power-on or device reset occurred" message (Note, that message appears
when the LUN is accessed after runtime PM, not during runtime PM)

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

Note for stable: depends on patch "scsi: Add quiet_suspend flag for SCSI
devices to suppress some PM messages"

Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V4:

	Separate patch for UFS driver changes only.

Changes in V3:

	Keep reset sense message for non-UFS devices

Changes in V2:

	Remove offending SCSI messages
	Use dev_dbg for offending UFSHCD messages


 drivers/scsi/ufs/ufshcd.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 50b12d60dc1b..f057d9ff0c6c 100644
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
+	sdev->quiet_suspend = 1;
 
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
-- 
2.25.1

