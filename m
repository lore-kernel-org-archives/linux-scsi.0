Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42DDC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7891220679
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O9Jb5n9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfHMH0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMH0F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h0GE+/7YBqyDzyOmtNyFT2WkwcrflXuL312Ib0oB4ts=; b=O9Jb5n9Gc4ICnbGdy5IqYLc6ed
        XK9Er+toSa3VxJT7//otISkSd6AlNExcDfot8cTJ4a59IYYiZzCuOkcdzx/Vf8bhDDm4AdjzVQUNn
        anuIQtzIdbJTgQeOA05WEAFixboAx8SlKzZGg6DpyWeR2JhBwd3JkjdhtxECdaaRC9c3Tt4MKMMa3
        RJJa+ZwS17WMKI1j6fXLsFW7RyV8NiZ22bFrGw//h27AOzQobvo4svUExXoApECLxhjRIAbf4ATHG
        CN7tgedBqskR8SrH2lUiu4H6jozETpJDj6QeraeIymEt+9hUnRqDcn6VIT5hTQz+BZtoErDRrBj0d
        l3c/F4uQ==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBw-0006LF-Up; Tue, 13 Aug 2019 07:26:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/28] drivers: remove the SGI SN2 IOC4 base support
Date:   Tue, 13 Aug 2019 09:25:00 +0200
Message-Id: <20190813072514.23299-15-hch@lst.de>
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

The IOC4 is a multi-function chip seen on SGI SN2 and some SGI MIPS
systems.  This removes the base driver, which while not having an SN2
Kconfig dependency was only for sub-drivers that had one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/driver-api/sgi-ioc4.rst    |  49 ---
 arch/ia64/configs/generic_defconfig      |   1 -
 arch/ia64/configs/gensparse_defconfig    |   1 -
 arch/mips/configs/bigsur_defconfig       |   1 -
 arch/mips/configs/ip32_defconfig         |   1 -
 arch/mips/configs/markeins_defconfig     |   1 -
 arch/mips/configs/rm200_defconfig        |   1 -
 arch/mips/configs/sb1250_swarm_defconfig |   1 -
 drivers/misc/Kconfig                     |  12 -
 drivers/misc/Makefile                    |   1 -
 drivers/misc/ioc4.c                      | 498 -----------------------
 include/linux/ioc4.h                     | 184 ---------
 include/linux/pci_ids.h                  |   1 -
 13 files changed, 752 deletions(-)
 delete mode 100644 Documentation/driver-api/sgi-ioc4.rst
 delete mode 100644 drivers/misc/ioc4.c
 delete mode 100644 include/linux/ioc4.h

diff --git a/Documentation/driver-api/sgi-ioc4.rst b/Documentation/driver-api/sgi-ioc4.rst
deleted file mode 100644
index 72709222d3c0..000000000000
--- a/Documentation/driver-api/sgi-ioc4.rst
+++ /dev/null
@@ -1,49 +0,0 @@
-====================================
-SGI IOC4 PCI (multi function) device
-====================================
-
-The SGI IOC4 PCI device is a bit of a strange beast, so some notes on
-it are in order.
-
-First, even though the IOC4 performs multiple functions, such as an
-IDE controller, a serial controller, a PS/2 keyboard/mouse controller,
-and an external interrupt mechanism, it's not implemented as a
-multifunction device.  The consequence of this from a software
-standpoint is that all these functions share a single IRQ, and
-they can't all register to own the same PCI device ID.  To make
-matters a bit worse, some of the register blocks (and even registers
-themselves) present in IOC4 are mixed-purpose between these several
-functions, meaning that there's no clear "owning" device driver.
-
-The solution is to organize the IOC4 driver into several independent
-drivers, "ioc4", "sgiioc4", and "ioc4_serial".  Note that there is no
-PS/2 controller driver as this functionality has never been wired up
-on a shipping IO card.
-
-ioc4
-====
-This is the core (or shim) driver for IOC4.  It is responsible for
-initializing the basic functionality of the chip, and allocating
-the PCI resources that are shared between the IOC4 functions.
-
-This driver also provides registration functions that the other
-IOC4 drivers can call to make their presence known.  Each driver
-needs to provide a probe and remove function, which are invoked
-by the core driver at appropriate times.  The interface of these
-IOC4 function probe and remove operations isn't precisely the same
-as PCI device probe and remove operations, but is logically the
-same operation.
-
-sgiioc4
-=======
-This is the IDE driver for IOC4.  Its name isn't very descriptive
-simply for historical reasons (it used to be the only IOC4 driver
-component).  There's not much to say about it other than it hooks
-up to the ioc4 driver via the appropriate registration, probe, and
-remove functions.
-
-ioc4_serial
-===========
-This is the serial driver for IOC4.  There's not much to say about it
-other than it hooks up to the ioc4 driver via the appropriate registration,
-probe, and remove functions.
diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 8dd921dce4b5..661d90b3e148 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -44,7 +44,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-CONFIG_SGI_IOC4=y
 CONFIG_SGI_XP=m
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index 5d5ea744f7e6..7844e6a956a4 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -36,7 +36,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-CONFIG_SGI_IOC4=y
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_IDE_GENERIC=y
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 66566026409d..f14ad0538f4e 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -103,7 +103,6 @@ CONFIG_FW_LOADER=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
-CONFIG_SGI_IOC4=m
 CONFIG_EEPROM_LEGACY=y
 CONFIG_EEPROM_MAX6875=y
 CONFIG_IDE=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 572cab91670c..370884018aad 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -46,7 +46,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
-CONFIG_SGI_IOC4=y
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index ae93a94f8c71..507ad91b21e7 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -117,7 +117,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
-CONFIG_SGI_IOC4=m
 CONFIG_SCSI=m
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=m
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 0f4b09f8a0ee..8762e75f5d5f 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -198,7 +198,6 @@ CONFIG_BLK_DEV_SX8=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
-CONFIG_SGI_IOC4=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/sb1250_swarm_defconfig b/arch/mips/configs/sb1250_swarm_defconfig
index 6883ea4477d4..bb0b1b22ebe1 100644
--- a/arch/mips/configs/sb1250_swarm_defconfig
+++ b/arch/mips/configs/sb1250_swarm_defconfig
@@ -49,7 +49,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=9220
 CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
-CONFIG_SGI_IOC4=m
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_IDETAPE=y
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 299032693934..423d2d26d8f7 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -126,18 +126,6 @@ config INTEL_MID_PTI
 	  an Intel Atom (non-netbook) mobile device containing a MIPI
 	  P1149.7 standard implementation.
 
-config SGI_IOC4
-	tristate "SGI IOC4 Base IO support"
-	depends on PCI
-	---help---
-	  This option enables basic support for the IOC4 chip on certain
-	  SGI IO controller cards (IO9, IO10, and PCI-RT).  This option
-	  does not enable any specific functions on such a card, but provides
-	  necessary infrastructure for other drivers to utilize.
-
-	  If you have an SGI Altix with an IOC4-based card say Y.
-	  Otherwise say N.
-
 config TIFM_CORE
 	tristate "TI Flash Media interface support"
 	depends on PCI
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index abd8ae249746..8dae0a976200 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -21,7 +21,6 @@ obj-$(CONFIG_QCOM_COINCELL)	+= qcom-coincell.o
 obj-$(CONFIG_QCOM_FASTRPC)	+= fastrpc.o
 obj-$(CONFIG_SENSORS_BH1770)	+= bh1770glc.o
 obj-$(CONFIG_SENSORS_APDS990X)	+= apds990x.o
-obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
deleted file mode 100644
index 9d0445a567db..000000000000
--- a/drivers/misc/ioc4.c
+++ /dev/null
@@ -1,498 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2005-2006 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-/* This file contains the master driver module for use by SGI IOC4 subdrivers.
- *
- * It allocates any resources shared between multiple subdevices, and
- * provides accessor functions (where needed) and the like for those
- * resources.  It also provides a mechanism for the subdevice modules
- * to support loading and unloading.
- *
- * Non-shared resources (e.g. external interrupt A_INT_OUT register page
- * alias, serial port and UART registers) are handled by the subdevice
- * modules themselves.
- *
- * This is all necessary because IOC4 is not implemented as a multi-function
- * PCI device, but an amalgamation of disparate registers for several
- * types of device (ATA, serial, external interrupts).  The normal
- * resource management in the kernel doesn't have quite the right interfaces
- * to handle this situation (e.g. multiple modules can't claim the same
- * PCI ID), thus this IOC4 master module.
- */
-
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/ioc4.h>
-#include <linux/ktime.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-#include <linux/time.h>
-#include <asm/io.h>
-
-/***************
- * Definitions *
- ***************/
-
-/* Tweakable values */
-
-/* PCI bus speed detection/calibration */
-#define IOC4_CALIBRATE_COUNT 63		/* Calibration cycle period */
-#define IOC4_CALIBRATE_CYCLES 256	/* Average over this many cycles */
-#define IOC4_CALIBRATE_DISCARD 2	/* Discard first few cycles */
-#define IOC4_CALIBRATE_LOW_MHZ 25	/* Lower bound on bus speed sanity */
-#define IOC4_CALIBRATE_HIGH_MHZ 75	/* Upper bound on bus speed sanity */
-#define IOC4_CALIBRATE_DEFAULT_MHZ 66	/* Assumed if sanity check fails */
-
-/************************
- * Submodule management *
- ************************/
-
-static DEFINE_MUTEX(ioc4_mutex);
-
-static LIST_HEAD(ioc4_devices);
-static LIST_HEAD(ioc4_submodules);
-
-/* Register an IOC4 submodule */
-int
-ioc4_register_submodule(struct ioc4_submodule *is)
-{
-	struct ioc4_driver_data *idd;
-
-	mutex_lock(&ioc4_mutex);
-	list_add(&is->is_list, &ioc4_submodules);
-
-	/* Initialize submodule for each IOC4 */
-	if (!is->is_probe)
-		goto out;
-
-	list_for_each_entry(idd, &ioc4_devices, idd_list) {
-		if (is->is_probe(idd)) {
-			printk(KERN_WARNING
-			       "%s: IOC4 submodule %s probe failed "
-			       "for pci_dev %s",
-			       __func__, module_name(is->is_owner),
-			       pci_name(idd->idd_pdev));
-		}
-	}
- out:
-	mutex_unlock(&ioc4_mutex);
-	return 0;
-}
-
-/* Unregister an IOC4 submodule */
-void
-ioc4_unregister_submodule(struct ioc4_submodule *is)
-{
-	struct ioc4_driver_data *idd;
-
-	mutex_lock(&ioc4_mutex);
-	list_del(&is->is_list);
-
-	/* Remove submodule for each IOC4 */
-	if (!is->is_remove)
-		goto out;
-
-	list_for_each_entry(idd, &ioc4_devices, idd_list) {
-		if (is->is_remove(idd)) {
-			printk(KERN_WARNING
-			       "%s: IOC4 submodule %s remove failed "
-			       "for pci_dev %s.\n",
-			       __func__, module_name(is->is_owner),
-			       pci_name(idd->idd_pdev));
-		}
-	}
- out:
-	mutex_unlock(&ioc4_mutex);
-}
-
-/*********************
- * Device management *
- *********************/
-
-#define IOC4_CALIBRATE_LOW_LIMIT \
-	(1000*IOC4_EXTINT_COUNT_DIVISOR/IOC4_CALIBRATE_LOW_MHZ)
-#define IOC4_CALIBRATE_HIGH_LIMIT \
-	(1000*IOC4_EXTINT_COUNT_DIVISOR/IOC4_CALIBRATE_HIGH_MHZ)
-#define IOC4_CALIBRATE_DEFAULT \
-	(1000*IOC4_EXTINT_COUNT_DIVISOR/IOC4_CALIBRATE_DEFAULT_MHZ)
-
-#define IOC4_CALIBRATE_END \
-	(IOC4_CALIBRATE_CYCLES + IOC4_CALIBRATE_DISCARD)
-
-#define IOC4_INT_OUT_MODE_TOGGLE 0x7	/* Toggle INT_OUT every COUNT+1 ticks */
-
-/* Determines external interrupt output clock period of the PCI bus an
- * IOC4 is attached to.  This value can be used to determine the PCI
- * bus speed.
- *
- * IOC4 has a design feature that various internal timers are derived from
- * the PCI bus clock.  This causes IOC4 device drivers to need to take the
- * bus speed into account when setting various register values (e.g. INT_OUT
- * register COUNT field, UART divisors, etc).  Since this information is
- * needed by several subdrivers, it is determined by the main IOC4 driver,
- * even though the following code utilizes external interrupt registers
- * to perform the speed calculation.
- */
-static void
-ioc4_clock_calibrate(struct ioc4_driver_data *idd)
-{
-	union ioc4_int_out int_out;
-	union ioc4_gpcr gpcr;
-	unsigned int state, last_state;
-	uint64_t start, end, period;
-	unsigned int count;
-
-	/* Enable output */
-	gpcr.raw = 0;
-	gpcr.fields.dir = IOC4_GPCR_DIR_0;
-	gpcr.fields.int_out_en = 1;
-	writel(gpcr.raw, &idd->idd_misc_regs->gpcr_s.raw);
-
-	/* Reset to power-on state */
-	writel(0, &idd->idd_misc_regs->int_out.raw);
-
-	/* Set up square wave */
-	int_out.raw = 0;
-	int_out.fields.count = IOC4_CALIBRATE_COUNT;
-	int_out.fields.mode = IOC4_INT_OUT_MODE_TOGGLE;
-	int_out.fields.diag = 0;
-	writel(int_out.raw, &idd->idd_misc_regs->int_out.raw);
-
-	/* Check square wave period averaged over some number of cycles */
-	start = ktime_get_ns();
-	state = 1; /* make sure the first read isn't a rising edge */
-	for (count = 0; count <= IOC4_CALIBRATE_END; count++) {
-		do { /* wait for a rising edge */
-			last_state = state;
-			int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
-			state = int_out.fields.int_out;
-		} while (last_state || !state);
-
-		/* discard the first few cycles */
-		if (count == IOC4_CALIBRATE_DISCARD)
-			start = ktime_get_ns();
-	}
-	end = ktime_get_ns();
-
-	/* Calculation rearranged to preserve intermediate precision.
-	 * Logically:
-	 * 1. "end - start" gives us the measurement period over all
-	 *    the square wave cycles.
-	 * 2. Divide by number of square wave cycles to get the period
-	 *    of a square wave cycle.
-	 * 3. Divide by 2*(int_out.fields.count+1), which is the formula
-	 *    by which the IOC4 generates the square wave, to get the
-	 *    period of an IOC4 INT_OUT count.
-	 */
-	period = (end - start) /
-		(IOC4_CALIBRATE_CYCLES * 2 * (IOC4_CALIBRATE_COUNT + 1));
-
-	/* Bounds check the result. */
-	if (period > IOC4_CALIBRATE_LOW_LIMIT ||
-	    period < IOC4_CALIBRATE_HIGH_LIMIT) {
-		printk(KERN_INFO
-		       "IOC4 %s: Clock calibration failed.  Assuming"
-		       "PCI clock is %d ns.\n",
-		       pci_name(idd->idd_pdev),
-		       IOC4_CALIBRATE_DEFAULT / IOC4_EXTINT_COUNT_DIVISOR);
-		period = IOC4_CALIBRATE_DEFAULT;
-	} else {
-		u64 ns = period;
-
-		do_div(ns, IOC4_EXTINT_COUNT_DIVISOR);
-		printk(KERN_DEBUG
-		       "IOC4 %s: PCI clock is %llu ns.\n",
-		       pci_name(idd->idd_pdev), (unsigned long long)ns);
-	}
-
-	/* Remember results.  We store the extint clock period rather
-	 * than the PCI clock period so that greater precision is
-	 * retained.  Divide by IOC4_EXTINT_COUNT_DIVISOR to get
-	 * PCI clock period.
-	 */
-	idd->count_period = period;
-}
-
-/* There are three variants of IOC4 cards: IO9, IO10, and PCI-RT.
- * Each brings out different combinations of IOC4 signals, thus.
- * the IOC4 subdrivers need to know to which we're attached.
- *
- * We look for the presence of a SCSI (IO9) or SATA (IO10) controller
- * on the same PCI bus at slot number 3 to differentiate IO9 from IO10.
- * If neither is present, it's a PCI-RT.
- */
-static unsigned int
-ioc4_variant(struct ioc4_driver_data *idd)
-{
-	struct pci_dev *pdev = NULL;
-	int found = 0;
-
-	/* IO9: Look for a QLogic ISP 12160 at the same bus and slot 3. */
-	do {
-		pdev = pci_get_device(PCI_VENDOR_ID_QLOGIC,
-				      PCI_DEVICE_ID_QLOGIC_ISP12160, pdev);
-		if (pdev &&
-		    idd->idd_pdev->bus->number == pdev->bus->number &&
-		    3 == PCI_SLOT(pdev->devfn))
-			found = 1;
-	} while (pdev && !found);
-	if (NULL != pdev) {
-		pci_dev_put(pdev);
-		return IOC4_VARIANT_IO9;
-	}
-
-	/* IO10: Look for a Vitesse VSC 7174 at the same bus and slot 3. */
-	pdev = NULL;
-	do {
-		pdev = pci_get_device(PCI_VENDOR_ID_VITESSE,
-				      PCI_DEVICE_ID_VITESSE_VSC7174, pdev);
-		if (pdev &&
-		    idd->idd_pdev->bus->number == pdev->bus->number &&
-		    3 == PCI_SLOT(pdev->devfn))
-			found = 1;
-	} while (pdev && !found);
-	if (NULL != pdev) {
-		pci_dev_put(pdev);
-		return IOC4_VARIANT_IO10;
-	}
-
-	/* PCI-RT: No SCSI/SATA controller will be present */
-	return IOC4_VARIANT_PCI_RT;
-}
-
-static void
-ioc4_load_modules(struct work_struct *work)
-{
-	request_module("sgiioc4");
-}
-
-static DECLARE_WORK(ioc4_load_modules_work, ioc4_load_modules);
-
-/* Adds a new instance of an IOC4 card */
-static int
-ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
-{
-	struct ioc4_driver_data *idd;
-	struct ioc4_submodule *is;
-	uint32_t pcmd;
-	int ret;
-
-	/* Enable IOC4 and take ownership of it */
-	if ((ret = pci_enable_device(pdev))) {
-		printk(KERN_WARNING
-		       "%s: Failed to enable IOC4 device for pci_dev %s.\n",
-		       __func__, pci_name(pdev));
-		goto out;
-	}
-	pci_set_master(pdev);
-
-	/* Set up per-IOC4 data */
-	idd = kmalloc(sizeof(struct ioc4_driver_data), GFP_KERNEL);
-	if (!idd) {
-		printk(KERN_WARNING
-		       "%s: Failed to allocate IOC4 data for pci_dev %s.\n",
-		       __func__, pci_name(pdev));
-		ret = -ENODEV;
-		goto out_idd;
-	}
-	idd->idd_pdev = pdev;
-	idd->idd_pci_id = pci_id;
-
-	/* Map IOC4 misc registers.  These are shared between subdevices
-	 * so the main IOC4 module manages them.
-	 */
-	idd->idd_bar0 = pci_resource_start(idd->idd_pdev, 0);
-	if (!idd->idd_bar0) {
-		printk(KERN_WARNING
-		       "%s: Unable to find IOC4 misc resource "
-		       "for pci_dev %s.\n",
-		       __func__, pci_name(idd->idd_pdev));
-		ret = -ENODEV;
-		goto out_pci;
-	}
-	if (!request_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs),
-			    "ioc4_misc")) {
-		printk(KERN_WARNING
-		       "%s: Unable to request IOC4 misc region "
-		       "for pci_dev %s.\n",
-		       __func__, pci_name(idd->idd_pdev));
-		ret = -ENODEV;
-		goto out_pci;
-	}
-	idd->idd_misc_regs = ioremap(idd->idd_bar0,
-				     sizeof(struct ioc4_misc_regs));
-	if (!idd->idd_misc_regs) {
-		printk(KERN_WARNING
-		       "%s: Unable to remap IOC4 misc region "
-		       "for pci_dev %s.\n",
-		       __func__, pci_name(idd->idd_pdev));
-		ret = -ENODEV;
-		goto out_misc_region;
-	}
-
-	/* Failsafe portion of per-IOC4 initialization */
-
-	/* Detect card variant */
-	idd->idd_variant = ioc4_variant(idd);
-	printk(KERN_INFO "IOC4 %s: %s card detected.\n", pci_name(pdev),
-	       idd->idd_variant == IOC4_VARIANT_IO9 ? "IO9" :
-	       idd->idd_variant == IOC4_VARIANT_PCI_RT ? "PCI-RT" :
-	       idd->idd_variant == IOC4_VARIANT_IO10 ? "IO10" : "unknown");
-
-	/* Initialize IOC4 */
-	pci_read_config_dword(idd->idd_pdev, PCI_COMMAND, &pcmd);
-	pci_write_config_dword(idd->idd_pdev, PCI_COMMAND,
-			       pcmd | PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
-
-	/* Determine PCI clock */
-	ioc4_clock_calibrate(idd);
-
-	/* Disable/clear all interrupts.  Need to do this here lest
-	 * one submodule request the shared IOC4 IRQ, but interrupt
-	 * is generated by a different subdevice.
-	 */
-	/* Disable */
-	writel(~0, &idd->idd_misc_regs->other_iec.raw);
-	writel(~0, &idd->idd_misc_regs->sio_iec);
-	/* Clear (i.e. acknowledge) */
-	writel(~0, &idd->idd_misc_regs->other_ir.raw);
-	writel(~0, &idd->idd_misc_regs->sio_ir);
-
-	/* Track PCI-device specific data */
-	idd->idd_serial_data = NULL;
-	pci_set_drvdata(idd->idd_pdev, idd);
-
-	mutex_lock(&ioc4_mutex);
-	list_add_tail(&idd->idd_list, &ioc4_devices);
-
-	/* Add this IOC4 to all submodules */
-	list_for_each_entry(is, &ioc4_submodules, is_list) {
-		if (is->is_probe && is->is_probe(idd)) {
-			printk(KERN_WARNING
-			       "%s: IOC4 submodule 0x%s probe failed "
-			       "for pci_dev %s.\n",
-			       __func__, module_name(is->is_owner),
-			       pci_name(idd->idd_pdev));
-		}
-	}
-	mutex_unlock(&ioc4_mutex);
-
-	/* Request sgiioc4 IDE driver on boards that bring that functionality
-	 * off of IOC4.  The root filesystem may be hosted on a drive connected
-	 * to IOC4, so we need to make sure the sgiioc4 driver is loaded as it
-	 * won't be picked up by modprobes due to the ioc4 module owning the
-	 * PCI device.
-	 */
-	if (idd->idd_variant != IOC4_VARIANT_PCI_RT) {
-		/* Request the module from a work procedure as the modprobe
-		 * goes out to a userland helper and that will hang if done
-		 * directly from ioc4_probe().
-		 */
-		printk(KERN_INFO "IOC4 loading sgiioc4 submodule\n");
-		schedule_work(&ioc4_load_modules_work);
-	}
-
-	return 0;
-
-out_misc_region:
-	release_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
-out_pci:
-	kfree(idd);
-out_idd:
-	pci_disable_device(pdev);
-out:
-	return ret;
-}
-
-/* Removes a particular instance of an IOC4 card. */
-static void
-ioc4_remove(struct pci_dev *pdev)
-{
-	struct ioc4_submodule *is;
-	struct ioc4_driver_data *idd;
-
-	idd = pci_get_drvdata(pdev);
-
-	/* Remove this IOC4 from all submodules */
-	mutex_lock(&ioc4_mutex);
-	list_for_each_entry(is, &ioc4_submodules, is_list) {
-		if (is->is_remove && is->is_remove(idd)) {
-			printk(KERN_WARNING
-			       "%s: IOC4 submodule 0x%s remove failed "
-			       "for pci_dev %s.\n",
-			       __func__, module_name(is->is_owner),
-			       pci_name(idd->idd_pdev));
-		}
-	}
-	mutex_unlock(&ioc4_mutex);
-
-	/* Release resources */
-	iounmap(idd->idd_misc_regs);
-	if (!idd->idd_bar0) {
-		printk(KERN_WARNING
-		       "%s: Unable to get IOC4 misc mapping for pci_dev %s. "
-		       "Device removal may be incomplete.\n",
-		       __func__, pci_name(idd->idd_pdev));
-	}
-	release_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
-
-	/* Disable IOC4 and relinquish */
-	pci_disable_device(pdev);
-
-	/* Remove and free driver data */
-	mutex_lock(&ioc4_mutex);
-	list_del(&idd->idd_list);
-	mutex_unlock(&ioc4_mutex);
-	kfree(idd);
-}
-
-static const struct pci_device_id ioc4_id_table[] = {
-	{PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC4, PCI_ANY_ID,
-	 PCI_ANY_ID, 0x0b4000, 0xFFFFFF},
-	{0}
-};
-
-static struct pci_driver ioc4_driver = {
-	.name = "IOC4",
-	.id_table = ioc4_id_table,
-	.probe = ioc4_probe,
-	.remove = ioc4_remove,
-};
-
-MODULE_DEVICE_TABLE(pci, ioc4_id_table);
-
-/*********************
- * Module management *
- *********************/
-
-/* Module load */
-static int __init
-ioc4_init(void)
-{
-	return pci_register_driver(&ioc4_driver);
-}
-
-/* Module unload */
-static void __exit
-ioc4_exit(void)
-{
-	/* Ensure ioc4_load_modules() has completed before exiting */
-	flush_work(&ioc4_load_modules_work);
-	pci_unregister_driver(&ioc4_driver);
-}
-
-module_init(ioc4_init);
-module_exit(ioc4_exit);
-
-MODULE_AUTHOR("Brent Casavant - Silicon Graphics, Inc. <bcasavan@sgi.com>");
-MODULE_DESCRIPTION("PCI driver master module for SGI IOC4 Base-IO Card");
-MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL(ioc4_register_submodule);
-EXPORT_SYMBOL(ioc4_unregister_submodule);
diff --git a/include/linux/ioc4.h b/include/linux/ioc4.h
deleted file mode 100644
index 51e2b9fb6372..000000000000
--- a/include/linux/ioc4.h
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-#ifndef _LINUX_IOC4_H
-#define _LINUX_IOC4_H
-
-#include <linux/interrupt.h>
-
-/***************
- * Definitions *
- ***************/
-
-/* Miscellaneous values inherent to hardware */
-
-#define IOC4_EXTINT_COUNT_DIVISOR 520	/* PCI clocks per COUNT tick */
-
-/***********************************
- * Structures needed by subdrivers *
- ***********************************/
-
-/* This structure fully describes the IOC4 miscellaneous registers which
- * appear at bar[0]+0x00000 through bar[0]+0x0005c.  The corresponding
- * PCI resource is managed by the main IOC4 driver because it contains
- * registers of interest to many different IOC4 subdrivers.
- */
-struct ioc4_misc_regs {
-	/* Miscellaneous IOC4 registers */
-	union ioc4_pci_err_addr_l {
-		uint32_t raw;
-		struct {
-			uint32_t valid:1;	/* Address captured */
-			uint32_t master_id:4;	/* Unit causing error
-						 * 0/1: Serial port 0 TX/RX
-						 * 2/3: Serial port 1 TX/RX
-						 * 4/5: Serial port 2 TX/RX
-						 * 6/7: Serial port 3 TX/RX
-						 * 8: ATA/ATAPI
-						 * 9-15: Undefined
-						 */
-			uint32_t mul_err:1;	/* Multiple errors occurred */
-			uint32_t addr:26;	/* Bits 31-6 of error addr */
-		} fields;
-	} pci_err_addr_l;
-	uint32_t pci_err_addr_h;	/* Bits 63-32 of error addr */
-	union ioc4_sio_int {
-		uint32_t raw;
-		struct {
-			uint8_t tx_mt:1;	/* TX ring buffer empty */
-			uint8_t rx_full:1;	/* RX ring buffer full */
-			uint8_t rx_high:1;	/* RX high-water exceeded */
-			uint8_t rx_timer:1;	/* RX timer has triggered */
-			uint8_t delta_dcd:1;	/* DELTA_DCD seen */
-			uint8_t delta_cts:1;	/* DELTA_CTS seen */
-			uint8_t intr_pass:1;	/* Interrupt pass-through */
-			uint8_t tx_explicit:1;	/* TX, MCW, or delay complete */
-		} fields[4];
-	} sio_ir;		/* Serial interrupt state */
-	union ioc4_other_int {
-		uint32_t raw;
-		struct {
-			uint32_t ata_int:1;	/* ATA port passthru */
-			uint32_t ata_memerr:1;	/* ATA halted by mem error */
-			uint32_t memerr:4;	/* Serial halted by mem err */
-			uint32_t kbd_int:1;	/* kbd/mouse intr asserted */
-			uint32_t reserved:16;	/* zero */
-			uint32_t rt_int:1;	/* INT_OUT section latch */
-			uint32_t gen_int:8;	/* Intr. from generic pins */
-		} fields;
-	} other_ir;		/* Other interrupt state */
-	union ioc4_sio_int sio_ies;	/* Serial interrupt enable set */
-	union ioc4_other_int other_ies;	/* Other interrupt enable set */
-	union ioc4_sio_int sio_iec;	/* Serial interrupt enable clear */
-	union ioc4_other_int other_iec;	/* Other interrupt enable clear */
-	union ioc4_sio_cr {
-		uint32_t raw;
-		struct {
-			uint32_t cmd_pulse:4;	/* Bytebus strobe width */
-			uint32_t arb_diag:3;	/* PCI bus requester */
-			uint32_t sio_diag_idle:1;	/* Active ser req? */
-			uint32_t ata_diag_idle:1;	/* Active ATA req? */
-			uint32_t ata_diag_active:1;	/* ATA req is winner */
-			uint32_t reserved:22;	/* zero */
-		} fields;
-	} sio_cr;
-	uint32_t unused1;
-	union ioc4_int_out {
-		uint32_t raw;
-		struct {
-			uint32_t count:16;	/* Period control */
-			uint32_t mode:3;	/* Output signal shape */
-			uint32_t reserved:11;	/* zero */
-			uint32_t diag:1;	/* Timebase control */
-			uint32_t int_out:1;	/* Current value */
-		} fields;
-	} int_out;		/* External interrupt output control */
-	uint32_t unused2;
-	union ioc4_gpcr {
-		uint32_t raw;
-		struct {
-			uint32_t dir:8;	/* Pin direction */
-			uint32_t edge:8;	/* Edge/level mode */
-			uint32_t reserved1:4;	/* zero */
-			uint32_t int_out_en:1;	/* INT_OUT enable */
-			uint32_t reserved2:11;	/* zero */
-		} fields;
-	} gpcr_s;		/* Generic PIO control set */
-	union ioc4_gpcr gpcr_c;	/* Generic PIO control clear */
-	union ioc4_gpdr {
-		uint32_t raw;
-		struct {
-			uint32_t gen_pin:8;	/* State of pins */
-			uint32_t reserved:24;
-		} fields;
-	} gpdr;			/* Generic PIO data */
-	uint32_t unused3;
-	union ioc4_gppr {
-		uint32_t raw;
-		struct {
-			uint32_t gen_pin:1;	/* Single pin state */
-			uint32_t reserved:31;
-		} fields;
-	} gppr[8];		/* Generic PIO pins */
-};
-
-/* Masks for GPCR DIR pins */
-#define IOC4_GPCR_DIR_0 0x01	/* External interrupt output */
-#define IOC4_GPCR_DIR_1 0x02	/* External interrupt input */
-#define IOC4_GPCR_DIR_2 0x04
-#define IOC4_GPCR_DIR_3 0x08	/* Keyboard/mouse presence */
-#define IOC4_GPCR_DIR_4 0x10	/* Ser. port 0 xcvr select (0=232, 1=422) */
-#define IOC4_GPCR_DIR_5 0x20	/* Ser. port 1 xcvr select (0=232, 1=422) */
-#define IOC4_GPCR_DIR_6 0x40	/* Ser. port 2 xcvr select (0=232, 1=422) */
-#define IOC4_GPCR_DIR_7 0x80	/* Ser. port 3 xcvr select (0=232, 1=422) */
-
-/* Masks for GPCR EDGE pins */
-#define IOC4_GPCR_EDGE_0 0x01
-#define IOC4_GPCR_EDGE_1 0x02	/* External interrupt input */
-#define IOC4_GPCR_EDGE_2 0x04
-#define IOC4_GPCR_EDGE_3 0x08
-#define IOC4_GPCR_EDGE_4 0x10
-#define IOC4_GPCR_EDGE_5 0x20
-#define IOC4_GPCR_EDGE_6 0x40
-#define IOC4_GPCR_EDGE_7 0x80
-
-#define IOC4_VARIANT_IO9	0x0900
-#define IOC4_VARIANT_PCI_RT	0x0901
-#define IOC4_VARIANT_IO10	0x1000
-
-/* One of these per IOC4 */
-struct ioc4_driver_data {
-	struct list_head idd_list;
-	unsigned long idd_bar0;
-	struct pci_dev *idd_pdev;
-	const struct pci_device_id *idd_pci_id;
-	struct ioc4_misc_regs __iomem *idd_misc_regs;
-	unsigned long count_period;
-	void *idd_serial_data;
-	unsigned int idd_variant;
-};
-
-/* One per submodule */
-struct ioc4_submodule {
-	struct list_head is_list;
-	char *is_name;
-	struct module *is_owner;
-	int (*is_probe) (struct ioc4_driver_data *);
-	int (*is_remove) (struct ioc4_driver_data *);
-};
-
-#define IOC4_NUM_CARDS		8	/* max cards per partition */
-
-/**********************************
- * Functions needed by submodules *
- **********************************/
-
-extern int ioc4_register_submodule(struct ioc4_submodule *);
-extern void ioc4_unregister_submodule(struct ioc4_submodule *);
-
-#endif				/* _LINUX_IOC4_H */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c842735a4f45..85e2ca611d42 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1070,7 +1070,6 @@
 #define PCI_VENDOR_ID_SGI		0x10a9
 #define PCI_DEVICE_ID_SGI_IOC3		0x0003
 #define PCI_DEVICE_ID_SGI_LITHIUM	0x1002
-#define PCI_DEVICE_ID_SGI_IOC4		0x100a
 
 #define PCI_VENDOR_ID_WINBOND		0x10ad
 #define PCI_DEVICE_ID_WINBOND_82C105	0x0105
-- 
2.20.1

