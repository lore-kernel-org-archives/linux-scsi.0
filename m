Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CA4C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 18:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9364323443
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 18:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbhAGSyI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 13:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbhAGSyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 13:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CBB223403;
        Thu,  7 Jan 2021 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610045607;
        bh=erhpAKY+XwwvG5qml7bc0wewyfZ7jVTUXRAohXe9q/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teKLmvTcs8yQmxVZuiYgYaFCWPObyFbXzM7hFuX1YUqtVoCAzyvqQyymsCr2O8cdI
         al1dFolYOM5F89xp2aBdi2qjaQWMVN4dKPeA4lG5kyH5KMhDBwOo8LnxfKpCwGa1yq
         CRGX5zGIlXY5+eeqeNTSq/U/2kgjRBceNthDH8nlMVgwb4YWQL7Znj9xLhqDhL+cyg
         8/73pxap+ddZrQ3UBay/9DzwoH2RJXcwvoK2HSWkZNrQUKiG1tzuiNEeZv3XCg11kz
         pXSv3Q4It4+iCAR5Riq9NAsNCLw2njt73Y0Ubv3+bpqcyTve2r5X0HgN2ZF5pw5B6l
         zioV1cFCz5Vrw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v5 1/2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Date:   Thu,  7 Jan 2021 10:53:15 -0800
Message-Id: <20210107185316.788815-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20210107185316.788815-1-jaegeuk@kernel.org>
References: <20210107185316.788815-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When gate_work/ungate_work gets an error during hibern8_enter or exit,
 ufshcd_err_handler()
   ufshcd_scsi_block_requests()
   ufshcd_reset_and_restore()
     ufshcd_clear_ua_wluns() -> stuck
   ufshcd_scsi_unblock_requests()

In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery flows
such as suspend/resume, link_recovery, and error_handler.

Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd resets")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Reviewed-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bedb822a40a3..e6e7bdf99cd7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3996,6 +3996,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
+	else
+		ufshcd_clear_ua_wluns(hba);
 
 	return ret;
 }
@@ -6003,6 +6005,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->eh_sem);
+
+	if (!err && needs_reset)
+		ufshcd_clear_ua_wluns(hba);
 }
 
 /**
@@ -6940,14 +6945,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	ufshcd_set_clk_freq(hba, true);
 
 	err = ufshcd_hba_enable(hba);
-	if (err)
-		goto out;
 
 	/* Establish the link again and restore the device */
-	err = ufshcd_probe_hba(hba, false);
 	if (!err)
-		ufshcd_clear_ua_wluns(hba);
-out:
+		err = ufshcd_probe_hba(hba, false);
+
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
 	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
@@ -7718,6 +7720,8 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	ufshcd_clear_ua_wluns(hba);
+
 	/* Initialize devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
 		memcpy(&hba->clk_scaling.saved_pwr_info.info,
@@ -7919,8 +7923,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
-	} else {
-		ufshcd_clear_ua_wluns(hba);
 	}
 }
 
@@ -8777,6 +8779,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
+	ufshcd_clear_ua_wluns(hba);
 	ufshcd_release(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
@@ -8887,6 +8890,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
+	ufshcd_clear_ua_wluns(hba);
+
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
 
-- 
2.29.2.729.g45daf8777d-goog

