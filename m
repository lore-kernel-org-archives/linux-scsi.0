From: John Garry <john.garry@huawei.com>
Subject: [PATCH 8/8] scsi: hisi_sas: Add debugfs IOST file and add file operations
Date: Wed, 19 Dec 2018 23:56:46 +0800
Message-ID: <1545235006-151716-9-git-send-email-john.garry@huawei.com>
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

This patch create debugfs file for IOST and add file operations.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 51 +++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 45a0be2..3d24366 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2630,6 +2630,24 @@ static int hisi_sas_debugfs_port_open(struct inode *inode, struct file *filp)
 	.owner = THIS_MODULE,
 };
 
+static int hisi_sas_show_row_64(struct seq_file *s, int index,
+				int sz, u64 *ptr)
+{
+	int i;
+
+	/* completion header size not fixed per HW version */
+	seq_printf(s, "index %04d:\n\t", index);
+	for (i = 1; i <= sz / 8; i++, ptr++) {
+		seq_printf(s, " 0x%016llx", le64_to_cpu(*ptr));
+		if (!(i % 2))
+			seq_puts(s, "\n\t");
+	}
+
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
 static int hisi_sas_show_row_32(struct seq_file *s, int index,
 				int sz, u32 *ptr)
 {
@@ -2722,6 +2740,35 @@ static int hisi_sas_debugfs_dq_open(struct inode *inode, struct file *filp)
 	.owner = THIS_MODULE,
 };
 
+static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+	struct hisi_sas_iost *debugfs_iost = hisi_hba->debugfs_iost;
+	int i, ret, max_command_entries = hisi_hba->hw->max_command_entries;
+
+	for (i = 0; i < max_command_entries; i++, debugfs_iost++) {
+		ret = hisi_sas_show_row_64(s, i, sizeof(*debugfs_iost),
+					   (u64 *)debugfs_iost);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_iost_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_iost_show, inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_iost_fops = {
+	.open = hisi_sas_debugfs_iost_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 {
 	struct dentry *dump_dentry;
@@ -2783,6 +2830,10 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 			goto fail;
 	}
 
+	if (!debugfs_create_file("iost", 0400, dump_dentry, hisi_hba,
+				 &hisi_sas_debugfs_iost_fops))
+		goto fail;
+
 	return;
 fail:
 	debugfs_remove_recursive(hisi_hba->debugfs_dir);
-- 
1.9.1
