From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 04/15] mpt3sas: Lockless access for chain buffers.
Date: Fri, 30 Mar 2018 15:07:13 +0530
Message-ID: <1522402644-3016-5-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Introduces Chain lookup table/tracker and implements accessing chain buffer
using smid.
Removed link list based access of chain buffer which requires lock and
allocated as many chains needed.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 111 +++++++++++++++++++-----------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   8 ++-
 2 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a79c6df..1e8e399 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -297,12 +297,15 @@ static void *
 _base_get_chain_buffer_dma_to_chain_buffer(struct MPT3SAS_ADAPTER *ioc,
 		dma_addr_t chain_buffer_dma)
 {
-	u16 index;
-
-	for (index = 0; index < ioc->chain_depth; index++) {
-		if (ioc->chain_lookup[index].chain_buffer_dma ==
-				chain_buffer_dma)
-			return ioc->chain_lookup[index].chain_buffer;
+	u16 index, j;
+	struct chain_tracker *ct;
+
+	for (index = 0; index < ioc->scsiio_depth; index++) {
+		for (j = 0; j < ioc->chains_needed_per_io; j++) {
+			ct = &ioc->chain_lookup[index].chains_per_smid[j];
+			if (ct && ct->chain_buffer_dma == chain_buffer_dma)
+				return ct->chain_buffer;
+		}
 	}
 	pr_info(MPT3SAS_FMT
 	    "Provided chain_buffer_dma address is not in the lookup list\n",
@@ -1678,7 +1681,8 @@ _base_add_sg_single_64(void *paddr, u32 flags_length, dma_addr_t dma_addr)
  * @ioc: per adapter object
  * @scmd: SCSI commands of the IO request
  *
- * Returns chain tracker(from ioc->free_chain_list)
+ * Returns chain tracker from chain_lookup table using key as
+ * smid and smid's chain_offset.
  */
 static struct chain_tracker *
 _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc,
@@ -1686,20 +1690,15 @@ _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct chain_tracker *chain_req;
 	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
-	unsigned long flags;
+	u16 smid = st->smid;
+	u8 chain_offset =
+	   atomic_read(&ioc->chain_lookup[smid - 1].chain_offset);
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	if (list_empty(&ioc->free_chain_list)) {
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-			"chain buffers not available\n", ioc->name));
+	if (chain_offset == ioc->chains_needed_per_io)
 		return NULL;
-	}
-	chain_req = list_entry(ioc->free_chain_list.next,
-	    struct chain_tracker, tracker_list);
-	list_del_init(&chain_req->tracker_list);
-	list_add_tail(&chain_req->tracker_list, &st->chain_list);
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	chain_req = &ioc->chain_lookup[smid - 1].chains_per_smid[chain_offset];
+	atomic_inc(&ioc->chain_lookup[smid - 1].chain_offset);
 	return chain_req;
 }
 
@@ -3278,13 +3277,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 		return;
 	st->cb_idx = 0xFF;
 	st->direct_io = 0;
-	if (!list_empty(&st->chain_list)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-		list_splice_init(&st->chain_list, &ioc->free_chain_list);
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	}
+	atomic_set(&ioc->chain_lookup[st->smid - 1].chain_offset, 0);
 }
 
 /**
@@ -4102,6 +4095,8 @@ static void
 _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i = 0;
+	int j = 0;
+	struct chain_tracker *ct;
 	struct reply_post_struct *rps;
 
 	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
@@ -4192,14 +4187,18 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
-		for (i = 0; i < ioc->chain_depth; i++) {
-			if (ioc->chain_lookup[i].chain_buffer)
-				dma_pool_free(ioc->chain_dma_pool,
-				    ioc->chain_lookup[i].chain_buffer,
-				    ioc->chain_lookup[i].chain_buffer_dma);
+		for (i = 0; i < ioc->scsiio_depth; i++) {
+			for (j = 0; j < ioc->chains_needed_per_io; j++) {
+				ct = &ioc->chain_lookup[i].chains_per_smid[j];
+				if (ct && ct->chain_buffer)
+					dma_pool_free(ioc->chain_dma_pool,
+						ct->chain_buffer,
+						ct->chain_buffer_dma);
+			}
+			kfree(ioc->chain_lookup[i].chains_per_smid);
 		}
 		dma_pool_destroy(ioc->chain_dma_pool);
-		free_pages((ulong)ioc->chain_lookup, ioc->chain_pages);
+		kfree(ioc->chain_lookup);
 		ioc->chain_lookup = NULL;
 	}
 }
@@ -4221,7 +4220,8 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	u16 max_request_credit, nvme_blocks_needed;
 	unsigned short sg_tablesize;
 	u16 sge_size;
-	int i;
+	int i, j;
+	struct chain_tracker *ct;
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
@@ -4502,15 +4502,24 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		ioc->name, ioc->request, ioc->scsiio_depth));
 
 	ioc->chain_depth = min_t(u32, ioc->chain_depth, MAX_CHAIN_DEPTH);
-	sz = ioc->chain_depth * sizeof(struct chain_tracker);
-	ioc->chain_pages = get_order(sz);
-	ioc->chain_lookup = (struct chain_tracker *)__get_free_pages(
-	    GFP_KERNEL, ioc->chain_pages);
+	sz = ioc->scsiio_depth * sizeof(struct chain_lookup);
+	ioc->chain_lookup = kzalloc(sz, GFP_KERNEL);
 	if (!ioc->chain_lookup) {
-		pr_err(MPT3SAS_FMT "chain_lookup: __get_free_pages failed\n",
-			ioc->name);
+		pr_err(MPT3SAS_FMT "chain_lookup: __get_free_pages "
+		"failed\n", ioc->name);
 		goto out;
 	}
+
+	sz = ioc->chains_needed_per_io * sizeof(struct chain_tracker);
+	for (i = 0; i < ioc->scsiio_depth; i++) {
+		ioc->chain_lookup[i].chains_per_smid = kzalloc(sz, GFP_KERNEL);
+		if (!ioc->chain_lookup[i].chains_per_smid) {
+			pr_err(MPT3SAS_FMT "chain_lookup: "
+					" kzalloc failed\n", ioc->name);
+			goto out;
+		}
+	}
+
 	ioc->chain_dma_pool = dma_pool_create("chain pool", &ioc->pdev->dev,
 	    ioc->chain_segment_sz, 16, 0);
 	if (!ioc->chain_dma_pool) {
@@ -4518,17 +4527,21 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			ioc->name);
 		goto out;
 	}
-	for (i = 0; i < ioc->chain_depth; i++) {
-		ioc->chain_lookup[i].chain_buffer = dma_pool_alloc(
+	for (i = 0; i < ioc->scsiio_depth; i++) {
+		for (j = 0; j < ioc->chains_needed_per_io; j++) {
+			ct = &ioc->chain_lookup[i].chains_per_smid[j];
+			ct->chain_buffer = dma_pool_alloc(
 		    ioc->chain_dma_pool , GFP_KERNEL,
-		    &ioc->chain_lookup[i].chain_buffer_dma);
-		if (!ioc->chain_lookup[i].chain_buffer) {
-			ioc->chain_depth = i;
-			goto chain_done;
+		    &ct->chain_buffer_dma);
+			if (!ct->chain_buffer) {
+				pr_err(MPT3SAS_FMT "chain_lookup: "
+				" pci_pool_alloc failed\n", ioc->name);
+				goto out;
+			}
 		}
 		total_sz += ioc->chain_segment_sz;
 	}
- chain_done:
+
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
 		ioc->name, ioc->chain_depth, ioc->chain_segment_sz,
@@ -6176,12 +6189,6 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 		    &ioc->internal_free_list);
 	}
 
-	/* chain pool */
-	INIT_LIST_HEAD(&ioc->free_chain_list);
-	for (i = 0; i < ioc->chain_depth; i++)
-		list_add_tail(&ioc->chain_lookup[i].tracker_list,
-		    &ioc->free_chain_list);
-
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	/* initialize Reply Free Queue */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 5977993..a0fca8a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -770,7 +770,11 @@ struct pcie_sg_list {
 struct chain_tracker {
 	void *chain_buffer;
 	dma_addr_t chain_buffer_dma;
-	struct list_head tracker_list;
+};
+
+struct chain_lookup {
+	struct chain_tracker *chains_per_smid;
+	atomic_t	chain_offset;
 };
 
 /**
@@ -1261,7 +1265,7 @@ struct MPT3SAS_ADAPTER {
 	u32		page_size;
 
 	/* chain */
-	struct chain_tracker *chain_lookup;
+	struct chain_lookup *chain_lookup;
 	struct list_head free_chain_list;
 	struct dma_pool *chain_dma_pool;
 	ulong		chain_pages;
-- 
1.8.3.1
