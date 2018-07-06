From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/2] scsi: remove NCR_D700 driver
Date: Fri,  6 Jul 2018 15:33:48 +0200
Message-ID: <20180706133349.28508-2-jthumshirn@suse.de>
References: <20180706133349.28508-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706133349.28508-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

The NCR DUAL 700 SCSI driver depends on microchannel support, but
microchannel support was removed from the kernel with commit
bb8187d35f82 ("MCA: delete all remaining traces of microchannel bus
support.") over 6 years ago.

So zap the D700 SCSI driver as well.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 MAINTAINERS             |   6 -
 drivers/scsi/Kconfig    |  12 --
 drivers/scsi/Makefile   |   1 -
 drivers/scsi/NCR_D700.c | 405 ------------------------------------------------
 drivers/scsi/NCR_D700.h |  30 ----
 5 files changed, 454 deletions(-)
 delete mode 100644 drivers/scsi/NCR_D700.c
 delete mode 100644 drivers/scsi/NCR_D700.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 07d1576fc766..a4e69b7a6674 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9749,12 +9749,6 @@ F:	drivers/scsi/mac_scsi.*
 F:	drivers/scsi/sun3_scsi.*
 F:	drivers/scsi/sun3_scsi_vme.c
 
-NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
-M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/NCR_D700.*
-
 NCSI LIBRARY:
 M:	Samuel Mendoza-Jonas <sam@mendozajonas.com>
 S:	Maintained
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 35c909bbf8ba..2de36255257a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -841,18 +841,6 @@ config SCSI_IZIP_SLOW_CTR
 
 	  Generally, saying N is fine.
 
-config SCSI_NCR_D700
-	tristate "NCR Dual 700 MCA SCSI support"
-	depends on MCA && SCSI
-	select SCSI_SPI_ATTRS
-	help
-	  This is a driver for the MicroChannel Dual 700 card produced by
-	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
-	  tries to negotiate sync and uses tag command queueing.
-
-	  Unless you have an NCR manufactured machine, the chances are that
-	  you do not have this SCSI card, so say N.
-
 config SCSI_LASI700
 	tristate "HP Lasi SCSI support for 53c700/710"
 	depends on GSC && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 80aca2456353..3729d0d1a5e7 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -76,7 +76,6 @@ obj-$(CONFIG_SCSI_PM8001)	+= pm8001/
 obj-$(CONFIG_SCSI_ISCI)		+= isci/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
-obj-$(CONFIG_SCSI_NCR_D700)	+= 53c700.o NCR_D700.o
 obj-$(CONFIG_SCSI_NCR_Q720)	+= NCR_Q720_mod.o
 obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas408.o	qlogicfas.o
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
deleted file mode 100644
index b39a2409a507..000000000000
--- a/drivers/scsi/NCR_D700.c
+++ /dev/null
@@ -1,405 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8 -*- */
-
-/* NCR Dual 700 MCA SCSI Driver
- *
- * Copyright (C) 2001 by James.Bottomley@HansenPartnership.com
-**-----------------------------------------------------------------------------
-**  
-**  This program is free software; you can redistribute it and/or modify
-**  it under the terms of the GNU General Public License as published by
-**  the Free Software Foundation; either version 2 of the License, or
-**  (at your option) any later version.
-**
-**  This program is distributed in the hope that it will be useful,
-**  but WITHOUT ANY WARRANTY; without even the implied warranty of
-**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-**  GNU General Public License for more details.
-**
-**  You should have received a copy of the GNU General Public License
-**  along with this program; if not, write to the Free Software
-**  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-**
-**-----------------------------------------------------------------------------
- */
-
-/* Notes:
- *
- * Most of the work is done in the chip specific module, 53c700.o
- *
- * TODO List:
- *
- * 1. Extract the SCSI ID from the voyager CMOS table (necessary to
- *    support multi-host environments.
- *
- * */
-
-
-/* CHANGELOG 
- *
- * Version 2.2
- *
- * Added mca_set_adapter_name().
- *
- * Version 2.1
- *
- * Modularise the driver into a Board piece (this file) and a chip
- * piece 53c700.[ch] and 53c700.scr, added module options.  You can
- * now specify the scsi id by the parameters
- *
- * NCR_D700=slot:<n> [siop:<n>] id:<n> ....
- *
- * They need to be comma separated if compiled into the kernel
- *
- * Version 2.0
- *
- * Initial implementation of TCQ (Tag Command Queueing).  TCQ is full
- * featured and uses the clock algorithm to keep track of outstanding
- * tags and guard against individual tag starvation.  Also fixed a bug
- * in all of the 1.x versions where the D700_data_residue() function
- * was returning results off by 32 bytes (and thus causing the same 32
- * bytes to be written twice corrupting the data block).  It turns out
- * the 53c700 only has a 6 bit DBC and DFIFO registers not 7 bit ones
- * like the 53c710 (The 710 is the only data manual still available,
- * which I'd been using to program the 700).
- *
- * Version 1.2
- *
- * Much improved message handling engine
- *
- * Version 1.1
- *
- * Add code to handle selection reasonably correctly.  By the time we
- * get the selection interrupt, we've already responded, but drop off the
- * bus and hope the selector will go away.
- *
- * Version 1.0:
- *
- *   Initial release.  Fully functional except for procfs and tag
- * command queueing.  Has only been tested on cards with 53c700-66
- * chips and only single ended. Features are
- *
- * 1. Synchronous data transfers to offset 8 (limit of 700-66) and
- *    100ns (10MHz) limit of SCSI-2
- *
- * 2. Disconnection and reselection
- *
- * Testing:
- * 
- *  I've only really tested this with the 700-66 chip, but have done
- * soak tests in multi-device environments to verify that
- * disconnections and reselections are being processed correctly.
- * */
-
-#define NCR_D700_VERSION "2.2"
-
-#include <linux/blkdev.h>
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/mca.h>
-#include <linux/slab.h>
-#include <asm/io.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_spi.h>
-
-#include "53c700.h"
-#include "NCR_D700.h"
-
-static char *NCR_D700;		/* command line from insmod */
-
-MODULE_AUTHOR("James Bottomley");
-MODULE_DESCRIPTION("NCR Dual700 SCSI Driver");
-MODULE_LICENSE("GPL");
-module_param(NCR_D700, charp, 0);
-
-static __u8 id_array[2*(MCA_MAX_SLOT_NR + 1)] =
-	{ [0 ... 2*(MCA_MAX_SLOT_NR + 1)-1] = 7 };
-
-#ifdef MODULE
-#define ARG_SEP ' '
-#else
-#define ARG_SEP ','
-#endif
-
-static int __init
-param_setup(char *string)
-{
-	char *pos = string, *next;
-	int slot = -1, siop = -1;
-
-	while(pos != NULL && (next = strchr(pos, ':')) != NULL) {
-		int val = (int)simple_strtoul(++next, NULL, 0);
-
-		if(!strncmp(pos, "slot:", 5))
-			slot = val;
-		else if(!strncmp(pos, "siop:", 5))
-			siop = val;
-		else if(!strncmp(pos, "id:", 3)) {
-			if(slot == -1) {
-				printk(KERN_WARNING "NCR D700: Must specify slot for id parameter\n");
-			} else if(slot > MCA_MAX_SLOT_NR) {
-				printk(KERN_WARNING "NCR D700: Illegal slot %d for id %d\n", slot, val);
-			} else {
-				if(siop != 0 && siop != 1) {
-					id_array[slot*2] = val;
-					id_array[slot*2 + 1] =val;
-				} else {
-					id_array[slot*2 + siop] = val;
-				}
-			}
-		}
-		if((pos = strchr(pos, ARG_SEP)) != NULL)
-			pos++;
-	}
-	return 1;
-}
-
-/* Host template.  The 53c700 routine NCR_700_detect will
- * fill in all of the missing routines */
-static struct scsi_host_template NCR_D700_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= "NCR Dual 700 MCA",
-	.proc_name		= "NCR_D700",
-	.this_id		= 7,
-};
-
-/* We needs this helper because we have two hosts per struct device */
-struct NCR_D700_private {
-	struct device		*dev;
-	struct Scsi_Host	*hosts[2];
-	char			name[30];
-	char			pad;
-};
-
-static int
-NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
-		   int slot, u32 region, int differential)
-{
-	struct NCR_700_Host_Parameters *hostdata;
-	struct Scsi_Host *host;
-	int ret;
-
-	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host"
-		       "data, detatching\n", siop);
-		return -ENOMEM;
-	}
-
-	if (!request_region(region, 64, "NCR_D700")) {
-		printk(KERN_ERR "NCR D700: Failed to reserve IO region 0x%x\n",
-				region);
-		ret = -ENODEV;
-		goto region_failed;
-	}
-		
-	/* Fill in the three required pieces of hostdata */
-	hostdata->base = ioport_map(region, 64);
-	hostdata->differential = (((1<<siop) & differential) != 0);
-	hostdata->clock = NCR_D700_CLOCK_MHZ;
-	hostdata->burst_length = 8;
-
-	/* and register the siop */
-	host = NCR_700_detect(&NCR_D700_driver_template, hostdata, p->dev);
-	if (!host) {
-		ret = -ENOMEM;
-		goto detect_failed;
-	}
-
-	p->hosts[siop] = host;
-	/* FIXME: read this from SUS */
-	host->this_id = id_array[slot * 2 + siop];
-	host->irq = irq;
-	host->base = region;
-	scsi_scan_host(host);
-
-	return 0;
-
- detect_failed:
-	release_region(region, 64);
- region_failed:
-	kfree(hostdata);
-
-	return ret;
-}
-
-static irqreturn_t
-NCR_D700_intr(int irq, void *data)
-{
-	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
-	int i, found = 0;
-
-	for (i = 0; i < 2; i++)
-		if (p->hosts[i] &&
-		    NCR_700_intr(irq, p->hosts[i]) == IRQ_HANDLED)
-			found++;
-
-	return found ? IRQ_HANDLED : IRQ_NONE;
-}
-
-/* Detect a D700 card.  Note, because of the setup --- the chips are
- * essentially connectecd to the MCA bus independently, it is easier
- * to set them up as two separate host adapters, rather than one
- * adapter with two channels */
-static int
-NCR_D700_probe(struct device *dev)
-{
-	struct NCR_D700_private *p;
-	int differential;
-	static int banner = 1;
-	struct mca_device *mca_dev = to_mca_device(dev);
-	int slot = mca_dev->slot;
-	int found = 0;
-	int irq, i;
-	int pos3j, pos3k, pos3a, pos3b, pos4;
-	__u32 base_addr, offset_addr;
-
-	/* enable board interrupt */
-	pos4 = mca_device_read_pos(mca_dev, 4);
-	pos4 |= 0x4;
-	mca_device_write_pos(mca_dev, 4, pos4);
-
-	mca_device_write_pos(mca_dev, 6, 9);
-	pos3j = mca_device_read_pos(mca_dev, 3);
-	mca_device_write_pos(mca_dev, 6, 10);
-	pos3k = mca_device_read_pos(mca_dev, 3);
-	mca_device_write_pos(mca_dev, 6, 0);
-	pos3a = mca_device_read_pos(mca_dev, 3);
-	mca_device_write_pos(mca_dev, 6, 1);
-	pos3b = mca_device_read_pos(mca_dev, 3);
-
-	base_addr = ((pos3j << 8) | pos3k) & 0xfffffff0;
-	offset_addr = ((pos3a << 8) | pos3b) & 0xffffff70;
-
-	irq = (pos4 & 0x3) + 11;
-	if(irq >= 13)
-		irq++;
-	if(banner) {
-		printk(KERN_NOTICE "NCR D700: Driver Version " NCR_D700_VERSION "\n"
-		       "NCR D700:  Copyright (c) 2001 by James.Bottomley@HansenPartnership.com\n"
-		       "NCR D700:\n");
-		banner = 0;
-	}
-	/* now do the bus related transforms */
-	irq = mca_device_transform_irq(mca_dev, irq);
-	base_addr = mca_device_transform_ioport(mca_dev, base_addr);
-	offset_addr = mca_device_transform_ioport(mca_dev, offset_addr);
-
-	printk(KERN_NOTICE "NCR D700: found in slot %d  irq = %d  I/O base = 0x%x\n", slot, irq, offset_addr);
-
-	/*outb(BOARD_RESET, base_addr);*/
-
-	/* clear any pending interrupts */
-	(void)inb(base_addr + 0x08);
-	/* get modctl, used later for setting diff bits */
-	switch(differential = (inb(base_addr + 0x08) >> 6)) {
-	case 0x00:
-		/* only SIOP1 differential */
-		differential = 0x02;
-		break;
-	case 0x01:
-		/* Both SIOPs differential */
-		differential = 0x03;
-		break;
-	case 0x03:
-		/* No SIOPs differential */
-		differential = 0x00;
-		break;
-	default:
-		printk(KERN_ERR "D700: UNEXPECTED DIFFERENTIAL RESULT 0x%02x\n",
-		       differential);
-		differential = 0x00;
-		break;
-	}
-
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	p->dev = dev;
-	snprintf(p->name, sizeof(p->name), "D700(%s)", dev_name(dev));
-	if (request_irq(irq, NCR_D700_intr, IRQF_SHARED, p->name, p)) {
-		printk(KERN_ERR "D700: request_irq failed\n");
-		kfree(p);
-		return -EBUSY;
-	}
-	/* plumb in both 700 chips */
-	for (i = 0; i < 2; i++) {
-		int err;
-
-		if ((err = NCR_D700_probe_one(p, i, irq, slot,
-					      offset_addr + (0x80 * i),
-					      differential)) != 0)
-			printk("D700: SIOP%d: probe failed, error = %d\n",
-			       i, err);
-		else
-			found++;
-	}
-
-	if (!found) {
-		kfree(p);
-		return -ENODEV;
-	}
-
-	mca_device_set_claim(mca_dev, 1);
-	mca_device_set_name(mca_dev, "NCR_D700");
-	dev_set_drvdata(dev, p);
-	return 0;
-}
-
-static void
-NCR_D700_remove_one(struct Scsi_Host *host)
-{
-	scsi_remove_host(host);
-	NCR_700_release(host);
-	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
-	free_irq(host->irq, host);
-	release_region(host->base, 64);
-}
-
-static int
-NCR_D700_remove(struct device *dev)
-{
-	struct NCR_D700_private *p = dev_get_drvdata(dev);
-	int i;
-
-	for (i = 0; i < 2; i++)
-		NCR_D700_remove_one(p->hosts[i]);
-
-	kfree(p);
-	return 0;
-}
-
-static short NCR_D700_id_table[] = { NCR_D700_MCA_ID, 0 };
-
-static struct mca_driver NCR_D700_driver = {
-	.id_table = NCR_D700_id_table,
-	.driver = {
-		.name		= "NCR_D700",
-		.bus		= &mca_bus_type,
-		.probe		= NCR_D700_probe,
-		.remove		= NCR_D700_remove,
-	},
-};
-
-static int __init NCR_D700_init(void)
-{
-#ifdef MODULE
-	if (NCR_D700)
-		param_setup(NCR_D700);
-#endif
-
-	return mca_register_driver(&NCR_D700_driver);
-}
-
-static void __exit NCR_D700_exit(void)
-{
-	mca_unregister_driver(&NCR_D700_driver);
-}
-
-module_init(NCR_D700_init);
-module_exit(NCR_D700_exit);
-
-__setup("NCR_D700=", param_setup);
diff --git a/drivers/scsi/NCR_D700.h b/drivers/scsi/NCR_D700.h
deleted file mode 100644
index eb675d782ef6..000000000000
--- a/drivers/scsi/NCR_D700.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* -*- mode: c; c-basic-offset: 8 -*- */
-
-/* NCR Dual 700 MCA SCSI Driver
- *
- * Copyright (C) 2001 by James.Bottomley@HansenPartnership.com
- */
-
-#ifndef _NCR_D700_H
-#define _NCR_D700_H
-
-/* Don't turn on debugging messages */
-#undef NCR_D700_DEBUG
-
-/* The MCA identifier */
-#define NCR_D700_MCA_ID		0x0092
-
-/* Defines for the Board registers */
-#define	BOARD_RESET		0x80	/* board level reset */
-#define ADD_PARENB		0x04	/* Address Parity Enabled */
-#define DAT_PARENB		0x01	/* Data Parity Enabled */
-#define SFBK_ENB		0x10	/* SFDBK Interrupt Enabled */
-#define LED0GREEN		0x20	/* Led 0 (red 0; green 1) */
-#define LED1GREEN		0x40	/* Led 1 (red 0; green 1) */
-#define LED0RED			0xDF	/* Led 0 (red 0; green 1) */
-#define LED1RED			0xBF	/* Led 1 (red 0; green 1) */
-
-#define NCR_D700_CLOCK_MHZ	50
-
-#endif
-- 
2.16.4
