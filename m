From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 2/2 2.6.29-rc] cxgb3i - add handling of chip reset
Date: Tue, 24 Feb 2009 17:28:19 -0800
Message-ID: <200902250128.n1P1SJOD007746@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:6312 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZBYBYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 20:24:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 2/2 2.6.29-rc] cxgb3i - add support of chip reset

From: Karen Xie <kxie@chelsio.com>

The cxgb3 driver would reset the chip due to an EEH event or a fatal error
and notifies the upper layer modules (iscsi, rdma).
Upon receiving the notification the cxgb3i driver would 
- close all the iscsi tcp connections and mark the associated sessions as
  failed due to connection error,
- re-initialize its offload functions,
- re-initialize the chip's ddp functions.

The iscsi error recovery mechanism will re-establish the tcp connection after
reset. 

This patch requires the the following cxgb3 patch in the linux-next git tree
(http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=cb0bc205959bf8c60acae9c71f3da0597e756f8e).

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i.h         |   10 +
 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |  258 +++++++++++++++++-----------------
 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |    5 -
 drivers/scsi/cxgb3i/cxgb3i_init.c    |   25 +++
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |  145 +++++++++++++------
 drivers/scsi/cxgb3i/cxgb3i_offload.c |  102 +++++++++----
 drivers/scsi/cxgb3i/cxgb3i_offload.h |   10 +
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |   11 +
 drivers/scsi/cxgb3i/cxgb3i_pdu.h     |    2 
 9 files changed, 338 insertions(+), 230 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index a7cf550..e13c98a 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -66,10 +66,12 @@ struct cxgb3i_hba {
  * @pdev:	pointer to pci dev
  * @hba_cnt:	# of hbas (the same as # of ports)
  * @hba:	all the hbas on this adapter
+ * @flag:	bit flag for adapter event/status
  * @tx_max_size: max. tx packet size supported
  * @rx_max_size: max. rx packet size supported
  * @tag_format: ddp tag format settings
  */
+#define CXGB3I_ADAPTER_FLAG_RESET	0x1
 struct cxgb3i_adapter {
 	struct list_head list_head;
 	spinlock_t lock;
@@ -78,6 +80,7 @@ struct cxgb3i_adapter {
 	unsigned char hba_cnt;
 	struct cxgb3i_hba *hba[MAX_NPORTS];
 
+	unsigned int flags;
 	unsigned int tx_max_size;
 	unsigned int rx_max_size;
 
@@ -137,10 +140,9 @@ struct cxgb3i_task_data {
 int cxgb3i_iscsi_init(void);
 void cxgb3i_iscsi_cleanup(void);
 
-struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *);
-void cxgb3i_adapter_remove(struct t3cdev *);
-int cxgb3i_adapter_ulp_init(struct cxgb3i_adapter *);
-void cxgb3i_adapter_ulp_cleanup(struct cxgb3i_adapter *);
+struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *);
+void cxgb3i_adapter_open(struct t3cdev *);
+void cxgb3i_adapter_close(struct t3cdev *);
 
 struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *);
 struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *,
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index a83d36e..012956b 100644
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
@@ -113,22 +110,30 @@ static int set_ddp_map(struct cxgb3i_ddp_info *ddp, struct pagepod_hdr *hdr,
 	return 0;
 }
 
-static int clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int idx,
-			 unsigned int npods)
+static int clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int tag,
+			 unsigned int idx, unsigned int npods)
 {
 	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
 	int i;
+	int cnt = 0;
 
 	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
 		struct sk_buff *skb = ddp->gl_skb[idx];
 
+		if (!skb) {
+			ddp_log_error("ddp tag 0x%x, 0x%x, %d/%u, skb NULL.\n",
+					tag, idx, i, npods);
+			continue;
+		}
+
+		cnt++;
 		ddp->gl_skb[idx] = NULL;
 		memset((skb->head + sizeof(struct ulp_mem_io)), 0, PPOD_SIZE);
 		ulp_mem_io_set_hdr(skb, pm_addr);
 		skb->priority = CPL_PRIORITY_CONTROL;
 		cxgb3_ofld_send(ddp->tdev, skb);
 	}
-	return 0;
+	return cnt;
 }
 
 static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
@@ -439,14 +444,15 @@ EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_reserve);
  * @tag: ddp tag
  * ddp cleanup for a given ddp tag and release all the resources held
  */
-void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
+int cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
 {
 	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
 	u32 idx;
+	int err = -EINVAL;
 
 	if (!ddp) {
 		ddp_log_error("release ddp tag 0x%x, ddp NULL.\n", tag);
-		return;
+		return err;
 	}
 
 	idx = (tag >> PPOD_IDX_SHIFT) & ddp->idx_mask;
@@ -457,17 +463,26 @@ void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
 		if (!gl) {
 			ddp_log_error("release ddp 0x%x, idx 0x%x, gl NULL.\n",
 				      tag, idx);
-			return;
+			return err;
 		}
 		npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
+		if (!npods) {
+			ddp_log_error("release ddp 0x%x, 0x%x, gl elem %u.\n",
+				      tag, idx, gl->nelem);
+			return err;
+		}
 		ddp_log_debug("ddp tag 0x%x, release idx 0x%x, npods %u.\n",
 			      tag, idx, npods);
-		clear_ddp_map(ddp, idx, npods);
+		if (clear_ddp_map(ddp, tag, idx, npods) == npods)
+			err = 0;
 		ddp_unmark_entries(ddp, idx, npods);
 		cxgb3i_ddp_release_gl(gl, ddp->pdev);
-	} else
+	} else {
 		ddp_log_error("ddp tag 0x%x, idx 0x%x > max 0x%x.\n",
 			      tag, idx, ddp->nppods);
+		return err;
+	}
+	return err;
 }
 EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_release);
 
@@ -565,7 +580,87 @@ int cxgb3i_setup_conn_digest(struct t3cdev *tdev, unsigned int tid,
 }
 EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_digest);
 
-static int ddp_init(struct t3cdev *tdev)
+
+/**
+ * cxgb3i_adapter_ddp_info - initialize the adapter's ddp resource
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
@@ -573,6 +668,12 @@ static int ddp_init(struct t3cdev *tdev)
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
@@ -582,7 +683,7 @@ static int ddp_init(struct t3cdev *tdev)
 	if (err < 0) {
 		ddp_log_error("%s, failed to get iscsi param err=%d.\n",
 				 tdev->name, err);
-		return err;
+		return;
 	}
 
 	ppmax = (uinfo.ulimit - uinfo.llimit + 1) >> PPOD_SIZE_SHIFT;
@@ -599,7 +700,7 @@ static int ddp_init(struct t3cdev *tdev)
 	if (!ddp) {
 		ddp_log_warn("%s unable to alloc ddp 0x%d, ddp disabled.\n",
 			     tdev->name, ppmax);
-		return 0;
+		return;
 	}
 	ddp->gl_map = (struct cxgb3i_gather_list **)(ddp + 1);
 	ddp->gl_skb = (struct sk_buff **)(((char *)ddp->gl_map) +
@@ -633,141 +734,46 @@ static int ddp_init(struct t3cdev *tdev)
 
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
index 3faae78..40224ad 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -286,7 +286,7 @@ static inline u32 cxgb3i_tag_nonrsvd_bits(struct cxgb3i_tag_format *tformat,
 int cxgb3i_ddp_tag_reserve(struct t3cdev *, unsigned int tid,
 			   struct cxgb3i_tag_format *, u32 *tag,
 			   struct cxgb3i_gather_list *, gfp_t gfp);
-void cxgb3i_ddp_tag_release(struct t3cdev *, u32 tag);
+int cxgb3i_ddp_tag_release(struct t3cdev *, u32 tag);
 
 struct cxgb3i_gather_list *cxgb3i_ddp_make_gl(unsigned int xferlen,
 				struct scatterlist *sgl,
@@ -303,7 +303,6 @@ int cxgb3i_setup_conn_pagesize(struct t3cdev *, unsigned int tid, int reply,
 int cxgb3i_setup_conn_digest(struct t3cdev *, unsigned int tid,
 				int hcrc, int dcrc, int reply);
 int cxgb3i_ddp_find_page_index(unsigned long pgsz);
-int cxgb3i_adapter_ddp_init(struct t3cdev *, struct cxgb3i_tag_format *,
+int cxgb3i_adapter_ddp_info(struct t3cdev *, struct cxgb3i_tag_format *,
 			    unsigned int *txsz, unsigned int *rxsz);
-void cxgb3i_adapter_ddp_cleanup(struct t3cdev *);
 #endif
diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 1ce9f24..833dbfa 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -26,6 +26,7 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 
 static void open_s3_dev(struct t3cdev *);
 static void close_s3_dev(struct t3cdev *);
+static void s3_err_handler(struct t3cdev *tdev, u32 status, u32 error);
 
 static cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS];
 static struct cxgb3_client t3c_client = {
@@ -33,6 +34,7 @@ static struct cxgb3_client t3c_client = {
 	.handlers = cxgb3i_cpl_handlers,
 	.add = open_s3_dev,
 	.remove = close_s3_dev,
+	.err_handler = s3_err_handler,
 };
 
 /**
@@ -49,7 +51,7 @@ static void open_s3_dev(struct t3cdev *t3dev)
 	}
 
 	cxgb3i_sdev_add(t3dev, &t3c_client);
-	cxgb3i_adapter_add(t3dev);
+	cxgb3i_adapter_open(t3dev);
 }
 
 /**
@@ -58,10 +60,29 @@ static void open_s3_dev(struct t3cdev *t3dev)
  */
 static void close_s3_dev(struct t3cdev *t3dev)
 {
-	cxgb3i_adapter_remove(t3dev);
+	cxgb3i_adapter_close(t3dev);
 	cxgb3i_sdev_remove(t3dev);
 }
 
+static void s3_err_handler(struct t3cdev *tdev, u32 status, u32 error)
+{
+	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(tdev);
+
+	cxgb3i_log_info("snic 0x%p, tdev 0x%p, status 0x%x, err 0x%x.\n",
+			snic, tdev, status, error);
+	if (!snic)
+		return;
+
+	switch (status) {
+	case OFFLOAD_STATUS_DOWN:
+		snic->flags |= CXGB3I_ADAPTER_FLAG_RESET;
+		break;
+	case OFFLOAD_STATUS_UP:
+		snic->flags &= ~CXGB3I_ADAPTER_FLAG_RESET;
+		break;
+	}
+}
+
 /**
  * cxgb3i_init_module - module init entry point
  *
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index fa2a44f..28bdf0a 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -53,36 +53,90 @@ static LIST_HEAD(cxgb3i_snic_list);
 static DEFINE_RWLOCK(cxgb3i_snic_rwlock);
 
 /**
- * cxgb3i_adapter_add - init a s3 adapter structure and any h/w settings
- * @t3dev: t3cdev adapter
- * return the resulting cxgb3i_adapter struct
+ * cxgb3i_adpater_find_by_tdev - find the cxgb3i_adapter structure with a
+ *	given t3cdev
+ * @tdev: t3cdev pointer
  */
-struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
+struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *tdev)
 {
 	struct cxgb3i_adapter *snic;
-	struct adapter *adapter = tdev2adap(t3dev);
+
+	read_lock(&cxgb3i_snic_rwlock);
+	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
+		if (snic->tdev == tdev) {
+			read_unlock(&cxgb3i_snic_rwlock);
+			return snic;
+		}
+	}
+	read_unlock(&cxgb3i_snic_rwlock);
+	return NULL;
+}
+
+/**
+ * cxgb3i_adapter_remove - release all the resources held and cleanup any
+ *	h/w settings
+ * @t3dev: t3cdev adapter
+ */
+void cxgb3i_adapter_close(struct t3cdev *t3dev)
+{
+	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(t3dev);
 	int i;
 
-	snic = kzalloc(sizeof(*snic), GFP_KERNEL);
-	if (!snic) {
-		cxgb3i_api_debug("cxgb3 %s, OOM.\n", t3dev->name);
-		return NULL;
+	if (!snic || snic->flags & CXGB3I_ADAPTER_FLAG_RESET) {
+		cxgb3i_log_info("t3dev 0x%p close, snic 0x%p, f 0x%x.\n",
+				t3dev, snic, snic ? snic->flags : 0);
+		return;
 	}
-	spin_lock_init(&snic->lock);
 
-	snic->tdev = t3dev;
+	/* remove from the list */
+	write_lock(&cxgb3i_snic_rwlock);
+	list_del(&snic->list_head);
+	write_unlock(&cxgb3i_snic_rwlock);
+
+	for (i = 0; i < snic->hba_cnt; i++) {
+		if (snic->hba[i]) {
+			cxgb3i_hba_host_remove(snic->hba[i]);
+			snic->hba[i] = NULL;
+		}
+	}
+	cxgb3i_log_info("t3dev 0x%p close, snic 0x%p, %u scsi hosts removed.\n",
+			t3dev, snic, snic->hba_cnt);
+	kfree(snic);
+}
+
+/**
+ * cxgb3i_adapter_open - initiate or update a s3 adapter structure and
+ *	any h/w settings
+ * @t3dev: t3cdev adapter
+ */
+static inline int adapter_update(struct cxgb3i_adapter *snic)
+{
+	cxgb3i_log_info("snic 0x%p, t3dev 0x%p, updating.\n",
+			snic, snic->tdev);
+	return cxgb3i_adapter_ddp_info(snic->tdev, &snic->tag_format,
+					&snic->tx_max_size,
+					&snic->rx_max_size);
+}
+
+static int adapter_add(struct cxgb3i_adapter *snic)
+{
+	struct t3cdev *t3dev = snic->tdev;
+	struct adapter *adapter = tdev2adap(t3dev);
+	int i, err;
+
 	snic->pdev = adapter->pdev;
 	snic->tag_format.sw_bits = sw_tag_idx_bits + sw_tag_age_bits;
 
-	if (cxgb3i_adapter_ddp_init(t3dev, &snic->tag_format,
+	err = cxgb3i_adapter_ddp_info(t3dev, &snic->tag_format,
 				    &snic->tx_max_size,
-				    &snic->rx_max_size) < 0)
-		goto free_snic;
+				    &snic->rx_max_size);
+	if (err < 0)
+		return err;
 
 	for_each_port(adapter, i) {
 		snic->hba[i] = cxgb3i_hba_host_add(snic, adapter->port[i]);
 		if (!snic->hba[i])
-			goto ulp_cleanup;
+			return -EINVAL;
 	}
 	snic->hba_cnt = adapter->params.nports;
 
@@ -91,46 +145,35 @@ struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
 	list_add_tail(&snic->list_head, &cxgb3i_snic_list);
 	write_unlock(&cxgb3i_snic_rwlock);
 
-	return snic;
-
-ulp_cleanup:
-	cxgb3i_adapter_ddp_cleanup(t3dev);
-free_snic:
-	kfree(snic);
-	return NULL;
+	cxgb3i_log_info("t3dev 0x%p open, snic 0x%p, %u scsi hosts added.\n",
+			t3dev, snic, snic->hba_cnt);
+	return 0;
 }
 
-/**
- * cxgb3i_adapter_remove - release all the resources held and cleanup any
- *	h/w settings
- * @t3dev: t3cdev adapter
- */
-void cxgb3i_adapter_remove(struct t3cdev *t3dev)
+void cxgb3i_adapter_open(struct t3cdev *t3dev)
 {
-	int i;
-	struct cxgb3i_adapter *snic;
+	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(t3dev);
+	int err;
 
-	/* remove from the list */
-	write_lock(&cxgb3i_snic_rwlock);
-	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
-		if (snic->tdev == t3dev) {
-			list_del(&snic->list_head);
-			break;
-		}
+	if (snic)
+		err = adapter_update(snic);
+	else {
+		snic = kzalloc(sizeof(*snic), GFP_KERNEL);
+		if (snic) {
+			spin_lock_init(&snic->lock);
+			snic->tdev = t3dev;
+			err = adapter_add(snic);
+		} else
+			err = -ENOMEM;
 	}
-	write_unlock(&cxgb3i_snic_rwlock);
 
-	if (snic) {
-		for (i = 0; i < snic->hba_cnt; i++) {
-			if (snic->hba[i]) {
-				cxgb3i_hba_host_remove(snic->hba[i]);
-				snic->hba[i] = NULL;
-			}
+	if (err < 0) {
+		cxgb3i_log_info("snic 0x%p, f 0x%x, t3dev 0x%p open, err %d.\n",
+				snic, snic ? snic->flags : 0, t3dev, err);
+		if (snic) {
+			snic->flags &= ~CXGB3I_ADAPTER_FLAG_RESET;
+			cxgb3i_adapter_close(t3dev);
 		}
-
-		/* release ddp resources */
-		cxgb3i_adapter_ddp_cleanup(snic->tdev);
-		kfree(snic);
 	}
 }
 
@@ -173,7 +216,8 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 				 sizeof(struct cxgb3i_hba),
 				 CXGB3I_SCSI_QDEPTH_DFLT);
 	if (!shost) {
-		cxgb3i_log_info("iscsi_host_alloc failed.\n");
+		cxgb3i_log_info("snic 0x%p, ndev 0x%p, host_alloc failed.\n",
+				snic, ndev);
 		return NULL;
 	}
 
@@ -191,7 +235,8 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 	pci_dev_get(snic->pdev);
 	err = iscsi_host_add(shost, &snic->pdev->dev);
 	if (err) {
-		cxgb3i_log_info("iscsi_host_add failed.\n");
+		cxgb3i_log_info("snic 0x%p, ndev 0x%p, host_add failed.\n",
+				snic, ndev);
 		goto pci_dev_put;
 	}
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index de3b3b6..bd3d0af 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -94,29 +94,30 @@ static int c3cn_get_port(struct s3_conn *c3cn, struct cxgb3i_sdev_data *cdata)
 	if (!cdata)
 		goto error_out;
 
-	if (c3cn->saddr.sin_port != 0) {
-		idx = ntohs(c3cn->saddr.sin_port) - cxgb3_sport_base;
-		if (idx < 0 || idx >= cxgb3_max_connect)
-			return 0;
-		if (!test_and_set_bit(idx, cdata->sport_map))
-			return -EADDRINUSE;
+	if (c3cn->saddr.sin_port) {
+		cxgb3i_log_error("connect, sin_port NON-ZERO %u.\n",
+				 c3cn->saddr.sin_port);
+		return -EADDRINUSE;
 	}
 
-	/* the sport_map_next may not be accurate but that is okay, sport_map
-	   should be */
-	start = idx = cdata->sport_map_next;
+	spin_lock_bh(&cdata->lock);
+	start = idx = cdata->sport_next;
 	do {
 		if (++idx >= cxgb3_max_connect)
 			idx = 0;
-		if (!(test_and_set_bit(idx, cdata->sport_map))) {
+		if (!cdata->sport_conn[idx]) {
 			c3cn->saddr.sin_port = htons(cxgb3_sport_base + idx);
-			cdata->sport_map_next = idx;
+			cdata->sport_next = idx;
+			cdata->sport_conn[idx] = c3cn;
+			spin_unlock_bh(&cdata->lock);
+
 			c3cn_conn_debug("%s reserve port %u.\n",
 					cdata->cdev->name,
 					cxgb3_sport_base + idx);
 			return 0;
 		}
 	} while (idx != start);
+	spin_unlock_bh(&cdata->lock);
 
 error_out:
 	return -EADDRNOTAVAIL;
@@ -124,15 +125,19 @@ error_out:
 
 static void c3cn_put_port(struct s3_conn *c3cn)
 {
-	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(c3cn->cdev);
+	if (!c3cn->cdev)
+		return;
 
 	if (c3cn->saddr.sin_port) {
+		struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(c3cn->cdev);
 		int idx = ntohs(c3cn->saddr.sin_port) - cxgb3_sport_base;
 
 		c3cn->saddr.sin_port = 0;
 		if (idx < 0 || idx >= cxgb3_max_connect)
 			return;
-		clear_bit(idx, cdata->sport_map);
+		spin_lock_bh(&cdata->lock);
+		cdata->sport_conn[idx] = NULL;
+		spin_unlock_bh(&cdata->lock);
 		c3cn_conn_debug("%s, release port %u.\n",
 				cdata->cdev->name, cxgb3_sport_base + idx);
 	}
@@ -187,7 +192,7 @@ static void c3cn_closed(struct s3_conn *c3cn)
 	c3cn_put_port(c3cn);
 	c3cn_release_offload_resources(c3cn);
 	c3cn_set_state(c3cn, C3CN_STATE_CLOSED);
-	cxgb3i_conn_closing(c3cn);
+	cxgb3i_conn_closing(c3cn, c3cn_flag(c3cn, C3CN_OFFLOAD_DOWN));
 }
 
 /*
@@ -886,7 +891,7 @@ static void process_peer_close(struct s3_conn *c3cn, struct sk_buff *skb)
 				 c3cn->cdev->name, c3cn->tid, c3cn->state);
 	}
 
-	cxgb3i_conn_closing(c3cn);
+	cxgb3i_conn_closing(c3cn, 0);
 out:
 	__kfree_skb(skb);
 }
@@ -1305,11 +1310,7 @@ static void c3cn_release_offload_resources(struct s3_conn *c3cn)
 	struct t3cdev *cdev = c3cn->cdev;
 	unsigned int tid = c3cn->tid;
 
-	if (!cdev)
-		return;
-
 	c3cn->qset = 0;
-
 	c3cn_free_cpl_skbs(c3cn);
 
 	if (c3cn->wr_avail != c3cn->wr_max) {
@@ -1317,18 +1318,22 @@ static void c3cn_release_offload_resources(struct s3_conn *c3cn)
 		reset_wr_list(c3cn);
 	}
 
-	if (c3cn->l2t) {
-		l2t_release(L2DATA(cdev), c3cn->l2t);
-		c3cn->l2t = NULL;
-	}
-
-	if (c3cn->state == C3CN_STATE_CONNECTING) /* we have ATID */
-		s3_free_atid(cdev, tid);
-	else {		/* we have TID */
-		cxgb3_remove_tid(cdev, (void *)c3cn, tid);
-		c3cn_put(c3cn);
+	if (cdev) {
+		if (c3cn->l2t) {
+			l2t_release(L2DATA(cdev), c3cn->l2t);
+			c3cn->l2t = NULL;
+		}
+		if (c3cn->state == C3CN_STATE_CONNECTING)
+			/* we have ATID */
+			s3_free_atid(cdev, tid);
+		else {
+			/* we have TID */
+			cxgb3_remove_tid(cdev, (void *)c3cn, tid);
+			c3cn_put(c3cn);
+		}
 	}
 
+	c3cn->dst_cache = NULL;
 	c3cn->cdev = NULL;
 }
 
@@ -1425,10 +1430,10 @@ void cxgb3i_c3cn_release(struct s3_conn *c3cn)
 {
 	c3cn_conn_debug("c3cn 0x%p, s %u, f 0x%lx.\n",
 			c3cn, c3cn->state, c3cn->flags);
-	if (likely(c3cn->state != C3CN_STATE_CONNECTING))
-		c3cn_active_close(c3cn);
-	else
+	if (unlikely(c3cn->state == C3CN_STATE_CONNECTING))
 		c3cn_set_flag(c3cn, C3CN_ACTIVE_CLOSE_NEEDED);
+	else if (likely(c3cn->state != C3CN_STATE_CLOSED))
+		c3cn_active_close(c3cn);
 	c3cn_put(c3cn);
 }
 
@@ -1657,7 +1662,6 @@ int cxgb3i_c3cn_connect(struct s3_conn *c3cn, struct sockaddr_in *usin)
 	c3cn_set_state(c3cn, C3CN_STATE_CLOSED);
 	ip_rt_put(rt);
 	c3cn_put_port(c3cn);
-	c3cn->daddr.sin_port = 0;
 	return err;
 }
 
@@ -1777,10 +1781,25 @@ out_err:
 static void sdev_data_cleanup(struct cxgb3i_sdev_data *cdata)
 {
 	struct adap_ports *ports = &cdata->ports;
+	struct s3_conn *c3cn;
 	int i;
 
+	for (i = 0; i < cxgb3_max_connect; i++) {
+		if (cdata->sport_conn[i]) {
+			c3cn = cdata->sport_conn[i];
+			cdata->sport_conn[i] = NULL;
+
+			spin_lock_bh(&c3cn->lock);
+			c3cn->cdev = NULL;
+			c3cn_set_flag(c3cn, C3CN_OFFLOAD_DOWN);
+			c3cn_closed(c3cn);
+			spin_unlock_bh(&c3cn->lock);
+		}
+	}
+
 	for (i = 0; i < ports->nports; i++)
 		NDEV2CDATA(ports->lldevs[i]) = NULL;
+
 	cxgb3i_free_big_mem(cdata);
 }
 
@@ -1822,21 +1841,27 @@ void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
 	struct cxgb3i_sdev_data *cdata;
 	struct ofld_page_info rx_page_info;
 	unsigned int wr_len;
-	int mapsize = DIV_ROUND_UP(cxgb3_max_connect,
-				   8 * sizeof(unsigned long));
+	int mapsize = cxgb3_max_connect * sizeof(struct s3_conn *);
 	int i;
 
 	cdata =  cxgb3i_alloc_big_mem(sizeof(*cdata) + mapsize, GFP_KERNEL);
-	if (!cdata)
+	if (!cdata) {
+		cxgb3i_log_warn("t3dev 0x%p, offload up, OOM %d.\n",
+				cdev, mapsize);
 		return;
+	}
 
 	if (cdev->ctl(cdev, GET_WR_LEN, &wr_len) < 0 ||
 	    cdev->ctl(cdev, GET_PORTS, &cdata->ports) < 0 ||
-	    cdev->ctl(cdev, GET_RX_PAGE_INFO, &rx_page_info) < 0)
+	    cdev->ctl(cdev, GET_RX_PAGE_INFO, &rx_page_info) < 0) {
+		cxgb3i_log_warn("t3dev 0x%p, offload up, ioctl failed.\n",
+				cdev);
 		goto free_cdata;
+	}
 
 	s3_init_wr_tab(wr_len);
 
+	spin_lock_init(&cdata->lock);
 	INIT_LIST_HEAD(&cdata->list);
 	cdata->cdev = cdev;
 	cdata->client = client;
@@ -1848,6 +1873,7 @@ void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
 	list_add_tail(&cdata->list, &cdata_list);
 	write_unlock(&cdata_rwlock);
 
+	cxgb3i_log_info("t3dev 0x%p, offload up, added.\n", cdev);
 	return;
 
 free_cdata:
@@ -1862,6 +1888,8 @@ void cxgb3i_sdev_remove(struct t3cdev *cdev)
 {
 	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(cdev);
 
+	cxgb3i_log_info("t3dev 0x%p, offload down, remove.\n", cdev);
+
 	write_lock(&cdata_rwlock);
 	list_del(&cdata->list);
 	write_unlock(&cdata_rwlock);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 6344b9e..dab759d 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -135,6 +135,7 @@ enum c3cn_flags {
 	C3CN_ABORT_RPL_PENDING,	/* expecting an abort reply */
 	C3CN_TX_DATA_SENT,	/* already sent a TX_DATA WR */
 	C3CN_ACTIVE_CLOSE_NEEDED,	/* need to be closed */
+	C3CN_OFFLOAD_DOWN	/* offload function off */
 };
 
 /**
@@ -147,16 +148,17 @@ enum c3cn_flags {
  * @cdev:	t3cdev adapter
  * @client:	CPL client pointer
  * @ports:	array of adapter ports
- * @sport_map_next: next index into the port map
- * @sport_map:	source port map
+ * @sport_next: next port
+ * @sport_conn:	source port connection
  */
 struct cxgb3i_sdev_data {
 	struct list_head list;
 	struct t3cdev *cdev;
 	struct cxgb3_client *client;
 	struct adap_ports ports;
-	unsigned int sport_map_next;
-	unsigned long sport_map[0];
+	spinlock_t lock;
+	unsigned int sport_next;
+	struct s3_conn *sport_conn[0];
 };
 #define NDEV2CDATA(ndev) (*(struct cxgb3i_sdev_data **)&(ndev)->ec_ptr)
 #define CXGB3_SDEV_DATA(cdev) NDEV2CDATA((cdev)->lldev)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 17115c2..f104326 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -483,13 +483,18 @@ void cxgb3i_conn_tx_open(struct s3_conn *c3cn)
 	}
 }
 
-void cxgb3i_conn_closing(struct s3_conn *c3cn)
+void cxgb3i_conn_closing(struct s3_conn *c3cn, int error)
 {
 	struct iscsi_conn *conn;
 
 	read_lock(&c3cn->callback_lock);
 	conn = c3cn->user_data;
-	if (conn && c3cn->state != C3CN_STATE_ESTABLISHED)
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	if (conn && c3cn->state != C3CN_STATE_ESTABLISHED) {
+		if (error)
+			iscsi_session_failure(conn->session,
+						ISCSI_ERR_CONN_FAILED);
+		else
+			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	}
 	read_unlock(&c3cn->callback_lock);
 }
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.h b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
index 0770b23..df4a876 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
@@ -53,7 +53,7 @@ struct cpl_rx_data_ddp_norss {
 #define ULP2_FLAG_DCRC_ERROR		0x20
 #define ULP2_FLAG_PAD_ERROR		0x40
 
-void cxgb3i_conn_closing(struct s3_conn *c3cn);
+void cxgb3i_conn_closing(struct s3_conn *c3cn, int);
 void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn);
 void cxgb3i_conn_tx_open(struct s3_conn *c3cn);
 #endif
