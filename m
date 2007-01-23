From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 1/4] aacraid: rework communication support code
Date: Tue, 23 Jan 2007 14:59:20 -0800
Message-ID: <1169593160.10440.22.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965576AbXAWW7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 17:59:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

Replace all if/else communication transports with a platform function call.
This is in recognition of the need to migrate to up-and-coming transports.
Currently the Linux driver does not support two available communication
transports provided by our products, these will be added in future patches, and
will expand the platform function set.

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>
---


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2007-01-15 10:20:19.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2007-01-18 10:06:54.000000000 -0800
@@ -5,6 +5,7 @@
 #define _nblank(x) #x
 #define nblank(x) _nblank(x)[0]
 
+#include <linux/interrupt.h>
 
 /*------------------------------------------------------------------------------
  *              D E F I N E S
@@ -488,13 +489,20 @@
 
 struct adapter_ops
 {
+	/* Low level operations */
 	void (*adapter_interrupt)(struct aac_dev *dev);
 	void (*adapter_notify)(struct aac_dev *dev, u32 event);
 	void (*adapter_disable_int)(struct aac_dev *dev);
+	void (*adapter_enable_int)(struct aac_dev *dev);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
-	int  (*adapter_send)(struct fib * fib);
+	/* Transport operations */
 	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
+	irqreturn_t (*adapter_intr)(int irq, void *dev_id);
+	/* Packet operations */
+	int  (*adapter_deliver)(struct fib * fib);
+	/* Administrative operations */
+	int  (*adapter_comm)(struct aac_dev * dev, int comm);
 };
 
 /*
@@ -1018,7 +1026,9 @@
 	u8			nondasd_support; 
 	u8			dac_support;
 	u8			raid_scsi_mode;
-	u8			new_comm_interface;
+	u8			comm_interface;
+#	define AAC_COMM_PRODUCER 0
+#	define AAC_COMM_MESSAGE  1
 	/* macro side-effects BEWARE */
 #	define			raw_io_interface \
 	  init->InitStructRevision==cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4)
@@ -1036,18 +1046,24 @@
 #define aac_adapter_disable_int(dev) \
 	(dev)->a_ops.adapter_disable_int(dev)
 
+#define aac_adapter_enable_int(dev) \
+	(dev)->a_ops.adapter_enable_int(dev)
+
 #define aac_adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4) \
 	(dev)->a_ops.adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4)
 
 #define aac_adapter_check_health(dev) \
 	(dev)->a_ops.adapter_check_health(dev)
 
-#define aac_adapter_send(fib) \
-	((fib)->dev)->a_ops.adapter_send(fib)
-
 #define aac_adapter_ioremap(dev, size) \
 	(dev)->a_ops.adapter_ioremap(dev, size)
 
+#define aac_adapter_deliver(fib) \
+	((fib)->dev)->a_ops.adapter_deliver(fib)
+
+#define aac_adapter_comm(dev,comm) \
+	(dev)->a_ops.adapter_comm(dev, comm)
+
 #define FIB_CONTEXT_FLAG_TIMED_OUT		(0x00000001)
 
 /*
@@ -1795,6 +1811,7 @@
 int aac_rx_init(struct aac_dev *dev);
 int aac_rkt_init(struct aac_dev *dev);
 int aac_sa_init(struct aac_dev *dev);
+int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long *nonotify);
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/comminit.c	2007-01-15 10:24:10.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/comminit.c	2007-01-15 10:24:43.000000000 -0800
@@ -95,7 +95,7 @@
 	init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
 
 	init->InitFlags = 0;
-	if (dev->new_comm_interface) {
+	if (dev->comm_interface == AAC_COMM_MESSAGE) {
 		init->InitFlags = cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
 		dprintk((KERN_WARNING"aacraid: New Comm Interface enabled\n"));
 	}
@@ -297,21 +297,23 @@
 		- sizeof(struct aac_fibhdr)
 		- sizeof(struct aac_write) + sizeof(struct sgentry))
 			/ sizeof(struct sgentry);
-	dev->new_comm_interface = 0;
+	dev->comm_interface = AAC_COMM_PRODUCER;
 	dev->raw_io_64 = 0;
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
 	 		(status[0] == 0x00000001)) {
 		if (status[1] & AAC_OPT_NEW_COMM_64)
 			dev->raw_io_64 = 1;
-		if (status[1] & AAC_OPT_NEW_COMM)
-			dev->new_comm_interface = dev->a_ops.adapter_send != 0;
-		if (dev->new_comm_interface && (status[2] > dev->base_size)) {
+		if (dev->a_ops.adapter_comm &&
+		    (status[1] & AAC_OPT_NEW_COMM))
+			dev->comm_interface = AAC_COMM_MESSAGE;
+		if ((dev->comm_interface == AAC_COMM_MESSAGE) &&
+		    (status[2] > dev->base_size)) {
 			aac_adapter_ioremap(dev, 0);
 			dev->base_size = status[2];
 			if (aac_adapter_ioremap(dev, status[2])) {
 				/* remap failed, go back ... */
-				dev->new_comm_interface = 0;
+				dev->comm_interface = AAC_COMM_PRODUCER;
 				if (aac_adapter_ioremap(dev, AAC_MIN_FOOTPRINT_SIZE)) {
 					printk(KERN_WARNING
 					  "aacraid: unable to map adapter.\n");
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2007-01-15 10:20:19.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2007-01-15 10:24:43.000000000 -0800
@@ -317,7 +317,7 @@
  *	success.
  */
 
-static int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long *nonotify)
+int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long *nonotify)
 {
 	struct aac_entry * entry = NULL;
 	int map = 0;
@@ -387,7 +387,6 @@
 {
 	struct aac_dev * dev = fibptr->dev;
 	struct hw_fib * hw_fib = fibptr->hw_fib;
-	struct aac_queue * q;
 	unsigned long flags = 0;
 	unsigned long qflags;
 
@@ -469,38 +468,10 @@
 
 	if (!dev->queues)
 		return -EBUSY;
-	q = &dev->queues->queue[AdapNormCmdQueue];
 
 	if(wait)
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-	spin_lock_irqsave(q->lock, qflags);
-	if (dev->new_comm_interface) {
-		unsigned long count = 10000000L; /* 50 seconds */
-		q->numpending++;
-		spin_unlock_irqrestore(q->lock, qflags);
-		while (aac_adapter_send(fibptr) != 0) {
-			if (--count == 0) {
-				if (wait)
-					spin_unlock_irqrestore(&fibptr->event_lock, flags);
-				spin_lock_irqsave(q->lock, qflags);
-				q->numpending--;
-				spin_unlock_irqrestore(q->lock, qflags);
-				return -ETIMEDOUT;
-			}
-			udelay(5);
-		}
-	} else {
-		u32 index;
-		unsigned long nointr = 0;
-		aac_queue_get( dev, &index, AdapNormCmdQueue, hw_fib, 1, fibptr, &nointr);
-
-		q->numpending++;
-		*(q->headers.producer) = cpu_to_le32(index + 1);
-		spin_unlock_irqrestore(q->lock, qflags);
-		dprintk((KERN_DEBUG "aac_fib_send: inserting a queue entry at index %d.\n",index));
-		if (!(nointr & aac_config.irq_mod))
-			aac_adapter_notify(dev, AdapNormCmdQueue);
-	}
+	aac_adapter_deliver(fibptr);
 
 	/*
 	 *	If the caller wanted us to wait for response wait now. 
@@ -520,6 +491,7 @@
 			while (down_trylock(&fibptr->event_wait)) {
 				int blink;
 				if (--count == 0) {
+					struct aac_queue * q = &dev->queues->queue[AdapNormCmdQueue];
 					spin_lock_irqsave(q->lock, qflags);
 					q->numpending--;
 					spin_unlock_irqrestore(q->lock, qflags);
@@ -659,7 +631,7 @@
 	unsigned long qflags;
 
 	if (hw_fib->header.XferState == 0) {
-		if (dev->new_comm_interface)
+		if (dev->comm_interface == AAC_COMM_MESSAGE)
 			kfree (hw_fib);
         	return 0;
 	}
@@ -667,7 +639,7 @@
 	 *	If we plan to do anything check the structure type first.
 	 */ 
 	if ( hw_fib->header.StructType != FIB_MAGIC ) {
-		if (dev->new_comm_interface)
+		if (dev->comm_interface == AAC_COMM_MESSAGE)
 			kfree (hw_fib);
         	return -EINVAL;
 	}
@@ -679,7 +651,7 @@
 	 *	send the completed cdb to the adapter.
 	 */
 	if (hw_fib->header.XferState & cpu_to_le32(SentFromAdapter)) {
-		if (dev->new_comm_interface) {
+		if (dev->comm_interface == AAC_COMM_MESSAGE) {
 			kfree (hw_fib);
 		} else {
 	       		u32 index;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rkt.c	2007-01-15 10:20:19.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/rkt.c	2007-01-18 10:11:20.000000000 -0800
@@ -34,6 +34,40 @@
 
 #include "aacraid.h"
 
+#define AAC_NUM_IO_FIB_RKT      (246 - AAC_NUM_MGT_FIB)
+
+/**
+ *	aac_rkt_select_comm	-	Select communications method
+ *	@dev: Adapter
+ *	@comm: communications method
+ */
+
+static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
+{
+	int retval;
+	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
+	retval = aac_rx_select_comm(dev, comm);
+	if (comm == AAC_COMM_MESSAGE) {
+		/*
+		 * FIB Setup has already been done, but we can minimize the
+		 * damage by at least ensuring the OS never issues more
+		 * commands than we can handle. The Rocket adapters currently
+		 * can only handle 246 commands and 8 AIFs at the same time,
+		 * and in fact do notify us accordingly if we negotiate the
+		 * FIB size. The problem that causes us to add this check is
+		 * to ensure that we do not overdo it with the adapter when a
+		 * hard coded FIB override is being utilized. This special
+		 * case warrants this half baked, but convenient, check here.
+		 */
+		if (dev->scsi_host_ptr->can_queue > AAC_NUM_IO_FIB_RKT) {
+			dev->init->MaxIoCommands =
+				cpu_to_le32(AAC_NUM_IO_FIB_RKT + AAC_NUM_MGT_FIB);
+			dev->scsi_host_ptr->can_queue = AAC_NUM_IO_FIB_RKT;
+		}
+	}
+	return retval;
+}
+
 /**
  *	aac_rkt_ioremap
  *	@size: mapping resize request
@@ -63,39 +97,13 @@
 
 int aac_rkt_init(struct aac_dev *dev)
 {
-	int retval;
 	extern int _aac_rx_init(struct aac_dev *dev);
-	extern void aac_rx_start_adapter(struct aac_dev *dev);
 
 	/*
 	 *	Fill in the function dispatch table.
 	 */
 	dev->a_ops.adapter_ioremap = aac_rkt_ioremap;
+	dev->a_ops.adapter_comm = aac_rkt_select_comm;
 
-	retval = _aac_rx_init(dev);
-	if (retval)
-		return retval;
-	if (dev->new_comm_interface) {
-		/*
-		 * FIB Setup has already been done, but we can minimize the
-		 * damage by at least ensuring the OS never issues more
-		 * commands than we can handle. The Rocket adapters currently
-		 * can only handle 246 commands and 8 AIFs at the same time,
-		 * and in fact do notify us accordingly if we negotiate the
-		 * FIB size. The problem that causes us to add this check is
-		 * to ensure that we do not overdo it with the adapter when a
-		 * hard coded FIB override is being utilized. This special
-		 * case warrants this half baked, but convenient, check here.
-		 */
-		if (dev->scsi_host_ptr->can_queue > (246 - AAC_NUM_MGT_FIB)) {
-			dev->init->MaxIoCommands = cpu_to_le32(246);
-			dev->scsi_host_ptr->can_queue = 246 - AAC_NUM_MGT_FIB;
-		}
-	}
-	/*
-	 *	Tell the adapter that all is configured, and it can start
-	 *	accepting requests
-	 */
-	aac_rx_start_adapter(dev);
-	return 0;
+	return _aac_rx_init(dev);
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2007-01-15 10:20:19.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2007-01-18 09:11:18.000000000 -0800
@@ -46,60 +46,60 @@
 
 #include "aacraid.h"
 
-static irqreturn_t aac_rx_intr(int irq, void *dev_id)
+static irqreturn_t aac_rx_intr_producer(int irq, void *dev_id)
 {
 	struct aac_dev *dev = dev_id;
+	unsigned long bellbits;
+	u8 intstat = rx_readb(dev, MUnit.OISR);
 
-	dprintk((KERN_DEBUG "aac_rx_intr(%d,%p)\n", irq, dev_id));
-	if (dev->new_comm_interface) {
-		u32 Index = rx_readl(dev, MUnit.OutboundQueue);
-		if (Index == 0xFFFFFFFFL)
-			Index = rx_readl(dev, MUnit.OutboundQueue);
-		if (Index != 0xFFFFFFFFL) {
-			do {
-				if (aac_intr_normal(dev, Index)) {
-					rx_writel(dev, MUnit.OutboundQueue, Index);
-					rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespReady);
-				}
-				Index = rx_readl(dev, MUnit.OutboundQueue);
-			} while (Index != 0xFFFFFFFFL);
-			return IRQ_HANDLED;
+	/*
+	 *	Read mask and invert because drawbridge is reversed.
+	 *	This allows us to only service interrupts that have
+	 *	been enabled.
+	 *	Check to see if this is our interrupt.  If it isn't just return
+	 */
+	if (intstat & ~(dev->OIMR)) {
+		bellbits = rx_readl(dev, OutboundDoorbellReg);
+		if (bellbits & DoorBellPrintfReady) {
+			aac_printf(dev, readl (&dev->IndexRegs->Mailbox[5]));
+			rx_writel(dev, MUnit.ODR,DoorBellPrintfReady);
+			rx_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
 		}
-	} else {
-		unsigned long bellbits;
-		u8 intstat;
-		intstat = rx_readb(dev, MUnit.OISR);
-		/*
-		 *	Read mask and invert because drawbridge is reversed.
-		 *	This allows us to only service interrupts that have 
-		 *	been enabled.
-		 *	Check to see if this is our interrupt.  If it isn't just return
-		 */
-		if (intstat & ~(dev->OIMR)) 
-		{
-			bellbits = rx_readl(dev, OutboundDoorbellReg);
-			if (bellbits & DoorBellPrintfReady) {
-				aac_printf(dev, readl (&dev->IndexRegs->Mailbox[5]));
-				rx_writel(dev, MUnit.ODR,DoorBellPrintfReady);
-				rx_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
-			}
-			else if (bellbits & DoorBellAdapterNormCmdReady) {
-				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
-				aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
-			}
-			else if (bellbits & DoorBellAdapterNormRespReady) {
-				rx_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
-				aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
-			}
-			else if (bellbits & DoorBellAdapterNormCmdNotFull) {
-				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
-			}
-			else if (bellbits & DoorBellAdapterNormRespNotFull) {
-				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
-				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
-			}
-			return IRQ_HANDLED;
+		else if (bellbits & DoorBellAdapterNormCmdReady) {
+			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
+			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
 		}
+		else if (bellbits & DoorBellAdapterNormRespReady) {
+			rx_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
+			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
+		}
+		else if (bellbits & DoorBellAdapterNormCmdNotFull) {
+			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+		}
+		else if (bellbits & DoorBellAdapterNormRespNotFull) {
+			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+		}
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+static irqreturn_t aac_rx_intr_message(int irq, void *dev_id)
+{
+	struct aac_dev *dev = dev_id;
+	u32 Index = rx_readl(dev, MUnit.OutboundQueue);
+	if (Index == 0xFFFFFFFFL)
+		Index = rx_readl(dev, MUnit.OutboundQueue);
+	if (Index != 0xFFFFFFFFL) {
+		do {
+			if (aac_intr_normal(dev, Index)) {
+				rx_writel(dev, MUnit.OutboundQueue, Index);
+				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespReady);
+			}
+			Index = rx_readl(dev, MUnit.OutboundQueue);
+		} while (Index != 0xFFFFFFFFL);
+		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
 }
@@ -115,6 +115,26 @@
 }
 
 /**
+ *	aac_rx_enable_interrupt_producer	-	Enable interrupts
+ *	@dev: Adapter
+ */
+
+static void aac_rx_enable_interrupt_producer(struct aac_dev *dev)
+{
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+}
+
+/**
+ *	aac_rx_enable_interrupt_message	-	Enable interrupts
+ *	@dev: Adapter
+ */
+
+static void aac_rx_enable_interrupt_message(struct aac_dev *dev)
+{
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+}
+
+/**
  *	rx_sync_cmd	-	send a command and wait
  *	@dev: Adapter
  *	@command: Command to execute
@@ -189,10 +209,7 @@
 		/*
 		 *	Restore interrupt mask even though we timed out
 		 */
-		if (dev->new_comm_interface)
-			rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
-		else
-			rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+		aac_adapter_enable_int(dev);
 		return -ETIMEDOUT;
 	}
 	/*
@@ -215,10 +232,7 @@
 	/*
 	 *	Restore interrupt mask
 	 */
-	if (dev->new_comm_interface)
-		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
-	else
-		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+	aac_adapter_enable_int(dev);
 	return 0;
 
 }
@@ -360,35 +374,72 @@
 }
 
 /**
- *	aac_rx_send
+ *	aac_rx_deliver_producer
  *	@fib: fib to issue
  *
  *	Will send a fib, returning 0 if successful.
  */
-static int aac_rx_send(struct fib * fib)
+static int aac_rx_deliver_producer(struct fib * fib)
 {
-	u64 addr = fib->hw_fib_pa;
 	struct aac_dev *dev = fib->dev;
-	volatile void __iomem *device = dev->regs.rx;
+	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
+	unsigned long qflags;
 	u32 Index;
+	unsigned long nointr = 0;
 
-	dprintk((KERN_DEBUG "%p->aac_rx_send(%p->%llx)\n", dev, fib, addr));
-	Index = rx_readl(dev, MUnit.InboundQueue);
-	if (Index == 0xFFFFFFFFL)
+	spin_lock_irqsave(q->lock, qflags);
+	aac_queue_get( dev, &Index, AdapNormCmdQueue, fib->hw_fib, 1, fib, &nointr);
+
+	q->numpending++;
+	*(q->headers.producer) = cpu_to_le32(Index + 1);
+	spin_unlock_irqrestore(q->lock, qflags);
+	if (!(nointr & aac_config.irq_mod))
+		aac_adapter_notify(dev, AdapNormCmdQueue);
+
+	return 0;
+}
+
+/**
+ *	aac_rx_deliver_message
+ *	@fib: fib to issue
+ *
+ *	Will send a fib, returning 0 if successful.
+ */
+static int aac_rx_deliver_message(struct fib * fib)
+{
+	struct aac_dev *dev = fib->dev;
+	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
+	unsigned long qflags;
+	u32 Index;
+	u64 addr;
+	volatile void __iomem *device;
+
+	unsigned long count = 10000000L; /* 50 seconds */
+	spin_lock_irqsave(q->lock, qflags);
+	q->numpending++;
+	spin_unlock_irqrestore(q->lock, qflags);
+	for(;;) {
 		Index = rx_readl(dev, MUnit.InboundQueue);
-	dprintk((KERN_DEBUG "Index = 0x%x\n", Index));
-	if (Index == 0xFFFFFFFFL)
-		return Index;
+		if (Index == 0xFFFFFFFFL)
+			Index = rx_readl(dev, MUnit.InboundQueue);
+		if (Index != 0xFFFFFFFFL)
+			break;
+		if (--count == 0) {
+			spin_lock_irqsave(q->lock, qflags);
+			q->numpending--;
+			spin_unlock_irqrestore(q->lock, qflags);
+			return -ETIMEDOUT;
+		}
+		udelay(5);
+	}
 	device = dev->base + Index;
-	dprintk((KERN_DEBUG "entry = %x %x %u\n", (u32)(addr & 0xffffffff),
-	  (u32)(addr >> 32), (u32)le16_to_cpu(fib->hw_fib->header.Size)));
+	addr = fib->hw_fib_pa;
 	writel((u32)(addr & 0xffffffff), device);
 	device += sizeof(u32);
 	writel((u32)(addr >> 32), device);
 	device += sizeof(u32);
 	writel(le16_to_cpu(fib->hw_fib->header.Size), device);
 	rx_writel(dev, MUnit.InboundQueue, Index);
-	dprintk((KERN_DEBUG "aac_rx_send - return 0\n"));
 	return 0;
 }
 
@@ -430,6 +481,31 @@
 }
 
 /**
+ *	aac_rx_select_comm	-	Select communications method
+ *	@dev: Adapter
+ *	@comm: communications method
+ */
+
+int aac_rx_select_comm(struct aac_dev *dev, int comm)
+{
+	switch (comm) {
+	case AAC_COMM_PRODUCER:
+		dev->a_ops.adapter_enable_int = aac_rx_enable_interrupt_producer;
+		dev->a_ops.adapter_intr = aac_rx_intr_producer;
+		dev->a_ops.adapter_deliver = aac_rx_deliver_producer;
+		break;
+	case AAC_COMM_MESSAGE:
+		dev->a_ops.adapter_enable_int = aac_rx_enable_interrupt_message;
+		dev->a_ops.adapter_intr = aac_rx_intr_message;
+		dev->a_ops.adapter_deliver = aac_rx_deliver_message;
+		break;
+	default:
+		return 1;
+	}
+	return 0;
+}
+
+/**
  *	aac_rx_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *
@@ -489,40 +565,42 @@
 		}
 		msleep(1);
 	}
-	if (request_irq(dev->scsi_host_ptr->irq, aac_rx_intr, IRQF_SHARED|IRQF_DISABLED, "aacraid", (void *)dev)<0)
-	{
-		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name, instance);
-		goto error_iounmap;
-	}
 	/*
-	 *	Fill in the function dispatch table.
+	 *	Fill in the common function dispatch table.
 	 */
 	dev->a_ops.adapter_interrupt = aac_rx_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
-	dev->a_ops.adapter_send = aac_rx_send;
 
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
 	 *	can handle.
 	 */
-	rx_writeb(dev, MUnit.OIMR, 0xff);
+	aac_adapter_comm(dev, AAC_COMM_PRODUCER);
+	aac_adapter_disable_int(dev);
 	rx_writel(dev, MUnit.ODR, 0xffffffff);
-	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+	aac_adapter_enable_int(dev);
 
 	if (aac_init_adapter(dev) == NULL)
-		goto error_irq;
-	if (dev->new_comm_interface)
-		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+		goto error_iounmap;
+	aac_adapter_comm(dev, dev->comm_interface);
+	if (request_irq(dev->scsi_host_ptr->irq, dev->a_ops.adapter_intr,
+			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
+			name, instance);
+		goto error_iounmap;
+	}
+	aac_adapter_enable_int(dev);
+	/*
+	 *	Tell the adapter that all is configured, and it can
+	 * start accepting requests
+	 */
+	aac_rx_start_adapter(dev);
 
 	return 0;
 
-error_irq:
-	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
-	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
-
 error_iounmap:
 
 	return -1;
@@ -530,20 +608,11 @@
 
 int aac_rx_init(struct aac_dev *dev)
 {
-	int retval;
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
 	dev->a_ops.adapter_ioremap = aac_rx_ioremap;
+	dev->a_ops.adapter_comm = aac_rx_select_comm;
 
-	retval = _aac_rx_init(dev);
-	if (!retval) {
-		/*
-		 *	Tell the adapter that all is configured, and it can
-		 * start accepting requests
-		 */
-		aac_rx_start_adapter(dev);
-	}
-	return retval;
+	return _aac_rx_init(dev);
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/sa.c	2007-01-15 10:20:19.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/sa.c	2007-01-15 10:24:43.000000000 -0800
@@ -92,6 +92,17 @@
 }
 
 /**
+ *	aac_sa_enable_interrupt	-	enable interrupt
+ *	@dev: Which adapter to enable.
+ */
+
+static void aac_sa_enable_interrupt (struct aac_dev *dev)
+{
+	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 |
+				DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
+}
+
+/**
  *	aac_sa_notify_adapter		-	handle adapter notification
  *	@dev:	Adapter that notification is for
  *	@event:	Event to notidy
@@ -347,32 +358,36 @@
 		msleep(1);
 	}
 
-	if (request_irq(dev->scsi_host_ptr->irq, aac_sa_intr, IRQF_SHARED|IRQF_DISABLED, "aacraid", (void *)dev ) < 0) {
-		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n", name, instance);
-		goto error_iounmap;
-	}
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
 
 	dev->a_ops.adapter_interrupt = aac_sa_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
+	dev->a_ops.adapter_enable_int = aac_sa_enable_interrupt;
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;
+	dev->a_ops.adapter_intr = aac_sa_intr;
 	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
 
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that 
 	 *	we can handle.
 	 */
-	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
-	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | 
-				DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
+	aac_adapter_disable_int(dev);
+	aac_adapter_enable_int(dev);
 
 	if(aac_init_adapter(dev) == NULL)
 		goto error_irq;
+	if (request_irq(dev->scsi_host_ptr->irq, dev->a_ops.adapter_intr,
+			IRQF_SHARED|IRQF_DISABLED,
+			"aacraid", (void *)dev ) < 0) {
+		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n",
+			name, instance);
+		goto error_iounmap;
+	}
+	aac_adapter_enable_int(dev);
 
 	/*
 	 *	Tell the adapter that all is configure, and it can start 
@@ -382,7 +397,7 @@
 	return 0;
 
 error_irq:
-	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
+	aac_sa_disable_interrupt(dev);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:

-- 
Mark Haverkamp <markh@linux-foundation.org>

