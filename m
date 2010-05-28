From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 5/6] cciss: add performant mode support
Date: Fri, 28 May 2010 15:17:12 -0500
Message-ID: <20100528201712.GD6989@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <scameron@beardog.cce.hp.com>
List-Id: linux-scsi@vger.kernel.org

Patch 5 of 6
This patch adds a mode of controller operation called Performant Mode. Even
though cciss has been deprecated in favor of hpsa there are new controllers
due out next year that HP must support in older vendor distros. Vendors
require all fixes/features be upstream. These new controllers support only
16 commands in simple mode but support up to 1024 in performant mode. This
requires us to add this support at this late date.

The performant mode transport minimizes host PCI accesses by performinf many
completions per read. PCI writes are posted so the host can write then
immediately get off the bus not waiting for the writwe to complete to the
target. In the context of performant mode the host read out to a controller
pulls all posted writes into host memory ensuring the reply queue is
coherent.

cciss: add performant mode support for Stars/Sirius

From: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>


cciss: add performant mode support for Stars/Sirius
---
 drivers/block/cciss.c      |  267 ++++++++++++++++++++++++++++++++++++--------
 drivers/block/cciss.h      |  109 +++++++++++++++++-
 drivers/block/cciss_cmd.h  |   34 +++++-
 drivers/block/cciss_scsi.c |    6 +
 4 files changed, 353 insertions(+), 63 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cd830cb..08a2e61 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -206,6 +206,11 @@ static void cciss_device_release(struct device *dev);
 static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
 static void cciss_free_drive_info(ctlr_info_t *h, int drv_index);
 
+/* performant mode helper functions */
+static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
+				int *bucket_map);
+static void cciss_put_controller_into_performant_mode(ctlr_info_t *h);
+
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
 #else
@@ -231,6 +236,16 @@ static const struct block_device_operations cciss_fops = {
 	.revalidate_disk = cciss_revalidate,
 };
 
+/* set_performant_mode: Modify the tag for cciss performant
+ * set bit 0 for pull model, bits 3-1 for block fetch
+ * register number
+ */
+static void set_performant_mode(ctlr_info_t *h, CommandList_struct *c)
+{
+	if (likely(h->transMethod == CFGTBL_Trans_Performant))
+		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
+}
+
 /*
  * Enqueuing and dequeuing functions for cmdlists.
  */
@@ -261,6 +276,7 @@ static void enqueue_cmd_and_start_io(ctlr_info_t *h,
 	CommandList_struct *c)
 {
 	unsigned long flags;
+	set_performant_mode(h, c);
 	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
@@ -350,6 +366,28 @@ static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 
 #ifdef CONFIG_PROC_FS
 
+static inline u32 next_command(ctlr_info_t *h)
+{
+	u32 a;
+
+	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+		return h->access.command_completed(h);
+
+	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
+		a = *(h->reply_pool_head); /* Next cmd in ring buffer */
+		(h->reply_pool_head)++;
+		h->commands_outstanding--;
+	} else {
+		a = FIFO_EMPTY;
+	}
+	/* Check for wraparound */
+	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
+		h->reply_pool_head = h->reply_pool;
+		h->reply_pool_wraparound ^= 1;
+	}
+	return a;
+}
+
 /*
  * Report information about this controller.
  */
@@ -377,7 +415,7 @@ static void cciss_seq_show_header(struct seq_file *seq)
 		h->product_name,
 		(unsigned long)h->board_id,
 		h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
-		h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
+		h->firm_ver[3], (unsigned int)h->intr[PERF_MODE_INT],
 		h->num_luns,
 		h->Qdepth, h->commands_outstanding,
 		h->maxQsinceinit, h->max_outstanding, h->maxSG);
@@ -3126,13 +3164,13 @@ after_error_processing:
 
 static inline u32 cciss_tag_contains_index(u32 tag)
 {
-#define DIRECT_LOOKUP_BIT 0x04
+#define DIRECT_LOOKUP_BIT 0x10
 	return tag & DIRECT_LOOKUP_BIT;
 }
 
 static inline u32 cciss_tag_to_index(u32 tag)
 {
-#define DIRECT_LOOKUP_SHIFT 3
+#define DIRECT_LOOKUP_SHIFT 5
 	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 
@@ -3262,9 +3300,12 @@ static void do_cciss_request(struct request_queue *q)
 			blk_rq_sectors(creq), seg, chained);
 #endif				/* CCISS_DEBUG */
 
-	c->Header.SGList = c->Header.SGTotal = seg + chained;
-	if (seg > h->max_cmd_sgentries)
+	c->Header.SGTotal = seg + chained;
+	if (seg <= h->max_cmd_sgentries)
+		c->Header.SGList = c->Header.SGTotal;
+	else
 		c->Header.SGList = h->max_cmd_sgentries;
+	set_performant_mode(h, c);
 
 	if (likely(blk_fs_request(creq))) {
 		if(h->cciss_read == CCISS_READ_10) {
@@ -3370,10 +3411,10 @@ static inline u32 process_indexed_cmd(ctlr_info_t *h, u32 raw_tag)
 
 	tag_index = cciss_tag_to_index(raw_tag);
 	if (bad_tag(h, tag_index, raw_tag))
-		return get_next_completion(h);
+		return next_command(h);
 	c = h->cmd_pool + tag_index;
 	finish_cmd(h, c, raw_tag);
-	return get_next_completion(h);
+	return next_command(h);
 }
 
 /* process completion of a non-indexed command */
@@ -3390,11 +3431,11 @@ static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
 		tag_masked = cciss_tag_discard_error_bits(tag);
 		if (busaddr_masked == tag_masked) {
 			finish_cmd(h, c, raw_tag);
-			return get_next_completion(h);
+			return next_command(h);
 		}
 	}
 	bad_tag(h, h->nr_cmds + 1, raw_tag);
-	return get_next_completion(h);
+	return next_command(h);
 }
 
 static irqreturn_t do_cciss_intx(int irq, void *dev_id)
@@ -3700,6 +3741,155 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 	return -1;
 }
 
+/* Fill in bucket_map[], given nsgs (the max number of
+ * scatter gather elements supported) and bucket[],
+ * which is an array of 8 integers.  The bucket[] array
+ * contains 8 different DMA transfer sizes (in 16
+ * byte increments) which the controller uses to fetch
+ * commands.  This function fills in bucket_map[], which
+ * maps a given number of scatter gather elements to one of
+ * the 8 DMA transfer sizes.  The point of it is to allow the
+ * controller to only do as much DMA as needed to fetch the
+ * command, with the DMA transfer size encoded in the lower
+ * bits of the command address.
+ */
+static void  calc_bucket_map(int bucket[], int num_buckets,
+	int nsgs, int *bucket_map)
+{
+	int i, j, b, size;
+
+	/* even a command with 0 SGs requires 4 blocks */
+#define MINIMUM_TRANSFER_BLOCKS 4
+#define NUM_BUCKETS 8
+	/* Note, bucket_map must have nsgs+1 entries. */
+	for (i = 0; i <= nsgs; i++) {
+		/* Compute size of a command with i SG entries */
+		size = i + MINIMUM_TRANSFER_BLOCKS;
+		b = num_buckets; /* Assume the biggest bucket */
+		/* Find the bucket that is just big enough */
+		for (j = 0; j < 8; j++) {
+			if (bucket[j] >= size) {
+				b = j;
+				break;
+			}
+		}
+		/* for a command with i SG entries, use bucket b. */
+		bucket_map[i] = b;
+	}
+}
+
+static void
+cciss_put_controller_into_performant_mode(ctlr_info_t *h)
+{
+	int l = 0;
+	__u32 trans_support;
+	__u32 trans_offset;
+			/*
+			 *  5 = 1 s/g entry or 4k
+			 *  6 = 2 s/g entry or 8k
+			 *  8 = 4 s/g entry or 16k
+			 * 10 = 6 s/g entry or 24k
+			 */
+	int bft[8] = { 5, 6, 8, 10, 12, 20, 28, MAXSGENTRIES + 4};
+	unsigned long register_value;
+
+	BUILD_BUG_ON(28 > MAXSGENTRIES + 4);
+
+	/* Attempt to put controller into performant mode if supported */
+	/* Does board support performant mode? */
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
+	printk(KERN_WARNING "cciss%d: Placing controller into "
+				"performant mode\n", h->ctlr);
+	/* Performant mode demands commands on a 32 byte boundary
+	 * pci_alloc_consistent aligns on page boundarys already.
+	 * Just need to check if divisible by 32
+	 */
+	if ((sizeof(CommandList_struct) % 32) != 0) {
+		printk(KERN_WARNING "%s %d %s\n",
+			"cciss info: command size[",
+			(int)sizeof(CommandList_struct),
+			"] not divisible by 32, no performant mode..\n");
+		return;
+	}
+
+	/* Performant mode ring buffer and supporting data structures */
+	h->reply_pool = (__u64 *)pci_alloc_consistent(
+		h->pdev, h->max_commands * sizeof(__u64),
+		&(h->reply_pool_dhandle));
+
+	/* Need a block fetch table for performant mode */
+	h->blockFetchTable = kmalloc(((h->maxsgentries+1) *
+		sizeof(__u32)), GFP_KERNEL);
+
+	if ((h->reply_pool == NULL) || (h->blockFetchTable == NULL))
+		goto clean_up;
+
+	h->reply_pool_wraparound = 1; /* spec: init to 1 */
+
+	/* Controller spec: zero out this buffer. */
+	memset(h->reply_pool, 0, h->max_commands * sizeof(__u64));
+	h->reply_pool_head = h->reply_pool;
+
+	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
+	calc_bucket_map(bft, ARRAY_SIZE(bft), h->maxsgentries,
+				h->blockFetchTable);
+	writel(bft[0], &h->transtable->BlockFetch0);
+	writel(bft[1], &h->transtable->BlockFetch1);
+	writel(bft[2], &h->transtable->BlockFetch2);
+	writel(bft[3], &h->transtable->BlockFetch3);
+	writel(bft[4], &h->transtable->BlockFetch4);
+	writel(bft[5], &h->transtable->BlockFetch5);
+	writel(bft[6], &h->transtable->BlockFetch6);
+	writel(bft[7], &h->transtable->BlockFetch7);
+
+	/* size of controller ring buffer */
+	writel(h->max_commands, &h->transtable->RepQSize);
+	writel(1, &h->transtable->RepQCount);
+	writel(0, &h->transtable->RepQCtrAddrLow32);
+	writel(0, &h->transtable->RepQCtrAddrHigh32);
+	writel(h->reply_pool_dhandle, &h->transtable->RepQAddr0Low32);
+	writel(0, &h->transtable->RepQAddr0High32);
+	writel(CFGTBL_Trans_Performant,
+			&(h->cfgtable->HostWrite.TransportRequest));
+
+	h->transMethod = CFGTBL_Trans_Performant;
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+	/* under certain very rare conditions, this can take awhile.
+	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
+	 * as we enter this code.) */
+	for (l = 0; l < MAX_CONFIG_WAIT; l++) {
+		register_value = readl(h->vaddr + SA5_DOORBELL);
+		if (!(register_value & CFGTBL_ChangeReq))
+			break;
+		/* delay and try again */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	register_value = readl(&(h->cfgtable->TransportActive));
+	if (!(register_value & CFGTBL_Trans_Performant)) {
+		printk(KERN_WARNING "cciss: unable to get board into"
+					" performant mode\n");
+		return;
+	}
+
+	/* Change the access methods to the performant access methods */
+	h->access = SA5_performant_access;
+
+	return;
+clean_up:
+	kfree(h->blockFetchTable);
+	if (h->reply_pool)
+		pci_free_consistent(h->pdev,
+				h->max_commands * sizeof(__u64),
+				h->reply_pool,
+				h->reply_pool_dhandle);
+	return;
+
+} /* cciss_put_controller_into_performant_mode */
+
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
  * controllers that are capable. If not, we use IO-APIC mode.
  */
@@ -3749,7 +3939,7 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c,
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	c->intr[SIMPLE_MODE_INT] = pdev->irq;
+	c->intr[PERF_MODE_INT] = pdev->irq;
 	return;
 }
 
@@ -3761,6 +3951,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	__u32 cfg_base_addr;
 	__u64 cfg_base_addr_index;
 	int i, prod_index, err;
+	__u32 trans_offset;
 
 	subsystem_vendor_id = pdev->subsystem_vendor;
 	subsystem_device_id = pdev->subsystem_device;
@@ -3874,11 +4065,16 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
 						       cfg_base_addr_index) +
 				    cfg_offset, sizeof(CfgTable_struct));
+	/* Find performant mode table. */
+	trans_offset = readl(&(c->cfgtable->TransMethodOffset));
+	c->transtable = remap_pci_mem(pci_resource_start(pdev,
+		cfg_base_addr_index) + cfg_offset+trans_offset,
+		sizeof(*c->transtable));
 	c->board_id = board_id;
 
-#ifdef CCISS_DEBUG
-	print_cfg_table(c->cfgtable);
-#endif				/* CCISS_DEBUG */
+	#ifdef CCISS_DEBUG
+		print_cfg_table(c->cfgtable);
+	#endif				/* CCISS_DEBUG */
 
 	/* Some controllers support Zero Memory Raid (ZMR).
 	 * When configured in ZMR mode the number of supported
@@ -3888,7 +4084,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	 * are supported on the controller then subtract 4 to
 	 * leave a little room for ioctl calls.
 	 */
-	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
+	c->max_commands = readl(&(c->cfgtable->MaxPerformantModeCommands));
 	c->maxsgentries = readl(&(c->cfgtable->MaxSGElements));
 
 	/*
@@ -3933,7 +4129,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	 * kernels revealed a bug in the refetch if dom0 resides on a P600.
 	 */
 	if(board_id == 0x3225103C) {
-		__u32 dma_prefetch;
+			__u32 dma_prefetch;
 		__u32 dma_refetch;
 		dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
 		dma_prefetch |= 0x8000;
@@ -3944,38 +4140,8 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	}
 
 #ifdef CCISS_DEBUG
-	printk("Trying to put board into Simple mode\n");
+	printk(KERN_WARNING "Trying to put board into Performant mode\n");
 #endif				/* CCISS_DEBUG */
-	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
-	/* Update the field, and then ring the doorbell */
-	writel(CFGTBL_Trans_Simple, &(c->cfgtable->HostWrite.TransportRequest));
-	writel(CFGTBL_ChangeReq, c->vaddr + SA5_DOORBELL);
-
-	/* under certain very rare conditions, this can take awhile.
-	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
-	 * as we enter this code.) */
-	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
-		if (!(readl(c->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
-			break;
-		/* delay and try again */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(msecs_to_jiffies(1));
-	}
-
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "I counter got to %d %x\n", i,
-	       readl(c->vaddr + SA5_DOORBELL));
-#endif				/* CCISS_DEBUG */
-#ifdef CCISS_DEBUG
-	print_cfg_table(c->cfgtable);
-#endif				/* CCISS_DEBUG */
-
-	if (!(readl(&(c->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
-		printk(KERN_WARNING "cciss: unable to get board into"
-		       " simple mode\n");
-		err = -ENODEV;
-		goto err_out_free_res;
-	}
 	return 0;
 
 err_out_free_res:
@@ -3984,6 +4150,7 @@ err_out_free_res:
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
 	pci_release_regions(pdev);
+	cciss_put_controller_into_performant_mode(c);
 	return err;
 }
 
@@ -4260,7 +4427,6 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	i = alloc_cciss_hba();
 	if (i < 0)
 		return -1;
-
 	hba[i]->busy_initializing = 1;
 	INIT_HLIST_HEAD(&hba[i]->cmpQ);
 	INIT_HLIST_HEAD(&hba[i]->reqQ);
@@ -4327,7 +4493,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	printk(KERN_INFO "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
 	       hba[i]->devname, pdev->device, pci_name(pdev),
-	       hba[i]->intr[SIMPLE_MODE_INT], dac ? "" : " not");
+	       hba[i]->intr[PERF_MODE_INT], dac ? "" : " not");
 
 	hba[i]->cmd_pool_bits =
 	    kmalloc(DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
@@ -4433,7 +4599,7 @@ clean4:
 				    hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
 				    hba[i]->errinfo_pool,
 				    hba[i]->errinfo_pool_dhandle);
-	free_irq(hba[i]->intr[SIMPLE_MODE_INT], hba[i]);
+	free_irq(hba[i]->intr[PERF_MODE_INT], hba[i]);
 clean2:
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
 clean1:
@@ -4475,7 +4641,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
 		printk(KERN_WARNING "cciss%d: Error flushing cache\n",
 			h->ctlr);
 	h->access.set_intr_mask(h, CCISS_INTR_OFF);
-	free_irq(h->intr[2], h);
+	free_irq(h->intr[PERF_MODE_INT], h);
 }
 
 static void __devexit cciss_remove_one(struct pci_dev *pdev)
@@ -4575,7 +4741,6 @@ static int __init cciss_init(void)
 	 * array of them, the size must be a multiple of 8 bytes.
 	 */
 	BUILD_BUG_ON(sizeof(CommandList_struct) % COMMANDLIST_ALIGNMENT);
-
 	printk(KERN_INFO DRIVER_NAME "\n");
 
 	err = bus_register(&cciss_bus_type);
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index c527932..8a9f5b5 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -85,8 +85,8 @@ struct ctlr_info
 	int	max_cmd_sgentries;
 	SGDescriptor_struct **cmd_sg_list;
 
-#	define DOORBELL_INT	0
-#	define PERF_MODE_INT	1
+#	define PERF_MODE_INT	0
+#	define DOORBELL_INT	1
 #	define SIMPLE_MODE_INT	2
 #	define MEMQ_MODE_INT	3
 	unsigned int intr[4];
@@ -137,10 +137,27 @@ struct ctlr_info
 	struct list_head scan_list;
 	struct completion scan_wait;
 	struct device dev;
+	/*
+	 * Performant mode tables.
+	 */
+	u32 trans_support;
+	u32 trans_offset;
+	struct TransTable_struct *transtable;
+	unsigned long transMethod;
+
+	/*
+	 * Performant mode completion buffer
+	 */
+	u64 *reply_pool;
+	dma_addr_t reply_pool_dhandle;
+	u64 *reply_pool_head;
+	size_t reply_pool_size;
+	unsigned char reply_pool_wraparound;
+	u32 *blockFetchTable;
 };
 
-/*  Defining the diffent access_menthods */
-/*
+/*  Defining the diffent access_methods
+ *
  * Memory mapped FIFO interface (SMART 53xx cards)
  */
 #define SA5_DOORBELL	0x20
@@ -159,6 +176,15 @@ struct ctlr_info
 #define SA5B_INTR_PENDING	0x04
 #define FIFO_EMPTY		0xffffffff	
 #define CCISS_FIRMWARE_READY	0xffff0000 /* value in scratchpad register */
+/* Perf. mode flags */
+#define SA5_PERF_INTR_PENDING	0x04
+#define SA5_PERF_INTR_OFF	0x05
+#define SA5_OUTDB_STATUS_PERF_BIT	0x01
+#define SA5_OUTDB_CLEAR_PERF_BIT	0x01
+#define SA5_OUTDB_CLEAR         0xA0
+#define SA5_OUTDB_CLEAR_PERF_BIT        0x01
+#define SA5_OUTDB_STATUS        0x9C
+
 
 #define  CISS_ERROR_BIT		0x02
 
@@ -170,8 +196,9 @@ struct ctlr_info
 static void SA5_submit_command( ctlr_info_t *h, CommandList_struct *c) 
 {
 #ifdef CCISS_DEBUG
-	 printk("Sending %x - down to controller\n", c->busaddr );
-#endif /* CCISS_DEBUG */ 
+	printk(KERN_WARNING "cciss%d: Sending %08x - down to controller\n",
+			h->ctlr, c->busaddr);
+#endif /* CCISS_DEBUG */
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
@@ -214,6 +241,20 @@ static void SA5B_intr_mask(ctlr_info_t *h, unsigned long val)
                         h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
         }
 }
+
+/* Performant mode intr_mask */
+static void SA5_performant_intr_mask(ctlr_info_t *h, unsigned long val)
+{
+	if (val) { /* turn on interrupts */
+		h->interrupts_enabled = 1;
+		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	} else {
+		h->interrupts_enabled = 0;
+		writel(SA5_PERF_INTR_OFF,
+				h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	}
+}
+
 /*
  *  Returns true if fifo is full.  
  * 
@@ -250,6 +291,40 @@ static unsigned long SA5_completed(ctlr_info_t *h)
 	return ( register_value); 
 
 }
+
+/* Performant mode command completed */
+static unsigned long SA5_performant_completed(ctlr_info_t *h)
+{
+	unsigned long register_value = FIFO_EMPTY;
+
+	/* flush the controller write of the reply queue by reading
+	 * outbound doorbell status register.
+	 */
+	register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
+	/* msi auto clears the interrupt pending bit. */
+	if (!(h->msi_vector || h->msix_vector)) {
+		writel(SA5_OUTDB_CLEAR_PERF_BIT, h->vaddr + SA5_OUTDB_CLEAR);
+		/* Do a read in order to flush the write to the controller
+		 * (as per spec.)
+		 */
+		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
+	}
+
+	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
+		register_value = *(h->reply_pool_head);
+		(h->reply_pool_head)++;
+		h->commands_outstanding--;
+	} else {
+		register_value = FIFO_EMPTY;
+	}
+	/* Check for wraparound */
+	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
+		h->reply_pool_head = h->reply_pool;
+		h->reply_pool_wraparound ^= 1;
+	}
+
+	return register_value;
+}
 /*
  *	Returns true if an interrupt is pending.. 
  */
@@ -280,6 +355,20 @@ static bool SA5B_intr_pending(ctlr_info_t *h)
         return 0 ;
 }
 
+static bool SA5_performant_intr_pending(ctlr_info_t *h)
+{
+	unsigned long register_value = readl(h->vaddr + SA5_INTR_STATUS);
+
+	if (!register_value)
+		return false;
+
+	if (h->msi_vector || h->msix_vector)
+		return true;
+
+	/* Read outbound doorbell to flush */
+	register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
+	return register_value & SA5_OUTDB_STATUS_PERF_BIT;
+}
 
 static struct access_method SA5_access = {
 	SA5_submit_command,
@@ -297,6 +386,14 @@ static struct access_method SA5B_access = {
         SA5_completed,
 };
 
+static struct access_method SA5_performant_access = {
+	SA5_submit_command,
+	SA5_performant_intr_mask,
+	SA5_fifo_full,
+	SA5_performant_intr_pending,
+	SA5_performant_completed,
+};
+
 struct board_type {
 	__u32	board_id;
 	char	*product_name;
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index e624ff9..eda6a8e 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -54,6 +54,7 @@
 #define CFGTBL_AccCmds          0x00000001l
 
 #define CFGTBL_Trans_Simple     0x00000002l
+#define CFGTBL_Trans_Performant 0x00000004l
 
 #define CFGTBL_BusType_Ultra2   0x00000001l
 #define CFGTBL_BusType_Ultra3   0x00000002l
@@ -173,12 +174,15 @@ typedef struct _SGDescriptor_struct {
  * PAD_64 can be adjusted independently as needed for 32-bit
  * and 64-bits systems.
  */
-#define COMMANDLIST_ALIGNMENT (8)
+#define COMMANDLIST_ALIGNMENT (32)
 #define IS_64_BIT ((sizeof(long) - 4)/4)
 #define IS_32_BIT (!IS_64_BIT)
-#define PAD_32 (0)
+#define PAD_32 (32)
 #define PAD_64 (4)
 #define PADSIZE (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
+#define DIRECT_LOOKUP_BIT 0x10
+#define DIRECT_LOOKUP_SHIFT 5
+
 typedef struct _CommandList_struct {
   CommandListHeader_struct Header;
   RequestBlock_struct      Request;
@@ -195,7 +199,7 @@ typedef struct _CommandList_struct {
   struct completion *waiting;
   int	 retry_count;
   void * scsi_cmd;
-  char   pad[PADSIZE];
+  char pad[PADSIZE];
 } CommandList_struct;
 
 /* Configuration Table Structure */
@@ -209,12 +213,15 @@ typedef struct _HostWrite_struct {
 typedef struct _CfgTable_struct {
   BYTE             Signature[4];
   DWORD            SpecValence;
+#define SIMPLE_MODE	0x02
+#define PERFORMANT_MODE	0x04
+#define MEMQ_MODE	0x08
   DWORD            TransportSupport;
   DWORD            TransportActive;
   HostWrite_struct HostWrite;
   DWORD            CmdsOutMax;
   DWORD            BusTypes;
-  DWORD            Reserved; 
+  DWORD            TransMethodOffset;
   BYTE             ServerName[16];
   DWORD            HeartBeat;
   DWORD            SCSI_Prefetch;
@@ -222,6 +229,25 @@ typedef struct _CfgTable_struct {
   DWORD            MaxLogicalUnits;
   DWORD            MaxPhysicalDrives;
   DWORD            MaxPhysicalDrivesPerLogicalUnit;
+  DWORD            MaxPerformantModeCommands;
 } CfgTable_struct;
+
+struct TransTable_struct {
+  u32 BlockFetch0;
+  u32 BlockFetch1;
+  u32 BlockFetch2;
+  u32 BlockFetch3;
+  u32 BlockFetch4;
+  u32 BlockFetch5;
+  u32 BlockFetch6;
+  u32 BlockFetch7;
+  u32 RepQSize;
+  u32 RepQCount;
+  u32 RepQCtrAddrLow32;
+  u32 RepQCtrAddrHigh32;
+  u32 RepQAddr0Low32;
+  u32 RepQAddr0High32;
+};
+
 #pragma pack()	 
 #endif /* CCISS_CMD_H */
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e1d0e2c..df26a4f 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -93,8 +93,8 @@ static struct scsi_host_template cciss_driver_template = {
 
 #pragma pack(1)
 
-#define SCSI_PAD_32 0
-#define SCSI_PAD_64 0
+#define SCSI_PAD_32 8
+#define SCSI_PAD_64 8
 
 struct cciss_scsi_cmd_stack_elem_t {
 	CommandList_struct cmd;
@@ -213,6 +213,8 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 
 	/* Check alignment, see cciss_cmd.h near CommandList_struct def. */
 	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
+	/* printk(KERN_WARNING "cciss_scsi.c: 0x%08x 0x%08x 0x%08x\n",
+			0xdeadbeef, sizeof(*stk->pool), 0xbeefdead); */
 	/* pci_alloc_consistent guarantees 32-bit DMA address will be used */
 	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
 		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
