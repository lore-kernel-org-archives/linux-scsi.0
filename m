Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF4FC4727D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 12:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5382520719
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 12:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387896AbgJBMlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 08:41:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:36769 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgJBMlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 08:41:25 -0400
IronPort-SDR: Ytp5BERBMJKaySN8iB1ccYpfH5AZSUYk38k+HGX4l1+hyiJrm9bLD1nclqgGWq7C2awQqb8JfJ
 NQwsNs0XDnxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="181105711"
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="181105711"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 05:41:22 -0700
IronPort-SDR: 5SHLbzd24ughPzdChNcooU7gcjhhwuJWtnyZo0U/aa0fmsS3Vcvnim86XmApf07qPOA1ygr3Rc
 EhzHKaCVJ6Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="352362859"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.190])
  by orsmga007.jf.intel.com with ESMTP; 02 Oct 2020 05:41:20 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: Workaround UFS devices that object to DeepSleep IMMED
Date:   Fri,  2 Oct 2020 15:40:43 +0300
Message-Id: <20201002124043.25394-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002124043.25394-1-adrian.hunter@intel.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The UFS specification says to set the IMMED (immediate) flag for the
Start/Stop Unit command when entering DeepSleep. However some UFS
devices object to that. Workaround that by retrying without IMMED.
Whichever possibility works, the result is recorded for the next
time.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 53 +++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h | 11 ++++++++
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d072b0c80bd8..3a67a711c0ae 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8202,6 +8202,44 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 	return ret;
 }
 
+static bool ufshcd_set_immed(struct ufs_hba *hba,
+			     enum ufs_dev_pwr_mode pwr_mode)
+{
+	/*
+	 * DeepSleep requires the Immediate flag. DeepSleep state is actually
+	 * entered when the link state goes to Hibern8.
+	 */
+	return pwr_mode == UFS_DEEPSLEEP_PWR_MODE &&
+	       hba->deepsleep_immed != UFS_DEEPSLEEP_IMMED_BROKEN;
+}
+
+static bool ufshcd_retry_dev_pwr_mode(struct ufs_hba *hba,
+				      enum ufs_dev_pwr_mode pwr_mode,
+				      unsigned char *cmd, int ret,
+				      struct scsi_sense_hdr *sshdr)
+{
+	if (pwr_mode == UFS_DEEPSLEEP_PWR_MODE &&
+	    hba->deepsleep_immed == UFS_DEEPSLEEP_IMMED_UNKNOWN &&
+	    (cmd[1] & 1) && driver_byte(ret) == DRIVER_SENSE &&
+	    scsi_sense_valid(sshdr) && sshdr->sense_key == ILLEGAL_REQUEST) {
+		cmd[1] &= ~1;
+		return true;
+	}
+	return false;
+}
+
+static void ufshcd_set_dev_pwr_mode_success(struct ufs_hba *hba,
+					    enum ufs_dev_pwr_mode pwr_mode,
+					    unsigned char *cmd)
+{
+	if (pwr_mode == UFS_DEEPSLEEP_PWR_MODE &&
+	    hba->deepsleep_immed == UFS_DEEPSLEEP_IMMED_UNKNOWN) {
+		hba->deepsleep_immed = (cmd[1] & 1) ?
+					UFS_DEEPSLEEP_IMMED_OK :
+					UFS_DEEPSLEEP_IMMED_BROKEN;
+	}
+}
+
 /**
  * ufshcd_set_dev_pwr_mode - sends START STOP UNIT command to set device
  *			     power mode
@@ -8251,14 +8289,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		hba->wlun_dev_clr_ua = false;
 	}
 
-	/*
-	 * DeepSleep requires the Immediate flag. DeepSleep state is actually
-	 * entered when the link state goes to Hibern8.
-	 */
-	if (pwr_mode == UFS_DEEPSLEEP_PWR_MODE)
-		cmd[1] = 1;
+	cmd[1] = ufshcd_set_immed(hba, pwr_mode) ? 1 : 0;
 	cmd[4] = pwr_mode << 4;
-
+retry:
 	/*
 	 * Current function would be generally called from the power management
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
@@ -8267,6 +8300,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
 	if (ret) {
+		if (ufshcd_retry_dev_pwr_mode(hba, pwr_mode, cmd, ret, &sshdr))
+			goto retry;
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
@@ -8274,8 +8309,10 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
-	if (!ret)
+	if (!ret) {
 		hba->curr_dev_pwr_mode = pwr_mode;
+		ufshcd_set_dev_pwr_mode_success(hba, pwr_mode, cmd);
+	}
 out:
 	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8c6094fb35f4..b4bf00891c9f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -147,6 +147,16 @@ struct ufs_pm_lvl_states {
 	enum uic_link_state link_state;
 };
 
+/*
+ * Whether or not to set the immediate flag for the DeepSleep START_STOP unit
+ * command.
+ */
+enum ufs_deepsleep_immed {
+	UFS_DEEPSLEEP_IMMED_UNKNOWN,	/* Set IMMED, but retry without it */
+	UFS_DEEPSLEEP_IMMED_OK,		/* Set IMMED */
+	UFS_DEEPSLEEP_IMMED_BROKEN,	/* Do not set IMMED */
+};
+
 /**
  * struct ufshcd_lrb - local reference block
  * @utr_descriptor_ptr: UTRD address of the command
@@ -705,6 +715,7 @@ struct ufs_hba {
 	struct device_attribute rpm_lvl_attr;
 	struct device_attribute spm_lvl_attr;
 	int pm_op_in_progress;
+	enum ufs_deepsleep_immed deepsleep_immed;
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
-- 
2.17.1

