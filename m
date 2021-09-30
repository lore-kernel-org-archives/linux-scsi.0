Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C30C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 19:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6772861528
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 19:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346424AbhI3TyZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 15:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345816AbhI3TyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 15:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B61CB6128C;
        Thu, 30 Sep 2021 19:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633031561;
        bh=CXvy6PdBkhcfVgqmS4LcJkP5IHuDAOxPW0V+G5W0JGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=QhmGWal/y7/eTwmaqgbAxVr/9Qj2BUbiAU+4JVnIj55FGwYD5PZbr6sYR2TKtjUBg
         zv9j7aySzUCpKOOreIrVvDtDOdk2FwGMpFaxR6G+Bja3QLFsrYW1JhUKFfmTn+lgyj
         hg67r0mOSUyDl63YMxn3y9YB7z1zy2TDeeQfcEsv7B4owDPVJNGafCHKzNr9e/V4KT
         E/tbMS/vkumw6LZL7jh+bFvpvpDEpwxaCB8HsYbNsvfOp0sbcekS83U7m7QHkpQbBT
         HgQSH+3a7cPM9rlaKoaF+JBYQJFA4yVO5vjmMoZhZT9Vr2p0ftQZj+5GvjAlmGXApr
         uMQilrPh0CfNg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] scsi: ufs: retry START_STOP on UNIT_ATTENTION
Date:   Thu, 30 Sep 2021 12:52:36 -0700
Message-Id: <20210930195237.1521436-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 57d104c153d3 ("ufs: add UFS power management support") made the UFS
driver submit a REQUEST SENSE command before submitting a power management
command to a WLUN to clear the POWER ON unit attention. Instead of
submitting a REQUEST SENSE command before submitting a power management
command, retry the power management command until it succeeds.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..1f21d371e231 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8630,7 +8630,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret;
+	int ret, retries;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8665,8 +8665,14 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+	for (retries = 3; retries > 0; --retries) {
+		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+		if (!scsi_status_is_check_condition(ret) ||
+				!scsi_sense_valid(&sshdr) ||
+				sshdr.sense_key != UNIT_ATTENTION)
+			break;
+	}
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.33.0.800.g4c38ced690-goog

