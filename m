From: John Garry <john.garry@huawei.com>
Subject: [PATCH 05/23] scsi: hisi_sas: remove hisi_sas_port_deformed()
Date: Thu, 23 Mar 2017 01:25:21 +0800
Message-ID: <1490203539-228029-6-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4371 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760812AbdCVQ6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:20 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

Currently when a root PHY is deformed from a asd_sas_port
we try to release the slots in the LLDD, and fail.

Regardless, it is not right to release this early.

This patch removes the deformed function. As it was
before, port deformation is still done in
hisi_sas_phy_down().

It would be nice to actually remove the
hisi_sas_port_{de}formed() pair, however we cannot as
we need to know the asd_sas_port index libsas has
associated with an asd_sas_phy.

The hw does actually generate a port id for a PHY, but
this seems to a random number, so ignored for this
purpose.

This patch also changes the code to link slots to the
hisi_sas_device, and not hisi_sas_port.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 85 ++++++++++++++--------------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  9 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 13 +++---
 4 files changed, 46 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2135de9..6aa0b62 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -91,7 +91,6 @@ struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
 	u8	port_attached;
 	u8	id; /* from hw */
-	struct list_head	list;
 };
 
 struct hisi_sas_cq {
@@ -114,6 +113,7 @@ struct hisi_sas_device {
 	u64 attached_phy;
 	u64 device_id;
 	atomic64_t running_req;
+	struct list_head	list;
 	u8 dev_status;
 };
 
@@ -166,7 +166,7 @@ struct hisi_sas_hw {
 			  struct hisi_sas_slot *slot,
 			  int device_id, int abort_flag, int tag_to_abort);
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
-			     struct hisi_sas_slot *slot, int abort);
+			     struct hisi_sas_slot *slot);
 	void (*phys_init)(struct hisi_hba *hisi_hba);
 	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9d9f305..f64c1b6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -308,7 +308,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 		goto err_out_command_table;
 	}
 
-	list_add_tail(&slot->entry, &port->list);
+	list_add_tail(&slot->entry, &sas_dev->list);
 	spin_lock(&task->task_state_lock);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock(&task->task_state_lock);
@@ -424,6 +424,7 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 			sas_dev->dev_type = device->dev_type;
 			sas_dev->hisi_hba = hisi_hba;
 			sas_dev->sas_device = device;
+			INIT_LIST_HEAD(&hisi_hba->devices[i].list);
 			break;
 		}
 	}
@@ -568,63 +569,55 @@ static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
 	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 }
 
-static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba, int phy_no,
-				     struct domain_device *device)
+static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba,
+				     struct sas_task *task,
+				     struct hisi_sas_slot *slot)
 {
-	struct hisi_sas_phy *phy;
-	struct hisi_sas_port *port;
-	struct hisi_sas_slot *slot, *slot2;
-	struct device *dev = &hisi_hba->pdev->dev;
+	struct task_status_struct *ts;
+	unsigned long flags;
 
-	phy = &hisi_hba->phy[phy_no];
-	port = phy->port;
-	if (!port)
+	if (!task)
 		return;
 
-	list_for_each_entry_safe(slot, slot2, &port->list, entry) {
-		struct sas_task *task;
-
-		task = slot->task;
-		if (device && task->dev != device)
-			continue;
-
-		dev_info(dev, "Release slot [%d:%d], task [%p]:\n",
-			 slot->dlvry_queue, slot->dlvry_queue_slot, task);
-		hisi_hba->hw->slot_complete(hisi_hba, slot, 1);
-	}
-}
+	ts = &task->task_status;
 
-static void hisi_sas_port_notify_deformed(struct asd_sas_phy *sas_phy)
-{
-	struct domain_device *device;
-	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
-	struct asd_sas_port *sas_port = sas_phy->port;
+	ts->resp = SAS_TASK_COMPLETE;
+	ts->stat = SAS_ABORTED_TASK;
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	list_for_each_entry(device, &sas_port->dev_list, dev_list_node)
-		hisi_sas_do_release_task(phy->hisi_hba, sas_phy->id, device);
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
 }
 
+/* hisi_hba.lock should be locked */
 static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
 			struct domain_device *device)
 {
-	struct asd_sas_port *port = device->port;
-	struct asd_sas_phy *sas_phy;
+	struct hisi_sas_slot *slot, *slot2;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
 
-	list_for_each_entry(sas_phy, &port->phy_list, port_phy_el)
-		hisi_sas_do_release_task(hisi_hba, sas_phy->id, device);
+	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry)
+		hisi_sas_do_release_task(hisi_hba, slot->task, slot);
 }
 
 static void hisi_sas_release_tasks(struct hisi_hba *hisi_hba)
 {
+	struct hisi_sas_device *sas_dev;
+	struct domain_device *device;
 	int i;
 
-	for (i = 0; i < HISI_SAS_MAX_PHYS; i++) {
-		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
-		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
+		sas_dev = &hisi_hba->devices[i];
+		device = sas_dev->sas_device;
 
-		if (!sas_phy->port)
+		if ((sas_dev->dev_type == SAS_PHY_UNUSED) ||
+		    !device)
 			continue;
-		hisi_sas_port_notify_deformed(sas_phy);
+
+		hisi_sas_release_task(hisi_hba, device);
 	}
 }
 
@@ -958,7 +951,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 				slot = &hisi_hba->slot_info
 					[tmf_task.tag_of_task_to_be_managed];
 				spin_lock_irqsave(&hisi_hba->lock, flags);
-				hisi_hba->hw->slot_complete(hisi_hba, slot, 1);
+				hisi_hba->hw->slot_complete(hisi_hba, slot);
 				spin_unlock_irqrestore(&hisi_hba->lock, flags);
 			}
 		}
@@ -1149,11 +1142,8 @@ static int hisi_sas_query_task(struct sas_task *task)
 	if (rc)
 		goto err_out_tag;
 
-	/* Port structure is static for the HBA, so
-	*  even if the port is deformed it is ok
-	*  to reference.
-	*/
-	list_add_tail(&slot->entry, &port->list);
+
+	list_add_tail(&slot->entry, &sas_dev->list);
 	spin_lock(&task->task_state_lock);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock(&task->task_state_lock);
@@ -1259,11 +1249,6 @@ static void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 	hisi_sas_port_notify_formed(sas_phy);
 }
 
-static void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy)
-{
-	hisi_sas_port_notify_deformed(sas_phy);
-}
-
 static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 {
 	phy->phy_attached = 0;
@@ -1369,7 +1354,6 @@ void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
 	.lldd_lu_reset		= hisi_sas_lu_reset,
 	.lldd_query_task	= hisi_sas_query_task,
 	.lldd_port_formed	= hisi_sas_port_formed,
-	.lldd_port_deformed	= hisi_sas_port_deformed,
 };
 
 void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
@@ -1414,7 +1398,6 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 		hisi_sas_phy_init(hisi_hba, i);
 		hisi_hba->port[i].port_attached = 0;
 		hisi_hba->port[i].id = -1;
-		INIT_LIST_HEAD(&hisi_hba->port[i].list);
 	}
 
 	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 43988eb..2f3e877 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1277,7 +1277,7 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 }
 
 static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
-			       struct hisi_sas_slot *slot, int abort)
+			       struct hisi_sas_slot *slot)
 {
 	struct sas_task *task = slot->task;
 	struct hisi_sas_device *sas_dev;
@@ -1307,9 +1307,8 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
 
-	if (unlikely(!sas_dev || abort)) {
-		if (!sas_dev)
-			dev_dbg(dev, "slot complete: port has not device\n");
+	if (unlikely(!sas_dev)) {
+		dev_dbg(dev, "slot complete: port has no device\n");
 		ts->stat = SAS_PHY_DOWN;
 		goto out;
 	}
@@ -1622,7 +1621,7 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 		 */
 		slot->cmplt_queue_slot = rd_point;
 		slot->cmplt_queue = queue;
-		slot_complete_v1_hw(hisi_hba, slot, 0);
+		slot_complete_v1_hw(hisi_hba, slot);
 
 		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
 			rd_point = 0;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 401e5c6..b9d5132 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -625,6 +625,7 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 			sas_dev->dev_type = device->dev_type;
 			sas_dev->hisi_hba = hisi_hba;
 			sas_dev->sas_device = device;
+			INIT_LIST_HEAD(&hisi_hba->devices[i].list);
 			break;
 		}
 	}
@@ -1724,8 +1725,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 }
 
 static int
-slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
-		    int abort)
+slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 {
 	struct sas_task *task = slot->task;
 	struct hisi_sas_device *sas_dev;
@@ -1752,9 +1752,8 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
 
-	if (unlikely(!sas_dev || abort)) {
-		if (!sas_dev)
-			dev_dbg(dev, "slot complete: port has not device\n");
+	if (unlikely(!sas_dev)) {
+		dev_dbg(dev, "slot complete: port has no device\n");
 		ts->stat = SAS_PHY_DOWN;
 		goto out;
 	}
@@ -2615,7 +2614,7 @@ static void cq_tasklet_v2_hw(unsigned long val)
 				slot = &hisi_hba->slot_info[iptt];
 				slot->cmplt_queue_slot = rd_point;
 				slot->cmplt_queue = queue;
-				slot_complete_v2_hw(hisi_hba, slot, 0);
+				slot_complete_v2_hw(hisi_hba, slot);
 
 				act_tmp &= ~(1 << ncq_tag_count);
 				ncq_tag_count = ffs(act_tmp);
@@ -2625,7 +2624,7 @@ static void cq_tasklet_v2_hw(unsigned long val)
 			slot = &hisi_hba->slot_info[iptt];
 			slot->cmplt_queue_slot = rd_point;
 			slot->cmplt_queue = queue;
-			slot_complete_v2_hw(hisi_hba, slot, 0);
+			slot_complete_v2_hw(hisi_hba, slot);
 		}
 
 		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
-- 
1.9.1
