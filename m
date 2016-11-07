From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/11] hisi_sas: use atomic64_t for hisi_sas_device.running_req
Date: Mon, 7 Nov 2016 20:48:39 +0800
Message-ID: <1478522920-108145-11-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Sometimes the value of hisi_sas_device.running_req
would go negative unless we have the check for
running_req >= 0 before trying to decrement.

This is because using running_req is not thread-safe.

As such, the value for running_req may be actually incorrect,
so use atomic64_t instead.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 9 +++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index bf59fab..8b5ecc6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -111,7 +111,7 @@ struct hisi_sas_device {
 	struct domain_device	*sas_device;
 	u64 attached_phy;
 	u64 device_id;
-	u64 running_req;
+	atomic64_t running_req;
 	u8 dev_status;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 504cbcf..18e2194 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -162,8 +162,8 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 	hisi_sas_slot_task_free(hisi_hba, task, abort_slot);
 	if (task->task_done)
 		task->task_done(task);
-	if (sas_dev && sas_dev->running_req)
-		sas_dev->running_req--;
+	if (sas_dev)
+		atomic64_dec(&sas_dev->running_req);
 }
 
 static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
@@ -303,7 +303,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 
 	hisi_hba->slot_prep = slot;
 
-	sas_dev->running_req++;
+	atomic64_inc(&sas_dev->running_req);
 	++(*pass);
 
 	return 0;
@@ -1027,7 +1027,8 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 	hisi_hba->slot_prep = slot;
 
-	sas_dev->running_req++;
+	atomic64_inc(&sas_dev->running_req);
+
 	/* send abort command to our chip */
 	hisi_hba->hw->start_delivery(hisi_hba);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index bbc5760..05177fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1366,8 +1366,8 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-	if (sas_dev && sas_dev->running_req)
-		sas_dev->running_req--;
+	if (sas_dev)
+		atomic64_dec(&sas_dev->running_req);
 
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cda3baf..e88113a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1728,8 +1728,8 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-	if (sas_dev && sas_dev->running_req)
-		sas_dev->running_req--;
+	if (sas_dev)
+		atomic64_dec(&sas_dev->running_req);
 
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
-- 
1.9.1
