From: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH 2/2 2.6.30-rc] cxgb3i -- suppot of different kernel page sizes
Date: Sat, 13 Jun 2009 14:29:01 -0700
Message-ID: <200906132129.n5DLT1BZ029021@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


[PATCH 2/2 2.6.30-rc] cxgb3i -- suppot of different kernel page sizes

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

The default kernel pages supported are 4K, 8K, 16K, and 64K. Re-calculate
entries if PAGE_SIZE is not one of the defaults.

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index b6fdb5e..cdecd73 100644
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
@@ -718,6 +743,17 @@ void cxgb3i_ddp_init(struct t3cdev *tdev)
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
