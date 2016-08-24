From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 3/8] hisi_sas: add internal abort to hisi_sas_abort_task()
Date: Wed, 24 Aug 2016 19:05:49 +0800
Message-ID: <1472036754-156813-4-git-send-email-john.garry@huawei.com>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Execute an internal abort for executing a task abort.
This is for case of the command still being present
in host when abort is executed.

For a SATA internal abort, we set abort for all tasks
associated with the device.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c4e59cd..280a19d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -841,18 +841,22 @@ static int hisi_sas_abort_task(struct sas_task *task)
 			}
 		}
 
+		hisi_sas_internal_task_abort(hisi_hba, device,
+					     HISI_SAS_INT_ABT_CMD, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (task->dev->dev_type == SAS_SATA_DEV) {
-			struct hisi_slot_info *slot = task->lldd_task;
-
-			dev_notice(dev, "abort task: hba=%p task=%p slot=%p\n",
-				   hisi_hba, task, slot);
-			task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+			hisi_sas_internal_task_abort(hisi_hba, device,
+						     HISI_SAS_INT_ABT_DEV, 0);
 			rc = TMF_RESP_FUNC_COMPLETE;
-			goto out;
 		}
+	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
+		/* SMP */
+		struct hisi_sas_slot *slot = task->lldd_task;
+		u32 tag = slot->idx;
 
+		hisi_sas_internal_task_abort(hisi_hba, device,
+					     HISI_SAS_INT_ABT_CMD, tag);
 	}
 
 out:
-- 
1.9.1
