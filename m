Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4830C433E9
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 19:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99BCA2312A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 19:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbhAFTg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 14:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbhAFTgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Jan 2021 14:36:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDB252312C;
        Wed,  6 Jan 2021 19:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609961745;
        bh=Sg6PHuBnrD/N1YEvncinjBd0H+xRihqqKourTu1UvQc=;
        h=From:To:Cc:Subject:Date:From;
        b=O4AR86dArQmMhdipsEsc/LHz65PVMw7vDY5eFFnsbL4GLthP77U77hqV0KRJBLSxf
         7rPvQugxBiiCQ5K4js4++OHfwOrAMhN8h4bpN498D7uh8YXLjeuFFi8O379t08cAO2
         SAS3yqOvz/PkcEFDfNuSttHAfUOy692mKgx1p0l0mlygjAQ8/3uyHUqDfr1jTucjF8
         +qjFdczxrI+wemKcnO5UOoKrWlIzNIZNaq62k0ZRG1nr9b68Jn6wJlFjNPY6BxlcRI
         RBNHy4Dz9jCSIe9IKc6LceFmUn8hhGS5LBsbFBy3C4vJ4ftQhJ4OXBlS7Dury/j9zx
         cCOaW5fkMWXRQ==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Date:   Wed,  6 Jan 2021 11:35:36 -0800
Message-Id: <20210106193537.3347681-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
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
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bedb822a40a3..1678cec08b51 100644
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

