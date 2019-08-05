From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/15] scsi: hisi_sas: Fix pointer usage error in show debugfs IOST/ITCT
Date: Mon, 5 Aug 2019 21:48:00 +0800
Message-ID: <1565012892-75940-4-git-send-email-john.garry@huawei.com>
References: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Fix how the pointer is set in hisi_sas_debugfs_iost_show() and
hisi_sas_debugfs_itct_show().

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 54bbab7151c7..325ec4306794 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2992,9 +2992,10 @@ static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
 	struct hisi_hba *hisi_hba = s->private;
 	struct hisi_sas_iost *debugfs_iost = hisi_hba->debugfs_iost;
 	int i, ret, max_command_entries = HISI_SAS_MAX_COMMANDS;
-	__le64 *iost = &debugfs_iost->qw0;
 
 	for (i = 0; i < max_command_entries; i++, debugfs_iost++) {
+		__le64 *iost = &debugfs_iost->qw0;
+
 		ret = hisi_sas_show_row_64(s, i, sizeof(*debugfs_iost),
 					   iost);
 		if (ret)
@@ -3022,9 +3023,10 @@ static int hisi_sas_debugfs_itct_show(struct seq_file *s, void *p)
 	int i, ret;
 	struct hisi_hba *hisi_hba = s->private;
 	struct hisi_sas_itct *debugfs_itct = hisi_hba->debugfs_itct;
-	__le64 *itct = &debugfs_itct->qw0;
 
 	for (i = 0; i < HISI_SAS_MAX_ITCT_ENTRIES; i++, debugfs_itct++) {
+		__le64 *itct = &debugfs_itct->qw0;
+
 		ret = hisi_sas_show_row_64(s, i, sizeof(*debugfs_itct),
 					   itct);
 		if (ret)
-- 
2.17.1
