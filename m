From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/11] mpt2sas: Create a pool of chain buffer instead of dedicated per IOs
Date: Sat, 13 Nov 2010 04:34:06 +0530
Message-ID: <20101112230357.GF853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:57853 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab0KLXqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:46:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Create a pool of chain buffers, instead of dedicated per IO:
This enahancment is to address memory allocation failure when asking
for more than 2300 IOs per host.   There is just not enough contiquious
DMA physical memory to make one single allocation to hold both message
frames and chain buffers when asking for more than 2300 request. In order
to address this problem we will have to allocate memory for each chain
buffer in a seperate individual memory allocation, placing each chain
element of 128 bytes onto a pool of available chains, which can be
shared amoung all request.
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 3a4404e..b3bd864 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -65,7 +65,6 @@
 static MPT_CALLBACK	mpt_callbacks[MPT_MAX_CALLBACKS];
 
 #define FAULT_POLLING_INTERVAL 1000 /* in milliseconds */
-#define MPT2SAS_MAX_REQUEST_QUEUE 600 /* maximum controller queue depth */
 
 static int max_queue_depth = -1;
 module_param(max_queue_depth, int, 0);
@@ -1497,6 +1496,7 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	unsigned long flags;
 	int i;
+	struct chain_tracker *chain_req, *next;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (smid >= ioc->hi_priority_smid) {
@@ -1519,6 +1519,14 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 
 	/* scsiio queue */
 	i = smid - 1;
+	if (!list_empty(&ioc->scsi_lookup[i].chain_list)) {
+		list_for_each_entry_safe(chain_req, next,
+		    &ioc->scsi_lookup[i].chain_list, tracker_list) {
+			list_del_init(&chain_req->tracker_list);
+			list_add_tail(&chain_req->tracker_list,
+			    &ioc->free_chain_list);
+		}
+	}
 	ioc->scsi_lookup[i].cb_idx = 0xFF;
 	ioc->scsi_lookup[i].scmd = NULL;
 	list_add_tail(&ioc->scsi_lookup[i].tracker_list,
@@ -1968,6 +1976,8 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 {
+	int i;
+
 	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
@@ -2032,6 +2042,20 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 	}
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
+	if (ioc->chain_lookup) {
+		for (i = 0; i < ioc->chain_depth; i++) {
+			if (ioc->chain_lookup[i].chain_buffer)
+				pci_pool_free(ioc->chain_dma_pool,
+				    ioc->chain_lookup[i].chain_buffer,
+				    ioc->chain_lookup[i].chain_buffer_dma);
+		}
+		if (ioc->chain_dma_pool)
+			pci_pool_destroy(ioc->chain_dma_pool);
+	}
+	if (ioc->chain_lookup) {
+		free_pages((ulong)ioc->chain_lookup, ioc->chain_pages);
+		ioc->chain_lookup = NULL;
+	}
 }
 
 
@@ -2053,6 +2077,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	u32 sz, total_sz;
 	u32 retry_sz;
 	u16 max_request_credit;
+	int i;
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
@@ -2070,14 +2095,11 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 
 	/* command line tunables  for max controller queue depth */
-	if (max_queue_depth != -1) {
+	if (max_queue_depth != -1)
 		max_request_credit = (max_queue_depth < facts->RequestCredit)
 		    ? max_queue_depth : facts->RequestCredit;
-	} else {
-		max_request_credit = (facts->RequestCredit >
-		    MPT2SAS_MAX_REQUEST_QUEUE) ? MPT2SAS_MAX_REQUEST_QUEUE :
-		    facts->RequestCredit;
-	}
+	else
+		max_request_credit = facts->RequestCredit;
 
 	ioc->hba_queue_depth = max_request_credit;
 	ioc->hi_priority_depth = facts->HighPriorityCredit;
@@ -2183,7 +2205,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	 * "frame for smid=0
 	 */
 	ioc->chain_depth = ioc->chains_needed_per_io * ioc->scsiio_depth;
-	sz = ((ioc->scsiio_depth + 1 + ioc->chain_depth) * ioc->request_sz);
+	sz = ((ioc->scsiio_depth + 1) * ioc->request_sz);
 
 	/* hi-priority queue */
 	sz += (ioc->hi_priority_depth * ioc->request_sz);
@@ -2224,19 +2246,11 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	ioc->internal_dma = ioc->hi_priority_dma + (ioc->hi_priority_depth *
 	    ioc->request_sz);
 
-	ioc->chain = ioc->internal + (ioc->internal_depth *
-	    ioc->request_sz);
-	ioc->chain_dma = ioc->internal_dma + (ioc->internal_depth *
-	    ioc->request_sz);
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "request pool(0x%p): "
 	    "depth(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name,
 	    ioc->request, ioc->hba_queue_depth, ioc->request_sz,
 	    (ioc->hba_queue_depth * ioc->request_sz)/1024));
-	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "chain pool(0x%p): depth"
-	    "(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name, ioc->chain,
-	    ioc->chain_depth, ioc->request_sz, ((ioc->chain_depth *
-	    ioc->request_sz))/1024));
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "request pool: dma(0x%llx)\n",
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
@@ -2255,6 +2269,38 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    "depth(%d)\n", ioc->name, ioc->request,
 	    ioc->scsiio_depth));
 
+	/* loop till the allocation succeeds */
+	do {
+		sz = ioc->chain_depth * sizeof(struct chain_tracker);
+		ioc->chain_pages = get_order(sz);
+		ioc->chain_lookup = (struct chain_tracker *)__get_free_pages(
+		    GFP_KERNEL, ioc->chain_pages);
+		if (ioc->chain_lookup == NULL)
+			ioc->chain_depth -= 100;
+	} while (ioc->chain_lookup == NULL);
+	ioc->chain_dma_pool = pci_pool_create("chain pool", ioc->pdev,
+	    ioc->request_sz, 16, 0);
+	if (!ioc->chain_dma_pool) {
+		printk(MPT2SAS_ERR_FMT "chain_dma_pool: pci_pool_create "
+		    "failed\n", ioc->name);
+		goto out;
+	}
+	for (i = 0; i < ioc->chain_depth; i++) {
+		ioc->chain_lookup[i].chain_buffer = pci_pool_alloc(
+		    ioc->chain_dma_pool , GFP_KERNEL,
+		    &ioc->chain_lookup[i].chain_buffer_dma);
+		if (!ioc->chain_lookup[i].chain_buffer) {
+			ioc->chain_depth = i;
+			goto chain_done;
+		}
+		total_sz += ioc->request_sz;
+	}
+chain_done:
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "chain pool depth"
+	    "(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name,
+	    ioc->chain_depth, ioc->request_sz, ((ioc->chain_depth *
+	    ioc->request_sz))/1024));
+
 	/* initialize hi-priority queue smid's */
 	ioc->hpr_lookup = kcalloc(ioc->hi_priority_depth,
 	    sizeof(struct request_tracker), GFP_KERNEL);
@@ -2404,7 +2450,6 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	return 0;
 
  out:
-	_base_release_memory_pools(ioc);
 	return -ENOMEM;
 }
 
@@ -3587,6 +3632,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	INIT_LIST_HEAD(&ioc->free_list);
 	smid = 1;
 	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
+		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].smid = smid;
 		ioc->scsi_lookup[i].scmd = NULL;
@@ -3613,6 +3659,13 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		list_add_tail(&ioc->internal_lookup[i].tracker_list,
 		    &ioc->internal_free_list);
 	}
+
+	/* chain pool */
+	INIT_LIST_HEAD(&ioc->free_chain_list);
+	for (i = 0; i < ioc->chain_depth; i++)
+		list_add_tail(&ioc->chain_lookup[i].tracker_list,
+		    &ioc->free_chain_list);
+
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	/* initialize Reply Free Queue */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 63f7a19..edf1a02 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -419,6 +419,18 @@ enum reset_type {
 };
 
 /**
+ * struct chain_tracker - firmware chain tracker
+ * @chain_buffer: chain buffer
+ * @chain_buffer_dma: physical address
+ * @tracker_list: list of free request (ioc->free_chain_list)
+ */
+struct chain_tracker {
+	void *chain_buffer;
+	dma_addr_t chain_buffer_dma;
+	struct list_head tracker_list;
+};
+
+/**
  * struct request_tracker - firmware request tracker
  * @smid: system message id
  * @scmd: scsi request pointer
@@ -430,6 +442,7 @@ struct request_tracker {
 	u16	smid;
 	struct scsi_cmnd *scmd;
 	u8	cb_idx;
+	struct list_head chain_list;
 	struct list_head tracker_list;
 };
 
@@ -704,8 +717,10 @@ struct MPT2SAS_ADAPTER {
 	wait_queue_head_t reset_wq;
 
 	/* chain */
-	u8		*chain;
-	dma_addr_t	chain_dma;
+	struct chain_tracker *chain_lookup;
+	struct list_head free_chain_list;
+	struct dma_pool *chain_dma_pool;
+	ulong		chain_pages;
 	u16 		max_sges_in_main_message;
 	u16		max_sges_in_chain_message;
 	u16		chains_needed_per_io;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..98dcf6b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -931,31 +931,32 @@ _scsih_scsi_lookup_find_by_lun(struct MPT2SAS_ADAPTER *ioc, int id,
 }
 
 /**
- * _scsih_get_chain_buffer_dma - obtain block of chains (dma address)
+ * _scsih_get_chain_buffer_tracker - obtain chain tracker
  * @ioc: per adapter object
- * @smid: system request message index
+ * @smid: smid associated to an IO request
  *
- * Returns phys pointer to chain buffer.
+ * Returns chain tracker(from ioc->free_chain_list)
  */
-static dma_addr_t
-_scsih_get_chain_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid)
+static struct chain_tracker *
+_scsih_get_chain_buffer_tracker(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
-	return ioc->chain_dma + ((smid - 1) * (ioc->request_sz *
-	    ioc->chains_needed_per_io));
-}
+	struct chain_tracker *chain_req;
+	unsigned long flags;
 
-/**
- * _scsih_get_chain_buffer - obtain block of chains assigned to a mf request
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns virt pointer to chain buffer.
- */
-static void *
-_scsih_get_chain_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid)
-{
-	return (void *)(ioc->chain + ((smid - 1) * (ioc->request_sz *
-	    ioc->chains_needed_per_io)));
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->free_chain_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		printk(MPT2SAS_WARN_FMT "chain buffers not available\n",
+		    ioc->name);
+		return NULL;
+	}
+	chain_req = list_entry(ioc->free_chain_list.next,
+	    struct chain_tracker, tracker_list);
+	list_del_init(&chain_req->tracker_list);
+	list_add_tail(&chain_req->tracker_list,
+	    &ioc->scsi_lookup[smid - 1].chain_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return chain_req;
 }
 
 /**
@@ -986,6 +987,7 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
 	u32 sgl_flags;
 	u32 sgl_flags_last_element;
 	u32 sgl_flags_end_buffer;
+	struct chain_tracker *chain_req;
 
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 
@@ -1033,8 +1035,11 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
 
 	/* initializing the chain flags and pointers */
 	chain_flags = MPI2_SGE_FLAGS_CHAIN_ELEMENT << MPI2_SGE_FLAGS_SHIFT;
-	chain = _scsih_get_chain_buffer(ioc, smid);
-	chain_dma = _scsih_get_chain_buffer_dma(ioc, smid);
+	chain_req = _scsih_get_chain_buffer_tracker(ioc, smid);
+	if (!chain_req)
+		return -1;
+	chain = chain_req->chain_buffer;
+	chain_dma = chain_req->chain_buffer_dma;
 	do {
 		sges_in_segment = (sges_left <=
 		    ioc->max_sges_in_chain_message) ? sges_left :
@@ -1070,8 +1075,11 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
 			sges_in_segment--;
 		}
 
-		chain_dma += ioc->request_sz;
-		chain += ioc->request_sz;
+		chain_req = _scsih_get_chain_buffer_tracker(ioc, smid);
+		if (!chain_req)
+			return -1;
+		chain = chain_req->chain_buffer;
+		chain_dma = chain_req->chain_buffer_dma;
 	} while (1);
 
 
