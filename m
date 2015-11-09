From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 20/32] scsi: hisi_sas: add v1 hw interrupt init
Date: Tue, 10 Nov 2015 00:32:25 +0800
Message-ID: <1447086757-147706-21-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add code to interrupts, so now we can get a phy up
interrupt when a disk is connected.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   5 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 162 +++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 039f285..b236a2f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -38,6 +38,11 @@
 #define HISI_SAS_NAME_LEN 32
 
 
+enum {
+	PORT_TYPE_SAS = (1U << 1),
+	PORT_TYPE_SATA = (1U << 0),
+};
+
 enum dev_status {
 	HISI_SAS_DEV_NORMAL,
 	HISI_SAS_DEV_EH,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 4d1402d..b595d24 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -728,6 +728,160 @@ static void phys_init_v1_hw(struct hisi_hba *hisi_hba)
 	mod_timer(timer, jiffies + HZ);
 }
 
+/* Interrupts */
+static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int i, phy_no = sas_phy->id;
+	u32 irq_value, context, port_id, link_rate;
+	u32 *frame_rcvd = (u32 *)sas_phy->frame_rcvd;
+	struct sas_identify_frame *id = (struct sas_identify_frame *)frame_rcvd;
+	irqreturn_t res = IRQ_HANDLED;
+
+	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2);
+	if (!(irq_value & CHL_INT2_SL_PHY_ENA_MSK)) {
+		dev_dbg(dev, "phyup: irq_value = %x not set enable bit\n",
+			irq_value);
+		res = IRQ_NONE;
+		goto end;
+	}
+
+	context = hisi_sas_read32(hisi_hba, PHY_CONTEXT);
+	if (context & 1 << phy_no) {
+		dev_err(dev, "phyup: phy%d SATA attached equipment\n",
+			phy_no);
+		goto end;
+	}
+
+	port_id = (hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA) >> (4 * phy_no))
+		  & 0xf;
+	if (port_id == 0xf) {
+		dev_err(dev, "phyup: phy%d invalid portid\n", phy_no);
+		res = IRQ_NONE;
+		goto end;
+	}
+
+	for (i = 0; i < 6; i++) {
+		u32 idaf = hisi_sas_phy_read32(hisi_hba, phy_no,
+					RX_IDAF_DWORD0 + (i * 4));
+		frame_rcvd[i] = __swab32(idaf);
+	}
+
+	/* Get the linkrate */
+	link_rate = hisi_sas_read32(hisi_hba, PHY_CONN_RATE);
+	link_rate = (link_rate >> (phy_no * 4)) & 0xf;
+	sas_phy->linkrate = link_rate;
+	sas_phy->oob_mode = SAS_OOB_MODE;
+	memcpy(sas_phy->attached_sas_addr,
+		&id->sas_addr, SAS_ADDR_SIZE);
+	dev_info(dev, "phyup: phy%d link_rate=%d\n",
+		 phy_no, link_rate);
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
+
+end:
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
+			     CHL_INT2_SL_PHY_ENA_MSK);
+
+	if (irq_value & CHL_INT2_SL_PHY_ENA_MSK) {
+		u32 chl_int0 = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT0);
+
+		chl_int0 &= ~CHL_INT0_PHYCTRL_NOTRDY_MSK;
+		hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, chl_int0);
+		hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK, 0x3ce3ee);
+	}
+
+	return res;
+}
+static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
+	{"Phy Up"},
+};
+static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
+	int_phyup_v1_hw,
+};
+
+static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i, j, irq, rc;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct device_node *np = dev->of_node;
+	char *int_names = hisi_hba->int_names;
+
+	if (!np)
+		return -ENOENT;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
+
+		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++) {
+			int idx = (i * HISI_SAS_PHY_INT_NR) + j;
+
+			irq = irq_of_parse_and_map(np, idx);
+			if (!irq) {
+				dev_err(dev,
+					"irq init: fail map phy interrupt %d\n",
+					idx);
+				return -ENOENT;
+			}
+
+			(void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
+				       HISI_SAS_NAME_LEN,
+				       "%s %s:%d", dev_name(dev),
+				       phy_int_names[j], i);
+			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
+					&int_names[idx * HISI_SAS_NAME_LEN],
+					phy);
+			if (rc) {
+				dev_err(dev, "irq init: could not request "
+					"phy interrupt %d, rc=%d\n",
+					irq, rc);
+				return -ENOENT;
+			}
+		}
+	}
+	return 0;
+}
+
+static int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+	u32 val;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		/* Clear interrupt status */
+		val = hisi_sas_phy_read32(hisi_hba, i, CHL_INT0);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, val);
+		val = hisi_sas_phy_read32(hisi_hba, i, CHL_INT1);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, val);
+		val = hisi_sas_phy_read32(hisi_hba, i, CHL_INT2);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2, val);
+
+		/* Unmask interrupt */
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0_MSK, 0x3ce3ee);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1_MSK, 0x17fff);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x8000012a);
+
+		/* bypass chip bug mask abnormal intr */
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0_MSK,
+				0x3fffff & ~CHL_INT0_MSK_PHYCTRL_NOTRDY_MSK);
+	}
+
+	return 0;
+}
+
 static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 {
 	int rc;
@@ -736,6 +890,14 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	if (rc)
 		return rc;
 
+	rc = interrupt_init_v1_hw(hisi_hba);
+	if (rc)
+		return rc;
+
+	rc = interrupt_openall_v1_hw(hisi_hba);
+	if (rc)
+		return rc;
+
 	phys_init_v1_hw(hisi_hba);
 
 	return 0;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
