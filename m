From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/7] scsi: hisi_sas: Move evaluation of hisi_hba in hisi_sas_task_prep()
Date: Mon, 24 Sep 2018 23:06:29 +0800
Message-ID: <1537801594-207139-3-git-send-email-john.garry@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

In evaluating hisi_hba, the sas_port may be NULL, so for safety relocate
the the check to value possible NULL deference.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index ba6fb535..3b95a7a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -287,13 +287,13 @@ static int hisi_sas_task_prep(struct sas_task *task,
 			      int *pass)
 {
 	struct domain_device *device = task->dev;
-	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct hisi_hba *hisi_hba;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_port *port;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
 	struct asd_sas_port *sas_port = device->port;
-	struct device *dev = hisi_hba->dev;
+	struct device *dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
 	int n_elem = 0, n_elem_req = 0, n_elem_resp = 0;
 	struct hisi_sas_dq *dq;
@@ -314,6 +314,9 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		return -ECOMM;
 	}
 
+	hisi_hba = dev_to_hisi_hba(device);
+	dev = hisi_hba->dev;
+
 	if (DEV_IS_GONE(sas_dev)) {
 		if (sas_dev)
 			dev_info(dev, "task prep: device %d not ready\n",
-- 
1.9.1
