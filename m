From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] hisi_sas: fix error codes in hisi_sas_task_prep()
Date: Wed, 9 Dec 2015 13:48:36 +0300
Message-ID: <20151209104836.GK3173@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There were a couple cases where the error codes weren't set and also I
changed the success return to "return 0;" which is the same as
"return rc;" but more explicit.

Fixes: 42e7a69368a5 ('hisi_sas: Add ssp command functio')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2929018..99b1950 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -208,15 +208,19 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	slot->status_buffer = dma_pool_alloc(hisi_hba->status_buffer_pool,
 					     GFP_ATOMIC,
 					     &slot->status_buffer_dma);
-	if (!slot->status_buffer)
+	if (!slot->status_buffer) {
+		rc = -ENOMEM;
 		goto err_out_slot_buf;
+	}
 	memset(slot->status_buffer, 0, HISI_SAS_STATUS_BUF_SZ);
 
 	slot->command_table = dma_pool_alloc(hisi_hba->command_table_pool,
 					     GFP_ATOMIC,
 					     &slot->command_table_dma);
-	if (!slot->command_table)
+	if (!slot->command_table) {
+		rc = -ENOMEM;
 		goto err_out_status_buf;
+	}
 	memset(slot->command_table, 0, HISI_SAS_COMMAND_TABLE_SZ);
 	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
 
@@ -254,7 +258,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	sas_dev->running_req++;
 	++(*pass);
 
-	return rc;
+	return 0;
 
 err_out_sge:
 	dma_pool_free(hisi_hba->sge_page_pool, slot->sge_page,
