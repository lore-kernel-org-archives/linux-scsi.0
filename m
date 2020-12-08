Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFE8C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7832310E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgLHVv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgLHVv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Dec 2020 16:51:58 -0500
Date:   Tue, 8 Dec 2020 13:51:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607464277;
        bh=yZmkyOw708uk+qtFAUhQepgGFTdqhLTaCVU0MzOV+iU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKski44zBJYdLaTuXXc4vt9RN0SDBwl/IbQLBKuSbtU2XFv/xDIY1ytzdhosMPM6V
         0y9D8KWsTrqPerOjKyUOQdjhjZkpQ1nKgzYY9DsHT1/81o1Pb0IoICen2YZIHsRXhX
         r3eApoF7E6LFxZLmtbhCX2yrMdEzGJoxrhq5sPjIGYMYxlEL67oewNqzhAyym9EFWT
         u+g71oTEiHLpUotJ+4tQ6jdmCrwODE/u87UOEQAKFBtGn5uueDBqmDlx8MQZcCoLIr
         vuReeUDid3nl1FSZV9HNZ+1EMrw48l6zeRuzhrJM0rHWus6SDz4SSsG5l1nNQ8Uhpz
         dXReF28+AjxCg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Randall Huang <huangrandall@google.com>,
        Leo Liou <leoliou@google.com>
Subject: Re: [PATCH v2] scsi: ufs: clear uac for RPMB after ufshcd resets
Message-ID: <X8/1U8+Dd3UJjKA/@google.com>
References: <20201201041402.3860525-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201041402.3860525-1-jaegeuk@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From 902e313f0d7ccf5e24491c2badc6dc173ce35fb1 Mon Sep 17 00:00:00 2001
From: Randall Huang <huangrandall@google.com>
Date: Tue, 24 Nov 2020 15:29:58 +0800
Subject: [PATCH] scsi: ufs: clear uac for RPMB after ufshcd resets

If RPMB is not provisioned, we may see RPMB failure after UFS suspend/resume.
Inject request_sense to clear uac in ufshcd reset flow.

Signed-off-by: Randall Huang <huangrandall@google.com>
Signed-off-by: Leo Liou <leoliou@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---

 v2:
  - fix build warning

 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dba3ee307307..d6a3a0ba6960 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -220,6 +220,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
@@ -6814,7 +6815,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 
 	/* Establish the link again and restore the device */
 	err = ufshcd_probe_hba(hba, false);
-
+	if (!err)
+		ufshcd_clear_ua_wluns(hba);
 out:
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -8304,13 +8306,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * handling context.
 	 */
 	hba->host->eh_noresume = 1;
-	if (hba->wlun_dev_clr_ua) {
-		ret = ufshcd_send_request_sense(hba, sdp);
-		if (ret)
-			goto out;
-		/* Unit attention condition is cleared now */
-		hba->wlun_dev_clr_ua = false;
-	}
+	ufshcd_clear_ua_wluns(hba);
 
 	cmd[4] = pwr_mode << 4;
 
@@ -8331,7 +8327,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 
 	if (!ret)
 		hba->curr_dev_pwr_mode = pwr_mode;
-out:
+
 	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
 	return ret;
-- 
2.29.2.576.ga3fc446d84-goog

