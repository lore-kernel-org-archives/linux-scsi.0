From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 09/11] aacraid: performance improvement changes
Date: Thu, 26 Mar 2015 10:41:30 -0400
Message-ID: <1427380892-1978-10-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:50389 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbbCZOsl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:48:41 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add performance improvement changes.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |    5 +++--
 drivers/scsi/aacraid/comminit.c |    4 ++--
 drivers/scsi/aacraid/commsup.c  |   37 ++++++++++++++++++-------------------
 drivers/scsi/aacraid/dpcsup.c   |    4 ++--
 drivers/scsi/aacraid/linit.c    |   37 +++++++++++++++++++------------------
 drivers/scsi/aacraid/rx.c       |   14 +++-----------
 drivers/scsi/aacraid/src.c      |   14 ++++++++++----
 7 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 43d8076..2ba158b 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
 
-#define AAC_MAX_MSIX		32	/* vectors */
+#define AAC_MAX_MSIX		8	/* vectors */
 #define AAC_PCI_MSI_ENABLE	0x8000
 
 enum {
@@ -633,7 +633,8 @@ struct aac_queue {
 	spinlock_t		lockdata;	/* Actual lock (used only on one side of the lock) */
 	struct list_head	cmdq;		/* A queue of FIBs which need to be prcessed by the FS thread. This is */
 						/* only valid for command queues which receive entries from the adapter. */
-	u32			numpending;	/* Number of entries on outstanding queue. */
+	/* Number of entries on outstanding queue. */
+	atomic_t		numpending;
 	struct aac_dev *	dev;		/* Back pointer to adapter structure */
 };
 
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 27432b9..45db84a 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -53,7 +53,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 {
 	unsigned char *base;
 	unsigned long size, align;
-	const unsigned long fibsize = 4096;
+	const unsigned long fibsize = dev->max_fib_size;
 	const unsigned long printfbufsiz = 256;
 	unsigned long host_rrq_size = 0;
 	struct aac_init *init;
@@ -182,7 +182,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
     
 static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem, int qsize)
 {
-	q->numpending = 0;
+	atomic_set(&q->numpending, 0);
 	q->dev = dev;
 	init_waitqueue_head(&q->cmdready);
 	INIT_LIST_HEAD(&q->cmdq);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e615a0b..1a3c0e0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -208,14 +208,10 @@ struct fib *aac_fib_alloc(struct aac_dev *dev)
 
 void aac_fib_free(struct fib *fibptr)
 {
-	unsigned long flags, flagsv;
+	unsigned long flags;
 
-	spin_lock_irqsave(&fibptr->event_lock, flagsv);
-	if (fibptr->done == 2) {
-		spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
+	if (fibptr->done == 2)
 		return;
-	}
-	spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
 
 	spin_lock_irqsave(&fibptr->dev->fib_lock, flags);
 	if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
@@ -321,7 +317,7 @@ static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entr
 	/* Queue is full */
 	if ((*index + 1) == le32_to_cpu(*(q->headers.consumer))) {
 		printk(KERN_WARNING "Queue %d full, %u outstanding.\n",
-				qid, q->numpending);
+				qid, atomic_read(&q->numpending));
 		return 0;
 	} else {
 		*entry = q->base + *index;
@@ -414,7 +410,6 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	struct aac_dev * dev = fibptr->dev;
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 	unsigned long flags = 0;
-	unsigned long qflags;
 	unsigned long mflags = 0;
 	unsigned long sflags = 0;
 
@@ -568,9 +563,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 				int blink;
 				if (time_is_before_eq_jiffies(timeout)) {
 					struct aac_queue * q = &dev->queues->queue[AdapNormCmdQueue];
-					spin_lock_irqsave(q->lock, qflags);
-					q->numpending--;
-					spin_unlock_irqrestore(q->lock, qflags);
+					atomic_dec(&q->numpending);
 					if (wait == -1) {
 	        				printk(KERN_ERR "aacraid: aac_fib_send: first asynchronous command timed out.\n"
 						  "Usually a result of a PCI interrupt routing problem;\n"
@@ -775,7 +768,6 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 
 int aac_fib_complete(struct fib *fibptr)
 {
-	unsigned long flags;
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 
 	/*
@@ -798,12 +790,6 @@ int aac_fib_complete(struct fib *fibptr)
 	 *	command is complete that we had sent to the adapter and this
 	 *	cdb could be reused.
 	 */
-	spin_lock_irqsave(&fibptr->event_lock, flags);
-	if (fibptr->done == 2) {
-		spin_unlock_irqrestore(&fibptr->event_lock, flags);
-		return 0;
-	}
-	spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
 	if((hw_fib->header.XferState & cpu_to_le32(SentFromHost)) &&
 		(hw_fib->header.XferState & cpu_to_le32(AdapterProcessed)))
@@ -1257,6 +1243,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	struct scsi_cmnd *command;
 	struct scsi_cmnd *command_list;
 	int jafo = 0;
+	int cpu;
 
 	/*
 	 * Assumptions:
@@ -1319,14 +1306,26 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	aac->comm_phys = 0;
 	kfree(aac->queues);
 	aac->queues = NULL;
+	cpu = cpumask_first(cpu_online_mask);
 	if (aac->pdev->device == PMC_DEVICE_S6 ||
 	    aac->pdev->device == PMC_DEVICE_S7 ||
 	    aac->pdev->device == PMC_DEVICE_S8 ||
 	    aac->pdev->device == PMC_DEVICE_S9) {
 		if (aac->max_msix > 1) {
-			for (i = 0; i < aac->max_msix; i++)
+			for (i = 0; i < aac->max_msix; i++) {
+				if (irq_set_affinity_hint(
+				    aac->msixentry[i].vector,
+				    NULL)) {
+					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\n",
+						aac->name,
+						aac->id,
+						cpu);
+				}
+				cpu = cpumask_next(cpu,
+						cpu_online_mask);
 				free_irq(aac->msixentry[i].vector,
 					 &(aac->aac_msix[i]));
+			}
 			pci_disable_msix(aac->pdev);
 		} else {
 			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 2e39466..da9d993 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -84,7 +84,7 @@ unsigned int aac_response_normal(struct aac_queue * q)
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		dev->queues->queue[AdapNormCmdQueue].numpending--;
+		atomic_dec(&dev->queues->queue[AdapNormCmdQueue].numpending);
 
 		if (unlikely(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
 			spin_unlock_irqrestore(q->lock, flags);
@@ -354,7 +354,7 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		dev->queues->queue[AdapNormCmdQueue].numpending--;
+		atomic_dec(&dev->queues->queue[AdapNormCmdQueue].numpending);
 
 		if (unlikely(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
 			aac_fib_complete(fib);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 36653a9..7bbf1b3 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -251,27 +251,15 @@ static struct aac_driver_ident aac_drivers[] = {
  *	TODO: unify with aac_scsi_cmd().
  */
 
-static int aac_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+static int aac_queuecommand(struct Scsi_Host *shost,
+			    struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *host = cmd->device->host;
-	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
-	u32 count = 0;
-	cmd->scsi_done = done;
-	for (; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-		struct fib * fib = &dev->fibs[count];
-		struct scsi_cmnd * command;
-		if (fib->hw_fib_va->header.XferState &&
-		    ((command = fib->callback_data)) &&
-		    (command == cmd) &&
-		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE))
-			return 0; /* Already owned by Adapter */
-	}
+	int r = 0;
 	cmd->SCp.phase = AAC_OWNER_LOWLEVEL;
-	return (aac_scsi_cmd(cmd) ? FAILED : 0);
+	r = (aac_scsi_cmd(cmd) ? FAILED : 0);
+	return r;
 }
 
-static DEF_SCSI_QCMD(aac_queuecommand)
-
 /**
  *	aac_info		-	Returns the host adapter name
  *	@shost:		Scsi host to report on
@@ -1085,6 +1073,7 @@ static struct scsi_host_template aac_driver_template = {
 static void __aac_shutdown(struct aac_dev * aac)
 {
 	int i;
+	int cpu;
 
 	if (aac->aif_thread) {
 		int i;
@@ -1099,14 +1088,26 @@ static void __aac_shutdown(struct aac_dev * aac)
 	}
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
+	cpu = cpumask_first(cpu_online_mask);
 	if (aac->pdev->device == PMC_DEVICE_S6 ||
 	    aac->pdev->device == PMC_DEVICE_S7 ||
 	    aac->pdev->device == PMC_DEVICE_S8 ||
 	    aac->pdev->device == PMC_DEVICE_S9) {
 		if (aac->max_msix > 1) {
-			for (i = 0; i < aac->max_msix; i++)
+			for (i = 0; i < aac->max_msix; i++) {
+				if (irq_set_affinity_hint(
+				    aac->msixentry[i].vector,
+				    NULL)) {
+					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\n",
+						aac->name,
+						aac->id,
+						cpu);
+				}
+				cpu = cpumask_next(cpu,
+						cpu_online_mask);
 				free_irq(aac->msixentry[i].vector,
 					 &(aac->aac_msix[i]));
+			}
 		} else {
 			free_irq(aac->pdev->irq,
 				 &(aac->aac_msix[0]));
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 5c6a870..9570612 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -400,16 +400,13 @@ int aac_rx_deliver_producer(struct fib * fib)
 {
 	struct aac_dev *dev = fib->dev;
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
-	unsigned long qflags;
 	u32 Index;
 	unsigned long nointr = 0;
 
-	spin_lock_irqsave(q->lock, qflags);
 	aac_queue_get( dev, &Index, AdapNormCmdQueue, fib->hw_fib_va, 1, fib, &nointr);
 
-	q->numpending++;
+	atomic_inc(&q->numpending);
 	*(q->headers.producer) = cpu_to_le32(Index + 1);
-	spin_unlock_irqrestore(q->lock, qflags);
 	if (!(nointr & aac_config.irq_mod))
 		aac_adapter_notify(dev, AdapNormCmdQueue);
 
@@ -426,15 +423,12 @@ static int aac_rx_deliver_message(struct fib * fib)
 {
 	struct aac_dev *dev = fib->dev;
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
-	unsigned long qflags;
 	u32 Index;
 	u64 addr;
 	volatile void __iomem *device;
 
 	unsigned long count = 10000000L; /* 50 seconds */
-	spin_lock_irqsave(q->lock, qflags);
-	q->numpending++;
-	spin_unlock_irqrestore(q->lock, qflags);
+	atomic_inc(&q->numpending);
 	for(;;) {
 		Index = rx_readl(dev, MUnit.InboundQueue);
 		if (unlikely(Index == 0xFFFFFFFFL))
@@ -442,9 +436,7 @@ static int aac_rx_deliver_message(struct fib * fib)
 		if (likely(Index != 0xFFFFFFFFL))
 			break;
 		if (--count == 0) {
-			spin_lock_irqsave(q->lock, qflags);
-			q->numpending--;
-			spin_unlock_irqrestore(q->lock, qflags);
+			atomic_dec(&q->numpending);
 			return -ETIMEDOUT;
 		}
 		udelay(5);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 4a963cd..4596e9d 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -444,15 +444,12 @@ static int aac_src_deliver_message(struct fib *fib)
 {
 	struct aac_dev *dev = fib->dev;
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
-	unsigned long qflags;
 	u32 fibsize;
 	dma_addr_t address;
 	struct aac_fib_xporthdr *pFibX;
 	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);
 
-	spin_lock_irqsave(q->lock, qflags);
-	q->numpending++;
-	spin_unlock_irqrestore(q->lock, qflags);
+	atomic_inc(&q->numpending);
 
 	if (dev->msi_enabled && fib->hw_fib_va->header.Command != AifRequest &&
 	    dev->max_msix > 1) {
@@ -794,6 +791,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	int instance = dev->id;
 	int i, j;
 	const char *name = dev->name;
+	int cpu;
 
 	dev->a_ops.adapter_ioremap = aac_srcv_ioremap;
 	dev->a_ops.adapter_comm = aac_src_select_comm;
@@ -911,6 +909,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	if (dev->msi_enabled)
 		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
 	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
+		cpu = cpumask_first(cpu_online_mask);
 		for (i = 0; i < dev->max_msix; i++) {
 			dev->aac_msix[i].vector_no = i;
 			dev->aac_msix[i].dev = dev;
@@ -928,6 +927,13 @@ int aac_srcv_init(struct aac_dev *dev)
 				pci_disable_msix(dev->pdev);
 				goto error_iounmap;
 			}
+			if (irq_set_affinity_hint(
+			   dev->msixentry[i].vector,
+			   get_cpu_mask(cpu))) {
+				printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu %d\n",
+						name, instance, cpu);
+			}
+			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
 	} else {
 		dev->aac_msix[0].vector_no = 0;
-- 
1.7.7.3

