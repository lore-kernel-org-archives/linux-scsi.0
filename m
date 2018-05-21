From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/13] scsi: hisi_sas: Fix return value when get_free_slot() failed
Date: Mon, 21 May 2018 18:09:24 +0800
Message-ID: <1526897365-228549-13-git-send-email-john.garry@huawei.com>
References: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

It is an step of executing task to get free slot. If the step
fails, we will cleanup LLDD resources and should return failure
to upper layer or internal caller to abort task execution of this
time.

But in the current code, the caller of get_free_slot() doesn't
return failure when get_free_slot() failed. This patch is to fix
it.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2e02539..f6c4eb6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -443,6 +443,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	wr_q_index = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (wr_q_index < 0) {
 		spin_unlock_irqrestore(&dq->lock, flags_dq);
+		rc = -EAGAIN;
 		goto err_out_buf;
 	}
 
@@ -1708,6 +1709,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 	wr_q_index = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (wr_q_index < 0) {
 		spin_unlock_irqrestore(&dq->lock, flags_dq);
+		rc = -EAGAIN;
 		goto err_out_buf;
 	}
 	list_add_tail(&slot->delivery, &dq->list);
-- 
1.9.1
