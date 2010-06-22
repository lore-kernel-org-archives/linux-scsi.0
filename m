From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] SCSI: mvsas, fix potential NULL dereference
Date: Tue, 22 Jun 2010 13:42:02 +0200
Message-ID: <1277206922-27259-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>, Srinivas <satyasrinivasp@hcl.in>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stanse found that in mvs_abort_task, mvi_dev is dereferenced earlier
than tested for being NULL. Move the assignment below the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Srinivas <satyasrinivasp@hcl.in>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mvsas/mv_sas.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f5e3217..cab9242 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1640,7 +1640,7 @@ int mvs_abort_task(struct sas_task *task)
 	struct mvs_tmf_task tmf_task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
+	struct mvs_info *mvi;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 	u32 tag;
@@ -1650,6 +1650,8 @@ int mvs_abort_task(struct sas_task *task)
 		rc = TMF_RESP_FUNC_FAILED;
 	}
 
+	mvi = mvi_dev->mvi_info;
+
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-- 
1.7.1
