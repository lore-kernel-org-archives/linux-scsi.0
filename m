From: j00310691 <john.garry@huawei.com>
Subject: [PATCH v2 15/23] hisi_sas: add v2 SATA interrupt handler
Date: Tue, 26 Jan 2016 01:22:04 +0800
Message-ID: <1453742532-53092-16-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:55363 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbcAYRI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 12:08:56 -0500
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>

From: John Garry <john.garry@huawei.com>

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 100 +++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 5af2069..c4a887c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -861,6 +861,86 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct	hisi_sas_initial_fis *initial_fis;
+	struct dev_to_host_fis *fis;
+	u32 ent_tmp, ent_msk, ent_int, port_id, link_rate, hard_phy_linkrate;
+	irqreturn_t res = IRQ_HANDLED;
+	u8 attached_sas_addr[SAS_ADDR_SIZE] = {0};
+	int phy_no;
+
+	phy_no = sas_phy->id;
+	initial_fis = &hisi_hba->initial_fis[phy_no];
+	fis = &initial_fis->fis;
+
+	ent_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK1);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk | 1 << phy_no);
+
+	ent_int = hisi_sas_read32(hisi_hba, ENT_INT_SRC1);
+	ent_tmp = ent_int;
+	ent_int >>= ENT_INT_SRC1_D2H_FIS_CH1_OFF * (phy_no % 4);
+	if ((ent_int & ENT_INT_SRC1_D2H_FIS_CH0_MSK) == 0) {
+		dev_warn(dev, "sata int: phy%d did not receive FIS\n", phy_no);
+		hisi_sas_write32(hisi_hba, ENT_INT_SRC1, ent_tmp);
+		hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk);
+		res = IRQ_NONE;
+		goto end;
+	}
+
+	if (unlikely(phy_no == 8)) {
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
+		dev_err(dev, "sata int: phy%d invalid portid\n", phy_no);
+		res = IRQ_NONE;
+		goto end;
+	}
+
+	sas_phy->linkrate = link_rate;
+	hard_phy_linkrate = hisi_sas_phy_read32(hisi_hba, phy_no,
+						HARD_PHY_LINKRATE);
+	phy->maximum_linkrate = hard_phy_linkrate & 0xf;
+	phy->minimum_linkrate = (hard_phy_linkrate >> 4) & 0xf;
+
+	sas_phy->oob_mode = SATA_OOB_MODE;
+	/* Make up some unique SAS address */
+	attached_sas_addr[0] = 0x50;
+	attached_sas_addr[7] = phy_no;
+	memcpy(sas_phy->attached_sas_addr, attached_sas_addr, SAS_ADDR_SIZE);
+	memcpy(sas_phy->frame_rcvd, fis, sizeof(struct dev_to_host_fis));
+	dev_info(dev, "sata int phyup: phy%d link_rate=%d\n", phy_no, link_rate);
+	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	phy->port_id = port_id;
+	phy->phy_type |= PORT_TYPE_SATA;
+	phy->phy_attached = 1;
+	phy->identify.device_type = SAS_SATA_DEV;
+	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
+	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
+	queue_work(hisi_hba->wq, &phy->phyup_ws);
+
+end:
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC1, ent_tmp);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk);
+
+	return res;
+}
+
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phy_updown_v2_hw,
 	int_chnl_int_v2_hw,
@@ -900,6 +980,26 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 		}
 	}
 
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
+		int idx = i + 72; /* First SATA interrupt is irq72 */
+
+		irq = irq_map[idx];
+		if (!irq) {
+			dev_err(dev, "irq init: fail map phy interrupt %d\n",
+				idx);
+			return -ENOENT;
+		}
+
+		rc = devm_request_irq(dev, irq, sata_int_v2_hw, 0,
+				      DRV_NAME " sata", phy);
+		if (rc) {
+			dev_err(dev, "irq init: could not request "
+				"sata interrupt %d, rc=%d\n",
+				irq, rc);
+			return -ENOENT;
+		}
+	}
 	return 0;
 }
 
-- 
1.9.1

