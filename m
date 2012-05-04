From: akpm@linux-foundation.org
Subject: [patch 4/5] drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED
Date: Fri, 04 May 2012 14:35:10 -0700
Message-ID: <20120504213510.7254FA04FA@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42930 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759939Ab2EDVfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 17:35:11 -0400
Received: by vcbfl13 with SMTP id fl13so236670vcb.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 May 2012 14:35:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linkinjeon@gmail.com, santoshsy@gmail.com

From: Namjae Jeon <linkinjeon@gmail.com>
Subject: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED

Currently the UFS host driver has returned incorrect values for SUCCESS
and FAILED.  Fix it to return the correct value to the upper layer.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~ufs-fix-incorrect-return-value-about-success-and-failed drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~ufs-fix-incorrect-return-value-about-success-and-failed
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1163,6 +1163,8 @@ static int ufshcd_task_req_compl(struct 
 		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
 		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
 			task_result = FAILED;
+		else
+			task_result = SUCCESS;
 	} else {
 		task_result = FAILED;
 		dev_err(&hba->pdev->dev,
@@ -1556,7 +1558,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 	clear_bit(free_slot, &hba->tm_condition);
-	return ufshcd_task_req_compl(hba, free_slot);
+	err = ufshcd_task_req_compl(hba, free_slot);
 out:
 	return err;
 }
@@ -1580,7 +1582,7 @@ static int ufshcd_device_reset(struct sc
 	tag = cmd->request->tag;
 
 	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LOGICAL_RESET);
-	if (err)
+	if (err == FAILED)
 		goto out;
 
 	for (pos = 0; pos < hba->nutrs; pos++) {
@@ -1620,7 +1622,7 @@ static int ufshcd_host_reset(struct scsi
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		return SUCCESS;
 
-	return (ufshcd_do_reset(hba) == SUCCESS) ? SUCCESS : FAILED;
+	return ufshcd_do_reset(hba);
 }
 
 /**
@@ -1652,7 +1654,7 @@ static int ufshcd_abort(struct scsi_cmnd
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
-	if (err)
+	if (err == FAILED)
 		goto out;
 
 	scsi_dma_unmap(cmd);
_
