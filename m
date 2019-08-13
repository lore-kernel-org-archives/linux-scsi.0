Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2287AC32753
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D449D20665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d3g5BTho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfHMHZc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:25:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMHZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2TWbhhl2LAlCGPgVDVZf1/2nM9NMXeFRfLqZwHts8K4=; b=d3g5BThoUO45/fm1GYNZQAxP3a
        BZh8YSFbIZtjDNZjXDFGyhmXMrR1L0G02s6xXKjpQXwW4+O/yg/yMX4iqphrSlVkQUohAzBH3Otfr
        32ScLVJdDwfN/s+KjbYwX4UTtXo3VjCu5BLilI3hvjoXZkdVSyj665zmOY4e6xHqxSgs6ona8yLK7
        tEX2vEgOn0gE/CSxiuYOsm6qLCyooJ+w98v6gCKdGuPSJJuuRWlWOAfrhSNuxF7P0WPZqjsjWjsRS
        M5ls+LqmOOgtKxy4GGyRpIOq9UABcO9F7Cu0ymxMOQNtP0jUvNGlXCsMQRBi6H6HVTTCKZ5N+x54F
        qX8XdW3g==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBQ-00065i-Gw; Tue, 13 Aug 2019 07:25:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/28] ide: remove the sgiioc4 driver
Date:   Tue, 13 Aug 2019 09:24:50 +0200
Message-Id: <20190813072514.23299-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SGI SN2 support is about to be removed.  Remove this driver that
depends on the SN2 support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/configs/generic_defconfig   |   1 -
 arch/ia64/configs/gensparse_defconfig |   1 -
 drivers/Kconfig                       |   2 -
 drivers/ide/Kconfig                   |   9 -
 drivers/ide/Makefile                  |   1 -
 drivers/ide/sgiioc4.c                 | 630 --------------------------
 6 files changed, 644 deletions(-)
 delete mode 100644 drivers/ide/sgiioc4.c

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 79b88384c885..a41afb3ef209 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -51,7 +51,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_GENERIC=y
 CONFIG_BLK_DEV_CMD64X=y
 CONFIG_BLK_DEV_PIIX=y
-CONFIG_BLK_DEV_SGIIOC4=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index f1490580ed69..07484aa6f16f 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -44,7 +44,6 @@ CONFIG_IDE_GENERIC=y
 CONFIG_BLK_DEV_GENERIC=y
 CONFIG_BLK_DEV_CMD64X=y
 CONFIG_BLK_DEV_PIIX=y
-CONFIG_BLK_DEV_SGIIOC4=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 61cf4ea2c229..477d63d0364d 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -30,8 +30,6 @@ source "drivers/block/Kconfig"
 
 source "drivers/nvme/Kconfig"
 
-# misc before ide - BLK_DEV_SGIIOC4 depends on SGI_IOC4
-
 source "drivers/misc/Kconfig"
 
 source "drivers/ide/Kconfig"
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 9eada392df15..1c227ea8ecd3 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -567,15 +567,6 @@ config BLK_DEV_SVWKS
 	  This driver adds PIO/(U)DMA support for the ServerWorks OSB4/CSB5
 	  chipsets.
 
-config BLK_DEV_SGIIOC4
-	tristate "Silicon Graphics IOC4 chipset ATA/ATAPI support"
-	depends on (IA64_SGI_SN2 || IA64_GENERIC) && SGI_IOC4
-	select BLK_DEV_IDEDMA_PCI
-	help
-	  This driver adds PIO & MultiMode DMA-2 support for the SGI IOC4
-	  chipset, which has one channel and can support two devices.
-	  Please say Y here if you have an Altix System from SGI.
-
 config BLK_DEV_SIIMAGE
 	tristate "Silicon Image chipset support"
 	select BLK_DEV_IDEDMA_PCI
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 9f617a77970f..cac02db4098d 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -59,7 +59,6 @@ obj-$(CONFIG_BLK_DEV_PDC202XX_NEW)	+= pdc202xx_new.o
 obj-$(CONFIG_BLK_DEV_PIIX)		+= piix.o
 obj-$(CONFIG_BLK_DEV_RZ1000)		+= rz1000.o
 obj-$(CONFIG_BLK_DEV_SVWKS)		+= serverworks.o
-obj-$(CONFIG_BLK_DEV_SGIIOC4)		+= sgiioc4.o
 obj-$(CONFIG_BLK_DEV_SIIMAGE)		+= siimage.o
 obj-$(CONFIG_BLK_DEV_SIS5513)		+= sis5513.o
 obj-$(CONFIG_BLK_DEV_SL82C105)		+= sl82c105.o
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
deleted file mode 100644
index 2d35e9f7516f..000000000000
--- a/drivers/ide/sgiioc4.c
+++ /dev/null
@@ -1,630 +0,0 @@
-/*
- * Copyright (c) 2003-2006 Silicon Graphics, Inc.  All Rights Reserved.
- * Copyright (C) 2008-2009 MontaVista Software, Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * For further information regarding this notice, see:
- *
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/scatterlist.h>
-#include <linux/ioc4.h>
-#include <linux/io.h>
-#include <linux/ide.h>
-
-#define DRV_NAME "SGIIOC4"
-
-/* IOC4 Specific Definitions */
-#define IOC4_CMD_OFFSET		0x100
-#define IOC4_CTRL_OFFSET	0x120
-#define IOC4_DMA_OFFSET		0x140
-#define IOC4_INTR_OFFSET	0x0
-
-#define IOC4_TIMING		0x00
-#define IOC4_DMA_PTR_L		0x01
-#define IOC4_DMA_PTR_H		0x02
-#define IOC4_DMA_ADDR_L		0x03
-#define IOC4_DMA_ADDR_H		0x04
-#define IOC4_BC_DEV		0x05
-#define IOC4_BC_MEM		0x06
-#define	IOC4_DMA_CTRL		0x07
-#define	IOC4_DMA_END_ADDR	0x08
-
-/* Bits in the IOC4 Control/Status Register */
-#define	IOC4_S_DMA_START	0x01
-#define	IOC4_S_DMA_STOP		0x02
-#define	IOC4_S_DMA_DIR		0x04
-#define	IOC4_S_DMA_ACTIVE	0x08
-#define	IOC4_S_DMA_ERROR	0x10
-#define	IOC4_ATA_MEMERR		0x02
-
-/* Read/Write Directions */
-#define	IOC4_DMA_WRITE		0x04
-#define	IOC4_DMA_READ		0x00
-
-/* Interrupt Register Offsets */
-#define IOC4_INTR_REG		0x03
-#define	IOC4_INTR_SET		0x05
-#define	IOC4_INTR_CLEAR		0x07
-
-#define IOC4_IDE_CACHELINE_SIZE	128
-#define IOC4_CMD_CTL_BLK_SIZE	0x20
-#define IOC4_SUPPORTED_FIRMWARE_REV 46
-
-struct ioc4_dma_regs {
-	u32 timing_reg0;
-	u32 timing_reg1;
-	u32 low_mem_ptr;
-	u32 high_mem_ptr;
-	u32 low_mem_addr;
-	u32 high_mem_addr;
-	u32 dev_byte_count;
-	u32 mem_byte_count;
-	u32 status;
-};
-
-/* Each Physical Region Descriptor Entry size is 16 bytes (2 * 64 bits) */
-/* IOC4 has only 1 IDE channel */
-#define IOC4_PRD_BYTES		16
-#define IOC4_PRD_ENTRIES	(PAGE_SIZE / (4 * IOC4_PRD_BYTES))
-
-
-static void sgiioc4_init_hwif_ports(struct ide_hw *hw,
-				    unsigned long data_port,
-				    unsigned long ctrl_port,
-				    unsigned long irq_port)
-{
-	unsigned long reg = data_port;
-	int i;
-
-	/* Registers are word (32 bit) aligned */
-	for (i = 0; i <= 7; i++)
-		hw->io_ports_array[i] = reg + i * 4;
-
-	hw->io_ports.ctl_addr = ctrl_port;
-	hw->io_ports.irq_addr = irq_port;
-}
-
-static int sgiioc4_checkirq(ide_hwif_t *hwif)
-{
-	unsigned long intr_addr = hwif->io_ports.irq_addr + IOC4_INTR_REG * 4;
-
-	if (readl((void __iomem *)intr_addr) & 0x03)
-		return 1;
-
-	return 0;
-}
-
-static u8 sgiioc4_read_status(ide_hwif_t *);
-
-static int sgiioc4_clearirq(ide_drive_t *drive)
-{
-	u32 intr_reg;
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long other_ir = io_ports->irq_addr + (IOC4_INTR_REG << 2);
-
-	/* Code to check for PCI error conditions */
-	intr_reg = readl((void __iomem *)other_ir);
-	if (intr_reg & 0x03) { /* Valid IOC4-IDE interrupt */
-		/*
-		 * Using sgiioc4_read_status to read the Status register has a
-		 * side effect of clearing the interrupt.  The first read should
-		 * clear it if it is set.  The second read should return
-		 * a "clear" status if it got cleared.  If not, then spin
-		 * for a bit trying to clear it.
-		 */
-		u8 stat = sgiioc4_read_status(hwif);
-		int count = 0;
-
-		stat = sgiioc4_read_status(hwif);
-		while ((stat & ATA_BUSY) && (count++ < 100)) {
-			udelay(1);
-			stat = sgiioc4_read_status(hwif);
-		}
-
-		if (intr_reg & 0x02) {
-			struct pci_dev *dev = to_pci_dev(hwif->dev);
-			/* Error when transferring DMA data on PCI bus */
-			u32 pci_err_addr_low, pci_err_addr_high,
-			    pci_stat_cmd_reg;
-
-			pci_err_addr_low =
-				readl((void __iomem *)io_ports->irq_addr);
-			pci_err_addr_high =
-				readl((void __iomem *)(io_ports->irq_addr + 4));
-			pci_read_config_dword(dev, PCI_COMMAND,
-					      &pci_stat_cmd_reg);
-			printk(KERN_ERR "%s(%s): PCI Bus Error when doing DMA: "
-			       "status-cmd reg is 0x%x\n",
-			       __func__, drive->name, pci_stat_cmd_reg);
-			printk(KERN_ERR "%s(%s): PCI Error Address is 0x%x%x\n",
-			       __func__, drive->name,
-			       pci_err_addr_high, pci_err_addr_low);
-			/* Clear the PCI Error indicator */
-			pci_write_config_dword(dev, PCI_COMMAND, 0x00000146);
-		}
-
-		/* Clear the Interrupt, Error bits on the IOC4 */
-		writel(0x03, (void __iomem *)other_ir);
-
-		intr_reg = readl((void __iomem *)other_ir);
-	}
-
-	return intr_reg & 3;
-}
-
-static void sgiioc4_dma_start(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned long ioc4_dma_addr = hwif->dma_base + IOC4_DMA_CTRL * 4;
-	unsigned int reg = readl((void __iomem *)ioc4_dma_addr);
-	unsigned int temp_reg = reg | IOC4_S_DMA_START;
-
-	writel(temp_reg, (void __iomem *)ioc4_dma_addr);
-}
-
-static u32 sgiioc4_ide_dma_stop(ide_hwif_t *hwif, u64 dma_base)
-{
-	unsigned long ioc4_dma_addr = dma_base + IOC4_DMA_CTRL * 4;
-	u32	ioc4_dma;
-	int	count;
-
-	count = 0;
-	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
-	while ((ioc4_dma & IOC4_S_DMA_STOP) && (count++ < 200)) {
-		udelay(1);
-		ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
-	}
-	return ioc4_dma;
-}
-
-/* Stops the IOC4 DMA Engine */
-static int sgiioc4_dma_end(ide_drive_t *drive)
-{
-	u32 ioc4_dma, bc_dev, bc_mem, num, valid = 0, cnt = 0;
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned long dma_base = hwif->dma_base;
-	int dma_stat = 0;
-	unsigned long *ending_dma = ide_get_hwifdata(hwif);
-
-	writel(IOC4_S_DMA_STOP, (void __iomem *)(dma_base + IOC4_DMA_CTRL * 4));
-
-	ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
-
-	if (ioc4_dma & IOC4_S_DMA_STOP) {
-		printk(KERN_ERR
-		       "%s(%s): IOC4 DMA STOP bit is still 1 :"
-		       "ioc4_dma_reg 0x%x\n",
-		       __func__, drive->name, ioc4_dma);
-		dma_stat = 1;
-	}
-
-	/*
-	 * The IOC4 will DMA 1's to the ending DMA area to indicate that
-	 * previous data DMA is complete.  This is necessary because of relaxed
-	 * ordering between register reads and DMA writes on the Altix.
-	 */
-	while ((cnt++ < 200) && (!valid)) {
-		for (num = 0; num < 16; num++) {
-			if (ending_dma[num]) {
-				valid = 1;
-				break;
-			}
-		}
-		udelay(1);
-	}
-	if (!valid) {
-		printk(KERN_ERR "%s(%s) : DMA incomplete\n", __func__,
-		       drive->name);
-		dma_stat = 1;
-	}
-
-	bc_dev = readl((void __iomem *)(dma_base + IOC4_BC_DEV * 4));
-	bc_mem = readl((void __iomem *)(dma_base + IOC4_BC_MEM * 4));
-
-	if ((bc_dev & 0x01FF) || (bc_mem & 0x1FF)) {
-		if (bc_dev > bc_mem + 8) {
-			printk(KERN_ERR
-			       "%s(%s): WARNING!! byte_count_dev %d "
-			       "!= byte_count_mem %d\n",
-			       __func__, drive->name, bc_dev, bc_mem);
-		}
-	}
-
-	return dma_stat;
-}
-
-static void sgiioc4_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-}
-
-/* Returns 1 if DMA IRQ issued, 0 otherwise */
-static int sgiioc4_dma_test_irq(ide_drive_t *drive)
-{
-	return sgiioc4_checkirq(drive->hwif);
-}
-
-static void sgiioc4_dma_host_set(ide_drive_t *drive, int on)
-{
-	if (!on)
-		sgiioc4_clearirq(drive);
-}
-
-static void sgiioc4_resetproc(ide_drive_t *drive)
-{
-	struct ide_cmd *cmd = &drive->hwif->cmd;
-
-	sgiioc4_dma_end(drive);
-	ide_dma_unmap_sg(drive, cmd);
-	sgiioc4_clearirq(drive);
-}
-
-static void sgiioc4_dma_lost_irq(ide_drive_t *drive)
-{
-	sgiioc4_resetproc(drive);
-
-	ide_dma_lost_irq(drive);
-}
-
-static u8 sgiioc4_read_status(ide_hwif_t *hwif)
-{
-	unsigned long port = hwif->io_ports.status_addr;
-	u8 reg = (u8) readb((void __iomem *) port);
-
-	if (!(reg & ATA_BUSY)) {	/* Not busy... check for interrupt */
-		unsigned long other_ir = port - 0x110;
-		unsigned int intr_reg = (u32) readl((void __iomem *) other_ir);
-
-		/* Clear the Interrupt, Error bits on the IOC4 */
-		if (intr_reg & 0x03) {
-			writel(0x03, (void __iomem *) other_ir);
-			intr_reg = (u32) readl((void __iomem *) other_ir);
-		}
-	}
-
-	return reg;
-}
-
-/* Creates a DMA map for the scatter-gather list entries */
-static int ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
-	int num_ports = sizeof(struct ioc4_dma_regs);
-	void *pad;
-
-	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
-
-	if (request_mem_region(dma_base, num_ports, hwif->name) == NULL) {
-		printk(KERN_ERR "%s(%s) -- ERROR: addresses 0x%08lx to 0x%08lx "
-		       "already in use\n", __func__, hwif->name,
-		       dma_base, dma_base + num_ports - 1);
-		return -1;
-	}
-
-	hwif->dma_base = (unsigned long)hwif->io_ports.irq_addr +
-			 IOC4_DMA_OFFSET;
-
-	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
-
-	hwif->prd_max_nents = IOC4_PRD_ENTRIES;
-	hwif->prd_ent_size = IOC4_PRD_BYTES;
-
-	if (ide_allocate_dma_engine(hwif))
-		goto dma_pci_alloc_failure;
-
-	pad = dma_alloc_coherent(&dev->dev, IOC4_IDE_CACHELINE_SIZE,
-				   (dma_addr_t *)&hwif->extra_base, GFP_KERNEL);
-	if (pad) {
-		ide_set_hwifdata(hwif, pad);
-		return 0;
-	}
-
-	ide_release_dma_engine(hwif);
-
-	printk(KERN_ERR "%s(%s) -- ERROR: Unable to allocate DMA maps\n",
-	       __func__, hwif->name);
-	printk(KERN_INFO "%s: changing from DMA to PIO mode", hwif->name);
-
-dma_pci_alloc_failure:
-	release_mem_region(dma_base, num_ports);
-
-	return -1;
-}
-
-/* Initializes the IOC4 DMA Engine */
-static void sgiioc4_configure_for_dma(int dma_direction, ide_drive_t *drive)
-{
-	u32 ioc4_dma;
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned long dma_base = hwif->dma_base;
-	unsigned long ioc4_dma_addr = dma_base + IOC4_DMA_CTRL * 4;
-	u32 dma_addr, ending_dma_addr;
-
-	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
-
-	if (ioc4_dma & IOC4_S_DMA_ACTIVE) {
-		printk(KERN_WARNING "%s(%s): Warning!! DMA from previous "
-		       "transfer was still active\n", __func__, drive->name);
-		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
-		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
-
-		if (ioc4_dma & IOC4_S_DMA_STOP)
-			printk(KERN_ERR "%s(%s): IOC4 DMA STOP bit is "
-			       "still 1\n", __func__, drive->name);
-	}
-
-	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
-	if (ioc4_dma & IOC4_S_DMA_ERROR) {
-		printk(KERN_WARNING "%s(%s): Warning!! DMA Error during "
-		       "previous transfer, status 0x%x\n",
-		       __func__, drive->name, ioc4_dma);
-		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
-		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
-
-		if (ioc4_dma & IOC4_S_DMA_STOP)
-			printk(KERN_ERR "%s(%s): IOC4 DMA STOP bit is "
-			       "still 1\n", __func__, drive->name);
-	}
-
-	/* Address of the Scatter Gather List */
-	dma_addr = cpu_to_le32(hwif->dmatable_dma);
-	writel(dma_addr, (void __iomem *)(dma_base + IOC4_DMA_PTR_L * 4));
-
-	/* Address of the Ending DMA */
-	memset(ide_get_hwifdata(hwif), 0, IOC4_IDE_CACHELINE_SIZE);
-	ending_dma_addr = cpu_to_le32(hwif->extra_base);
-	writel(ending_dma_addr, (void __iomem *)(dma_base +
-						 IOC4_DMA_END_ADDR * 4));
-
-	writel(dma_direction, (void __iomem *)ioc4_dma_addr);
-}
-
-/* IOC4 Scatter Gather list Format					 */
-/* 128 Bit entries to support 64 bit addresses in the future		 */
-/* The Scatter Gather list Entry should be in the BIG-ENDIAN Format	 */
-/* --------------------------------------------------------------------- */
-/* | Upper 32 bits - Zero	    |		Lower 32 bits- address | */
-/* --------------------------------------------------------------------- */
-/* | Upper 32 bits - Zero	    |EOL| 15 unused     | 16 Bit Length| */
-/* --------------------------------------------------------------------- */
-/* Creates the scatter gather list, DMA Table				 */
-
-static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned int *table = hwif->dmatable_cpu;
-	unsigned int count = 0, i = cmd->sg_nents;
-	struct scatterlist *sg = hwif->sg_table;
-
-	while (i && sg_dma_len(sg)) {
-		dma_addr_t cur_addr;
-		int cur_len;
-		cur_addr = sg_dma_address(sg);
-		cur_len = sg_dma_len(sg);
-
-		while (cur_len) {
-			if (count++ >= IOC4_PRD_ENTRIES) {
-				printk(KERN_WARNING
-				       "%s: DMA table too small\n",
-				       drive->name);
-				return 0;
-			} else {
-				u32 bcount =
-				    0x10000 - (cur_addr & 0xffff);
-
-				if (bcount > cur_len)
-					bcount = cur_len;
-
-				/*
-				 * Put the address, length in
-				 * the IOC4 dma-table format
-				 */
-				*table = 0x0;
-				table++;
-				*table = cpu_to_be32(cur_addr);
-				table++;
-				*table = 0x0;
-				table++;
-
-				*table = cpu_to_be32(bcount);
-				table++;
-
-				cur_addr += bcount;
-				cur_len -= bcount;
-			}
-		}
-
-		sg = sg_next(sg);
-		i--;
-	}
-
-	if (count) {
-		table--;
-		*table |= cpu_to_be32(0x80000000);
-		return count;
-	}
-
-	return 0;		/* revert to PIO for this request */
-}
-
-static int sgiioc4_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	int ddir;
-	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
-
-	if (sgiioc4_build_dmatable(drive, cmd) == 0)
-		/* try PIO instead of DMA */
-		return 1;
-
-	if (write)
-		/* Writes TO the IOC4 FROM Main Memory */
-		ddir = IOC4_DMA_READ;
-	else
-		/* Writes FROM the IOC4 TO Main Memory */
-		ddir = IOC4_DMA_WRITE;
-
-	sgiioc4_configure_for_dma(ddir, drive);
-
-	return 0;
-}
-
-static const struct ide_tp_ops sgiioc4_tp_ops = {
-	.exec_command		= ide_exec_command,
-	.read_status		= sgiioc4_read_status,
-	.read_altstatus		= ide_read_altstatus,
-	.write_devctl		= ide_write_devctl,
-
-	.dev_select		= ide_dev_select,
-	.tf_load		= ide_tf_load,
-	.tf_read		= ide_tf_read,
-
-	.input_data		= ide_input_data,
-	.output_data		= ide_output_data,
-};
-
-static const struct ide_port_ops sgiioc4_port_ops = {
-	.set_dma_mode		= sgiioc4_set_dma_mode,
-	/* reset DMA engine, clear IRQs */
-	.resetproc		= sgiioc4_resetproc,
-};
-
-static const struct ide_dma_ops sgiioc4_dma_ops = {
-	.dma_host_set		= sgiioc4_dma_host_set,
-	.dma_setup		= sgiioc4_dma_setup,
-	.dma_start		= sgiioc4_dma_start,
-	.dma_end		= sgiioc4_dma_end,
-	.dma_test_irq		= sgiioc4_dma_test_irq,
-	.dma_lost_irq		= sgiioc4_dma_lost_irq,
-};
-
-static const struct ide_port_info sgiioc4_port_info = {
-	.name			= DRV_NAME,
-	.chipset		= ide_pci,
-	.init_dma		= ide_dma_sgiioc4,
-	.tp_ops			= &sgiioc4_tp_ops,
-	.port_ops		= &sgiioc4_port_ops,
-	.dma_ops		= &sgiioc4_dma_ops,
-	.host_flags		= IDE_HFLAG_MMIO,
-	.irq_flags		= IRQF_SHARED,
-	.mwdma_mask		= ATA_MWDMA2_ONLY,
-};
-
-static int sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
-{
-	unsigned long cmd_base, irqport;
-	unsigned long bar0, cmd_phys_base, ctl;
-	void __iomem *virt_base;
-	struct ide_hw hw, *hws[] = { &hw };
-	int rc;
-
-	/* Get the CmdBlk and CtrlBlk base registers */
-	bar0 = pci_resource_start(dev, 0);
-	virt_base = pci_ioremap_bar(dev, 0);
-	if (virt_base == NULL) {
-		printk(KERN_ERR "%s: Unable to remap BAR 0 address: 0x%lx\n",
-				DRV_NAME, bar0);
-		return -ENOMEM;
-	}
-	cmd_base = (unsigned long)virt_base + IOC4_CMD_OFFSET;
-	ctl = (unsigned long)virt_base + IOC4_CTRL_OFFSET;
-	irqport = (unsigned long)virt_base + IOC4_INTR_OFFSET;
-
-	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
-	if (request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
-			       DRV_NAME) == NULL) {
-		printk(KERN_ERR "%s %s -- ERROR: addresses 0x%08lx to 0x%08lx "
-		       "already in use\n", DRV_NAME, pci_name(dev),
-		       cmd_phys_base, cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
-		rc = -EBUSY;
-		goto req_mem_rgn_err;
-	}
-
-	/* Initialize the IO registers */
-	memset(&hw, 0, sizeof(hw));
-	sgiioc4_init_hwif_ports(&hw, cmd_base, ctl, irqport);
-	hw.irq = dev->irq;
-	hw.dev = &dev->dev;
-
-	/* Initialize chipset IRQ registers */
-	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
-
-	rc = ide_host_add(&sgiioc4_port_info, hws, 1, NULL);
-	if (!rc)
-		return 0;
-
-	release_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE);
-req_mem_rgn_err:
-	iounmap(virt_base);
-	return rc;
-}
-
-static unsigned int pci_init_sgiioc4(struct pci_dev *dev)
-{
-	int ret;
-
-	printk(KERN_INFO "%s: IDE controller at PCI slot %s, revision %d\n",
-			 DRV_NAME, pci_name(dev), dev->revision);
-
-	if (dev->revision < IOC4_SUPPORTED_FIRMWARE_REV) {
-		printk(KERN_ERR "Skipping %s IDE controller in slot %s: "
-				"firmware is obsolete - please upgrade to "
-				"revision46 or higher\n",
-				DRV_NAME, pci_name(dev));
-		ret = -EAGAIN;
-		goto out;
-	}
-	ret = sgiioc4_ide_setup_pci_device(dev);
-out:
-	return ret;
-}
-
-static int ioc4_ide_attach_one(struct ioc4_driver_data *idd)
-{
-	/*
-	 * PCI-RT does not bring out IDE connection.
-	 * Do not attach to this particular IOC4.
-	 */
-	if (idd->idd_variant == IOC4_VARIANT_PCI_RT)
-		return 0;
-
-	return pci_init_sgiioc4(idd->idd_pdev);
-}
-
-static struct ioc4_submodule ioc4_ide_submodule = {
-	.is_name = "IOC4_ide",
-	.is_owner = THIS_MODULE,
-	.is_probe = ioc4_ide_attach_one,
-};
-
-static int __init ioc4_ide_init(void)
-{
-	return ioc4_register_submodule(&ioc4_ide_submodule);
-}
-
-late_initcall(ioc4_ide_init); /* Call only after IDE init is done */
-
-MODULE_AUTHOR("Aniket Malatpure/Jeremy Higdon");
-MODULE_DESCRIPTION("IDE PCI driver module for SGI IOC4 Base-IO Card");
-MODULE_LICENSE("GPL");
-- 
2.20.1

