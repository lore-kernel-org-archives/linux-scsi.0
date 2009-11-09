From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 1/7]MVSAS: Update chip initialization
Date: Mon, 9 Nov 2009 19:50:25 +0800
Message-ID: <20091109115025.GA32317@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:54329 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZKICxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 21:53:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, jeff@garzik.org
Cc: qswang@marvell.com, jfeng@marvell.com


>From 60ba00f2f2263c52e4b2f5a614b1800a36f4cb9e Mon Sep 17 00:00:00 2001
From: andy <ayan@marvell.com>
Date: Fri, 6 Nov 2009 16:54:50 +0800
Subject: [PATCH 1/6] Update chip initialization

Update chip init code to enhance performance,correct some settings
for 6G phy negotiation.

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_64xx.c  |   18 +++++++++++++-----
 drivers/scsi/mvsas/mv_94xx.c  |   41 ++++++++++++++++++++++++++++-------------
 drivers/scsi/mvsas/mv_94xx.h  |    5 +++--
 drivers/scsi/mvsas/mv_chips.h |    5 -----
 4 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 10a5077..4c005fa 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -373,15 +373,23 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
 	/* reset CMD queue */
 	tmp = mr32(MVS_PCS);
 	tmp |= PCS_CMD_RST;
+	tmp &= ~PCS_SELF_CLEAR;
+
+	/* enable cmd_cmpl bit self-clearing */
+	if (mvi->flags & MVF_MSI)
+		tmp |= PCS_SELF_CLEAR;
+
 	mw32(MVS_PCS, tmp);
 	/* interrupt coalescing may cause missing HW interrput in some case,
 	 * and the max count is 0x1ff, while our max slot is 0x200,
 	 * it will make count 0.
 	 */
 	tmp = 0;
-	mw32(MVS_INT_COAL, tmp);
-
-	tmp = 0x100;
+	if (MVS_CHIP_SLOT_SZ > 0x1ff)
+		mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+	else
+		mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+	tmp = 0x10400;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -393,8 +401,8 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
 		PCS_CMD_EN | PCS_CMD_STOP_ERR);
 
 	/* enable completion queue interrupt */
-	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS | CINT_CI_STOP |
-		CINT_DMA_PCIE);
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM |
+		CINT_SRS | CINT_CI_STOP | CINT_DMA_PCIE);
 
 	mw32(MVS_INT_MASK, tmp);
 
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 0940fae..f0017fc 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -102,7 +102,9 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	void __iomem *regs = mvi->regs;
 	int i;
 	u32 tmp, cctl;
+	u8 revision;
 
+	revision = mvi->pdev->revision;
 	mvs_show_pcie_usage(mvi);
 	if (mvi->flags & MVF_FLAG_SOC) {
 		tmp = mr32(MVS_PHY_CTL);
@@ -132,6 +134,21 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 		msleep(100);
 	}
 
+	/* disable Multiplexing, enable phy implemented */
+	mw32(MVS_PORTS_IMP, 0xFF);
+
+	if (revision == 0xa0) {
+		mw32(MVS_PA_VSR_ADDR, 0x00000104);
+		mw32(MVS_PA_VSR_PORT, 0x00018080);
+	}
+	mw32(MVS_PA_VSR_ADDR, VSR_PHY_MODE8);
+	mw32(MVS_PA_VSR_PORT, 0x0084d4ff);
+	if (revision == 0x01) {
+		mw32(MVS_PA_VSR_ADDR, 0x00000144);
+		mw32(MVS_PA_VSR_PORT, 0x08001006);
+		mw32(MVS_PA_VSR_ADDR, 0x000001b4);
+		mw32(MVS_PA_VSR_PORT, 0x0000705f);
+	}
 	/* reset control */
 	mw32(MVS_PCS, 0);		/* MVS_PCS */
 	mw32(MVS_STP_REG_SET_0, 0);
@@ -140,14 +157,6 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	/* init phys */
 	mvs_phy_hacks(mvi);
 
-	/* disable Multiplexing, enable phy implemented */
-	mw32(MVS_PORTS_IMP, 0xFF);
-
-
-	mw32(MVS_PA_VSR_ADDR, 0x00000104);
-	mw32(MVS_PA_VSR_PORT, 0x00018080);
-	mw32(MVS_PA_VSR_ADDR, VSR_PHY_MODE8);
-	mw32(MVS_PA_VSR_PORT, 0x0084ffff);
 
 	/* set LED blink when IO*/
 	mw32(MVS_PA_VSR_ADDR, 0x00000030);
@@ -227,15 +236,21 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	/* reset CMD queue */
 	tmp = mr32(MVS_PCS);
 	tmp |= PCS_CMD_RST;
+	tmp &= ~PCS_SELF_CLEAR;
+	/* enable cmd_cmpl bit self-clearing */
+	if (mvi->flags & MVF_MSI)
+		tmp |= PCS_SELF_CLEAR;
 	mw32(MVS_PCS, tmp);
 	/* interrupt coalescing may cause missing HW interrput in some case,
 	 * and the max count is 0x1ff, while our max slot is 0x200,
 	 * it will make count 0.
 	 */
 	tmp = 0;
-	mw32(MVS_INT_COAL, tmp);
-
-	tmp = 0x100;
+	if (MVS_CHIP_SLOT_SZ > 0x1ff)
+		mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+	else
+		mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+	tmp = 0x10400;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -247,8 +262,8 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 		PCS_CMD_EN | PCS_CMD_STOP_ERR);
 
 	/* enable completion queue interrupt */
-	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS | CINT_CI_STOP |
-		CINT_DMA_PCIE);
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM |
+		CINT_SRS | CINT_CI_STOP | CINT_DMA_PCIE);
 	tmp |= CINT_PHY_MASK;
 	mw32(MVS_INT_MASK, tmp);
 
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 23ed9b1..a510ad8 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -100,6 +100,7 @@ enum hw_registers {
 	MVS_P4_VSR_DATA 	= 0x254, /* phy4 VSR data */
 	MVS_PA_VSR_ADDR		= 0x290, /* All port VSR addr */
 	MVS_PA_VSR_PORT		= 0x294, /* All port VSR data */
+	MVS_COMMAND_ACTIVE 	= 0x300, /* ACTIVE COMMAND */
 };
 
 enum pci_cfg_registers {
@@ -129,8 +130,8 @@ enum sas_sata_vsp_regs {
 
 enum chip_register_bits {
 	PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0x7 << 8),
-	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0x7 << 8),
-	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (12),
+	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0x7 << 12),
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (16),
 	PHY_NEG_SPP_PHYS_LINK_RATE_MASK =
 			(0x3 << PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
 };
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
index a67e1c4..68736f4 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -190,11 +190,6 @@ static inline void __devinit mvs_phy_hacks(struct mvs_info *mvi)
 	tmp &= 0x0000ffff;
 	tmp |= 0x00fa0000;
 	mvs_cw32(mvi, CMD_PHY_MODE_21, tmp);
-
-	tmp = mvs_cr32(mvi, CMD_PHY_TIMER);
-	tmp &= 0x1fffffff;
-	tmp |= (2U << 29);	/* 8 ms retry */
-	mvs_cw32(mvi, CMD_PHY_TIMER, tmp);
 }
 
 static inline void mvs_int_sata(struct mvs_info *mvi)
-- 
1.6.2.2

