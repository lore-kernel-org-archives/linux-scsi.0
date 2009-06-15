From: kxie@chelsio.com
Subject: [PATCH 2/2 2.6.30-rc v2] cxgb3i -- suppot of different kernel
 page sizes
Date: Mon, 15 Jun 2009 11:15:16 -0700
Message-ID: <200906151815.n5FIFGcA008961@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:8935 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZFOSIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 14:08:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH 2/2 2.6.30-rc v2] cxgb3i -- suppot of different kernel page sizes

From: Karen Xie <kxie@chelsio.com>

The default kernel pages supported are 4K, 8K, 16K, and 64K. Re-calculate
entries if PAGE_SIZE is not one of the defaults.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 8eb2848..344fd53 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -206,6 +206,31 @@ int cxgb3i_ddp_find_page_index(unsigned long pgsz)
 	return DDP_PGIDX_MAX;
 }
 
+/**
+ * cxgb3i_ddp_adjust_page_table - adjust page table with PAGE_SIZE
+ * return the ddp page index, if no match is found return DDP_PGIDX_MAX.
+ */
+int cxgb3i_ddp_adjust_page_table(void)
+{
+	int i;
+	unsigned int base_order, order;
+
+	if (PAGE_SIZE < (1UL << ddp_page_shift[0])) {
+		ddp_log_info("PAGE_SIZE 0x%lx too small, min. 0x%lx.\n",
+				PAGE_SIZE, 1UL << ddp_page_shift[0]);
+		return -EINVAL;
+	}
+
+	base_order = get_order(1UL << ddp_page_shift[0]);
+	order = get_order(1 << PAGE_SHIFT);
+	for (i = 0; i < DDP_PGIDX_MAX; i++) {
+		/* first is the kernel page size, then just doubling the size */
+		ddp_page_order[i] = order - base_order + i;
+		ddp_page_shift[i] = PAGE_SHIFT + i;
+	}
+	return 0;
+}
+
 static inline void ddp_gl_unmap(struct pci_dev *pdev,
 				struct cxgb3i_gather_list *gl)
 {
@@ -727,6 +752,17 @@ void cxgb3i_ddp_init(struct t3cdev *tdev)
 {
 	if (page_idx == DDP_PGIDX_MAX) {
 		page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
+
+		if (page_idx == DDP_PGIDX_MAX) {
+			ddp_log_info("system PAGE_SIZE %lu, update hw.\n",
+					PAGE_SIZE);
+			if (cxgb3i_ddp_adjust_page_table() < 0) {
+				ddp_log_info("PAGE_SIZE %lu, ddp disabled.\n",
+						PAGE_SIZE);
+				return;
+			}
+			page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
+		}
 		ddp_log_info("system PAGE_SIZE %lu, ddp idx %u.\n",
 				PAGE_SIZE, page_idx);
 	}
