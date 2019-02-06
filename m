From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/6] scsi: hisi_sas: Add manual trigger for debugfs dump
Date: Wed, 6 Feb 2019 18:52:52 +0800
Message-ID: <1549450376-114929-3-git-send-email-john.garry@huawei.com>
References: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Add an interface to manually trigger a debugfs dump.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 34 +++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1a3d31d4258c..35619bdad1d5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2977,6 +2977,36 @@ static void hisi_sas_debugfs_snapshot_regs(struct hisi_hba *hisi_hba)
 	hisi_hba->hw->snapshot_restore(hisi_hba);
 }
 
+static ssize_t hisi_sas_debugfs_trigger_dump_write(struct file *file,
+						   const char __user *user_buf,
+						   size_t count, loff_t *ppos)
+{
+	struct hisi_hba *hisi_hba = file->f_inode->i_private;
+	char buf[8];
+
+	/* A bit racy, but don't care too much since it's only debugfs */
+	if (hisi_hba->debugfs_snapshot)
+		return -EFAULT;
+
+	if (count > 8)
+		return -EFAULT;
+
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+
+	if (buf[0] != '1')
+		return -EFAULT;
+
+	queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+
+	return count;
+}
+
+static const struct file_operations hisi_sas_debugfs_trigger_dump_fops = {
+	.write = &hisi_sas_debugfs_trigger_dump_write,
+	.owner = THIS_MODULE,
+};
+
 void hisi_sas_debugfs_work_handler(struct work_struct *work)
 {
 	struct hisi_hba *hisi_hba =
@@ -2999,6 +3029,10 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 
 	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
 						   hisi_sas_debugfs_dir);
+	debugfs_create_file("trigger_dump", 0600,
+			    hisi_hba->debugfs_dir,
+			    hisi_hba,
+			    &hisi_sas_debugfs_trigger_dump_fops);
 
 	/* Alloc buffer for global */
 	sz = hisi_hba->hw->debugfs_reg_global->count * 4;
-- 
2.17.1
