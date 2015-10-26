From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 19/32] scsi: hisi_sas: add v1 HW initialisation code
Date: Mon, 26 Oct 2015 22:14:50 +0800
Message-ID: <1445868903-183817-20-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |   4 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 331 +++++++++++++++++++++++++++++++++
 3 files changed, 336 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 0818101..a186f4d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -84,6 +84,7 @@ struct hisi_sas_slot {
 };
 
 struct hisi_sas_hw {
+	int (*hw_init)(struct hisi_hba *hisi_hba);
 	int complete_hdr_size;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e606b51..46c4c22e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -399,6 +399,10 @@ int hisi_sas_probe(struct platform_device *pdev,
 
 	hisi_sas_init_add(hisi_hba);
 
+	rc = hisi_hba->hw->hw_init(hisi_hba);
+	if (rc)
+		goto err_out_ha;
+
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index d1c9c27..ee0d6b0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -405,7 +405,338 @@ enum {
 	(HISI_SAS_PHY_MAX_INT_NR + HISI_SAS_CQ_MAX_INT_NR +\
 	HISI_SAS_FATAL_INT_NR)
 
+static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	return readl(regs);
+}
+
+static void hisi_sas_write32(struct hisi_hba *hisi_hba,
+				    u32 off, u32 val)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	writel(val, regs);
+}
+
+static void hisi_sas_phy_write32(struct hisi_hba *hisi_hba,
+					int phy_no, u32 off, u32 val)
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
+static void config_phy_opt_mode_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg &= ~PHY_CFG_DC_OPT_MSK;
+	cfg |= 1 << PHY_CFG_DC_OPT_OFF;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
+static void config_tx_tfe_autoneg_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CONFIG2);
+
+	cfg &= ~PHY_CONFIG2_FORCE_TXDEEMPH_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CONFIG2, cfg);
+}
+
+static void config_id_frame_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct sas_identify_frame identify_frame;
+	u32 *identify_buffer;
+
+	memset(&identify_frame, 0, sizeof(identify_frame));
+	identify_frame.dev_type = SAS_END_DEVICE;
+	identify_frame.frame_type = 0;
+	identify_frame._un1 = 1;
+	identify_frame.initiator_bits = SAS_PROTOCOL_ALL;
+	identify_frame.target_bits = SAS_PROTOCOL_NONE;
+	memcpy(&identify_frame._un4_11[0], hisi_hba->sas_addr, SAS_ADDR_SIZE);
+	memcpy(&identify_frame.sas_addr[0], hisi_hba->sas_addr,	SAS_ADDR_SIZE);
+	identify_frame.phy_id = phy_no;
+	identify_buffer = (u32 *)(&identify_frame);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD0,
+			__swab32(identify_buffer[0]));
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD1,
+			identify_buffer[2]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD2,
+			identify_buffer[1]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD3,
+			identify_buffer[4]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD4,
+			identify_buffer[3]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD5,
+			__swab32(identify_buffer[5]));
+}
+
+static void init_id_frame_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		config_id_frame_v1_hw(hisi_hba, i);
+}
+
+static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+	unsigned long end_time;
+	u32 val;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		u32 phy_ctrl = hisi_sas_phy_read32(hisi_hba, i, PHY_CTRL);
+
+		phy_ctrl |= PHY_CTRL_RESET_MSK;
+		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL, phy_ctrl);
+	}
+	msleep(1); /* It is safe to wait for 50us */
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
+	/* Apply reset */
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reg[0], RESET_VALUE);
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reg[1], RESET_VALUE);
+	msleep(1);
+	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reg[2], &val);
+	if (RESET_VALUE != (val & RESET_VALUE)) {
+		dev_err(dev, "Reset failed\n");
+		return -EIO;
+	}
+
+	/* De-reset */
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reg[3], RESET_VALUE);
+	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reg[4], RESET_VALUE);
+	msleep(1);
+	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reg[2], &val);
+	if (val & RESET_VALUE) {
+		dev_err(dev, "De-reset failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void init_reg_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	/* Global registers init*/
+	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
+			 (u32)((1ULL << hisi_hba->queue_count) - 1));
+	hisi_sas_write32(hisi_hba, HGC_TRANS_TASK_CNT_LIMIT, 0x11);
+	hisi_sas_write32(hisi_hba, DEVICE_MSG_WORK_MODE, 0x1);
+	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x1ff);
+	hisi_sas_write32(hisi_hba, HGC_ERR_STAT_EN, 0x401);
+	hisi_sas_write32(hisi_hba, CFG_1US_TIMER_TRSH, 0x64);
+	hisi_sas_write32(hisi_hba, HGC_GET_ITV_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, I_T_NEXUS_LOSS_TIME, 0x64);
+	hisi_sas_write32(hisi_hba, BUS_INACTIVE_LIMIT_TIME, 0x2710);
+	hisi_sas_write32(hisi_hba, REJECT_TO_OPEN_LIMIT_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x7a12);
+	hisi_sas_write32(hisi_hba, HGC_DFX_CFG2, 0x9c40);
+	hisi_sas_write32(hisi_hba, FIS_LIST_BADDR_L, 0x2);
+	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0xc);
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x186a0);
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 1);
+	hisi_sas_write32(hisi_hba, ENT_INT_COAL_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, ENT_INT_COAL_CNT, 0x1);
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 0xffffffff);
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC_MSK, 0);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC1, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC2, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0);
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0);
+	hisi_sas_write32(hisi_hba, AXI_AHB_CLK_CFG, 0x2);
+	hisi_sas_write32(hisi_hba, CFG_SAS_CONFIG, 0x22000000);
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE, 0x88a);
+		hisi_sas_phy_write32(hisi_hba, i, PHY_CONFIG2, 0x7c080);
+		hisi_sas_phy_write32(hisi_hba, i, PHY_RATE_NEGO, 0x415ee00);
+		hisi_sas_phy_write32(hisi_hba, i, PHY_PCN, 0x80a80000);
+		hisi_sas_phy_write32(hisi_hba, i, SL_TOUT_CFG, 0x7d7d7d7d);
+		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, RXOP_CHECK_CFG_H, 0x1000);
+		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 0);
+		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER, 0x13f0a);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT_COAL_EN, 3);
+		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 8);
+	}
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		/* Delivery queue */
+		hisi_sas_write32(hisi_hba,
+				 DLVRY_Q_0_BASE_ADDR_HI + (i * 0x14),
+				 upper_32_bits(hisi_hba->cmd_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba,
+				 DLVRY_Q_0_BASE_ADDR_LO + (i * 0x14),
+				 lower_32_bits(hisi_hba->cmd_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba,
+				 DLVRY_Q_0_DEPTH + (i * 0x14),
+				 HISI_SAS_QUEUE_SLOTS);
+
+		/* Completion queue */
+		hisi_sas_write32(hisi_hba,
+				 COMPL_Q_0_BASE_ADDR_HI + (i * 0x14),
+				 upper_32_bits(hisi_hba->complete_hdr_dma[i]));
+
+		hisi_sas_write32(hisi_hba,
+				 COMPL_Q_0_BASE_ADDR_LO + (i * 0x14),
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
+	hisi_sas_write32(hisi_hba, BROKEN_MSG_ADDR_LO,
+			 lower_32_bits(hisi_hba->breakpoint_dma));
+
+	hisi_sas_write32(hisi_hba, BROKEN_MSG_ADDR_HI,
+			 upper_32_bits(hisi_hba->breakpoint_dma));
+}
+
+static int hw_init_v1_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	int rc;
+
+	rc = reset_hw_v1_hw(hisi_hba);
+	if (rc) {
+		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d", rc);
+		return rc;
+	}
+
+	msleep(100);
+	init_reg_v1_hw(hisi_hba);
+
+	init_id_frame_v1_hw(hisi_hba);
+
+	return 0;
+}
+
+static void enable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg |= PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
+static void start_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	config_id_frame_v1_hw(hisi_hba, phy_no);
+	config_phy_opt_mode_v1_hw(hisi_hba, phy_no);
+	config_tx_tfe_autoneg_v1_hw(hisi_hba, phy_no);
+	enable_phy_v1_hw(hisi_hba, phy_no);
+}
+
+static void start_phys_v1_hw(unsigned long data)
+{
+	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x12a);
+		start_phy_v1_hw(hisi_hba, i);
+	}
+}
+
+static void phys_init_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+	struct timer_list *timer = &hisi_hba->timer;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x6a);
+		hisi_sas_phy_read32(hisi_hba, i, CHL_INT2_MSK);
+	}
+
+	setup_timer(timer, start_phys_v1_hw, (unsigned long)hisi_hba);
+	mod_timer(timer, jiffies + HZ);
+}
+
+static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
+{
+	int rc;
+
+	rc = hw_init_v1_hw(hisi_hba);
+	if (rc)
+		return rc;
+
+	phys_init_v1_hw(hisi_hba);
+
+	return 0;
+}
+
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
+	.hw_init = hisi_sas_v1_init,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
