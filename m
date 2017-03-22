From: John Garry <john.garry@huawei.com>
Subject: [PATCH 14/23] scsi: hisi_sas: remove task free'ing for timeouts
Date: Thu, 23 Mar 2017 01:25:30 +0800
Message-ID: <1490203539-228029-15-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4389 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751324AbdCVRIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 13:08:47 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

When a TMF or internal abort times-out, do not free
slot. We expect this to be done upon later escalated
error handling.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f9ea5cc..3d63a24 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -743,14 +743,6 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				dev_err(dev, "abort tmf: TMF task timeout\n");
-				if (task->lldd_task) {
-					struct hisi_sas_slot *slot =
-						task->lldd_task;
-
-					hisi_sas_slot_task_free(hisi_hba,
-								task, slot);
-				}
-
 				goto ex_err;
 			}
 		}
@@ -1248,15 +1240,10 @@ static int hisi_sas_query_task(struct sas_task *task)
 		goto exit;
 	}
 
-	/* TMF timed out, return direct. */
+	/* Internal abort timed out */
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 			dev_err(dev, "internal task abort: timeout.\n");
-			if (task->lldd_task) {
-				struct hisi_sas_slot *slot = task->lldd_task;
-
-				hisi_sas_slot_task_free(hisi_hba, task, slot);
-			}
 		}
 	}
 
-- 
1.9.1
