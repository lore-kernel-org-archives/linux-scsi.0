From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 8/8] aacraid: remove aac_insert_entry
Date: Thu, 08 Sep 2005 13:50:39 -0700
Message-ID: <1126212639.7479.26.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58541 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751396AbVIHUxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 16:53:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec.

High Priority Queues have *never* been used in the entire history of the
aac based adapters. Associated with this, aac_insert_entry can be
removed, SavedIrql can be removed & padding variable can be removed.
With the movement of SavedIrql out & replaced with an automatic variable
qflags, the locking can be refined somewhat. The sparse warnings did not
catch the need for byte swapping in the 'dprintk' debugging print
macros, so fixed this up when this code was moved outside of the now
refined locking.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



Index: scsi-misc-aac-2/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aacraid.h	2005-09-08 11:32:23.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aacraid.h	2005-09-08 11:32:45.000000000 -0700
@@ -306,7 +306,6 @@
  */
 
 #define		FsaNormal	1
-#define		FsaHigh		2
 
 /*
  * Define the FIB. The FIB is the where all the requested data and
@@ -550,8 +549,6 @@
                   /* This is only valid for adapter to host command queues. */ 
 	spinlock_t	 	*lock;		/* Spinlock for this queue must take this lock before accessing the lock */
 	spinlock_t		lockdata;	/* Actual lock (used only on one side of the lock) */
-	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */
-	u32			padding;	/* Padding - FIXME - can remove I believe */
 	struct list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
                                 		/* only valid for command queues which receive entries from the adapter. */
 	struct list_head	pendingq;	/* A queue of outstanding fib's to the adapter. */
Index: scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:36.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:45.000000000 -0700
@@ -271,40 +271,22 @@
 	/* Interrupt Moderation, only interrupt for first two entries */
 	if (idx != le32_to_cpu(*(q->headers.consumer))) {
 		if (--idx == 0) {
-			if (qid == AdapHighCmdQueue)
-				idx = ADAP_HIGH_CMD_ENTRIES;
-			else if (qid == AdapNormCmdQueue)
+			if (qid == AdapNormCmdQueue)
 				idx = ADAP_NORM_CMD_ENTRIES;
-			else if (qid == AdapHighRespQueue) 
-	        		idx = ADAP_HIGH_RESP_ENTRIES;
-			else if (qid == AdapNormRespQueue) 
+			else
 				idx = ADAP_NORM_RESP_ENTRIES;
 		}
 		if (idx != le32_to_cpu(*(q->headers.consumer)))
 			*nonotify = 1; 
 	}
 
-	if (qid == AdapHighCmdQueue) {
-	        if (*index >= ADAP_HIGH_CMD_ENTRIES)
-        		*index = 0;
-	} else if (qid == AdapNormCmdQueue) {
+	if (qid == AdapNormCmdQueue) {
 	        if (*index >= ADAP_NORM_CMD_ENTRIES) 
 			*index = 0; /* Wrap to front of the Producer Queue. */
-	}
-	else if (qid == AdapHighRespQueue) 
-	{
-	        if (*index >= ADAP_HIGH_RESP_ENTRIES)
-			*index = 0;
-	}
-	else if (qid == AdapNormRespQueue) 
-	{
+	} else {
 		if (*index >= ADAP_NORM_RESP_ENTRIES) 
 			*index = 0; /* Wrap to front of the Producer Queue. */
 	}
-	else {
-		printk("aacraid: invalid qid\n");
-		BUG();
-	}
 
         if ((*index + 1) == le32_to_cpu(*(q->headers.consumer))) { /* Queue is full */
 		printk(KERN_WARNING "Queue %d full, %u outstanding.\n",
@@ -336,12 +318,8 @@
 {
 	struct aac_entry * entry = NULL;
 	int map = 0;
-	struct aac_queue * q = &dev->queues->queue[qid];
-		
-	spin_lock_irqsave(q->lock, q->SavedIrql);
 	    
-	if (qid == AdapHighCmdQueue || qid == AdapNormCmdQueue) 
-	{
+	if (qid == AdapNormCmdQueue) {
 		/*  if no entries wait for some if caller wants to */
         	while (!aac_get_entry(dev, qid, &entry, index, nonotify)) 
         	{
@@ -352,9 +330,7 @@
 	         */
 	        entry->size = cpu_to_le32(le16_to_cpu(hw_fib->header.Size));
 	        map = 1;
-	}
-	else if (qid == AdapHighRespQueue || qid == AdapNormRespQueue)
-	{
+	} else {
 	        while(!aac_get_entry(dev, qid, &entry, index, nonotify)) 
 	        {
 			/* if no entries wait for some if caller wants to */
@@ -377,42 +353,6 @@
 	return 0;
 }
 
-
-/**
- *	aac_insert_entry	-	insert a queue entry
- *	@dev: Adapter
- *	@index: Index of entry to insert
- *	@qid: Queue number
- *	@nonotify: Suppress adapter notification
- *
- *	Gets the next free QE off the requested priorty adapter command
- *	queue and associates the Fib with the QE. The QE represented by
- *	index is ready to insert on the queue when this routine returns
- *	success.
- */
- 
-static int aac_insert_entry(struct aac_dev * dev, u32 index, u32 qid, unsigned long nonotify) 
-{
-	struct aac_queue * q = &dev->queues->queue[qid];
-
-	if(q == NULL)
-		BUG();
-	*(q->headers.producer) = cpu_to_le32(index + 1);
-	spin_unlock_irqrestore(q->lock, q->SavedIrql);
-
-	if (qid == AdapHighCmdQueue ||
-	    qid == AdapNormCmdQueue ||
-	    qid == AdapHighRespQueue ||
-	    qid == AdapNormRespQueue)
-	{
-		if (!nonotify)
-			aac_adapter_notify(dev, qid);
-	}
-	else
-		printk("Suprise insert!\n");
-	return 0;
-}
-
 /*
  *	Define the highest level of host to adapter communication routines. 
  *	These routines will support host to adapter FS commuication. These 
@@ -441,12 +381,13 @@
 int fib_send(u16 command, struct fib * fibptr, unsigned long size,  int priority, int wait, int reply, fib_callback callback, void * callback_data)
 {
 	u32 index;
-	u32 qid;
 	struct aac_dev * dev = fibptr->dev;
 	unsigned long nointr = 0;
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_queue * q;
 	unsigned long flags = 0;
+	unsigned long qflags;
+
 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
 		return -EBUSY;
 	/*
@@ -499,26 +440,8 @@
 	 *	Get a queue entry connect the FIB to it and send an notify
 	 *	the adapter a command is ready.
 	 */
-	if (priority == FsaHigh) {
-		hw_fib->header.XferState |= cpu_to_le32(HighPriority);
-		qid = AdapHighCmdQueue;
-	} else {
-		hw_fib->header.XferState |= cpu_to_le32(NormalPriority);
-		qid = AdapNormCmdQueue;
-	}
-	q = &dev->queues->queue[qid];
+	hw_fib->header.XferState |= cpu_to_le32(NormalPriority);
 
-	if(wait)
-		spin_lock_irqsave(&fibptr->event_lock, flags);
-	if(aac_queue_get( dev, &index, qid, hw_fib, 1, fibptr, &nointr)<0)
-		return -EWOULDBLOCK;
-	dprintk((KERN_DEBUG "fib_send: inserting a queue entry at index %d.\n",index));
-	dprintk((KERN_DEBUG "Fib contents:.\n"));
-	dprintk((KERN_DEBUG "  Command =               %d.\n", hw_fib->header.Command));
-	dprintk((KERN_DEBUG "  XferState  =            %x.\n", hw_fib->header.XferState));
-	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib));
-	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
-	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
 	/*
 	 *	Fill in the Callback and CallbackContext if we are not
 	 *	going to wait.
@@ -527,15 +450,33 @@
 		fibptr->callback = callback;
 		fibptr->callback_data = callback_data;
 	}
-	FIB_COUNTER_INCREMENT(aac_config.FibsSent);
-	list_add_tail(&fibptr->queue, &q->pendingq);
-	q->numpending++;
 
 	fibptr->done = 0;
 	fibptr->flags = 0;
 
-	if(aac_insert_entry(dev, index, qid, (nointr & aac_config.irq_mod)) < 0)
-		return -EWOULDBLOCK;
+	FIB_COUNTER_INCREMENT(aac_config.FibsSent);
+
+	dprintk((KERN_DEBUG "fib_send: inserting a queue entry at index %d.\n",index));
+	dprintk((KERN_DEBUG "Fib contents:.\n"));
+	dprintk((KERN_DEBUG "  Command =               %d.\n", hw_fib->header.Command));
+	dprintk((KERN_DEBUG "  XferState  =            %x.\n", hw_fib->header.XferState));
+	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib));
+	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
+	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
+
+	q = &dev->queues->queue[AdapNormCmdQueue];
+
+	if(wait)
+		spin_lock_irqsave(&fibptr->event_lock, flags);
+	spin_lock_irqsave(q->lock, qflags);
+	aac_queue_get( dev, &index, AdapNormCmdQueue, hw_fib, 1, fibptr, &nointr);
+
+	list_add_tail(&fibptr->queue, &q->pendingq);
+	q->numpending++;
+	*(q->headers.producer) = cpu_to_le32(index + 1);
+	spin_unlock_irqrestore(q->lock, qflags);
+	if (!(nointr & aac_config.irq_mod))
+		aac_adapter_notify(dev, AdapNormCmdQueue);
 	/*
 	 *	If the caller wanted us to wait for response wait now. 
 	 */
@@ -651,15 +592,9 @@
 		case HostNormCmdQueue:
 			notify = HostNormCmdNotFull;
 			break;
-		case HostHighCmdQueue:
-			notify = HostHighCmdNotFull;
-			break;
 		case HostNormRespQueue:
 			notify = HostNormRespNotFull;
 			break;
-		case HostHighRespQueue:
-			notify = HostHighRespNotFull;
-			break;
 		default:
 			BUG();
 			return;
@@ -681,9 +616,13 @@
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_dev * dev = fibptr->dev;
+	struct aac_queue * q;
 	unsigned long nointr = 0;
-	if (hw_fib->header.XferState == 0)
+	unsigned long qflags;
+
+	if (hw_fib->header.XferState == 0) {
         	return 0;
+	}
 	/*
 	 *	If we plan to do anything check the structure type first.
 	 */ 
@@ -698,37 +637,21 @@
 	 *	send the completed cdb to the adapter.
 	 */
 	if (hw_fib->header.XferState & cpu_to_le32(SentFromAdapter)) {
+		u32 index;
 	        hw_fib->header.XferState |= cpu_to_le32(HostProcessed);
-	        if (hw_fib->header.XferState & cpu_to_le32(HighPriority)) {
-        		u32 index;
-       			if (size) 
-			{
-				size += sizeof(struct aac_fibhdr);
-				if (size > le16_to_cpu(hw_fib->header.SenderSize))
-					return -EMSGSIZE;
-				hw_fib->header.Size = cpu_to_le16(size);
-			}
-			if(aac_queue_get(dev, &index, AdapHighRespQueue, hw_fib, 1, NULL, &nointr) < 0) {
-				return -EWOULDBLOCK;
-			}
-			if (aac_insert_entry(dev, index, AdapHighRespQueue,  (nointr & (int)aac_config.irq_mod)) != 0) {
-			}
-		} else if (hw_fib->header.XferState & 
-				cpu_to_le32(NormalPriority)) {
-			u32 index;
-
-			if (size) {
-				size += sizeof(struct aac_fibhdr);
-				if (size > le16_to_cpu(hw_fib->header.SenderSize)) 
-					return -EMSGSIZE;
-				hw_fib->header.Size = cpu_to_le16(size);
-			}
-			if (aac_queue_get(dev, &index, AdapNormRespQueue, hw_fib, 1, NULL, &nointr) < 0) 
-				return -EWOULDBLOCK;
-			if (aac_insert_entry(dev, index, AdapNormRespQueue, (nointr & (int)aac_config.irq_mod)) != 0) 
-			{
-			}
-		}
+		if (size) {
+			size += sizeof(struct aac_fibhdr);
+			if (size > le16_to_cpu(hw_fib->header.SenderSize)) 
+				return -EMSGSIZE;
+			hw_fib->header.Size = cpu_to_le16(size);
+		}
+		q = &dev->queues->queue[AdapNormRespQueue];
+		spin_lock_irqsave(q->lock, qflags);
+		aac_queue_get(dev, &index, AdapNormRespQueue, hw_fib, 1, NULL, &nointr);
+		*(q->headers.producer) = cpu_to_le32(index + 1);
+		spin_unlock_irqrestore(q->lock, qflags);
+		if (!(nointr & (int)aac_config.irq_mod))
+			aac_adapter_notify(dev, AdapNormRespQueue);
 	}
 	else 
 	{

-- 
Mark Haverkamp <markh@osdl.org>

