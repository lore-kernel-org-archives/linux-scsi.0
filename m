From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 24/32] scsi: hisi_sas: add dev_found and port_formed
Date: Mon, 26 Oct 2015 22:14:55 +0800
Message-ID: <1445868903-183817-25-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add functions to deal with lldd_dev_found and lldd_port_formed

Signed-off-by: John Garry <john.garry@huawei.com>

Conflicts:
	drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  13 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 106 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  41 +++++++++++++
 3 files changed, 160 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2805708..fc2457f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -40,6 +40,7 @@
 #define HISI_SAS_NAME_LEN 32
 #define HISI_SAS_CTRL_REG_CNT 5
 
+struct hisi_hba;
 
 enum {
 	PORT_TYPE_SAS = (1U << 1),
@@ -50,6 +51,13 @@ enum dev_status {
 	HISI_SAS_DEV_NORMAL,
 	HISI_SAS_DEV_EH,
 };
+
+enum hisi_sas_dev_type {
+	HISI_SAS_DEV_TYPE_STP = 0,
+	HISI_SAS_DEV_TYPE_SSP,
+	HISI_SAS_DEV_TYPE_SATA,
+};
+
 struct hisi_sas_phy {
 	struct hisi_hba	*hisi_hba;
 	struct hisi_sas_port	*port;
@@ -84,6 +92,9 @@ struct hisi_sas_cq {
 
 struct hisi_sas_device {
 	enum sas_device_type	dev_type;
+	struct hisi_hba		*hisi_hba;
+	struct domain_device	*sas_device;
+	u64 attached_phy;
 	u64 device_id;
 	u64 running_req;
 	u8 dev_status;
@@ -116,6 +127,8 @@ struct hisi_sas_tmf_task {
 
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
+	void (*setup_itct)(struct hisi_hba *hisi_hba,
+			   struct hisi_sas_device *device);
 	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
 	int (*get_free_slot)(struct hisi_hba *hisi_hba, int *q, int *s);
 	void (*start_delivery)(struct hisi_hba *hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9660513..9e62eda 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -12,6 +12,9 @@
 #include "hisi_sas.h"
 #define DRV_NAME "hisi_sas"
 
+#define DEV_IS_EXPANDER(type) \
+	((type == SAS_EDGE_EXPANDER_DEVICE) || \
+	(type == SAS_FANOUT_EXPANDER_DEVICE))
 
 #define DEV_IS_GONE(dev) \
 	((!dev) || (dev->dev_type == SAS_PHY_UNUSED))
@@ -341,6 +344,79 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
 }
 
+static struct hisi_sas_device *hisi_sas_alloc_dev(struct hisi_hba *hisi_hba)
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
+static int hisi_sas_dev_found_notify(struct domain_device *device, int lock)
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
+	hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
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
+				 SAS_ADDR(parent_dev->sas_addr));
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
 static void hisi_sas_phyup_work(struct work_struct *work)
 {
 	struct hisi_sas_phy *phy =
@@ -378,6 +454,34 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	INIT_WORK(&phy->phyup_ws, hisi_sas_phyup_work);
 }
 
+static int hisi_sas_dev_found(struct domain_device *device)
+{
+	return hisi_sas_dev_found_notify(device, 1);
+}
+
+static void hisi_sas_dev_gone_notify(struct domain_device *device)
+{
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	if (!sas_dev) {
+		dev_warn(dev, "%s: found dev has gone\n", __func__);
+		return;
+	}
+
+	dev_info(dev, "found dev[%lld:%x] is gone\n",
+		 sas_dev->device_id, sas_dev->dev_type);
+
+	hisi_hba->hw->free_device(hisi_hba, sas_dev);
+	device->lldd_dev = NULL;
+	sas_dev->sas_device = NULL;
+}
+
+static void hisi_sas_dev_gone(struct domain_device *device)
+{
+	hisi_sas_dev_gone_notify(device);
+}
 
 static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 {
@@ -406,6 +510,8 @@ static struct scsi_host_template hisi_sas_sht = {
 };
 
 static struct sas_domain_function_template hisi_sas_transport_ops = {
+	.lldd_dev_found		= hisi_sas_dev_found,
+	.lldd_dev_gone		= hisi_sas_dev_gone,
 	.lldd_execute_task	= hisi_sas_queue_command,
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index be72e80..f9ebe7e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -498,6 +498,46 @@ static void init_id_frame_v1_hw(struct hisi_hba *hisi_hba)
 		config_id_frame_v1_hw(hisi_hba, i);
 }
 
+static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
+			     struct hisi_sas_device *sas_dev)
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
 
 static void free_device_v1_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
@@ -1473,6 +1513,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
+	.setup_itct = setup_itct_v1_hw,
 	.sl_notify = sl_notify_v1_hw,
 	.free_device = free_device_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
-- 
1.9.1
