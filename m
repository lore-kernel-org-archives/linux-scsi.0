From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: mvumi: Using plain integer as NULL pointer
Date: Sat, 16 Feb 2019 18:01:30 +0800
Message-ID: <20190216100130.19396-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fix following sparse warning:

drivers/scsi/mvumi.c:1797:48: warning: Using plain integer as NULL pointer
drivers/scsi/mvumi.c:2143:50: warning: Using plain integer as NULL pointer
drivers/scsi/mvumi.c:755:58: warning: Using plain integer as NULL pointer

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/mvumi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 36f6420..a8fe1f8 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -752,7 +752,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
 		spin_lock_irqsave(mhba->shost->host_lock, flags);
 		atomic_dec(&cmd->sync_cmd);
 		if (mhba->tag_cmd[cmd->frame->tag]) {
-			mhba->tag_cmd[cmd->frame->tag] = 0;
+			mhba->tag_cmd[cmd->frame->tag] = NULL;
 			dev_warn(&mhba->pdev->dev, "TIMEOUT:release tag [%d]\n",
 							cmd->frame->tag);
 			tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
@@ -1794,7 +1794,7 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
 		cmd = mhba->tag_cmd[ob_frame->tag];
 
 		atomic_dec(&mhba->fw_outstanding);
-		mhba->tag_cmd[ob_frame->tag] = 0;
+		mhba->tag_cmd[ob_frame->tag] = NULL;
 		tag_release_one(mhba, &mhba->tag_pool, ob_frame->tag);
 		if (cmd->scmd)
 			mvumi_complete_cmd(mhba, cmd, ob_frame);
@@ -2140,7 +2140,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	spin_lock_irqsave(mhba->shost->host_lock, flags);
 
 	if (mhba->tag_cmd[cmd->frame->tag]) {
-		mhba->tag_cmd[cmd->frame->tag] = 0;
+		mhba->tag_cmd[cmd->frame->tag] = NULL;
 		tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
 	}
 	if (!list_empty(&cmd->queue_pointer))
-- 
2.7.0
