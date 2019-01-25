From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/13] scsi: hisi_sas: Remove unused parameter of function hisi_sas_alloc()
Date: Fri, 25 Jan 2019 22:22:33 +0800
Message-ID: <1548426159-225679-8-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Actually in function hisi_sas_alloc(), parameter shost is not used, so
remove it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index aac8b38..235b819 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -497,7 +497,7 @@ struct hisi_sas_slot_buf_table {
 extern struct dentry *hisi_sas_debugfs_dir;
 
 extern void hisi_sas_stop_phys(struct hisi_hba *hisi_hba);
-extern int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost);
+extern int hisi_sas_alloc(struct hisi_hba *hisi_hba);
 extern void hisi_sas_free(struct hisi_hba *hisi_hba);
 extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
 				int direction);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b57a44b..8f7f82d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2074,7 +2074,7 @@ void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_init_mem);
 
-int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
+int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
 	int i, j, s, max_command_entries = hisi_hba->hw->max_command_entries;
@@ -2358,7 +2358,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 			goto err_out;
 	}
 
-	if (hisi_sas_alloc(hisi_hba, shost)) {
+	if (hisi_sas_alloc(hisi_hba)) {
 		hisi_sas_free(hisi_hba);
 		goto err_out;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d5eabfc..4b628c2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2591,7 +2591,7 @@ static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
 	if (hisi_sas_get_fw_info(hisi_hba) < 0)
 		goto err_out;
 
-	if (hisi_sas_alloc(hisi_hba, shost)) {
+	if (hisi_sas_alloc(hisi_hba)) {
 		hisi_sas_free(hisi_hba);
 		goto err_out;
 	}
-- 
1.9.1
