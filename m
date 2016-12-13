From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 03/12] scsi: ufs: fix multiple ufs spec violation
Date: Mon, 12 Dec 2016 16:53:01 -0800
Message-ID: <1481590382-32233-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57844 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbcLMAxT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 19:53:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

From: Dolev Raviv <draviv@codeaurora.org>

When a command to a W-LU is timed out via scsi, error handling
will treat it as any other LU and send commands such as
START_STOP with wrong format or task abort. Those commands are
illegal for W-LU according to the UFS spec.
To solve it, when an error is recognized those steps are skipped
and the last step, reset and restore process, is initiated.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 86bf409..7fdcab0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -218,6 +218,7 @@ enum {
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
+static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
@@ -4771,6 +4772,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	host = cmd->device->host;
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
+	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
 			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
@@ -4778,6 +4780,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		BUG();
 	}
 
+	/*
+	 * Task abort to the device W-LUN is illegal. When this command
+	 * will fail, due to spec violation, scsi err handling next step
+	 * will be to send LU reset which, again, is a spec violation.
+	 * To avoid these unnecessary/illegal step we skip to the last error
+	 * handling stage: reset and restore.
+	 */
+	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN)
+		return ufshcd_eh_host_reset_handler(cmd);
+
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return SUCCESS */
@@ -4801,7 +4813,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	ufshcd_print_pwr_info(hba);
 	ufshcd_print_trs(hba, 1 << tag, true);
 
-	lrbp = &hba->lrb[tag];
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 				UFS_QUERY_TASK, &resp);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

