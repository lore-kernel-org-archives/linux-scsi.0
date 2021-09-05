Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6F2C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 09:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBCD60F12
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 09:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbhIEJwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 05:52:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:45314 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhIEJwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 5 Sep 2021 05:52:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10097"; a="219779267"
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="scan'208";a="219779267"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 02:51:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="scan'208";a="468519265"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.174])
  by orsmga007.jf.intel.com with ESMTP; 05 Sep 2021 02:51:28 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
Date:   Sun,  5 Sep 2021 12:51:51 +0300
Message-Id: <20210905095153.6217-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210905095153.6217-1-adrian.hunter@intel.com>
References: <20210905095153.6217-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no guarantee to be able to enter the queue if requests are
blocked. That is because freezing the queue will block entry to the
queue, but freezing also waits for outstanding requests which can make
no progress while the queue is blocked.

That situation can happen when the error handler issues requests to
clear unit attention condition. Requests can be blocked if the
ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, which can happen
as a result either of error handler activity, or theoretically a
request that is issued after the error handler unblocks the queue
but before clearing unit attention condition.

The deadlock is very unlikely, so the error handler can be expected
to clear ua at some point anyway, so the simple solution is not to
wait to enter the queue.

Additionally, note that the RPMB queue might be not be entered because
it is runtime suspended, but in that case ua will be cleared at RPMB
runtime resume.

Cc: stable@vger.kernel.org # 5.14+ ac1bc2ba060f: scsi: ufs: Request sense data asynchronously
Cc: stable@vger.kernel.org # 5.14+ 9b5ac8ab4e8b: scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V3:

	Correct commit message.
	Amend stable tags to add dependent cherry picks


 drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 67889d74761c..52fb059efa77 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -224,7 +224,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
-static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba, bool nowait);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
@@ -4110,7 +4110,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
 	else
-		ufshcd_clear_ua_wluns(hba);
+		ufshcd_clear_ua_wluns(hba, false);
 
 	return ret;
 }
@@ -5974,7 +5974,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
-	ufshcd_clear_ua_wluns(hba);
+	ufshcd_clear_ua_wluns(hba, true);
 	ufshcd_rpm_put(hba);
 }
 
@@ -7907,7 +7907,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	ufshcd_clear_ua_wluns(hba);
+	ufshcd_clear_ua_wluns(hba, false);
 
 	/* Initialize devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
@@ -7943,7 +7943,8 @@ static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
 }
 
 static int
-ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
+ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev,
+			   bool nowait)
 {
 	/*
 	 * Some UFS devices clear unit attention condition only if the sense
@@ -7951,6 +7952,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	 */
 	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
 	struct scsi_request *rq;
+	blk_mq_req_flags_t flags;
 	struct request *req;
 	char *buffer;
 	int ret;
@@ -7959,8 +7961,8 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
-			      /*flags=*/BLK_MQ_REQ_PM);
+	flags = BLK_MQ_REQ_PM | (nowait ? BLK_MQ_REQ_NOWAIT : 0);
+	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, flags);
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out_free;
@@ -7990,7 +7992,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	return ret;
 }
 
-static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
+static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun, bool nowait)
 {
 	struct scsi_device *sdp;
 	unsigned long flags;
@@ -8016,7 +8018,10 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	if (ret)
 		goto out_err;
 
-	ret = ufshcd_request_sense_async(hba, sdp);
+	ret = ufshcd_request_sense_async(hba, sdp, nowait);
+	if (nowait && ret && wlun == UFS_UPIU_RPMB_WLUN &&
+	    pm_runtime_suspended(&sdp->sdev_gendev))
+		ret = 0; /* RPMB runtime resume will clear UAC */
 	scsi_device_put(sdp);
 out_err:
 	if (ret)
@@ -8025,16 +8030,16 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	return ret;
 }
 
-static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba, bool nowait)
 {
 	int ret = 0;
 
 	if (!hba->wlun_dev_clr_ua)
 		goto out;
 
-	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
+	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN, nowait);
 	if (!ret)
-		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
+		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN, nowait);
 	if (!ret)
 		hba->wlun_dev_clr_ua = false;
 out:
@@ -8656,7 +8661,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 */
 	hba->host->eh_noresume = 1;
 	if (hba->wlun_dev_clr_ua)
-		ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
+		ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN, false);
 
 	cmd[4] = pwr_mode << 4;
 
@@ -9825,7 +9830,7 @@ static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
 
 	if (!hba->wlun_rpmb_clr_ua)
 		return 0;
-	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
+	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN, false);
 	if (!ret)
 		hba->wlun_rpmb_clr_ua = 0;
 	return ret;
-- 
2.17.1

