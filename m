From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] add card types to 2.6.2 aacraid driver
Date: Wed, 04 Feb 2004 11:15:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075922128.16628.41.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:3799 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264285AbUBDTPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2004 14:15:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch adds support for new RAID cards.  Also removes two cards from
the list that were never products.


 Makefile  |    2 
 aacraid.h |   21 +++
 linit.c   |   32 +++-
 rkt.c     |  416 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rx.c      |   10 -
 5 files changed, 465 insertions(+), 16 deletions(-)

===== drivers/scsi/aacraid/Makefile 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/Makefile	Wed May  7 19:18:41 2003
+++ edited/drivers/scsi/aacraid/Makefile	Wed Jan 28 11:09:15 2004
@@ -3,6 +3,6 @@
 obj-$(CONFIG_SCSI_AACRAID) := aacraid.o
 
 aacraid-objs	:= linit.o aachba.o commctrl.o comminit.o commsup.o \
-		   dpcsup.o rx.o sa.o
+		   dpcsup.o rx.o sa.o rkt.o
 
 EXTRA_CFLAGS	:= -Idrivers/scsi
===== drivers/scsi/aacraid/aacraid.h 1.11 vs edited =====
--- 1.11/drivers/scsi/aacraid/aacraid.h	Mon Jan 12 07:29:39 2004
+++ edited/drivers/scsi/aacraid/aacraid.h	Wed Jan 28 11:37:58 2004
@@ -713,6 +713,24 @@
 #define rx_writeb(AEP, CSR, value)	writeb(value, &((AEP)->regs.rx->CSR))
 #define rx_writel(AEP, CSR, value)	writel(value, &((AEP)->regs.rx->CSR))
 
+/*
+ *	Rkt Message Unit Registers (same as Rx, except a larger reserve region)
+ */
+
+#define rkt_mu_registers rx_mu_registers
+#define rkt_inbound rx_inbound
+
+struct rkt_registers {
+	struct rkt_mu_registers		MUnit;		 /* 1300h - 1334h */
+	u32				reserved1[1010]; /* 1338h - 22fch */
+	struct rkt_inbound		IndexRegs;	 /* 2300h - */
+};
+
+#define rkt_readb(AEP, CSR)		readb(&((AEP)->regs.rkt->CSR))
+#define rkt_readl(AEP, CSR)		readl(&((AEP)->regs.rkt->CSR))
+#define rkt_writeb(AEP, CSR, value)	writeb(value, &((AEP)->regs.rkt->CSR))
+#define rkt_writel(AEP, CSR, value)	writel(value, &((AEP)->regs.rkt->CSR))
+
 struct fib;
 
 typedef void (*fib_callback)(void *ctxt, struct fib *fibctx);
@@ -889,7 +907,9 @@
 	{
 		struct sa_registers *sa;
 		struct rx_registers *rx;
+		struct rkt_registers *rkt;
 	} regs;
+	u32			OIMR; /* Mask Register Cache */
 	/*
 	 *	The following is the number of the individual adapter
 	 */
@@ -1492,6 +1512,7 @@
 int aac_dev_ioctl(struct aac_dev *dev, int cmd, void *arg);
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void *arg);
 int aac_rx_init(struct aac_dev *dev, unsigned long devNumber);
+int aac_rkt_init(struct aac_dev *dev, unsigned long devNumber);
 int aac_sa_init(struct aac_dev *dev, unsigned long devNumber);
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
===== drivers/scsi/aacraid/linit.c 1.24 vs edited =====
--- 1.24/drivers/scsi/aacraid/linit.c	Thu Jan 22 01:57:36 2004
+++ edited/drivers/scsi/aacraid/linit.c	Tue Feb  3 14:46:46 2004
@@ -101,14 +101,20 @@
 	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
 	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
 	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 20 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
-	{ 0x9005, 0x0250, 0x1014, 0x0279, 0, 0, 21 }, /* (Marco)*/
-	{ 0x9005, 0x0250, 0x1014, 0x028c, 0, 0, 22 }, /* (Sebring)*/
 
-	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 23 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 24 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 25 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 26 }, /* Dell PERC2 "Quad Channel" */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 27 }, /* HP NetRAID-4M */
+	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 21 }, /* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 22 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 23 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 24 }, /* Dell PERC2 "Quad Channel" */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 25 }, /* HP NetRAID-4M */
+
+	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 26 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 27 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 28 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 29 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ 0x9005, 0x0285, 0x0E11, 0x0295, 0, 0, 30 }, /* SATA 6Ch (Bearcat) */
+
+	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 31 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -141,14 +147,20 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Marco)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Sebring)*/
 
 	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
 	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT }, /* Dell PERC2 "Quad Channel" */
-	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }  /* HP NetRAID-4M */
+	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 },  /* HP NetRAID-4M */
+
+	{ aac_rx_init, "aacraid",  "DELL    ", "CERC SR2        ", 1 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 1 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA", 1 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SO-DIMM SATA ZCR", 1 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SATA 6Channel   ", 1 }, /* SATA 6Ch (Bearcat) */
+
+	{ aac_rkt_init,"aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
 };
 
 /**
===== drivers/scsi/aacraid/rkt.c 1.1 vs edited =====
--- 1.1/drivers/scsi/aacraid/rkt.c	Tue Feb  3 15:18:17 2004
+++ edited/drivers/scsi/aacraid/rkt.c	Tue Feb  3 15:18:33 2004
@@ -0,0 +1,416 @@
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
+ *  rkt.c
+ *
+ * Abstract: Hardware miniport for Drawbridge specific hardware functions.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+#include <asm/semaphore.h>
+
+#include <scsi/scsi_host.h>
+
+#include "aacraid.h"
+
+static irqreturn_t aac_rkt_intr(int irq, void *dev_id, struct pt_regs *regs)
+{
+	struct aac_dev *dev = dev_id;
+	unsigned long bellbits;
+	u8 intstat, mask;
+	intstat = rkt_readb(dev, MUnit.OISR);
+	/*
+	 *	Read mask and invert because drawbridge is reversed.
+	 *	This allows us to only service interrupts that have 
+	 *	been enabled.
+	 */
+	mask = ~(dev->OIMR);
+	/* Check to see if this is our interrupt.  If it isn't just return */
+	if (intstat & mask) 
+	{
+		bellbits = rkt_readl(dev, OutboundDoorbellReg);
+		if (bellbits & DoorBellPrintfReady) {
+			aac_printf(dev, le32_to_cpu(rkt_readl (dev, IndexRegs.Mailbox[5])));
+			rkt_writel(dev, MUnit.ODR,DoorBellPrintfReady);
+			rkt_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
+		}
+		else if (bellbits & DoorBellAdapterNormCmdReady) {
+			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
+		}
+		else if (bellbits & DoorBellAdapterNormRespReady) {
+			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
+			rkt_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
+		}
+		else if (bellbits & DoorBellAdapterNormCmdNotFull) {
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+		}
+		else if (bellbits & DoorBellAdapterNormRespNotFull) {
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+		}
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+/**
+ *	aac_rkt_enable_interrupt	-	Enable event reporting
+ *	@dev: Adapter
+ *	@event: Event to enable
+ *
+ *	Enable event reporting from the i960 for a given event.
+ */
+ 
+static void aac_rkt_enable_interrupt(struct aac_dev * dev, u32 event)
+{
+	switch (event) {
+
+	case HostNormCmdQue:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_1);
+		break;
+
+	case HostNormRespQue:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_2);
+		break;
+
+	case AdapNormCmdNotFull:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_3);
+		break;
+
+	case AdapNormRespNotFull:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_4);
+		break;
+	}
+}
+
+/**
+ *	aac_rkt_disable_interrupt	-	Disable event reporting
+ *	@dev: Adapter
+ *	@event: Event to enable
+ *
+ *	Disable event reporting from the i960 for a given event.
+ */
+
+static void aac_rkt_disable_interrupt(struct aac_dev *dev, u32 event)
+{
+	switch (event) {
+
+	case HostNormCmdQue:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_1);
+		break;
+
+	case HostNormRespQue:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_2);
+		break;
+
+	case AdapNormCmdNotFull:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_3);
+		break;
+
+	case AdapNormRespNotFull:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_4);
+		break;
+	}
+}
+
+/**
+ *	rkt_sync_cmd	-	send a command and wait
+ *	@dev: Adapter
+ *	@command: Command to execute
+ *	@p1: first parameter
+ *	@ret: adapter status
+ *
+ *	This routine will send a synchronous comamnd to the adapter and wait 
+ *	for its	completion.
+ */
+
+static int rkt_sync_cmd(struct aac_dev *dev, u32 command, u32 p1, u32 *status)
+{
+	unsigned long start;
+	int ok;
+	/*
+	 *	Write the command into Mailbox 0
+	 */
+	rkt_writel(dev, InboundMailbox0, cpu_to_le32(command));
+	/*
+	 *	Write the parameters into Mailboxes 1 - 4
+	 */
+	rkt_writel(dev, InboundMailbox1, cpu_to_le32(p1));
+	rkt_writel(dev, InboundMailbox2, 0);
+	rkt_writel(dev, InboundMailbox3, 0);
+	rkt_writel(dev, InboundMailbox4, 0);
+	/*
+	 *	Clear the synch command doorbell to start on a clean slate.
+	 */
+	rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
+	/*
+	 *	Disable doorbell interrupts
+	 */
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR |= 0x04);
+	/*
+	 *	Force the completion of the mask register write before issuing
+	 *	the interrupt.
+	 */
+	rkt_readb (dev, MUnit.OIMR);
+	/*
+	 *	Signal that there is a new synch command
+	 */
+	rkt_writel(dev, InboundDoorbellReg, INBOUNDDOORBELL_0);
+
+	ok = 0;
+	start = jiffies;
+
+	/*
+	 *	Wait up to 30 seconds
+	 */
+	while (time_before(jiffies, start+30*HZ)) 
+	{
+		udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
+		/*
+		 *	Mon960 will set doorbell0 bit when it has completed the command.
+		 */
+		if (rkt_readl(dev, OutboundDoorbellReg) & OUTBOUNDDOORBELL_0) {
+			/*
+			 *	Clear the doorbell.
+			 */
+			rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
+			ok = 1;
+			break;
+		}
+		/*
+		 *	Yield the processor in case we are slow 
+		 */
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1);
+	}
+	if (ok != 1) {
+		/*
+		 *	Restore interrupt mask even though we timed out
+		 */
+		rkt_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
+		return -ETIMEDOUT;
+	}
+	/*
+	 *	Pull the synch status from Mailbox 0.
+	 */
+	*status = le32_to_cpu(rkt_readl(dev, IndexRegs.Mailbox[0]));
+	/*
+	 *	Clear the synch command doorbell.
+	 */
+	rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
+	/*
+	 *	Restore interrupt mask
+	 */
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
+	return 0;
+
+}
+
+/**
+ *	aac_rkt_interrupt_adapter	-	interrupt adapter
+ *	@dev: Adapter
+ *
+ *	Send an interrupt to the i960 and breakpoint it.
+ */
+
+static void aac_rkt_interrupt_adapter(struct aac_dev *dev)
+{
+	u32 ret;
+	rkt_sync_cmd(dev, BREAKPOINT_REQUEST, 0, &ret);
+}
+
+/**
+ *	aac_rkt_notify_adapter		-	send an event to the adapter
+ *	@dev: Adapter
+ *	@event: Event to send
+ *
+ *	Notify the i960 that something it probably cares about has
+ *	happened.
+ */
+
+static void aac_rkt_notify_adapter(struct aac_dev *dev, u32 event)
+{
+	switch (event) {
+
+	case AdapNormCmdQue:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_1);
+		break;
+	case HostNormRespNotFull:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_4);
+		break;
+	case AdapNormRespQue:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_2);
+		break;
+	case HostNormCmdNotFull:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_3);
+		break;
+	case HostShutdown:
+//		rkt_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, &ret);
+		break;
+	case FastIo:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_6);
+		break;
+	case AdapPrintfDone:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_5);
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+/**
+ *	aac_rkt_start_adapter		-	activate adapter
+ *	@dev:	Adapter
+ *
+ *	Start up processing on an i960 based AAC adapter
+ */
+
+static void aac_rkt_start_adapter(struct aac_dev *dev)
+{
+	u32 status;
+	struct aac_init *init;
+
+	init = dev->init;
+	init->HostElapsedSeconds = cpu_to_le32(jiffies/HZ);
+	/*
+	 *	Tell the adapter we are back and up and running so it will scan
+	 *	its command queues and enable our interrupts
+	 */
+	dev->irq_mask = (DoorBellPrintfReady | OUTBOUNDDOORBELL_1 | OUTBOUNDDOORBELL_2 | OUTBOUNDDOORBELL_3 | OUTBOUNDDOORBELL_4);
+	/*
+	 *	First clear out all interrupts.  Then enable the one's that we
+	 *	can handle.
+	 */
+	rkt_writeb(dev, MUnit.OIMR, 0xff);
+	rkt_writel(dev, MUnit.ODR, 0xffffffff);
+//	rkt_writeb(dev, MUnit.OIMR, ~(u8)OUTBOUND_DOORBELL_INTERRUPT_MASK);
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+
+	// We can only use a 32 bit address here
+	rkt_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &status);
+}
+
+/**
+ *	aac_rkt_init	-	initialize an i960 based AAC card
+ *	@dev: device to configure
+ *	@devnum: adapter number
+ *
+ *	Allocate and set up resources for the i960 based AAC variants. The 
+ *	device_interface in the commregion will be allocated and linked 
+ *	to the comm region.
+ */
+
+int aac_rkt_init(struct aac_dev *dev, unsigned long num)
+{
+	unsigned long start;
+	unsigned long status;
+	int instance;
+	const char * name;
+
+	dev->devnum = num;
+	instance = dev->id;
+	name     = dev->name;
+
+	/*
+	 *	Map in the registers from the adapter.
+	 */
+	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
+	{	
+		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
+		return -1;
+	}
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & SELF_TEST_FAILED) {
+		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
+		return -1;
+	}
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_PANIC) {
+		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
+		return -1;
+	}
+	start = jiffies;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
+	 */
+	while (!(rkt_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_UP_AND_RUNNING)) 
+	{
+		if(time_after(jiffies, start+180*HZ))
+		{
+			status = rkt_readl(dev, IndexRegs.Mailbox[7]) >> 16;
+			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %ld.\n", dev->name, instance, status);
+			return -1;
+		}
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1);
+	}
+	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
+	{
+		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name, instance);
+		return -1;
+	}
+	/*
+	 *	Fill in the function dispatch table.
+	 */
+	dev->a_ops.adapter_interrupt = aac_rkt_interrupt_adapter;
+	dev->a_ops.adapter_enable_int = aac_rkt_enable_interrupt;
+	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
+	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
+	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
+
+	if (aac_init_adapter(dev) == NULL)
+		return -1;
+	/*
+	 *	Start any kernel threads needed
+	 */
+	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
+	if(dev->thread_pid < 0)
+	{
+		printk(KERN_ERR "aacraid: Unable to create rkt thread.\n");
+		return -1;
+	}	
+	/*
+	 *	Tell the adapter that all is configured, and it can start
+	 *	accepting requests
+	 */
+	aac_rkt_start_adapter(dev);
+	return 0;
+}
===== drivers/scsi/aacraid/rx.c 1.5 vs edited =====
--- 1.5/drivers/scsi/aacraid/rx.c	Wed Nov 19 10:38:55 2003
+++ edited/drivers/scsi/aacraid/rx.c	Tue Feb  3 14:23:03 2004
@@ -56,7 +56,7 @@
 	 *	This allows us to only service interrupts that have 
 	 *	been enabled.
 	 */
-	mask = ~(rx_readb(dev, MUnit.OIMR));
+	mask = ~(dev->OIMR);
 	/* Check to see if this is our interrupt.  If it isn't just return */
 	if (intstat & mask) 
 	{
@@ -179,7 +179,7 @@
 	/*
 	 *	Disable doorbell interrupts
 	 */
-	rx_writeb(dev, MUnit.OIMR, rx_readb(dev, MUnit.OIMR) | 0x04);
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR |= 0x04);
 	/*
 	 *	Force the completion of the mask register write before issuing
 	 *	the interrupt.
@@ -220,7 +220,7 @@
 		/*
 		 *	Restore interrupt mask even though we timed out
 		 */
-		rx_writeb(dev, MUnit.OIMR, rx_readl(dev, MUnit.OIMR) & 0xfb);
+		rx_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
 		return -ETIMEDOUT;
 	}
 	/*
@@ -234,7 +234,7 @@
 	/*
 	 *	Restore interrupt mask
 	 */
-	rx_writeb(dev, MUnit.OIMR, rx_readl(dev, MUnit.OIMR) & 0xfb);
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
 	return 0;
 
 }
@@ -318,7 +318,7 @@
 	rx_writeb(dev, MUnit.OIMR, 0xff);
 	rx_writel(dev, MUnit.ODR, 0xffffffff);
 //	rx_writeb(dev, MUnit.OIMR, ~(u8)OUTBOUND_DOORBELL_INTERRUPT_MASK);
-	rx_writeb(dev, MUnit.OIMR, 0xfb);
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 
 	// We can only use a 32 bit address here
 	rx_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &status);



-- 
Mark Haverkamp <markh@osdl.org>

