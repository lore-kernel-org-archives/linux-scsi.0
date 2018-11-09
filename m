From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/5] scsi: hisi_sas: Relocate some codes to avoid an unused check
Date: Fri, 9 Nov 2018 22:06:35 +0800
Message-ID: <1541772396-161814-5-git-send-email-john.garry@huawei.com>
References: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

In function hisi_sas_task_prep(), we check asd_sas_port, but in function
hisi_sas_task_exec(), we already refer to asd_sas_port by using function
dev_to_hisi_hba() implicitly. So to avoid this possible invalid
dereference, relocate the check to function hisi_sas_task_prep().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 44 ++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8633ff9..65dc749 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -302,36 +302,19 @@ static int hisi_sas_task_prep(struct sas_task *task,
 			      int *pass)
 {
 	struct domain_device *device = task->dev;
-	struct hisi_hba *hisi_hba;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_port *port;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
 	struct asd_sas_port *sas_port = device->port;
-	struct device *dev;
+	struct device *dev = hisi_hba->dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
 	int n_elem = 0, n_elem_req = 0, n_elem_resp = 0;
 	struct hisi_sas_dq *dq;
 	unsigned long flags;
 	int wr_q_index;
 
-	if (!sas_port) {
-		struct task_status_struct *ts = &task->task_status;
-
-		ts->resp = SAS_TASK_UNDELIVERED;
-		ts->stat = SAS_PHY_DOWN;
-		/*
-		 * libsas will use dev->port, should
-		 * not call task_done for sata
-		 */
-		if (device->dev_type != SAS_SATA_DEV)
-			task->task_done(task);
-		return -ECOMM;
-	}
-
-	hisi_hba = dev_to_hisi_hba(device);
-	dev = hisi_hba->dev;
-
 	if (DEV_IS_GONE(sas_dev)) {
 		if (sas_dev)
 			dev_info(dev, "task prep: device %d not ready\n",
@@ -506,10 +489,29 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	u32 rc;
 	u32 pass = 0;
 	unsigned long flags;
-	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
-	struct device *dev = hisi_hba->dev;
+	struct hisi_hba *hisi_hba;
+	struct device *dev;
+	struct domain_device *device = task->dev;
+	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_dq *dq = NULL;
 
+	if (!sas_port) {
+		struct task_status_struct *ts = &task->task_status;
+
+		ts->resp = SAS_TASK_UNDELIVERED;
+		ts->stat = SAS_PHY_DOWN;
+		/*
+		 * libsas will use dev->port, should
+		 * not call task_done for sata
+		 */
+		if (device->dev_type != SAS_SATA_DEV)
+			task->task_done(task);
+		return -ECOMM;
+	}
+
+	hisi_hba = dev_to_hisi_hba(device);
+	dev = hisi_hba->dev;
+
 	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags))) {
 		if (in_softirq())
 			return -EINVAL;
-- 
1.9.1
