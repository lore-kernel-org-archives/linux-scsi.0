From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 1/3 2.6.29] cxgb3i -- split ddp set up code out
Date: Sat, 6 Dec 2008 23:10:24 -0800
Message-ID: <200812070710.mB77AOkC020879@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:2832 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYLGHJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 02:09:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 1/3 2.6.29] cxgb3i -- split ddp set up code out

From: Karen Xie <kxie@chelsio.com>

- split ddp pagepod manager out to a sperate module to support multiple
  iscsi entities.
- fixed cxgb3i code to work with the new core change.
- when parsing host memory scatterlist for transmitting or ddp setup,
  coalesce the buffers as much as possible.
- split setting of the host page size and connection digest settings into 
  seperate functions.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/Makefile       |    3 
 drivers/scsi/cxgb3i/cxgb3i.h       |   58 ---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c   |  771 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxgb3i/cxgb3i_ddp.h   |  306 ++++++++++++++
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |  310 ++++++++++----
 drivers/scsi/cxgb3i/cxgb3i_ulp2.c  |  513 ++++--------------------
 drivers/scsi/cxgb3i/cxgb3i_ulp2.h  |   49 --
 7 files changed, 1373 insertions(+), 637 deletions(-)
 create mode 100644 drivers/scsi/cxgb3i/cxgb3i_ddp.c
 create mode 100644 drivers/scsi/cxgb3i/cxgb3i_ddp.h


diff --git a/drivers/scsi/cxgb3i/Makefile b/drivers/scsi/cxgb3i/Makefile
index 8c8a894..3481f64 100644
--- a/drivers/scsi/cxgb3i/Makefile
+++ b/drivers/scsi/cxgb3i/Makefile
@@ -1,5 +1,4 @@
 EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3
 
 cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_ulp2.o cxgb3i_offload.o
-
-obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
+obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i_ddp.o cxgb3i.o
diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index f4eef28..1c2301e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -29,7 +29,9 @@
 #include "cxgb3_ctl_defs.h"
 #include "cxgb3_offload.h"
 #include "firmware_exports.h"
+
 #include "cxgb3i_offload.h"
+#include "cxgb3i_ddp.h"
 
 #define CXGB3I_SCSI_QDEPTH_DFLT	128
 #define CXGB3I_MAX_TARGET	CXGB3I_MAX_CONN
@@ -41,45 +43,6 @@ struct cxgb3i_hba;
 struct cxgb3i_endpoint;
 
 /**
- * struct cxgb3i_tag_format - cxgb3i ulp tag for steering pdu payload
- *
- * @idx_bits:	# of bits used to store itt (from iscsi laryer)
- * @age_bits:	# of bits used to store age (from iscsi laryer)
- * @rsvd_bits:	# of bits used by h/w
- * @rsvd_shift:	shift left
- * @rsvd_mask:  bit mask
- * @rsvd_tag_mask:  h/w tag bit mask
- *
- */
-struct cxgb3i_tag_format {
-	unsigned char idx_bits;
-	unsigned char age_bits;
-	unsigned char rsvd_bits;
-	unsigned char rsvd_shift;
-	u32 rsvd_mask;
-	u32 rsvd_tag_mask;
-};
-
-/**
- * struct cxgb3i_ddp_info - cxgb3i direct data placement for pdu payload
- *
- * @llimit:	lower bound of the page pod memory
- * @ulimit:	upper bound of the page pod memory
- * @nppods:	# of page pod entries
- * @idx_last:	page pod entry last used
- * @map_lock:	lock to synchonize access to the page pod map
- * @map:	page pod map
- */
-struct cxgb3i_ddp_info {
-	unsigned int llimit;
-	unsigned int ulimit;
-	unsigned int nppods;
-	unsigned int idx_last;
-	spinlock_t map_lock;
-	u8 *map;
-};
-
-/**
  * struct cxgb3i_hba - cxgb3i iscsi structure (per port)
  *
  * @snic:	cxgb3i adapter containing this port
@@ -103,8 +66,7 @@ struct cxgb3i_hba {
  * @hba:	all the hbas on this adapter
  * @tx_max_size: max. tx packet size supported
  * @rx_max_size: max. rx packet size supported
- * @tag_format: ulp tag format settings
- * @ddp:	ulp ddp state
+ * @tag_format: ddp tag format settings
  */
 struct cxgb3i_adapter {
 	struct list_head list_head;
@@ -118,22 +80,23 @@ struct cxgb3i_adapter {
 	unsigned int rx_max_size;
 
 	struct cxgb3i_tag_format tag_format;
-	struct cxgb3i_ddp_info ddp;
 };
 
 /**
  * struct cxgb3i_conn - cxgb3i iscsi connection
  *
- * @tcp_conn:	pointer to iscsi_tcp_conn structure
  * @listhead:	list head to link elements
+ * @conn:	pointer to iscsi_endpoint structure
  * @conn:	pointer to iscsi_conn structure
  * @hba:	pointer to the hba this conn. is going through
+ * @task_idx_bits: # of bits needed for session->cmds_max
  */
 struct cxgb3i_conn {
 	struct list_head list_head;
 	struct cxgb3i_endpoint *cep;
 	struct iscsi_conn *conn;
 	struct cxgb3i_hba *hba;
+	unsigned int task_idx_bits;
 };
 
 /**
@@ -149,9 +112,6 @@ struct cxgb3i_endpoint {
 	struct cxgb3i_conn *cconn;
 };
 
-/*
- * Function Prototypes
- */
 int cxgb3i_iscsi_init(void);
 void cxgb3i_iscsi_cleanup(void);
 
@@ -167,12 +127,6 @@ void cxgb3i_hba_host_remove(struct cxgb3i_hba *);
 
 int cxgb3i_ulp2_init(void);
 void cxgb3i_ulp2_cleanup(void);
-int cxgb3i_conn_ulp_setup(struct cxgb3i_conn *, int, int);
-void cxgb3i_ddp_tag_release(struct cxgb3i_adapter *, u32,
-			    struct scatterlist *, unsigned int);
-u32 cxgb3i_ddp_tag_reserve(struct cxgb3i_adapter *, unsigned int,
-			   u32, unsigned int, struct scatterlist *,
-			   unsigned int);
 void cxgb3i_conn_ulp2_cleanup_task(struct iscsi_task *);
 int cxgb3i_conn_ulp2_alloc_pdu(struct iscsi_task *, u8);
 int cxgb3i_conn_ulp2_init_pdu(struct iscsi_task *, unsigned int, unsigned int);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
new file mode 100644
index 0000000..5322af3
--- /dev/null
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -0,0 +1,771 @@
+/*
+ * cxgb3i_ddp.c: Chelsio S3xx iSCSI DDP Manager.
+ *
+ * Copyright (c) 2008 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ * Written by: Karen Xie (kxie@chelsio.com)
+ */
+
+#include <linux/skbuff.h>
+
+/* from cxgb3 LLD */
+#include "common.h"
+#include "t3_cpl.h"
+#include "t3cdev.h"
+#include "cxgb3_ctl_defs.h"
+#include "cxgb3_offload.h"
+#include "firmware_exports.h"
+
+#include "cxgb3i_ddp.h"
+
+#define DRV_MODULE_NAME         "cxgb3i_ddp"
+#define DRV_MODULE_VERSION      "1.0.0"
+#define DRV_MODULE_RELDATE      "Dec. 1, 2008"
+
+static char version[] =
+	"Chelsio S3xx iSCSI DDP " DRV_MODULE_NAME
+	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+
+MODULE_AUTHOR("Karen Xie <kxie@chelsio.com>");
+MODULE_DESCRIPTION("cxgb3i ddp pagepod manager");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_MODULE_VERSION);
+
+#define ddp_log_error(fmt...) printk(KERN_ERR "cxgb3i_ddp: ERR! " fmt)
+#define ddp_log_warn(fmt...)  printk(KERN_WARNING "cxgb3i_ddp: WARN! " fmt)
+#define ddp_log_info(fmt...)  printk(KERN_INFO "cxgb3i_ddp: " fmt)
+
+#ifdef __DEBUG_CXGB3I_DDP__
+#define ddp_log_debug(fmt, args...) \
+	printk(KERN_INFO "cxgb3i_ddp: %s - " fmt, __func__ , ## args)
+#else
+#define ddp_log_debug(fmt...)
+#endif
+
+/*
+ * iSCSI Direct Data Placement
+ *
+ * T3 h/w can directly place the iSCSI Data-In or Data-Out PDU's payload into
+ * pre-posted final destination host-memory buffers based on the Initiator
+ * Task Tag (ITT) in Data-In or Target Task Tag (TTT) in Data-Out PDUs.
+ *
+ * The host memory address is programmed into h/w in the format of pagepod
+ * entries.
+ * The location of the pagepod entry is encoded into ddp tag which is used or
+ * is the base for ITT/TTT.
+ */
+
+#define DDP_PGIDX_MAX		4
+#define DDP_THRESHOLD	2048
+static unsigned char ddp_page_order[DDP_PGIDX_MAX] = {0, 1, 2, 4};
+static unsigned char ddp_page_shift[DDP_PGIDX_MAX] = {12, 13, 14, 16};
+static unsigned char page_idx = DDP_PGIDX_MAX;
+
+static LIST_HEAD(cxgb3i_ddp_list);
+static DEFINE_RWLOCK(cxgb3i_ddp_rwlock);
+
+/*
+ * functions to program the pagepod in h/w
+ */
+static inline void ulp_mem_io_set_hdr(struct sk_buff *skb, unsigned int addr)
+{
+	struct ulp_mem_io *req = (struct ulp_mem_io *)skb->head;
+
+	req->wr.wr_lo = 0;
+	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_BYPASS));
+	req->cmd_lock_addr = htonl(V_ULP_MEMIO_ADDR(addr >> 5) |
+				   V_ULPTX_CMD(ULP_MEM_WRITE));
+	req->len = htonl(V_ULP_MEMIO_DATA_LEN(PPOD_SIZE >> 5) |
+			 V_ULPTX_NFLITS((PPOD_SIZE >> 3) + 1));
+}
+
+static int set_ddp_map(struct cxgb3i_ddp_info *ddp, struct pagepod_hdr *hdr,
+		       unsigned int idx, unsigned int npods,
+		       struct cxgb3i_gather_list *gl)
+{
+	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
+	int i;
+
+	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
+		struct sk_buff *skb = ddp->gl_skb[idx];
+		struct pagepod *ppod;
+		int j, pidx;
+
+		/* hold on to the skb until we clear the ddp mapping */
+		skb_get(skb);
+
+		ulp_mem_io_set_hdr(skb, pm_addr);
+		ppod = (struct pagepod *)
+		       (skb->head + sizeof(struct ulp_mem_io));
+		memcpy(&(ppod->hdr), hdr, sizeof(struct pagepod));
+		for (pidx = 4 * i, j = 0; j < 5; ++j, ++pidx)
+			ppod->addr[j] = pidx < gl->nelem ?
+				     cpu_to_be64(gl->phys_addr[pidx]) : 0UL;
+
+		skb->priority = CPL_PRIORITY_CONTROL;
+		cxgb3_ofld_send(ddp->tdev, skb);
+	}
+	return 0;
+}
+
+static int clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int idx,
+			 unsigned int npods)
+{
+	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
+	int i;
+
+	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
+		struct sk_buff *skb = ddp->gl_skb[idx];
+
+		ddp->gl_skb[idx] = NULL;
+		memset((skb->head + sizeof(struct ulp_mem_io)), 0, PPOD_SIZE);
+		ulp_mem_io_set_hdr(skb, pm_addr);
+		skb->priority = CPL_PRIORITY_CONTROL;
+		cxgb3_ofld_send(ddp->tdev, skb);
+	}
+	return 0;
+}
+
+static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
+					  int start, int max, int count,
+					  struct cxgb3i_gather_list *gl)
+{
+	unsigned int i, j;
+
+	spin_lock(&ddp->map_lock);
+	for (i = start; i <= max;) {
+		for (j = 0; j < count; j++) {
+			if (ddp->gl_map[i + j])
+				break;
+		}
+		if (j == count) {
+			for (j = 0; j < count; j++)
+				ddp->gl_map[i + j] = gl;
+			spin_unlock(&ddp->map_lock);
+			return i;
+		}
+		i += j + 1;
+	}
+	spin_unlock(&ddp->map_lock);
+	return -EBUSY;
+}
+
+static inline void ddp_unmark_entries(struct cxgb3i_ddp_info *ddp,
+				      int start, int count)
+{
+	spin_lock(&ddp->map_lock);
+	memset(&ddp->gl_map[start], 0,
+	       count * sizeof(struct cxgb3i_gather_list *));
+	spin_unlock(&ddp->map_lock);
+}
+
+static inline void ddp_free_gl_skb(struct cxgb3i_ddp_info *ddp,
+				   int idx, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++, idx++)
+		if (ddp->gl_skb[idx]) {
+			kfree_skb(ddp->gl_skb[idx]);
+			ddp->gl_skb[idx] = NULL;
+		}
+}
+
+static inline int ddp_alloc_gl_skb(struct cxgb3i_ddp_info *ddp, int idx,
+				   int count, gfp_t gfp)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		struct sk_buff *skb = alloc_skb(sizeof(struct ulp_mem_io) +
+						PPOD_SIZE, gfp);
+		if (skb) {
+			ddp->gl_skb[idx + i] = skb;
+			skb_put(skb, sizeof(struct ulp_mem_io) + PPOD_SIZE);
+		} else {
+			ddp_free_gl_skb(ddp, idx, i);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+/**
+ * cxgb3i_ddp_find_page_index - return ddp page index for a given page size.
+ * @pgsz: page size
+ * return the ddp page index, if no match is found return DDP_PGIDX_MAX.
+ */
+int cxgb3i_ddp_find_page_index(unsigned long pgsz)
+{
+	int i;
+
+	for (i = 0; i < DDP_PGIDX_MAX; i++) {
+		if (pgsz == (1UL << ddp_page_shift[i]))
+			return i;
+	}
+	ddp_log_debug("ddp page size 0x%lx not supported.\n", pgsz);
+	return DDP_PGIDX_MAX;
+}
+EXPORT_SYMBOL_GPL(cxgb3i_ddp_find_page_index);
+
+static inline void ddp_gl_unmap(struct pci_dev *pdev,
+				struct cxgb3i_gather_list *gl)
+{
+	int i;
+
+	for (i = 0; i < gl->nelem; i++)
+		pci_unmap_page(pdev, gl->phys_addr[i], PAGE_SIZE,
+			       PCI_DMA_FROMDEVICE);
+}
+
+static inline int ddp_gl_map(struct pci_dev *pdev,
+			     struct cxgb3i_gather_list *gl)
+{
+	int i;
+
+	for (i = 0; i < gl->nelem; i++) {
+		gl->phys_addr[i] = pci_map_page(pdev, gl->pages[i], 0,
+						PAGE_SIZE,
+						PCI_DMA_FROMDEVICE);
+		if (unlikely(pci_dma_mapping_error(pdev, gl->phys_addr[i])))
+			goto unmap;
+	}
+
+	return i;
+
+unmap:
+	if (i) {
+		unsigned int nelem = gl->nelem;
+
+		gl->nelem = i;
+		ddp_gl_unmap(pdev, gl);
+		gl->nelem = nelem;
+	}
+	return -ENOMEM;
+}
+
+/**
+ * cxgb3i_ddp_make_gl - build ddp page buffer list
+ * @xferlen: total buffer length
+ * @sgl: page buffer scatter-gather list
+ * @sgcnt: # of page buffers
+ * @pdev: pci_dev, used for pci map
+ * @gfp: allocation mode
+ *
+ * construct a ddp page buffer list from the scsi scattergather list.
+ * coalesce buffers as much as possible, and obtain dma addresses for
+ * each page.
+ *
+ * Return the cxgb3i_gather_list constructed from the page buffers if the
+ * memory can be used for ddp. Return NULL otherwise.
+ */
+struct cxgb3i_gather_list *cxgb3i_ddp_make_gl(unsigned int xferlen,
+					      struct scatterlist *sgl,
+					      unsigned int sgcnt,
+					      struct pci_dev *pdev,
+					      gfp_t gfp)
+{
+	struct cxgb3i_gather_list *gl;
+	struct scatterlist *sg = sgl;
+	struct page *sgpage = sg_page(sg);
+	unsigned int sglen = sg->length;
+	unsigned int sgoffset = sg->offset;
+	unsigned int npages = (xferlen + sgoffset + PAGE_SIZE - 1) >>
+			      PAGE_SHIFT;
+	int i = 1, j = 0;
+
+	if (xferlen < DDP_THRESHOLD) {
+		ddp_log_debug("xfer %u < threshold %u, no ddp.\n",
+			      xferlen, DDP_THRESHOLD);
+		return NULL;
+	}
+
+	gl = kzalloc(sizeof(struct cxgb3i_gather_list) +
+		     npages * (sizeof(dma_addr_t) + sizeof(struct page *)),
+		     gfp);
+	if (!gl)
+		return NULL;
+
+	gl->pages = (struct page **)&gl->phys_addr[npages];
+	gl->length = xferlen;
+	gl->offset = sgoffset;
+	gl->pages[0] = sgpage;
+
+	sg = sg_next(sg);
+	while (sg) {
+		struct page *page = sg_page(sg);
+
+		if (sgpage == page && sg->offset == sgoffset + sglen)
+			sglen += sg->length;
+		else {
+			/* make sure the sgl is fit for ddp:
+			 * each has the same page size, and
+			 * all of the middle pages are used completely
+			 */
+			if ((j && sgoffset) ||
+			    ((i != sgcnt - 1) &&
+			     ((sglen + sgoffset) & ~PAGE_MASK)))
+				goto error_out;
+
+			j++;
+			if (j == gl->nelem || sg->offset)
+				goto error_out;
+			gl->pages[j] = page;
+			sglen = sg->length;
+			sgoffset = sg->offset;
+			sgpage = page;
+		}
+		i++;
+		sg = sg_next(sg);
+	}
+	gl->nelem = ++j;
+
+	if (ddp_gl_map(pdev, gl) < 0)
+		goto error_out;
+
+	return gl;
+
+error_out:
+	kfree(gl);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(cxgb3i_ddp_make_gl);
+
+/**
+ * cxgb3i_ddp_release_gl - release a page buffer list
+ * @gl: a ddp page buffer list
+ * @pdev: pci_dev used for pci_unmap
+ * free a ddp page buffer list resulted from cxgb3i_ddp_make_gl().
+ */
+void cxgb3i_ddp_release_gl(struct cxgb3i_gather_list *gl,
+			   struct pci_dev *pdev)
+{
+	ddp_gl_unmap(pdev, gl);
+	kfree(gl);
+}
+EXPORT_SYMBOL_GPL(cxgb3i_ddp_release_gl);
+
+/**
+ * cxgb3i_ddp_tag_reserve - set up ddp for a data transfer
+ * @tdev: t3cdev adapter
+ * @tid: connection id
+ * @tformat: tag format
+ * @tagp: the s/w tag, if ddp setup is successful, it will be updated with
+ *	  ddp/hw tag
+ * @gl: the page momory list
+ * @gfp: allocation mode
+ *
+ * ddp setup for a given page buffer list and construct the ddp tag.
+ * return 0 if success, < 0 otherwise.
+ */
+int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
+			   struct cxgb3i_tag_format *tformat, u32 *tagp,
+			   struct cxgb3i_gather_list *gl, gfp_t gfp)
+{
+	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
+	struct pagepod_hdr hdr;
+	unsigned int npods;
+	int idx = -1, idx_max;
+	int err = -ENOMEM;
+	u32 sw_tag = *tagp;
+	u32 tag;
+
+	if (page_idx >= DDP_PGIDX_MAX || !ddp || !gl || !gl->nelem ||
+		gl->length < DDP_THRESHOLD) {
+		ddp_log_debug("pgidx %u, xfer %u/%u, NO ddp.\n",
+			      page_idx, gl->length, DDP_THRESHOLD);
+		return -EINVAL;
+	}
+
+	npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
+	idx_max = ddp->nppods - npods + 1;
+
+	if (ddp->idx_last == ddp->nppods)
+		idx = ddp_find_unused_entries(ddp, 0, idx_max, npods, gl);
+	else {
+		idx = ddp_find_unused_entries(ddp, ddp->idx_last + 1,
+					      idx_max, npods, gl);
+		if (idx < 0 && ddp->idx_last >= npods)
+			idx = ddp_find_unused_entries(ddp, 0,
+						      ddp->idx_last - npods + 1,
+						      npods, gl);
+	}
+	if (idx < 0) {
+		ddp_log_debug("xferlen %u, gl %u, npods %u NO DDP.\n",
+			      gl->length, gl->nelem, npods);
+		return idx;
+	}
+
+	err = ddp_alloc_gl_skb(ddp, idx, npods, gfp);
+	if (err < 0)
+		goto unmark_entries;
+
+	tag = cxgb3i_ddp_tag_base(tformat, sw_tag);
+	tag |= idx << PPOD_IDX_SHIFT;
+
+	hdr.rsvd = 0;
+	hdr.vld_tid = htonl(F_PPOD_VALID | V_PPOD_TID(tid));
+	hdr.pgsz_tag_clr = htonl(tag & ddp->rsvd_tag_mask);
+	hdr.maxoffset = htonl(gl->length);
+	hdr.pgoffset = htonl(gl->offset);
+
+	err = set_ddp_map(ddp, &hdr, idx, npods, gl);
+	if (err < 0)
+		goto free_gl_skb;
+
+	ddp->idx_last = idx;
+	ddp_log_debug("xfer %u, gl %u,%u, tid 0x%x, 0x%x -> 0x%x(%u,%u).\n",
+		      gl->length, gl->nelem, gl->offset, tid, sw_tag, tag,
+		      idx, npods);
+	*tagp = tag;
+	return 0;
+
+free_gl_skb:
+	ddp_free_gl_skb(ddp, idx, npods);
+unmark_entries:
+	ddp_unmark_entries(ddp, idx, npods);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_reserve);
+
+/**
+ * cxgb3i_ddp_tag_release - release a ddp tag
+ * @tdev: t3cdev adapter
+ * @tag: ddp tag
+ * ddp cleanup for a given ddp tag and release all the resources held
+ */
+void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
+{
+	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
+	u32 idx;
+
+	if (!ddp) {
+		ddp_log_error("release ddp tag 0x%x, ddp NULL.\n", tag);
+		return;
+	}
+
+	idx = (tag >> PPOD_IDX_SHIFT) & ddp->idx_mask;
+	if (idx < ddp->nppods) {
+		struct cxgb3i_gather_list *gl = ddp->gl_map[idx];
+		unsigned int npods;
+
+		if (!gl) {
+			ddp_log_error("release ddp 0x%x, idx 0x%x, gl NULL.\n",
+				      tag, idx);
+			return;
+		}
+		npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
+		ddp_log_debug("ddp tag 0x%x, release idx 0x%x, npods %u.\n",
+			      tag, idx, npods);
+		clear_ddp_map(ddp, idx, npods);
+		ddp_unmark_entries(ddp, idx, npods);
+		cxgb3i_ddp_release_gl(gl, ddp->pdev);
+	} else
+		ddp_log_error("ddp tag 0x%x, idx 0x%x > max 0x%x.\n",
+			      tag, idx, ddp->nppods);
+}
+EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_release);
+
+static int setup_conn_pgidx(struct t3cdev *tdev, unsigned int tid, int pg_idx,
+			    int reply)
+{
+	struct sk_buff *skb = alloc_skb(sizeof(struct cpl_set_tcb_field),
+					GFP_KERNEL);
+	struct cpl_set_tcb_field *req;
+	u64 val = pg_idx < DDP_PGIDX_MAX ? pg_idx : 0;
+
+	if (!skb)
+		return -ENOMEM;
+
+	/* set up ulp submode and page size */
+	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
+	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
+	req->reply = V_NO_REPLY(reply ? 0 : 1);
+	req->cpu_idx = 0;
+	req->word = htons(31);
+	req->mask = cpu_to_be64(0xF0000000);
+	req->val = cpu_to_be64(val << 28);
+	skb->priority = CPL_PRIORITY_CONTROL;
+
+	cxgb3_ofld_send(tdev, skb);
+	return 0;
+}
+
+/**
+ * cxgb3i_setup_conn_host_pagesize - setup the conn.'s ddp page size
+ * @tdev: t3cdev adapter
+ * @tid: connection id
+ * @reply: request reply from h/w
+ * set up the ddp page size based on the host PAGE_SIZE for a connection
+ * identified by tid
+ */
+int cxgb3i_setup_conn_host_pagesize(struct t3cdev *tdev, unsigned int tid,
+				    int reply)
+{
+	return setup_conn_pgidx(tdev, tid, page_idx, reply);
+}
+EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_host_pagesize);
+
+/**
+ * cxgb3i_setup_conn_pagesize - setup the conn.'s ddp page size
+ * @tdev: t3cdev adapter
+ * @tid: connection id
+ * @reply: request reply from h/w
+ * @pgsz: ddp page size
+ * set up the ddp page size for a connection identified by tid
+ */
+int cxgb3i_setup_conn_pagesize(struct t3cdev *tdev, unsigned int tid,
+				int reply, unsigned long pgsz)
+{
+	int pgidx = cxgb3i_ddp_find_page_index(pgsz);
+
+	return setup_conn_pgidx(tdev, tid, pgidx, reply);
+}
+EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_pagesize);
+
+/**
+ * cxgb3i_setup_conn_digest - setup conn. digest setting
+ * @tdev: t3cdev adapter
+ * @tid: connection id
+ * @hcrc: header digest enabled
+ * @dcrc: data digest enabled
+ * @reply: request reply from h/w
+ * set up the iscsi digest settings for a connection identified by tid
+ */
+int cxgb3i_setup_conn_digest(struct t3cdev *tdev, unsigned int tid,
+			     int hcrc, int dcrc, int reply)
+{
+	struct sk_buff *skb = alloc_skb(sizeof(struct cpl_set_tcb_field),
+					GFP_KERNEL);
+	struct cpl_set_tcb_field *req;
+	u64 val = (hcrc ? 1 : 0) | (dcrc ? 2 : 0);
+
+	if (!skb)
+		return -ENOMEM;
+
+	/* set up ulp submode and page size */
+	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
+	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
+	req->reply = V_NO_REPLY(reply ? 0 : 1);
+	req->cpu_idx = 0;
+	req->word = htons(31);
+	req->mask = cpu_to_be64(0x0F000000);
+	req->val = cpu_to_be64(val << 24);
+	skb->priority = CPL_PRIORITY_CONTROL;
+
+	cxgb3_ofld_send(tdev, skb);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_digest);
+
+static int ddp_init(struct t3cdev *tdev)
+{
+	struct cxgb3i_ddp_info *ddp;
+	struct ulp_iscsi_info uinfo;
+	unsigned int ppmax, bits;
+	int i, err;
+	static int vers_printed;
+
+	if (!vers_printed) {
+		printk(KERN_INFO "%s", version);
+		vers_printed = 1;
+	}
+
+	err = tdev->ctl(tdev, ULP_ISCSI_GET_PARAMS, &uinfo);
+	if (err < 0) {
+		ddp_log_error("%s, failed to get iscsi param err=%d.\n",
+				 tdev->name, err);
+		return err;
+	}
+
+	ppmax = (uinfo.ulimit - uinfo.llimit + 1) >> PPOD_SIZE_SHIFT;
+	bits = __ilog2_u32(ppmax) + 1;
+	if (bits > PPOD_IDX_MAX_SIZE)
+		bits = PPOD_IDX_MAX_SIZE;
+	ppmax = (1 << (bits - 1)) - 1;
+
+	ddp = cxgb3i_alloc_big_mem(sizeof(struct cxgb3i_ddp_info) +
+				   ppmax *
+					(sizeof(struct cxgb3i_gather_list *) +
+					sizeof(struct sk_buff *)),
+				   GFP_KERNEL);
+	if (!ddp) {
+		ddp_log_warn("%s unable to alloc ddp 0x%d, ddp disabled.\n",
+			     tdev->name, ppmax);
+		return 0;
+	}
+	ddp->gl_map = (struct cxgb3i_gather_list **)(ddp + 1);
+	ddp->gl_skb = (struct sk_buff **)(((char *)ddp->gl_map) +
+					  ppmax *
+					  sizeof(struct cxgb3i_gather_list *));
+	spin_lock_init(&ddp->map_lock);
+
+	ddp->tdev = tdev;
+	ddp->pdev = uinfo.pdev;
+	ddp->max_txsz = min_t(unsigned int, uinfo.max_txsz, ULP2_MAX_PKT_SIZE);
+	/* will set max rx with ULP_ISCSI_SET_PARAM below */
+	ddp->max_rxsz = ULP2_MAX_PKT_SIZE;
+	ddp->llimit = uinfo.llimit;
+	ddp->ulimit = uinfo.ulimit;
+	ddp->nppods = ppmax;
+	ddp->idx_last = ppmax;
+	ddp->idx_bits = bits;
+	ddp->idx_mask = (1 << bits) - 1;
+	ddp->rsvd_tag_mask = (1 << (bits + PPOD_IDX_SHIFT)) - 1;
+
+	uinfo.tagmask = ddp->idx_mask << PPOD_IDX_SHIFT;
+	for (i = 0; i < DDP_PGIDX_MAX; i++)
+		uinfo.pgsz_factor[i] = ddp_page_order[i];
+	uinfo.ulimit = uinfo.llimit + (ppmax << PPOD_SIZE_SHIFT);
+
+	err = tdev->ctl(tdev, ULP_ISCSI_SET_PARAMS, &uinfo);
+	if (err < 0) {
+		ddp_log_warn("%s unable to set iscsi param err=%d, "
+			      "ddp disabled.\n", tdev->name, err);
+		goto free_ddp_map;
+	}
+
+	tdev->ulp_iscsi = ddp;
+
+	/* add to the list */
+	write_lock(&cxgb3i_ddp_rwlock);
+	list_add_tail(&ddp->list, &cxgb3i_ddp_list);
+	write_unlock(&cxgb3i_ddp_rwlock);
+
+	ddp_log_info("nppods %u (0x%x ~ 0x%x), bits %u, mask 0x%x,0x%x "
+			"pkt %u,%u.\n",
+			ppmax, ddp->llimit, ddp->ulimit, ddp->idx_bits,
+			ddp->idx_mask, ddp->rsvd_tag_mask,
+			ddp->max_txsz, ddp->max_rxsz);
+	return 0;
+
+free_ddp_map:
+	cxgb3i_free_big_mem(ddp);
+	return err;
+}
+
+/**
+ * cxgb3i_adapter_ddp_init - initialize the adapter's ddp resource
+ * @tdev: t3cdev adapter
+ * @tformat: tag format
+ * @txsz: max tx pkt size, filled in by this func.
+ * @rxsz: max rx pkt size, filled in by this func.
+ * initialize the ddp pagepod manager for a given adapter if needed and
+ * setup the tag format for a given iscsi entity
+ */
+int cxgb3i_adapter_ddp_init(struct t3cdev *tdev,
+			    struct cxgb3i_tag_format *tformat,
+			    unsigned int *txsz, unsigned int *rxsz)
+{
+	struct cxgb3i_ddp_info *ddp;
+	unsigned char idx_bits;
+
+	if (!tformat)
+		return -EINVAL;
+
+	if (!tdev->ulp_iscsi) {
+		int err = ddp_init(tdev);
+		if (err < 0)
+			return err;
+	}
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
+	*txsz = ddp->max_txsz;
+	*rxsz = ddp->max_rxsz;
+	ddp_log_info("ddp max pkt size: %u, %u.\n",
+		     ddp->max_txsz, ddp->max_rxsz);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_init);
+
+static void ddp_release(struct cxgb3i_ddp_info *ddp)
+{
+	int i = 0;
+	struct t3cdev *tdev = ddp->tdev;
+
+	tdev->ulp_iscsi = NULL;
+	while (i < ddp->nppods) {
+		struct cxgb3i_gather_list *gl = ddp->gl_map[i];
+		if (gl) {
+			int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
+				     >> PPOD_PAGES_SHIFT;
+
+			kfree(gl);
+			ddp_free_gl_skb(ddp, i, npods);
+		} else
+			i++;
+	}
+	cxgb3i_free_big_mem(ddp);
+}
+
+/**
+ * cxgb3i_adapter_ddp_cleanup - release the adapter's ddp resource
+ * @tdev: t3cdev adapter
+ * release all the resource held by the ddp pagepod manager for a given
+ * adapter if needed
+ */
+void cxgb3i_adapter_ddp_cleanup(struct t3cdev *tdev)
+{
+	struct cxgb3i_ddp_info *ddp;
+
+	/* remove from the list */
+	write_lock(&cxgb3i_ddp_rwlock);
+	list_for_each_entry(ddp, &cxgb3i_ddp_list, list) {
+		if (ddp->tdev == tdev) {
+			list_del(&ddp->list);
+			break;
+		}
+	}
+	write_unlock(&cxgb3i_ddp_rwlock);
+
+	if (ddp)
+		ddp_release(ddp);
+}
+EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_cleanup);
+
+/**
+ * cxgb3i_ddp_init_module - module init entry point
+ * initialize any driver wide global data structures
+ */
+static int __init cxgb3i_ddp_init_module(void)
+{
+	page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
+	ddp_log_info("system PAGE_SIZE %lu, ddp idx %u.\n",
+		     PAGE_SIZE, page_idx);
+	return 0;
+}
+
+/**
+ * cxgb3i_ddp_exit_module - module cleanup/exit entry point
+ * go through the ddp list and release any resource held.
+ */
+static void __exit cxgb3i_ddp_exit_module(void)
+{
+	struct cxgb3i_ddp_info *ddp;
+
+	/* release all ddp manager if there is any */
+	write_lock(&cxgb3i_ddp_rwlock);
+	list_for_each_entry(ddp, &cxgb3i_ddp_list, list) {
+		list_del(&ddp->list);
+		ddp_release(ddp);
+	}
+	write_unlock(&cxgb3i_ddp_rwlock);
+}
+
+module_init(cxgb3i_ddp_init_module);
+module_exit(cxgb3i_ddp_exit_module);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
new file mode 100644
index 0000000..1621dd0
--- /dev/null
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -0,0 +1,306 @@
+/*
+ * cxgb3i_ddp.h: Chelsio S3xx iSCSI DDP Manager.
+ *
+ * Copyright (c) 2008 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ * Written by: Karen Xie (kxie@chelsio.com)
+ */
+
+#ifndef __CXGB3I_ULP2_DDP_H__
+#define __CXGB3I_ULP2_DDP_H__
+
+/**
+ * struct cxgb3i_tag_format - cxgb3i ulp tag format for an iscsi entity
+ *
+ * @sw_bits:	# of bits used by iscsi software layer
+ * @rsvd_bits:	# of bits used by h/w
+ * @rsvd_shift:	h/w bits shift left
+ * @rsvd_mask:	reserved bit mask
+ */
+struct cxgb3i_tag_format {
+	unsigned char sw_bits;
+	unsigned char rsvd_bits;
+	unsigned char rsvd_shift;
+	unsigned char filler[1];
+	u32 rsvd_mask;
+};
+
+/**
+ * struct cxgb3i_gather_list - cxgb3i direct data placement memory
+ *
+ * @tag:	ddp tag
+ * @length:	total data buffer length
+ * @offset:	initial offset to the 1st page
+ * @nelem:	# of pages
+ * @pages:	page pointers
+ * @phys_addr:	physical address
+ */
+struct cxgb3i_gather_list {
+	u32 tag;
+	unsigned int length;
+	unsigned int offset;
+	unsigned int nelem;
+	struct page **pages;
+	dma_addr_t phys_addr[0];
+};
+
+/**
+ * struct cxgb3i_ddp_info - cxgb3i direct data placement for pdu payload
+ *
+ * @list:	list head to link elements
+ * @tdev:	pointer to t3cdev used by cxgb3 driver
+ * @max_txsz:	max tx packet size for ddp
+ * @max_rxsz:	max rx packet size for ddp
+ * @llimit:	lower bound of the page pod memory
+ * @ulimit:	upper bound of the page pod memory
+ * @nppods:	# of page pod entries
+ * @idx_last:	page pod entry last used
+ * @idx_bits:	# of bits the pagepod index would take
+ * @idx_mask:	pagepod index mask
+ * @rsvd_tag_mask: tag mask
+ * @map_lock:	lock to synchonize access to the page pod map
+ * @gl_map:	ddp memory gather list
+ * @gl_skb:	skb used to program the pagepod
+ */
+struct cxgb3i_ddp_info {
+	struct list_head list;
+	struct t3cdev *tdev;
+	struct pci_dev *pdev;
+	unsigned int max_txsz;
+	unsigned int max_rxsz;
+	unsigned int llimit;
+	unsigned int ulimit;
+	unsigned int nppods;
+	unsigned int idx_last;
+	unsigned char idx_bits;
+	unsigned char filler[3];
+	u32 idx_mask;
+	u32 rsvd_tag_mask;
+	spinlock_t map_lock;
+	struct cxgb3i_gather_list **gl_map;
+	struct sk_buff **gl_skb;
+};
+
+#define ULP2_MAX_PKT_SIZE	16224
+#define ULP2_MAX_PDU_SIZE	(ULP2_MAX_PKT_SIZE - ISCSI_PDU_HEADER_MAX)
+#define PPOD_PAGES_MAX		4
+#define PPOD_PAGES_SHIFT	2	/* 4 pages per pod */
+
+/*
+ * struct pagepod_hdr, pagepod - pagepod format
+ */
+struct pagepod_hdr {
+	u32 vld_tid;
+	u32 pgsz_tag_clr;
+	u32 maxoffset;
+	u32 pgoffset;
+	u64 rsvd;
+};
+
+struct pagepod {
+	struct pagepod_hdr hdr;
+	u64 addr[PPOD_PAGES_MAX + 1];
+};
+
+#define PPOD_SIZE		sizeof(struct pagepod)	/* 64 */
+#define PPOD_SIZE_SHIFT		6
+
+#define PPOD_COLOR_SHIFT	0
+#define PPOD_COLOR_SIZE		6
+#define PPOD_COLOR_MASK		((1 << PPOD_COLOR_SIZE) - 1)
+
+#define PPOD_IDX_SHIFT		PPOD_COLOR_SIZE
+#define PPOD_IDX_MAX_SIZE	24
+
+#define S_PPOD_TID    0
+#define M_PPOD_TID    0xFFFFFF
+#define V_PPOD_TID(x) ((x) << S_PPOD_TID)
+
+#define S_PPOD_VALID    24
+#define V_PPOD_VALID(x) ((x) << S_PPOD_VALID)
+#define F_PPOD_VALID    V_PPOD_VALID(1U)
+
+#define S_PPOD_COLOR    0
+#define M_PPOD_COLOR    0x3F
+#define V_PPOD_COLOR(x) ((x) << S_PPOD_COLOR)
+
+#define S_PPOD_TAG    6
+#define M_PPOD_TAG    0xFFFFFF
+#define V_PPOD_TAG(x) ((x) << S_PPOD_TAG)
+
+#define S_PPOD_PGSZ    30
+#define M_PPOD_PGSZ    0x3
+#define V_PPOD_PGSZ(x) ((x) << S_PPOD_PGSZ)
+
+/*
+ * large memory chunk allocation/release
+ * use vmalloc() if kmalloc() fails
+ */
+static inline void *cxgb3i_alloc_big_mem(unsigned int size,
+					 gfp_t gfp)
+{
+	void *p = kmalloc(size, gfp);
+	if (!p)
+		p = vmalloc(size);
+	if (p)
+		memset(p, 0, size);
+	return p;
+}
+
+static inline void cxgb3i_free_big_mem(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree(addr);
+	else
+		kfree(addr);
+}
+
+/*
+ * cxgb3i ddp tag are 32 bits, it consists of reserved bits used by h/w and
+ * non-reserved bits that can be used by the iscsi s/w.
+ * The reserved bits are identified by the rsvd_bits and rsvd_shift fields
+ * in struct cxgb3i_tag_format.
+ *
+ * The upper most reserved bit can be used to check if a tag is ddp tag or not:
+ * 	if the bit is 0, the tag is a valid ddp tag
+ */
+
+/**
+ * cxgb3i_is_ddp_tag - check if a given tag is a hw/ddp tag
+ * @tformat: tag format information
+ * @tag: tag to be checked
+ *
+ * return true if the tag is a ddp tag, false otherwise.
+ */
+static inline int cxgb3i_is_ddp_tag(struct cxgb3i_tag_format *tformat, u32 tag)
+{
+	return !(tag & (1 << (tformat->rsvd_bits + tformat->rsvd_shift - 1)));
+}
+
+/**
+ * cxgb3i_sw_tag_usable - check if a given s/w tag has enough bits left for
+ *			  the reserved/hw bits
+ * @tformat: tag format information
+ * @sw_tag: s/w tag to be checked
+ *
+ * return true if the tag is a ddp tag, false otherwise.
+ */
+static inline int cxgb3i_sw_tag_usable(struct cxgb3i_tag_format *tformat,
+					u32 sw_tag)
+{
+	sw_tag >>= (32 - tformat->rsvd_bits);
+	return !sw_tag;
+}
+
+/**
+ * cxgb3i_set_non_ddp_tag - mark a given s/w tag as an invalid ddp tag
+ * @tformat: tag format information
+ * @sw_tag: s/w tag to be checked
+ *
+ * insert 1 at the upper most reserved bit to mark it as an invalid ddp tag.
+ */
+static inline u32 cxgb3i_set_non_ddp_tag(struct cxgb3i_tag_format *tformat,
+					 u32 sw_tag)
+{
+	unsigned char shift = tformat->rsvd_bits + tformat->rsvd_shift - 1;
+	u32 mask = (1 << shift) - 1;
+
+	if (sw_tag && (sw_tag & ~mask)) {
+		u32 v1 = sw_tag & ((1 << shift) - 1);
+		u32 v2 = (sw_tag >> (shift - 1)) << shift;
+
+		return v2 | v1 | 1 << shift;
+	}
+	return sw_tag | 1 << shift;
+}
+
+/**
+ * cxgb3i_ddp_tag_base - shift the s/w tag bits so that reserved bits are not
+ *			 used.
+ * @tformat: tag format information
+ * @sw_tag: s/w tag to be checked
+ */
+static inline u32 cxgb3i_ddp_tag_base(struct cxgb3i_tag_format *tformat,
+				      u32 sw_tag)
+{
+	u32 mask = (1 << tformat->rsvd_shift) - 1;
+
+	if (sw_tag && (sw_tag & ~mask)) {
+		u32 v1 = sw_tag & mask;
+		u32 v2 = sw_tag >> tformat->rsvd_shift;
+
+		v2 <<= tformat->rsvd_shift + tformat->rsvd_bits;
+		return v2 | v1;
+	}
+	return sw_tag;
+}
+
+/**
+ * cxgb3i_tag_rsvd_bits - get the reserved bits used by the h/w
+ * @tformat: tag format information
+ * @tag: tag to be checked
+ *
+ * return the reserved bits in the tag
+ */
+static inline u32 cxgb3i_tag_rsvd_bits(struct cxgb3i_tag_format *tformat,
+				       u32 tag)
+{
+	if (cxgb3i_is_ddp_tag(tformat, tag))
+		return (tag >> tformat->rsvd_shift) & tformat->rsvd_mask;
+	return 0;
+}
+
+/**
+ * cxgb3i_tag_nonrsvd_bits - get the non-reserved bits used by the s/w
+ * @tformat: tag format information
+ * @tag: tag to be checked
+ *
+ * return the non-reserved bits in the tag.
+ */
+static inline u32 cxgb3i_tag_nonrsvd_bits(struct cxgb3i_tag_format *tformat,
+					  u32 tag)
+{
+	unsigned char shift = tformat->rsvd_bits + tformat->rsvd_shift - 1;
+	u32 v1, v2;
+
+	if (cxgb3i_is_ddp_tag(tformat, tag)) {
+		v1 = tag & ((1 << tformat->rsvd_shift) - 1);
+		v2 = (tag >> (shift + 1)) << tformat->rsvd_shift;
+	} else {
+		u32 mask = (1 << shift) - 1;
+
+		tag &= ~(1 << shift);
+		v1 = tag & mask;
+		v2 = (tag >> 1) & ~mask;
+	}
+	return v1 | v2;
+}
+
+int cxgb3i_ddp_tag_reserve(struct t3cdev *, unsigned int tid,
+			   struct cxgb3i_tag_format *, u32 *tag,
+			   struct cxgb3i_gather_list *, gfp_t gfp);
+void cxgb3i_ddp_tag_release(struct t3cdev *, u32 tag);
+
+struct cxgb3i_gather_list *cxgb3i_ddp_make_gl(unsigned int xferlen,
+				struct scatterlist *sgl,
+				unsigned int sgcnt,
+				struct pci_dev *pdev,
+				gfp_t gfp);
+void cxgb3i_ddp_release_gl(struct cxgb3i_gather_list *gl,
+				struct pci_dev *pdev);
+
+int cxgb3i_setup_conn_host_pagesize(struct t3cdev *, unsigned int tid,
+				    int reply);
+int cxgb3i_setup_conn_pagesize(struct t3cdev *, unsigned int tid, int reply,
+			       unsigned long pgsz);
+int cxgb3i_setup_conn_digest(struct t3cdev *, unsigned int tid,
+				int hcrc, int dcrc, int reply);
+int cxgb3i_ddp_find_page_index(unsigned long pgsz);
+int cxgb3i_adapter_ddp_init(struct t3cdev *, struct cxgb3i_tag_format *,
+			    unsigned int *txsz, unsigned int *rxsz);
+void cxgb3i_adapter_ddp_cleanup(struct t3cdev *);
+#endif
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 6f745fe..207c182 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -24,17 +24,38 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #include "cxgb3i.h"
+#include "cxgb3i_ulp2.h"
+
+#ifdef __DEBUG_CXGB3I_TAG__
+#define cxgb3i_tag_debug	cxgb3i_log_debug
+#else
+#define cxgb3i_tag_debug(fmt...)
+#endif
+
+#ifdef __DEBUG_CXGB3I_API__
+#define cxgb3i_api_debug	cxgb3i_log_debug
+#else
+#define cxgb3i_api_debug(fmt...)
+#endif
+
+/*
+ * align pdu size to multiple of 512 for better performance
+ */
+#define align_pdu_size(n) do { n = (n) & (~511); } while (0)
 
 static struct scsi_transport_template *cxgb3i_scsi_transport;
 static struct scsi_host_template cxgb3i_host_template;
 static struct iscsi_transport cxgb3i_iscsi_transport;
+static unsigned char sw_tag_idx_bits;
+static unsigned char sw_tag_age_bits;
 
 static LIST_HEAD(cxgb3i_snic_list);
 static DEFINE_RWLOCK(cxgb3i_snic_rwlock);
 
 /**
  * cxgb3i_adapter_add - init a s3 adapter structure and any h/w settings
- * @snic:	pointer to adapter instance
+ * @t3dev: t3cdev adapter
+ * return the resulting cxgb3i_adapter struct
  */
 struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
 {
@@ -44,15 +65,18 @@ struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
 
 	snic = kzalloc(sizeof(*snic), GFP_KERNEL);
 	if (!snic) {
-		cxgb3i_log_debug("cxgb3 %s, OOM.\n", t3dev->name);
+		cxgb3i_api_debug("cxgb3 %s, OOM.\n", t3dev->name);
 		return NULL;
 	}
-
 	spin_lock_init(&snic->lock);
+
 	snic->tdev = t3dev;
 	snic->pdev = adapter->pdev;
+	snic->tag_format.sw_bits = sw_tag_idx_bits + sw_tag_age_bits;
 
-	if (cxgb3i_adapter_ulp_init(snic))
+	if (cxgb3i_adapter_ddp_init(t3dev, &snic->tag_format,
+				    &snic->tx_max_size,
+				    &snic->rx_max_size) < 0)
 		goto free_snic;
 
 	for_each_port(adapter, i) {
@@ -70,15 +94,16 @@ struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
 	return snic;
 
 ulp_cleanup:
-	cxgb3i_adapter_ulp_cleanup(snic);
+	cxgb3i_adapter_ddp_cleanup(t3dev);
 free_snic:
 	kfree(snic);
 	return NULL;
 }
 
 /**
- * cxgb3i_snic_cleanup - release all the resources held and cleanup h/w settings
- * @snic:	pointer to adapter instance
+ * cxgb3i_adapter_remove - release all the resources held and cleanup any
+ *	h/w settings
+ * @t3dev: t3cdev adapter
  */
 void cxgb3i_adapter_remove(struct t3cdev *t3dev)
 {
@@ -86,7 +111,7 @@ void cxgb3i_adapter_remove(struct t3cdev *t3dev)
 	struct cxgb3i_adapter *snic;
 
 	/* remove from the list */
-	read_lock(&cxgb3i_snic_rwlock);
+	write_lock(&cxgb3i_snic_rwlock);
 	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
 		if (snic->tdev == t3dev) {
 			list_del(&snic->list_head);
@@ -104,11 +129,16 @@ void cxgb3i_adapter_remove(struct t3cdev *t3dev)
 		}
 
 		/* release ddp resources */
-		cxgb3i_adapter_ulp_cleanup(snic);
+		cxgb3i_adapter_ddp_cleanup(snic->tdev);
 		kfree(snic);
 	}
 }
 
+/**
+ * cxgb3i_hba_find_by_netdev - find the cxgb3i_hba structure with a given
+ *	net_device
+ * @t3dev: t3cdev adapter
+ */
 struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
 {
 	struct cxgb3i_adapter *snic;
@@ -127,6 +157,11 @@ struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
 	return NULL;
 }
 
+/**
+ * cxgb3i_hba_host_add - register a new host with scsi/iscsi
+ * @snic: the cxgb3i adapter
+ * @ndev: associated net_device
+ */
 struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 				       struct net_device *ndev)
 {
@@ -160,7 +195,7 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 		goto pci_dev_put;
 	}
 
-	cxgb3i_log_debug("shost 0x%p, hba 0x%p, no %u.\n",
+	cxgb3i_api_debug("shost 0x%p, hba 0x%p, no %u.\n",
 			 shost, hba, shost->host_no);
 
 	return hba;
@@ -171,9 +206,13 @@ pci_dev_put:
 	return NULL;
 }
 
+/**
+ * cxgb3i_hba_host_remove - de-register the host with scsi/iscsi
+ * @hba: the cxgb3i hba
+ */
 void cxgb3i_hba_host_remove(struct cxgb3i_hba *hba)
 {
-	cxgb3i_log_debug("shost 0x%p, hba 0x%p, no %u.\n",
+	cxgb3i_api_debug("shost 0x%p, hba 0x%p, no %u.\n",
 			 hba->shost, hba, hba->shost->host_no);
 	iscsi_host_remove(hba->shost);
 	pci_dev_put(hba->snic->pdev);
@@ -230,12 +269,12 @@ static struct iscsi_endpoint *cxgb3i_ep_connect(struct sockaddr *dst_addr,
 	cep->c3cn = c3cn;
 	cep->hba = hba;
 
-	cxgb3i_log_debug("ep 0x%p, 0x%p, c3cn 0x%p, hba 0x%p.\n",
+	cxgb3i_api_debug("ep 0x%p, 0x%p, c3cn 0x%p, hba 0x%p.\n",
 			  ep, cep, c3cn, hba);
 	return ep;
 
 release_conn:
-	cxgb3i_log_debug("conn 0x%p failed, release.\n", c3cn);
+	cxgb3i_api_debug("conn 0x%p failed, release.\n", c3cn);
 	if (c3cn)
 		cxgb3i_c3cn_release(c3cn);
 	return ERR_PTR(err);
@@ -255,7 +294,7 @@ static int cxgb3i_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 
 	if (!c3cn_in_state(c3cn, C3CN_STATE_ESTABLISHED))
 		return 0;
-	cxgb3i_log_debug("ep 0x%p, c3cn 0x%p established.\n", ep, c3cn);
+	cxgb3i_api_debug("ep 0x%p, c3cn 0x%p established.\n", ep, c3cn);
 	return 1;
 }
 
@@ -270,7 +309,7 @@ static void cxgb3i_ep_disconnect(struct iscsi_endpoint *ep)
 	struct cxgb3i_endpoint *cep = ep->dd_data;
 	struct cxgb3i_conn *cconn = cep->cconn;
 
-	cxgb3i_log_debug("ep 0x%p, cep 0x%p.\n", ep, cep);
+	cxgb3i_api_debug("ep 0x%p, cep 0x%p.\n", ep, cep);
 
 	if (cconn && cconn->conn) {
 		/*
@@ -285,7 +324,7 @@ static void cxgb3i_ep_disconnect(struct iscsi_endpoint *ep)
 		write_unlock_bh(&cep->c3cn->callback_lock);
 	}
 
-	cxgb3i_log_debug("ep 0x%p, cep 0x%p, release c3cn 0x%p.\n",
+	cxgb3i_api_debug("ep 0x%p, cep 0x%p, release c3cn 0x%p.\n",
 			 ep, cep, cep->c3cn);
 	cxgb3i_c3cn_release(cep->c3cn);
 	iscsi_destroy_endpoint(ep);
@@ -318,7 +357,7 @@ cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
 	cep = ep->dd_data;
 	hba = cep->hba;
 	shost = hba->shost;
-	cxgb3i_log_debug("ep 0x%p, cep 0x%p, hba 0x%p.\n", ep, cep, hba);
+	cxgb3i_api_debug("ep 0x%p, cep 0x%p, hba 0x%p.\n", ep, cep, hba);
 	BUG_ON(hba != iscsi_host_priv(shost));
 
 	*host_no = shost->host_no;
@@ -348,44 +387,66 @@ remove_session:
  */
 static void cxgb3i_session_destroy(struct iscsi_cls_session *cls_session)
 {
-	cxgb3i_log_debug("sess 0x%p.\n", cls_session);
+	cxgb3i_api_debug("sess 0x%p.\n", cls_session);
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 }
 
-static inline void cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
+/**
+ * cxgb3i_conn_max_xmit_dlength -- check the max. xmit pdu segment size,
+ * reduce it to be within the hardware limit if needed
+ * @conn: iscsi connection
+ */
+static inline int cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
 
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
+	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_SIZE,
+				 cconn->hba->snic->tx_max_size -
+				 ISCSI_PDU_HEADER_MAX);
 
 	if (conn->max_xmit_dlength)
 		conn->max_xmit_dlength = min_t(unsigned int,
-						conn->max_xmit_dlength,
-						cconn->hba->snic->tx_max_size -
-						ISCSI_PDU_HEADER_MAX);
+						conn->max_xmit_dlength, max);
 	else
-		conn->max_xmit_dlength = cconn->hba->snic->tx_max_size -
-						ISCSI_PDU_HEADER_MAX;
-	cxgb3i_log_debug("conn 0x%p, max xmit %u.\n",
+		conn->max_xmit_dlength = max;
+	align_pdu_size(conn->max_xmit_dlength);
+	cxgb3i_log_info("conn 0x%p, max xmit %u.\n",
 			 conn, conn->max_xmit_dlength);
+	return 0;
 }
 
-static inline void cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
+/**
+ * cxgb3i_conn_max_recv_dlength -- check the max. recv pdu segment size against
+ * the hardware limit
+ * @conn: iscsi connection
+ * return 0 if the value is valid, < 0 otherwise.
+ */
+static inline int cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
-
-	if (conn->max_recv_dlength)
+	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_SIZE,
+				 cconn->hba->snic->rx_max_size -
+				 ISCSI_PDU_HEADER_MAX);
+
+	align_pdu_size(max);
+	if (conn->max_recv_dlength) {
+		if (conn->max_recv_dlength > max) {
+			cxgb3i_log_error("MaxRecvDataSegmentLength %u too big."
+					 " Need to be <= %u.\n",
+					 conn->max_recv_dlength, max);
+			return -EINVAL;
+		}
 		conn->max_recv_dlength = min_t(unsigned int,
-						conn->max_recv_dlength,
-						cconn->hba->snic->rx_max_size -
-						ISCSI_PDU_HEADER_MAX);
-	else
-		conn->max_recv_dlength = cconn->hba->snic->rx_max_size -
-						ISCSI_PDU_HEADER_MAX;
-	cxgb3i_log_debug("conn 0x%p, max recv %u.\n",
+						conn->max_recv_dlength, max);
+		align_pdu_size(conn->max_recv_dlength);
+	} else
+		conn->max_recv_dlength = max;
+	cxgb3i_api_debug("conn 0x%p, max recv %u.\n",
 			 conn, conn->max_recv_dlength);
+	return 0;
 }
 
 /**
@@ -403,7 +464,7 @@ static struct iscsi_cls_conn *cxgb3i_conn_create(struct iscsi_cls_session
 	struct iscsi_tcp_conn *tcp_conn;
 	struct cxgb3i_conn *cconn;
 
-	cxgb3i_log_debug("sess 0x%p, cid %u.\n", cls_session, cid);
+	cxgb3i_api_debug("sess 0x%p, cid %u.\n", cls_session, cid);
 
 	cls_conn = iscsi_tcp_conn_setup(cls_session, sizeof(*cconn), cid);
 	if (!cls_conn)
@@ -435,6 +496,7 @@ static int cxgb3i_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
+	struct cxgb3i_adapter *snic;
 	struct iscsi_endpoint *ep;
 	struct cxgb3i_endpoint *cep;
 	struct s3_conn *c3cn;
@@ -444,15 +506,25 @@ static int cxgb3i_conn_bind(struct iscsi_cls_session *cls_session,
 	if (!ep)
 		return -EINVAL;
 
-	cxgb3i_log_debug("ep 0x%p, cls sess 0x%p, cls conn 0x%p.\n",
+	/* setup ddp pagesize */
+	cep = ep->dd_data;
+	c3cn = cep->c3cn;
+	snic = cep->hba->snic;
+	err = cxgb3i_setup_conn_host_pagesize(snic->tdev, c3cn->tid, 0);
+	if (err < 0)
+		return err;
+
+	cxgb3i_api_debug("ep 0x%p, cls sess 0x%p, cls conn 0x%p.\n",
 			 ep, cls_session, cls_conn);
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (err)
 		return -EINVAL;
 
-	cep = ep->dd_data;
-	c3cn = cep->c3cn;
+	/* calculate the tag idx bits needed for this conn based on cmds_max */
+	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
+	cxgb3i_api_debug("session cmds_max 0x%x, bits %u.\n",
+			 conn->session->cmds_max, cconn->task_idx_bits);
 
 	read_lock(&c3cn->callback_lock);
 	c3cn->user_data = conn;
@@ -472,6 +544,7 @@ static int cxgb3i_conn_bind(struct iscsi_cls_session *cls_session,
 
 	/* init recv engine */
 	iscsi_tcp_hdr_recv_prep(tcp_conn);
+
 	return 0;
 }
 
@@ -489,7 +562,7 @@ static int cxgb3i_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	int len;
 
-	cxgb3i_log_debug("cls_conn 0x%p, param %d.\n", cls_conn, param);
+	cxgb3i_api_debug("cls_conn 0x%p, param %d.\n", cls_conn, param);
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -509,6 +582,15 @@ static int cxgb3i_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	return len;
 }
 
+/**
+ * cxgb3i_conn_set_param - set iscsi connection parameter
+ * @cls_conn:	pointer to iscsi cls conn
+ * @param:	parameter type identifier
+ * @buf:	buffer pointer
+ * @buflen:	buffer length
+ *
+ * set iSCSI connection parameters
+ */
 static int cxgb3i_conn_set_param(struct iscsi_cls_conn *cls_conn,
 				 enum iscsi_param param, char *buf, int buflen)
 {
@@ -516,20 +598,24 @@ static int cxgb3i_conn_set_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
+	struct cxgb3i_adapter *snic = cconn->hba->snic;
+	struct s3_conn *c3cn = cconn->cep->c3cn;
 	int value, err = 0;
 
 	switch (param) {
 	case ISCSI_PARAM_HDRDGST_EN:
 		err = iscsi_set_param(cls_conn, param, buf, buflen);
 		if (!err && conn->hdrdgst_en)
-			cxgb3i_conn_ulp_setup(cconn, conn->hdrdgst_en,
-					      conn->datadgst_en);
+			err = cxgb3i_setup_conn_digest(snic->tdev, c3cn->tid,
+							conn->hdrdgst_en,
+							conn->datadgst_en, 0);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		err = iscsi_set_param(cls_conn, param, buf, buflen);
 		if (!err && conn->datadgst_en)
-			cxgb3i_conn_ulp_setup(cconn, conn->hdrdgst_en,
-					      conn->datadgst_en);
+			err = cxgb3i_setup_conn_digest(snic->tdev, c3cn->tid,
+							conn->hdrdgst_en,
+							conn->datadgst_en, 0);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		sscanf(buf, "%d", &value);
@@ -543,11 +629,13 @@ static int cxgb3i_conn_set_param(struct iscsi_cls_conn *cls_conn,
 			return -ENOMEM;
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		err = iscsi_set_param(cls_conn, param, buf, buflen);
-		cxgb3i_conn_max_recv_dlength(conn);
+		if (!err)
+			err = cxgb3i_conn_max_recv_dlength(conn);
 		break;
 	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
 		err = iscsi_set_param(cls_conn, param, buf, buflen);
-		cxgb3i_conn_max_xmit_dlength(conn);
+		if (!err)
+			err = cxgb3i_conn_max_xmit_dlength(conn);
 		break;
 	default:
 		return iscsi_set_param(cls_conn, param, buf, buflen);
@@ -567,19 +655,21 @@ static int cxgb3i_host_set_param(struct Scsi_Host *shost,
 {
 	struct cxgb3i_hba *hba = iscsi_host_priv(shost);
 
-	cxgb3i_log_debug("param %d, buf %s.\n", param, buf);
+	cxgb3i_api_debug("param %d, buf %s.\n", param, buf);
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+	{
 		__be32 addr = in_aton(buf);
 		cxgb3i_set_private_ipv4addr(hba->ndev, addr);
 		return 0;
+	}
 	case ISCSI_HOST_PARAM_HWADDRESS:
 	case ISCSI_HOST_PARAM_NETDEV_NAME:
 		/* ignore */
 		return 0;
 	default:
-		return iscsi_host_set_param(shost, param, buf);
+		return iscsi_host_set_param(shost, param, buf, buflen);
 	}
 }
 
@@ -596,7 +686,7 @@ static int cxgb3i_host_get_param(struct Scsi_Host *shost,
 	int i;
 	int len = 0;
 
-	cxgb3i_log_debug("hba %s, param %d.\n", hba->ndev->name, param);
+	cxgb3i_api_debug("hba %s, param %d.\n", hba->ndev->name, param);
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_HWADDRESS:
@@ -650,45 +740,39 @@ static void cxgb3i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->custom[0].value = conn->eh_abort_cnt;
 }
 
-static inline u32 tag_base(struct cxgb3i_tag_format *format,
-			   unsigned int idx, unsigned int age)
-{
-	u32 sw_bits = idx | (age << format->idx_bits);
-	u32 tag = sw_bits >> format->rsvd_shift;
-
-	tag <<= format->rsvd_bits + format->rsvd_shift;
-	tag |= sw_bits & ((1 << format->rsvd_shift) - 1);
-	return tag;
-}
-
-static inline void cxgb3i_parse_tag(struct cxgb3i_tag_format *format,
-				    u32 tag, u32 *rsvd_bits, u32 *sw_bits)
-{
-	if (rsvd_bits)
-		*rsvd_bits = (tag >> format->rsvd_shift) & format->rsvd_mask;
-	if (sw_bits) {
-		*sw_bits = (tag >> (format->rsvd_shift + format->rsvd_bits))
-			    << format->rsvd_shift;
-		*sw_bits |= tag & ((1 << format->rsvd_shift) - 1);
-	}
-}
-
-
+/**
+ * cxgb3i_parse_itt - get the idx and age bits from a given tag
+ * @conn:	iscsi connection
+ * @itt:	itt tag
+ * @idx:	task index, filled in by this function
+ * @age:	session age, filled in by this function
+ */
 static void cxgb3i_parse_itt(struct iscsi_conn *conn, itt_t itt,
 			     int *idx, int *age)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
 	struct cxgb3i_adapter *snic = cconn->hba->snic;
+	u32 tag = ntohl((__force u32) itt);
 	u32 sw_bits;
 
-	cxgb3i_parse_tag(&snic->tag_format, itt, NULL, &sw_bits);
+	sw_bits = cxgb3i_tag_nonrsvd_bits(&snic->tag_format, tag);
 	if (idx)
-		*idx = sw_bits & ISCSI_ITT_MASK;
+		*idx = sw_bits & ((1 << cconn->task_idx_bits) - 1);
 	if (age)
-		*age = (sw_bits >> snic->tag_format.idx_bits) & ISCSI_AGE_MASK;
+		*age = (sw_bits >> cconn->task_idx_bits) & ISCSI_AGE_MASK;
+
+	cxgb3i_tag_debug("parse tag 0x%x/0x%x, sw 0x%x, itt 0x%x, age 0x%x.\n",
+			 tag, itt, sw_bits, idx ? *idx : 0xFFFFF,
+			 age ? *age : 0xFF);
 }
 
+/**
+ * cxgb3i_reserve_itt - generate tag for a give task
+ * Try to set up ddp for a scsi read task.
+ * @task: iscsi task
+ * @hdr_itt: tag, filled in by this function
+ */
 int cxgb3i_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 {
 	struct scsi_cmnd *sc = task->sc;
@@ -697,36 +781,61 @@ int cxgb3i_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
 	struct cxgb3i_adapter *snic = cconn->hba->snic;
-	u32 sw_tag = tag_base(&snic->tag_format, task->itt, sess->age);
-	u32 tag = RESERVED_ITT;
+	struct cxgb3i_tag_format *tformat = &snic->tag_format;
+	u32 sw_tag = (sess->age << cconn->task_idx_bits) | task->itt;
+	u32 tag;
+	int err = -EINVAL;
 
-	if (sc && (sc->sc_data_direction == DMA_FROM_DEVICE)) {
+	if (sc && (sc->sc_data_direction == DMA_FROM_DEVICE) &&
+	    cxgb3i_sw_tag_usable(tformat, sw_tag)) {
 		struct s3_conn *c3cn = cconn->cep->c3cn;
-		tag =
-		    cxgb3i_ddp_tag_reserve(snic, c3cn->tid, sw_tag,
-					   scsi_out(sc)->length,
-					   scsi_out(sc)->table.sgl,
-					   scsi_out(sc)->table.nents);
+		struct cxgb3i_gather_list *gl;
+
+		gl = cxgb3i_ddp_make_gl(scsi_in(sc)->length,
+					scsi_in(sc)->table.sgl,
+					scsi_in(sc)->table.nents,
+					snic->pdev,
+					GFP_ATOMIC);
+		if (gl) {
+			tag = sw_tag;
+			err = cxgb3i_ddp_tag_reserve(snic->tdev, c3cn->tid,
+						     tformat, &tag,
+						     gl, GFP_ATOMIC);
+			if (err < 0)
+				cxgb3i_ddp_release_gl(gl, snic->pdev);
+		}
 	}
-	if (tag == RESERVED_ITT)
-		tag = sw_tag | (snic->tag_format.rsvd_mask <<
-				snic->tag_format.rsvd_shift);
-	*hdr_itt = htonl(tag);
+
+	if (err < 0)
+		tag = cxgb3i_set_non_ddp_tag(tformat, sw_tag);
+	/* the itt need to sent in big-endian order */
+	*hdr_itt = (__force itt_t)htonl(tag);
+
+	cxgb3i_tag_debug("new tag 0x%x/0x%x (itt 0x%x, age 0x%x).\n",
+			 tag, *hdr_itt, task->itt, sess->age);
 	return 0;
 }
 
+/**
+ * cxgb3i_release_itt - release the tag for a given task
+ * if the tag is a ddp tag, release the ddp setup
+ * @task:	iscsi task
+ * @hdr_itt:	tag
+ */
 void cxgb3i_release_itt(struct iscsi_task *task, itt_t hdr_itt)
 {
 	struct scsi_cmnd *sc = task->sc;
 	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
 	struct cxgb3i_adapter *snic = cconn->hba->snic;
+	struct cxgb3i_tag_format *tformat = &snic->tag_format;
+	u32 tag = ntohl((__force u32)hdr_itt);
 
-	hdr_itt = ntohl(hdr_itt);
-	if (sc && (sc->sc_data_direction == DMA_FROM_DEVICE))
-		cxgb3i_ddp_tag_release(snic, hdr_itt,
-				       scsi_out(sc)->table.sgl,
-				       scsi_out(sc)->table.nents);
+	cxgb3i_tag_debug("release tag 0x%x.\n", tag);
+
+	if (sc && (sc->sc_data_direction == DMA_FROM_DEVICE) &&
+	    cxgb3i_is_ddp_tag(tformat, tag))
+		cxgb3i_ddp_tag_release(snic->tdev, tag);
 }
 
 /**
@@ -754,7 +863,8 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	.owner			= THIS_MODULE,
 	.name			= "cxgb3i",
 	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
-				| CAP_DATADGST | CAP_DIGEST_OFFLOAD,
+				| CAP_DATADGST | CAP_DIGEST_OFFLOAD |
+				CAP_PADDING_OFFLOAD,
 	.param_mask		= ISCSI_MAX_RECV_DLENGTH |
 				ISCSI_MAX_XMIT_DLENGTH |
 				ISCSI_HDRDGST_EN |
@@ -799,7 +909,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	/* pdu xmit req. from user space */
 	.send_pdu		= iscsi_conn_send_pdu,
 	/* task */
-	.xmit_task		= iscsi_tcp_task_xmit,
+	.init_task		= iscsi_tcp_task_init,
 	.xmit_task		= iscsi_tcp_task_xmit,
 	.cleanup_task		= cxgb3i_conn_ulp2_cleanup_task,
 
@@ -819,20 +929,26 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 
 int cxgb3i_iscsi_init(void)
 {
+	sw_tag_idx_bits = (__ilog2_u32(ISCSI_ITT_MASK)) + 1;
+	sw_tag_age_bits = (__ilog2_u32(ISCSI_AGE_MASK)) + 1;
+	cxgb3i_log_info("tag itt 0x%x, %u bits, age 0x%x, %u bits.\n",
+			ISCSI_ITT_MASK, sw_tag_idx_bits,
+			ISCSI_AGE_MASK, sw_tag_age_bits);
+
 	cxgb3i_scsi_transport =
 	    iscsi_register_transport(&cxgb3i_iscsi_transport);
 	if (!cxgb3i_scsi_transport) {
 		cxgb3i_log_error("Could not register cxgb3i transport.\n");
 		return -ENODEV;
 	}
-	cxgb3i_log_debug("cxgb3i transport 0x%p.\n", cxgb3i_scsi_transport);
+	cxgb3i_api_debug("cxgb3i transport 0x%p.\n", cxgb3i_scsi_transport);
 	return 0;
 }
 
 void cxgb3i_iscsi_cleanup(void)
 {
 	if (cxgb3i_scsi_transport) {
-		cxgb3i_log_debug("cxgb3i transport 0x%p.\n",
+		cxgb3i_api_debug("cxgb3i transport 0x%p.\n",
 				 cxgb3i_scsi_transport);
 		iscsi_unregister_transport(&cxgb3i_iscsi_transport);
 	}
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ulp2.c b/drivers/scsi/cxgb3i/cxgb3i_ulp2.c
index be6df91..18ac41b 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ulp2.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ulp2.c
@@ -32,322 +32,11 @@
 #define cxgb3i_tx_debug(fmt...)
 #endif
 
-#ifdef __DEBUG_CXGB3I_TAG__
-#define cxgb3i_tag_debug	cxgb3i_log_debug
-#else
-#define cxgb3i_tag_debug(fmt...)
-#endif
-
-#ifdef __DEBUG_CXGB3I_DDP__
-#define cxgb3i_ddp_debug	cxgb3i_log_debug
-#else
-#define cxgb3i_ddp_debug(fmt...)
-#endif
-
 static struct page *pad_page;
 
-#define ULP2_PGIDX_MAX		4
-#define ULP2_4K_PAGE_SHIFT	12
-#define ULP2_4K_PAGE_MASK	(~((1UL << ULP2_4K_PAGE_SHIFT) - 1))
-static unsigned char ddp_page_order[ULP2_PGIDX_MAX];
-static unsigned long ddp_page_size[ULP2_PGIDX_MAX];
-static unsigned char ddp_page_shift[ULP2_PGIDX_MAX];
-static unsigned char sw_tag_idx_bits;
-static unsigned char sw_tag_age_bits;
-
-static void cxgb3i_ddp_page_init(void)
-{
-	int i;
-	unsigned long n = PAGE_SIZE >> ULP2_4K_PAGE_SHIFT;
-
-	if (PAGE_SIZE & (~ULP2_4K_PAGE_MASK)) {
-		cxgb3i_log_debug("PAGE_SIZE 0x%lx is not multiple of 4K, "
-				"ddp disabled.\n", PAGE_SIZE);
-		return;
-	}
-	n = __ilog2_u32(n);
-	for (i = 0; i < ULP2_PGIDX_MAX; i++, n++) {
-		ddp_page_order[i] = n;
-		ddp_page_shift[i] = ULP2_4K_PAGE_SHIFT + n;
-		ddp_page_size[i] = 1 << ddp_page_shift[i];
-		cxgb3i_log_debug("%d, order %u, shift %u, size 0x%lx.\n", i,
-				 ddp_page_order[i], ddp_page_shift[i],
-				 ddp_page_size[i]);
-	}
-
-	sw_tag_idx_bits = (__ilog2_u32(ISCSI_ITT_MASK)) + 1;
-	sw_tag_age_bits = (__ilog2_u32(ISCSI_AGE_MASK)) + 1;
-}
-
-static inline void ulp_mem_io_set_hdr(struct sk_buff *skb, unsigned int addr)
-{
-	struct ulp_mem_io *req = (struct ulp_mem_io *)skb->head;
-
-	req->wr.wr_lo = 0;
-	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_BYPASS));
-	req->cmd_lock_addr = htonl(V_ULP_MEMIO_ADDR(addr >> 5) |
-				   V_ULPTX_CMD(ULP_MEM_WRITE));
-	req->len = htonl(V_ULP_MEMIO_DATA_LEN(PPOD_SIZE >> 5) |
-			 V_ULPTX_NFLITS((PPOD_SIZE >> 3) + 1));
-}
-
-static int set_ddp_map(struct cxgb3i_adapter *snic, struct pagepod_hdr *hdr,
-		       unsigned int idx, unsigned int npods,
-		       struct scatterlist *sgl, unsigned int sgcnt)
-{
-	struct cxgb3i_ddp_info *ddp = &snic->ddp;
-	struct scatterlist *sg = sgl;
-	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
-	int i;
-
-	for (i = 0; i < npods; i++, pm_addr += PPOD_SIZE) {
-		struct sk_buff *skb;
-		struct pagepod *ppod;
-		int j, k;
-		skb =
-		    alloc_skb(sizeof(struct ulp_mem_io) + PPOD_SIZE,
-			      GFP_ATOMIC);
-		if (!skb) {
-			cxgb3i_log_debug("skb OMM.\n");
-			return -ENOMEM;
-		}
-		skb_put(skb, sizeof(struct ulp_mem_io) + PPOD_SIZE);
-
-		ulp_mem_io_set_hdr(skb, pm_addr);
-		ppod =
-		    (struct pagepod *)(skb->head + sizeof(struct ulp_mem_io));
-		memcpy(&(ppod->hdr), hdr, sizeof(struct pagepod));
-		for (j = 0, k = i * 4; j < 5; j++, k++) {
-			if (k < sgcnt) {
-				ppod->addr[j] = cpu_to_be64(sg_dma_address(sg));
-				if (j < 4)
-					sg = sg_next(sg);
-			} else
-				ppod->addr[j] = 0UL;
-		}
-
-		skb->priority = CPL_PRIORITY_CONTROL;
-		cxgb3_ofld_send(snic->tdev, skb);
-	}
-	return 0;
-}
-
-static int clear_ddp_map(struct cxgb3i_adapter *snic, unsigned int idx,
-			 unsigned int npods)
-{
-	struct cxgb3i_ddp_info *ddp = &snic->ddp;
-	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
-	int i;
-
-	for (i = 0; i < npods; i++, pm_addr += PPOD_SIZE) {
-		struct sk_buff *skb;
-		skb =
-		    alloc_skb(sizeof(struct ulp_mem_io) + PPOD_SIZE,
-			      GFP_ATOMIC);
-		if (!skb)
-			return -ENOMEM;
-		skb_put(skb, sizeof(struct ulp_mem_io) + PPOD_SIZE);
-		memset((skb->head + sizeof(struct ulp_mem_io)), 0, PPOD_SIZE);
-		ulp_mem_io_set_hdr(skb, pm_addr);
-		skb->priority = CPL_PRIORITY_CONTROL;
-		cxgb3_ofld_send(snic->tdev, skb);
-	}
-	return 0;
-}
-
-static int cxgb3i_ddp_sgl_check(struct scatterlist *sgl, unsigned int sgcnt)
-{
-	struct scatterlist *sg;
-	int i;
-
-	/* make sure the sgl is fit for ddp:
-	 *      each has the same page size, and
-	 *      first & last page do not need to be used completely, and
-	 *      the rest of page must be used completely
-	 */
-	for_each_sg(sgl, sg, sgcnt, i) {
-		if ((i && sg->offset) ||
-		    ((i != sgcnt - 1) &&
-		     (sg->length + sg->offset) != PAGE_SIZE)) {
-			cxgb3i_tag_debug("sg %u/%u, off %u, len %u.\n",
-					 i, sgcnt, sg->offset, sg->length);
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
-static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
-					  int start, int max, int count)
-{
-	unsigned int i, j;
-
-	spin_lock(&ddp->map_lock);
-	for (i = start; i <= max;) {
-		for (j = 0; j < count; j++) {
-			if (ddp->map[i + j])
-				break;
-		}
-		if (j == count) {
-			memset(&ddp->map[i], 1, count);
-			spin_unlock(&ddp->map_lock);
-			return i;
-		}
-		i += j + 1;
-	}
-	spin_unlock(&ddp->map_lock);
-	return -EBUSY;
-}
-
-static inline void ddp_unmark_entries(struct cxgb3i_ddp_info *ddp,
-				      int start, int count)
-{
-	spin_lock(&ddp->map_lock);
-	memset(&ddp->map[start], 0, count);
-	spin_unlock(&ddp->map_lock);
-}
-
-static inline int sgl_map(struct cxgb3i_adapter *snic,
-			  struct scatterlist *sgl, unsigned int sgcnt)
-{
-	struct scatterlist *sg;
-	int i, err;
-
-	for_each_sg(sgl, sg, sgcnt, i) {
-		err = pci_map_sg(snic->pdev, sg, 1, PCI_DMA_FROMDEVICE);
-		if (err <= 0) {
-			cxgb3i_tag_debug("sgcnt %d/%u, pci map failed %d.\n",
-					 i, sgcnt, err);
-			return err;
-		}
-	}
-	return sgcnt;
-}
-
-static inline void sgl_unmap(struct cxgb3i_adapter *snic,
-			     struct scatterlist *sgl, unsigned int sgcnt)
-{
-	struct scatterlist *sg;
-	int i;
-
-	for_each_sg(sgl, sg, sgcnt, i) {
-		if (sg_dma_address(sg))
-			pci_unmap_sg(snic->pdev, sg, 1, PCI_DMA_FROMDEVICE);
-		else
-			break;
-	}
-}
-
-u32 cxgb3i_ddp_tag_reserve(struct cxgb3i_adapter *snic, unsigned int tid,
-			   u32 sw_tag, unsigned int xferlen,
-			   struct scatterlist *sgl, unsigned int sgcnt)
-{
-	struct cxgb3i_ddp_info *ddp = &snic->ddp;
-	struct pagepod_hdr hdr;
-	unsigned int npods;
-	int idx = -1, idx_max;
-	u32 tag;
-	int err;
-
-	if (!ddp || !sgcnt || xferlen < PAGE_SIZE) {
-		cxgb3i_tag_debug("sgcnt %u, xferlen %u < %lu, NO DDP.\n",
-				 sgcnt, xferlen, PAGE_SIZE);
-		return RESERVED_ITT;
-	}
-
-	err = cxgb3i_ddp_sgl_check(sgl, sgcnt);
-	if (err < 0) {
-		cxgb3i_tag_debug("sgcnt %u, xferlen %u, SGL check fail.\n",
-				 sgcnt, xferlen);
-		return RESERVED_ITT;
-	}
-
-	npods = (sgcnt + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
-	idx_max = ddp->nppods - npods + 1;
-
-	if (ddp->idx_last == ddp->nppods)
-		idx = ddp_find_unused_entries(ddp, 0, idx_max, npods);
-	else {
-		idx = ddp_find_unused_entries(ddp, ddp->idx_last + 1, idx_max,
-					      npods);
-		if ((idx < 0) && (ddp->idx_last >= npods))
-			idx = ddp_find_unused_entries(ddp, 0,
-						      ddp->idx_last - npods + 1,
-						      npods);
-	}
-	if (idx < 0) {
-		cxgb3i_tag_debug("sgcnt %u, xferlen %u, npods %u NO DDP.\n",
-				 sgcnt, xferlen, npods);
-		return RESERVED_ITT;
-	}
-
-	err = sgl_map(snic, sgl, sgcnt);
-	if (err < sgcnt)
-		goto unmap_sgl;
-
-	tag = sw_tag | (idx << snic->tag_format.rsvd_shift);
-
-	hdr.rsvd = 0;
-	hdr.vld_tid = htonl(F_PPOD_VALID | V_PPOD_TID(tid));
-	hdr.pgsz_tag_clr = htonl(tag & snic->tag_format.rsvd_tag_mask);
-	hdr.maxoffset = htonl(xferlen);
-	hdr.pgoffset = htonl(sgl->offset);
-
-	if (set_ddp_map(snic, &hdr, idx, npods, sgl, sgcnt) < 0)
-		goto unmap_sgl;
-
-	ddp->idx_last = idx;
-	cxgb3i_tag_debug("tid 0x%x, xfer %u, 0x%x -> ddp 0x%x (0x%x, %u).\n",
-			 tid, xferlen, sw_tag, tag, idx, npods);
-	return tag;
-
-unmap_sgl:
-	sgl_unmap(snic, sgl, sgcnt);
-	ddp_unmark_entries(ddp, idx, npods);
-	return RESERVED_ITT;
-}
-
-void cxgb3i_ddp_tag_release(struct cxgb3i_adapter *snic, u32 tag,
-			    struct scatterlist *sgl, unsigned int sgcnt)
-{
-	u32 idx = (tag >> snic->tag_format.rsvd_shift) &
-		  snic->tag_format.rsvd_mask;
-	unsigned int npods = (sgcnt + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
-
-	if (idx < snic->tag_format.rsvd_mask) {
-		cxgb3i_tag_debug("ddp tag 0x%x, release idx 0x%x, npods %u.\n",
-				 tag, idx, npods);
-		clear_ddp_map(snic, idx, npods);
-		ddp_unmark_entries(&snic->ddp, idx, npods);
-		sgl_unmap(snic, sgl, sgcnt);
-	}
-}
-
-int cxgb3i_conn_ulp_setup(struct cxgb3i_conn *cconn, int hcrc, int dcrc)
-{
-	struct s3_conn *c3cn = cconn->cep->c3cn;
-	struct sk_buff *skb = alloc_skb(sizeof(struct cpl_set_tcb_field),
-					GFP_KERNEL | __GFP_NOFAIL);
-	struct cpl_set_tcb_field *req;
-	u32 submode = (hcrc ? 1 : 0) | (dcrc ? 2 : 0);
-
-	/* set up ulp submode and page size */
-	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
-	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
-	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, c3cn->tid));
-	req->reply = V_NO_REPLY(1);
-	req->cpu_idx = 0;
-	req->word = htons(31);
-	req->mask = cpu_to_be64(0xFF000000);
-	/* the connection page size is always the same as ddp-pgsz0 */
-	req->val = cpu_to_be64(submode << 24);
-	skb->priority = CPL_PRIORITY_CONTROL;
-
-	cxgb3_ofld_send(c3cn->cdev, skb);
-	return 0;
-}
-
+/*
+ * pdu receive, interact with libiscsi_tcp
+ */
 static inline int read_pdu_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 			       unsigned int offset, int offloaded)
 {
@@ -411,13 +100,28 @@ static int cxgb3i_conn_read_pdu_skb(struct iscsi_conn *conn,
 	if (iscsi_tcp_recv_segment_is_hdr(tcp_conn))
 		return 0;
 
+	offset = rc;
+	if (conn->hdrdgst_en)
+		offset += ISCSI_DIGEST_SIZE;
+
 	/* iscsi data */
-	if (skb_ulp_mode(skb) & ULP2_FLAG_DATA_DDPED)
+	if (skb_ulp_mode(skb) & ULP2_FLAG_DATA_DDPED) {
+		cxgb3i_rx_debug("skb 0x%p, opcode 0x%x, data %u, ddp'ed, "
+				"itt 0x%x.\n",
+				skb,
+				tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK,
+				tcp_conn->in.datalen,
+				ntohl(tcp_conn->in.hdr->itt));
 		offloaded = 1;
-
-	offset = rc;
-	if (!offloaded)
+	} else {
+		cxgb3i_rx_debug("skb 0x%p, opcode 0x%x, data %u, NOT ddp'ed, "
+				"itt 0x%x.\n",
+				skb,
+				tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK,
+				tcp_conn->in.datalen,
+				ntohl(tcp_conn->in.hdr->itt));
 		offset += sizeof(struct cpl_iscsi_hdr_norss);
+	}
 
 	rc = read_pdu_skb(conn, skb, offset, offloaded);
 	if (rc < 0)
@@ -426,6 +130,9 @@ static int cxgb3i_conn_read_pdu_skb(struct iscsi_conn *conn,
 		return 0;
 }
 
+/*
+ * pdu transmit, interact with libiscsi_tcp
+ */
 static inline void tx_skb_setmode(struct sk_buff *skb, int hcrc, int dcrc)
 {
 	u8 submode = 0;
@@ -465,6 +172,9 @@ int cxgb3i_conn_ulp2_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	if (!skb)
 		return -ENOMEM;
 
+	cxgb3i_tx_debug("task 0x%p, opcode 0x%x, skb 0x%p.\n",
+			task, opcode, skb);
+
 	tcp_task->dd_data = skb;
 	skb_reserve(skb, TX_HEADER_LEN);
 	skb_put(skb, sizeof(struct iscsi_hdr));
@@ -474,6 +184,7 @@ int cxgb3i_conn_ulp2_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	/* data_out uses scsi_cmd's itt */
 	if (opcode != ISCSI_OP_SCSI_DATA_OUT)
 		cxgb3i_reserve_itt(task, &task->hdr->itt);
+
 	return 0;
 }
 
@@ -488,6 +199,9 @@ int cxgb3i_conn_ulp2_init_pdu(struct iscsi_task *task, unsigned int offset,
 	int i, padlen = iscsi_padding(count);
 	skb_frag_t *frag;
 
+	cxgb3i_tx_debug("task 0x%p,0x%p, offset %u, count %u, skb 0x%p.\n",
+			task, task->sc, offset, count, skb);
+
 	tx_skb_setmode(skb, conn->hdrdgst_en, datalen ? conn->datadgst_en : 0);
 	if (!count)
 		return 0;
@@ -495,35 +209,48 @@ int cxgb3i_conn_ulp2_init_pdu(struct iscsi_task *task, unsigned int offset,
 	if (task->sc) {
 		struct scatterlist *sg;
 		struct scsi_data_buffer *sdb;
-		unsigned int sg_offset = offset;
+		unsigned int sgoffset = offset;
+		struct page *sgpg;
+		unsigned int sglen;
 
 		sdb = scsi_out(task->sc);
 		sg = sdb->table.sgl;
 
 		for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-			cxgb3i_rx_debug("sg %d, len %u offset %u\n",
-					i, sg->length, sg->offset);
+			cxgb3i_tx_debug("sg %d, page 0x%p, len %u offset %u\n",
+					i, sg_page(sg), sg->length, sg->offset);
 
-			if (sg_offset < sg->length)
+			if (sgoffset < sg->length)
 				break;
-			sg_offset -= sg->length;
-		}
-
-		while (datalen) {
-			i = skb_shinfo(skb)->nr_frags;
-			frag = &skb_shinfo(skb)->frags[i];
-
-			pg = sg_page(sg);
-			get_page(pg);
-			frag->page = pg;
-			frag->page_offset = sg_offset + sg->offset;
-			frag->size = min(sg->length, datalen);
-
-			sg_offset = 0;
-			skb_shinfo(skb)->nr_frags++;
-			datalen -= frag->size;
-			sg = sg_next(sg);
+			sgoffset -= sg->length;
 		}
+		sgpg = sg_page(sg);
+		sglen = sg->length - sgoffset;
+
+		do {
+			int j = skb_shinfo(skb)->nr_frags;
+			unsigned int copy;
+
+			if (!sglen) {
+				sg = sg_next(sg);
+				sgpg = sg_page(sg);
+				sgoffset = 0;
+				sglen = sg->length;
+				++i;
+			}
+			copy = min(sglen, datalen);
+			if (j && skb_can_coalesce(skb, j, sgpg,
+						  sg->offset + sgoffset)) {
+				skb_shinfo(skb)->frags[j - 1].size += copy;
+			} else {
+				get_page(sgpg);
+				skb_fill_page_desc(skb, j, sgpg,
+						   sg->offset + sgoffset, copy);
+			}
+			sgoffset += copy;
+			sglen -= copy;
+			datalen -= copy;
+		} while (datalen);
 	} else {
 		pg = virt_to_page(task->data);
 
@@ -564,12 +291,17 @@ int cxgb3i_conn_ulp2_xmit_pdu(struct iscsi_task *task)
 	struct sk_buff *skb = tcp_task->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
-	unsigned int datalen = skb->data_len;
+	unsigned int datalen;
 	int err;
 
+	if (!skb)
+		return 0;
+
+	datalen = skb->data_len;
 	tcp_task->dd_data = NULL;
-	err = cxgb3i_c3cn_send_pdus(cconn->cep->c3cn,
-				    skb, MSG_DONTWAIT | MSG_NOSIGNAL);
+	err = cxgb3i_c3cn_send_pdus(cconn->cep->c3cn, skb);
+	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
+			task, skb, skb->len, skb->data_len, err);
 	if (err > 0) {
 		int pdulen = err;
 
@@ -584,6 +316,8 @@ int cxgb3i_conn_ulp2_xmit_pdu(struct iscsi_task *task)
 
 	if (err < 0 && err != -EAGAIN) {
 		kfree_skb(skb);
+		cxgb3i_tx_debug("itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
+				task->itt, skb, skb->len, skb->data_len, err);
 		iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
 		iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
 		return err;
@@ -599,7 +333,6 @@ int cxgb3i_ulp2_init(void)
 	if (!pad_page)
 		return -ENOMEM;
 	memset(page_address(pad_page), 0, PAGE_SIZE);
-	cxgb3i_ddp_page_init();
 	return 0;
 }
 
@@ -665,97 +398,3 @@ void cxgb3i_conn_closing(struct s3_conn *c3cn)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	read_unlock(&c3cn->callback_lock);
 }
-
-int cxgb3i_adapter_ulp_init(struct cxgb3i_adapter *snic)
-{
-	struct t3cdev *tdev = snic->tdev;
-	struct cxgb3i_ddp_info *ddp = &snic->ddp;
-	struct ulp_iscsi_info uinfo;
-	unsigned int ppmax, bits, max_bits;
-	int i, err;
-
-	spin_lock_init(&ddp->map_lock);
-
-	err = tdev->ctl(tdev, ULP_ISCSI_GET_PARAMS, &uinfo);
-	if (err < 0) {
-		cxgb3i_log_error("%s, failed to get iscsi param err=%d.\n",
-				 tdev->name, err);
-		return err;
-	}
-
-	ppmax = (uinfo.ulimit - uinfo.llimit + 1) >> PPOD_SIZE_SHIFT;
-	max_bits = min(PPOD_IDX_MAX_SIZE,
-		       (32 - sw_tag_idx_bits - sw_tag_age_bits));
-	bits = __ilog2_u32(ppmax) + 1;
-	if (bits > max_bits)
-		bits = max_bits;
-	ppmax = (1 << bits) - 1;
-
-	snic->tx_max_size = min_t(unsigned int,
-				  uinfo.max_txsz, ULP2_MAX_PKT_SIZE);
-	snic->rx_max_size = min_t(unsigned int,
-				  uinfo.max_rxsz, ULP2_MAX_PKT_SIZE);
-
-	snic->tag_format.idx_bits = sw_tag_idx_bits;
-	snic->tag_format.age_bits = sw_tag_age_bits;
-	snic->tag_format.rsvd_bits = bits;
-	snic->tag_format.rsvd_shift = PPOD_IDX_SHIFT;
-	snic->tag_format.rsvd_mask = (1 << snic->tag_format.rsvd_bits) - 1;
-	snic->tag_format.rsvd_tag_mask =
-		(1 << (snic->tag_format.rsvd_bits + PPOD_IDX_SHIFT)) - 1;
-
-	ddp->map = cxgb3i_alloc_big_mem(ppmax);
-	if (!ddp->map) {
-		cxgb3i_log_warn("snic unable to alloc ddp ppod 0x%u, "
-				"ddp disabled.\n", ppmax);
-		return 0;
-	}
-	ddp->llimit = uinfo.llimit;
-	ddp->ulimit = uinfo.ulimit;
-
-	uinfo.tagmask =
-	    snic->tag_format.rsvd_mask << snic->tag_format.rsvd_shift;
-	for (i = 0; i < ULP2_PGIDX_MAX; i++)
-		uinfo.pgsz_factor[i] = ddp_page_order[i];
-
-	uinfo.ulimit = uinfo.llimit + (ppmax << PPOD_SIZE_SHIFT);
-
-	err = tdev->ctl(tdev, ULP_ISCSI_SET_PARAMS, &uinfo);
-	if (err < 0) {
-		cxgb3i_log_warn("snic unable to set iscsi param err=%d, "
-				"ddp disabled.\n", err);
-		goto free_ppod_map;
-	}
-
-	ddp->nppods = ppmax;
-	ddp->idx_last = ppmax;
-
-	tdev->ulp_iscsi = ddp;
-
-	cxgb3i_log_info("snic nppods %u (0x%x ~ 0x%x), rsvd shift %u, "
-			"bits %u, mask 0x%x, 0x%x, pkt %u,%u.\n",
-			ppmax, ddp->llimit, ddp->ulimit,
-			snic->tag_format.rsvd_shift,
-			snic->tag_format.rsvd_bits,
-			snic->tag_format.rsvd_mask, uinfo.tagmask,
-			snic->tx_max_size, snic->rx_max_size);
-
-	return 0;
-
-free_ppod_map:
-	cxgb3i_free_big_mem(ddp->map);
-	return 0;
-}
-
-void cxgb3i_adapter_ulp_cleanup(struct cxgb3i_adapter *snic)
-{
-	u8 *map = snic->ddp.map;
-
-	if (map) {
-		snic->tdev->ulp_iscsi = NULL;
-		spin_lock(&snic->lock);
-		snic->ddp.map = NULL;
-		spin_unlock(&snic->lock);
-		cxgb3i_free_big_mem(map);
-	}
-}
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ulp2.h b/drivers/scsi/cxgb3i/cxgb3i_ulp2.h
index 5b3b226..eddf217 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ulp2.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ulp2.h
@@ -13,53 +13,6 @@
 #ifndef __CXGB3I_ULP2_H__
 #define __CXGB3I_ULP2_H__
 
-#define ULP2_PDU_PAYLOAD_DFLT	(16224 - ISCSI_PDU_HEADER_MAX)
-#define PPOD_PAGES_MAX		4
-#define PPOD_PAGES_SHIFT	2	/* 4 pages per pod */
-
-struct pagepod_hdr {
-	u32 vld_tid;
-	u32 pgsz_tag_clr;
-	u32 maxoffset;
-	u32 pgoffset;
-	u64 rsvd;
-};
-
-struct pagepod {
-	struct pagepod_hdr hdr;
-	u64 addr[PPOD_PAGES_MAX + 1];
-};
-
-#define PPOD_SIZE		sizeof(struct pagepod)	/* 64 */
-#define PPOD_SIZE_SHIFT		6
-
-#define PPOD_COLOR_SHIFT	0
-#define PPOD_COLOR_SIZE		6
-#define PPOD_COLOR_MASK		((1 << PPOD_COLOR_SIZE) - 1)
-
-#define PPOD_IDX_SHIFT		PPOD_COLOR_SIZE
-#define PPOD_IDX_MAX_SIZE	24
-
-#define S_PPOD_TID    0
-#define M_PPOD_TID    0xFFFFFF
-#define V_PPOD_TID(x) ((x) << S_PPOD_TID)
-
-#define S_PPOD_VALID    24
-#define V_PPOD_VALID(x) ((x) << S_PPOD_VALID)
-#define F_PPOD_VALID    V_PPOD_VALID(1U)
-
-#define S_PPOD_COLOR    0
-#define M_PPOD_COLOR    0x3F
-#define V_PPOD_COLOR(x) ((x) << S_PPOD_COLOR)
-
-#define S_PPOD_TAG    6
-#define M_PPOD_TAG    0xFFFFFF
-#define V_PPOD_TAG(x) ((x) << S_PPOD_TAG)
-
-#define S_PPOD_PGSZ    30
-#define M_PPOD_PGSZ    0x3
-#define V_PPOD_PGSZ(x) ((x) << S_PPOD_PGSZ)
-
 struct cpl_iscsi_hdr_norss {
 	union opcode_tid ot;
 	u16 pdu_len_ddp;
@@ -100,8 +53,6 @@ struct cpl_rx_data_ddp_norss {
 #define ULP2_FLAG_DCRC_ERROR		0x20
 #define ULP2_FLAG_PAD_ERROR		0x40
 
-#define ULP2_MAX_PKT_SIZE		16224
-
 void cxgb3i_conn_closing(struct s3_conn *);
 void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn);
 void cxgb3i_conn_tx_open(struct s3_conn *c3cn);
