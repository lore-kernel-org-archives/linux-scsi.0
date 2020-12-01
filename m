Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D362C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 04:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BB112073C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 04:15:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4ggzrxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgLAEOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 23:14:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgLAEOv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 23:14:51 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A1420725;
        Tue,  1 Dec 2020 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606796050;
        bh=PlLOAxsEMv5+xbPFqK55E56Pqe82bs9RFICqdVs/xuA=;
        h=From:To:Cc:Subject:Date:From;
        b=Y4ggzrxIARtzC+hrMoiQOKkijo7yTCg4STb2dZUi3eZkQTkSQQEPfH2/8YEYRYlI9
         cJENdFlu6VYC2XBvPKd3HVMFrU8Aim0ULyFSqNlmmHgBPVWjYaw0nIuM7VqeIlhpTO
         oAlzQOMnE681ybFQS1wph88vFF6CDFJ75ra8qZmM=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Randall Huang <huangrandall@google.com>,
        Leo Liou <leoliou@google.com>, Jaegeuk Kim <jaegeuk@google.com>
Subject: [PATCH] scsi: ufs: clear uac for RPMB after ufshcd resets
Date:   Mon, 30 Nov 2020 20:14:02 -0800
Message-Id: <20201201041402.3860525-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Randall Huang <huangrandall@google.com>

If RPMB is not provisioned, we may see RPMB failure after UFS suspend/resume.
Inject request_sense to clear uac in ufshcd reset flow.

Signed-off-by: Randall Huang <huangrandall@google.com>
Signed-off-by: Leo Liou <leoliou@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dba3ee307307..c728c00b58db 100644
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
 
-- 
2.29.2.454.gaff20da3a2-goog

