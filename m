From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 2/2] [SCSI] ufs: add SCSI host lock push-down for ufs.
Date: Tue,  1 May 2012 10:31:26 -0400
Message-ID: <1335882686-16071-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2EAObl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 10:31:41 -0400
Received: by pbbrp8 with SMTP id rp8so4465184pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 01 May 2012 07:31:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jBottomley@parallels.com, akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>

SCSI host lock push-down patch is not applied in ufs host driver yet.
After adding it, I tried to remove unneeded spin lock in queuecommand also.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3cb7a08..a134738 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -658,23 +658,23 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_queuecommand - main entry point for SCSI requests
+ * ufshcd_queuecommand_lck - main entry point for SCSI requests
  * @cmd: command from SCSI Midlayer
  * @done: call back function
  *
  * Returns 0 for success, non-zero in case of failure
  */
-static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+static int
+ufshcd_queuecommand_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
-	unsigned long flags;
 	int tag;
 	int err = 0;
 
-	hba = shost_priv(host);
+	hba = shost_priv(scp->device->host);
 
-	tag = cmd->request->tag;
+	tag = scp->request->tag;
 
 	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
 		err = SCSI_MLQUEUE_HOST_BUSY;
@@ -683,11 +683,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp = &hba->lrb[tag];
 
-	lrbp->cmd = cmd;
+	lrbp->cmd = scp;
 	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
-	lrbp->sense_buffer = cmd->sense_buffer;
+	lrbp->sense_buffer = scp->sense_buffer;
 	lrbp->task_tag = tag;
-	lrbp->lun = cmd->device->lun;
+	lrbp->lun = scp->device->lun;
 
 	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
@@ -698,13 +698,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 
 	/* issue command to the controller */
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
 	return err;
 }
 
+static DEF_SCSI_QCMD(ufshcd_queuecommand);
+
 /**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
-- 
1.7.5.4

