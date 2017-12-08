From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/19] scsi: hisi_sas: fix dma_unmap_sg() parameter
Date: Sat, 9 Dec 2017 01:16:33 +0800
Message-ID: <1512753410-50924-3-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For function dma_unmap_sg(), the <nents> parameter
should be number of elements in the scatterlist
prior to the mapping, not after the mapping.

Fix this usage.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 359ec52..d842530 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -192,7 +192,8 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 
 		if (!sas_protocol_ata(task->task_proto))
 			if (slot->n_elem)
-				dma_unmap_sg(dev, task->scatter, slot->n_elem,
+				dma_unmap_sg(dev, task->scatter,
+					     task->num_scatter,
 					     task->data_dir);
 
 		if (sas_dev)
@@ -431,7 +432,8 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 	dev_err(dev, "task prep: failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(dev, task->scatter, n_elem,
+			dma_unmap_sg(dev, task->scatter,
+				     task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
-- 
1.9.1
