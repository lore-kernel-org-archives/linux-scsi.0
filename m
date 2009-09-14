From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/9] mpt2sas: Added SCSIIO, Internal and high priority memory pools to support multiple TM
Date: Mon, 14 Sep 2009 11:02:48 +0530
Message-ID: <20090914053237.GF31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:46729 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbZINFzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 01:55:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1) create a pool of high priority message frames in the region of memory
between message frames and chains.  The modifications are in
_base_allocate_memory_pools.  Also create a seperate pool of memory for
internal commands located near the same region of memory.  The pool of high
priority message frames is restriced by the facts->HighPriorityCredit.

2) Create additional API for accessing request message frames. New function
mpt2sas_base_get_smid_hpr is for highpriority request. New function
mpt2sas_base_get_smid_scsiio for SCSI_IO, passing in the scsi command
pointer.  The mpt2sas_base_get_smid function is for requesting internal
commands.

3) Added new function _base_get_cb_idx to obtain the callback
index from one of the three pools of request message frames.

4) Removed wrapper functions _scsih_scsi_lookup_set and
_scsih_scsi_lookup_getclear. These were removed because this handling was
moved into mpt2sas_base_get_smid_scsiio and mpt2sas_base_free_smid.

5) The function mpt2sas_base_free_smid is modified so the request message
frames are put back on one of the three pools of request message frames.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 675a049..4c583ff 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -63,7 +63,7 @@
 static MPT_CALLBACK	mpt_callbacks[MPT_MAX_CALLBACKS];
 
 #define FAULT_POLLING_INTERVAL 1000 /* in milliseconds */
-#define MPT2SAS_MAX_REQUEST_QUEUE 500 /* maximum controller queue depth */
+#define MPT2SAS_MAX_REQUEST_QUEUE 600 /* maximum controller queue depth */
 
 static int max_queue_depth = -1;
 module_param(max_queue_depth, int, 0);
@@ -650,6 +650,34 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 }
 
 /**
+ * _base_get_cb_idx - obtain the callback index
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return callback index.
+ */
+static u8
+_base_get_cb_idx(struct MPT2SAS_ADAPTER *ioc, u16 smid)
+{
+	int i;
+	u8 cb_idx = 0xFF;
+
+	if (smid >= ioc->hi_priority_smid) {
+		if (smid < ioc->internal_smid) {
+			i = smid - ioc->hi_priority_smid;
+			cb_idx = ioc->hpr_lookup[i].cb_idx;
+		} else {
+			i = smid - ioc->internal_smid;
+			cb_idx = ioc->internal_lookup[i].cb_idx;
+		}
+	} else {
+		i = smid - 1;
+		cb_idx = ioc->scsi_lookup[i].cb_idx;
+	}
+	return cb_idx;
+}
+
+/**
  * _base_mask_interrupts - disable interrupts
  * @ioc: pointer to scsi command object
  *
@@ -747,9 +775,10 @@ _base_interrupt(int irq, void *bus_id)
 		    MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS)
 			goto next;
 		if (smid)
-			cb_idx = ioc->scsi_lookup[smid - 1].cb_idx;
+			cb_idx = _base_get_cb_idx(ioc, smid);
 		if (smid && cb_idx != 0xFF) {
-			mpt_callbacks[cb_idx](ioc, smid, msix_index, reply);
+			mpt_callbacks[cb_idx](ioc, smid, msix_index,
+			    reply);
 			if (reply)
 				_base_display_reply_info(ioc, smid, msix_index,
 				    reply);
@@ -1193,19 +1222,6 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt2sas_base_get_msg_frame_dma - obtain request mf pointer phys addr
- * @ioc: per adapter object
- * @smid: system request message index(smid zero is invalid)
- *
- * Returns phys pointer to message frame.
- */
-dma_addr_t
-mpt2sas_base_get_msg_frame_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid)
-{
-	return ioc->request_dma + (smid * ioc->request_sz);
-}
-
-/**
  * mpt2sas_base_get_msg_frame - obtain request mf pointer
  * @ioc: per adapter object
  * @smid: system request message index(smid zero is invalid)
@@ -1260,7 +1276,7 @@ mpt2sas_base_get_reply_virt_addr(struct MPT2SAS_ADAPTER *ioc, u32 phys_addr)
 }
 
 /**
- * mpt2sas_base_get_smid - obtain a free smid
+ * mpt2sas_base_get_smid - obtain a free smid from internal queue
  * @ioc: per adapter object
  * @cb_idx: callback index
  *
@@ -1274,6 +1290,39 @@ mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
 	u16 smid;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->internal_free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: smid not available\n",
+		    ioc->name, __func__);
+		return 0;
+	}
+
+	request = list_entry(ioc->internal_free_list.next,
+	    struct request_tracker, tracker_list);
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt2sas_base_get_smid_scsiio - obtain a free smid from scsiio queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ * @scmd: pointer to scsi command object
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
+    struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct request_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->free_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		printk(MPT2SAS_ERR_FMT "%s: smid not available\n",
@@ -1283,6 +1332,36 @@ mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
 
 	request = list_entry(ioc->free_list.next,
 	    struct request_tracker, tracker_list);
+	request->scmd = scmd;
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt2sas_base_get_smid_hpr - obtain a free smid from hi-priority queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
+{
+	unsigned long flags;
+	struct request_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->hpr_free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		return 0;
+	}
+
+	request = list_entry(ioc->hpr_free_list.next,
+	    struct request_tracker, tracker_list);
 	request->cb_idx = cb_idx;
 	smid = request->smid;
 	list_del(&request->tracker_list);
@@ -1302,10 +1381,32 @@ void
 mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	ioc->scsi_lookup[smid - 1].cb_idx = 0xFF;
-	list_add_tail(&ioc->scsi_lookup[smid - 1].tracker_list,
+	if (smid >= ioc->hi_priority_smid) {
+		if (smid < ioc->internal_smid) {
+			/* hi-priority */
+			i = smid - ioc->hi_priority_smid;
+			ioc->hpr_lookup[i].cb_idx = 0xFF;
+			list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+			    &ioc->hpr_free_list);
+		} else {
+			/* internal queue */
+			i = smid - ioc->internal_smid;
+			ioc->internal_lookup[i].cb_idx = 0xFF;
+			list_add_tail(&ioc->internal_lookup[i].tracker_list,
+			    &ioc->internal_free_list);
+		}
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		return;
+	}
+
+	/* scsiio queue */
+	i = smid - 1;
+	ioc->scsi_lookup[i].cb_idx = 0xFF;
+	ioc->scsi_lookup[i].scmd = NULL;
+	list_add_tail(&ioc->scsi_lookup[i].tracker_list,
 	    &ioc->free_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
@@ -1713,6 +1814,8 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 	}
 
 	kfree(ioc->scsi_lookup);
+	kfree(ioc->hpr_lookup);
+	kfree(ioc->internal_lookup);
 }
 
 
@@ -1732,7 +1835,6 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	u16 num_of_reply_frames;
 	u16 chains_needed_per_io;
 	u32 sz, total_sz;
-	u16 i;
 	u32 retry_sz;
 	u16 max_request_credit;
 
@@ -1760,7 +1862,10 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		    MPT2SAS_MAX_REQUEST_QUEUE) ? MPT2SAS_MAX_REQUEST_QUEUE :
 		    facts->RequestCredit;
 	}
-	ioc->request_depth = max_request_credit;
+
+	ioc->hba_queue_depth = max_request_credit;
+	ioc->hi_priority_depth = facts->HighPriorityCredit;
+	ioc->internal_depth = ioc->hi_priority_depth + 5;
 
 	/* request frame size */
 	ioc->request_sz = facts->IOCRequestFrameSize * 4;
@@ -1798,7 +1903,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	ioc->chains_needed_per_io = chains_needed_per_io;
 
 	/* reply free queue sizing - taking into account for events */
-	num_of_reply_frames = ioc->request_depth + 32;
+	num_of_reply_frames = ioc->hba_queue_depth + 32;
 
 	/* number of replies frames can't be a multiple of 16 */
 	/* decrease number of reply frames by 1 */
@@ -1819,7 +1924,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	 * frames
 	 */
 
-	queue_size = ioc->request_depth + num_of_reply_frames + 1;
+	queue_size = ioc->hba_queue_depth + num_of_reply_frames + 1;
 	/* round up to 16 byte boundary */
 	if (queue_size % 16)
 		queue_size += 16 - (queue_size % 16);
@@ -1833,60 +1938,85 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		if (queue_diff % 16)
 			queue_diff += 16 - (queue_diff % 16);
 
-		/* adjust request_depth, reply_free_queue_depth,
+		/* adjust hba_queue_depth, reply_free_queue_depth,
 		 * and queue_size
 		 */
-		ioc->request_depth -= queue_diff;
+		ioc->hba_queue_depth -= queue_diff;
 		ioc->reply_free_queue_depth -= queue_diff;
 		queue_size -= queue_diff;
 	}
 	ioc->reply_post_queue_depth = queue_size;
 
-	/* max scsi host queue depth */
-	ioc->shost->can_queue = ioc->request_depth - INTERNAL_CMDS_COUNT;
-	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host queue: depth"
-	    "(%d)\n", ioc->name, ioc->shost->can_queue));
-
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scatter gather: "
 	    "sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), "
 	    "chains_per_io(%d)\n", ioc->name, ioc->max_sges_in_main_message,
 	    ioc->max_sges_in_chain_message, ioc->shost->sg_tablesize,
 	    ioc->chains_needed_per_io));
 
+	ioc->scsiio_depth = ioc->hba_queue_depth -
+	    ioc->hi_priority_depth - ioc->internal_depth;
+
+	/* set the scsi host can_queue depth
+	 * with some internal commands that could be outstanding
+	 */
+	ioc->shost->can_queue = ioc->scsiio_depth - (2);
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
+	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
+
 	/* contiguous pool for request and chains, 16 byte align, one extra "
 	 * "frame for smid=0
 	 */
-	ioc->chain_depth = ioc->chains_needed_per_io * ioc->request_depth;
-	sz = ((ioc->request_depth + 1 + ioc->chain_depth) * ioc->request_sz);
+	ioc->chain_depth = ioc->chains_needed_per_io * ioc->scsiio_depth;
+	sz = ((ioc->scsiio_depth + 1 + ioc->chain_depth) * ioc->request_sz);
+
+	/* hi-priority queue */
+	sz += (ioc->hi_priority_depth * ioc->request_sz);
+
+	/* internal queue */
+	sz += (ioc->internal_depth * ioc->request_sz);
 
 	ioc->request_dma_sz = sz;
 	ioc->request = pci_alloc_consistent(ioc->pdev, sz, &ioc->request_dma);
 	if (!ioc->request) {
 		printk(MPT2SAS_ERR_FMT "request pool: pci_alloc_consistent "
-		    "failed: req_depth(%d), chains_per_io(%d), frame_sz(%d), "
-		    "total(%d kB)\n", ioc->name, ioc->request_depth,
+		    "failed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), "
+		    "total(%d kB)\n", ioc->name, ioc->hba_queue_depth,
 		    ioc->chains_needed_per_io, ioc->request_sz, sz/1024);
-		if (ioc->request_depth < MPT2SAS_SAS_QUEUE_DEPTH)
+		if (ioc->scsiio_depth < MPT2SAS_SAS_QUEUE_DEPTH)
 			goto out;
 		retry_sz += 64;
-		ioc->request_depth = max_request_credit - retry_sz;
+		ioc->hba_queue_depth = max_request_credit - retry_sz;
 		goto retry_allocation;
 	}
 
 	if (retry_sz)
 		printk(MPT2SAS_ERR_FMT "request pool: pci_alloc_consistent "
-		    "succeed: req_depth(%d), chains_per_io(%d), frame_sz(%d), "
-		    "total(%d kb)\n", ioc->name, ioc->request_depth,
+		    "succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), "
+		    "total(%d kb)\n", ioc->name, ioc->hba_queue_depth,
 		    ioc->chains_needed_per_io, ioc->request_sz, sz/1024);
 
-	ioc->chain = ioc->request + ((ioc->request_depth + 1) *
+
+	/* hi-priority queue */
+	ioc->hi_priority = ioc->request + ((ioc->scsiio_depth + 1) *
 	    ioc->request_sz);
-	ioc->chain_dma = ioc->request_dma + ((ioc->request_depth + 1) *
+	ioc->hi_priority_dma = ioc->request_dma + ((ioc->scsiio_depth + 1) *
+	    ioc->request_sz);
+
+	/* internal queue */
+	ioc->internal = ioc->hi_priority + (ioc->hi_priority_depth *
 	    ioc->request_sz);
+	ioc->internal_dma = ioc->hi_priority_dma + (ioc->hi_priority_depth *
+	    ioc->request_sz);
+
+	ioc->chain = ioc->internal + (ioc->internal_depth *
+	    ioc->request_sz);
+	ioc->chain_dma = ioc->internal_dma + (ioc->internal_depth *
+	    ioc->request_sz);
+
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "request pool(0x%p): "
 	    "depth(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name,
-	    ioc->request, ioc->request_depth, ioc->request_sz,
-	    ((ioc->request_depth + 1) * ioc->request_sz)/1024));
+	    ioc->request, ioc->hba_queue_depth, ioc->request_sz,
+	    (ioc->hba_queue_depth * ioc->request_sz)/1024));
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "chain pool(0x%p): depth"
 	    "(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name, ioc->chain,
 	    ioc->chain_depth, ioc->request_sz, ((ioc->chain_depth *
@@ -1895,7 +2025,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
 
-	ioc->scsi_lookup = kcalloc(ioc->request_depth,
+	ioc->scsi_lookup = kcalloc(ioc->scsiio_depth,
 	    sizeof(struct request_tracker), GFP_KERNEL);
 	if (!ioc->scsi_lookup) {
 		printk(MPT2SAS_ERR_FMT "scsi_lookup: kcalloc failed\n",
@@ -1903,12 +2033,38 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		goto out;
 	}
 
-	 /* initialize some bits */
-	for (i = 0; i < ioc->request_depth; i++)
-		ioc->scsi_lookup[i].smid = i + 1;
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsiio(0x%p): "
+	    "depth(%d)\n", ioc->name, ioc->request,
+	    ioc->scsiio_depth));
+
+	/* initialize hi-priority queue smid's */
+	ioc->hpr_lookup = kcalloc(ioc->hi_priority_depth,
+	    sizeof(struct request_tracker), GFP_KERNEL);
+	if (!ioc->hpr_lookup) {
+		printk(MPT2SAS_ERR_FMT "hpr_lookup: kcalloc failed\n",
+		    ioc->name);
+		goto out;
+	}
+	ioc->hi_priority_smid = ioc->scsiio_depth + 1;
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "hi_priority(0x%p): "
+	    "depth(%d), start smid(%d)\n", ioc->name, ioc->hi_priority,
+	    ioc->hi_priority_depth, ioc->hi_priority_smid));
+
+	/* initialize internal queue smid's */
+	ioc->internal_lookup = kcalloc(ioc->internal_depth,
+	    sizeof(struct request_tracker), GFP_KERNEL);
+	if (!ioc->internal_lookup) {
+		printk(MPT2SAS_ERR_FMT "internal_lookup: kcalloc failed\n",
+		    ioc->name);
+		goto out;
+	}
+	ioc->internal_smid = ioc->hi_priority_smid + ioc->hi_priority_depth;
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "internal(0x%p): "
+	    "depth(%d), start smid(%d)\n", ioc->name, ioc->internal,
+	     ioc->internal_depth, ioc->internal_smid));
 
 	/* sense buffers, 4 byte align */
-	sz = ioc->request_depth * SCSI_SENSE_BUFFERSIZE;
+	sz = ioc->scsiio_depth * SCSI_SENSE_BUFFERSIZE;
 	ioc->sense_dma_pool = pci_pool_create("sense pool", ioc->pdev, sz, 4,
 	    0);
 	if (!ioc->sense_dma_pool) {
@@ -1925,7 +2081,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "sense pool(0x%p): depth(%d), element_size(%d), pool_size"
-	    "(%d kB)\n", ioc->name, ioc->sense, ioc->request_depth,
+	    "(%d kB)\n", ioc->name, ioc->sense, ioc->scsiio_depth,
 	    SCSI_SENSE_BUFFERSIZE, sz/1024));
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "sense_dma(0x%llx)\n",
 	    ioc->name, (unsigned long long)ioc->sense_dma));
@@ -3166,6 +3322,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	int r, i;
 	unsigned long	flags;
 	u32 reply_address;
+	u16 smid;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
@@ -3173,11 +3330,34 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	INIT_LIST_HEAD(&ioc->free_list);
-	for (i = 0; i < ioc->request_depth; i++) {
+	smid = 1;
+	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
+		ioc->scsi_lookup[i].smid = smid;
+		ioc->scsi_lookup[i].scmd = NULL;
 		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
 		    &ioc->free_list);
 	}
+
+	/* hi-priority queue */
+	INIT_LIST_HEAD(&ioc->hpr_free_list);
+	smid = ioc->hi_priority_smid;
+	for (i = 0; i < ioc->hi_priority_depth; i++, smid++) {
+		ioc->hpr_lookup[i].cb_idx = 0xFF;
+		ioc->hpr_lookup[i].smid = smid;
+		list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+		    &ioc->hpr_free_list);
+	}
+
+	/* internal queue */
+	INIT_LIST_HEAD(&ioc->internal_free_list);
+	smid = ioc->internal_smid;
+	for (i = 0; i < ioc->internal_depth; i++, smid++) {
+		ioc->internal_lookup[i].cb_idx = 0xFF;
+		ioc->internal_lookup[i].smid = smid;
+		list_add_tail(&ioc->internal_lookup[i].tracker_list,
+		    &ioc->internal_free_list);
+	}
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	/* initialize Reply Free Queue */
@@ -3272,6 +3452,17 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
+	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
+	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
+	if (!ioc->pfacts)
+		goto out_free_resources;
+
+	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
+		r = _base_get_port_facts(ioc, i, CAN_SLEEP);
+		if (r)
+			goto out_free_resources;
+	}
+
 	r = _base_allocate_memory_pools(ioc, CAN_SLEEP);
 	if (r)
 		goto out_free_resources;
@@ -3321,17 +3512,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	_base_unmask_events(ioc, MPI2_EVENT_IR_OPERATION_STATUS);
 	_base_unmask_events(ioc, MPI2_EVENT_TASK_SET_FULL);
 	_base_unmask_events(ioc, MPI2_EVENT_LOG_ENTRY_ADDED);
-
-	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
-	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
-	if (!ioc->pfacts)
-		goto out_free_resources;
-
-	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
-		r = _base_get_port_facts(ioc, i, CAN_SLEEP);
-		if (r)
-			goto out_free_resources;
-	}
 	r = _base_make_ioc_operational(ioc, CAN_SLEEP);
 	if (r)
 		goto out_free_resources;
@@ -3460,7 +3640,7 @@ _wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	/* pending command count */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->request_depth; i++)
+	for (i = 0; i < ioc->scsiio_depth; i++)
 		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
 			ioc->pending_io_count++;
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 3de37b7..9113262 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -264,6 +264,13 @@ struct _internal_cmd {
  * SAS Topology Structures
  */
 
+#define MPTSAS_STATE_TR_SEND		0x0001
+#define MPTSAS_STATE_TR_COMPLETE	0x0002
+#define MPTSAS_STATE_CNTRL_SEND		0x0004
+#define MPTSAS_STATE_CNTRL_COMPLETE	0x0008
+
+#define MPT2SAS_REQ_SAS_CNTRL		0x0010
+
 /**
  * struct _sas_device - attached device information
  * @list: sas device list
@@ -510,8 +517,9 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @config_page_sz: config page size
  * @config_page: reserve memory for config page payload
  * @config_page_dma:
+ * @hba_queue_depth: hba request queue depth
  * @sge_size: sg element size for either 32/64 bit
- * @request_depth: hba request queue depth
+ * @scsiio_depth: SCSI_IO queue depth
  * @request_sz: per request frame size
  * @request: pool of request frames
  * @request_dma:
@@ -528,6 +536,18 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @chains_needed_per_io: max chains per io
  * @chain_offset_value_for_main_message: location 1st sg in main
  * @chain_depth: total chains allocated
+ * @hi_priority_smid:
+ * @hi_priority:
+ * @hi_priority_dma:
+ * @hi_priority_depth:
+ * @hpr_lookup:
+ * @hpr_free_list:
+ * @internal_smid:
+ * @internal:
+ * @internal_dma:
+ * @internal_depth:
+ * @internal_lookup:
+ * @internal_free_list:
  * @sense: pool of sense
  * @sense_dma:
  * @sense_dma_pool:
@@ -643,9 +663,10 @@ struct MPT2SAS_ADAPTER {
 	void 		*config_page;
 	dma_addr_t	config_page_dma;
 
-	/* request */
+	/* scsiio request */
+	u16		hba_queue_depth;
 	u16		sge_size;
-	u16 		request_depth;
+	u16 		scsiio_depth;
 	u16		request_sz;
 	u8		*request;
 	dma_addr_t	request_dma;
@@ -665,6 +686,22 @@ struct MPT2SAS_ADAPTER {
 	u16		chain_offset_value_for_main_message;
 	u16		chain_depth;
 
+	/* hi-priority queue */
+	u16		hi_priority_smid;
+	u8		*hi_priority;
+	dma_addr_t	hi_priority_dma;
+	u16		hi_priority_depth;
+	struct request_tracker *hpr_lookup;
+	struct list_head hpr_free_list;
+
+	/* internal queue */
+	u16		internal_smid;
+	u8		*internal;
+	dma_addr_t	internal_dma;
+	u16		internal_depth;
+	struct request_tracker *internal_lookup;
+	struct list_head internal_free_list;
+
 	/* sense */
 	u8		*sense;
 	dma_addr_t	sense_dma;
@@ -720,9 +757,13 @@ int mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 void *mpt2sas_base_get_msg_frame(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void *mpt2sas_base_get_sense_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_build_zero_len_sge(struct MPT2SAS_ADAPTER *ioc, void *paddr);
-dma_addr_t mpt2sas_base_get_msg_frame_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 
+/* hi-priority queue */
+u16 mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
+u16 mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
+    struct scsi_cmnd *scmd);
+
 u16 mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 3796150..466e2f4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -509,7 +509,7 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 
 	handle = le16_to_cpu(tm_request->DevHandle);
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = ioc->request_depth; i && !found; i--) {
+	for (i = ioc->scsiio_depth; i && !found; i--) {
 		scmd = ioc->scsi_lookup[i - 1].scmd;
 		if (scmd == NULL || scmd->device == NULL ||
 		    scmd->device->hostdata == NULL)
@@ -616,7 +616,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		printk(MPT2SAS_INFO_FMT "%s: ioc is operational\n",
 		    ioc->name, __func__);
 
-	smid = mpt2sas_base_get_smid(ioc, ioc->ctl_cb_idx);
+	smid = mpt2sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b38a807..0a489c6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -762,66 +762,16 @@ _scsih_is_end_device(u32 device_info)
 }
 
 /**
- * _scsih_scsi_lookup_get - returns scmd entry
+ * mptscsih_get_scsi_lookup - returns scmd entry
  * @ioc: per adapter object
  * @smid: system request message index
- * Context: This function will acquire ioc->scsi_lookup_lock.
  *
  * Returns the smid stored scmd pointer.
  */
 static struct scsi_cmnd *
 _scsih_scsi_lookup_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
-	unsigned long	flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = ioc->scsi_lookup[smid - 1].scmd;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return scmd;
-}
-
-/**
- * mptscsih_getclear_scsi_lookup - returns scmd entry
- * @ioc: per adapter object
- * @smid: system request message index
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * Returns the smid stored scmd pointer, as well as clearing the scmd pointer.
- */
-static struct scsi_cmnd *
-_scsih_scsi_lookup_getclear(struct MPT2SAS_ADAPTER *ioc, u16 smid)
-{
-	unsigned long	flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = ioc->scsi_lookup[smid - 1].scmd;
-	ioc->scsi_lookup[smid - 1].scmd = NULL;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return scmd;
-}
-
-/**
- * _scsih_scsi_lookup_set - updates scmd entry in lookup
- * @ioc: per adapter object
- * @smid: system request message index
- * @scmd: pointer to scsi command object
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * This will save scmd pointer in the scsi_lookup array.
- *
- * Return nothing.
- */
-static void
-_scsih_scsi_lookup_set(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    struct scsi_cmnd *scmd)
-{
-	unsigned long	flags;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	ioc->scsi_lookup[smid - 1].scmd = scmd;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return ioc->scsi_lookup[smid - 1].scmd;
 }
 
 /**
@@ -844,9 +794,9 @@ _scsih_scsi_lookup_find_by_scmd(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	smid = 0;
-	for (i = 0; i < ioc->request_depth; i++) {
+	for (i = 0; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd == scmd) {
-			smid = i + 1;
+			smid = ioc->scsi_lookup[i].smid;
 			goto out;
 		}
 	}
@@ -875,7 +825,7 @@ _scsih_scsi_lookup_find_by_target(struct MPT2SAS_ADAPTER *ioc, int id,
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
-	for (i = 0 ; i < ioc->request_depth; i++) {
+	for (i = 0 ; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd &&
 		    (ioc->scsi_lookup[i].scmd->device->id == id &&
 		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
@@ -909,7 +859,7 @@ _scsih_scsi_lookup_find_by_lun(struct MPT2SAS_ADAPTER *ioc, int id,
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
-	for (i = 0 ; i < ioc->request_depth; i++) {
+	for (i = 0 ; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd &&
 		    (ioc->scsi_lookup[i].scmd->device->id == id &&
 		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
@@ -1119,7 +1069,7 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 }
 
 /**
- * _scsih_change_queue_depth - changing device queue tag type
+ * _scsih_change_queue_type - changing device queue tag type
  * @sdev: scsi device struct
  * @tag_type: requested tag type
  *
@@ -1822,7 +1772,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 		goto issue_host_reset;
 	}
 
-	smid = mpt2sas_base_get_smid(ioc, ioc->tm_cb_idx);
+	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
@@ -1830,7 +1780,8 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	}
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "sending tm: handle(0x%04x),"
-	    " task_type(0x%02x), smid(%d)\n", ioc->name, handle, type, smid));
+	    " task_type(0x%02x), smid(%d)\n", ioc->name, handle, type,
+	    smid_task));
 	ioc->tm_cmds.status = MPT2_CMD_PENDING;
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 	ioc->tm_cmds.smid = smid;
@@ -2082,7 +2033,7 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 }
 
 /**
- * _scsih_abort - eh threads main host reset routine
+ * _scsih_host_reset - eh threads main host reset routine
  * @sdev: scsi device struct
  *
  * Returns SUCCESS if command aborted else FAILED
@@ -2440,8 +2391,8 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 	u16 smid;
 	u16 count = 0;
 
-	for (smid = 1; smid <= ioc->request_depth; smid++) {
-		scmd = _scsih_scsi_lookup_getclear(ioc, smid);
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
 		count++;
@@ -2623,7 +2574,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON))
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
-	smid = mpt2sas_base_get_smid(ioc, ioc->scsi_io_cb_idx);
+	smid = mpt2sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
@@ -2665,7 +2616,6 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		}
 	}
 
-	_scsih_scsi_lookup_set(ioc, smid, scmd);
 	mpt2sas_base_put_smid_scsi_io(ioc, smid,
 	    sas_device_priv_data->sas_target->handle);
 	return 0;
@@ -2984,7 +2934,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 response_code;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_getclear(ioc, smid);
+	scmd = _scsih_scsi_lookup_get(ioc, smid);
 	if (scmd == NULL)
 		return;
 
@@ -3406,9 +3356,8 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		}
 	}
 
-	sas_address = le64_to_cpu(expander_pg0.SASAddress);
-
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	sas_address = le64_to_cpu(expander_pg0.SASAddress);
 	sas_expander = mpt2sas_scsih_expander_find_by_sas_address(ioc,
 	    sas_address);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
@@ -4081,7 +4030,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	termination_count = 0;
 	query_count = 0;
 	mpi_reply = ioc->tm_cmds.reply;
-	for (smid = 1; smid <= ioc->request_depth; smid++) {
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
@@ -4145,8 +4094,8 @@ _scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 	if (event_data->DiscoveryStatus)
-		printk(MPT2SAS_DEBUG_FMT ", discovery_status(0x%08x)",
-		    ioc->name, le32_to_cpu(event_data->DiscoveryStatus));
+		printk("discovery_status(0x%08x)",
+		    le32_to_cpu(event_data->DiscoveryStatus));
 	printk("\n");
 	}
 #endif
