From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 14:21:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065475276.17021.77.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:5043 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261774AbTJFVVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 17:21:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

===== drivers/scsi/aacraid/commctrl.c 1.3 vs edited =====
--- 1.3/drivers/scsi/aacraid/commctrl.c	Fri May  2 12:30:31 2003
+++ edited/drivers/scsi/aacraid/commctrl.c	Tue Sep 30 09:33:19 2003
@@ -150,7 +150,7 @@
 		 *	the list to 0.
 		 */
 		fibctx->count = 0;
-		AAC_INIT_LIST_HEAD(&fibctx->hw_fib_list);
+		INIT_LIST_HEAD(&fibctx->fib_list);
 		fibctx->jiffies = jiffies/HZ;
 		/*
 		 *	Now add this context onto the adapter's 
@@ -181,7 +181,7 @@
 {
 	struct fib_ioctl f;
 	struct aac_fib_context *fibctx, *aifcp;
-	struct hw_fib * hw_fib;
+	struct fib *fib;
 	int status;
 	struct list_head * entry;
 	int found;
@@ -224,27 +224,28 @@
 	 *	-EAGAIN
 	 */
 return_fib:
-	if (!aac_list_empty(&fibctx->hw_fib_list)) {
-		struct aac_list_head * entry;
+	if (!list_empty(&fibctx->fib_list)) {
+		struct list_head * entry;
 		/*
 		 *	Pull the next fib from the fibs
 		 */
-		entry = (struct aac_list_head*)(ulong)fibctx->hw_fib_list.next;
-		aac_list_del(entry);
+		entry = fibctx->fib_list.next;
+		list_del(entry);
 		
-		hw_fib = aac_list_entry(entry, struct hw_fib, header.FibLinks);
+		fib = list_entry(entry, struct fib, fiblink);
 		fibctx->count--;
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
-		if (copy_to_user(f.fib, hw_fib, sizeof(struct hw_fib))) {
-			kfree(hw_fib);
+		if (copy_to_user(f.fib, fib->hw_fib, sizeof(struct hw_fib))) {
+			kfree(fib->hw_fib);
+			kfree(fib);
 			return -EFAULT;
 		}	
 		/*
 		 *	Free the space occupied by this copy of the fib.
 		 */
-		kfree(hw_fib);
+		kfree(fib->hw_fib);
+		kfree(fib);
 		status = 0;
-		fibctx->jiffies = jiffies/HZ;
 	} else {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
 		if (f.wait) {
@@ -259,29 +260,31 @@
 			status = -EAGAIN;
 		}	
 	}
+	fibctx->jiffies = jiffies/HZ;
 	return status;
 }
 
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context * fibctx)
 {
-	struct hw_fib *hw_fib;
+	struct fib *fib;
 
 	/*
 	 *	First free any FIBs that have not been consumed.
 	 */
-	while (!aac_list_empty(&fibctx->hw_fib_list)) {
-		struct aac_list_head * entry;
+	while (!list_empty(&fibctx->fib_list)) {
+		struct list_head * entry;
 		/*
 		 *	Pull the next fib from the fibs
 		 */
-		entry = (struct aac_list_head*)(ulong)(fibctx->hw_fib_list.next);
-		aac_list_del(entry);
-		hw_fib = aac_list_entry(entry, struct hw_fib, header.FibLinks);
+		entry = fibctx->fib_list.next;
+		list_del(entry);
+		fib = list_entry(entry, struct fib, fiblink);
 		fibctx->count--;
 		/*
 		 *	Free the space occupied by this copy of the fib.
 		 */
-		kfree(hw_fib);
+		kfree(fib->hw_fib);
+		kfree(fib);
 	}
 	/*
 	 *	Remove the Context from the AdapterFibContext List
@@ -355,17 +358,19 @@
  *	@dev: adapter
  *	@arg: ioctl arguments
  *
- *	This routine returns the firmware version.
- *      Under Linux, there have been no version incompatibilities, so this is simple!
+ *	This routine returns the driver version.
+ *      Under Linux, there have been no version incompatibilities, so 
+ *      this is simple!
  */
 
 static int check_revision(struct aac_dev *dev, void *arg)
 {
 	struct revision response;
+	extern unsigned long aac_driver_version;
 
 	response.compat = 1;
-	response.version = dev->adapter_info.kernelrev;
-	response.build = dev->adapter_info.kernelbuild;
+	response.version = aac_driver_version;
+	response.build = AAC_DRIVER_BUILD;
 
 	if (copy_to_user(arg, &response, sizeof(response)))
 		return -EFAULT;
@@ -430,14 +435,14 @@
 	// Fix up srb for endian and force some values
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);	// Force this
 	srbcmd->channel  = cpu_to_le32(srbcmd->channel);
-	srbcmd->target   = cpu_to_le32(srbcmd->target);
+	srbcmd->id       = cpu_to_le32(srbcmd->id);
 	srbcmd->lun      = cpu_to_le32(srbcmd->lun);
 	srbcmd->flags    = cpu_to_le32(srbcmd->flags);
 	srbcmd->timeout  = cpu_to_le32(srbcmd->timeout);
 	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
 	srbcmd->cdb_size = cpu_to_le32(srbcmd->cdb_size);
 	
-	switch(srbcmd->flags){
+	switch(srbcmd->flags & (SRB_DataIn | SRB_DataOut)){
 	case SRB_DataOut:
 		data_dir = SCSI_DATA_WRITE;
 		break;
@@ -455,12 +460,19 @@
 		byte_count = 0;
 
 		// This should also catch if user used the 32 bit sgmap
-		actual_fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry64));
+		actual_fibsize = sizeof (struct aac_srb) - 
+			sizeof(struct sgentry) + ((srbcmd->sg.count & 0xff) * 
+					sizeof (struct sgentry64));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
 			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
 			rcode = -EINVAL;
 			goto cleanup;
 		}
+		if ((data_dir == SCSI_DATA_NONE) && psg->count) { // Dogs and cats sleeping with eachother - should not continue
+			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
+			rcode = -EINVAL;
+			goto cleanup;
+		}
 
 		for (i = 0; i < psg->count; i++) {
 			dma_addr_t addr; 
@@ -475,7 +487,7 @@
 			}
 			sg_user[i] = (ulong)psg->sg[i].addr;
 			sg_list[i] = (ulong)p; // save so we can clean up later
-			sg_indx = i;
+			sg_indx = i + 1;
 
 			if( flags & SRB_DataOut ){
 				if(copy_from_user(p,psg->sg[i].addr,psg->sg[i].count)){
@@ -505,6 +517,11 @@
 			rcode = -EINVAL;
 			goto cleanup;
 		}
+		if ((data_dir == SCSI_DATA_NONE) && psg->count) { // Dogs and cats sleeping with eachother - should not continue
+			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
+			rcode = -EINVAL;
+			goto cleanup;
+		}
 		for (i = 0; i < psg->count; i++) {
 			dma_addr_t addr; 
 			void* p;
@@ -517,7 +534,7 @@
 			}
 			sg_user[i] = (ulong)(psg->sg[i].addr);
 			sg_list[i] = (ulong)p; // save so we can clean up later
-			sg_indx = i;
+			sg_indx = i + 1;
 
 			if( flags & SRB_DataOut ){
 				if(copy_from_user((void*)p,(void*)(ulong)(psg->sg[i].addr),psg->sg[i].count)){
@@ -543,7 +560,7 @@
 	}
 
 	if( flags & SRB_DataIn ) {
-		for(i = 0 ; i <= sg_indx; i++){
+		for(i = 0 ; i < sg_indx; i++){
 			if(copy_to_user((void*)(sg_user[i]),(void*)(sg_list[i]),le32_to_cpu(srbcmd->sg.sg[i].count))){
 				printk(KERN_DEBUG"aacraid: Could not copy sg data to user\n"); 
 				rcode = -EFAULT;
@@ -561,7 +578,7 @@
 	}
 
 cleanup:
-	for(i=0; i <= sg_indx; i++){
+	for(i=0; i < sg_indx; i++){
 		kfree((void*)sg_list[i]);
 	}
 	fib_complete(srbfib);
@@ -579,17 +596,17 @@
 
 int aac_get_pci_info(struct aac_dev* dev, void* arg)
 {
-        struct aac_pci_info pci_info;
+	struct aac_pci_info pci_info;
 
 	pci_info.bus = dev->pdev->bus->number;
 	pci_info.slot = PCI_SLOT(dev->pdev->devfn);
 
-       if(copy_to_user( arg, (void*)&pci_info, sizeof(struct aac_pci_info))){
+	if (copy_to_user(arg, (void*)&pci_info, sizeof(struct aac_pci_info))) {
 		printk(KERN_DEBUG "aacraid: Could not copy pci info\n");
-               return -EFAULT;
+		return -EFAULT;
 	}
-        return 0;
- }
+	return 0;
+}
  
 
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void *arg)
===== drivers/scsi/aacraid/comminit.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/comminit.c	Fri May  2 12:30:22 2003
+++ edited/drivers/scsi/aacraid/comminit.c	Tue Sep 30 14:57:28 2003
@@ -86,13 +86,22 @@
 	 *	Adapter Fibs are the first thing allocated so that they
 	 *	start page aligned
 	 */
-	dev->fib_base_va = (ulong)base;
+	dev->aif_base_va = (struct hw_fib *)base;
 	
-	init->AdapterFibsVirtualAddress = cpu_to_le32((u32)(ulong)phys);
+	/* We submit the physical address for AIF tags to limit to 32 bits */
+	init->AdapterFibsVirtualAddress = cpu_to_le32(0);
 	init->AdapterFibsPhysicalAddress = cpu_to_le32((u32)phys);
 	init->AdapterFibsSize = cpu_to_le32(fibsize);
 	init->AdapterFibAlign = cpu_to_le32(sizeof(struct hw_fib));
-	init->HostPhysMemPages = cpu_to_le32(num_physpages);		// number of 4k pages of host physical memory
+	/* 
+	 * number of 4k pages of host physical memory.  The aacraid fw needs
+	 * this number to be less than 4gb worth of pages.
+	 */
+	if (num_physpages <= AAC_MAX_HOSTPHYSMEMPAGES) {
+		init->HostPhysMemPages = cpu_to_le32(num_physpages);
+	} else {
+		init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
+	}
 
 	/*
 	 * Increment the base address by the amount already used
@@ -131,7 +140,7 @@
 	q->dev = dev;
 	INIT_LIST_HEAD(&q->pendingq);
 	init_waitqueue_head(&q->cmdready);
-	AAC_INIT_LIST_HEAD(&q->cmdq);
+	INIT_LIST_HEAD(&q->cmdq);
 	init_waitqueue_head(&q->qfull);
 	spin_lock_init(&q->lockdata);
 	q->lock = &q->lockdata;
@@ -156,6 +165,8 @@
 	int status;
 
 	fibctx = fib_alloc(dev);
+	if (!fibctx) 
+		return -ENOMEM;
 	fib_init(fibctx);
 
 	cmd = (struct aac_close *) fib_data(fibctx);
===== drivers/scsi/aacraid/commsup.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/commsup.c	Fri May  2 12:31:18 2003
+++ edited/drivers/scsi/aacraid/commsup.c	Fri Oct  3 14:26:00 2003
@@ -136,6 +136,7 @@
 {
 	struct fib * fibptr;
 	unsigned long flags;
+	
 	spin_lock_irqsave(&dev->fib_lock, flags);
 	fibptr = dev->free_fib;	
 	while(!fibptr){
@@ -143,7 +144,7 @@
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
 		spin_lock_irqsave(&dev->fib_lock, flags);
-		fibptr = dev->free_fib;	
+		fibptr = dev->free_fib;
 	}
 	dev->free_fib = fibptr->next;
 	spin_unlock_irqrestore(&dev->fib_lock, flags);
@@ -205,7 +206,7 @@
 	hw_fib->header.StructType = FIB_MAGIC;
 	hw_fib->header.Size = cpu_to_le16(sizeof(struct hw_fib));
         hw_fib->header.XferState = cpu_to_le32(HostOwned | FibInitialized | FibEmpty | FastResponseCapable);
-	hw_fib->header.SenderFibAddress = cpu_to_le32(fibptr->hw_fib_pa);
+	hw_fib->header.SenderFibAddress = 0; /* Filled in later if needed */
 	hw_fib->header.ReceiverFibAddress = cpu_to_le32(fibptr->hw_fib_pa);
 	hw_fib->header.SenderSize = cpu_to_le16(sizeof(struct hw_fib));
 }
@@ -286,7 +287,7 @@
 	}
 
         if ((*index + 1) == le32_to_cpu(*(q->headers.consumer))) { /* Queue is full */
-		printk(KERN_WARNING "Queue %d full, %d outstanding.\n",
+		printk(KERN_WARNING "Queue %d full, %ld outstanding.\n",
 				qid, q->numpending);
 		return 0;
 	} else {
@@ -295,7 +296,7 @@
 	}
 }   
 
-/*Command thread: *
+/*
  *	aac_queue_get		-	get the next free QE
  *	@dev: Adapter
  *	@index: Returned index
@@ -315,10 +316,7 @@
 {
 	struct aac_entry * entry = NULL;
 	int map = 0;
-	struct aac_queue * q = &dev->queues->queue[qid];
 		
-	spin_lock_irqsave(q->lock, q->SavedIrql);
-	    
 	if (qid == AdapHighCmdQueue || qid == AdapNormCmdQueue) 
 	{
 		/*  if no entries wait for some if caller wants to */
@@ -357,41 +355,6 @@
 }
 
 
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
@@ -416,8 +379,12 @@
  *	an event to wait on must be supplied. This event will be set when a
  *	response FIB is received from the adapter.
  */
- 
-int fib_send(u16 command, struct fib * fibptr, unsigned long size,  int priority, int wait, int reply, fib_callback callback, void * callback_data)
+
+fib_send_t fib_send = aac_fib_send;
+
+int aac_fib_send(u16 command, struct fib * fibptr, unsigned long size,  
+		int priority, int wait, int reply, fib_callback callback, 
+		void * callback_data)
 {
 	u32 index;
 	u32 qid;
@@ -426,13 +393,14 @@
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_queue * q;
 	unsigned long flags = 0;
+	unsigned long qflags;
 	if (!(le32_to_cpu(hw_fib->header.XferState) & HostOwned))
 		return -EBUSY;
 	/*
 	 *	There are 5 cases with the wait and reponse requested flags. 
 	 *	The only invalid cases are if the caller requests to wait and
 	 *	does not request a response and if the caller does not want a
-	 *	response and the Fibis not allocated from pool. If a response
+	 *	response and the Fib is not allocated from pool. If a response
 	 *	is not requesed the Fib will just be deallocaed by the DPC
 	 *	routine when the response comes back from the adapter. No
 	 *	further processing will be done besides deleting the Fib. We 
@@ -455,8 +423,7 @@
 	 *	Map the fib into 32bits by using the fib number
 	 */
 
-//	hw_fib->header.SenderFibAddress = ((u32)(fibptr-dev->fibs)) << 1;
-	hw_fib->header.SenderFibAddress = cpu_to_le32((u32)(ulong)fibptr->hw_fib_pa);
+	hw_fib->header.SenderFibAddress = cpu_to_le32(((u32)(fibptr - dev->fibs)) << 1);
 	hw_fib->header.SenderData = (u32)(fibptr - dev->fibs);
 	/*
 	 *	Set FIB state to indicate where it came from and if we want a
@@ -490,14 +457,17 @@
 
 	if(wait)
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-	if(aac_queue_get( dev, &index, qid, hw_fib, 1, fibptr, &nointr)<0)
-		return -EWOULDBLOCK;
+
+
+	spin_lock_irqsave(q->lock, qflags);
+	aac_queue_get(dev, &index, qid, hw_fib, 1, fibptr, &nointr);
+
 	dprintk((KERN_DEBUG "fib_send: inserting a queue entry at index %d.\n",index));
 	dprintk((KERN_DEBUG "Fib contents:.\n"));
 	dprintk((KERN_DEBUG "  Command =               %d.\n", hw_fib->header.Command));
 	dprintk((KERN_DEBUG "  XferState  =            %x.\n", hw_fib->header.XferState));
 	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib));
-	dprintk((KERN_DEBUG "  hw_fib pa being sent=%xl\n",(ulong)fibptr->hw_fib_pa));
+	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
 	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
 	/*
 	 *	Fill in the Callback and CallbackContext if we are not
@@ -514,8 +484,10 @@
 	fibptr->done = 0;
 	fibptr->flags = 0;
 
-	if(aac_insert_entry(dev, index, qid, (nointr & aac_config.irq_mod)) < 0)
-		return -EWOULDBLOCK;
+	*(q->headers.producer) = cpu_to_le32(index+1);
+	spin_unlock_irqrestore(q->lock, qflags);
+	if (!(nointr & aac_config.irq_mod))
+		aac_adapter_notify(dev, qid);
 	/*
 	 *	If the caller wanted us to wait for response wait now. 
 	 */
@@ -526,7 +498,7 @@
 		if(fibptr->done == 0)
 			BUG();
 			
-		if((fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)){
+		if ((fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
 			return -ETIMEDOUT;
 		} else {
 			return 0;
@@ -640,15 +612,24 @@
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_dev * dev = fibptr->dev;
+	struct aac_queue * q;
 	unsigned long nointr = 0;
-	if (le32_to_cpu(hw_fib->header.XferState) == 0)
-        	return 0;
+	unsigned long qflags;
+	u32 qid;
+	int ret = 0;
+
+	if (le32_to_cpu(hw_fib->header.XferState) == 0) {
+		ret = 0;
+		goto out;
+	}
 	/*
 	 *	If we plan to do anything check the structure type first.
 	 */ 
-	if ( hw_fib->header.StructType != FIB_MAGIC ) {
-        	return -EINVAL;
+	if (hw_fib->header.StructType != FIB_MAGIC) {
+        	ret = -EINVAL;
+		goto out;
 	}
+
 	/*
 	 *	This block handles the case where the adapter had sent us a
 	 *	command and we have finished processing the command. We
@@ -657,45 +638,41 @@
 	 *	send the completed cdb to the adapter.
 	 */
 	if (hw_fib->header.XferState & cpu_to_le32(SentFromAdapter)) {
+        	u32 index;
 	        hw_fib->header.XferState |= cpu_to_le32(HostProcessed);
 	        if (hw_fib->header.XferState & cpu_to_le32(HighPriority)) {
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
+			qid = AdapHighRespQueue;
 		}
 		else if (hw_fib->header.XferState & NormalPriority) 
 		{
-			u32 index;
+			qid = AdapNormRespQueue;
+		} else {
+			goto out;
+		}
 
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
+		if (size) {
+			size += sizeof(struct aac_fibhdr);
+			if (size > le16_to_cpu(hw_fib->header.SenderSize)) {
+				ret = -EMSGSIZE;
+				goto out;
 			}
+			hw_fib->header.Size = cpu_to_le16(size);
 		}
+		q = &dev->queues->queue[qid];
+		spin_lock_irqsave(q->lock, qflags);
+		aac_queue_get(dev, &index, qid, hw_fib, 1, NULL, &nointr);
+		*(q->headers.producer) = cpu_to_le32(index+1);
+		spin_unlock_irqrestore(q->lock, qflags);
+		if (!(nointr & (int)aac_config.irq_mod))
+			aac_adapter_notify(dev, qid);
 	}
 	else 
 	{
         	printk(KERN_WARNING "fib_adapter_complete: Unknown xferstate detected.\n");
         	BUG();
 	}   
-	return 0;
+out:
+	return ret;
 }
 
 /**
@@ -777,7 +754,6 @@
 	memset(cp, 0,  256);
 }
 
-
 /**
  *	aac_handle_aif		-	Handle a message from the firmware
  *	@dev: Which adapter this fib is from
@@ -790,13 +766,252 @@
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
+	struct aac_aifcmd * aifcmd = (struct aac_aifcmd *)hw_fib->data;
+	int busy;
+	u32 container;
+	struct scsi_device *device;
+
+	enum {
+		NOTHING,
+		DELETE,
+		ADD,
+		CHANGE
+	} DeviceConfigNeeded;
+
+	/* Sniff for container changes */
+	dprintk ((KERN_INFO "aac_handle_aif: Aif command=%x type=%x\n",
+	  le32_to_cpu(aifcmd->command), le32_to_cpu(*(u32 *)aifcmd->data)));
+
+	DeviceConfigNeeded = NOTHING;
+
+	/*
+	 *	We have set this up to try and minimize the number of
+	 * re-configures that take place. As a result of this when
+	 * certain AIF's come in we will set a flag waiting for another
+	 * type of AIF before setting the re-config flag.
+	 */
+	switch (le32_to_cpu(aifcmd->command)) {
+	case AifCmdDriverNotify:
+		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		/*
+		 *	Morph or Expand complete
+		 */
+		case AifDenMorphComplete:
+		case AifDenVolumeExtendComplete:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= MAXIMUM_NUM_CONTAINERS) 
+				break;
+			dprintk ((KERN_INFO "container=%d(%d,%d,%d,%d)\n",
+			  container,
+			  (dev && dev->scsi_host_ptr)
+			    ? dev->scsi_host_ptr->host_no
+			    : -1,
+			  CONTAINER_CHANNEL,
+			  container,
+			  CONTAINER_LUN));
+
+			/*
+			 *	Find the Scsi_Device associated with the SCSI
+			 * address. Make sure we have the right array, and if
+			 * so set the flag to initiate a new re-config once we
+			 * see an AifEnConfigChange AIF come through.
+			 */
+
+			if ((dev != (struct aac_dev *)NULL)
+			 && (dev->scsi_host_ptr != (struct Scsi_Host *)NULL)) {
+
+				list_for_each_entry(device, 
+						&dev->scsi_host_ptr->my_devices, siblings) {
+					if ((device->channel == CONTAINER_CHANNEL)
+					 && (device->id == container)
+					 && (device->lun == CONTAINER_LUN)) {
+						dev->DeviceContainerID = container;
+						dev->DeviceConfigNeeded = CHANGE;
+						dev->DeviceConfigWaitingOn = AifEnConfigChange;
+						break;
+					} /* if */
+				} /* for */
+			} /* if */
+		} /* switch */
+
+		/*
+		 *	If we are waiting on something and this happens to be
+		 * that thing then set the re-configure flag.
+		 */
+		if (dev->DeviceConfigWaitingOn == le32_to_cpu(*(u32 *)aifcmd->data)) {
+			DeviceConfigNeeded = dev->DeviceConfigNeeded;
+		}
+		break;
+
+	case AifCmdEventNotify:
+		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		/*
+		 *	Add an Array.
+		 */
+		case AifEnAddContainer:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= MAXIMUM_NUM_CONTAINERS) 
+				break;
+			dprintk ((KERN_INFO "Add container=%d(%d,%d,%d,%d)\n",
+			  container,
+			  (dev && dev->scsi_host_ptr)
+			    ? dev->scsi_host_ptr->host_no
+			    : -1,
+			  CONTAINER_CHANNEL,
+			  container,
+			  CONTAINER_LUN));
+			dev->DeviceContainerID = container;
+			dev->DeviceConfigNeeded = ADD;
+			dev->DeviceConfigWaitingOn = AifEnConfigChange;
+			break;
+
+		/*
+		 *	Delete an Array.
+		 */
+		case AifEnDeleteContainer:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= MAXIMUM_NUM_CONTAINERS) 
+				break;
+			dprintk ((KERN_INFO "Delete container=%d(%d,%d,%d,%d)\n",
+			  container,
+			  (dev && dev->scsi_host_ptr)
+			    ? dev->scsi_host_ptr->host_no
+			    : -1,
+			  CONTAINER_CHANNEL,
+			  container,
+			  CONTAINER_LUN));
+			dev->DeviceContainerID = container;
+			dev->DeviceConfigNeeded = DELETE;
+			dev->DeviceConfigWaitingOn = AifEnConfigChange;
+			break;
+
+		/*
+		 *	Container change detected. If we currently are not
+		 * waiting on something else, setup to wait on a Config Change.
+		 */
+		case AifEnContainerChange:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= MAXIMUM_NUM_CONTAINERS) 
+				break;
+			dprintk ((KERN_INFO "Change container=%d(%d,%d,%d,%d)\n",
+			  container,
+			  (dev && dev->scsi_host_ptr)
+			    ? dev->scsi_host_ptr->host_no
+			    : -1,
+			  CONTAINER_CHANNEL,
+			  container,
+			  CONTAINER_LUN));
+			dev->DeviceContainerID = container;
+			if (dev->DeviceConfigWaitingOn) {
+				break;
+			}
+			dev->DeviceConfigNeeded = CHANGE;
+			dev->DeviceConfigWaitingOn = AifEnConfigChange;
+			break;
+		} /* switch */
+
+		/*
+		 *	If we are waiting on something and this happens to be
+		 * that thing then set the re-configure flag.
+		 */
+		if (dev->DeviceConfigWaitingOn == le32_to_cpu(*(u32 *)aifcmd->data)) {
+			DeviceConfigNeeded = dev->DeviceConfigNeeded;
+		}
+		break;
+
+	case AifCmdJobProgress:
+		/*
+		 *	These are job progress AIF's. When a Clear is being
+		 * done on a container it is initially created then hidden from
+		 * the OS. When the clear completes we don't get a config
+		 * change so we monitor the job status complete on a clear then
+		 * wait for a containe change.
+		 */
+
+		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
+		 && ((((u32 *)aifcmd->data)[6] == ((u32 *)aifcmd->data)[5])
+		  || (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsSuccess)))) {
+			dev->DeviceContainerID = -1;
+			dev->DeviceConfigWaitingOn = AifEnContainerChange;
+			dev->DeviceConfigNeeded = ADD;
+		}
+		break;
+	} /* switch */
+
+	if (DeviceConfigNeeded == NOTHING) {
+		return;
+	}
+
+
 	/*
-	 * Set the status of this FIB to be Invalid parameter.
-	 *
-	 *	*(u32 *)fib->data = ST_INVAL;
+	 *	If we decided that a re-configuration needs to be done,
+	 * schedule it here on the way out the door, please close the door
+	 * behind you.
 	 */
-	*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
-	fib_adapter_complete(fibptr, sizeof(u32));
+	dev->DeviceConfigWaitingOn = 0;
+	dev->DeviceConfigNeeded = NOTHING;
+	container = dev->DeviceContainerID;
+	dev->DeviceContainerID = -1;
+
+	busy = 0;
+
+	dprintk ((KERN_INFO "container=%d(%d,%d,%d,%d)\n", container,
+		(dev && dev->scsi_host_ptr) 
+		? dev->scsi_host_ptr->host_no : -1,
+		CONTAINER_CHANNEL,
+	  	container,
+		CONTAINER_LUN));
+
+	/*
+	 *	Find the Scsi_Device associated with the SCSI address,
+	 * and mark it as changed, invalidating the cache. This deals
+	 * with changes to existing device IDs.
+	 */
+
+	if (!dev || !dev->scsi_host_ptr) {
+		return;
+	}
+
+	list_for_each_entry(device, &dev->scsi_host_ptr->my_devices, siblings)
+	{
+		struct fsa_scsi_hba *fsa_dev_ptr = &(dev->fsa_dev);
+
+		dprintk((KERN_INFO "aifd: device (%d,%d,%d,%d)?\n",
+		  dev->scsi_host_ptr->host_no,
+		  device->channel,
+		  device->id,
+		  device->lun));
+		if ((device->channel == CONTAINER_CHANNEL)
+		 && (device->id == container)
+		 && (device->lun == CONTAINER_LUN)) {
+			busy |= (atomic_read(&device->access_count) != 0);
+			dprintk ((KERN_INFO"busy=%d DeviceConfigNeeded %d\n", 
+						busy, DeviceConfigNeeded));
+			if (busy == 0) {
+				device->removable = TRUE;
+				switch (DeviceConfigNeeded) {
+				case CHANGE:
+					dprintk((KERN_INFO"Change\n"));
+					/*
+					 * force reload of disk info via probe_container
+					 */
+					if (fsa_dev_ptr->valid[container] == 1)
+						fsa_dev_ptr->valid[container] = 2;
+					scsi_rescan_device(&device->sdev_gendev);
+					break;
+				case DELETE:
+					dprintk((KERN_INFO"Delete\n"));
+					break;
+				case ADD:
+					dprintk((KERN_INFO"Add\n"));
+					break;
+				default:
+					dprintk((KERN_INFO"Other\n"));
+					break;
+				}
+			}
+		}
+	}
 }
 
 /**
@@ -808,12 +1023,11 @@
  *	until the queue is empty. When the queue is empty it will wait for
  *	more FIBs.
  */
- 
 int aac_command_thread(struct aac_dev * dev)
 {
-	struct hw_fib *hw_fib, *newfib;
-	struct fib fibptr; /* for error logging */
-	struct aac_queue_block *queues = dev->queues;
+	struct hw_fib *hw_fib, *hw_newfib;
+	struct fib *fib, *newfib;
+	struct aac_queue *q = &dev->queues->queue[HostNormCmdQueue];
 	struct aac_fib_context *fibctx;
 	unsigned long flags;
 	DECLARE_WAITQUEUE(wait, current);
@@ -833,42 +1047,46 @@
 	 *	Let the DPC know it has a place to send the AIF's to.
 	 */
 	dev->aif_thread = 1;
-	memset(&fibptr, 0, sizeof(struct fib));
-	add_wait_queue(&queues->queue[HostNormCmdQueue].cmdready, &wait);
+	add_wait_queue(&q->cmdready, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
+	dprintk ((KERN_INFO "aac_command_thread start\n"));
 	while(1) 
 	{
-		spin_lock_irqsave(queues->queue[HostNormCmdQueue].lock, flags);
-		while(!aac_list_empty(&(queues->queue[HostNormCmdQueue].cmdq))) {
-			struct aac_list_head *entry;
+		spin_lock_irqsave(q->lock, flags);
+		while(!list_empty(&(q->cmdq))) {
+			struct list_head *entry;
 			struct aac_aifcmd * aifcmd;
 
 			set_current_state(TASK_RUNNING);
-		
-			entry = (struct aac_list_head*)(ulong)(queues->queue[HostNormCmdQueue].cmdq.next);
-			dprintk(("aacraid: Command thread: removing fib from cmdq (%p)\n",entry));
-			aac_list_del(entry);
-			
-			spin_unlock_irqrestore(queues->queue[HostNormCmdQueue].lock, flags);
-			hw_fib = aac_list_entry(entry, struct hw_fib, header.FibLinks);
+
+			entry = q->cmdq.next;
+			list_del(entry);
+	
+			spin_unlock_irqrestore(q->lock, flags);
+			fib = list_entry(entry, struct fib, fiblink);
 			/*
 			 *	We will process the FIB here or pass it to a 
 			 *	worker thread that is TBD. We Really can't 
 			 *	do anything at this point since we don't have
 			 *	anything defined for this thread to do.
 			 */
-			memset(&fibptr, 0, sizeof(struct fib));
-			fibptr.type = FSAFS_NTC_FIB_CONTEXT;
-			fibptr.size = sizeof( struct fib );
-			fibptr.hw_fib = hw_fib;
-			fibptr.data = hw_fib->data;
-			fibptr.dev = dev;
+			hw_fib = fib->hw_fib;
+			
+			memset(fib, 0, sizeof(struct fib));
+			fib->type = FSAFS_NTC_FIB_CONTEXT;
+			fib->size = sizeof( struct fib );
+			fib->hw_fib = hw_fib;
+			fib->data = hw_fib->data;
+			fib->dev = dev;
 			/*
 			 *	We only handle AifRequest fibs from the adapter.
 			 */
 			aifcmd = (struct aac_aifcmd *) hw_fib->data;
-			if (aifcmd->command == le16_to_cpu(AifCmdDriverNotify)) {
-				aac_handle_aif(dev, &fibptr);
+			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
+				/* Handle Driver Notify Events */
+				aac_handle_aif(dev, fib);
+				*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
+				fib_adapter_complete(fib, sizeof(u32));
 			} else {
 				struct list_head *entry;
 				/* The u32 here is important and intended. We are using
@@ -877,6 +1095,12 @@
 				u32 time_now, time_last;
 				unsigned long flagv;
 				
+				/* Sniff events */
+				if ((aifcmd->command == cpu_to_le32(AifCmdEventNotify))
+				 || (aifcmd->command == cpu_to_le32(AifCmdJobProgress))) {
+					aac_handle_aif(dev, fib);
+				}
+
 				time_now = jiffies/HZ;
 
 				spin_lock_irqsave(&dev->fib_lock, flagv);
@@ -898,6 +1122,11 @@
 					 */
 					if (fibctx->count > 20)
 					{
+						/*
+						 * It's *not* jiffies folks,
+						 * but jiffies / HZ, so do not
+						 * panic ...
+						 */
 						time_last = fibctx->jiffies;
 						/*
 						 * Has it been > 2 minutes 
@@ -914,17 +1143,21 @@
 					 * Warning: no sleep allowed while
 					 * holding spinlock
 					 */
-					newfib = kmalloc(sizeof(struct hw_fib), GFP_ATOMIC);
-					if (newfib) {
+					hw_newfib = kmalloc(sizeof(struct hw_fib), GFP_ATOMIC);
+					newfib = kmalloc(sizeof(struct fib), GFP_ATOMIC);
+					if (newfib && hw_newfib) {
 						/*
 						 * Make the copy of the FIB
+						 * FIXME: check if we need to fix other fields up
 						 */
-						memcpy(newfib, hw_fib, sizeof(struct hw_fib));
+						memcpy(hw_newfib, hw_fib, sizeof(struct hw_fib));
+						memcpy(newfib, fib, sizeof(struct fib));
+						newfib->hw_fib = hw_newfib;
 						/*
 						 * Put the FIB onto the
 						 * fibctx's fibs
 						 */
-						aac_list_add_tail(&newfib->header.FibLinks, &fibctx->hw_fib_list);
+						list_add_tail(&newfib->fiblink, &fibctx->fib_list);
 						fibctx->count++;
 						/* 
 						 * Set the event to wake up the
@@ -933,6 +1166,10 @@
 						up(&fibctx->wait_sem);
 					} else {
 						printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
+						if(newfib)
+							kfree(newfib);
+						if(hw_newfib)
+							kfree(hw_newfib);
 					}
 					entry = entry->next;
 				}
@@ -940,22 +1177,24 @@
 				 *	Set the status of this FIB
 				 */
 				*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
-				fib_adapter_complete(&fibptr, sizeof(u32));
+				fib_adapter_complete(fib, sizeof(u32));
 				spin_unlock_irqrestore(&dev->fib_lock, flagv);
 			}
-			spin_lock_irqsave(queues->queue[HostNormCmdQueue].lock, flags);
+			spin_lock_irqsave(q->lock, flags);
+			kfree(fib);
 		}
 		/*
 		 *	There are no more AIF's
 		 */
-		spin_unlock_irqrestore(queues->queue[HostNormCmdQueue].lock, flags);
+		spin_unlock_irqrestore(q->lock, flags);
 		schedule();
 
 		if(signal_pending(current))
 			break;
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	remove_wait_queue(&queues->queue[HostNormCmdQueue].cmdready, &wait);
+	remove_wait_queue(&q->cmdready, &wait);
 	dev->aif_thread = 0;
 	complete_and_exit(&dev->aif_completion, 0);
 }
+ 

-- 
Mark Haverkamp <markh@osdl.org>

