From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH] scsi: ufs: flush eh_work when eh_work scheduled.
Date: Sat, 24 Jun 2017 19:14:32 +0800
Message-ID: <20170624111432.11852-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8375 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFXLPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jun 2017 07:15:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Forget a condition: eh_work scheduled but do not start to work.

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e050dcea1bea..a2dff12713fc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5807,7 +5807,8 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	do {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		if (!(work_pending(&hba->eh_work) ||
-				hba->ufshcd_state == UFSHCD_STATE_RESET))
+			    hba->ufshcd_state == UFSHCD_STATE_RESET ||
+			    hba->ufshcd_state == UFSHCD_STATE_EH_SCHEDULED))
 			break;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
-- 
2.13.0
