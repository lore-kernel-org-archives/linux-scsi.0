Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8101CC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 15:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4873422CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 15:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgLUP1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 10:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgLUP1I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Dec 2020 10:27:08 -0500
Date:   Mon, 21 Dec 2020 07:26:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608564387;
        bh=LV+j6LH9cEGVQGrj5ole2ULK2AGRXA9YiKHBTKba6+8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOKiqZfT+rtNdhtlLXqIZmZ4pLEPr77hdOhTVsz7Tb+B8Ip59/i/DjiUP2/r/GzUt
         5Of14DfbBbcJkAhtKZnWr6dka3O5c5VhpOTvyH9fWbQ6ZFO57Z4ac0ICgdjioVBm40
         N/J7Z0yZgy3j1d3sAEy24Bof+W3nVP6VDEIJ8TDAPyOtvXrE1X5fUCVqUg0oEKp+kW
         WsXSW8zI3Lz475HPz5JMvdCCeY9LXieB7tj1j19FgTzhadoM4z6FmStaet7RakeAnR
         Sj259to+e9X4g6qbCwlBIKFOvt5siUWPKTvJkJXBqv/XIR1fy6MRr7+M9XOmHsYXk4
         fX5ki50YgQ46w==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com
Subject: Re: [PATCH v2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Message-ID: <X+C+oqegC7EI6zDv@google.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218033131.2624065-1-jaegeuk@kernel.org>
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

 Change log from v1:
  - add condition check to call
  - add Fixes tag

 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add25a7e..29a62552f6f1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3963,6 +3963,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
+	else
+		ufshcd_clear_ua_wluns(hba);
 
 	return ret;
 }
@@ -5968,6 +5970,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->eh_sem);
+
+	if (!err && needs_reset)
+		ufshcd_clear_ua_wluns(hba);
 }
 
 /**
@@ -6908,14 +6913,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
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
@@ -8745,6 +8747,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
+	ufshcd_clear_ua_wluns(hba);
 	ufshcd_release(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
@@ -8855,6 +8858,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
+	ufshcd_clear_ua_wluns(hba);
+
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
 
-- 
2.29.2.729.g45daf8777d-goog

