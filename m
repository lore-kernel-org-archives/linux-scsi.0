From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH] scsi: ufs: introduce a new ufshcd_statea UFSHCD_STATE_EH_SCHEDULED
Date: Wed, 16 Nov 2016 11:29:37 +0800
Message-ID: <20161116032937.117395-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:11476 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935055AbcKPDad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 22:30:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Add a new ufshcd_state, indicats that an err handler may get to run
immediately. Use UFSHCD_STATE_ERROR here looks not literaly correct.

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05c7456..59d4130 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -123,6 +123,7 @@ enum {
 	UFSHCD_STATE_RESET,
 	UFSHCD_STATE_ERROR,
 	UFSHCD_STATE_OPERATIONAL,
+	UFSHCD_STATE_EH_SCHEDULED,
 };
 
 /* UFSHCD error handling flags */
@@ -1410,6 +1411,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
+	case UFSHCD_STATE_EH_SCHEDULED:
 	case UFSHCD_STATE_RESET:
 		err = SCSI_MLQUEUE_HOST_BUSY;
 		goto out_unlock;
@@ -4158,7 +4160,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 			/* block commands from scsi mid-layer */
 			scsi_block_requests(hba->host);
 
-			hba->ufshcd_state = UFSHCD_STATE_ERROR;
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
 			schedule_work(&hba->eh_work);
 		}
 	}
-- 
2.9.3

