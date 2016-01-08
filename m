From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/23] hisi_sas: add v2 int init and phy up handler
Date: Fri, 8 Jan 2016 22:15:31 +0800
Message-ID: <1452262542-64589-13-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 171 +++++++++++++++++++++++++++++++++
 1 file changed, 171 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 325b287..ba2f792 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -256,6 +256,11 @@ struct hisi_sas_complete_v2_hdr {
 	__le32 dw3;
 };
 
+enum {
+	HISI_SAS_PHY_PHY_UPDOWN,
+	HISI_SAS_PHY_INT_NR
+};
+
 #define HISI_SAS_COMMAND_ENTRIES_V2_HW 4096
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
@@ -609,6 +614,167 @@ static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
 	mod_timer(timer, jiffies + HZ);
 }
 
+static void sl_notify_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 sl_control;
+
+	sl_control = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
+	sl_control |= SL_CONTROL_NOTIFY_EN_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
+	msleep(1);
+	sl_control = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
+	sl_control &= ~SL_CONTROL_NOTIFY_EN_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
+}
+
+static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
+{
+	int i, res = 0;
+	u32 context, port_id, link_rate, hard_phy_linkrate;
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 *frame_rcvd = (u32 *)sas_phy->frame_rcvd;
+	struct sas_identify_frame *id = (struct sas_identify_frame *)frame_rcvd;
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 1);
+
+	/* Check for SATA dev */
+	context = hisi_sas_read32(hisi_hba, PHY_CONTEXT);
+	if (context & (1 << phy_no))
+		goto end;
+
+	if (phy_no == 8) {
+		u32 port_state = hisi_sas_read32(hisi_hba, PORT_STATE);
+
+		port_id = (port_state & PORT_STATE_PHY8_PORT_NUM_MSK) >>
+			  PORT_STATE_PHY8_PORT_NUM_OFF;
+		link_rate = (port_state & PORT_STATE_PHY8_CONN_RATE_MSK) >>
+			    PORT_STATE_PHY8_CONN_RATE_OFF;
+	} else {
+		port_id = hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA);
+		port_id = (port_id >> (4 * phy_no)) & 0xf;
+		link_rate = hisi_sas_read32(hisi_hba, PHY_CONN_RATE);
+		link_rate = (link_rate >> (phy_no * 4)) & 0xf;
+	}
+
+	if (port_id == 0xf) {
+		dev_err(dev, "phyup: phy%d invalid portid\n", phy_no);
+		res = IRQ_NONE;
+		goto end;
+	}
+
+	for (i = 0; i < 6; i++) {
+		u32 idaf = hisi_sas_phy_read32(hisi_hba, phy_no,
+					       RX_IDAF_DWORD0 + (i * 4));
+		frame_rcvd[i] = __swab32(idaf);
+	}
+
+	/* Get the linkrates */
+	link_rate = hisi_sas_read32(hisi_hba, PHY_CONN_RATE);
+	link_rate = (link_rate >> (phy_no * 4)) & 0xf;
+	sas_phy->linkrate = link_rate;
+	hard_phy_linkrate = hisi_sas_phy_read32(hisi_hba, phy_no,
+						HARD_PHY_LINKRATE);
+	phy->maximum_linkrate = hard_phy_linkrate & 0xf;
+	phy->minimum_linkrate = (hard_phy_linkrate >> 4) & 0xf;
+
+	sas_phy->oob_mode = SAS_OOB_MODE;
+	memcpy(sas_phy->attached_sas_addr, &id->sas_addr, SAS_ADDR_SIZE);
+	dev_info(dev, "phyup: phy%d link_rate=%d\n", phy_no, link_rate);
+	phy->port_id = port_id;
+	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	phy->phy_type |= PORT_TYPE_SAS;
+	phy->phy_attached = 1;
+	phy->identify.device_type = id->dev_type;
+	phy->frame_rcvd_size =	sizeof(struct sas_identify_frame);
+	if (phy->identify.device_type == SAS_END_DEVICE)
+		phy->identify.target_port_protocols =
+			SAS_PROTOCOL_SSP;
+	else if (phy->identify.device_type != SAS_PHY_UNUSED)
+		phy->identify.target_port_protocols =
+			SAS_PROTOCOL_SMP;
+	queue_work(hisi_hba->wq, &phy->phyup_ws);
+
+end:
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
+			     CHL_INT0_SL_PHY_ENABLE_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 0);
+
+	return res;
+}
+
+static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
+{
+	struct hisi_hba *hisi_hba = p;
+	u32 irq_msk;
+	int phy_no = 0;
+	irqreturn_t res = IRQ_HANDLED;
+
+	irq_msk = (hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO)
+		   >> HGC_INVLD_DQE_INFO_FB_CH0_OFF) & 0x1ff;
+	while (irq_msk) {
+		if (irq_msk  & 1) {
+			u32 irq_value = hisi_sas_phy_read32(hisi_hba, phy_no,
+							    CHL_INT0);
+
+			if (irq_value & CHL_INT0_SL_PHY_ENABLE_MSK)
+				/* phy up */
+				if (phy_up_v2_hw(phy_no, hisi_hba)) {
+					res = IRQ_NONE;
+					goto end;
+				}
+
+		}
+		irq_msk >>= 1;
+		phy_no++;
+	}
+
+end:
+	return res;
+}
+
+static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
+	int_phy_updown_v2_hw,
+};
+
+/**
+ * There is a limitation in the hip06 chipset that we need
+ * to map in all mbigen interrupts, even if they are not used.
+ */
+static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct platform_device *pdev = hisi_hba->pdev;
+	struct device *dev = &pdev->dev;
+	int i, irq, rc, irq_map[128];
+
+
+	for (i = 0; i < 128; i++)
+		irq_map[i] = platform_get_irq(pdev, i);
+
+	for (i = 0; i < HISI_SAS_PHY_INT_NR; i++) {
+		int idx = i;
+
+		irq = irq_map[idx + 1]; /* Phy up/down is irq1 */
+		if (!irq) {
+			dev_err(dev, "irq init: fail map phy interrupt %d\n",
+				idx);
+			return -ENOENT;
+		}
+
+		rc = devm_request_irq(dev, irq, phy_interrupts[i], 0,
+				      DRV_NAME " phy", hisi_hba);
+		if (rc) {
+			dev_err(dev, "irq init: could not request "
+				"phy interrupt %d, rc=%d\n",
+				irq, rc);
+			return -ENOENT;
+		}
+	}
+
+	return 0;
+}
+
 static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 {
 	int rc;
@@ -617,6 +783,10 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 	if (rc)
 		return rc;
 
+	rc = interrupt_init_v2_hw(hisi_hba);
+	if (rc)
+		return rc;
+
 	phys_init_v2_hw(hisi_hba);
 
 	return 0;
@@ -624,6 +794,7 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
+	.sl_notify = sl_notify_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 };
-- 
1.9.1
