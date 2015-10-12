From: John Garry <john.garry@huawei.com>
Subject: [PATCH 18/25] scsi: hisi_sas: add dev_gone and port_deformed
Date: Mon, 12 Oct 2015 23:20:30 +0800
Message-ID: <1444663237-238302-19-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:14430 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbJLPO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:14:26 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add function calls for lldd_dev_gone and lldd_port_deformed.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  7 +++
 drivers/scsi/hisi_sas/hisi_sas_init.c  |  2 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 80 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 28 ++++++++++++
 4 files changed, 117 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3f61a4a..265d9bd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -352,14 +352,19 @@ union hisi_sas_command_table {
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
 int hisi_sas_dev_found(struct domain_device *dev);
+void hisi_sas_dev_gone(struct domain_device *dev);
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags);
 void hisi_sas_port_formed(struct asd_sas_phy *sas_phy);
+void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy);
 void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy);
 void hisi_sas_wq_process(struct work_struct *work);
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			struct hisi_sas_slot *slot);
 
 /* hw specific functions */
+extern int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
+			       struct hisi_sas_slot *slot,
+			       int abort);
 extern void hisi_sas_setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 				      struct hisi_sas_device *device);
 extern void start_delivery_v1_hw(struct hisi_hba *hisi_hba);
@@ -370,6 +375,8 @@ extern int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 extern int interrupt_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
 extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
+extern int free_device_v1_hw(struct hisi_hba *hisi_hba,
+			     struct hisi_sas_device *dev);
 extern int phys_init_v1_hw(struct hisi_hba *hisi_hba);
 extern void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
 extern void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 703527b..ba64562 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -34,8 +34,10 @@ static struct scsi_host_template hisi_sas_sht = {
 
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
+	.lldd_dev_gone		= hisi_sas_dev_gone,
 	.lldd_execute_task	= hisi_sas_queue_command,
 	.lldd_port_formed	= hisi_sas_port_formed,
+	.lldd_port_deformed	= hisi_sas_port_deformed,
 };
 
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fbc2cca..36ef8cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -514,12 +514,86 @@ void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 }
 
+void hisi_sas_do_release_task(struct hisi_hba *hisi_hba,
+		int phy_no, struct domain_device *device)
+{
+	struct hisi_sas_phy *phy;
+	struct hisi_sas_port *port;
+	struct hisi_sas_slot *slot, *slot2;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	phy = &hisi_hba->phy[phy_no];
+	port = phy->port;
+	if (!port)
+		return;
+
+	list_for_each_entry_safe(slot, slot2, &port->list, entry) {
+		struct sas_task *task;
+
+		task = slot->task;
+		if (device && task->dev != device)
+			continue;
+
+		dev_info(dev, "Release slot [%d:%d], task [%p]:\n",
+			 slot->dlvry_queue, slot->dlvry_queue_slot, task);
+		slot_complete_v1_hw(hisi_hba, slot, 1);
+	}
+}
+
+static void hisi_sas_port_notify_deformed(struct asd_sas_phy *sas_phy,
+					  int lock)
+{
+	struct domain_device *device;
+	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct hisi_sas_port *port = sas_port->lldd_port;
+	int phy_no = 0;
+
+	port->port_attached = 0;
+	port->id = -1;
+
+	while (phy != &hisi_hba->phy[phy_no]) {
+		phy_no++;
+
+		if (phy_no >= hisi_hba->n_phy)
+			return;
+	}
+	list_for_each_entry(device, &sas_port->dev_list, dev_list_node)
+		hisi_sas_do_release_task(phy->hisi_hba, phy_no, device);
+}
 
 int hisi_sas_dev_found(struct domain_device *device)
 {
 	return hisi_sas_dev_found_notify(device, 1);
 }
 
+
+static void hisi_sas_dev_gone_notify(struct domain_device *device)
+{
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	if (!sas_dev) {
+		pr_warn("%s: found dev has gone\n", __func__);
+		return;
+	}
+
+	dev_info(dev, "found dev[%lld:%x] is gone\n",
+		 sas_dev->device_id, sas_dev->dev_type);
+
+	free_device_v1_hw(hisi_hba, sas_dev);
+
+	device->lldd_dev = NULL;
+	sas_dev->sas_device = NULL;
+}
+
+void hisi_sas_dev_gone(struct domain_device *device)
+{
+	hisi_sas_dev_gone_notify(device);
+}
+
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 {
 	return hisi_sas_task_exec(task, gfp_flags, NULL, 0, NULL);
@@ -529,6 +603,12 @@ void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 {
 	hisi_sas_port_notify_formed(sas_phy, 1);
 }
+
+void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy)
+{
+	hisi_sas_port_notify_deformed(sas_phy, 1);
+}
+
 static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 {
 	phy->phy_attached = 0;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fadd163..2de54a7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -534,6 +534,34 @@ void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 				(0xff00 < ITCT_HDR_REJ_OPEN_TL_OFF));
 }
 
+int free_device_v1_hw(struct hisi_hba *hisi_hba,
+		      struct hisi_sas_device *sas_dev)
+{
+	u64 dev_id = sas_dev->device_id;
+	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
+	u32 qw0, reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
+
+	reg_val |= CFG_AGING_TIME_ITCT_REL_MSK;
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, reg_val);
+
+	/* free itct */
+	udelay(1);
+	reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
+	reg_val &= ~CFG_AGING_TIME_ITCT_REL_MSK;
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, reg_val);
+
+	qw0 = cpu_to_le64(itct->qw0);
+	qw0 &= ~ITCT_HDR_VALID_MSK;
+	itct->qw0 = cpu_to_le64(qw0);
+
+	memset(sas_dev, 0, sizeof(*sas_dev));
+	sas_dev->device_id = dev_id;
+	sas_dev->dev_type = SAS_PHY_UNUSED;
+	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
+
+	return 0;
+}
+
 static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
-- 
1.9.1

