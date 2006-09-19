From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/5] aacraid:  merge rx and rkt code
Date: Tue, 19 Sep 2006 09:00:02 -0700
Message-ID: <1158681602.2837.22.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61090 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751675AbWISQAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 12:00:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn:

The only real difference between the rkt and rx platform modules is the
offset of the message registers. This patch recognizes this similarity
and simplifies the driver to reduce it's code footprint and to improve
maintainability by reducing the code duplication.

Visibly, the 'rkt.c' portion of this patch looks more complicated than
it really is. View it as retaining the rkt-only specifics of the
interface.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-09-12 09:49:31.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-09-12 09:49:42.000000000 -0700
@@ -494,6 +494,7 @@
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
 	int  (*adapter_send)(struct fib * fib);
+	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
 };
 
 /*
@@ -682,14 +683,6 @@
 	__le32	Mailbox[8];
 };
 
-#define	InboundMailbox0		IndexRegs.Mailbox[0]
-#define	InboundMailbox1		IndexRegs.Mailbox[1]
-#define	InboundMailbox2		IndexRegs.Mailbox[2]
-#define	InboundMailbox3		IndexRegs.Mailbox[3]
-#define	InboundMailbox4		IndexRegs.Mailbox[4]
-#define	InboundMailbox5		IndexRegs.Mailbox[5]
-#define	InboundMailbox6		IndexRegs.Mailbox[6]
-
 #define	INBOUNDDOORBELL_0	0x00000001
 #define INBOUNDDOORBELL_1	0x00000002
 #define INBOUNDDOORBELL_2	0x00000004
@@ -1010,6 +1003,8 @@
 		struct rx_registers __iomem *rx;
 		struct rkt_registers __iomem *rkt;
 	} regs;
+	volatile void __iomem *base;
+	volatile struct rx_inbound __iomem *IndexRegs;
 	u32			OIMR; /* Mask Register Cache */
 	/*
 	 *	AIF thread states
@@ -1050,6 +1045,9 @@
 #define aac_adapter_send(fib) \
 	((fib)->dev)->a_ops.adapter_send(fib)
 
+#define aac_adapter_ioremap(dev, size) \
+	(dev)->a_ops.adapter_ioremap(dev, size)
+
 #define FIB_CONTEXT_FLAG_TIMED_OUT		(0x00000001)
 
 /*
--- scsi-misc-aac.orig/drivers/scsi/aacraid/comminit.c	2006-09-12 09:48:50.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/comminit.c	2006-09-12 09:49:42.000000000 -0700
@@ -307,17 +307,12 @@
 		if (status[1] & AAC_OPT_NEW_COMM)
 			dev->new_comm_interface = dev->a_ops.adapter_send != 0;
 		if (dev->new_comm_interface && (status[2] > dev->base_size)) {
-			iounmap(dev->regs.sa);
+			aac_adapter_ioremap(dev, 0);
 			dev->base_size = status[2];
-			dprintk((KERN_DEBUG "ioremap(%lx,%d)\n",
-			  host->base, status[2]));
-			dev->regs.sa = ioremap(host->base, status[2]);
-			if (dev->regs.sa == NULL) {
+			if (aac_adapter_ioremap(dev, status[2])) {
 				/* remap failed, go back ... */
 				dev->new_comm_interface = 0;
-				dev->regs.sa = ioremap(host->base, 
-						AAC_MIN_FOOTPRINT_SIZE);
-				if (dev->regs.sa == NULL) {	
+				if (aac_adapter_ioremap(dev, AAC_MIN_FOOTPRINT_SIZE)) {
 					printk(KERN_WARNING
 					  "aacraid: unable to map adapter.\n");
 					return NULL;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-09-12 09:49:40.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-09-12 09:49:42.000000000 -0700
@@ -867,13 +867,6 @@
 	 *	Map in the registers from the adapter.
 	 */
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
-	if ((aac->regs.sa = ioremap(
-	  (unsigned long)aac->scsi_host_ptr->base, AAC_MIN_FOOTPRINT_SIZE))
-	  == NULL) {	
-		printk(KERN_WARNING "%s: unable to map adapter.\n",
-		  AAC_DRIVERNAME);
-		goto out_free_fibs;
-	}
 	if ((*aac_drivers[index].init)(aac))
 		goto out_unmap;
 
@@ -972,8 +965,7 @@
 	aac_fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
-	iounmap(aac->regs.sa);
- out_free_fibs:
+	aac_adapter_ioremap(aac, 0);
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
  out_free_host:
@@ -1008,7 +1000,7 @@
 	kfree(aac->queues);
 
 	free_irq(pdev->irq, aac);
-	iounmap(aac->regs.sa);
+	aac_adapter_ioremap(aac, 0);
 	
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rkt.c	2006-09-12 09:48:50.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rkt.c	2006-09-12 09:49:42.000000000 -0700
@@ -28,389 +28,27 @@
  *
  */
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/pci.h>
-#include <linux/spinlock.h>
-#include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/completion.h>
-#include <linux/time.h>
-#include <linux/interrupt.h>
-#include <asm/semaphore.h>
 
 #include <scsi/scsi_host.h>
 
 #include "aacraid.h"
 
-static irqreturn_t aac_rkt_intr(int irq, void *dev_id, struct pt_regs *regs)
-{
-	struct aac_dev *dev = dev_id;
-
-	if (dev->new_comm_interface) {
-		u32 Index = rkt_readl(dev, MUnit.OutboundQueue);
-		if (Index == 0xFFFFFFFFL)
-			Index = rkt_readl(dev, MUnit.OutboundQueue);
-		if (Index != 0xFFFFFFFFL) {
-			do {
-				if (aac_intr_normal(dev, Index)) {
-					rkt_writel(dev, MUnit.OutboundQueue, Index);
-					rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespReady);
-				}
-				Index = rkt_readl(dev, MUnit.OutboundQueue);
-			} while (Index != 0xFFFFFFFFL);
-			return IRQ_HANDLED;
-		}
-	} else {
-		unsigned long bellbits;
-		u8 intstat;
-		intstat = rkt_readb(dev, MUnit.OISR);
-		/*
-		 *	Read mask and invert because drawbridge is reversed.
-		 *	This allows us to only service interrupts that have 
-		 *	been enabled.
-		 *	Check to see if this is our interrupt.  If it isn't just return
-		 */
-		if (intstat & ~(dev->OIMR))
-		{
-			bellbits = rkt_readl(dev, OutboundDoorbellReg);
-			if (bellbits & DoorBellPrintfReady) {
-				aac_printf(dev, rkt_readl (dev, IndexRegs.Mailbox[5]));
-				rkt_writel(dev, MUnit.ODR,DoorBellPrintfReady);
-				rkt_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
-			}
-			else if (bellbits & DoorBellAdapterNormCmdReady) {
-				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
-				aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
-//				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
-			}
-			else if (bellbits & DoorBellAdapterNormRespReady) {
-				rkt_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
-				aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
-			}
-			else if (bellbits & DoorBellAdapterNormCmdNotFull) {
-				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
-			}
-			else if (bellbits & DoorBellAdapterNormRespNotFull) {
-				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
-				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
-			}
-			return IRQ_HANDLED;
-		}
-	}
-	return IRQ_NONE;
-}
-
-/**
- *	aac_rkt_disable_interrupt	-	Disable interrupts
- *	@dev: Adapter
- */
-
-static void aac_rkt_disable_interrupt(struct aac_dev *dev)
-{
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
-}
-
-/**
- *	rkt_sync_cmd	-	send a command and wait
- *	@dev: Adapter
- *	@command: Command to execute
- *	@p1: first parameter
- *	@ret: adapter status
- *
- *	This routine will send a synchronous command to the adapter and wait 
- *	for its	completion.
- */
-
-static int rkt_sync_cmd(struct aac_dev *dev, u32 command,
-	u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6,
-	u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4)
-{
-	unsigned long start;
-	int ok;
-	/*
-	 *	Write the command into Mailbox 0
-	 */
-	rkt_writel(dev, InboundMailbox0, command);
-	/*
-	 *	Write the parameters into Mailboxes 1 - 6
-	 */
-	rkt_writel(dev, InboundMailbox1, p1);
-	rkt_writel(dev, InboundMailbox2, p2);
-	rkt_writel(dev, InboundMailbox3, p3);
-	rkt_writel(dev, InboundMailbox4, p4);
-	/*
-	 *	Clear the synch command doorbell to start on a clean slate.
-	 */
-	rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
-	/*
-	 *	Disable doorbell interrupts
-	 */
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
-	/*
-	 *	Force the completion of the mask register write before issuing
-	 *	the interrupt.
-	 */
-	rkt_readb (dev, MUnit.OIMR);
-	/*
-	 *	Signal that there is a new synch command
-	 */
-	rkt_writel(dev, InboundDoorbellReg, INBOUNDDOORBELL_0);
-
-	ok = 0;
-	start = jiffies;
-
-	/*
-	 *	Wait up to 30 seconds
-	 */
-	while (time_before(jiffies, start+30*HZ)) 
-	{
-		udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
-		/*
-		 *	Mon960 will set doorbell0 bit when it has completed the command.
-		 */
-		if (rkt_readl(dev, OutboundDoorbellReg) & OUTBOUNDDOORBELL_0) {
-			/*
-			 *	Clear the doorbell.
-			 */
-			rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
-			ok = 1;
-			break;
-		}
-		/*
-		 *	Yield the processor in case we are slow 
-		 */
-		msleep(1);
-	}
-	if (ok != 1) {
-		/*
-		 *	Restore interrupt mask even though we timed out
-		 */
-		if (dev->new_comm_interface)
-			rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
-		else
-			rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
-		return -ETIMEDOUT;
-	}
-	/*
-	 *	Pull the synch status from Mailbox 0.
-	 */
-	if (status)
-		*status = rkt_readl(dev, IndexRegs.Mailbox[0]);
-	if (r1)
-		*r1 = rkt_readl(dev, IndexRegs.Mailbox[1]);
-	if (r2)
-		*r2 = rkt_readl(dev, IndexRegs.Mailbox[2]);
-	if (r3)
-		*r3 = rkt_readl(dev, IndexRegs.Mailbox[3]);
-	if (r4)
-		*r4 = rkt_readl(dev, IndexRegs.Mailbox[4]);
-	/*
-	 *	Clear the synch command doorbell.
-	 */
-	rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
-	/*
-	 *	Restore interrupt mask
-	 */
-	if (dev->new_comm_interface)
-		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
-	else
-		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
-	return 0;
-
-}
-
-/**
- *	aac_rkt_interrupt_adapter	-	interrupt adapter
- *	@dev: Adapter
- *
- *	Send an interrupt to the i960 and breakpoint it.
- */
-
-static void aac_rkt_interrupt_adapter(struct aac_dev *dev)
-{
-	rkt_sync_cmd(dev, BREAKPOINT_REQUEST, 0, 0, 0, 0, 0, 0,
-	  NULL, NULL, NULL, NULL, NULL);
-}
-
 /**
- *	aac_rkt_notify_adapter		-	send an event to the adapter
- *	@dev: Adapter
- *	@event: Event to send
+ *	aac_rkt_ioremap
+ *	@size: mapping resize request
  *
- *	Notify the i960 that something it probably cares about has
- *	happened.
  */
-
-static void aac_rkt_notify_adapter(struct aac_dev *dev, u32 event)
+static int aac_rkt_ioremap(struct aac_dev * dev, u32 size)
 {
-	switch (event) {
-
-	case AdapNormCmdQue:
-		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_1);
-		break;
-	case HostNormRespNotFull:
-		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_4);
-		break;
-	case AdapNormRespQue:
-		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_2);
-		break;
-	case HostNormCmdNotFull:
-		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_3);
-		break;
-	case HostShutdown:
-//		rkt_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, 0, 0,
-//		  NULL, NULL, NULL, NULL, NULL);
-		break;
-	case FastIo:
-		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_6);
-		break;
-	case AdapPrintfDone:
-		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_5);
-		break;
-	default:
-		BUG();
-		break;
+	if (!size) {
+		iounmap(dev->regs.rkt);
+		return 0;
 	}
-}
-
-/**
- *	aac_rkt_start_adapter		-	activate adapter
- *	@dev:	Adapter
- *
- *	Start up processing on an i960 based AAC adapter
- */
-
-static void aac_rkt_start_adapter(struct aac_dev *dev)
-{
-	struct aac_init *init;
-
-	init = dev->init;
-	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
-	// We can only use a 32 bit address here
-	rkt_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
-	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
-}
-
-/**
- *	aac_rkt_check_health
- *	@dev: device to check if healthy
- *
- *	Will attempt to determine if the specified adapter is alive and
- *	capable of handling requests, returning 0 if alive.
- */
-static int aac_rkt_check_health(struct aac_dev *dev)
-{
-	u32 status = rkt_readl(dev, MUnit.OMRx[0]);
-
-	/*
-	 *	Check to see if the board failed any self tests.
-	 */
-	if (status & SELF_TEST_FAILED)
+	dev->base = dev->regs.rkt = ioremap(dev->scsi_host_ptr->base, size);
+	if (dev->base == NULL)
 		return -1;
-	/*
-	 *	Check to see if the board panic'd.
-	 */
-	if (status & KERNEL_PANIC) {
-		char * buffer;
-		struct POSTSTATUS {
-			__le32 Post_Command;
-			__le32 Post_Address;
-		} * post;
-		dma_addr_t paddr, baddr;
-		int ret;
-
-		if ((status & 0xFF000000L) == 0xBC000000L)
-			return (status >> 16) & 0xFF;
-		buffer = pci_alloc_consistent(dev->pdev, 512, &baddr);
-		ret = -2;
-		if (buffer == NULL)
-			return ret;
-		post = pci_alloc_consistent(dev->pdev,
-		  sizeof(struct POSTSTATUS), &paddr);
-		if (post == NULL) {
-			pci_free_consistent(dev->pdev, 512, buffer, baddr);
-			return ret;
-		}
-                memset(buffer, 0, 512);
-		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
-                post->Post_Address = cpu_to_le32(baddr);
-                rkt_writel(dev, MUnit.IMRx[0], paddr);
-                rkt_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, 0, 0, 0, 0, 0,
-		  NULL, NULL, NULL, NULL, NULL);
-		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
-		  post, paddr);
-                if ((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X'))) {
-                        ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
-                        ret <<= 4;
-                        ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
-                }
-		pci_free_consistent(dev->pdev, 512, buffer, baddr);
-                return ret;
-        }
-	/*
-	 *	Wait for the adapter to be up and running.
-	 */
-	if (!(status & KERNEL_UP_AND_RUNNING))
-		return -3;
-	/*
-	 *	Everything is OK
-	 */
-	return 0;
-}
-
-/**
- *	aac_rkt_send
- *	@fib: fib to issue
- *
- *	Will send a fib, returning 0 if successful.
- */
-static int aac_rkt_send(struct fib * fib)
-{
-	u64 addr = fib->hw_fib_pa;
-	struct aac_dev *dev = fib->dev;
-	volatile void __iomem *device = dev->regs.rkt;
-	u32 Index;
-
-	dprintk((KERN_DEBUG "%p->aac_rkt_send(%p->%llx)\n", dev, fib, addr));
-	Index = rkt_readl(dev, MUnit.InboundQueue);
-	if (Index == 0xFFFFFFFFL)
-		Index = rkt_readl(dev, MUnit.InboundQueue);
-	dprintk((KERN_DEBUG "Index = 0x%x\n", Index));
-	if (Index == 0xFFFFFFFFL)
-		return Index;
-	device += Index;
-	dprintk((KERN_DEBUG "entry = %x %x %u\n", (u32)(addr & 0xffffffff),
-	  (u32)(addr >> 32), (u32)le16_to_cpu(fib->hw_fib->header.Size)));
-	writel((u32)(addr & 0xffffffff), device);
-	device += sizeof(u32);
-	writel((u32)(addr >> 32), device);
-	device += sizeof(u32);
-	writel(le16_to_cpu(fib->hw_fib->header.Size), device);
-	rkt_writel(dev, MUnit.InboundQueue, Index);
-	dprintk((KERN_DEBUG "aac_rkt_send - return 0\n"));
-	return 0;
-}
-
-static int aac_rkt_restart_adapter(struct aac_dev *dev)
-{
-	u32 var;
-
-	printk(KERN_ERR "%s%d: adapter kernel panic'd.\n",
-			dev->name, dev->id);
-
-	if (aac_rkt_check_health(dev) <= 0)
-		return 1;
-	if (rkt_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
-			&var, NULL, NULL, NULL, NULL))
-		return 1;
-	if (var != 0x00000001)
-		 return 1;
-	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
-		return 1;
+	dev->IndexRegs = &dev->regs.rkt->IndexRegs;
 	return 0;
 }
 
@@ -425,74 +63,18 @@
 
 int aac_rkt_init(struct aac_dev *dev)
 {
-	unsigned long start;
-	unsigned long status;
-	int instance;
-	const char * name;
-
-	instance = dev->id;
-	name     = dev->name;
+	int retval;
+	extern int _aac_rx_init(struct aac_dev *dev);
+	extern void aac_rx_start_adapter(struct aac_dev *dev);
 
 	/*
-	 *	Check to see if the board panic'd while booting.
-	 */
-	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
-		if (aac_rkt_restart_adapter(dev))
-			goto error_iounmap;
-	/*
-	 *	Check to see if the board failed any self tests.
-	 */
-	if (rkt_readl(dev, MUnit.OMRx[0]) & SELF_TEST_FAILED) {
-		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
-		goto error_iounmap;
-	}
-	/*
-	 *	Check to see if the monitor panic'd while booting.
-	 */
-	if (rkt_readl(dev, MUnit.OMRx[0]) & MONITOR_PANIC) {
-		printk(KERN_ERR "%s%d: adapter monitor panic.\n", dev->name, instance);
-		goto error_iounmap;
-	}
-	start = jiffies;
-	/*
-	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
-	 */
-	while (!(rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_UP_AND_RUNNING))
-	{
-		if(time_after(jiffies, start+startup_timeout*HZ))
-		{
-			status = rkt_readl(dev, MUnit.OMRx[0]);
-			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n", 
-					dev->name, instance, status);
-			goto error_iounmap;
-		}
-		msleep(1);
-	}
-	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr, IRQF_SHARED|IRQF_DISABLED, "aacraid", (void *)dev)<0)
-	{
-		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name, instance);
-		goto error_iounmap;
-	}
-	/*
 	 *	Fill in the function dispatch table.
 	 */
-	dev->a_ops.adapter_interrupt = aac_rkt_interrupt_adapter;
-	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
-	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
-	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
-	dev->a_ops.adapter_check_health = aac_rkt_check_health;
-	dev->a_ops.adapter_send = aac_rkt_send;
-
-	/*
-	 *	First clear out all interrupts.  Then enable the one's that we
-	 *	can handle.
-	 */
-	rkt_writeb(dev, MUnit.OIMR, 0xff);
-	rkt_writel(dev, MUnit.ODR, 0xffffffff);
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+	dev->a_ops.adapter_ioremap = aac_rkt_ioremap;
 
-	if (aac_init_adapter(dev) == NULL)
-		goto error_irq;
+	retval = _aac_rx_init(dev);
+	if (retval)
+		return retval;
 	if (dev->new_comm_interface) {
 		/*
 		 * FIB Setup has already been done, but we can minimize the
@@ -509,20 +91,11 @@
 			dev->init->MaxIoCommands = cpu_to_le32(246);
 			dev->scsi_host_ptr->can_queue = 246 - AAC_NUM_MGT_FIB;
 		}
-		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
 	}
 	/*
 	 *	Tell the adapter that all is configured, and it can start
 	 *	accepting requests
 	 */
-	aac_rkt_start_adapter(dev);
+	aac_rx_start_adapter(dev);
 	return 0;
-
-error_irq:
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
-	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
-
-error_iounmap:
-
-	return -1;
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2006-09-12 09:48:50.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2006-09-12 09:49:42.000000000 -0700
@@ -79,7 +79,7 @@
 		{
 			bellbits = rx_readl(dev, OutboundDoorbellReg);
 			if (bellbits & DoorBellPrintfReady) {
-				aac_printf(dev, rx_readl (dev, IndexRegs.Mailbox[5]));
+				aac_printf(dev, readl (&dev->IndexRegs->Mailbox[5]));
 				rx_writel(dev, MUnit.ODR,DoorBellPrintfReady);
 				rx_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
 			}
@@ -134,14 +134,14 @@
 	/*
 	 *	Write the command into Mailbox 0
 	 */
-	rx_writel(dev, InboundMailbox0, command);
+	writel(command, &dev->IndexRegs->Mailbox[0]);
 	/*
 	 *	Write the parameters into Mailboxes 1 - 6
 	 */
-	rx_writel(dev, InboundMailbox1, p1);
-	rx_writel(dev, InboundMailbox2, p2);
-	rx_writel(dev, InboundMailbox3, p3);
-	rx_writel(dev, InboundMailbox4, p4);
+	writel(p1, &dev->IndexRegs->Mailbox[1]);
+	writel(p2, &dev->IndexRegs->Mailbox[2]);
+	writel(p3, &dev->IndexRegs->Mailbox[3]);
+	writel(p4, &dev->IndexRegs->Mailbox[4]);
 	/*
 	 *	Clear the synch command doorbell to start on a clean slate.
 	 */
@@ -199,15 +199,15 @@
 	 *	Pull the synch status from Mailbox 0.
 	 */
 	if (status)
-		*status = rx_readl(dev, IndexRegs.Mailbox[0]);
+		*status = readl(&dev->IndexRegs->Mailbox[0]);
 	if (r1)
-		*r1 = rx_readl(dev, IndexRegs.Mailbox[1]);
+		*r1 = readl(&dev->IndexRegs->Mailbox[1]);
 	if (r2)
-		*r2 = rx_readl(dev, IndexRegs.Mailbox[2]);
+		*r2 = readl(&dev->IndexRegs->Mailbox[2]);
 	if (r3)
-		*r3 = rx_readl(dev, IndexRegs.Mailbox[3]);
+		*r3 = readl(&dev->IndexRegs->Mailbox[3]);
 	if (r4)
-		*r4 = rx_readl(dev, IndexRegs.Mailbox[4]);
+		*r4 = readl(&dev->IndexRegs->Mailbox[4]);
 	/*
 	 *	Clear the synch command doorbell.
 	 */
@@ -261,8 +261,6 @@
 		rx_writel(dev, MUnit.IDR,INBOUNDDOORBELL_3);
 		break;
 	case HostShutdown:
-//		rx_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, 0, 0,
-//		  NULL, NULL, NULL, NULL, NULL);
 		break;
 	case FastIo:
 		rx_writel(dev, MUnit.IDR,INBOUNDDOORBELL_6);
@@ -283,7 +281,7 @@
  *	Start up processing on an i960 based AAC adapter
  */
 
-static void aac_rx_start_adapter(struct aac_dev *dev)
+void aac_rx_start_adapter(struct aac_dev *dev)
 {
 	struct aac_init *init;
 
@@ -381,7 +379,7 @@
 	dprintk((KERN_DEBUG "Index = 0x%x\n", Index));
 	if (Index == 0xFFFFFFFFL)
 		return Index;
-	device += Index;
+	device = dev->base + Index;
 	dprintk((KERN_DEBUG "entry = %x %x %u\n", (u32)(addr & 0xffffffff),
 	  (u32)(addr >> 32), (u32)le16_to_cpu(fib->hw_fib->header.Size)));
 	writel((u32)(addr & 0xffffffff), device);
@@ -394,6 +392,24 @@
 	return 0;
 }
 
+/**
+ *	aac_rx_ioremap
+ *	@size: mapping resize request
+ *
+ */
+static int aac_rx_ioremap(struct aac_dev * dev, u32 size)
+{
+	if (!size) {
+		iounmap(dev->regs.rx);
+		return 0;
+	}
+	dev->base = dev->regs.rx = ioremap(dev->scsi_host_ptr->base, size);
+	if (dev->base == NULL)
+		return -1;
+	dev->IndexRegs = &dev->regs.rx->IndexRegs;
+	return 0;
+}
+
 static int aac_rx_restart_adapter(struct aac_dev *dev)
 {
 	u32 var;
@@ -422,7 +438,7 @@
  *	to the comm region.
  */
 
-int aac_rx_init(struct aac_dev *dev)
+int _aac_rx_init(struct aac_dev *dev)
 {
 	unsigned long start;
 	unsigned long status;
@@ -432,23 +448,30 @@
 	instance = dev->id;
 	name     = dev->name;
 
+	if (aac_adapter_ioremap(dev, dev->base_size)) {
+		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
+		goto error_iounmap;
+	}
+
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
-	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
+	status = rx_readl(dev, MUnit.OMRx[0]);
+	if (status & KERNEL_PANIC)
 		if (aac_rx_restart_adapter(dev))
 			goto error_iounmap;
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
-	if (rx_readl(dev, MUnit.OMRx[0]) & SELF_TEST_FAILED) {
+	status = rx_readl(dev, MUnit.OMRx[0]);
+	if (status & SELF_TEST_FAILED) {
 		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
 		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the monitor panic'd while booting.
 	 */
-	if (rx_readl(dev, MUnit.OMRx[0]) & MONITOR_PANIC) {
+	if (status & MONITOR_PANIC) {
 		printk(KERN_ERR "%s%d: adapter monitor panic.\n", dev->name, instance);
 		goto error_iounmap;
 	}
@@ -456,12 +479,10 @@
 	/*
 	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
 	 */
-	while ((!(rx_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_UP_AND_RUNNING))
-		|| (!(rx_readl(dev, MUnit.OMRx[0]) & KERNEL_UP_AND_RUNNING)))
+	while (!((status = rx_readl(dev, MUnit.OMRx[0])) & KERNEL_UP_AND_RUNNING))
 	{
 		if(time_after(jiffies, start+startup_timeout*HZ))
 		{
-			status = rx_readl(dev, IndexRegs.Mailbox[7]);
 			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n", 
 					dev->name, instance, status);
 			goto error_iounmap;
@@ -496,11 +517,6 @@
 	if (dev->new_comm_interface)
 		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
 
-	/*
-	 *	Tell the adapter that all is configured, and it can start
-	 *	accepting requests
-	 */
-	aac_rx_start_adapter(dev);
 	return 0;
 
 error_irq:
@@ -511,3 +527,23 @@
 
 	return -1;
 }
+
+int aac_rx_init(struct aac_dev *dev)
+{
+	int retval;
+
+	/*
+	 *	Fill in the function dispatch table.
+	 */
+	dev->a_ops.adapter_ioremap = aac_rx_ioremap;
+
+	retval = _aac_rx_init(dev);
+	if (!retval) {
+		/*
+		 *	Tell the adapter that all is configured, and it can
+		 * start accepting requests
+		 */
+		aac_rx_start_adapter(dev);
+	}
+	return retval;
+}
--- scsi-misc-aac.orig/drivers/scsi/aacraid/sa.c	2006-09-12 09:48:50.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/sa.c	2006-09-12 09:49:42.000000000 -0700
@@ -281,6 +281,21 @@
 }
 
 /**
+ *	aac_sa_ioremap
+ *	@size: mapping resize request
+ *
+ */
+static int aac_sa_ioremap(struct aac_dev * dev, u32 size)
+{
+	if (!size) {
+		iounmap(dev->regs.sa);
+		return 0;
+	}
+	dev->base = dev->regs.sa = ioremap(dev->scsi_host_ptr->base, size);
+	return (dev->base == NULL) ? -1 : 0;
+}
+
+/**
  *	aac_sa_init	-	initialize an ARM based AAC card
  *	@dev: device to configure
  *
@@ -299,6 +314,11 @@
 	instance = dev->id;
 	name     = dev->name;
 
+	if (aac_sa_ioremap(dev, dev->base_size)) {
+		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
+		goto error_iounmap;
+	}
+
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
@@ -341,6 +361,7 @@
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;
+	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
 
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that 

-- 
Mark Haverkamp <markh@osdl.org>

