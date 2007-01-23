From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 3/4] aacraid: Begin adding support for new adapter type
Date: Tue, 23 Jan 2007 15:00:13 -0800
Message-ID: <1169593213.10440.24.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965551AbXAWXAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 18:00:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

Add in the NEMER/ARK physical register mapping, represented in up and coming
products currently under test at Adaptec.

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2007-01-18 10:06:54.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2007-01-18 10:11:28.000000000 -0800
@@ -1810,6 +1810,7 @@
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg);
 int aac_rx_init(struct aac_dev *dev);
 int aac_rkt_init(struct aac_dev *dev);
+int aac_nark_init(struct aac_dev *dev);
 int aac_sa_init(struct aac_dev *dev);
 int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long *nonotify);
 unsigned int aac_response_normal(struct aac_queue * q);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2007-01-18 10:11:26.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2007-01-18 10:11:28.000000000 -0800
@@ -157,6 +157,7 @@
 	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 58 }, /* Legend Catchall */
 	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec Catch All */
 	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec Rocket Catch All */
+	{ 0x9005, 0x0288, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 61 }, /* Adaptec NEMER/ARK Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -230,7 +231,8 @@
 	{ aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Dell Catchall */
 	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend Catchall */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec Catch All */
-	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec Rocket Catch All */
+	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Rocket Catch All */
+	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec NEMER/ARK Catch All */
 };
 
 /**
@@ -804,7 +806,6 @@
 	.emulated                       = 1,
 };
 
-
 static int __devinit aac_probe_one(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
--- scsi-misc-aac.orig/drivers/scsi/aacraid/Makefile	2007-01-18 10:06:54.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/Makefile	2007-01-18 10:11:28.000000000 -0800
@@ -3,6 +3,6 @@
 obj-$(CONFIG_SCSI_AACRAID) := aacraid.o
 
 aacraid-objs	:= linit.o aachba.o commctrl.o comminit.o commsup.o \
-		   dpcsup.o rx.o sa.o rkt.o
+		   dpcsup.o rx.o sa.o rkt.o nark.o
 
 EXTRA_CFLAGS	:= -Idrivers/scsi
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ scsi-misc-aac/drivers/scsi/aacraid/nark.c	2007-01-18 10:11:28.000000000 -0800
@@ -0,0 +1,87 @@
+/*
+ *	Adaptec AAC series RAID controller driver
+ *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *
+ * based on the old aacraid driver that is..
+ * Adaptec aacraid device driver for Linux.
+ *
+ * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Module Name:
+ *  nark.c
+ *
+ * Abstract: Hardware Device Interface for NEMER/ARK
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/blkdev.h>
+
+#include <scsi/scsi_host.h>
+
+#include "aacraid.h"
+
+/**
+ *	aac_nark_ioremap
+ *	@size: mapping resize request
+ *
+ */
+static int aac_nark_ioremap(struct aac_dev * dev, u32 size)
+{
+	if (!size) {
+		iounmap(dev->regs.rx);
+		dev->regs.rx = NULL;
+		iounmap(dev->base);
+		dev->base = NULL;
+		return 0;
+	}
+	dev->scsi_host_ptr->base = pci_resource_start(dev->pdev, 2);
+	dev->regs.rx = ioremap((u64)pci_resource_start(dev->pdev, 0) |
+	  ((u64)pci_resource_start(dev->pdev, 1) << 32),
+	  sizeof(struct rx_registers) - sizeof(struct rx_inbound));
+	dev->base = NULL;
+	if (dev->regs.rx == NULL)
+		return -1;
+	dev->base = ioremap(dev->scsi_host_ptr->base, size);
+	if (dev->base == NULL) {
+		iounmap(dev->regs.rx);
+		dev->regs.rx = NULL;
+		return -1;
+	}
+	dev->IndexRegs = &((struct rx_registers __iomem *)dev->base)->IndexRegs;
+	return 0;
+}
+
+/**
+ *	aac_nark_init	-	initialize an NEMER/ARK Split Bar card
+ *	@dev: device to configure
+ *
+ */
+
+int aac_nark_init(struct aac_dev * dev)
+{
+	extern int _aac_rx_init(struct aac_dev *dev);
+	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
+
+	/*
+	 *	Fill in the function dispatch table.
+	 */
+	dev->a_ops.adapter_ioremap = aac_nark_ioremap;
+	dev->a_ops.adapter_comm = aac_rx_select_comm;
+
+	return _aac_rx_init(dev);
+}

-- 
Mark Haverkamp <markh@linux-foundation.org>

