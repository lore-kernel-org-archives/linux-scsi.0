From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/13] scsi: hisi_sas: Fix type casting and missing static qualifier in debugfs code
Date: Fri, 25 Jan 2019 22:22:28 +0800
Message-ID: <1548426159-225679-3-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Sparse can detect some type casting issues in the debugfs code, so
fix it up.

Also a missing static qualifier is added to hisi_sas_debugfs_to_reg_name().

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c | 21 +++++++++++----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index b8b1ded..5bb6759 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -359,8 +359,8 @@ struct hisi_hba {
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
 
 	/* debugfs memories */
-	void *debugfs_global_reg;
-	void *debugfs_port_reg[HISI_SAS_MAX_PHYS];
+	u32 *debugfs_global_reg;
+	u32 *debugfs_port_reg[HISI_SAS_MAX_PHYS];
 	void *debugfs_complete_hdr[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_cmd_hdr	*debugfs_cmd_hdr[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_iost *debugfs_iost;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 72d2295..73a545a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2547,7 +2547,7 @@ static void hisi_sas_debugfs_snapshot_iost_reg(struct hisi_hba *hisi_hba)
 	}
 }
 
-const char *
+static const char *
 hisi_sas_debugfs_to_reg_name(int off, int base_off,
 			     const struct hisi_sas_debugfs_reg_lu *lu)
 {
@@ -2574,10 +2574,10 @@ static void hisi_sas_debugfs_print_reg(u32 *regs_val, const void *ptr,
 
 		if (name)
 			seq_printf(s, "0x%08x 0x%08x %s\n", off,
-				   le32_to_cpu(regs_val[i]), name);
+				   regs_val[i], name);
 		else
 			seq_printf(s, "0x%08x 0x%08x\n", off,
-				   le32_to_cpu(regs_val[i]));
+				   regs_val[i]);
 	}
 }
 
@@ -2587,7 +2587,7 @@ static int hisi_sas_debugfs_global_show(struct seq_file *s, void *p)
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *reg_global = hw->debugfs_reg_global;
 
-	hisi_sas_debugfs_print_reg((u32 *)hisi_hba->debugfs_global_reg,
+	hisi_sas_debugfs_print_reg(hisi_hba->debugfs_global_reg,
 				   reg_global, s);
 
 	return 0;
@@ -2634,7 +2634,7 @@ static int hisi_sas_debugfs_port_open(struct inode *inode, struct file *filp)
 };
 
 static int hisi_sas_show_row_64(struct seq_file *s, int index,
-				int sz, u64 *ptr)
+				int sz, __le64 *ptr)
 {
 	int i;
 
@@ -2652,7 +2652,7 @@ static int hisi_sas_show_row_64(struct seq_file *s, int index,
 }
 
 static int hisi_sas_show_row_32(struct seq_file *s, int index,
-				int sz, u32 *ptr)
+				int sz, __le32 *ptr)
 {
 	int i;
 
@@ -2672,7 +2672,7 @@ static int hisi_sas_cq_show_slot(struct seq_file *s, int slot, void *cq_ptr)
 	struct hisi_sas_cq *cq = cq_ptr;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	void *complete_queue = hisi_hba->debugfs_complete_hdr[cq->id];
-	void *complete_hdr = complete_queue +
+	__le32 *complete_hdr = complete_queue +
 			(hisi_hba->hw->complete_hdr_size * slot);
 
 	return hisi_sas_show_row_32(s, slot,
@@ -2711,8 +2711,8 @@ static int hisi_sas_dq_show_slot(struct seq_file *s, int slot, void *dq_ptr)
 	struct hisi_sas_dq *dq = dq_ptr;
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
 	void *cmd_queue = hisi_hba->debugfs_cmd_hdr[dq->id];
-	void *cmd_hdr = cmd_queue +
-		hisi_hba->hw->complete_hdr_size * slot;
+	__le32 *cmd_hdr = cmd_queue +
+		sizeof(struct hisi_sas_cmd_hdr) * slot;
 
 	return hisi_sas_show_row_32(s, slot, sizeof(struct hisi_sas_cmd_hdr),
 				    cmd_hdr);
@@ -2748,10 +2748,11 @@ static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
 	struct hisi_hba *hisi_hba = s->private;
 	struct hisi_sas_iost *debugfs_iost = hisi_hba->debugfs_iost;
 	int i, ret, max_command_entries = hisi_hba->hw->max_command_entries;
+	__le64 *iost = &debugfs_iost->qw0;
 
 	for (i = 0; i < max_command_entries; i++, debugfs_iost++) {
 		ret = hisi_sas_show_row_64(s, i, sizeof(*debugfs_iost),
-					   (u64 *)debugfs_iost);
+					   iost);
 		if (ret)
 			return ret;
 	}
-- 
1.9.1
