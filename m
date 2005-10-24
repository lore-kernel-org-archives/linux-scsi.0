From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/5] aacraid: Newer adapter communication iterface support
Date: Mon, 24 Oct 2005 10:52:22 -0700
Message-ID: <1130176342.4628.25.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:48862 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751202AbVJXRw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:52:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This patch adds the 'new comm' interface, which modern AAC based
adapters that are less than a year old support in the name of much
improved performance. These modern adapters support both the legacy and
the 'new comm' interfaces.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Index: scsi-rc-aac-1/drivers/scsi/aacraid/README
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/README	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/README	2005-10-19 13:04:18.000000000 -0700
@@ -57,7 +57,7 @@
 					(fixed 64bit and 64G memory model, changed confusing naming convention
 					 where fibs that go to the hardware are consistently called hw_fibs and
 					 not just fibs like the name of the driver tracking structure)
-Mark Salyzyn <Mark_Salyzyn@adaptec.com> Fixed panic issues and added some new product ids for upcoming hbas.
+Mark Salyzyn <Mark_Salyzyn@adaptec.com> Fixed panic issues and added some new product ids for upcoming hbas. Performance tuning, card failover and bug mitigations.
 
 Original Driver
 -------------------------
Index: scsi-rc-aac-1/drivers/scsi/aacraid/TODO
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/TODO	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/TODO	2005-10-19 13:04:18.000000000 -0700
@@ -1,4 +1,3 @@
 o	Testing
 o	More testing
-o	Drop irq_mask, basically unused
 o	I/O size increase
Index: scsi-rc-aac-1/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/aachba.c	2005-10-19 13:04:02.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/aachba.c	2005-10-19 13:04:18.000000000 -0700
@@ -359,15 +359,6 @@
 	return status;
 }
 
-static void aac_io_done(struct scsi_cmnd * scsicmd)
-{
-	unsigned long cpu_flags;
-	struct Scsi_Host *host = scsicmd->device->host;
-	spin_lock_irqsave(host->host_lock, cpu_flags);
-	scsicmd->scsi_done(scsicmd);
-	spin_unlock_irqrestore(host->host_lock, cpu_flags);
-}
-
 static void aac_internal_transfer(struct scsi_cmnd *scsicmd, void *data, unsigned int offset, unsigned int len)
 {
 	void *buf;
@@ -424,7 +415,7 @@
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 }
 
 /**
@@ -988,7 +979,7 @@
 	fib_complete(fibptr);
 	fib_free(fibptr);
 
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 }
 
 static int aac_read(struct scsi_cmnd * scsicmd, int cid)
@@ -1167,7 +1158,7 @@
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
 	return 0;
@@ -1239,7 +1230,7 @@
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
 		scsicmd->result = DID_ERROR << 16;
-		aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
 	fib_init(cmd_fibcontext);
@@ -1336,7 +1327,7 @@
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
@@ -1380,7 +1371,7 @@
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
-	aac_io_done(cmd);
+	cmd->scsi_done(cmd);
 }
 
 static int aac_synchronize(struct scsi_cmnd *scsicmd, int cid)
@@ -2097,7 +2088,7 @@
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 }
 
 /**
Index: scsi-rc-aac-1/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/aacraid.h	2005-10-19 13:04:06.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/aacraid.h	2005-10-19 13:04:18.000000000 -0700
@@ -481,6 +481,7 @@
 #define FSAFS_NTC_FIB_CONTEXT			0x030c
 
 struct aac_dev;
+struct fib;
 
 struct adapter_ops
 {
@@ -489,6 +490,7 @@
 	void (*adapter_disable_int)(struct aac_dev *dev);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
+	int  (*adapter_send)(struct fib * fib);
 };
 
 /*
@@ -659,6 +661,10 @@
 						Status Register */
 	__le32	OIMR;	    /*	1334h  | 34h | Outbound Interrupt 
 						Mask Register */
+	__le32	reserved2;  /*	1338h  | 38h | Reserved */
+	__le32	reserved3;  /*	133Ch  | 3Ch | Reserved */
+	__le32	InboundQueue;/*	1340h  | 40h | Inbound Queue Port relative to firmware */
+	__le32	OutboundQueue;/*1344h  | 44h | Outbound Queue Port relative to firmware */
 			    /* * Must access through ATU Inbound 
 			     	 Translation Window */
 };
@@ -693,8 +699,8 @@
 #define OutboundDoorbellReg	MUnit.ODR
 
 struct rx_registers {
-	struct rx_mu_registers		MUnit;		/* 1300h - 1334h */
-	__le32				reserved1[6];	/* 1338h - 134ch */
+	struct rx_mu_registers		MUnit;		/* 1300h - 1344h */
+	__le32				reserved1[2];	/* 1348h - 134ch */
 	struct rx_inbound		IndexRegs;
 };
 
@@ -711,8 +717,8 @@
 #define rkt_inbound rx_inbound
 
 struct rkt_registers {
-	struct rkt_mu_registers		MUnit;		 /* 1300h - 1334h */
-	__le32				reserved1[1010]; /* 1338h - 22fch */
+	struct rkt_mu_registers		MUnit;		 /* 1300h - 1344h */
+	__le32				reserved1[1006]; /* 1348h - 22fch */
 	struct rkt_inbound		IndexRegs;	 /* 2300h - */
 };
 
@@ -721,8 +727,6 @@
 #define rkt_writeb(AEP, CSR, value)	writeb(value, &((AEP)->regs.rkt->CSR))
 #define rkt_writel(AEP, CSR, value)	writel(value, &((AEP)->regs.rkt->CSR))
 
-struct fib;
-
 typedef void (*fib_callback)(void *ctxt, struct fib *fibctx);
 
 struct aac_fib_context {
@@ -937,7 +941,6 @@
 	const char		*name;
 	int			id;
 
-	u16			irq_mask;
 	/*
 	 *	negotiated FIB settings
 	 */
@@ -972,6 +975,7 @@
 	struct adapter_ops	a_ops;
 	unsigned long		fsrev;		/* Main driver's revision number */
 	
+	unsigned		base_size;	/* Size of mapped in region */
 	struct aac_init		*init;		/* Holds initialization info to communicate with adapter */
 	dma_addr_t		init_pa; 	/* Holds physical address of the init struct */
 	
@@ -992,6 +996,9 @@
 	/*
 	 *	The following is the device specific extension.
 	 */
+#if (!defined(AAC_MIN_FOOTPRINT_SIZE))
+#	define AAC_MIN_FOOTPRINT_SIZE 8192
+#endif
 	union
 	{
 		struct sa_registers __iomem *sa;
@@ -1012,6 +1019,7 @@
 	u8			nondasd_support; 
 	u8			dac_support;
 	u8			raid_scsi_mode;
+	u8			new_comm_interface;
 	/* macro side-effects BEWARE */
 #	define			raw_io_interface \
 	  init->InitStructRevision==cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4)
@@ -1034,6 +1042,8 @@
 #define aac_adapter_check_health(dev) \
 	(dev)->a_ops.adapter_check_health(dev)
 
+#define aac_adapter_send(fib) \
+	((fib)->dev)->a_ops.adapter_send(fib)
 
 #define FIB_CONTEXT_FLAG_TIMED_OUT		(0x00000001)
 
@@ -1779,6 +1789,7 @@
 int aac_sa_init(struct aac_dev *dev);
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
+unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
 int aac_command_thread(struct aac_dev * dev);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
 int fib_adapter_complete(struct fib * fibptr, unsigned short size);
Index: scsi-rc-aac-1/drivers/scsi/aacraid/comminit.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/comminit.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/comminit.c	2005-10-19 13:04:18.000000000 -0700
@@ -116,6 +116,10 @@
 	}
 
 	init->InitFlags = 0;
+	if (dev->new_comm_interface) {
+		init->InitFlags = cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
+		dprintk((KERN_WARNING"aacraid: New Comm Interface enabled\n"));
+	}
 	init->MaxIoCommands = cpu_to_le32(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
 	init->MaxIoSize = cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
 	init->MaxFibSize = cpu_to_le32(dev->max_fib_size);
@@ -315,12 +319,33 @@
 		- sizeof(struct aac_fibhdr)
 		- sizeof(struct aac_write) + sizeof(struct sgentry))
 			/ sizeof(struct sgentry);
+	dev->new_comm_interface = 0;
 	dev->raw_io_64 = 0;
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
 	 		(status[0] == 0x00000001)) {
 		if (status[1] & AAC_OPT_NEW_COMM_64)
 			dev->raw_io_64 = 1;
+		if (status[1] & AAC_OPT_NEW_COMM)
+			dev->new_comm_interface = dev->a_ops.adapter_send != 0;
+		if (dev->new_comm_interface && (status[2] > dev->base_size)) {
+			iounmap(dev->regs.sa);
+			dev->base_size = status[2];
+			dprintk((KERN_DEBUG "ioremap(%lx,%d)\n",
+			  host->base, status[2]));
+			dev->regs.sa = ioremap(host->base, status[2]);
+			if (dev->regs.sa == NULL) {
+				/* remap failed, go back ... */
+				dev->new_comm_interface = 0;
+				dev->regs.sa = ioremap(host->base, 
+						AAC_MIN_FOOTPRINT_SIZE);
+				if (dev->regs.sa == NULL) {	
+					printk(KERN_WARNING
+					  "aacraid: unable to map adapter.\n");
+					return NULL;
+				}
+			}
+		}
 	}
 	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
 	  0, 0, 0, 0, 0, 0,
Index: scsi-rc-aac-1/drivers/scsi/aacraid/commsup.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/commsup.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/commsup.c	2005-10-19 13:04:18.000000000 -0700
@@ -212,7 +212,7 @@
 	hw_fib->header.StructType = FIB_MAGIC;
 	hw_fib->header.Size = cpu_to_le16(fibptr->dev->max_fib_size);
 	hw_fib->header.XferState = cpu_to_le32(HostOwned | FibInitialized | FibEmpty | FastResponseCapable);
-	hw_fib->header.SenderFibAddress = cpu_to_le32(fibptr->hw_fib_pa);
+	hw_fib->header.SenderFibAddress = 0; /* Filled in later if needed */
 	hw_fib->header.ReceiverFibAddress = cpu_to_le32(fibptr->hw_fib_pa);
 	hw_fib->header.SenderSize = cpu_to_le16(fibptr->dev->max_fib_size);
 }
@@ -380,9 +380,7 @@
  
 int fib_send(u16 command, struct fib * fibptr, unsigned long size,  int priority, int wait, int reply, fib_callback callback, void * callback_data)
 {
-	u32 index;
 	struct aac_dev * dev = fibptr->dev;
-	unsigned long nointr = 0;
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_queue * q;
 	unsigned long flags = 0;
@@ -417,7 +415,7 @@
 	 *	Map the fib into 32bits by using the fib number
 	 */
 
-	hw_fib->header.SenderFibAddress = cpu_to_le32(((u32)(fibptr-dev->fibs)) << 1);
+	hw_fib->header.SenderFibAddress = cpu_to_le32(((u32)(fibptr - dev->fibs)) << 2);
 	hw_fib->header.SenderData = (u32)(fibptr - dev->fibs);
 	/*
 	 *	Set FIB state to indicate where it came from and if we want a
@@ -456,10 +454,10 @@
 
 	FIB_COUNTER_INCREMENT(aac_config.FibsSent);
 
-	dprintk((KERN_DEBUG "fib_send: inserting a queue entry at index %d.\n",index));
 	dprintk((KERN_DEBUG "Fib contents:.\n"));
-	dprintk((KERN_DEBUG "  Command =               %d.\n", hw_fib->header.Command));
-	dprintk((KERN_DEBUG "  XferState  =            %x.\n", hw_fib->header.XferState));
+	dprintk((KERN_DEBUG "  Command =               %d.\n", le32_to_cpu(hw_fib->header.Command)));
+	dprintk((KERN_DEBUG "  SubCommand =            %d.\n", le32_to_cpu(((struct aac_query_mount *)fib_data(fibptr))->command)));
+	dprintk((KERN_DEBUG "  XferState  =            %x.\n", le32_to_cpu(hw_fib->header.XferState)));
 	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib));
 	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
 	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
@@ -469,14 +467,37 @@
 	if(wait)
 		spin_lock_irqsave(&fibptr->event_lock, flags);
 	spin_lock_irqsave(q->lock, qflags);
-	aac_queue_get( dev, &index, AdapNormCmdQueue, hw_fib, 1, fibptr, &nointr);
+	if (dev->new_comm_interface) {
+		unsigned long count = 10000000L; /* 50 seconds */
+		list_add_tail(&fibptr->queue, &q->pendingq);
+		q->numpending++;
+		spin_unlock_irqrestore(q->lock, qflags);
+		while (aac_adapter_send(fibptr) != 0) {
+			if (--count == 0) {
+				if (wait)
+					spin_unlock_irqrestore(&fibptr->event_lock, flags);
+				spin_lock_irqsave(q->lock, qflags);
+				q->numpending--;
+				list_del(&fibptr->queue);
+				spin_unlock_irqrestore(q->lock, qflags);
+				return -ETIMEDOUT;
+			}
+			udelay(5);
+		}
+	} else {
+		u32 index;
+		unsigned long nointr = 0;
+		aac_queue_get( dev, &index, AdapNormCmdQueue, hw_fib, 1, fibptr, &nointr);
+
+		list_add_tail(&fibptr->queue, &q->pendingq);
+		q->numpending++;
+		*(q->headers.producer) = cpu_to_le32(index + 1);
+		spin_unlock_irqrestore(q->lock, qflags);
+		dprintk((KERN_DEBUG "fib_send: inserting a queue entry at index %d.\n",index));
+		if (!(nointr & aac_config.irq_mod))
+			aac_adapter_notify(dev, AdapNormCmdQueue);
+	}
 
-	list_add_tail(&fibptr->queue, &q->pendingq);
-	q->numpending++;
-	*(q->headers.producer) = cpu_to_le32(index + 1);
-	spin_unlock_irqrestore(q->lock, qflags);
-	if (!(nointr & aac_config.irq_mod))
-		aac_adapter_notify(dev, AdapNormCmdQueue);
 	/*
 	 *	If the caller wanted us to wait for response wait now. 
 	 */
@@ -492,7 +513,6 @@
 			 * hardware failure has occurred.
 			 */
 			unsigned long count = 36000000L; /* 3 minutes */
-			unsigned long qflags;
 			while (down_trylock(&fibptr->event_wait)) {
 				if (--count == 0) {
 					spin_lock_irqsave(q->lock, qflags);
@@ -621,12 +641,16 @@
 	unsigned long qflags;
 
 	if (hw_fib->header.XferState == 0) {
+		if (dev->new_comm_interface)
+			kfree (hw_fib);
         	return 0;
 	}
 	/*
 	 *	If we plan to do anything check the structure type first.
 	 */ 
 	if ( hw_fib->header.StructType != FIB_MAGIC ) {
+		if (dev->new_comm_interface)
+			kfree (hw_fib);
         	return -EINVAL;
 	}
 	/*
@@ -637,21 +661,25 @@
 	 *	send the completed cdb to the adapter.
 	 */
 	if (hw_fib->header.XferState & cpu_to_le32(SentFromAdapter)) {
-		u32 index;
-	        hw_fib->header.XferState |= cpu_to_le32(HostProcessed);
-		if (size) {
-			size += sizeof(struct aac_fibhdr);
-			if (size > le16_to_cpu(hw_fib->header.SenderSize)) 
-				return -EMSGSIZE;
-			hw_fib->header.Size = cpu_to_le16(size);
+		if (dev->new_comm_interface) {
+			kfree (hw_fib);
+		} else {
+	       		u32 index;
+		        hw_fib->header.XferState |= cpu_to_le32(HostProcessed);
+			if (size) {
+				size += sizeof(struct aac_fibhdr);
+				if (size > le16_to_cpu(hw_fib->header.SenderSize)) 
+					return -EMSGSIZE;
+				hw_fib->header.Size = cpu_to_le16(size);
+			}
+			q = &dev->queues->queue[AdapNormRespQueue];
+			spin_lock_irqsave(q->lock, qflags);
+			aac_queue_get(dev, &index, AdapNormRespQueue, hw_fib, 1, NULL, &nointr);
+			*(q->headers.producer) = cpu_to_le32(index + 1);
+			spin_unlock_irqrestore(q->lock, qflags);
+			if (!(nointr & (int)aac_config.irq_mod))
+				aac_adapter_notify(dev, AdapNormRespQueue);
 		}
-		q = &dev->queues->queue[AdapNormRespQueue];
-		spin_lock_irqsave(q->lock, qflags);
-		aac_queue_get(dev, &index, AdapNormRespQueue, hw_fib, 1, NULL, &nointr);
-		*(q->headers.producer) = cpu_to_le32(index + 1);
-		spin_unlock_irqrestore(q->lock, qflags);
-		if (!(nointr & (int)aac_config.irq_mod))
-			aac_adapter_notify(dev, AdapNormRespQueue);
 	}
 	else 
 	{
Index: scsi-rc-aac-1/drivers/scsi/aacraid/dpcsup.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/dpcsup.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/dpcsup.c	2005-10-19 13:04:18.000000000 -0700
@@ -73,7 +73,7 @@
 		int fast;
 		u32 index = le32_to_cpu(entry->addr);
 		fast = index & 0x01;
-		fib = &dev->fibs[index >> 1];
+		fib = &dev->fibs[index >> 2];
 		hwfib = fib->hw_fib;
 		
 		aac_consumer_free(dev, q, HostNormRespQueue);
@@ -213,3 +213,116 @@
 	spin_unlock_irqrestore(q->lock, flags);
 	return 0;
 }
+
+
+/**
+ *	aac_intr_normal	-	Handle command replies
+ *	@dev: Device
+ *	@index: completion reference
+ *
+ *	This DPC routine will be run when the adapter interrupts us to let us
+ *	know there is a response on our normal priority queue. We will pull off
+ *	all QE there are and wake up all the waiters before exiting.
+ */
+
+unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index)
+{
+	u32 index = le32_to_cpu(Index);
+
+	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, Index));
+	if ((index & 0x00000002L)) {
+		struct hw_fib * hw_fib;
+		struct fib * fib;
+		struct aac_queue *q = &dev->queues->queue[HostNormCmdQueue];
+		unsigned long flags;
+
+		if (index == 0xFFFFFFFEL) /* Special Case */
+			return 0;	  /* Do nothing */
+		/*
+		 *	Allocate a FIB. For non queued stuff we can just use
+		 * the stack so we are happy. We need a fib object in order to
+		 * manage the linked lists.
+		 */
+		if ((!dev->aif_thread)
+		 || (!(fib = kmalloc(sizeof(struct fib),GFP_ATOMIC))))
+			return 1;
+		if (!(hw_fib = kmalloc(sizeof(struct hw_fib),GFP_ATOMIC))) {
+			kfree (fib);
+			return 1;
+		}
+		memset(hw_fib, 0, sizeof(struct hw_fib));
+		memcpy(hw_fib, (struct hw_fib *)(((unsigned long)(dev->regs.sa)) + (index & ~0x00000002L)), sizeof(struct hw_fib));
+		memset(fib, 0, sizeof(struct fib));
+		INIT_LIST_HEAD(&fib->fiblink);
+		fib->type = FSAFS_NTC_FIB_CONTEXT;
+		fib->size = sizeof(struct fib);
+		fib->hw_fib = hw_fib;
+		fib->data = hw_fib->data;
+		fib->dev = dev;
+	
+		spin_lock_irqsave(q->lock, flags);
+		list_add_tail(&fib->fiblink, &q->cmdq);
+	        wake_up_interruptible(&q->cmdready);
+		spin_unlock_irqrestore(q->lock, flags);
+		return 1;
+	} else {
+		int fast = index & 0x01;
+		struct fib * fib = &dev->fibs[index >> 2];
+		struct hw_fib * hwfib = fib->hw_fib;
+
+		/*
+		 *	Remove this fib from the Outstanding I/O queue.
+		 *	But only if it has not already been timed out.
+		 *
+		 *	If the fib has been timed out already, then just 
+		 *	continue. The caller has already been notified that
+		 *	the fib timed out.
+		 */
+		if ((fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
+			printk(KERN_WARNING "aacraid: FIB timeout (%x).\n", fib->flags);
+			printk(KERN_DEBUG"aacraid: hwfib=%p index=%i fib=%p\n",hwfib, hwfib->header.SenderData,fib);
+			return 0;
+		}
+
+		list_del(&fib->queue);
+		dev->queues->queue[AdapNormCmdQueue].numpending--;
+
+		if (fast) {
+			/*
+			 *	Doctor the fib
+			 */
+			*(__le32 *)hwfib->data = cpu_to_le32(ST_OK);
+			hwfib->header.XferState |= cpu_to_le32(AdapterProcessed);
+		}
+
+		FIB_COUNTER_INCREMENT(aac_config.FibRecved);
+
+		if (hwfib->header.Command == cpu_to_le16(NuFileSystem))
+		{
+			u32 *pstatus = (u32 *)hwfib->data;
+			if (*pstatus & cpu_to_le32(0xffff0000))
+				*pstatus = cpu_to_le32(ST_OK);
+		}
+		if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected | Async)) 
+		{
+	        	if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected))
+				FIB_COUNTER_INCREMENT(aac_config.NoResponseRecved);
+			else 
+				FIB_COUNTER_INCREMENT(aac_config.AsyncRecved);
+			/*
+			 *	NOTE:  we cannot touch the fib after this
+			 *	    call, because it may have been deallocated.
+			 */
+			fib->callback(fib->callback_data, fib);
+		} else {
+			unsigned long flagv;
+	  		dprintk((KERN_INFO "event_wait up\n"));
+			spin_lock_irqsave(&fib->event_lock, flagv);
+			fib->done = 1;
+			up(&fib->event_wait);
+			spin_unlock_irqrestore(&fib->event_lock, flagv);
+			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
+		}
+		return 0;
+	}
+}
Index: scsi-rc-aac-1/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/linit.c	2005-10-19 13:03:53.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/linit.c	2005-10-19 13:04:18.000000000 -0700
@@ -788,8 +788,29 @@
 		goto out_free_host;
 	spin_lock_init(&aac->fib_lock);
 
-	if ((*aac_drivers[index].init)(aac))
+	/*
+	 *	Map in the registers from the adapter.
+	 */
+	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
+	if ((aac->regs.sa = ioremap(
+	  (unsigned long)aac->scsi_host_ptr->base, AAC_MIN_FOOTPRINT_SIZE))
+	  == NULL) {	
+		printk(KERN_WARNING "%s: unable to map adapter.\n",
+		  AAC_DRIVERNAME);
 		goto out_free_fibs;
+	}
+	if ((*aac_drivers[index].init)(aac))
+		goto out_unmap;
+
+	/*
+	 *	Start any kernel threads needed
+	 */
+	aac->thread_pid = kernel_thread((int (*)(void *))aac_command_thread,
+	  aac, 0);
+	if (aac->thread_pid < 0) {
+		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
+		goto out_deinit;
+	}
 
 	/*
 	 * If we had set a smaller DMA mask earlier, set it to 4gig
@@ -866,10 +887,11 @@
 
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
+	free_irq(pdev->irq, aac);
+ out_unmap:
 	fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
-	free_irq(pdev->irq, aac);
 	iounmap(aac->regs.sa);
  out_free_fibs:
 	kfree(aac->fibs);
@@ -910,6 +932,7 @@
 	iounmap(aac->regs.sa);
 	
 	kfree(aac->fibs);
+	kfree(aac->fsa_dev);
 	
 	list_del(&aac->entry);
 	scsi_host_put(shost);
Index: scsi-rc-aac-1/drivers/scsi/aacraid/rkt.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/rkt.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/rkt.c	2005-10-19 13:04:18.000000000 -0700
@@ -49,40 +49,57 @@
 static irqreturn_t aac_rkt_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct aac_dev *dev = dev_id;
-	unsigned long bellbits;
-	u8 intstat, mask;
-	intstat = rkt_readb(dev, MUnit.OISR);
-	/*
-	 *	Read mask and invert because drawbridge is reversed.
-	 *	This allows us to only service interrupts that have 
-	 *	been enabled.
-	 */
-	mask = ~(dev->OIMR);
-	/* Check to see if this is our interrupt.  If it isn't just return */
-	if (intstat & mask) 
-	{
-		bellbits = rkt_readl(dev, OutboundDoorbellReg);
-		if (bellbits & DoorBellPrintfReady) {
-			aac_printf(dev, rkt_readl(dev, IndexRegs.Mailbox[5]));
-			rkt_writel(dev, MUnit.ODR,DoorBellPrintfReady);
-			rkt_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
-		}
-		else if (bellbits & DoorBellAdapterNormCmdReady) {
-			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
-			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
-		}
-		else if (bellbits & DoorBellAdapterNormRespReady) {
-			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
-			rkt_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
-		}
-		else if (bellbits & DoorBellAdapterNormCmdNotFull) {
-			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+
+	if (dev->new_comm_interface) {
+		u32 Index = rkt_readl(dev, MUnit.OutboundQueue);
+		if (Index == 0xFFFFFFFFL)
+			Index = rkt_readl(dev, MUnit.OutboundQueue);
+		if (Index != 0xFFFFFFFFL) {
+			do {
+				if (aac_intr_normal(dev, Index)) {
+					rkt_writel(dev, MUnit.OutboundQueue, Index);
+					rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespReady);
+				}
+				Index = rkt_readl(dev, MUnit.OutboundQueue);
+			} while (Index != 0xFFFFFFFFL);
+			return IRQ_HANDLED;
 		}
-		else if (bellbits & DoorBellAdapterNormRespNotFull) {
-			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
-			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+	} else {
+		unsigned long bellbits;
+		u8 intstat;
+		intstat = rkt_readb(dev, MUnit.OISR);
+		/*
+		 *	Read mask and invert because drawbridge is reversed.
+		 *	This allows us to only service interrupts that have 
+		 *	been enabled.
+		 *	Check to see if this is our interrupt.  If it isn't just return
+		 */
+		if (intstat & ~(dev->OIMR))
+		{
+			bellbits = rkt_readl(dev, OutboundDoorbellReg);
+			if (bellbits & DoorBellPrintfReady) {
+				aac_printf(dev, rkt_readl (dev, IndexRegs.Mailbox[5]));
+				rkt_writel(dev, MUnit.ODR,DoorBellPrintfReady);
+				rkt_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
+			}
+			else if (bellbits & DoorBellAdapterNormCmdReady) {
+				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
+				aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
+//				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
+			}
+			else if (bellbits & DoorBellAdapterNormRespReady) {
+				rkt_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
+				aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
+			}
+			else if (bellbits & DoorBellAdapterNormCmdNotFull) {
+				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+			}
+			else if (bellbits & DoorBellAdapterNormRespNotFull) {
+				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+				rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+			}
+			return IRQ_HANDLED;
 		}
-		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
 }
@@ -173,7 +190,10 @@
 		/*
 		 *	Restore interrupt mask even though we timed out
 		 */
-		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+		if (dev->new_comm_interface)
+			rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+		else
+			rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 		return -ETIMEDOUT;
 	}
 	/*
@@ -196,7 +216,10 @@
 	/*
 	 *	Restore interrupt mask
 	 */
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+	if (dev->new_comm_interface)
+		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+	else
+		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 	return 0;
 
 }
@@ -268,15 +291,6 @@
 
 	init = dev->init;
 	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
-	/*
-	 *	First clear out all interrupts.  Then enable the one's that we
-	 *	can handle.
-	 */
-	rkt_writeb(dev, MUnit.OIMR, 0xff);
-	rkt_writel(dev, MUnit.ODR, 0xffffffff);
-//	rkt_writeb(dev, MUnit.OIMR, ~(u8)OUTBOUND_DOORBELL_INTERRUPT_MASK);
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
-
 	// We can only use a 32 bit address here
 	rkt_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
 	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
@@ -350,6 +364,39 @@
 }
 
 /**
+ *	aac_rkt_send
+ *	@fib: fib to issue
+ *
+ *	Will send a fib, returning 0 if successful.
+ */
+static int aac_rkt_send(struct fib * fib)
+{
+	u64 addr = fib->hw_fib_pa;
+	struct aac_dev *dev = fib->dev;
+	volatile void __iomem *device = dev->regs.rkt;
+	u32 Index;
+
+	dprintk((KERN_DEBUG "%p->aac_rkt_send(%p->%llx)\n", dev, fib, addr));
+	Index = rkt_readl(dev, MUnit.InboundQueue);
+	if (Index == 0xFFFFFFFFL)
+		Index = rkt_readl(dev, MUnit.InboundQueue);
+	dprintk((KERN_DEBUG "Index = 0x%x\n", Index));
+	if (Index == 0xFFFFFFFFL)
+		return Index;
+	device += Index;
+	dprintk((KERN_DEBUG "entry = %x %x %u\n", (u32)(addr & 0xffffffff),
+	  (u32)(addr >> 32), (u32)le16_to_cpu(fib->hw_fib->header.Size)));
+	writel((u32)(addr & 0xffffffff), device);
+	device += sizeof(u32);
+	writel((u32)(addr >> 32), device);
+	device += sizeof(u32);
+	writel(le16_to_cpu(fib->hw_fib->header.Size), device);
+	rkt_writel(dev, MUnit.InboundQueue, Index);
+	dprintk((KERN_DEBUG "aac_rkt_send - return 0\n"));
+	return 0;
+}
+
+/**
  *	aac_rkt_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *
@@ -369,13 +416,8 @@
 	name     = dev->name;
 
 	/*
-	 *	Map in the registers from the adapter.
+	 *	Check to see if the board panic'd while booting.
 	 */
-	if((dev->regs.rkt = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
-	{	
-		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
-		goto error_iounmap;
-	}
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
@@ -426,6 +468,7 @@
 	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rkt_check_health;
+	dev->a_ops.adapter_send = aac_rkt_send;
 
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
@@ -437,15 +480,24 @@
 
 	if (aac_init_adapter(dev) == NULL)
 		goto error_irq;
-	/*
-	 *	Start any kernel threads needed
-	 */
-	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
-	if(dev->thread_pid < 0)
-	{
-		printk(KERN_ERR "aacraid: Unable to create rkt thread.\n");
-		goto error_kfree;
-	}	
+	if (dev->new_comm_interface) {
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
+		if (dev->scsi_host_ptr->can_queue > (246 - AAC_NUM_MGT_FIB)) {
+			dev->init->MaxIoCommands = cpu_to_le32(246);
+			dev->scsi_host_ptr->can_queue = 246 - AAC_NUM_MGT_FIB;
+		}
+		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+	}
 	/*
 	 *	Tell the adapter that all is configured, and it can start
 	 *	accepting requests
@@ -453,15 +505,11 @@
 	aac_rkt_start_adapter(dev);
 	return 0;
 
-error_kfree:
-	kfree(dev->queues);
-
 error_irq:
 	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:
-	iounmap(dev->regs.rkt);
 
 	return -1;
 }
Index: scsi-rc-aac-1/drivers/scsi/aacraid/rx.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/rx.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/rx.c	2005-10-19 13:04:18.000000000 -0700
@@ -49,40 +49,57 @@
 static irqreturn_t aac_rx_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct aac_dev *dev = dev_id;
-	unsigned long bellbits;
-	u8 intstat, mask;
-	intstat = rx_readb(dev, MUnit.OISR);
-	/*
-	 *	Read mask and invert because drawbridge is reversed.
-	 *	This allows us to only service interrupts that have 
-	 *	been enabled.
-	 */
-	mask = ~(dev->OIMR);
-	/* Check to see if this is our interrupt.  If it isn't just return */
-	if (intstat & mask) 
-	{
-		bellbits = rx_readl(dev, OutboundDoorbellReg);
-		if (bellbits & DoorBellPrintfReady) {
-			aac_printf(dev, rx_readl(dev, IndexRegs.Mailbox[5]));
-			rx_writel(dev, MUnit.ODR,DoorBellPrintfReady);
-			rx_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
-		}
-		else if (bellbits & DoorBellAdapterNormCmdReady) {
-			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
-			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
-		}
-		else if (bellbits & DoorBellAdapterNormRespReady) {
-			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
-			rx_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
-		}
-		else if (bellbits & DoorBellAdapterNormCmdNotFull) {
-			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+
+	dprintk((KERN_DEBUG "aac_rx_intr(%d,%p,%p)\n", irq, dev_id, regs));
+	if (dev->new_comm_interface) {
+		u32 Index = rx_readl(dev, MUnit.OutboundQueue);
+		if (Index == 0xFFFFFFFFL)
+			Index = rx_readl(dev, MUnit.OutboundQueue);
+		if (Index != 0xFFFFFFFFL) {
+			do {
+				if (aac_intr_normal(dev, Index)) {
+					rx_writel(dev, MUnit.OutboundQueue, Index);
+					rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespReady);
+				}
+				Index = rx_readl(dev, MUnit.OutboundQueue);
+			} while (Index != 0xFFFFFFFFL);
+			return IRQ_HANDLED;
 		}
-		else if (bellbits & DoorBellAdapterNormRespNotFull) {
-			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
-			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+	} else {
+		unsigned long bellbits;
+		u8 intstat;
+		intstat = rx_readb(dev, MUnit.OISR);
+		/*
+		 *	Read mask and invert because drawbridge is reversed.
+		 *	This allows us to only service interrupts that have 
+		 *	been enabled.
+		 *	Check to see if this is our interrupt.  If it isn't just return
+		 */
+		if (intstat & ~(dev->OIMR)) 
+		{
+			bellbits = rx_readl(dev, OutboundDoorbellReg);
+			if (bellbits & DoorBellPrintfReady) {
+				aac_printf(dev, rx_readl (dev, IndexRegs.Mailbox[5]));
+				rx_writel(dev, MUnit.ODR,DoorBellPrintfReady);
+				rx_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
+			}
+			else if (bellbits & DoorBellAdapterNormCmdReady) {
+				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
+				aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
+			}
+			else if (bellbits & DoorBellAdapterNormRespReady) {
+				rx_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
+				aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
+			}
+			else if (bellbits & DoorBellAdapterNormCmdNotFull) {
+				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+			}
+			else if (bellbits & DoorBellAdapterNormRespNotFull) {
+				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+			}
+			return IRQ_HANDLED;
 		}
-		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
 }
@@ -173,7 +190,10 @@
 		/*
 		 *	Restore interrupt mask even though we timed out
 		 */
-		rx_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
+		if (dev->new_comm_interface)
+			rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+		else
+			rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 		return -ETIMEDOUT;
 	}
 	/*
@@ -196,7 +216,10 @@
 	/*
 	 *	Restore interrupt mask
 	 */
-	rx_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
+	if (dev->new_comm_interface)
+		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+	else
+		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 	return 0;
 
 }
@@ -267,15 +290,6 @@
 
 	init = dev->init;
 	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
-	/*
-	 *	First clear out all interrupts.  Then enable the one's that we
-	 *	can handle.
-	 */
-	rx_writeb(dev, MUnit.OIMR, 0xff);
-	rx_writel(dev, MUnit.ODR, 0xffffffff);
-//	rx_writeb(dev, MUnit.OIMR, ~(u8)OUTBOUND_DOORBELL_INTERRUPT_MASK);
-	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
-
 	// We can only use a 32 bit address here
 	rx_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
 	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
@@ -349,6 +363,39 @@
 }
 
 /**
+ *	aac_rx_send
+ *	@fib: fib to issue
+ *
+ *	Will send a fib, returning 0 if successful.
+ */
+static int aac_rx_send(struct fib * fib)
+{
+	u64 addr = fib->hw_fib_pa;
+	struct aac_dev *dev = fib->dev;
+	volatile void __iomem *device = dev->regs.rx;
+	u32 Index;
+
+	dprintk((KERN_DEBUG "%p->aac_rx_send(%p->%llx)\n", dev, fib, addr));
+	Index = rx_readl(dev, MUnit.InboundQueue);
+	if (Index == 0xFFFFFFFFL)
+		Index = rx_readl(dev, MUnit.InboundQueue);
+	dprintk((KERN_DEBUG "Index = 0x%x\n", Index));
+	if (Index == 0xFFFFFFFFL)
+		return Index;
+	device += Index;
+	dprintk((KERN_DEBUG "entry = %x %x %u\n", (u32)(addr & 0xffffffff),
+	  (u32)(addr >> 32), (u32)le16_to_cpu(fib->hw_fib->header.Size)));
+	writel((u32)(addr & 0xffffffff), device);
+	device += sizeof(u32);
+	writel((u32)(addr >> 32), device);
+	device += sizeof(u32);
+	writel(le16_to_cpu(fib->hw_fib->header.Size), device);
+	rx_writel(dev, MUnit.InboundQueue, Index);
+	dprintk((KERN_DEBUG "aac_rx_send - return 0\n"));
+	return 0;
+}
+
+/**
  *	aac_rx_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *
@@ -368,13 +415,8 @@
 	name     = dev->name;
 
 	/*
-	 *	Map in the registers from the adapter.
+	 *	Check to see if the board panic'd while booting.
 	 */
-	if((dev->regs.rx = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
-	{	
-		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
-		return -1;
-	}
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
@@ -426,6 +468,7 @@
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
+	dev->a_ops.adapter_send = aac_rx_send;
 
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
@@ -437,15 +480,9 @@
 
 	if (aac_init_adapter(dev) == NULL)
 		goto error_irq;
-	/*
-	 *	Start any kernel threads needed
-	 */
-	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
-	if(dev->thread_pid < 0)
-	{
-		printk(KERN_ERR "aacraid: Unable to create rx thread.\n");
-		goto error_kfree;
-	}
+	if (dev->new_comm_interface)
+		rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xf7);
+
 	/*
 	 *	Tell the adapter that all is configured, and it can start
 	 *	accepting requests
@@ -453,15 +490,11 @@
 	aac_rx_start_adapter(dev);
 	return 0;
 
-error_kfree:
-	kfree(dev->queues);
-
 error_irq:
 	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:
-	iounmap(dev->regs.rx);
 
 	return -1;
 }
Index: scsi-rc-aac-1/drivers/scsi/aacraid/sa.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/sa.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/sa.c	2005-10-19 13:04:18.000000000 -0700
@@ -237,29 +237,16 @@
 
 static void aac_sa_start_adapter(struct aac_dev *dev)
 {
-	u32 ret;
 	struct aac_init *init;
 	/*
 	 * Fill in the remaining pieces of the init.
 	 */
 	init = dev->init;
 	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
-
-	/*
-	 * Tell the adapter we are back and up and running so it will scan its command
-	 * queues and enable our interrupts
-	 */
-	dev->irq_mask =	(PrintfReady | DOORBELL_1 | DOORBELL_2 | DOORBELL_3 | DOORBELL_4);
-	/*
-	 *	First clear out all interrupts.  Then enable the one's that 
-	 *	we can handle.
-	 */
-	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
-	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
 	/* We can only use a 32 bit address here */
 	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, 
 			(u32)(ulong)dev->init_pa, 0, 0, 0, 0, 0,
-			&ret, NULL, NULL, NULL, NULL);
+			NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -314,15 +301,6 @@
 	name     = dev->name;
 
 	/*
-	 *	Map in the registers from the adapter.
-	 */
-
-	if((dev->regs.sa = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
-	{	
-		printk(KERN_WARNING "aacraid: unable to map ARM.\n" );
-		goto error_iounmap;
-	}
-	/*
 	 *	Check to see if the board failed any self tests.
 	 */
 	if (sa_readl(dev, Mailbox7) & SELF_TEST_FAILED) {
@@ -378,31 +356,17 @@
 		goto error_irq;
 
 	/*
-	 *	Start any kernel threads needed
-	 */
-	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
-	if (dev->thread_pid < 0) {
-		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
-		goto error_kfree;
-	}
-
-	/*
 	 *	Tell the adapter that all is configure, and it can start 
 	 *	accepting requests
 	 */
 	aac_sa_start_adapter(dev);
 	return 0;
 
-
-error_kfree:
-	kfree(dev->queues);
-
 error_irq:
 	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:
-	iounmap(dev->regs.sa);
 
 	return -1;
 }

-- 
Mark Haverkamp <markh@osdl.org>

