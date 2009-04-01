From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] cxgb3i - re-initialize ddp settings after chip reset
Date: Wed,  1 Apr 2009 13:11:24 -0500
Message-ID: <12386094901595-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
 <12386094902138-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933432AbZDASLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:48 -0400
In-Reply-To: <12386094902138-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Xie <kxie@chelsio.com>

[PATCH 3/5 2.6.30] cxgb3i - re-initialize ddp settings after chip reset

From: Karen Xie <kxie@chelsio.com>

Re-initialize the ddp settings after chip reset. It includes re-initialize
the related registers and the ddp map.

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c |  242 ++++++++++++++++++--------------------
 drivers/scsi/cxgb3i/cxgb3i_ddp.h |    3 +-
 2 files changed, 118 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 4eb6f55..bb1eebf 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -66,9 +66,6 @@ static unsigned char ddp_page_order[DDP_PGIDX_MAX] = {0, 1, 2, 4};
 static unsigned char ddp_page_shift[DDP_PGIDX_MAX] = {12, 13, 14, 16};
 static unsigned char page_idx = DDP_PGIDX_MAX;
 
-static LIST_HEAD(cxgb3i_ddp_list);
-static DEFINE_RWLOCK(cxgb3i_ddp_rwlock);
-
 /*
  * functions to program the pagepod in h/w
  */
@@ -113,8 +110,8 @@ static int set_ddp_map(struct cxgb3i_ddp_info *ddp, struct pagepod_hdr *hdr,
 	return 0;
 }
 
-static int clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int idx,
-			 unsigned int npods)
+static void clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int tag,
+			 unsigned int idx, unsigned int npods)
 {
 	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
 	int i;
@@ -122,13 +119,17 @@ static int clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int idx,
 	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
 		struct sk_buff *skb = ddp->gl_skb[idx];
 
+		if (!skb) {
+			ddp_log_error("ddp tag 0x%x, 0x%x, %d/%u, skb NULL.\n",
+					tag, idx, i, npods);
+			continue;
+		}
 		ddp->gl_skb[idx] = NULL;
 		memset((skb->head + sizeof(struct ulp_mem_io)), 0, PPOD_SIZE);
 		ulp_mem_io_set_hdr(skb, pm_addr);
 		skb->priority = CPL_PRIORITY_CONTROL;
 		cxgb3_ofld_send(ddp->tdev, skb);
 	}
-	return 0;
 }
 
 static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
@@ -453,15 +454,15 @@ void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
 		struct cxgb3i_gather_list *gl = ddp->gl_map[idx];
 		unsigned int npods;
 
-		if (!gl) {
-			ddp_log_error("release ddp 0x%x, idx 0x%x, gl NULL.\n",
-				      tag, idx);
+		if (!gl || !gl->nelem) {
+			ddp_log_error("release 0x%x, idx 0x%x, gl 0x%p, %u.\n",
+				      tag, idx, gl, gl ? gl->nelem : 0);
 			return;
 		}
 		npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
 		ddp_log_debug("ddp tag 0x%x, release idx 0x%x, npods %u.\n",
 			      tag, idx, npods);
-		clear_ddp_map(ddp, idx, npods);
+		clear_ddp_map(ddp, tag, idx, npods);
 		ddp_unmark_entries(ddp, idx, npods);
 		cxgb3i_ddp_release_gl(gl, ddp->pdev);
 	} else
@@ -564,7 +565,87 @@ int cxgb3i_setup_conn_digest(struct t3cdev *tdev, unsigned int tid,
 }
 EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_digest);
 
-static int ddp_init(struct t3cdev *tdev)
+
+/**
+ * cxgb3i_adapter_ddp_info - read the adapter's ddp information
+ * @tdev: t3cdev adapter
+ * @tformat: tag format
+ * @txsz: max tx pdu payload size, filled in by this func.
+ * @rxsz: max rx pdu payload size, filled in by this func.
+ * setup the tag format for a given iscsi entity
+ */
+int cxgb3i_adapter_ddp_info(struct t3cdev *tdev,
+			    struct cxgb3i_tag_format *tformat,
+			    unsigned int *txsz, unsigned int *rxsz)
+{
+	struct cxgb3i_ddp_info *ddp;
+	unsigned char idx_bits;
+
+	if (!tformat)
+		return -EINVAL;
+
+	if (!tdev->ulp_iscsi)
+		return -EINVAL;
+
+	ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
+
+	idx_bits = 32 - tformat->sw_bits;
+	tformat->rsvd_bits = ddp->idx_bits;
+	tformat->rsvd_shift = PPOD_IDX_SHIFT;
+	tformat->rsvd_mask = (1 << tformat->rsvd_bits) - 1;
+
+	ddp_log_info("tag format: sw %u, rsvd %u,%u, mask 0x%x.\n",
+		      tformat->sw_bits, tformat->rsvd_bits,
+		      tformat->rsvd_shift, tformat->rsvd_mask);
+
+	*txsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
+			ddp->max_txsz - ISCSI_PDU_NONPAYLOAD_LEN);
+	*rxsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
+			ddp->max_rxsz - ISCSI_PDU_NONPAYLOAD_LEN);
+	ddp_log_info("max payload size: %u/%u, %u/%u.\n",
+		     *txsz, ddp->max_txsz, *rxsz, ddp->max_rxsz);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_info);
+
+/**
+ * ddp_release - release the cxgb3 adapter's ddp resource
+ * @tdev: t3cdev adapter
+ * release all the resource held by the ddp pagepod manager for a given
+ * adapter if needed
+ */
+static void ddp_release(struct t3cdev *tdev)
+{
+	int i = 0;
+	struct cxgb3i_ddp_info *ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
+
+	ddp_log_info("t3dev 0x%p, release ddp 0x%p.\n", tdev, ddp);
+
+	if (ddp) {
+		tdev->ulp_iscsi = NULL;
+		while (i < ddp->nppods) {
+			struct cxgb3i_gather_list *gl = ddp->gl_map[i];
+			if (gl) {
+				int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
+						>> PPOD_PAGES_SHIFT;
+				ddp_log_info("t3dev 0x%p, ddp %d + %d.\n",
+						tdev, i, npods);
+				kfree(gl);
+				ddp_free_gl_skb(ddp, i, npods);
+				i += npods;
+			} else
+				i++;
+		}
+		cxgb3i_free_big_mem(ddp);
+	}
+}
+
+/**
+ * ddp_init - initialize the cxgb3 adapter's ddp resource
+ * @tdev: t3cdev adapter
+ * initialize the ddp pagepod manager for a given adapter
+ */
+static void ddp_init(struct t3cdev *tdev)
 {
 	struct cxgb3i_ddp_info *ddp;
 	struct ulp_iscsi_info uinfo;
@@ -572,6 +653,12 @@ static int ddp_init(struct t3cdev *tdev)
 	int i, err;
 	static int vers_printed;
 
+	if (tdev->ulp_iscsi) {
+		ddp_log_warn("t3dev 0x%p, ddp 0x%p already set up.\n",
+				tdev, tdev->ulp_iscsi);
+		return;
+	}
+
 	if (!vers_printed) {
 		printk(KERN_INFO "%s", version);
 		vers_printed = 1;
@@ -581,7 +668,7 @@ static int ddp_init(struct t3cdev *tdev)
 	if (err < 0) {
 		ddp_log_error("%s, failed to get iscsi param err=%d.\n",
 				 tdev->name, err);
-		return err;
+		return;
 	}
 
 	ppmax = (uinfo.ulimit - uinfo.llimit + 1) >> PPOD_SIZE_SHIFT;
@@ -598,7 +685,7 @@ static int ddp_init(struct t3cdev *tdev)
 	if (!ddp) {
 		ddp_log_warn("%s unable to alloc ddp 0x%d, ddp disabled.\n",
 			     tdev->name, ppmax);
-		return 0;
+		return;
 	}
 	ddp->gl_map = (struct cxgb3i_gather_list **)(ddp + 1);
 	ddp->gl_skb = (struct sk_buff **)(((char *)ddp->gl_map) +
@@ -632,141 +719,46 @@ static int ddp_init(struct t3cdev *tdev)
 
 	tdev->ulp_iscsi = ddp;
 
-	/* add to the list */
-	write_lock(&cxgb3i_ddp_rwlock);
-	list_add_tail(&ddp->list, &cxgb3i_ddp_list);
-	write_unlock(&cxgb3i_ddp_rwlock);
-
-	ddp_log_info("nppods %u (0x%x ~ 0x%x), bits %u, mask 0x%x,0x%x "
-			"pkt %u/%u, %u/%u.\n",
-			ppmax, ddp->llimit, ddp->ulimit, ddp->idx_bits,
-			ddp->idx_mask, ddp->rsvd_tag_mask,
-			ddp->max_txsz, uinfo.max_txsz,
+	ddp_log_info("tdev 0x%p, nppods %u, bits %u, mask 0x%x,0x%x pkt %u/%u,"
+			" %u/%u.\n",
+			tdev, ppmax, ddp->idx_bits, ddp->idx_mask,
+			ddp->rsvd_tag_mask, ddp->max_txsz, uinfo.max_txsz,
 			ddp->max_rxsz, uinfo.max_rxsz);
-	return 0;
+	return;
 
 free_ddp_map:
 	cxgb3i_free_big_mem(ddp);
-	return err;
 }
 
-/**
- * cxgb3i_adapter_ddp_init - initialize the adapter's ddp resource
- * @tdev: t3cdev adapter
- * @tformat: tag format
- * @txsz: max tx pdu payload size, filled in by this func.
- * @rxsz: max rx pdu payload size, filled in by this func.
- * initialize the ddp pagepod manager for a given adapter if needed and
- * setup the tag format for a given iscsi entity
- */
-int cxgb3i_adapter_ddp_init(struct t3cdev *tdev,
-			    struct cxgb3i_tag_format *tformat,
-			    unsigned int *txsz, unsigned int *rxsz)
-{
-	struct cxgb3i_ddp_info *ddp;
-	unsigned char idx_bits;
-
-	if (!tformat)
-		return -EINVAL;
-
-	if (!tdev->ulp_iscsi) {
-		int err = ddp_init(tdev);
-		if (err < 0)
-			return err;
-	}
-	ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
-
-	idx_bits = 32 - tformat->sw_bits;
-	tformat->rsvd_bits = ddp->idx_bits;
-	tformat->rsvd_shift = PPOD_IDX_SHIFT;
-	tformat->rsvd_mask = (1 << tformat->rsvd_bits) - 1;
-
-	ddp_log_info("tag format: sw %u, rsvd %u,%u, mask 0x%x.\n",
-		      tformat->sw_bits, tformat->rsvd_bits,
-		      tformat->rsvd_shift, tformat->rsvd_mask);
-
-	*txsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
-			ddp->max_txsz - ISCSI_PDU_NONPAYLOAD_LEN);
-	*rxsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
-			ddp->max_rxsz - ISCSI_PDU_NONPAYLOAD_LEN);
-	ddp_log_info("max payload size: %u/%u, %u/%u.\n",
-		     *txsz, ddp->max_txsz, *rxsz, ddp->max_rxsz);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_init);
-
-static void ddp_release(struct cxgb3i_ddp_info *ddp)
-{
-	int i = 0;
-	struct t3cdev *tdev = ddp->tdev;
-
-	tdev->ulp_iscsi = NULL;
-	while (i < ddp->nppods) {
-		struct cxgb3i_gather_list *gl = ddp->gl_map[i];
-		if (gl) {
-			int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
-				     >> PPOD_PAGES_SHIFT;
-
-			kfree(gl);
-			ddp_free_gl_skb(ddp, i, npods);
-		} else
-			i++;
-	}
-	cxgb3i_free_big_mem(ddp);
-}
-
-/**
- * cxgb3i_adapter_ddp_cleanup - release the adapter's ddp resource
- * @tdev: t3cdev adapter
- * release all the resource held by the ddp pagepod manager for a given
- * adapter if needed
- */
-void cxgb3i_adapter_ddp_cleanup(struct t3cdev *tdev)
-{
-	struct cxgb3i_ddp_info *ddp;
-
-	/* remove from the list */
-	write_lock(&cxgb3i_ddp_rwlock);
-	list_for_each_entry(ddp, &cxgb3i_ddp_list, list) {
-		if (ddp->tdev == tdev) {
-			list_del(&ddp->list);
-			break;
-		}
-	}
-	write_unlock(&cxgb3i_ddp_rwlock);
-
-	if (ddp)
-		ddp_release(ddp);
-}
-EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_cleanup);
+static struct cxgb3_client t3c_ddp_client = {
+	.name = "iscsiddp_cxgb3",
+	.add = ddp_init,
+	.remove = ddp_release,
+};
 
 /**
  * cxgb3i_ddp_init_module - module init entry point
- * initialize any driver wide global data structures
+ * initialize any driver wide global data structures and register with the
+ * cxgb3 module
  */
 static int __init cxgb3i_ddp_init_module(void)
 {
 	page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
 	ddp_log_info("system PAGE_SIZE %lu, ddp idx %u.\n",
 		     PAGE_SIZE, page_idx);
+
+	cxgb3_register_client(&t3c_ddp_client);
 	return 0;
 }
 
 /**
  * cxgb3i_ddp_exit_module - module cleanup/exit entry point
- * go through the ddp list and release any resource held.
+ * go through the ddp list, unregister with the cxgb3 module and release
+ * any resource held.
  */
 static void __exit cxgb3i_ddp_exit_module(void)
 {
-	struct cxgb3i_ddp_info *ddp;
-
-	/* release all ddp manager if there is any */
-	write_lock(&cxgb3i_ddp_rwlock);
-	list_for_each_entry(ddp, &cxgb3i_ddp_list, list) {
-		list_del(&ddp->list);
-		ddp_release(ddp);
-	}
-	write_unlock(&cxgb3i_ddp_rwlock);
+	cxgb3_unregister_client(&t3c_ddp_client);
 }
 
 module_init(cxgb3i_ddp_init_module);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 75a63a8..87f032b 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -301,7 +301,6 @@ int cxgb3i_setup_conn_pagesize(struct t3cdev *, unsigned int tid, int reply,
 int cxgb3i_setup_conn_digest(struct t3cdev *, unsigned int tid,
 				int hcrc, int dcrc, int reply);
 int cxgb3i_ddp_find_page_index(unsigned long pgsz);
-int cxgb3i_adapter_ddp_init(struct t3cdev *, struct cxgb3i_tag_format *,
+int cxgb3i_adapter_ddp_info(struct t3cdev *, struct cxgb3i_tag_format *,
 			    unsigned int *txsz, unsigned int *rxsz);
-void cxgb3i_adapter_ddp_cleanup(struct t3cdev *);
 #endif
-- 
1.6.0.6

