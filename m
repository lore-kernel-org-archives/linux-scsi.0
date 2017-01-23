From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 08/24] aacraid: Added support for response path
Date: Mon, 23 Jan 2017 10:08:52 -0800
Message-ID: <20170123180908.3465-9-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0053.outbound.protection.outlook.com ([104.47.32.53]:14209
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751838AbdAXBB7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 20:01:59 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

This patch enables the driver to actually process the I/O, or srb replies
from adapter. In addition to any HBA1000 or SmartIOC2000 adapter events.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  | 34 +++++++++++++++------------
 drivers/scsi/aacraid/aacraid.h | 52 +++++++++++++++++++++++-------------------
 drivers/scsi/aacraid/commsup.c | 17 +++++++++-----
 drivers/scsi/aacraid/dpcsup.c  | 20 ++++++++--------
 drivers/scsi/aacraid/src.c     | 38 ++++++++++++++++++++++--------
 5 files changed, 99 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index c6eb8a5..5465c8a 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -329,7 +329,7 @@ static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 	}
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 	device = scsicmd->device;
-	if (unlikely(!device || !scsi_device_online(device))) {
+	if (unlikely(!device)) {
 		dprintk((KERN_WARNING "aac_valid_context: scsi device corrupt\n"));
 		aac_fib_complete(fibptr);
 		return 0;
@@ -475,16 +475,26 @@ int aac_get_containers(struct aac_dev *dev)
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
-			GFP_KERNEL);
-	if (!fsa_dev_ptr)
-		return -ENOMEM;
+	if ((dev->fsa_dev == NULL) ||
+		(dev->maximum_num_containers != maximum_num_containers)) {
+
+		fsa_dev_ptr = dev->fsa_dev;
 
-	dev->fsa_dev = fsa_dev_ptr;
-	dev->maximum_num_containers = maximum_num_containers;
+		dev->fsa_dev = kzalloc(sizeof(*fsa_dev_ptr) *
+				maximum_num_containers,	GFP_KERNEL);
 
-	for (index = 0; index < dev->maximum_num_containers; ) {
-		fsa_dev_ptr[index].devname[0] = '\0';
+		kfree(fsa_dev_ptr);
+		fsa_dev_ptr = NULL;
+
+
+		if (!dev->fsa_dev)
+			return -ENOMEM;
+
+		dev->maximum_num_containers = maximum_num_containers;
+	}
+	for (index = 0; index < dev->maximum_num_containers; index++) {
+		dev->fsa_dev[index].devname[0] = '\0';
+		dev->fsa_dev[index].valid = 0;
 
 		status = aac_probe_container(dev, index);
 
@@ -492,12 +502,6 @@ int aac_get_containers(struct aac_dev *dev)
 			printk(KERN_WARNING "aac_get_containers: SendFIB failed.\n");
 			break;
 		}
-
-		/*
-		 *	If there are no more containers, then stop asking.
-		 */
-		if (++index >= status)
-			break;
 	}
 	return status;
 }
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 8c6c4ac..f749215 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -407,7 +407,7 @@ struct aac_fibhdr {
 		__le32 SenderFibAddressHigh;/* upper 32bit of phys. FIB address */
 		__le32 TimeStamp;	/* otherwise timestamp for FW internal use */
 	} u;
-	u32 Handle;		/* FIB handle used for MSGU commnunication */
+	__le32 Handle;		/* FIB handle used for MSGU commnunication */
 	u32 Previous;		/* FW internal use */
 	u32 Next;		/* FW internal use */
 };
@@ -872,18 +872,20 @@ struct rkt_registers {
 #define src_inbound rx_inbound
 
 struct src_mu_registers {
-				/*	PCI*| Name */
-	__le32	reserved0[6];	/*	00h | Reserved */
-	__le32	IOAR[2];	/*	18h | IOA->host interrupt register */
-	__le32	IDR;		/*	20h | Inbound Doorbell Register */
-	__le32	IISR;		/*	24h | Inbound Int. Status Register */
-	__le32	reserved1[3];	/*	28h | Reserved */
-	__le32	OIMR;		/*	34h | Outbound Int. Mask Register */
-	__le32	reserved2[25];	/*	38h | Reserved */
-	__le32	ODR_R;		/*	9ch | Outbound Doorbell Read */
-	__le32	ODR_C;		/*	a0h | Outbound Doorbell Clear */
-	__le32	reserved3[6];	/*	a4h | Reserved */
-	__le32	OMR;		/*	bch | Outbound Message Register */
+				/*  PCI*| Name */
+	__le32	reserved0[6];	/*  00h | Reserved */
+	__le32	IOAR[2];	/*  18h | IOA->host interrupt register */
+	__le32	IDR;		/*  20h | Inbound Doorbell Register */
+	__le32	IISR;		/*  24h | Inbound Int. Status Register */
+	__le32	reserved1[3];	/*  28h | Reserved */
+	__le32	OIMR;		/*  34h | Outbound Int. Mask Register */
+	__le32	reserved2[25];  /*  38h | Reserved */
+	__le32	ODR_R;		/*  9ch | Outbound Doorbell Read */
+	__le32	ODR_C;		/*  a0h | Outbound Doorbell Clear */
+	__le32	reserved3[3];	/*  a4h | Reserved */
+	__le32	SCR0;		/*  b0h | Scratchpad 0 */
+	__le32	reserved4[2];	/*  b4h | Reserved */
+	__le32	OMR;		/*  bch | Outbound Message Register */
 	__le32	IQ_L;		/*  c0h | Inbound Queue (Low address) */
 	__le32	IQ_H;		/*  c4h | Inbound Queue (High address) */
 	__le32	ODR_MSI;	/*  c8h | MSI register for sync./AIF */
@@ -982,6 +984,7 @@ struct fsa_dev_info {
 	char		devname[8];
 	struct sense_data sense_data;
 	u32		block_size;
+	u8		identifier[16];
 };
 
 struct fib {
@@ -1012,6 +1015,7 @@ struct fib {
 	u32			vector_no;
 	struct hw_fib		*hw_fib_va;		/* Actual shared object */
 	dma_addr_t		hw_fib_pa;		/* physical address of hw_fib*/
+	u32			hbacmd_size;	/* cmd size for native */
 };
 
 #define AAC_DEVTYPE_RAID_MEMBER	1
@@ -1215,9 +1219,11 @@ struct aac_dev
 	/*
 	 *	negotiated FIB settings
 	 */
-	unsigned		max_fib_size;
-	unsigned		sg_tablesize;
-	unsigned		max_num_aif;
+	unsigned int		max_fib_size;
+	unsigned int		sg_tablesize;
+	unsigned int		max_num_aif;
+
+	unsigned int		max_cmd_size;	/* max_fib_size or MAX_NATIVE */
 
 	/*
 	 *	Map for 128 fib objects (64k)
@@ -1259,18 +1265,17 @@ struct aac_dev
 	 */
 	union aac_init		*init;
 	dma_addr_t		init_pa;	/* Holds physical address of the init struct */
-
-	u32			*host_rrq;	/* response queue
-						 * if AAC_COMM_MESSAGE_TYPE1 */
-
+	/* response queue (if AAC_COMM_MESSAGE_TYPE1) */
+	__le32			*host_rrq;
 	dma_addr_t		host_rrq_pa;	/* phys. address */
 	/* index into rrq buffer */
 	u32			host_rrq_idx[AAC_MAX_MSIX];
 	atomic_t		rrq_outstanding[AAC_MAX_MSIX];
 	u32			fibs_pushed_no;
 	struct pci_dev		*pdev;		/* Our PCI interface */
-	void *			printfbuf;	/* pointer to buffer used for printf's from the adapter */
-	void *			comm_addr;	/* Base address of Comm area */
+	/* pointer to buffer used for printf's from the adapter */
+	void			*printfbuf;
+	void			*comm_addr;	/* Base address of Comm area */
 	dma_addr_t		comm_phys;	/* Physical Address of Comm area */
 	size_t			comm_size;
 
@@ -1342,6 +1347,8 @@ struct aac_dev
 	u32			max_msix;	/* max. MSI-X vectors */
 	u32			vector_cap;	/* MSI-X vector capab.*/
 	int			msi_enabled;	/* MSI/MSI-X enabled */
+	atomic_t		msix_counter;
+	struct msix_entry	msixentry[AAC_MAX_MSIX];
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
 	struct aac_hba_map_info	hba_map[AAC_MAX_BUSES][AAC_MAX_TARGETS];
 	u8			adapter_shutdown;
@@ -2281,7 +2288,6 @@ int aac_rx_select_comm(struct aac_dev *dev, int comm);
 int aac_rx_deliver_producer(struct fib * fib);
 char * get_container_type(unsigned type);
 extern int numacb;
-extern int acbsize;
 extern char aac_driver_version[];
 extern int startup_timeout;
 extern int aif_timeout;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e37dfa5..31c65ca 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -60,12 +60,17 @@
 
 static int fib_map_alloc(struct aac_dev *dev)
 {
+	if (dev->max_fib_size > AAC_MAX_NATIVE_SIZE)
+		dev->max_cmd_size = AAC_MAX_NATIVE_SIZE;
+	else
+		dev->max_cmd_size = dev->max_fib_size;
+
 	dprintk((KERN_INFO
 	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d + %d), %p)\n",
-	  dev->pdev, dev->max_fib_size, dev->scsi_host_ptr->can_queue,
+	  dev->pdev, dev->max_cmd_size, dev->scsi_host_ptr->can_queue,
 	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
 	dev->hw_fib_va = pci_alloc_consistent(dev->pdev,
-		(dev->max_fib_size + sizeof(struct aac_fib_xporthdr))
+		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
 		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1),
 		&dev->hw_fib_pa);
 	if (dev->hw_fib_va == NULL)
@@ -83,9 +88,9 @@ static int fib_map_alloc(struct aac_dev *dev)
 
 void aac_fib_map_free(struct aac_dev *dev)
 {
-	if (dev->hw_fib_va && dev->max_fib_size) {
+	if (dev->hw_fib_va && dev->max_cmd_size) {
 		pci_free_consistent(dev->pdev,
-		(dev->max_fib_size *
+		(dev->max_cmd_size *
 		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
 		dev->hw_fib_va, dev->hw_fib_pa);
 	}
@@ -176,9 +181,9 @@ int aac_fib_setup(struct aac_dev * dev)
 		hw_fib->header.SenderSize = cpu_to_le16(dev->max_fib_size);
 		fibptr->hw_fib_pa = hw_fib_pa;
 		hw_fib = (struct hw_fib *)((unsigned char *)hw_fib +
-			dev->max_fib_size + sizeof(struct aac_fib_xporthdr));
+			dev->max_cmd_size + sizeof(struct aac_fib_xporthdr));
 		hw_fib_pa = hw_fib_pa +
-			dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
+			dev->max_cmd_size + sizeof(struct aac_fib_xporthdr);
 	}
 
 	/*
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 7e83620..8077dba 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -122,7 +122,6 @@ unsigned int aac_response_normal(struct aac_queue * q)
 			 *	NOTE:  we cannot touch the fib after this
 			 *	    call, because it may have been deallocated.
 			 */
-			fib->flags &= FIB_CONTEXT_FLAG_FASTRESP;
 			fib->callback(fib->callback_data, fib);
 		} else {
 			unsigned long flagv;
@@ -251,8 +250,9 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
 	BUG_ON(fibptr == NULL);
 	dev = fibptr->dev;
 
-	if (fibptr->hw_fib_va->header.XferState &
-	    cpu_to_le32(NoMoreAifDataAvailable)) {
+	if ((fibptr->hw_fib_va->header.XferState &
+	    cpu_to_le32(NoMoreAifDataAvailable)) ||
+		dev->sa_firmware) {
 		aac_fib_complete(fibptr);
 		aac_fib_free(fibptr);
 		return;
@@ -282,8 +282,8 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
  *	know there is a response on our normal priority queue. We will pull off
  *	all QE there are and wake up all the waiters before exiting.
  */
-unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
-			int isAif, int isFastResponse, struct hw_fib *aif_fib)
+unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
+	int isFastResponse, struct hw_fib *aif_fib)
 {
 	unsigned long mflags;
 	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
@@ -305,12 +305,14 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
 			kfree (fib);
 			return 1;
 		}
-		if (aif_fib != NULL) {
+		if (dev->sa_firmware) {
+			fib->hbacmd_size = index;	/* store event type */
+		} else if (aif_fib != NULL) {
 			memcpy(hw_fib, aif_fib, sizeof(struct hw_fib));
 		} else {
-			memcpy(hw_fib,
-				(struct hw_fib *)(((uintptr_t)(dev->regs.sa)) +
-				index), sizeof(struct hw_fib));
+			memcpy(hw_fib, (struct hw_fib *)
+				(((uintptr_t)(dev->regs.sa)) + index),
+				sizeof(struct hw_fib));
 		}
 		INIT_LIST_HEAD(&fib->fiblink);
 		fib->type = FSAFS_NTC_FIB_CONTEXT;
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 92c55e9..af31c09 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -135,8 +135,16 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 
 	if (mode & AAC_INT_MODE_AIF) {
 		/* handle AIF */
-		if (dev->aif_thread && dev->fsa_dev)
-			aac_intr_normal(dev, 0, 2, 0, NULL);
+		if (dev->sa_firmware) {
+			u32 events = src_readl(dev, MUnit.SCR0);
+
+			aac_intr_normal(dev, events, 1, 0, NULL);
+			writel(events, &dev->IndexRegs->Mailbox[0]);
+			src_writel(dev, MUnit.IDR, 1 << 23);
+		} else {
+			if (dev->aif_thread && dev->fsa_dev)
+				aac_intr_normal(dev, 0, 2, 0, NULL);
+		}
 		if (dev->msi_enabled)
 			aac_src_access_devreg(dev, AAC_CLEAR_AIF_BIT);
 		mode = 0;
@@ -148,17 +156,19 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 		for (;;) {
 			isFastResponse = 0;
 			/* remove toggle bit (31) */
-			handle = (dev->host_rrq[index] & 0x7fffffff);
-			/* check fast response bit (30) */
+			handle = le32_to_cpu((dev->host_rrq[index])
+				& 0x7fffffff);
+			/* check fast response bits (30, 1) */
 			if (handle & 0x40000000)
 				isFastResponse = 1;
 			handle &= 0x0000ffff;
 			if (handle == 0)
 				break;
+			handle >>= 2;
 			if (dev->msi_enabled && dev->max_msix > 1)
 				atomic_dec(&dev->rrq_outstanding[vector_no]);
+			aac_intr_normal(dev, handle, 0, isFastResponse, NULL);
 			dev->host_rrq[index++] = 0;
-			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
 			if (index == (vector_no + 1) * dev->vector_cap)
 				index = vector_no * dev->vector_cap;
 			dev->host_rrq_idx[vector_no] = index;
@@ -392,6 +402,7 @@ static void aac_src_start_adapter(struct aac_dev *dev)
 		dev->host_rrq_idx[i] = i * dev->vector_cap;
 		atomic_set(&dev->rrq_outstanding[i], 0);
 	}
+	atomic_set(&dev->msix_counter, 0);
 	dev->fibs_pushed_no = 0;
 
 	init = dev->init;
@@ -565,9 +576,18 @@ static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
 		dev->base = dev->regs.src.bar0 = NULL;
 		return 0;
 	}
+
+	dev->regs.src.bar1 =
+	ioremap(pci_resource_start(dev->pdev, 2), AAC_MIN_SRCV_BAR1_SIZE);
+	dev->base = NULL;
+	if (dev->regs.src.bar1 == NULL)
+		return -1;
 	dev->base = dev->regs.src.bar0 = ioremap(dev->base_start, size);
-	if (dev->base == NULL)
+	if (dev->base == NULL) {
+		iounmap(dev->regs.src.bar1);
+		dev->regs.src.bar1 = NULL;
 		return -1;
+	}
 	dev->IndexRegs = &((struct src_registers __iomem *)
 		dev->base)->u.denali.IndexRegs;
 	return 0;
@@ -918,9 +938,9 @@ int aac_srcv_init(struct aac_dev *dev)
 	if (aac_acquire_irq(dev))
 		goto error_iounmap;
 
-	dev->dbg_base = dev->base_start;
-	dev->dbg_base_mapped = dev->base;
-	dev->dbg_size = dev->base_size;
+	dev->dbg_base = pci_resource_start(dev->pdev, 2);
+	dev->dbg_base_mapped = dev->regs.src.bar1;
+	dev->dbg_size = AAC_MIN_SRCV_BAR1_SIZE;
 	dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 
 	aac_adapter_enable_int(dev);
-- 
2.7.4

