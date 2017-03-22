From: John Garry <john.garry@huawei.com>
Subject: [PATCH 20/23] scsi: hisi_sas: release SMP slot in lldd_abort_task
Date: Thu, 23 Mar 2017 01:25:36 +0800
Message-ID: <1490203539-228029-21-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When an SMP task timeouts, it will call lldd_abort_task
to release the associated slot, and then will release
the sas_task.

Currently in lldd_abort_task, if we fail to internally
abort IO, then the slot of SMP IO is not released,
but sas_task will still be later released, so the slot's
sas_task is NULL, which will cause NULL pointer when
hisi_sas_slot_task_free happens later.

To resolve, check the return value of internal abort,
and release the slot if it failed.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f86263b..1391f2d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -962,8 +962,13 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		struct hisi_sas_slot *slot = task->lldd_task;
 		u32 tag = slot->idx;
 
-		hisi_sas_internal_task_abort(hisi_hba, device,
-					     HISI_SAS_INT_ABT_CMD, tag);
+		rc = hisi_sas_internal_task_abort(hisi_hba, device,
+			     HISI_SAS_INT_ABT_CMD, tag);
+		if (rc == TMF_RESP_FUNC_FAILED) {
+			spin_lock_irqsave(&hisi_hba->lock, flags);
+			hisi_sas_do_release_task(hisi_hba, task, slot);
+			spin_unlock_irqrestore(&hisi_hba->lock, flags);
+		}
 	}
 
 out:
-- 
1.9.1
