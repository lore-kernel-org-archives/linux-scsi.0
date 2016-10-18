From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 04/11] scsi: ufs: commit descriptors before setting the doorbell
Date: Mon, 17 Oct 2016 17:09:36 -0700
Message-ID: <1476749376-11204-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935674AbcJRAJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 20:09:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

From: Gilad Broner <gbroner@codeaurora.org>

Add a write memory barrier to make sure descriptors prepared are actually
written to memory before ringing the doorbell. We have also added the
write memory barrier after ringing the doorbell register so that
controller sees the new request immediately.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a99f57b..beb4988 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -878,6 +878,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	/* Make sure that doorbell is committed immediately */
+	wmb();
 }
 
 /**
@@ -1475,6 +1477,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
 	}
+	/* Make sure descriptors are ready before ringing the doorbell */
+	wmb();
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -1585,6 +1589,8 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
 			msecs_to_jiffies(max_timeout));
 
+	/* Make sure descriptors are ready before ringing the doorbell */
+	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
@@ -4322,6 +4328,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	wmb();
 
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
+	/* Make sure that doorbell is committed immediately */
+	wmb();
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

