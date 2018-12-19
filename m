From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/8] scsi: hisi_sas: Add debugfs DQ file and add file operations
Date: Wed, 19 Dec 2018 23:56:45 +0800
Message-ID: <1545235006-151716-8-git-send-email-john.garry@huawei.com>
References: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

This patch create debugfs file for DQ and add file operations

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 52 +++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index ce0a9dc..45a0be2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2685,6 +2685,43 @@ static int hisi_sas_debugfs_cq_open(struct inode *inode, struct file *filp)
 	.owner = THIS_MODULE,
 };
 
+static int hisi_sas_dq_show_slot(struct seq_file *s, int slot, void *dq_ptr)
+{
+	struct hisi_sas_dq *dq = dq_ptr;
+	struct hisi_hba *hisi_hba = dq->hisi_hba;
+	void *cmd_queue = hisi_hba->debugfs_cmd_hdr[dq->id];
+	void *cmd_hdr = cmd_queue +
+		hisi_hba->hw->complete_hdr_size * slot;
+
+	return hisi_sas_show_row_32(s, slot, sizeof(struct hisi_sas_cmd_hdr),
+				    cmd_hdr);
+}
+
+static int hisi_sas_debugfs_dq_show(struct seq_file *s, void *p)
+{
+	int slot, ret;
+
+	for (slot = 0; slot < HISI_SAS_QUEUE_SLOTS; slot++) {
+		ret = hisi_sas_dq_show_slot(s, slot, s->private);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int hisi_sas_debugfs_dq_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_dq_show, inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_dq_fops = {
+	.open = hisi_sas_debugfs_dq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 {
 	struct dentry *dump_dentry;
@@ -2692,6 +2729,7 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	char name[256];
 	int p;
 	int c;
+	int d;
 
 	/* Create dump dir inside device dir */
 	dump_dentry = debugfs_create_dir("dump", hisi_hba->debugfs_dir);
@@ -2731,6 +2769,20 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 			goto fail;
 	}
 
+	/* Create DQ dir and files */
+	dentry = debugfs_create_dir("dq", dump_dentry);
+	if (!dentry)
+		goto fail;
+
+	for (d = 0; d < hisi_hba->queue_count; d++) {
+		snprintf(name, 256, "%d", d);
+
+		if (!debugfs_create_file(name, 0400, dentry,
+					 &hisi_hba->dq[d],
+					 &hisi_sas_debugfs_dq_fops))
+			goto fail;
+	}
+
 	return;
 fail:
 	debugfs_remove_recursive(hisi_hba->debugfs_dir);
-- 
1.9.1
