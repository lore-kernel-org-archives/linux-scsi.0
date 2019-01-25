From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/13] scsi: hisi_sas: Some misc tidy-up
Date: Fri, 25 Jan 2019 22:22:37 +0800
Message-ID: <1548426159-225679-12-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Sparse detected some problems in the driver, so tidy them up.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 89f1bc5..e48b627 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2075,14 +2075,18 @@ void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
 
 void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
 {
-	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
+	int i, s, j, max_command_entries = hisi_hba->hw->max_command_entries;
+	struct hisi_sas_breakpoint *sata_breakpoint = hisi_hba->sata_breakpoint;
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 		struct hisi_sas_dq *dq = &hisi_hba->dq[i];
+		struct hisi_sas_cmd_hdr *cmd_hdr = hisi_hba->cmd_hdr[i];
+
+		s = sizeof(struct hisi_sas_cmd_hdr);
+		for (j = 0; j < HISI_SAS_QUEUE_SLOTS; j++)
+			memset(&cmd_hdr[j], 0, s);
 
-		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
-		memset(hisi_hba->cmd_hdr[i], 0, s);
 		dq->wr_point = 0;
 
 		s = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
@@ -2099,8 +2103,9 @@ void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
 	s = max_command_entries * sizeof(struct hisi_sas_breakpoint);
 	memset(hisi_hba->breakpoint, 0, s);
 
-	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_sata_breakpoint);
-	memset(hisi_hba->sata_breakpoint, 0, s);
+	s = sizeof(struct hisi_sas_sata_breakpoint);
+	for (j = 0; j < HISI_SAS_MAX_ITCT_ENTRIES; j++)
+		memset(&sata_breakpoint[j], 0, s);
 }
 EXPORT_SYMBOL_GPL(hisi_sas_init_mem);
 
@@ -2157,10 +2162,9 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 
 	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
 	hisi_hba->itct = dmam_alloc_coherent(dev, s, &hisi_hba->itct_dma,
-					     GFP_KERNEL);
+					     GFP_KERNEL | __GFP_ZERO);
 	if (!hisi_hba->itct)
 		goto err_out;
-	memset(hisi_hba->itct, 0, s);
 
 	hisi_hba->slot_info = devm_kcalloc(dev, max_command_entries,
 					   sizeof(struct hisi_sas_slot),
@@ -2505,10 +2509,17 @@ static void hisi_sas_debugfs_snapshot_dq_reg(struct hisi_hba *hisi_hba)
 	int queue_entry_size = sizeof(struct hisi_sas_cmd_hdr);
 	int i;
 
-	for (i = 0; i < hisi_hba->queue_count; i++)
-		memcpy(hisi_hba->debugfs_cmd_hdr[i],
-		       hisi_hba->cmd_hdr[i],
-		       HISI_SAS_QUEUE_SLOTS * queue_entry_size);
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cmd_hdr	*debugfs_cmd_hdr, *cmd_hdr;
+		int j;
+
+		debugfs_cmd_hdr = hisi_hba->debugfs_cmd_hdr[i];
+		cmd_hdr = hisi_hba->cmd_hdr[i];
+
+		for (j = 0; j < HISI_SAS_QUEUE_SLOTS; j++)
+			memcpy(&debugfs_cmd_hdr[j], &cmd_hdr[j],
+			       queue_entry_size);
+	}
 }
 
 static void hisi_sas_debugfs_snapshot_port_reg(struct hisi_hba *hisi_hba)
-- 
1.9.1
