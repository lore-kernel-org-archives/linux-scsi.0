From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl
	processing
Date: Tue, 06 Feb 2007 14:19:54 -0800
Message-ID: <1170800394.10482.41.camel@dumbo>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-8h0Eo/Ows9Texrd6TT4X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34555 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXBGDaS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Feb 2007 22:30:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


--=-8h0Eo/Ows9Texrd6TT4X
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Preallocate memory for ioctl processing. This is to avoid situations 
where ioctl fails for lack of memory (when system under heavy stress).
The memory pool will have 8*4K, 4*8K and 1*64K memory chunks

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>

 drivers/scsi/megaraid/megaraid_sas.c |  257 ++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   32 ++-
 2 files changed, 276 insertions(+), 13 deletions(-)

diff -uprN 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:50:40.000000000 -0800
+++ 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:12:42.000000000 -0800
@@ -74,6 +74,14 @@ static DEFINE_MUTEX(megasas_async_queue_
 
 static u32 megasas_dbg_lvl;
 
+/* For IOCTL mem pool */
+int arr[MAX_IOCTL_MEM_POOL] = {MAX_4K_BUFF,MAX_8K_BUFF,MAX_64K_BUFF};
+
+int arr_size[MAX_IOCTL_MEM_POOL] =
+			{MEGASAS_INIT_IOCTL_MEM_SIZE/* 4k */,
+			2*MEGASAS_INIT_IOCTL_MEM_SIZE/* 8k */,
+			16*MEGASAS_INIT_IOCTL_MEM_SIZE/* 64k */};
+
 /**
  * megasas_get_cmd -	Get a command from the free pool
  * @instance:		Adapter soft state
@@ -1805,6 +1813,194 @@ megasas_get_ctrl_info(struct megasas_ins
 }
 
 /**
+ * megasas_get_ioctl_mem -	Get a buff from the free ioctl memory pool
+ * @instance:			Adapter soft state
+ * @i:				mem pool index
+ *
+ * Returns a free buff from the pool
+ */
+static inline struct megasas_ioctl_mm *
+megasas_get_ioctl_mem(struct megasas_instance* instance, u8 i)
+{
+	unsigned long flags;
+	struct megasas_ioctl_mm *ioctl_mm = NULL;
+
+	if(i >= MAX_IOCTL_MEM_POOL)
+		goto out;
+
+	spin_lock_irqsave(&instance->ioctl_memory_pool_lock, flags);
+
+	if (!list_empty(&instance->ioctl_memory_pool[i])) {
+		ioctl_mm = list_entry((&instance->ioctl_memory_pool[i])->next,
+				 struct megasas_ioctl_mm, list);
+		list_del_init(&ioctl_mm->list);
+	} else
+		printk(KERN_DEBUG "megasas: ioctl memory pool empty!\n");
+
+	spin_unlock_irqrestore(&instance->ioctl_memory_pool_lock, flags);
+out:
+	return ioctl_mm;
+}
+
+/**
+ * megasas_return_ioctl_mm -	Return memory to ioctl memory pool
+ * @instance:			Adapter soft state
+ * @megasas_ioctl_mm:		ioctl mem block
+ * @i:				mem_pool_index
+ */
+static inline void
+megasas_return_ioctl_mem(struct megasas_instance *instance,
+			struct megasas_ioctl_mm *ioctl_mm, u8 i)
+{
+	unsigned long flags;
+	if(!ioctl_mm){
+		printk(KERN_DEBUG "megasas: Trying to return "
+					"NULL to mem_pool\n");
+		return;
+	}
+	spin_lock_irqsave(&instance->ioctl_memory_pool_lock, flags);
+	list_add_tail(&ioctl_mm->list, &instance->ioctl_memory_pool[i]);
+	spin_unlock_irqrestore(&instance->ioctl_memory_pool_lock, flags);
+}
+
+/**
+ * megasas_free_ioctl_mem_pools - Free all the memory in the ioctl memory pool
+ * @instance:			Adapter soft state
+ */
+static void
+megasas_free_ioctl_mem_pools(struct megasas_instance *instance)
+{
+	struct megasas_ioctl_mm	*ioctl_mm;
+	u32 i,j;
+	u32 mem_size;
+	if(instance->mem_pool_empty)
+		return;
+	for (i=0; i < MAX_IOCTL_MEM_POOL; i++) {
+		mem_size = arr_size[i];
+		for (j = 0; j < arr[i]; j++) {
+			ioctl_mm = megasas_get_ioctl_mem(instance, i);
+
+			if (ioctl_mm){
+				if(ioctl_mm->vaddr)
+					pci_free_consistent(instance->pdev,
+							mem_size,
+							ioctl_mm->vaddr,
+						 	ioctl_mm->buf_handle);
+				kfree(ioctl_mm);
+			}
+		}
+	}
+}
+
+/**
+ * megasas_setup_mem_pools - Setup memory in the ioctl memory pool
+ * @instance:		Adapter soft state
+ *
+ * The memory pool will have 8x4K, 4*8K and 1x64K memory
+ * ioctl_memory_pool[0] ----> 4k memory list
+ * ioctl_memory_pool[1] ----> 8K memory list
+ * ioctl_memory_pool[2] ----> 64K memory list
+ */
+
+static int
+megasas_setup_mem_pools(struct megasas_instance *instance)
+{
+	struct megasas_ioctl_mm	*ioctl_mm;
+	dma_addr_t buf_handle;
+	void *vaddr;
+	u32 i, j;
+	u32 mem_size;
+	for (i=0; i < MAX_IOCTL_MEM_POOL; i++) {
+		mem_size = arr_size[i];
+
+		for (j = 0; j < arr[i]; j++) {
+
+			ioctl_mm = kmalloc(sizeof(struct megasas_ioctl_mm), GFP_KERNEL);	
+			if(!ioctl_mm){
+				printk(KERN_DEBUG "megasas:Failed to alloc "
+						"init memory for ioctl \n");
+				goto failed_to_alloc_mem_ioctl;
+			}
+			vaddr = pci_alloc_consistent(instance->pdev,mem_size,
+							    &buf_handle);
+			if (!vaddr) {
+				printk(KERN_DEBUG "megasas:Failed to alloc "
+						"memory for ioctl \n");
+				goto failed_to_alloc_mem_ioctl;
+			} else {
+				ioctl_mm->vaddr	= vaddr;
+				ioctl_mm->buf_handle = (u32)buf_handle;
+
+				list_add_tail(&ioctl_mm->list,
+					&instance->ioctl_memory_pool[i]);
+			}
+		}
+	}
+	return 0;
+failed_to_alloc_mem_ioctl:
+	megasas_free_ioctl_mem_pools(instance);
+	return 1;
+}
+
+/**
+ * megasas_get_buff_for_sge - Free all the memory in the ioctl memory pool
+ * @instance:		Adapter soft state
+ * @cmd:		megasas_cmd
+ */
+
+int
+megasas_get_buff_for_sge(struct megasas_iocpacket *ioc,
+			struct megasas_instance *instance,
+			struct megasas_cmd *cmd)
+{
+	int i,n;
+	u8 mem_type;
+	struct megasas_ioctl_mm* ioctl_mm;
+	if(instance->mem_pool_empty)
+		goto empty;
+	for (i = 0; i < ioc->sge_count; i++) {
+		/*
+		 * Check if we have buffer to use from our mem_pool
+		 * If we donot have enough to satisfy for all sge's then
+		 * free that has already been attached to the ioc
+		 */
+		mem_type=0xff;
+		if (ioc->sgl[i].iov_len <= MEGASAS_INIT_IOCTL_MEM_SIZE)
+			mem_type=0;
+		else if ((ioc->sgl[i].iov_len > MEGASAS_INIT_IOCTL_MEM_SIZE) &&
+			(ioc->sgl[i].iov_len <= 2*MEGASAS_INIT_IOCTL_MEM_SIZE))
+			mem_type=1;
+		else if ((ioc->sgl[i].iov_len > 2*MEGASAS_INIT_IOCTL_MEM_SIZE) &&
+			(ioc->sgl[i].iov_len <= 16*MEGASAS_INIT_IOCTL_MEM_SIZE))
+			mem_type=2;
+
+		ioctl_mm = megasas_get_ioctl_mem(instance, mem_type);
+			
+		if (ioctl_mm) {
+			cmd->ioctl_mem[i]=ioctl_mm;
+			cmd->ioctl_mem_pool_index[i] = mem_type;
+		} else
+			/* Not enough buffer in mem pool
+			 * Free all allocated buffer for this ioc
+			 */
+			goto out;
+	}
+	return 0;
+out:
+	for (n = 0; n < i; n++) {
+		if ((struct megasas_ioctl_mm *)cmd->ioctl_mem[i]) {
+			megasas_return_ioctl_mem(instance,
+				(struct megasas_ioctl_mm *)cmd->ioctl_mem[i],
+				cmd->ioctl_mem_pool_index[i]);
+			cmd->ioctl_mem[i]=NULL;
+			cmd->ioctl_mem_pool_index[i] = 0xff;
+		}
+	}
+empty:
+	return 1;
+}
+
+/**
  * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
  * @instance_addr:			Address of adapter soft state
  *
@@ -2310,7 +2506,7 @@ static int megasas_io_attach(struct mega
 static int __devinit
 megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int rval;
+	int rval,i;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -2396,10 +2592,23 @@ megasas_probe_one(struct pci_dev *pdev, 
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
+	spin_lock_init(&instance->ioctl_memory_pool_lock);
 
 	sema_init(&instance->aen_mutex, 1);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
+	/* 
+	 * for-ioctl: initialize ioctl memory list
+	 */
+	for (i=0; i<MAX_IOCTL_MEM_POOL; i++) {
+		INIT_LIST_HEAD(&instance->ioctl_memory_pool[i]);
+	}
+
+	if(megasas_setup_mem_pools(instance))
+		instance->mem_pool_empty=1;
+	
+	/* end for-ioctl */
+
 	/*
 	 * Initialize PCI related and misc parameters
 	 */
@@ -2472,6 +2681,8 @@ megasas_probe_one(struct pci_dev *pdev, 
       fail_irq:
       fail_init_mfi:
       fail_alloc_dma_buf:
+	/* Free ioctl mem pool */
+	megasas_free_ioctl_mem_pools(instance);
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
 				    instance->evt_detail,
@@ -2600,6 +2811,9 @@ static void megasas_detach_one(struct pc
 	free_irq(instance->pdev->irq, instance);
 
 	megasas_release_mfi(instance);
+	/* Free IOCTL mem pool */
+	megasas_free_ioctl_mem_pools(instance);
+
 
 	pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
 			    instance->evt_detail, instance->evt_detail_h);
@@ -2699,6 +2913,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	u32 *sense_ptr;
+	u8 from_pool = 0;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -2734,18 +2949,30 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	kern_sge32 = (struct megasas_sge32 *)
 	    ((unsigned long)cmd->frame + ioc->sgl_off);
 
+ 	/*
+	 * Check if we have buffer to use from our ioctl mem_pool
+	 * If we donot have then try to allocate new buffer
+	 */
+	if(!megasas_get_buff_for_sge(ioc,instance,cmd))
+		from_pool = 1;
+
 	/*
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
-		kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
+		if (from_pool) {
+			kbuff_arr[i] = cmd->ioctl_mem[i]->vaddr;
+			buf_handle = cmd->ioctl_mem[i]->buf_handle;
+		} else {
+			kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle);
-		if (!kbuff_arr[i]) {
-			printk(KERN_DEBUG "megasas: Failed to alloc "
-			       "kernel SGL buffer for IOCTL \n");
-			error = -ENOMEM;
-			goto out;
+			if (!kbuff_arr[i]) {
+				printk(KERN_DEBUG "megasas: Failed to alloc "
+					"kernel SGL buffer for IOCTL \n");
+				error = -ENOMEM;
+				goto out;
+			}
 		}
 
 		/*
@@ -2832,9 +3059,19 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		pci_free_consistent(instance->pdev,
-				    kern_sge32[i].length,
-				    kbuff_arr[i], kern_sge32[i].phys_addr);
+		if (from_pool) {
+			/* Return to the mem pool */
+			if ((struct megasas_ioctl_mm *)cmd->ioctl_mem[i]) {
+				megasas_return_ioctl_mem(instance,
+					(struct megasas_ioctl_mm *)cmd->ioctl_mem[i],
+					cmd->ioctl_mem_pool_index[i]);
+				cmd->ioctl_mem_pool_index[i]=0xff;
+				cmd->ioctl_mem[i]=NULL;
+			}
+		} else 
+			pci_free_consistent(instance->pdev,
+			    kern_sge32[i].length,
+			    kbuff_arr[i], kern_sge32[i].phys_addr);
 	}
 
 	megasas_return_cmd(instance, cmd);
diff -uprN 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 08:51:23.000000000 -0800
+++ 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 10:14:17.000000000 -0800
@@ -539,6 +539,17 @@ struct megasas_ctrl_info {
 
 #define MEGASAS_DBG_LVL				1
 
+/* 
+ * For ioctl memory manager
+ */
+
+#define MAX_IOCTL_MEM_POOL			3
+#define MEGASAS_INIT_IOCTL_MEM_SIZE		4096
+#define MAX_IOCTL_MEM_BLOCK			16
+#define MAX_4K_BUFF				8
+#define MAX_8K_BUFF				4
+#define MAX_64K_BUFF				1
+
 /*
  * When SCSI mid-layer calls driver's reset routine, driver waits for
  * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note
@@ -1059,6 +1070,12 @@ struct megasas_evt_detail {
 	u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
  };
 
+struct megasas_ioctl_mm {
+	void *vaddr;
+	dma_addr_t buf_handle;
+	struct list_head list;
+};
+
 struct megasas_instance {
 
 	u32 *producer;
@@ -1085,6 +1102,12 @@ struct megasas_instance {
 	struct dma_pool *frame_dma_pool;
 	struct dma_pool *sense_dma_pool;
 
+	/* ioctl memory */
+	struct list_head ioctl_memory_pool[MAX_IOCTL_MEM_POOL];
+	spinlock_t ioctl_memory_pool_lock;
+	u8 mem_pool_empty;
+	/* end :ioctl memory */
+
 	struct megasas_evt_detail *evt_detail;
 	dma_addr_t evt_detail_h;
 	struct megasas_cmd *aen_cmd;
@@ -1116,6 +1139,9 @@ struct megasas_instance {
 	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + 	\
 	scp->device->id
 
+#define MAX_MGMT_ADAPTERS		1024
+#define MAX_IOCTL_SGE			16
+
 struct megasas_cmd {
 
 	union megasas_frame *frame;
@@ -1132,10 +1158,10 @@ struct megasas_cmd {
 	struct scsi_cmnd *scmd;
 	struct megasas_instance *instance;
 	u32 frame_count;
-};
 
-#define MAX_MGMT_ADAPTERS		1024
-#define MAX_IOCTL_SGE			16
+	u8 ioctl_mem_pool_index[MAX_IOCTL_SGE]; /*0xff for not in use*/
+	struct megasas_ioctl_mm *ioctl_mem[MAX_IOCTL_SGE];
+};
 
 struct megasas_iocpacket {
 


--=-8h0Eo/Ows9Texrd6TT4X
Content-Disposition: attachment; filename=p4-ioctl_mm.patch
Content-Type: text/x-patch; name=p4-ioctl_mm.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:50:40.000000000 -0800
+++ 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:12:42.000000000 -0800
@@ -74,6 +74,14 @@ static DEFINE_MUTEX(megasas_async_queue_
 
 static u32 megasas_dbg_lvl;
 
+/* For IOCTL mem pool */
+int arr[MAX_IOCTL_MEM_POOL] = {MAX_4K_BUFF,MAX_8K_BUFF,MAX_64K_BUFF};
+
+int arr_size[MAX_IOCTL_MEM_POOL] =
+			{MEGASAS_INIT_IOCTL_MEM_SIZE/* 4k */,
+			2*MEGASAS_INIT_IOCTL_MEM_SIZE/* 8k */,
+			16*MEGASAS_INIT_IOCTL_MEM_SIZE/* 64k */};
+
 /**
  * megasas_get_cmd -	Get a command from the free pool
  * @instance:		Adapter soft state
@@ -1805,6 +1813,194 @@ megasas_get_ctrl_info(struct megasas_ins
 }
 
 /**
+ * megasas_get_ioctl_mem -	Get a buff from the free ioctl memory pool
+ * @instance:			Adapter soft state
+ * @i:				mem pool index
+ *
+ * Returns a free buff from the pool
+ */
+static inline struct megasas_ioctl_mm *
+megasas_get_ioctl_mem(struct megasas_instance* instance, u8 i)
+{
+	unsigned long flags;
+	struct megasas_ioctl_mm *ioctl_mm = NULL;
+
+	if(i >= MAX_IOCTL_MEM_POOL)
+		goto out;
+
+	spin_lock_irqsave(&instance->ioctl_memory_pool_lock, flags);
+
+	if (!list_empty(&instance->ioctl_memory_pool[i])) {
+		ioctl_mm = list_entry((&instance->ioctl_memory_pool[i])->next,
+				 struct megasas_ioctl_mm, list);
+		list_del_init(&ioctl_mm->list);
+	} else
+		printk(KERN_DEBUG "megasas: ioctl memory pool empty!\n");
+
+	spin_unlock_irqrestore(&instance->ioctl_memory_pool_lock, flags);
+out:
+	return ioctl_mm;
+}
+
+/**
+ * megasas_return_ioctl_mm -	Return memory to ioctl memory pool
+ * @instance:			Adapter soft state
+ * @megasas_ioctl_mm:		ioctl mem block
+ * @i:				mem_pool_index
+ */
+static inline void
+megasas_return_ioctl_mem(struct megasas_instance *instance,
+			struct megasas_ioctl_mm *ioctl_mm, u8 i)
+{
+	unsigned long flags;
+	if(!ioctl_mm){
+		printk(KERN_DEBUG "megasas: Trying to return "
+					"NULL to mem_pool\n");
+		return;
+	}
+	spin_lock_irqsave(&instance->ioctl_memory_pool_lock, flags);
+	list_add_tail(&ioctl_mm->list, &instance->ioctl_memory_pool[i]);
+	spin_unlock_irqrestore(&instance->ioctl_memory_pool_lock, flags);
+}
+
+/**
+ * megasas_free_ioctl_mem_pools - Free all the memory in the ioctl memory pool
+ * @instance:			Adapter soft state
+ */
+static void
+megasas_free_ioctl_mem_pools(struct megasas_instance *instance)
+{
+	struct megasas_ioctl_mm	*ioctl_mm;
+	u32 i,j;
+	u32 mem_size;
+	if(instance->mem_pool_empty)
+		return;
+	for (i=0; i < MAX_IOCTL_MEM_POOL; i++) {
+		mem_size = arr_size[i];
+		for (j = 0; j < arr[i]; j++) {
+			ioctl_mm = megasas_get_ioctl_mem(instance, i);
+
+			if (ioctl_mm){
+				if(ioctl_mm->vaddr)
+					pci_free_consistent(instance->pdev,
+							mem_size,
+							ioctl_mm->vaddr,
+						 	ioctl_mm->buf_handle);
+				kfree(ioctl_mm);
+			}
+		}
+	}
+}
+
+/**
+ * megasas_setup_mem_pools - Setup memory in the ioctl memory pool
+ * @instance:		Adapter soft state
+ *
+ * The memory pool will have 8x4K, 4*8K and 1x64K memory
+ * ioctl_memory_pool[0] ----> 4k memory list
+ * ioctl_memory_pool[1] ----> 8K memory list
+ * ioctl_memory_pool[2] ----> 64K memory list
+ */
+
+static int
+megasas_setup_mem_pools(struct megasas_instance *instance)
+{
+	struct megasas_ioctl_mm	*ioctl_mm;
+	dma_addr_t buf_handle;
+	void *vaddr;
+	u32 i, j;
+	u32 mem_size;
+	for (i=0; i < MAX_IOCTL_MEM_POOL; i++) {
+		mem_size = arr_size[i];
+
+		for (j = 0; j < arr[i]; j++) {
+
+			ioctl_mm = kmalloc(sizeof(struct megasas_ioctl_mm), GFP_KERNEL);	
+			if(!ioctl_mm){
+				printk(KERN_DEBUG "megasas:Failed to alloc "
+						"init memory for ioctl \n");
+				goto failed_to_alloc_mem_ioctl;
+			}
+			vaddr = pci_alloc_consistent(instance->pdev,mem_size,
+							    &buf_handle);
+			if (!vaddr) {
+				printk(KERN_DEBUG "megasas:Failed to alloc "
+						"memory for ioctl \n");
+				goto failed_to_alloc_mem_ioctl;
+			} else {
+				ioctl_mm->vaddr	= vaddr;
+				ioctl_mm->buf_handle = (u32)buf_handle;
+
+				list_add_tail(&ioctl_mm->list,
+					&instance->ioctl_memory_pool[i]);
+			}
+		}
+	}
+	return 0;
+failed_to_alloc_mem_ioctl:
+	megasas_free_ioctl_mem_pools(instance);
+	return 1;
+}
+
+/**
+ * megasas_get_buff_for_sge - Free all the memory in the ioctl memory pool
+ * @instance:		Adapter soft state
+ * @cmd:		megasas_cmd
+ */
+
+int
+megasas_get_buff_for_sge(struct megasas_iocpacket *ioc,
+			struct megasas_instance *instance,
+			struct megasas_cmd *cmd)
+{
+	int i,n;
+	u8 mem_type;
+	struct megasas_ioctl_mm* ioctl_mm;
+	if(instance->mem_pool_empty)
+		goto empty;
+	for (i = 0; i < ioc->sge_count; i++) {
+		/*
+		 * Check if we have buffer to use from our mem_pool
+		 * If we donot have enough to satisfy for all sge's then
+		 * free that has already been attached to the ioc
+		 */
+		mem_type=0xff;
+		if (ioc->sgl[i].iov_len <= MEGASAS_INIT_IOCTL_MEM_SIZE)
+			mem_type=0;
+		else if ((ioc->sgl[i].iov_len > MEGASAS_INIT_IOCTL_MEM_SIZE) &&
+			(ioc->sgl[i].iov_len <= 2*MEGASAS_INIT_IOCTL_MEM_SIZE))
+			mem_type=1;
+		else if ((ioc->sgl[i].iov_len > 2*MEGASAS_INIT_IOCTL_MEM_SIZE) &&
+			(ioc->sgl[i].iov_len <= 16*MEGASAS_INIT_IOCTL_MEM_SIZE))
+			mem_type=2;
+
+		ioctl_mm = megasas_get_ioctl_mem(instance, mem_type);
+			
+		if (ioctl_mm) {
+			cmd->ioctl_mem[i]=ioctl_mm;
+			cmd->ioctl_mem_pool_index[i] = mem_type;
+		} else
+			/* Not enough buffer in mem pool
+			 * Free all allocated buffer for this ioc
+			 */
+			goto out;
+	}
+	return 0;
+out:
+	for (n = 0; n < i; n++) {
+		if ((struct megasas_ioctl_mm *)cmd->ioctl_mem[i]) {
+			megasas_return_ioctl_mem(instance,
+				(struct megasas_ioctl_mm *)cmd->ioctl_mem[i],
+				cmd->ioctl_mem_pool_index[i]);
+			cmd->ioctl_mem[i]=NULL;
+			cmd->ioctl_mem_pool_index[i] = 0xff;
+		}
+	}
+empty:
+	return 1;
+}
+
+/**
  * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
  * @instance_addr:			Address of adapter soft state
  *
@@ -2310,7 +2506,7 @@ static int megasas_io_attach(struct mega
 static int __devinit
 megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int rval;
+	int rval,i;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -2396,10 +2592,23 @@ megasas_probe_one(struct pci_dev *pdev, 
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
+	spin_lock_init(&instance->ioctl_memory_pool_lock);
 
 	sema_init(&instance->aen_mutex, 1);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
+	/* 
+	 * for-ioctl: initialize ioctl memory list
+	 */
+	for (i=0; i<MAX_IOCTL_MEM_POOL; i++) {
+		INIT_LIST_HEAD(&instance->ioctl_memory_pool[i]);
+	}
+
+	if(megasas_setup_mem_pools(instance))
+		instance->mem_pool_empty=1;
+	
+	/* end for-ioctl */
+
 	/*
 	 * Initialize PCI related and misc parameters
 	 */
@@ -2472,6 +2681,8 @@ megasas_probe_one(struct pci_dev *pdev, 
       fail_irq:
       fail_init_mfi:
       fail_alloc_dma_buf:
+	/* Free ioctl mem pool */
+	megasas_free_ioctl_mem_pools(instance);
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
 				    instance->evt_detail,
@@ -2600,6 +2811,9 @@ static void megasas_detach_one(struct pc
 	free_irq(instance->pdev->irq, instance);
 
 	megasas_release_mfi(instance);
+	/* Free IOCTL mem pool */
+	megasas_free_ioctl_mem_pools(instance);
+
 
 	pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
 			    instance->evt_detail, instance->evt_detail_h);
@@ -2699,6 +2913,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	u32 *sense_ptr;
+	u8 from_pool = 0;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -2734,18 +2949,30 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	kern_sge32 = (struct megasas_sge32 *)
 	    ((unsigned long)cmd->frame + ioc->sgl_off);
 
+ 	/*
+	 * Check if we have buffer to use from our ioctl mem_pool
+	 * If we donot have then try to allocate new buffer
+	 */
+	if(!megasas_get_buff_for_sge(ioc,instance,cmd))
+		from_pool = 1;
+
 	/*
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
-		kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
+		if (from_pool) {
+			kbuff_arr[i] = cmd->ioctl_mem[i]->vaddr;
+			buf_handle = cmd->ioctl_mem[i]->buf_handle;
+		} else {
+			kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle);
-		if (!kbuff_arr[i]) {
-			printk(KERN_DEBUG "megasas: Failed to alloc "
-			       "kernel SGL buffer for IOCTL \n");
-			error = -ENOMEM;
-			goto out;
+			if (!kbuff_arr[i]) {
+				printk(KERN_DEBUG "megasas: Failed to alloc "
+					"kernel SGL buffer for IOCTL \n");
+				error = -ENOMEM;
+				goto out;
+			}
 		}
 
 		/*
@@ -2832,9 +3059,19 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		pci_free_consistent(instance->pdev,
-				    kern_sge32[i].length,
-				    kbuff_arr[i], kern_sge32[i].phys_addr);
+		if (from_pool) {
+			/* Return to the mem pool */
+			if ((struct megasas_ioctl_mm *)cmd->ioctl_mem[i]) {
+				megasas_return_ioctl_mem(instance,
+					(struct megasas_ioctl_mm *)cmd->ioctl_mem[i],
+					cmd->ioctl_mem_pool_index[i]);
+				cmd->ioctl_mem_pool_index[i]=0xff;
+				cmd->ioctl_mem[i]=NULL;
+			}
+		} else 
+			pci_free_consistent(instance->pdev,
+			    kern_sge32[i].length,
+			    kbuff_arr[i], kern_sge32[i].phys_addr);
 	}
 
 	megasas_return_cmd(instance, cmd);
diff -uprN 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 08:51:23.000000000 -0800
+++ 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 10:14:17.000000000 -0800
@@ -539,6 +539,17 @@ struct megasas_ctrl_info {
 
 #define MEGASAS_DBG_LVL				1
 
+/* 
+ * For ioctl memory manager
+ */
+
+#define MAX_IOCTL_MEM_POOL			3
+#define MEGASAS_INIT_IOCTL_MEM_SIZE		4096
+#define MAX_IOCTL_MEM_BLOCK			16
+#define MAX_4K_BUFF				8
+#define MAX_8K_BUFF				4
+#define MAX_64K_BUFF				1
+
 /*
  * When SCSI mid-layer calls driver's reset routine, driver waits for
  * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note
@@ -1059,6 +1070,12 @@ struct megasas_evt_detail {
 	u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
  };
 
+struct megasas_ioctl_mm {
+	void *vaddr;
+	dma_addr_t buf_handle;
+	struct list_head list;
+};
+
 struct megasas_instance {
 
 	u32 *producer;
@@ -1085,6 +1102,12 @@ struct megasas_instance {
 	struct dma_pool *frame_dma_pool;
 	struct dma_pool *sense_dma_pool;
 
+	/* ioctl memory */
+	struct list_head ioctl_memory_pool[MAX_IOCTL_MEM_POOL];
+	spinlock_t ioctl_memory_pool_lock;
+	u8 mem_pool_empty;
+	/* end :ioctl memory */
+
 	struct megasas_evt_detail *evt_detail;
 	dma_addr_t evt_detail_h;
 	struct megasas_cmd *aen_cmd;
@@ -1116,6 +1139,9 @@ struct megasas_instance {
 	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + 	\
 	scp->device->id
 
+#define MAX_MGMT_ADAPTERS		1024
+#define MAX_IOCTL_SGE			16
+
 struct megasas_cmd {
 
 	union megasas_frame *frame;
@@ -1132,10 +1158,10 @@ struct megasas_cmd {
 	struct scsi_cmnd *scmd;
 	struct megasas_instance *instance;
 	u32 frame_count;
-};
 
-#define MAX_MGMT_ADAPTERS		1024
-#define MAX_IOCTL_SGE			16
+	u8 ioctl_mem_pool_index[MAX_IOCTL_SGE]; /*0xff for not in use*/
+	struct megasas_ioctl_mm *ioctl_mem[MAX_IOCTL_SGE];
+};
 
 struct megasas_iocpacket {
 

--=-8h0Eo/Ows9Texrd6TT4X--

