From: Achim Leubner <Achim.Leubner@pmcs.com>
Subject: RE: [PATCH 6/7] aacraid: performance improvement changes
Date: Tue, 17 Mar 2015 15:27:52 +0000
Message-ID: <307F48E420013C4E85C75C93E532197AB8092057@BBYEXM01.pmc-sierra.internal>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1425458313-1956-7-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57838 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbbCQPwr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2015 11:52:47 -0400
In-Reply-To: <1425458313-1956-7-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>


-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Wednesday, March 4, 2015 9:39 AM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pandurangan; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH 6/7] aacraid: performance improvement changes

Add performance improvement changes.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |    6 +++---
 drivers/scsi/aacraid/comminit.c |   12 +++++++++++-
 drivers/scsi/aacraid/commsup.c  |    7 ++-----
 drivers/scsi/aacraid/dpcsup.c   |    4 ++--
 drivers/scsi/aacraid/linit.c    |   10 ++++------
 drivers/scsi/aacraid/rx.c       |   14 +++-----------
 drivers/scsi/aacraid/src.c      |    5 +----
 7 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index a37762e..74a0440 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
 
-#define AAC_MAX_MSIX		32	/* vectors */
+#define AAC_MAX_MSIX		8	/* vectors */
 #define AAC_PCI_MSI_ENABLE	0x8000
 
 enum {
@@ -62,7 +62,7 @@ enum {
 #define	PMC_GLOBAL_INT_BIT0		0x00000001
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 30300
+# define AAC_DRIVER_BUILD 40709
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -633,7 +633,7 @@ struct aac_queue {
 	spinlock_t		lockdata;	/* Actual lock (used only on one side of the lock) */
 	struct list_head	cmdq;		/* A queue of FIBs which need to be prcessed by the FS thread. This is */
 						/* only valid for command queues which receive entries from the adapter. */
-	u32			numpending;	/* Number of entries on outstanding queue. */
+	atomic_t		numpending;	/* Number of entries on outstanding queue. */
 	struct aac_dev *	dev;		/* Back pointer to adapter structure */
 };
 
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c index c3e13ae..c16043e 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -181,7 +181,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
     
 static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem, int qsize)  {
-	q->numpending = 0;
+	atomic_set(&q->numpending, 0);
 	q->dev = dev;
 	init_waitqueue_head(&q->cmdready);
 	INIT_LIST_HEAD(&q->cmdq);
@@ -510,6 +510,7 @@ static void aac_define_int_mode(struct aac_dev *dev)  {
 
 	int i, msi_count;
+	int cpu;
 
 	msi_count = i = 0;
 	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */ @@ -571,6 +572,15 @@ static void aac_define_int_mode(struct aac_dev *dev)
 	else {
 		if (dev->max_msix > msi_count)
 			dev->max_msix = msi_count;
+
+		/* Added to set IRQ affinity */
+		cpu = cpumask_first(cpu_online_mask);
+		cpu = cpumask_next(cpu, cpu_online_mask);
+
+		for (i = 0; i < dev->max_msix; i++) {
+			irq_set_affinity_hint(dev->msixentry[i].vector, get_cpu_mask(cpu));
+			cpu = cpumask_next(cpu, cpu_online_mask);
+		}
 	}
 	dev->vector_cap = (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) / msi_count;  } diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c index 2bed445..0555023 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -318,7 +318,7 @@ static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entr
 	/* Queue is full */
 	if ((*index + 1) == le32_to_cpu(*(q->headers.consumer))) {
 		printk(KERN_WARNING "Queue %d full, %u outstanding.\n",
-				qid, q->numpending);
+				qid, atomic_read(&q->numpending));
 		return 0;
 	} else {
 		*entry = q->base + *index;
@@ -411,7 +411,6 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	struct aac_dev * dev = fibptr->dev;
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 	unsigned long flags = 0;
-	unsigned long qflags;
 	unsigned long mflags = 0;
 	unsigned long sflags = 0;
 
@@ -565,9 +564,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
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
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c index 2e39466..da9d993 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -84,7 +84,7 @@ unsigned int aac_response_normal(struct aac_queue * q)
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		dev->queues->queue[AdapNormCmdQueue].numpending--;
+		atomic_dec(&dev->queues->queue[AdapNormCmdQueue].numpending);
 
 		if (unlikely(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
 			spin_unlock_irqrestore(q->lock, flags); @@ -354,7 +354,7 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		dev->queues->queue[AdapNormCmdQueue].numpending--;
+		atomic_dec(&dev->queues->queue[AdapNormCmdQueue].numpending);
 
 		if (unlikely(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
 			aac_fib_complete(fib);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c index 4c5ba9e..e0f9f81 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -250,16 +250,14 @@ static struct aac_driver_ident aac_drivers[] = {
  *
  *	TODO: unify with aac_scsi_cmd().
  */
-
-static int aac_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+static int aac_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd 
+*cmd)
 {
-	cmd->scsi_done = done;
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
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c index 5c6a870..9570612 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -400,16 +400,13 @@ int aac_rx_deliver_producer(struct fib * fib)  {
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
 
@@ -426,15 +423,12 @@ static int aac_rx_deliver_message(struct fib * fib)  {
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
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c index 82ff025..bde26a2 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -433,15 +433,12 @@ static int aac_src_deliver_message(struct fib *fib)  {
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
--
1.7.7.3

