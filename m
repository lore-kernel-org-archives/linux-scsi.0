From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/13] scsi: hisi_sas: Add debugfs ITCT file and add file operations
Date: Fri, 25 Jan 2019 22:22:29 +0800
Message-ID: <1548426159-225679-4-git-send-email-john.garry@huawei.com>
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

This patch create debugfs file for ITCT and add file operations.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 73a545a..c0aacb0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2773,6 +2773,36 @@ static int hisi_sas_debugfs_iost_open(struct inode *inode, struct file *filp)
 	.owner = THIS_MODULE,
 };
 
+static int hisi_sas_debugfs_itct_show(struct seq_file *s, void *p)
+{
+	int i, ret;
+	struct hisi_hba *hisi_hba = s->private;
+	struct hisi_sas_itct *debugfs_itct = hisi_hba->debugfs_itct;
+	__le64 *itct = &debugfs_itct->qw0;
+
+	for (i = 0; i < HISI_SAS_MAX_ITCT_ENTRIES; i++, debugfs_itct++) {
+		ret = hisi_sas_show_row_64(s, i, sizeof(*debugfs_itct),
+					   itct);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_itct_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_itct_show, inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_itct_fops = {
+	.open = hisi_sas_debugfs_itct_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 {
 	struct dentry *dump_dentry;
@@ -2819,6 +2849,9 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	debugfs_create_file("iost", 0400, dump_dentry, hisi_hba,
 			    &hisi_sas_debugfs_iost_fops);
 
+	debugfs_create_file("itct", 0400, dump_dentry, hisi_hba,
+			    &hisi_sas_debugfs_itct_fops);
+
 	return;
 }
 
-- 
1.9.1
