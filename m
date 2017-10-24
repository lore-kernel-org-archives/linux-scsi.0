From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/19] scsi: hisi_sas: fix NULL check in SMP abort task path
Date: Tue, 24 Oct 2017 23:51:37 +0800
Message-ID: <1508860309-212397-8-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

This patch adds a NULL check of task->lldd_task before
freeing the slot in SMP path.

This is to guard against the scenario of the slot being
freed during the from the preceding internal abort.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 88d90dc..2a209e1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1161,7 +1161,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 		rc = hisi_sas_internal_task_abort(hisi_hba, device,
 			     HISI_SAS_INT_ABT_CMD, tag);
-		if (rc == TMF_RESP_FUNC_FAILED) {
+		if (rc == TMF_RESP_FUNC_FAILED && task->lldd_task) {
 			spin_lock_irqsave(&hisi_hba->lock, flags);
 			hisi_sas_do_release_task(hisi_hba, task, slot);
 			spin_unlock_irqrestore(&hisi_hba->lock, flags);
-- 
1.9.1
