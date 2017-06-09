From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 01/23] scsi: hisi_sas: fix timeout check in hisi_sas_internal_task_abort()
Date: Fri, 9 Jun 2017 22:16:14 +0800
Message-ID: <1497017796-105067-2-git-send-email-john.garry@huawei.com>
References: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

We need to check for timeout before task status, or the task will be
mistook as completed internal abort command.
Also add protection for sas_task.task_state_flags in
hisi_sas_tmf_timedout().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f720d3c..3605d28 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -691,8 +691,13 @@ static void hisi_sas_task_done(struct sas_task *task)
 static void hisi_sas_tmf_timedout(unsigned long data)
 {
 	struct sas_task *task = (struct sas_task *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	complete(&task->slow_task->completion);
 }
 
@@ -1247,6 +1252,17 @@ static int hisi_sas_query_task(struct sas_task *task)
 	wait_for_completion(&task->slow_task->completion);
 	res = TMF_RESP_FUNC_FAILED;
 
+	/* Internal abort timed out */
+	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+			struct hisi_sas_slot *slot = task->lldd_task;
+
+			if (slot)
+				slot->task = NULL;
+			dev_err(dev, "internal task abort: timeout.\n");
+		}
+	}
+
 	if (task->task_status.resp == SAS_TASK_COMPLETE &&
 		task->task_status.stat == TMF_RESP_FUNC_COMPLETE) {
 		res = TMF_RESP_FUNC_COMPLETE;
@@ -1259,13 +1275,6 @@ static int hisi_sas_query_task(struct sas_task *task)
 		goto exit;
 	}
 
-	/* Internal abort timed out */
-	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-			dev_err(dev, "internal task abort: timeout.\n");
-		}
-	}
-
 exit:
 	dev_dbg(dev, "internal task abort: task to dev %016llx task=%p "
 		"resp: 0x%x sts 0x%x\n",
-- 
1.9.1
