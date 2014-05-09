From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH v2] [PATCH] drivers: scsi: mvsas: fix compiling issue by adding
 'MVS_' for "enum pci_interrupt_cause"
Date: Fri, 09 May 2014 09:19:39 +0800
Message-ID: <536C2D2B.6090501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The direct cause is IRQ_SPI is already defined as a macro in unicore32
architecture (also, blackfin and mips architectures define it). The
related error (unicore32  with allmodconfig)

    CC [M]  drivers/scsi/mvsas/mv_94xx.o
  In file included from drivers/scsi/mvsas/mv_94xx.c:27:
  drivers/scsi/mvsas/mv_94xx.h:176: error: expected identifier before numeric constant

And IRQ_SAS_A and IRQ_SAS_B are used as 'u32' (although "enum
pci_interrupt_cause" is not used directly, now).

All together, need add 'MVS_' for "enum pci_interrupt_cause".


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/mvsas/mv_94xx.c | 10 ++++----
 drivers/scsi/mvsas/mv_94xx.h | 58 ++++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 1e4479f..9270d15 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -564,7 +564,7 @@ static void mvs_94xx_interrupt_enable(struct mvs_info *mvi)
 	u32 tmp;
 
 	tmp = mr32(MVS_GBL_CTL);
-	tmp |= (IRQ_SAS_A | IRQ_SAS_B);
+	tmp |= (MVS_IRQ_SAS_A | MVS_IRQ_SAS_B);
 	mw32(MVS_GBL_INT_STAT, tmp);
 	writel(tmp, regs + 0x0C);
 	writel(tmp, regs + 0x10);
@@ -580,7 +580,7 @@ static void mvs_94xx_interrupt_disable(struct mvs_info *mvi)
 
 	tmp = mr32(MVS_GBL_CTL);
 
-	tmp &= ~(IRQ_SAS_A | IRQ_SAS_B);
+	tmp &= ~(MVS_IRQ_SAS_A | MVS_IRQ_SAS_B);
 	mw32(MVS_GBL_INT_STAT, tmp);
 	writel(tmp, regs + 0x0C);
 	writel(tmp, regs + 0x10);
@@ -596,7 +596,7 @@ static u32 mvs_94xx_isr_status(struct mvs_info *mvi, int irq)
 	if (!(mvi->flags & MVF_FLAG_SOC)) {
 		stat = mr32(MVS_GBL_INT_STAT);
 
-		if (!(stat & (IRQ_SAS_A | IRQ_SAS_B)))
+		if (!(stat & (MVS_IRQ_SAS_A | MVS_IRQ_SAS_B)))
 			return 0;
 	}
 	return stat;
@@ -606,8 +606,8 @@ static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32 stat)
 {
 	void __iomem *regs = mvi->regs;
 
-	if (((stat & IRQ_SAS_A) && mvi->id == 0) ||
-			((stat & IRQ_SAS_B) && mvi->id == 1)) {
+	if (((stat & MVS_IRQ_SAS_A) && mvi->id == 0) ||
+			((stat & MVS_IRQ_SAS_B) && mvi->id == 1)) {
 		mw32_f(MVS_INT_STAT, CINT_DONE);
 
 		spin_lock(&mvi->lock);
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 487aa6f..14e1974 100644
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
+	MVS_IRQ_COM_IN_I2O_IOP0        = (1 << 0),
+	MVS_IRQ_COM_IN_I2O_IOP1        = (1 << 1),
+	MVS_IRQ_COM_IN_I2O_IOP2        = (1 << 2),
+	MVS_IRQ_COM_IN_I2O_IOP3        = (1 << 3),
+	MVS_IRQ_COM_OUT_I2O_HOS0       = (1 << 4),
+	MVS_IRQ_COM_OUT_I2O_HOS1       = (1 << 5),
+	MVS_IRQ_COM_OUT_I2O_HOS2       = (1 << 6),
+	MVS_IRQ_COM_OUT_I2O_HOS3       = (1 << 7),
+	MVS_IRQ_PCIF_TO_CPU_DRBL0      = (1 << 8),
+	MVS_IRQ_PCIF_TO_CPU_DRBL1      = (1 << 9),
+	MVS_IRQ_PCIF_TO_CPU_DRBL2      = (1 << 10),
+	MVS_IRQ_PCIF_TO_CPU_DRBL3      = (1 << 11),
+	MVS_IRQ_PCIF_DRBL0             = (1 << 12),
+	MVS_IRQ_PCIF_DRBL1             = (1 << 13),
+	MVS_IRQ_PCIF_DRBL2             = (1 << 14),
+	MVS_IRQ_PCIF_DRBL3             = (1 << 15),
+	MVS_IRQ_XOR_A                  = (1 << 16),
+	MVS_IRQ_XOR_B                  = (1 << 17),
+	MVS_IRQ_SAS_A                  = (1 << 18),
+	MVS_IRQ_SAS_B                  = (1 << 19),
+	MVS_IRQ_CPU_CNTRL              = (1 << 20),
+	MVS_IRQ_GPIO                   = (1 << 21),
+	MVS_IRQ_UART                   = (1 << 22),
+	MVS_IRQ_SPI                    = (1 << 23),
+	MVS_IRQ_I2C                    = (1 << 24),
+	MVS_IRQ_SGPIO                  = (1 << 25),
+	MVS_IRQ_COM_ERR                = (1 << 29),
+	MVS_IRQ_I2O_ERR                = (1 << 30),
+	MVS_IRQ_PCIE_ERR               = (1 << 31),
 };
 
 union reg_phy_cfg {
-- 
1.9.2.459.g68773ac
