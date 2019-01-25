From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/13] scsi: hisi_sas: Correct memory allocation size for DQ debugfs
Date: Fri, 25 Jan 2019 22:22:36 +0800
Message-ID: <1548426159-225679-11-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Some sizes we allocate for debugfs structure is incorrect, so fix them.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0a817e9..89f1bc5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2502,7 +2502,7 @@ static void hisi_sas_debugfs_snapshot_cq_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_dq_reg(struct hisi_hba *hisi_hba)
 {
-	int queue_entry_size = hisi_hba->hw->complete_hdr_size;
+	int queue_entry_size = sizeof(struct hisi_sas_cmd_hdr);
 	int i;
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
@@ -2945,7 +2945,7 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 	}
 
 	/* Alloc buffer for dq */
-	sz = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
+	sz = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
 	for (d = 0; d < hisi_hba->queue_count; d++) {
 		hisi_hba->debugfs_cmd_hdr[d] =
 			devm_kmalloc(dev, sz, GFP_KERNEL);
-- 
1.9.1
