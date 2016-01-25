From: j00310691 <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 09/23] hisi_sas: add v2 hw init
Date: Tue, 26 Jan 2016 01:21:58 +0800
Message-ID: <1453742532-53092-10-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Add code to initialise the hardware.

Support is also added to deal with the
"am-max-transmissions" (amt) limitation in hip06
controller #1. This is how many connection requests
we can send on the system bus before waiting for a
response.
Due to chip bus design, controller #1 is limited to
32 amt, while, by design, a controller supports 64.
The default value for the nibbles in the relevant
registers is 0x40; these need to be programmed with
0x20.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 288 +++++++++++++++++++++++++++++++++
 1 file changed, 288 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 31e4fdc..da9c375 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -249,7 +249,295 @@
 #define ITCT_HDR_RTOLT_OFF		48
 #define ITCT_HDR_RTOLT_MSK		(0xffffULL << ITCT_HDR_RTOLT_OFF)
 
+struct hisi_sas_complete_v2_hdr {
+	__le32 dw0;
+	__le32 dw1;
+	__le32 act;
+	__le32 dw3;
+};
+
+#define HISI_SAS_COMMAND_ENTRIES_V2_HW 4096
+
+static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	return readl(regs);
+}
+
+static void hisi_sas_write32(struct hisi_hba *hisi_hba, u32 off, u32 val)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	writel(val, regs);
+}
+
+static void hisi_sas_phy_write32(struct hisi_hba *hisi_hba, int phy_no,
+				 u32 off, u32 val)
+{
+	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
+
+	writel(val, regs);
+}
+
+static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
+				      int phy_no, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
+
+	return readl(regs);
+}
+
+static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
+{
+	int i, reset_val;
+	u32 val;
+	unsigned long end_time;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	/* The mask needs to be set depending on the number of phys */
+	if (hisi_hba->n_phy == 9)
+		reset_val = 0x1fffff;
+	else
+		reset_val = 0x7ffff;
+
+	/* Disable all of the DQ */
+	for (i = 0; i < HISI_SAS_MAX_QUEUES; i++)
+		hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
+
+	/* Disable all of the PHYs */
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		u32 phy_cfg = hisi_sas_phy_read32(hisi_hba, i, PHY_CFG);
+
+		phy_cfg &= ~PHY_CTRL_RESET_MSK;
+		hisi_sas_phy_write32(hisi_hba, i, PHY_CFG, phy_cfg);
+	}
+	udelay(50);
+
+	/* Ensure DMA tx & rx idle */
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		u32 dma_tx_status, dma_rx_status;
+
+		end_time = jiffies + msecs_to_jiffies(1000);
+
+		while (1) {
+			dma_tx_status = hisi_sas_phy_read32(hisi_hba, i,
+							    DMA_TX_STATUS);
+			dma_rx_status = hisi_sas_phy_read32(hisi_hba, i,
+							    DMA_RX_STATUS);
+
+			if (!(dma_tx_status & DMA_TX_STATUS_BUSY_MSK) &&
+				!(dma_rx_status & DMA_RX_STATUS_BUSY_MSK))
+				break;
+
+			msleep(20);
+			if (time_after(jiffies, end_time))
+				return -EIO;
+		}
+	}
+
+	/* Ensure axi bus idle */
+	end_time = jiffies + msecs_to_jiffies(1000);
+	while (1) {
+		u32 axi_status =
+			hisi_sas_read32(hisi_hba, AXI_CFG);
+
+		if (axi_status == 0)
+			break;
+
+		msleep(20);
+		if (time_after(jiffies, end_time))
+			return -EIO;
+	}
+
+	/* reset and disable clock*/
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg,
+			reset_val);
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg + 4,
+			reset_val);
+	msleep(1);
+	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
+	if (reset_val != (val & reset_val)) {
+		dev_err(dev, "SAS reset fail.\n");
+		return -EIO;
+	}
+
+	/* De-reset and enable clock*/
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg + 4,
+			reset_val);
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg,
+			reset_val);
+	msleep(1);
+	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg,
+			&val);
+	if (val & reset_val) {
+		dev_err(dev, "SAS de-reset fail.\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct device_node *np = dev->of_node;
+	int i;
+
+	/* Global registers init */
+
+	/* Deal with am-max-transmissions quirk */
+	if (of_get_property(np, "hip06-sas-v2-quirk-amt", NULL)) {
+		hisi_sas_write32(hisi_hba, AM_CFG_MAX_TRANS, 0x2020);
+		hisi_sas_write32(hisi_hba, AM_CFG_SINGLE_PORT_MAX_TRANS,
+				 0x2020);
+	} /* Else, use defaults -> do nothing */
+
+	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
+			 (u32)((1ULL << hisi_hba->queue_count) - 1));
+	hisi_sas_write32(hisi_hba, AXI_USER1, 0xc0000000);
+	hisi_sas_write32(hisi_hba, AXI_USER2, 0x10000);
+	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
+	hisi_sas_write32(hisi_hba, HGC_SAS_TX_OPEN_FAIL_RETRY_CTRL, 0x7FF);
+	hisi_sas_write32(hisi_hba, OPENA_WT_CONTI_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, I_T_NEXUS_LOSS_TIME, 0x1F4);
+	hisi_sas_write32(hisi_hba, MAX_CON_TIME_LIMIT_TIME, 0x4E20);
+	hisi_sas_write32(hisi_hba, BUS_INACTIVE_LIMIT_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, HGC_ERR_STAT_EN, 0x1);
+	hisi_sas_write32(hisi_hba, HGC_GET_ITV_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
+	hisi_sas_write32(hisi_hba, ENT_INT_COAL_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, ENT_INT_COAL_CNT, 0x1);
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 0x0);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC1, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC2, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC3, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0x7efefefe);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0x7efefefe);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0x7ffffffe);
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0xfffff3c0);
+	for (i = 0; i < hisi_hba->queue_count; i++)
+		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK+0x4*i, 0);
+
+	hisi_sas_write32(hisi_hba, AXI_AHB_CLK_CFG, 1);
+	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE, 0x855);
+		hisi_sas_phy_write32(hisi_hba, i, SAS_PHY_CTRL, 0x30b9908);
+		hisi_sas_phy_write32(hisi_hba, i, SL_TOUT_CFG, 0x7d7d7d7d);
+		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 0x10);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, 0xffffffff);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, 0xffffffff);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2, 0xffffffff);
+		hisi_sas_phy_write32(hisi_hba, i, RXOP_CHECK_CFG_H, 0x1000);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1_MSK, 0xffffffff);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x8ffffbff);
+		hisi_sas_phy_write32(hisi_hba, i, SL_CFG, 0x23f801fc);
+		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL_RDY_MSK, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_NOT_RDY_MSK, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_DWS_RESET_MSK, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_PHY_ENA_MSK, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, SL_RX_BCAST_CHK_MSK, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT_COAL_EN, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL, 0x199B694);
+	}
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		/* Delivery queue */
+		hisi_sas_write32(hisi_hba,
+				 DLVRY_Q_0_BASE_ADDR_HI + (i * 0x14),
+				 upper_32_bits(hisi_hba->cmd_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba, DLVRY_Q_0_BASE_ADDR_LO + (i * 0x14),
+				 lower_32_bits(hisi_hba->cmd_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba, DLVRY_Q_0_DEPTH + (i * 0x14),
+				 HISI_SAS_QUEUE_SLOTS);
+
+		/* Completion queue */
+		hisi_sas_write32(hisi_hba, COMPL_Q_0_BASE_ADDR_HI + (i * 0x14),
+				 upper_32_bits(hisi_hba->complete_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba, COMPL_Q_0_BASE_ADDR_LO + (i * 0x14),
+				 lower_32_bits(hisi_hba->complete_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba, COMPL_Q_0_DEPTH + (i * 0x14),
+				 HISI_SAS_QUEUE_SLOTS);
+	}
+
+	/* itct */
+	hisi_sas_write32(hisi_hba, ITCT_BASE_ADDR_LO,
+			 lower_32_bits(hisi_hba->itct_dma));
+
+	hisi_sas_write32(hisi_hba, ITCT_BASE_ADDR_HI,
+			 upper_32_bits(hisi_hba->itct_dma));
+
+	/* iost */
+	hisi_sas_write32(hisi_hba, IOST_BASE_ADDR_LO,
+			 lower_32_bits(hisi_hba->iost_dma));
+
+	hisi_sas_write32(hisi_hba, IOST_BASE_ADDR_HI,
+			 upper_32_bits(hisi_hba->iost_dma));
+
+	/* breakpoint */
+	hisi_sas_write32(hisi_hba, IO_BROKEN_MSG_ADDR_LO,
+			 lower_32_bits(hisi_hba->breakpoint_dma));
+
+	hisi_sas_write32(hisi_hba, IO_BROKEN_MSG_ADDR_HI,
+			 upper_32_bits(hisi_hba->breakpoint_dma));
+
+	/* SATA broken msg */
+	hisi_sas_write32(hisi_hba, IO_SATA_BROKEN_MSG_ADDR_LO,
+			 lower_32_bits(hisi_hba->sata_breakpoint_dma));
+
+	hisi_sas_write32(hisi_hba, IO_SATA_BROKEN_MSG_ADDR_HI,
+			 upper_32_bits(hisi_hba->sata_breakpoint_dma));
+
+	/* SATA initial fis */
+	hisi_sas_write32(hisi_hba, SATA_INITI_D2H_STORE_ADDR_LO,
+			 lower_32_bits(hisi_hba->initial_fis_dma));
+
+	hisi_sas_write32(hisi_hba, SATA_INITI_D2H_STORE_ADDR_HI,
+			 upper_32_bits(hisi_hba->initial_fis_dma));
+}
+
+static int hw_init_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	int rc;
+
+	rc = reset_hw_v2_hw(hisi_hba);
+	if (rc) {
+		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d", rc);
+		return rc;
+	}
+
+	msleep(100);
+	init_reg_v2_hw(hisi_hba);
+
+	return 0;
+}
+
+static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
+{
+	int rc;
+
+	rc = hw_init_v2_hw(hisi_hba);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
+	.hw_init = hisi_sas_v2_init,
+	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
+	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 };
 
 static int hisi_sas_v2_probe(struct platform_device *pdev)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
