Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B8DC432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93E37207DD
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKZGyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 01:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbfKZGyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 01:54:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D14D5C48B02; Tue, 26 Nov 2019 06:54:20 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB868C76F4C;
        Tue, 26 Nov 2019 06:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB868C76F4C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=pass (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=pass smtp.mailfrom=cang@qti.qualcomm.com
From:   Can Guo <cang@qti.qualcomm.com>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 4/4] scsi: ufs: Complete pending requests in host reset and restore path
Date:   Mon, 25 Nov 2019 22:53:33 -0800
Message-Id: <1574751214-8321-5-git-send-email-cang@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

In UFS host reset and restore path, before probe, we stop and start the
host controller once. After host controller is stopped, the pending
requests, if any, are cleared from the doorbell, but no completion IRQ
would be raised due to the hba is stopped.
These pending requests shall be completed along with the first NOP_OUT
command(as it is the first command which can raise a transfer completion
IRQ) sent during probe.
Since the OCSs of these pending requests are not SUCCESS(because they are
not yet literally finished), their UPIUs shall be dumped. When there are
multiple pending requests, the UPIU dump can be overwhelming and may lead
to stability issues because it is in atomic context.
Therefore, before probe, complete these pending requests right after host
controller is stopped and silence the UPIU dump from them.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 24 ++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5950a7c..b92a3f4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4845,7 +4845,7 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 		break;
 	} /* end of switch */
 
-	if (host_byte(result) != DID_OK)
+	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -5404,8 +5404,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	/*
 	 * if host reset is required then skip clearing the pending
-	 * transfers forcefully because they will automatically get
-	 * cleared after link startup.
+	 * transfers forcefully because they will get cleared during
+	 * host reset and restore
 	 */
 	if (needs_reset)
 		goto skip_pending_xfer_clear;
@@ -6333,9 +6333,15 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	int err;
 	unsigned long flags;
 
-	/* Reset the host controller */
+	/*
+	 * Stop the host controller and complete the requests
+	 * cleared by h/w
+	 */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_hba_stop(hba, false);
+	hba->silence_err_logs = true;
+	ufshcd_complete_requests(hba);
+	hba->silence_err_logs = false;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* scale up clocks to max frequency before full reinitialization */
@@ -6369,7 +6375,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
 	int err = 0;
-	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
 	do {
@@ -6379,15 +6384,6 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
 
-	/*
-	 * After reset the door-bell might be cleared, complete
-	 * outstanding requests in s/w here.
-	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_transfer_req_compl(hba);
-	ufshcd_tmc_handler(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
 	return err;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..1e51034 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -513,6 +513,7 @@ struct ufs_stats {
  * @uic_error: UFS interconnect layer error status
  * @saved_err: sticky error mask
  * @saved_uic_err: sticky UIC error mask
+ * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
  * @auto_bkops_enabled: to track whether bkops is enabled in device
@@ -670,6 +671,7 @@ struct ufs_hba {
 	u32 saved_err;
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
+	bool silence_err_logs;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

