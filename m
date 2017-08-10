From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/19] scsi: hisi_sas: add status and command buffer for internal abort
Date: Fri, 11 Aug 2017 00:09:35 +0800
Message-ID: <1502381384-219889-11-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For v3 hw, internal abort function required status and command buffer
to be set, so add necessary code for this.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 86868ec..7e642c8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1363,12 +1363,21 @@ static int hisi_sas_query_task(struct sas_task *task)
 	slot->port = port;
 	task->lldd_task = slot;
 
+	slot->buf = dma_pool_alloc(hisi_hba->buffer_pool,
+			GFP_ATOMIC, &slot->buf_dma);
+	if (!slot->buf) {
+		rc = -ENOMEM;
+		goto err_out_tag;
+	}
+
 	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
+	memset(hisi_sas_cmd_hdr_addr_mem(slot), 0, HISI_SAS_COMMAND_TABLE_SZ);
+	memset(hisi_sas_status_buf_addr_mem(slot), 0, HISI_SAS_STATUS_BUF_SZ);
 
 	rc = hisi_sas_task_prep_abort(hisi_hba, slot, device_id,
 				      abort_flag, task_tag);
 	if (rc)
-		goto err_out_tag;
+		goto err_out_buf;
 
 
 	list_add_tail(&slot->entry, &sas_dev->list);
@@ -1386,6 +1395,9 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 	return 0;
 
+err_out_buf:
+	dma_pool_free(hisi_hba->buffer_pool, slot->buf,
+		slot->buf_dma);
 err_out_tag:
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	hisi_sas_slot_index_free(hisi_hba, slot_idx);
-- 
1.9.1
