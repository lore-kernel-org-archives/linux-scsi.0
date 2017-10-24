From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/19] scsi: hisi_sas: fix the risk of freeing slot twice
Date: Tue, 24 Oct 2017 23:51:38 +0800
Message-ID: <1508860309-212397-9-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:50508 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751398AbdJXPF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Oct 2017 11:05:28 -0400
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiaofei Tan <tanxiaofei@huawei.com>

The function hisi_sas_slot_task_free() is used to free
the slot and do tidy-up of LLDD resources. The LLDD
generally should know the state of a slot and decide when
to free it, and it should only be done once.

For some scenarios, we really don't know the state, like
when TMF timeout. In this case, we check task->lldd_task
before calling hisi_sas_slot_task_free().

However, we may miss some scenarios when we should also
check task->lldd_task, and it is not SMP safe to check
task->lldd_task as we don't protect it within spin lock.

This patch is to fix this risk of freeing slot twice, as
follows:
1. Check task->lldd_task in the hisi_sas_slot_task_free(),
and give up freeing of this time if task->lldd_task is NULL.
2. Set slot->buf to NULL after it is freed.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2a209e1..6b4dabde 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -185,13 +185,16 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 		struct domain_device *device = task->dev;
 		struct hisi_sas_device *sas_dev = device->lldd_dev;
 
+		if (!task->lldd_task)
+			return;
+
+		task->lldd_task = NULL;
+
 		if (!sas_protocol_ata(task->task_proto))
 			if (slot->n_elem)
 				dma_unmap_sg(dev, task->scatter, slot->n_elem,
 					     task->data_dir);
 
-		task->lldd_task = NULL;
-
 		if (sas_dev)
 			atomic64_dec(&sas_dev->running_req);
 	}
@@ -199,8 +202,8 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 	if (slot->buf)
 		dma_pool_free(hisi_hba->buffer_pool, slot->buf, slot->buf_dma);
 
-
 	list_del_init(&slot->entry);
+	slot->buf = NULL;
 	slot->task = NULL;
 	slot->port = NULL;
 	hisi_sas_slot_index_free(hisi_hba, slot->idx);
-- 
1.9.1
