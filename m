From: wfg@linux.intel.com
Subject: [scsi:pending 3/3] drivers/scsi/aacraid/src.c:425:2: warning: right
 shift count >= width of type
Date: Thu, 21 Jun 2012 01:12:39 +0800
Message-ID: <20120620171239.GB5512@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+pHx0qQiF2pBVqBT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60699 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab2FTRMs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jun 2012 13:12:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@ubuntu.com>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ben,

There are new compile warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git pending
head:   e766db42f45c7685fce5c0d48ba74eaa97e6d715
commit: e766db42f45c7685fce5c0d48ba74eaa97e6d715 [3/3] [SCSI] aacraid: Fix endian issues in core and SRC portions of driver

All warnings:

drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
drivers/scsi/aacraid/src.c:425:2: warning: right shift count >= width of type [enabled by default]

drivers/scsi/aacraid/src.c:425:
   422		if (address & (ALIGN32 - 1))
   423			return -EINVAL;
   424		address |= fibsize;
 > 425		src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
   426		src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
   427	
   428		return 0;

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation

--+pHx0qQiF2pBVqBT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-SCSI-aacraid-Fix-endian-issues-in-core-and-SRC-porti.patch"

>From e766db42f45c7685fce5c0d48ba74eaa97e6d715 Mon Sep 17 00:00:00 2001
From: Ben Collins <bcollins@ubuntu.com>
Date: Mon, 11 Jun 2012 16:14:36 -0400
Subject: [PATCH] [SCSI] aacraid: Fix endian issues in core and SRC portions
 of driver

This may not fix all endian issues in this driver, but it does get the
driver working on PowerPC for a PMC SRC card. So it should at least fix
all the problems in the core and in the SRC support.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Achim Leubner <Achim_Leubner@pmc-sierra.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
---
 drivers/scsi/aacraid/comminit.c |    4 ++--
 drivers/scsi/aacraid/src.c      |   46 ++++++++++++++++++++++++---------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index a35f54e..8e4b525 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -126,20 +126,20 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 			"aacraid: New Comm Interface type1 enabled\n"));
 	}
 	init->InitFlags |= cpu_to_le32(INITFLAGS_DRIVER_USES_UTC_TIME |
 				       INITFLAGS_DRIVER_SUPPORTS_PM);
 	init->MaxIoCommands = cpu_to_le32(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
 	init->MaxIoSize = cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
 	init->MaxFibSize = cpu_to_le32(dev->max_fib_size);
 
 	init->MaxNumAif = cpu_to_le32(dev->max_num_aif);
-	init->HostRRQ_AddrHigh = (u32)((u64)dev->host_rrq_pa >> 32);
-	init->HostRRQ_AddrLow = (u32)(dev->host_rrq_pa & 0xffffffff);
+	init->HostRRQ_AddrHigh = cpu_to_le32((u32)((u64)dev->host_rrq_pa >> 32));
+	init->HostRRQ_AddrLow = cpu_to_le32((u32)(dev->host_rrq_pa & 0xffffffff));
 
 
 	/*
 	 * Increment the base address by the amount already used
 	 */
 	base = base + fibsize + host_rrq_size + sizeof(struct aac_init);
 	phys = (dma_addr_t)((ulong)phys + fibsize + host_rrq_size +
 		sizeof(struct aac_init));
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 27a3e77..0fb1f55 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -68,19 +68,19 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 					index = 0;
 				if (dev->host_rrq[index] != 0)
 					break;
 			} while (index != old_index);
 			dev->host_rrq_idx = index;
 		}
 		for (;;) {
 			isFastResponse = 0;
 			/* remove toggle bit (31) */
-			handle = (dev->host_rrq[index] & 0x7fffffff);
+			handle = le32_to_cpu(dev->host_rrq[index]) & 0x7fffffff;
 			/* check fast response bit (30) */
 			if (handle & 0x40000000)
 				isFastResponse = 1;
 			handle &= 0x0000ffff;
 			if (handle == 0)
 				break;
 
 			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
 
@@ -383,42 +383,54 @@ static int aac_src_check_health(struct aac_dev *dev)
  *
  *	Will send a fib, returning 0 if successful.
  */
 static int aac_src_deliver_message(struct fib *fib)
 {
 	struct aac_dev *dev = fib->dev;
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
 	unsigned long qflags;
 	u32 fibsize;
-	u64 address;
+	dma_addr_t address;
 	struct aac_fib_xporthdr *pFibX;
+	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);
 
 	spin_lock_irqsave(q->lock, qflags);
 	q->numpending++;
 	spin_unlock_irqrestore(q->lock, qflags);
 
 	/* Calculate the amount to the fibsize bits */
-	fibsize = (sizeof(struct aac_fib_xporthdr) +
-		fib->hw_fib_va->header.Size + 127) / 128 - 1;
+	fibsize = (sizeof(struct aac_fib_xporthdr) + hdr_size + 127) / 128 - 1;
 	if (fibsize > (ALIGN32 - 1))
-		fibsize = ALIGN32 - 1;
-
-    /* Fill XPORT header */
-	pFibX = (struct aac_fib_xporthdr *)
-		((unsigned char *)fib->hw_fib_va -
-		sizeof(struct aac_fib_xporthdr));
-	pFibX->Handle = fib->hw_fib_va->header.SenderData + 1;
-	pFibX->HostAddress = fib->hw_fib_pa;
-	pFibX->Size = fib->hw_fib_va->header.Size;
-	address = fib->hw_fib_pa - (u64)sizeof(struct aac_fib_xporthdr);
-
-	src_writel(dev, MUnit.IQ_H, (u32)(address >> 32));
-	src_writel(dev, MUnit.IQ_L, (u32)(address & 0xffffffff) + fibsize);
+		return -EMSGSIZE;
+
+	/* Fill XPORT header */
+	pFibX = (void *)fib->hw_fib_va - sizeof(struct aac_fib_xporthdr);
+	/*
+	 * This was stored by aac_fib_send() and it is the index into
+	 * dev->fibs. Not sure why we add 1 to it, but I suspect that it's
+	 * because it can't be zero when we pass it to the hardware. Note that
+	 * it was stored in native endian, hence the lack of swapping. -- BenC
+	 */
+	pFibX->Handle = cpu_to_le32(fib->hw_fib_va->header.SenderData + 1);
+	pFibX->HostAddress = cpu_to_le64(fib->hw_fib_pa);
+	pFibX->Size = cpu_to_le32(hdr_size);
+
+	/*
+	 * The xport header has been 32-byte aligned for us so that fibsize
+	 * can be masked out of this address by hardware. -- BenC
+	 */
+	address = fib->hw_fib_pa - sizeof(struct aac_fib_xporthdr);
+	if (address & (ALIGN32 - 1))
+		return -EINVAL;
+	address |= fibsize;
+	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
+
 	return 0;
 }
 
 /**
  *	aac_src_ioremap
  *	@size: mapping resize request
  *
  */
 static int aac_src_ioremap(struct aac_dev *dev, u32 size)
-- 
1.7.10


--+pHx0qQiF2pBVqBT
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="src.c"

/*
 *	Adaptec AAC series RAID controller driver
 *	(c) Copyright 2001 Red Hat Inc.
 *
 * based on the old aacraid driver that is..
 * Adaptec aacraid device driver for Linux.
 *
 * Copyright (c) 2000-2010 Adaptec, Inc.
 *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * Module Name:
 *  src.c
 *
 * Abstract: Hardware Device Interface for PMC SRC based controllers
 *
 */

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/types.h>
#include <linux/pci.h>
#include <linux/spinlock.h>
#include <linux/slab.h>
#include <linux/blkdev.h>
#include <linux/delay.h>
#include <linux/completion.h>
#include <linux/time.h>
#include <linux/interrupt.h>
#include <scsi/scsi_host.h>

#include "aacraid.h"

static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
{
	struct aac_dev *dev = dev_id;
	unsigned long bellbits, bellbits_shifted;
	int our_interrupt = 0;
	int isFastResponse;
	u32 index, handle;

	bellbits = src_readl(dev, MUnit.ODR_R);
	if (bellbits & PmDoorBellResponseSent) {
		bellbits = PmDoorBellResponseSent;
		/* handle async. status */
		our_interrupt = 1;
		index = dev->host_rrq_idx;
		if (dev->host_rrq[index] == 0) {
			u32 old_index = index;
			/* adjust index */
			do {
				index++;
				if (index == dev->scsi_host_ptr->can_queue +
							AAC_NUM_MGT_FIB)
					index = 0;
				if (dev->host_rrq[index] != 0)
					break;
			} while (index != old_index);
			dev->host_rrq_idx = index;
		}
		for (;;) {
			isFastResponse = 0;
			/* remove toggle bit (31) */
			handle = le32_to_cpu(dev->host_rrq[index]) & 0x7fffffff;
			/* check fast response bit (30) */
			if (handle & 0x40000000)
				isFastResponse = 1;
			handle &= 0x0000ffff;
			if (handle == 0)
				break;

			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);

			dev->host_rrq[index++] = 0;
			if (index == dev->scsi_host_ptr->can_queue +
						AAC_NUM_MGT_FIB)
				index = 0;
			dev->host_rrq_idx = index;
		}
	} else {
		bellbits_shifted = (bellbits >> SRC_ODR_SHIFT);
		if (bellbits_shifted & DoorBellAifPending) {
			our_interrupt = 1;
			/* handle AIF */
			aac_intr_normal(dev, 0, 2, 0, NULL);
		} else if (bellbits_shifted & OUTBOUNDDOORBELL_0) {
			unsigned long sflags;
			struct list_head *entry;
			int send_it = 0;

			if (dev->sync_fib) {
				our_interrupt = 1;
				if (dev->sync_fib->callback)
					dev->sync_fib->callback(dev->sync_fib->callback_data,
						dev->sync_fib);
				spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
				if (dev->sync_fib->flags & FIB_CONTEXT_FLAG_WAIT) {
					dev->management_fib_count--;
					up(&dev->sync_fib->event_wait);
				}
				spin_unlock_irqrestore(&dev->sync_fib->event_lock, sflags);
				spin_lock_irqsave(&dev->sync_lock, sflags);
				if (!list_empty(&dev->sync_fib_list)) {
					entry = dev->sync_fib_list.next;
					dev->sync_fib = list_entry(entry, struct fib, fiblink);
					list_del(entry);
					send_it = 1;
				} else {
					dev->sync_fib = NULL;
				}
				spin_unlock_irqrestore(&dev->sync_lock, sflags);
				if (send_it) {
					aac_adapter_sync_cmd(dev, SEND_SYNCHRONOUS_FIB,
						(u32)dev->sync_fib->hw_fib_pa, 0, 0, 0, 0, 0,
						NULL, NULL, NULL, NULL, NULL);
				}
			}
		}
	}

	if (our_interrupt) {
		src_writel(dev, MUnit.ODR_C, bellbits);
		return IRQ_HANDLED;
	}
	return IRQ_NONE;
}

/**
 *	aac_src_disable_interrupt	-	Disable interrupts
 *	@dev: Adapter
 */

static void aac_src_disable_interrupt(struct aac_dev *dev)
{
	src_writel(dev, MUnit.OIMR, dev->OIMR = 0xffffffff);
}

/**
 *	aac_src_enable_interrupt_message	-	Enable interrupts
 *	@dev: Adapter
 */

static void aac_src_enable_interrupt_message(struct aac_dev *dev)
{
	src_writel(dev, MUnit.OIMR, dev->OIMR = 0xfffffff8);
}

/**
 *	src_sync_cmd	-	send a command and wait
 *	@dev: Adapter
 *	@command: Command to execute
 *	@p1: first parameter
 *	@ret: adapter status
 *
 *	This routine will send a synchronous command to the adapter and wait
 *	for its	completion.
 */

static int src_sync_cmd(struct aac_dev *dev, u32 command,
	u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6,
	u32 *status, u32 * r1, u32 * r2, u32 * r3, u32 * r4)
{
	unsigned long start;
	int ok;

	/*
	 *	Write the command into Mailbox 0
	 */
	writel(command, &dev->IndexRegs->Mailbox[0]);
	/*
	 *	Write the parameters into Mailboxes 1 - 6
	 */
	writel(p1, &dev->IndexRegs->Mailbox[1]);
	writel(p2, &dev->IndexRegs->Mailbox[2]);
	writel(p3, &dev->IndexRegs->Mailbox[3]);
	writel(p4, &dev->IndexRegs->Mailbox[4]);

	/*
	 *	Clear the synch command doorbell to start on a clean slate.
	 */
	src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);

	/*
	 *	Disable doorbell interrupts
	 */
	src_writel(dev, MUnit.OIMR, dev->OIMR = 0xffffffff);

	/*
	 *	Force the completion of the mask register write before issuing
	 *	the interrupt.
	 */
	src_readl(dev, MUnit.OIMR);

	/*
	 *	Signal that there is a new synch command
	 */
	src_writel(dev, MUnit.IDR, INBOUNDDOORBELL_0 << SRC_IDR_SHIFT);

	if (!dev->sync_mode || command != SEND_SYNCHRONOUS_FIB) {
		ok = 0;
		start = jiffies;

		/*
		 *	Wait up to 5 minutes
		 */
		while (time_before(jiffies, start+300*HZ)) {
			udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
			/*
			 *	Mon960 will set doorbell0 bit when it has completed the command.
			 */
			if ((src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT) & OUTBOUNDDOORBELL_0) {
				/*
				 *	Clear the doorbell.
				 */
				src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
				ok = 1;
				break;
			}
			/*
			 *	Yield the processor in case we are slow
			 */
			msleep(1);
		}
		if (unlikely(ok != 1)) {
			/*
			 *	Restore interrupt mask even though we timed out
			 */
			aac_adapter_enable_int(dev);
			return -ETIMEDOUT;
		}
		/*
		 *	Pull the synch status from Mailbox 0.
		 */
		if (status)
			*status = readl(&dev->IndexRegs->Mailbox[0]);
		if (r1)
			*r1 = readl(&dev->IndexRegs->Mailbox[1]);
		if (r2)
			*r2 = readl(&dev->IndexRegs->Mailbox[2]);
		if (r3)
			*r3 = readl(&dev->IndexRegs->Mailbox[3]);
		if (r4)
			*r4 = readl(&dev->IndexRegs->Mailbox[4]);

		/*
		 *	Clear the synch command doorbell.
		 */
		src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
	}

	/*
	 *	Restore interrupt mask
	 */
	aac_adapter_enable_int(dev);
	return 0;
}

/**
 *	aac_src_interrupt_adapter	-	interrupt adapter
 *	@dev: Adapter
 *
 *	Send an interrupt to the i960 and breakpoint it.
 */

static void aac_src_interrupt_adapter(struct aac_dev *dev)
{
	src_sync_cmd(dev, BREAKPOINT_REQUEST,
		0, 0, 0, 0, 0, 0,
		NULL, NULL, NULL, NULL, NULL);
}

/**
 *	aac_src_notify_adapter		-	send an event to the adapter
 *	@dev: Adapter
 *	@event: Event to send
 *
 *	Notify the i960 that something it probably cares about has
 *	happened.
 */

static void aac_src_notify_adapter(struct aac_dev *dev, u32 event)
{
	switch (event) {

	case AdapNormCmdQue:
		src_writel(dev, MUnit.ODR_C,
			INBOUNDDOORBELL_1 << SRC_ODR_SHIFT);
		break;
	case HostNormRespNotFull:
		src_writel(dev, MUnit.ODR_C,
			INBOUNDDOORBELL_4 << SRC_ODR_SHIFT);
		break;
	case AdapNormRespQue:
		src_writel(dev, MUnit.ODR_C,
			INBOUNDDOORBELL_2 << SRC_ODR_SHIFT);
		break;
	case HostNormCmdNotFull:
		src_writel(dev, MUnit.ODR_C,
			INBOUNDDOORBELL_3 << SRC_ODR_SHIFT);
		break;
	case FastIo:
		src_writel(dev, MUnit.ODR_C,
			INBOUNDDOORBELL_6 << SRC_ODR_SHIFT);
		break;
	case AdapPrintfDone:
		src_writel(dev, MUnit.ODR_C,
			INBOUNDDOORBELL_5 << SRC_ODR_SHIFT);
		break;
	default:
		BUG();
		break;
	}
}

/**
 *	aac_src_start_adapter		-	activate adapter
 *	@dev:	Adapter
 *
 *	Start up processing on an i960 based AAC adapter
 */

static void aac_src_start_adapter(struct aac_dev *dev)
{
	struct aac_init *init;

	init = dev->init;
	init->HostElapsedSeconds = cpu_to_le32(get_seconds());

	/* We can only use a 32 bit address here */
	src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
}

/**
 *	aac_src_check_health
 *	@dev: device to check if healthy
 *
 *	Will attempt to determine if the specified adapter is alive and
 *	capable of handling requests, returning 0 if alive.
 */
static int aac_src_check_health(struct aac_dev *dev)
{
	u32 status = src_readl(dev, MUnit.OMR);

	/*
	 *	Check to see if the board failed any self tests.
	 */
	if (unlikely(status & SELF_TEST_FAILED))
		return -1;

	/*
	 *	Check to see if the board panic'd.
	 */
	if (unlikely(status & KERNEL_PANIC))
		return (status >> 16) & 0xFF;
	/*
	 *	Wait for the adapter to be up and running.
	 */
	if (unlikely(!(status & KERNEL_UP_AND_RUNNING)))
		return -3;
	/*
	 *	Everything is OK
	 */
	return 0;
}

/**
 *	aac_src_deliver_message
 *	@fib: fib to issue
 *
 *	Will send a fib, returning 0 if successful.
 */
static int aac_src_deliver_message(struct fib *fib)
{
	struct aac_dev *dev = fib->dev;
	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
	unsigned long qflags;
	u32 fibsize;
	dma_addr_t address;
	struct aac_fib_xporthdr *pFibX;
	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);

	spin_lock_irqsave(q->lock, qflags);
	q->numpending++;
	spin_unlock_irqrestore(q->lock, qflags);

	/* Calculate the amount to the fibsize bits */
	fibsize = (sizeof(struct aac_fib_xporthdr) + hdr_size + 127) / 128 - 1;
	if (fibsize > (ALIGN32 - 1))
		return -EMSGSIZE;

	/* Fill XPORT header */
	pFibX = (void *)fib->hw_fib_va - sizeof(struct aac_fib_xporthdr);
	/*
	 * This was stored by aac_fib_send() and it is the index into
	 * dev->fibs. Not sure why we add 1 to it, but I suspect that it's
	 * because it can't be zero when we pass it to the hardware. Note that
	 * it was stored in native endian, hence the lack of swapping. -- BenC
	 */
	pFibX->Handle = cpu_to_le32(fib->hw_fib_va->header.SenderData + 1);
	pFibX->HostAddress = cpu_to_le64(fib->hw_fib_pa);
	pFibX->Size = cpu_to_le32(hdr_size);

	/*
	 * The xport header has been 32-byte aligned for us so that fibsize
	 * can be masked out of this address by hardware. -- BenC
	 */
	address = fib->hw_fib_pa - sizeof(struct aac_fib_xporthdr);
	if (address & (ALIGN32 - 1))
		return -EINVAL;
	address |= fibsize;
	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);

	return 0;
}

/**
 *	aac_src_ioremap
 *	@size: mapping resize request
 *
 */
static int aac_src_ioremap(struct aac_dev *dev, u32 size)
{
	if (!size) {
		iounmap(dev->regs.src.bar1);
		dev->regs.src.bar1 = NULL;
		iounmap(dev->regs.src.bar0);
		dev->base = dev->regs.src.bar0 = NULL;
		return 0;
	}
	dev->regs.src.bar1 = ioremap(pci_resource_start(dev->pdev, 2),
		AAC_MIN_SRC_BAR1_SIZE);
	dev->base = NULL;
	if (dev->regs.src.bar1 == NULL)
		return -1;
	dev->base = dev->regs.src.bar0 = ioremap(dev->base_start, size);
	if (dev->base == NULL) {
		iounmap(dev->regs.src.bar1);
		dev->regs.src.bar1 = NULL;
		return -1;
	}
	dev->IndexRegs = &((struct src_registers __iomem *)
		dev->base)->u.tupelo.IndexRegs;
	return 0;
}

/**
 *  aac_srcv_ioremap
 *	@size: mapping resize request
 *
 */
static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
{
	if (!size) {
		iounmap(dev->regs.src.bar0);
		dev->base = dev->regs.src.bar0 = NULL;
		return 0;
	}
	dev->base = dev->regs.src.bar0 = ioremap(dev->base_start, size);
	if (dev->base == NULL)
		return -1;
	dev->IndexRegs = &((struct src_registers __iomem *)
		dev->base)->u.denali.IndexRegs;
	return 0;
}

static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
{
	u32 var, reset_mask;

	if (bled >= 0) {
		if (bled)
			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
				dev->name, dev->id, bled);
		bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
			if (bled || (var != 0x00000001))
				return -EINVAL;
		if (dev->supplement_adapter_info.SupportedOptions2 &
			AAC_OPTION_DOORBELL_RESET) {
			src_writel(dev, MUnit.IDR, reset_mask);
			msleep(5000); /* Delay 5 seconds */
		}
	}

	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
		return -ENODEV;

	if (startup_timeout < 300)
		startup_timeout = 300;

	return 0;
}

/**
 *	aac_src_select_comm	-	Select communications method
 *	@dev: Adapter
 *	@comm: communications method
 */
int aac_src_select_comm(struct aac_dev *dev, int comm)
{
	switch (comm) {
	case AAC_COMM_MESSAGE:
		dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
		dev->a_ops.adapter_intr = aac_src_intr_message;
		dev->a_ops.adapter_deliver = aac_src_deliver_message;
		break;
	default:
		return 1;
	}
	return 0;
}

/**
 *  aac_src_init	-	initialize an Cardinal Frey Bar card
 *  @dev: device to configure
 *
 */

int aac_src_init(struct aac_dev *dev)
{
	unsigned long start;
	unsigned long status;
	int restart = 0;
	int instance = dev->id;
	const char *name = dev->name;

	dev->a_ops.adapter_ioremap = aac_src_ioremap;
	dev->a_ops.adapter_comm = aac_src_select_comm;

	dev->base_size = AAC_MIN_SRC_BAR0_SIZE;
	if (aac_adapter_ioremap(dev, dev->base_size)) {
		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
		goto error_iounmap;
	}

	/* Failure to reset here is an option ... */
	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
	if ((aac_reset_devices || reset_devices) &&
		!aac_src_restart_adapter(dev, 0))
		++restart;
	/*
	 *	Check to see if the board panic'd while booting.
	 */
	status = src_readl(dev, MUnit.OMR);
	if (status & KERNEL_PANIC) {
		if (aac_src_restart_adapter(dev, aac_src_check_health(dev)))
			goto error_iounmap;
		++restart;
	}
	/*
	 *	Check to see if the board failed any self tests.
	 */
	status = src_readl(dev, MUnit.OMR);
	if (status & SELF_TEST_FAILED) {
		printk(KERN_ERR "%s%d: adapter self-test failed.\n",
			dev->name, instance);
		goto error_iounmap;
	}
	/*
	 *	Check to see if the monitor panic'd while booting.
	 */
	if (status & MONITOR_PANIC) {
		printk(KERN_ERR "%s%d: adapter monitor panic.\n",
			dev->name, instance);
		goto error_iounmap;
	}
	start = jiffies;
	/*
	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
	 */
	while (!((status = src_readl(dev, MUnit.OMR)) &
		KERNEL_UP_AND_RUNNING)) {
		if ((restart &&
		  (status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC))) ||
		  time_after(jiffies, start+HZ*startup_timeout)) {
			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n",
					dev->name, instance, status);
			goto error_iounmap;
		}
		if (!restart &&
		  ((status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC)) ||
		  time_after(jiffies, start + HZ *
		  ((startup_timeout > 60)
		    ? (startup_timeout - 60)
		    : (startup_timeout / 2))))) {
			if (likely(!aac_src_restart_adapter(dev,
			    aac_src_check_health(dev))))
				start = jiffies;
			++restart;
		}
		msleep(1);
	}
	if (restart && aac_commit)
		aac_commit = 1;
	/*
	 *	Fill in the common function dispatch table.
	 */
	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
	dev->a_ops.adapter_notify = aac_src_notify_adapter;
	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
	dev->a_ops.adapter_check_health = aac_src_check_health;
	dev->a_ops.adapter_restart = aac_src_restart_adapter;

	/*
	 *	First clear out all interrupts.  Then enable the one's that we
	 *	can handle.
	 */
	aac_adapter_comm(dev, AAC_COMM_MESSAGE);
	aac_adapter_disable_int(dev);
	src_writel(dev, MUnit.ODR_C, 0xffffffff);
	aac_adapter_enable_int(dev);

	if (aac_init_adapter(dev) == NULL)
		goto error_iounmap;
	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
		goto error_iounmap;

	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);

	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {

		if (dev->msi)
			pci_disable_msi(dev->pdev);

		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
			name, instance);
		goto error_iounmap;
	}
	dev->dbg_base = pci_resource_start(dev->pdev, 2);
	dev->dbg_base_mapped = dev->regs.src.bar1;
	dev->dbg_size = AAC_MIN_SRC_BAR1_SIZE;

	aac_adapter_enable_int(dev);

	if (!dev->sync_mode) {
		/*
		 * Tell the adapter that all is configured, and it can
		 * start accepting requests
		 */
		aac_src_start_adapter(dev);
	}
	return 0;

error_iounmap:

	return -1;
}

/**
 *  aac_srcv_init	-	initialize an SRCv card
 *  @dev: device to configure
 *
 */

int aac_srcv_init(struct aac_dev *dev)
{
	unsigned long start;
	unsigned long status;
	int restart = 0;
	int instance = dev->id;
	const char *name = dev->name;

	dev->a_ops.adapter_ioremap = aac_srcv_ioremap;
	dev->a_ops.adapter_comm = aac_src_select_comm;

	dev->base_size = AAC_MIN_SRCV_BAR0_SIZE;
	if (aac_adapter_ioremap(dev, dev->base_size)) {
		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
		goto error_iounmap;
	}

	/* Failure to reset here is an option ... */
	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
	if ((aac_reset_devices || reset_devices) &&
		!aac_src_restart_adapter(dev, 0))
		++restart;
	/*
	 *	Check to see if the board panic'd while booting.
	 */
	status = src_readl(dev, MUnit.OMR);
	if (status & KERNEL_PANIC) {
		if (aac_src_restart_adapter(dev, aac_src_check_health(dev)))
			goto error_iounmap;
		++restart;
	}
	/*
	 *	Check to see if the board failed any self tests.
	 */
	status = src_readl(dev, MUnit.OMR);
	if (status & SELF_TEST_FAILED) {
		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
		goto error_iounmap;
	}
	/*
	 *	Check to see if the monitor panic'd while booting.
	 */
	if (status & MONITOR_PANIC) {
		printk(KERN_ERR "%s%d: adapter monitor panic.\n", dev->name, instance);
		goto error_iounmap;
	}
	start = jiffies;
	/*
	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
	 */
	while (!((status = src_readl(dev, MUnit.OMR)) & KERNEL_UP_AND_RUNNING)) {
		if ((restart &&
		  (status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC))) ||
		  time_after(jiffies, start+HZ*startup_timeout)) {
			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n",
					dev->name, instance, status);
			goto error_iounmap;
		}
		if (!restart &&
		  ((status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC)) ||
		  time_after(jiffies, start + HZ *
		  ((startup_timeout > 60)
		    ? (startup_timeout - 60)
		    : (startup_timeout / 2))))) {
			if (likely(!aac_src_restart_adapter(dev, aac_src_check_health(dev))))
				start = jiffies;
			++restart;
		}
		msleep(1);
	}
	if (restart && aac_commit)
		aac_commit = 1;
	/*
	 *	Fill in the common function dispatch table.
	 */
	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
	dev->a_ops.adapter_notify = aac_src_notify_adapter;
	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
	dev->a_ops.adapter_check_health = aac_src_check_health;
	dev->a_ops.adapter_restart = aac_src_restart_adapter;

	/*
	 *	First clear out all interrupts.  Then enable the one's that we
	 *	can handle.
	 */
	aac_adapter_comm(dev, AAC_COMM_MESSAGE);
	aac_adapter_disable_int(dev);
	src_writel(dev, MUnit.ODR_C, 0xffffffff);
	aac_adapter_enable_int(dev);

	if (aac_init_adapter(dev) == NULL)
		goto error_iounmap;
	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
		goto error_iounmap;
	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
		IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
		if (dev->msi)
			pci_disable_msi(dev->pdev);
		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
			name, instance);
		goto error_iounmap;
	}
	dev->dbg_base = dev->base_start;
	dev->dbg_base_mapped = dev->base;
	dev->dbg_size = dev->base_size;

	aac_adapter_enable_int(dev);

	if (!dev->sync_mode) {
		/*
		 * Tell the adapter that all is configured, and it can
		 * start accepting requests
		 */
		aac_src_start_adapter(dev);
	}
	return 0;

error_iounmap:

	return -1;
}


--+pHx0qQiF2pBVqBT--
