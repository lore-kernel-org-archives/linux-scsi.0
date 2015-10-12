From: John Garry <john.garry@huawei.com>
Subject: [PATCH 16/25] scsi: hisi_sas: add dev_found and port_formed
Date: Mon, 12 Oct 2015 23:20:28 +0800
Message-ID: <1444663237-238302-17-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12427 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbJLPHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:07:30 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add functions to deal with lldd_dev_found and lldd_port_formed.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  12 ++++
 drivers/scsi/hisi_sas/hisi_sas_init.c  |   2 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 125 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  41 +++++++++++
 4 files changed, 180 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 976964f..3516d6f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -47,6 +47,12 @@ enum dev_status {
 	HISI_SAS_DEV_EH,
 };
 
+enum hisi_sas_dev_type {
+	HISI_SAS_DEV_TYPE_STP = 0,
+	HISI_SAS_DEV_TYPE_SSP,
+	HISI_SAS_DEV_TYPE_SATA,
+};
+
 struct hisi_sas_phy {
 	struct hisi_hba	*hisi_hba;
 	struct hisi_sas_port	*port;
@@ -345,12 +351,16 @@ union hisi_sas_command_table {
 
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
+int hisi_sas_dev_found(struct domain_device *dev);
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags);
+void hisi_sas_port_formed(struct asd_sas_phy *sas_phy);
 void hisi_sas_wq_process(struct work_struct *work);
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			struct hisi_sas_slot *slot);
 
 /* hw specific functions */
+extern void hisi_sas_setup_itct_v1_hw(struct hisi_hba *hisi_hba,
+				      struct hisi_sas_device *device);
 extern void start_delivery_v1_hw(struct hisi_hba *hisi_hba);
 extern int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s);
 extern int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
@@ -361,4 +371,6 @@ extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
 extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int phys_init_v1_hw(struct hisi_hba *hisi_hba);
 extern void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
+extern void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
+			     struct hisi_sas_device *device);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index c681b21..703527b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -33,7 +33,9 @@ static struct scsi_host_template hisi_sas_sht = {
 };
 
 static struct sas_domain_function_template hisi_sas_transport_ops = {
+	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_execute_task	= hisi_sas_queue_command,
+	.lldd_port_formed	= hisi_sas_port_formed,
 };
 
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 74084c2..44cb9085 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -11,6 +11,9 @@
 
 #include "hisi_sas.h"
 
+#define DEV_IS_EXPANDER(type) \
+	((type == SAS_EDGE_EXPANDER_DEVICE) || \
+	(type == SAS_FANOUT_EXPANDER_DEVICE))
 
 #define DEV_IS_GONE(dev) \
 	((!dev) || (dev->dev_type == SAS_PHY_UNUSED))
@@ -352,6 +355,79 @@ void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
 }
 
+struct hisi_sas_device *hisi_sas_alloc_dev(struct hisi_hba *hisi_hba)
+{
+	int dev_id;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	for (dev_id = 0; dev_id < HISI_SAS_MAX_DEVICES; dev_id++) {
+		if (hisi_hba->devices[dev_id].dev_type == SAS_PHY_UNUSED) {
+			hisi_hba->devices[dev_id].device_id = dev_id;
+			return &hisi_hba->devices[dev_id];
+		}
+	}
+
+	dev_err(dev, "alloc dev: max support %d devices - could not alloc\n",
+		HISI_SAS_MAX_DEVICES);
+
+	return NULL;
+}
+
+int hisi_sas_dev_found_notify(struct domain_device *device, int lock)
+{
+	unsigned long flags = 0;
+	int res = 0;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct domain_device *parent_dev = device->parent;
+	struct hisi_sas_device *sas_dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	if (lock)
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+
+	sas_dev = hisi_sas_alloc_dev(hisi_hba);
+	if (!sas_dev) {
+		res = -EINVAL;
+		goto found_out;
+	}
+
+	device->lldd_dev = sas_dev;
+	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
+	sas_dev->dev_type = device->dev_type;
+	sas_dev->hisi_hba = hisi_hba;
+	sas_dev->sas_device = device;
+	setup_itct_v1_hw(hisi_hba, sas_dev);
+
+	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
+		int phy_no;
+		u8 phy_num = parent_dev->ex_dev.num_phys;
+		struct ex_phy *phy;
+
+		for (phy_no = 0; phy_no < phy_num; phy_no++) {
+			phy = &parent_dev->ex_dev.ex_phy[phy_no];
+			if (SAS_ADDR(phy->attached_sas_addr) ==
+				SAS_ADDR(device->sas_addr)) {
+				sas_dev->attached_phy = phy_no;
+				break;
+			}
+		}
+
+		if (phy_no == phy_num) {
+			dev_info(dev,
+				 "dev found: no attached "
+				 "dev:%016llx at ex:%016llx\n",
+				 SAS_ADDR(device->sas_addr),
+				SAS_ADDR(parent_dev->sas_addr));
+			res = -EINVAL;
+		}
+	}
+
+found_out:
+	if (lock)
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	return res;
+}
+
 
 static void hisi_sas_phyup_work(struct hisi_hba *hisi_hba,
 				      int phy_no)
@@ -400,7 +476,56 @@ void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	sas_phy->lldd_phy = phy;
 }
 
+void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
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
+
+int hisi_sas_dev_found(struct domain_device *device)
+{
+	return hisi_sas_dev_found_notify(device, 1);
+}
+
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 {
 	return hisi_sas_task_exec(task, gfp_flags, NULL, 0, NULL);
 }
+
+void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
+{
+	hisi_sas_port_notify_formed(sas_phy, 1);
+}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 4cb0e1b..e8b9dc3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -493,6 +493,47 @@ static void init_id_frame_v1_hw(struct hisi_hba *hisi_hba)
 		config_id_frame_v1_hw(hisi_hba, i);
 }
 
+void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
+		      struct hisi_sas_device *sas_dev)
+{
+	struct domain_device *device = sas_dev->sas_device;
+	struct device *dev = &hisi_hba->pdev->dev;
+	u64 qw0, device_id = sas_dev->device_id;
+	struct hisi_sas_itct *itct = &hisi_hba->itct[device_id];
+
+	memset(itct, 0, sizeof(*itct));
+
+	/* qw0 */
+	qw0 = 0;
+	switch (sas_dev->dev_type) {
+	case SAS_END_DEVICE:
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		qw0 = HISI_SAS_DEV_TYPE_SSP << ITCT_HDR_DEV_TYPE_OFF;
+		break;
+	default:
+		dev_warn(dev, "setup itct: unsupported dev type (%d)\n",
+			 sas_dev->dev_type);
+	}
+
+	qw0 |= ((1 << ITCT_HDR_VALID_OFF) |
+		(1 << ITCT_HDR_AWT_CONTROL_OFF) |
+		(device->max_linkrate << ITCT_HDR_MAX_CONN_RATE_OFF) |
+		(1 << ITCT_HDR_VALID_LINK_NUM_OFF) |
+		(device->port->id << ITCT_HDR_PORT_ID_OFF));
+	itct->qw0 = cpu_to_le64(qw0);
+
+	/* qw1 */
+	memcpy(&itct->sas_addr, device->sas_addr, SAS_ADDR_SIZE);
+	itct->sas_addr = __swab64(itct->sas_addr);
+
+	/* qw2 */
+	itct->qw2 = cpu_to_le64((500 < ITCT_HDR_IT_NEXUS_LOSS_TL_OFF) |
+				(0xff00 < ITCT_HDR_BUS_INACTIVE_TL_OFF) |
+				(0xff00 < ITCT_HDR_MAX_CONN_TL_OFF) |
+				(0xff00 < ITCT_HDR_REJ_OPEN_TL_OFF));
+}
+
 static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
-- 
1.9.1

