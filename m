From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 2/7] aacraid: Fix struct element name issue
Date: Thu, 15 Mar 2007 10:26:22 -0700
Message-ID: <1173979582.30374.22.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60751 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXCOR00 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:26:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

This patch is to resolve a namespace issue that will result from a patch
expected in the future that adds a new interface; rationalized as
correcting a long term issue where hw_fib, instead of hw_fib_va, refers
to the virtual address space and hw_fib_pa refers to the physical
address space. A small fragment of this patch also cleans up an unused
variable that was close to the patch fragments.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>

---


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2007-03-15 08:30:07.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2007-03-15 08:30:12.000000000 -0700
@@ -834,7 +834,7 @@ struct fib {
 	 */
 	struct list_head	fiblink;
 	void 			*data;
-	struct hw_fib		*hw_fib;		/* Actual shared object */
+	struct hw_fib		*hw_fib_va;		/* Actual shared object */
 	dma_addr_t		hw_fib_pa;		/* physical address of hw_fib*/
 };
 
@@ -1821,7 +1821,7 @@ int aac_fib_send(u16 command, struct fib
 int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entry **entry);
 void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
 int aac_fib_complete(struct fib * context);
-#define fib_data(fibctx) ((void *)(fibctx)->hw_fib->data)
+#define fib_data(fibctx) ((void *)(fibctx)->hw_fib_va->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
 int aac_get_config_status(struct aac_dev *dev, int commit_flag);
 int aac_get_containers(struct aac_dev *dev);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2007-03-15 08:28:04.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2007-03-15 08:30:12.000000000 -0700
@@ -69,7 +69,7 @@ static int ioctl_send_fib(struct aac_dev
 		return -ENOMEM;
 	}
 		
-	kfib = fibptr->hw_fib;
+	kfib = fibptr->hw_fib_va;
 	/*
 	 *	First copy in the header so that we can check the size field.
 	 */
@@ -91,9 +91,9 @@ static int ioctl_send_fib(struct aac_dev
 			goto cleanup;
 		}
 		/* Highjack the hw_fib */
-		hw_fib = fibptr->hw_fib;
+		hw_fib = fibptr->hw_fib_va;
 		hw_fib_pa = fibptr->hw_fib_pa;
-		fibptr->hw_fib = kfib = pci_alloc_consistent(dev->pdev, size, &fibptr->hw_fib_pa);
+		fibptr->hw_fib_va = kfib = pci_alloc_consistent(dev->pdev, size, &fibptr->hw_fib_pa);
 		memset(((char *)kfib) + dev->max_fib_size, 0, size - dev->max_fib_size);
 		memcpy(kfib, hw_fib, dev->max_fib_size);
 	}
@@ -137,7 +137,7 @@ cleanup:
 	if (hw_fib) {
 		pci_free_consistent(dev->pdev, size, kfib, fibptr->hw_fib_pa);
 		fibptr->hw_fib_pa = hw_fib_pa;
-		fibptr->hw_fib = hw_fib;
+		fibptr->hw_fib_va = hw_fib;
 	}
 	if (retval != -EINTR)
 		aac_fib_free(fibptr);
@@ -282,15 +282,15 @@ return_fib:
 		fib = list_entry(entry, struct fib, fiblink);
 		fibctx->count--;
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
-		if (copy_to_user(f.fib, fib->hw_fib, sizeof(struct hw_fib))) {
-			kfree(fib->hw_fib);
+		if (copy_to_user(f.fib, fib->hw_fib_va, sizeof(struct hw_fib))) {
+			kfree(fib->hw_fib_va);
 			kfree(fib);
 			return -EFAULT;
 		}	
 		/*
 		 *	Free the space occupied by this copy of the fib.
 		 */
-		kfree(fib->hw_fib);
+		kfree(fib->hw_fib_va);
 		kfree(fib);
 		status = 0;
 	} else {
@@ -340,7 +340,7 @@ int aac_close_fib_context(struct aac_dev
 		/*
 		 *	Free the space occupied by this copy of the fib.
 		 */
-		kfree(fib->hw_fib);
+		kfree(fib->hw_fib_va);
 		kfree(fib);
 	}
 	/*
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:07.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:12.000000000 -0700
@@ -94,7 +94,7 @@ void aac_fib_map_free(struct aac_dev *de
 int aac_fib_setup(struct aac_dev * dev)
 {
 	struct fib *fibptr;
-	struct hw_fib *hw_fib_va;
+	struct hw_fib *hw_fib;
 	dma_addr_t hw_fib_pa;
 	int i;
 
@@ -106,24 +106,24 @@ int aac_fib_setup(struct aac_dev * dev)
 	if (i<0)
 		return -ENOMEM;
 		
-	hw_fib_va = dev->hw_fib_va;
+	hw_fib = dev->hw_fib_va;
 	hw_fib_pa = dev->hw_fib_pa;
-	memset(hw_fib_va, 0, dev->max_fib_size * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
+	memset(hw_fib, 0, dev->max_fib_size * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
 	/*
 	 *	Initialise the fibs
 	 */
 	for (i = 0, fibptr = &dev->fibs[i]; i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); i++, fibptr++) 
 	{
 		fibptr->dev = dev;
-		fibptr->hw_fib = hw_fib_va;
-		fibptr->data = (void *) fibptr->hw_fib->data;
+		fibptr->hw_fib_va = hw_fib;
+		fibptr->data = (void *) fibptr->hw_fib_va->data;
 		fibptr->next = fibptr+1;	/* Forward chain the fibs */
 		init_MUTEX_LOCKED(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
-		hw_fib_va->header.XferState = cpu_to_le32(0xffffffff);
-		hw_fib_va->header.SenderSize = cpu_to_le16(dev->max_fib_size);
+		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
+		hw_fib->header.SenderSize = cpu_to_le16(dev->max_fib_size);
 		fibptr->hw_fib_pa = hw_fib_pa;
-		hw_fib_va = (struct hw_fib *)((unsigned char *)hw_fib_va + dev->max_fib_size);
+		hw_fib = (struct hw_fib *)((unsigned char *)hw_fib + dev->max_fib_size);
 		hw_fib_pa = hw_fib_pa + dev->max_fib_size;
 	}
 	/*
@@ -166,7 +166,7 @@ struct fib *aac_fib_alloc(struct aac_dev
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
 	 */
-	fibptr->hw_fib->header.XferState = 0;
+	fibptr->hw_fib_va->header.XferState = 0;
 	fibptr->callback = NULL;
 	fibptr->callback_data = NULL;
 
@@ -191,10 +191,10 @@ void aac_fib_free(struct fib *fibptr)
 		fibptr->next = fibptr->dev->timeout_fib;
 		fibptr->dev->timeout_fib = fibptr;
 	} else {
-		if (fibptr->hw_fib->header.XferState != 0) {
+		if (fibptr->hw_fib_va->header.XferState != 0) {
 			printk(KERN_WARNING "aac_fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n",
 				 (void*)fibptr, 
-				 le32_to_cpu(fibptr->hw_fib->header.XferState));
+				 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
 		}
 		fibptr->next = fibptr->dev->free_fib;
 		fibptr->dev->free_fib = fibptr;
@@ -211,7 +211,7 @@ void aac_fib_free(struct fib *fibptr)
  
 void aac_fib_init(struct fib *fibptr)
 {
-	struct hw_fib *hw_fib = fibptr->hw_fib;
+	struct hw_fib *hw_fib = fibptr->hw_fib_va;
 
 	hw_fib->header.StructType = FIB_MAGIC;
 	hw_fib->header.Size = cpu_to_le16(fibptr->dev->max_fib_size);
@@ -231,7 +231,7 @@ void aac_fib_init(struct fib *fibptr)
  
 static void fib_dealloc(struct fib * fibptr)
 {
-	struct hw_fib *hw_fib = fibptr->hw_fib;
+	struct hw_fib *hw_fib = fibptr->hw_fib_va;
 	BUG_ON(hw_fib->header.StructType != FIB_MAGIC);
 	hw_fib->header.XferState = 0;        
 }
@@ -386,7 +386,7 @@ int aac_fib_send(u16 command, struct fib
 		void *callback_data)
 {
 	struct aac_dev * dev = fibptr->dev;
-	struct hw_fib * hw_fib = fibptr->hw_fib;
+	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 	unsigned long flags = 0;
 	unsigned long qflags;
 
@@ -430,7 +430,7 @@ int aac_fib_send(u16 command, struct fib
 	 */
 	hw_fib->header.Command = cpu_to_le16(command);
 	hw_fib->header.XferState |= cpu_to_le32(SentFromHost);
-	fibptr->hw_fib->header.Flags = 0;	/* 0 the flags field - internal only*/
+	fibptr->hw_fib_va->header.Flags = 0;	/* 0 the flags field - internal only*/
 	/*
 	 *	Set the size of the Fib we want to send to the adapter
 	 */
@@ -462,7 +462,7 @@ int aac_fib_send(u16 command, struct fib
 	dprintk((KERN_DEBUG "  Command =               %d.\n", le32_to_cpu(hw_fib->header.Command)));
 	dprintk((KERN_DEBUG "  SubCommand =            %d.\n", le32_to_cpu(((struct aac_query_mount *)fib_data(fibptr))->command)));
 	dprintk((KERN_DEBUG "  XferState  =            %x.\n", le32_to_cpu(hw_fib->header.XferState)));
-	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib));
+	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib_va));
 	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
 	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
 
@@ -624,7 +624,7 @@ void aac_consumer_free(struct aac_dev * 
 
 int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 {
-	struct hw_fib * hw_fib = fibptr->hw_fib;
+	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 	struct aac_dev * dev = fibptr->dev;
 	struct aac_queue * q;
 	unsigned long nointr = 0;
@@ -688,7 +688,7 @@ int aac_fib_adapter_complete(struct fib 
  
 int aac_fib_complete(struct fib *fibptr)
 {
-	struct hw_fib * hw_fib = fibptr->hw_fib;
+	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 
 	/*
 	 *	Check for a fib which has already been completed
@@ -774,9 +774,8 @@ void aac_printf(struct aac_dev *dev, u32
 #define AIF_SNIFF_TIMEOUT	(30*HZ)
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
-	struct hw_fib * hw_fib = fibptr->hw_fib;
+	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 	struct aac_aifcmd * aifcmd = (struct aac_aifcmd *)hw_fib->data;
-	int busy;
 	u32 container;
 	struct scsi_device *device;
 	enum {
@@ -988,9 +987,6 @@ static void aac_handle_aif(struct aac_de
 	 * behind you.
 	 */
 
-	busy = 0;
-
-
 	/*
 	 *	Find the scsi_device associated with the SCSI address,
 	 * and mark it as changed, invalidating the cache. This deals
@@ -1068,8 +1064,8 @@ static int _aac_reset_adapter(struct aac
 	 */
 	for (index = 0; index < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); index++) {
 		struct fib *fib = &aac->fibs[index];
-		if (!(fib->hw_fib->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
-		  (fib->hw_fib->header.XferState & cpu_to_le32(ResponseExpected))) {
+		if (!(fib->hw_fib_va->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
+		  (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected))) {
 			unsigned long flagv;
 			spin_lock_irqsave(&fib->event_lock, flagv);
 			up(&fib->event_wait);
@@ -1237,7 +1233,7 @@ int aac_check_health(struct aac_dev * aa
 
 			memset(hw_fib, 0, sizeof(struct hw_fib));
 			memset(fib, 0, sizeof(struct fib));
-			fib->hw_fib = hw_fib;
+			fib->hw_fib_va = hw_fib;
 			fib->dev = aac;
 			aac_fib_init(fib);
 			fib->type = FSAFS_NTC_FIB_CONTEXT;
@@ -1343,11 +1339,11 @@ int aac_command_thread(void *data)
 			 *	do anything at this point since we don't have
 			 *	anything defined for this thread to do.
 			 */
-			hw_fib = fib->hw_fib;
+			hw_fib = fib->hw_fib_va;
 			memset(fib, 0, sizeof(struct fib));
 			fib->type = FSAFS_NTC_FIB_CONTEXT;
 			fib->size = sizeof( struct fib );
-			fib->hw_fib = hw_fib;
+			fib->hw_fib_va = hw_fib;
 			fib->data = hw_fib->data;
 			fib->dev = dev;
 			/*
@@ -1474,7 +1470,7 @@ int aac_command_thread(void *data)
 						 */
 						memcpy(hw_newfib, hw_fib, sizeof(struct hw_fib));
 						memcpy(newfib, fib, sizeof(struct fib));
-						newfib->hw_fib = hw_newfib;
+						newfib->hw_fib_va = hw_newfib;
 						/*
 						 * Put the FIB onto the
 						 * fibctx's fibs
--- scsi-misc-aac.orig/drivers/scsi/aacraid/dpcsup.c	2007-03-15 08:28:04.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/dpcsup.c	2007-03-15 08:30:12.000000000 -0700
@@ -73,7 +73,7 @@ unsigned int aac_response_normal(struct 
 		u32 index = le32_to_cpu(entry->addr);
 		fast = index & 0x01;
 		fib = &dev->fibs[index >> 2];
-		hwfib = fib->hw_fib;
+		hwfib = fib->hw_fib_va;
 		
 		aac_consumer_free(dev, q, HostNormRespQueue);
 		/*
@@ -193,7 +193,7 @@ unsigned int aac_command_normal(struct a
 		INIT_LIST_HEAD(&fib->fiblink);
 		fib->type = FSAFS_NTC_FIB_CONTEXT;
 		fib->size = sizeof(struct fib);
-		fib->hw_fib = hw_fib;
+		fib->hw_fib_va = hw_fib;
 		fib->data = hw_fib->data;
 		fib->dev = dev;
 		
@@ -259,7 +259,7 @@ unsigned int aac_intr_normal(struct aac_
 		INIT_LIST_HEAD(&fib->fiblink);
 		fib->type = FSAFS_NTC_FIB_CONTEXT;
 		fib->size = sizeof(struct fib);
-		fib->hw_fib = hw_fib;
+		fib->hw_fib_va = hw_fib;
 		fib->data = hw_fib->data;
 		fib->dev = dev;
 	
@@ -271,7 +271,7 @@ unsigned int aac_intr_normal(struct aac_
 	} else {
 		int fast = index & 0x01;
 		struct fib * fib = &dev->fibs[index >> 2];
-		struct hw_fib * hwfib = fib->hw_fib;
+		struct hw_fib * hwfib = fib->hw_fib_va;
 
 		/*
 		 *	Remove this fib from the Outstanding I/O queue.
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2007-03-15 08:30:07.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2007-03-15 08:30:12.000000000 -0700
@@ -387,7 +387,7 @@ static int aac_rx_deliver_producer(struc
 	unsigned long nointr = 0;
 
 	spin_lock_irqsave(q->lock, qflags);
-	aac_queue_get( dev, &Index, AdapNormCmdQueue, fib->hw_fib, 1, fib, &nointr);
+	aac_queue_get( dev, &Index, AdapNormCmdQueue, fib->hw_fib_va, 1, fib, &nointr);
 
 	q->numpending++;
 	*(q->headers.producer) = cpu_to_le32(Index + 1);
@@ -437,7 +437,7 @@ static int aac_rx_deliver_message(struct
 	device += sizeof(u32);
 	writel((u32)(addr >> 32), device);
 	device += sizeof(u32);
-	writel(le16_to_cpu(fib->hw_fib->header.Size), device);
+	writel(le16_to_cpu(fib->hw_fib_va->header.Size), device);
 	rx_writel(dev, MUnit.InboundQueue, Index);
 	return 0;
 }

-- 
Mark Haverkamp <markh@linux-foundation.org>

