From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/25] scsi: hisi_sas: add v1 HW initialisation code
Date: Mon, 12 Oct 2015 23:20:24 +0800
Message-ID: <1444663237-238302-13-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12364 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbJLPHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:07:07 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add complete code to initialise HW to the point where
we can get a phy up interrupt when a disk is connected.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  10 +
 drivers/scsi/hisi_sas/hisi_sas_init.c  |  20 ++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 502 +++++++++++++++++++++++++++++++++
 3 files changed, 532 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1a26f27..18fd30b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -34,7 +34,12 @@
 		(((sizeof(union hisi_sas_command_table)+3)/4)*4)
 
 #define HISI_SAS_NAME_LEN 32
+#define HISI_SAS_RESET_REG_CNT 5
 
+enum {
+	PORT_TYPE_SAS = (1U << 1),
+	PORT_TYPE_SATA = (1U << 0),
+};
 
 enum dev_status {
 	HISI_SAS_DEV_NORMAL,
@@ -123,6 +128,7 @@ struct hisi_hba {
 
 	void __iomem *regs;
 	void __iomem *ctrl_regs;
+	u32 reset_reg[HISI_SAS_RESET_REG_CNT];
 
 	u8 sas_addr[SAS_ADDR_SIZE];
 
@@ -323,4 +329,8 @@ union hisi_sas_command_table {
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
 void hisi_sas_wq_process(struct work_struct *work);
+extern int interrupt_init_v1_hw(struct hisi_hba *hisi_hba);
+extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
+extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
+extern int phys_init_v1_hw(struct hisi_hba *hisi_hba);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 558e0e7..67bfa58 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -270,6 +270,11 @@ static struct hisi_hba *hisi_sas_hba_alloc(
 
 	init_timer(&hisi_hba->timer);
 
+	if (of_property_read_u32_array(np, "reset-reg",
+				       (u32 *) &hisi_hba->reset_reg,
+				       HISI_SAS_RESET_REG_CNT))
+		goto err_out;
+
 	if (of_property_read_u32(np, "phy-count", &hisi_hba->n_phy))
 		goto err_out;
 
@@ -387,6 +392,21 @@ static int hisi_sas_probe(struct platform_device *pdev)
 	}
 
 	hisi_sas_init_add(hisi_hba);
+
+	rc = hw_init_v1_hw(hisi_hba);
+	if (rc)
+		goto err_out_ha;
+
+	rc = interrupt_init_v1_hw(hisi_hba);
+	if (rc)
+		goto err_out_ha;
+
+	rc = interrupt_openall_v1_hw(hisi_hba);
+	if (rc)
+		goto err_out_ha;
+
+	phys_init_v1_hw(hisi_hba);
+
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index ccc7aa7..20291b4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -400,3 +400,505 @@ enum {
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
+	u32 reg_val;
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
+	writel(CONTROLLER_RESET_VALUE,
+	       hisi_hba->ctrl_regs + hisi_hba->reset_reg[0]);
+	writel(CONTROLLER_RESET_VALUE,
+	       hisi_hba->ctrl_regs + hisi_hba->reset_reg[1]);
+	msleep(1);
+	reg_val = readl(hisi_hba->ctrl_regs + hisi_hba->reset_reg[2]);
+	if (CONTROLLER_RESET_VALUE != (reg_val & CONTROLLER_RESET_VALUE)) {
+		dev_err(dev, "Reset failed\n");
+		return -EIO;
+	}
+
+	/* De-reset */
+	writel(CONTROLLER_RESET_VALUE,
+	       hisi_hba->ctrl_regs + hisi_hba->reset_reg[3]);
+	writel(CONTROLLER_RESET_VALUE,
+	       hisi_hba->ctrl_regs + hisi_hba->reset_reg[4]);
+	msleep(1);
+	reg_val = readl(hisi_hba->ctrl_regs + hisi_hba->reset_reg[2]);
+	if (reg_val & CONTROLLER_RESET_VALUE) {
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
+	hisi_sas_write32(hisi_hba,
+		DLVRY_QUEUE_ENABLE,
+		(u32)((1ULL << hisi_hba->queue_count) - 1));
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
+
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
+int hw_init_v1_hw(struct hisi_hba *hisi_hba)
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
+void enable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg |= PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
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
+static void phys_up_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x6a);
+		hisi_sas_phy_read32(hisi_hba, i, CHL_INT2_MSK);
+	}
+}
+
+static int start_phy_layer_v1_hw(struct hisi_hba *hisi_hba)
+{
+	struct timer_list *timer = &hisi_hba->timer;
+
+	setup_timer(timer, start_phys_v1_hw, (unsigned long)hisi_hba);
+	mod_timer(timer, jiffies + HZ);
+
+	return 0;
+}
+
+int phys_init_v1_hw(struct hisi_hba *hisi_hba)
+{
+	phys_up_v1_hw(hisi_hba);
+	start_phy_layer_v1_hw(hisi_hba);
+
+	return 0;
+}
+
+/* Interrupts */
+static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int phy_no = sas_phy->id;
+	u32 *frame_rcvd = (u32 *)sas_phy->frame_rcvd;
+	struct sas_identify_frame *id = (struct sas_identify_frame *)frame_rcvd;
+	u32 irq_value, context, port_id, link_rate;
+	int i;
+	irqreturn_t res = IRQ_HANDLED;
+
+	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2);
+
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
+	dev_info(dev, "phyup: phy%d id=%d link_rate=%d\n",
+		 phy_no, hisi_hba->id, link_rate);
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
+
+end:
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
+			CHL_INT2_SL_PHY_ENA_MSK);
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
+
+
+static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
+	{"Phy Up"},
+};
+
+
+static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
+	int_phyup_v1_hw,
+};
+
+int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int i, j, irq, rc, id = hisi_hba->id;
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
+				dev_err(dev, "irq init: [%d] fail map phy interrupt %d\n",
+					hisi_hba->id, idx);
+				return -ENOENT;
+			}
+
+			(void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
+					HISI_SAS_NAME_LEN,
+					DRV_NAME" %s [%d %d]", phy_int_names[j],
+					id, i);
+			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
+					&int_names[idx * HISI_SAS_NAME_LEN],
+					phy);
+			if (rc) {
+				dev_err(dev, "irq init: [%d] could not request "
+					"phy interrupt %d, rc=%d\n",
+					hisi_hba->id, irq, rc);
+				return -ENOENT;
+			}
+		}
+	}
+
+
+	return 0;
+}
+
+int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba)
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
+		hisi_sas_phy_write32(hisi_hba,
+				     i,
+				     CHL_INT0_MSK,
+				     0x3fffff &
+				     ~CHL_INT0_MSK_PHYCTRL_NOTRDY_MSK);
+	}
+
+	return 0;
+}
-- 
1.9.1

