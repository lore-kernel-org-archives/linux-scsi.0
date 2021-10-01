Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103DFC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 18:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F6861ABE
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 18:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355770AbhJASWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 14:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354947AbhJASWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Oct 2021 14:22:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1355561ABA;
        Fri,  1 Oct 2021 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633112433;
        bh=G7UqmYmy+/1tzb9K3PPrde7yZpsU8B6HGBfcnvwh28I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hdhdx/kqebHsex+8VyplHzSV+ZtEbjr972zdfa8+y7W2cTMK95E1rw76kkMOvUmhQ
         N1wu6CTD648yFpIr3iCZJjNOhPy/NeUWEhH7bZtZoUT8yQaPLd4WuGBxZ3jX7nXrbB
         mC/JwXjDnrK2B3zkdFr8WvIeugow+JdSouifpT0LAHF3B/yP/BUFGnaYkJIVKQc7S9
         ypdOwiwmuSb6C7187E9jPuTWh7GW061VM2QDfCQ9gkZfGkdZDBmSvZCjdVqYuPZCkB
         P2yumIY7cOklWbzJ4xjw1DTVMtlfejuEeX5yqvoIFnj0rtwO6uafOPHm5bhVB9YcdQ
         9GYM/0S8C4K5Q==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] scsi: ufs: retry START_STOP on UNIT_ATTENTION
Date:   Fri,  1 Oct 2021 11:20:14 -0700
Message-Id: <20211001182015.1347587-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20211001182015.1347587-1-jaegeuk@kernel.org>
References: <20211001182015.1347587-1-jaegeuk@kernel.org>
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

This is the preparation to get rid of all UNIT ATTENTION code which should
be handled by users.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9faf02cbb9ad..7ec72de826e5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8676,7 +8676,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret;
+	int ret, retries;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8711,8 +8711,14 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
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

