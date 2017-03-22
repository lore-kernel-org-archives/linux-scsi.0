From: John Garry <john.garry@huawei.com>
Subject: [PATCH 01/23] scsi: hisi_sas: add to_hisi_sas_port()
Date: Thu, 23 Mar 2017 01:25:17 +0800
Message-ID: <1490203539-228029-2-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Introduce function to get hisi_sas_port from
asd_sas_port.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 17 +++++++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 +++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 ++++--
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9216dea..a018a8a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -346,6 +346,8 @@ struct hisi_sas_command_table_ssp {
 	struct hisi_sas_command_table_smp smp;
 	struct hisi_sas_command_table_stp stp;
 };
+
+extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 53637a9..11f32d2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -27,6 +27,12 @@ static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 	return device->port->ha->lldd_ha;
 }
 
+struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port)
+{
+	return container_of(sas_port, struct hisi_sas_port, sas_port);
+}
+EXPORT_SYMBOL_GPL(to_hisi_sas_port);
+
 static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	void *bitmap = hisi_hba->slot_index_tags;
@@ -178,10 +184,11 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	struct hisi_sas_port *port;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
+	struct asd_sas_port *sas_port = device->port;
 	struct device *dev = &hisi_hba->pdev->dev;
 	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
 
-	if (!device->port) {
+	if (!sas_port) {
 		struct task_status_struct *ts = &task->task_status;
 
 		ts->resp = SAS_TASK_UNDELIVERED;
@@ -206,7 +213,8 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 		rc = SAS_PHY_DOWN;
 		return rc;
 	}
-	port = device->port->lldd_port;
+
+	port = to_hisi_sas_port(sas_port);
 	if (port && !port->port_attached) {
 		dev_info(dev, "task prep: %s port%d not attach device\n",
 			 (sas_protocol_ata(task->task_proto)) ?
@@ -545,7 +553,7 @@ static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
 	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
 	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
 	struct asd_sas_port *sas_port = sas_phy->port;
-	struct hisi_sas_port *port = &hisi_hba->port[phy->port_id];
+	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 	unsigned long flags;
 
 	if (!sas_port)
@@ -990,13 +998,14 @@ static int hisi_sas_query_task(struct sas_task *task)
 	struct device *dev = &hisi_hba->pdev->dev;
 	struct hisi_sas_port *port;
 	struct hisi_sas_slot *slot;
+	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_cmd_hdr *cmd_hdr_base;
 	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
 
 	if (!device->port)
 		return -1;
 
-	port = device->port->lldd_port;
+	port = to_hisi_sas_port(sas_port);
 
 	/* simply get a slot and send abort command */
 	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 854fbea..022ad10 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -508,6 +508,8 @@ static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 	struct device *dev = &hisi_hba->pdev->dev;
 	u64 qw0, device_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[device_id];
+	struct asd_sas_port *sas_port = device->port;
+	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 
 	memset(itct, 0, sizeof(*itct));
 
@@ -528,7 +530,7 @@ static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 		(1 << ITCT_HDR_AWT_CONTROL_OFF) |
 		(device->max_linkrate << ITCT_HDR_MAX_CONN_RATE_OFF) |
 		(1 << ITCT_HDR_VALID_LINK_NUM_OFF) |
-		(device->port->id << ITCT_HDR_PORT_ID_OFF));
+		(port->id << ITCT_HDR_PORT_ID_OFF));
 	itct->qw0 = cpu_to_le64(qw0);
 
 	/* qw1 */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 1b21445..1590e2f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -676,7 +676,8 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 	u64 qw0, device_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[device_id];
 	struct domain_device *parent_dev = device->parent;
-	struct hisi_sas_port *port = device->port->lldd_port;
+	struct asd_sas_port *sas_port = device->port;
+	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 
 	memset(itct, 0, sizeof(*itct));
 
@@ -1920,7 +1921,8 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	struct domain_device *parent_dev = device->parent;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
-	struct hisi_sas_port *port = device->port->lldd_port;
+	struct asd_sas_port *sas_port = device->port;
+	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 	u8 *buf_cmd;
 	int has_data = 0, rc = 0, hdr_tag = 0;
 	u32 dw1 = 0, dw2 = 0;
-- 
1.9.1
