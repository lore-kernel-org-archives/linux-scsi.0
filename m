From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 25/32] scsi: hisi_sas: add abnormal irq handler
Date: Mon, 26 Oct 2015 22:14:56 +0800
Message-ID: <1445868903-183817-26-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add abnormal irq handler. This handler is concerned with
phy down event.
Also add port formed and port deformed handlers.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   2 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 136 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  70 +++++++++++++++++
 3 files changed, 208 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fc2457f..e52f5d3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -139,6 +139,7 @@ struct hisi_sas_hw {
 			     struct hisi_sas_slot *slot, int abort);
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
+	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
 	int complete_hdr_size;
 };
 
@@ -344,6 +345,7 @@ extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
 
+extern void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy);
 extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct sas_task *task,
 				    struct hisi_sas_slot *slot);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9e62eda..88bf72f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -454,6 +454,89 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	INIT_WORK(&phy->phyup_ws, hisi_sas_phyup_work);
 }
 
+static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
+{
+	struct sas_ha_struct *sas_ha = sas_phy->ha;
+	struct hisi_hba *hisi_hba = NULL;
+	int i = 0;
+	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct hisi_sas_port *port;
+	unsigned long flags = 0;
+
+	if (!sas_port)
+		return;
+
+	while (sas_ha->sas_phy[i]) {
+		if (sas_ha->sas_phy[i] == sas_phy) {
+			hisi_hba = (struct hisi_hba *)sas_ha->lldd_ha;
+			port = &hisi_hba->port[i];
+			break;
+		}
+		i++;
+	}
+
+	if (hisi_hba == NULL) {
+		pr_err("%s: could not find hba\n", __func__);
+		return;
+	}
+
+	if (lock)
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+	port->port_attached = 1;
+	port->id = phy->port_id;
+	phy->port = port;
+	sas_port->lldd_port = port;
+
+	if (lock)
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+}
+
+static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba,
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
+		hisi_hba->hw->slot_complete(hisi_hba, slot, 1);
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
+	int phy_no = 0;
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
+
 static int hisi_sas_dev_found(struct domain_device *device)
 {
 	return hisi_sas_dev_found_notify(device, 1);
@@ -488,6 +571,57 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	return hisi_sas_task_exec(task, gfp_flags, NULL, 0, NULL);
 }
 
+
+static void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
+{
+	hisi_sas_port_notify_formed(sas_phy, 1);
+}
+
+static void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy)
+{
+	hisi_sas_port_notify_deformed(sas_phy, 1);
+}
+
+static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
+{
+	phy->phy_attached = 0;
+	phy->phy_type = 0;
+	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	phy->port = NULL;
+}
+
+void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
+
+	if (rdy) {
+		/* Phy down but ready */
+		hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+		hisi_sas_port_notify_formed(sas_phy, 0);
+	} else {
+		struct hisi_sas_port *port  = phy->port;
+
+		/* Phy down and not ready */
+		sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_phy_disconnected(sas_phy);
+
+		if (port) {
+			if (phy->phy_type & PORT_TYPE_SAS) {
+				int port_id = port->id;
+
+				if (!hisi_hba->hw->get_wideport_bitmap(hisi_hba,
+								       port_id))
+					port->port_attached = 0;
+			} else if (phy->phy_type & PORT_TYPE_SATA)
+				port->port_attached = 0;
+		}
+		hisi_sas_phy_disconnected(phy);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_phy_down);
+
 static struct scsi_transport_template *hisi_sas_stt;
 
 static struct scsi_host_template hisi_sas_sht = {
@@ -513,6 +647,8 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_dev_gone		= hisi_sas_dev_gone,
 	.lldd_execute_task	= hisi_sas_queue_command,
+	.lldd_port_formed	= hisi_sas_port_formed,
+	.lldd_port_deformed	= hisi_sas_port_deformed,
 };
 
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index f9ebe7e..8a9498e74 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -809,6 +809,18 @@ static void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+static int get_wideport_bitmap_v1_hw(struct hisi_hba *hisi_hba, int port_id)
+{
+	int i, bitmap = 0;
+	u32 phy_port_num_ma = hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA);
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		if (((phy_port_num_ma >> (i * 4)) & 0xf) == port_id)
+			bitmap |= 1 << i;
+
+	return bitmap;
+}
+
 /**
  * This function allocates across all queues to load balance.
  * It uses the current cpu as the method to balance the
@@ -1339,6 +1351,61 @@ end:
 	return res;
 }
 
+static irqreturn_t int_abnormal_v1_hw(int irq, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	u32 irq_value, irq_mask_old;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int phy_no = sas_phy->id;
+
+	/* mask_int0 */
+	irq_mask_old = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT0_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK, 0x3fffff);
+
+	/* read int0 */
+	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT0);
+
+	if (irq_value & CHL_INT0_PHYCTRL_NOTRDY_MSK) {
+		u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
+
+		hisi_sas_phy_down(hisi_hba, phy_no,
+				  (phy_state & 1 << phy_no) ? 1 : 0);
+	}
+
+	if (irq_value & CHL_INT0_ID_TIMEOUT_MSK)
+		dev_dbg(dev, "abnormal: ID_TIMEOUT phy%d identify timeout\n",
+			phy_no);
+
+	if (irq_value & CHL_INT0_DWS_LOST_MSK)
+		dev_dbg(dev, "abnormal: DWS_LOST phy%d dws lost\n", phy_no);
+
+	if (irq_value & CHL_INT0_SN_FAIL_NGR_MSK)
+		dev_dbg(dev, "abnormal: SN_FAIL_NGR phy%d sn fail ngr\n",
+			phy_no);
+
+	if (irq_value & CHL_INT0_SL_IDAF_FAIL_MSK ||
+		irq_value & CHL_INT0_SL_OPAF_FAIL_MSK)
+		dev_dbg(dev, "abnormal: SL_ID/OPAF_FAIL phy%d check adr frm err\n",
+			phy_no);
+
+	if (irq_value & CHL_INT0_SL_PS_FAIL_OFF)
+		dev_dbg(dev, "abnormal: SL_PS_FAIL phy%d fail\n", phy_no);
+
+	/* write to zero */
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, irq_value);
+
+	if (irq_value & CHL_INT0_PHYCTRL_NOTRDY_MSK)
+		hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK,
+				0x3fffff & ~CHL_INT0_MSK_PHYCTRL_NOTRDY_MSK);
+	else
+		hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK,
+				irq_mask_old);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 {
 	struct hisi_sas_cq *cq = p;
@@ -1391,11 +1458,13 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 	{"Phy Up"},
+	{"Abnormal"},
 };
 
 static const char cq_int_name[32] = "cq";
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phyup_v1_hw,
+	int_abnormal_v1_hw
 };
 
 static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
@@ -1520,6 +1589,7 @@ static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.get_free_slot = get_free_slot_v1_hw,
 	.start_delivery = start_delivery_v1_hw,
 	.slot_complete = slot_complete_v1_hw,
+	.get_wideport_bitmap = get_wideport_bitmap_v1_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
 
-- 
1.9.1
