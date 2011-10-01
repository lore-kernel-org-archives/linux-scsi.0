From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/26] scsi/mvsas: use proper namespace for IRQ_* symbols
Date: Sat,  1 Oct 2011 22:03:35 +0200
Message-ID: <1317499438-14058-4-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1JAUE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2011 16:04:59 -0400
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>, Haojian Zhuang <haojian.zhuang@marvell.com>, Arnd Bergmann <arnd@arndb.de>, Xiangliang Yu <yuxiangl@marvell.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

The identifiers in the mvsas driver conflict with platform specific
interrupt definitions of the same name, so better prefix them
with MVS_ to avoid the collision.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mvsas/mv_94xx.c |   10 +++---
 drivers/scsi/mvsas/mv_94xx.h |   58 +++++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 3501291..9c12e03 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -534,7 +534,7 @@ static void mvs_94xx_interrupt_enable(struct mvs_info *mvi)
 	u32 tmp;
 
 	tmp = mr32(MVS_GBL_CTL);
-	tmp |= (IRQ_SAS_A | IRQ_SAS_B);
+	tmp |= (MVS_IRQ_SAS_A | MVS_IRQ_SAS_B);
 	mw32(MVS_GBL_INT_STAT, tmp);
 	writel(tmp, regs + 0x0C);
 	writel(tmp, regs + 0x10);
@@ -550,7 +550,7 @@ static void mvs_94xx_interrupt_disable(struct mvs_info *mvi)
 
 	tmp = mr32(MVS_GBL_CTL);
 
-	tmp &= ~(IRQ_SAS_A | IRQ_SAS_B);
+	tmp &= ~(MVS_IRQ_SAS_A | MVS_IRQ_SAS_B);
 	mw32(MVS_GBL_INT_STAT, tmp);
 	writel(tmp, regs + 0x0C);
 	writel(tmp, regs + 0x10);
@@ -566,7 +566,7 @@ static u32 mvs_94xx_isr_status(struct mvs_info *mvi, int irq)
 	if (!(mvi->flags & MVF_FLAG_SOC)) {
 		stat = mr32(MVS_GBL_INT_STAT);
 
-		if (!(stat & (IRQ_SAS_A | IRQ_SAS_B)))
+		if (!(stat & (MVS_IRQ_SAS_A | MVS_IRQ_SAS_B)))
 			return 0;
 	}
 	return stat;
@@ -576,8 +576,8 @@ static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32 stat)
 {
 	void __iomem *regs = mvi->regs;
 
-	if (((stat & IRQ_SAS_A) && mvi->id == 0) ||
-			((stat & IRQ_SAS_B) && mvi->id == 1)) {
+	if (((stat & MVS_IRQ_SAS_A) && mvi->id == 0) ||
+			((stat & MVS_IRQ_SAS_B) && mvi->id == 1)) {
 		mw32_f(MVS_INT_STAT, CINT_DONE);
 
 		spin_lock(&mvi->lock);
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 8f7eb4f..5bc7656 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -150,35 +150,35 @@ enum chip_register_bits {
 
 enum pci_interrupt_cause {
 	/*  MAIN_IRQ_CAUSE (R10200) Bits*/
-	IRQ_COM_IN_I2O_IOP0            = (1 << 0),
-	IRQ_COM_IN_I2O_IOP1            = (1 << 1),
-	IRQ_COM_IN_I2O_IOP2            = (1 << 2),
-	IRQ_COM_IN_I2O_IOP3            = (1 << 3),
-	IRQ_COM_OUT_I2O_HOS0           = (1 << 4),
-	IRQ_COM_OUT_I2O_HOS1           = (1 << 5),
-	IRQ_COM_OUT_I2O_HOS2           = (1 << 6),
-	IRQ_COM_OUT_I2O_HOS3           = (1 << 7),
-	IRQ_PCIF_TO_CPU_DRBL0          = (1 << 8),
-	IRQ_PCIF_TO_CPU_DRBL1          = (1 << 9),
-	IRQ_PCIF_TO_CPU_DRBL2          = (1 << 10),
-	IRQ_PCIF_TO_CPU_DRBL3          = (1 << 11),
-	IRQ_PCIF_DRBL0                 = (1 << 12),
-	IRQ_PCIF_DRBL1                 = (1 << 13),
-	IRQ_PCIF_DRBL2                 = (1 << 14),
-	IRQ_PCIF_DRBL3                 = (1 << 15),
-	IRQ_XOR_A                      = (1 << 16),
-	IRQ_XOR_B                      = (1 << 17),
-	IRQ_SAS_A                      = (1 << 18),
-	IRQ_SAS_B                      = (1 << 19),
-	IRQ_CPU_CNTRL                  = (1 << 20),
-	IRQ_GPIO                       = (1 << 21),
-	IRQ_UART                       = (1 << 22),
-	IRQ_SPI                        = (1 << 23),
-	IRQ_I2C                        = (1 << 24),
-	IRQ_SGPIO                      = (1 << 25),
-	IRQ_COM_ERR                    = (1 << 29),
-	IRQ_I2O_ERR                    = (1 << 30),
-	IRQ_PCIE_ERR                   = (1 << 31),
+	MVS_IRQ_COM_IN_I2O_IOP0            = (1 << 0),
+	MVS_IRQ_COM_IN_I2O_IOP1            = (1 << 1),
+	MVS_IRQ_COM_IN_I2O_IOP2            = (1 << 2),
+	MVS_IRQ_COM_IN_I2O_IOP3            = (1 << 3),
+	MVS_IRQ_COM_OUT_I2O_HOS0           = (1 << 4),
+	MVS_IRQ_COM_OUT_I2O_HOS1           = (1 << 5),
+	MVS_IRQ_COM_OUT_I2O_HOS2           = (1 << 6),
+	MVS_IRQ_COM_OUT_I2O_HOS3           = (1 << 7),
+	MVS_IRQ_PCIF_TO_CPU_DRBL0          = (1 << 8),
+	MVS_IRQ_PCIF_TO_CPU_DRBL1          = (1 << 9),
+	MVS_IRQ_PCIF_TO_CPU_DRBL2          = (1 << 10),
+	MVS_IRQ_PCIF_TO_CPU_DRBL3          = (1 << 11),
+	MVS_IRQ_PCIF_DRBL0                 = (1 << 12),
+	MVS_IRQ_PCIF_DRBL1                 = (1 << 13),
+	MVS_IRQ_PCIF_DRBL2                 = (1 << 14),
+	MVS_IRQ_PCIF_DRBL3                 = (1 << 15),
+	MVS_IRQ_XOR_A                      = (1 << 16),
+	MVS_IRQ_XOR_B                      = (1 << 17),
+	MVS_IRQ_SAS_A                      = (1 << 18),
+	MVS_IRQ_SAS_B                      = (1 << 19),
+	MVS_IRQ_CPU_CNTRL                  = (1 << 20),
+	MVS_IRQ_GPIO                       = (1 << 21),
+	MVS_IRQ_UART                       = (1 << 22),
+	MVS_IRQ_SPI                        = (1 << 23),
+	MVS_IRQ_I2C                        = (1 << 24),
+	MVS_IRQ_SGPIO                      = (1 << 25),
+	MVS_IRQ_COM_ERR                    = (1 << 29),
+	MVS_IRQ_I2O_ERR                    = (1 << 30),
+	MVS_IRQ_PCIE_ERR                   = (1 << 31),
 };
 
 union reg_phy_cfg {
-- 
1.7.5.4

