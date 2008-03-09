From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 01/10] block: add sg buffer copy helper functions
Date: Sun,  9 Mar 2008 13:44:28 +0900
Message-ID: <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47296 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYCIEqL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:11 -0500
In-Reply-To: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

This patch adds new two helper functions to copy data between an SG
table and liner buffer.

- sg_copy_from_buffer copies data from liner buffer to an SG table
- sg_copy_to_buffer copies data from an SG table to liner buffer

sg_copy_from_buffer always call flush_kernel_dcache_page. It's not
necessary for everyone but it's a no-op on most architectures and in
general the API is not used in performance critical path.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |    5 ++
 lib/scatterlist.c           |   90 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index a3d567a..ab6c672 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -213,6 +213,11 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 
+int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			void *buf, int buflen);
+int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+		      void *buf, int buflen);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index acca490..63e9c35 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -8,6 +8,7 @@
  */
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -292,3 +293,92 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 	return ret;
 }
 EXPORT_SYMBOL(sg_alloc_table);
+
+static int sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
+			  void *buf, int buflen, int to_buf)
+{
+	struct scatterlist *sg;
+	unsigned long buf_off = 0;
+	int i;
+
+	WARN_ON(!irqs_disabled());
+
+	for_each_sg(sgl, sg, nents, i) {
+		struct page *page;
+		int n = 0;
+		unsigned int sg_off = sg->offset;
+		unsigned int sg_copy = sg->length;
+
+		if (sg_copy > buflen)
+			sg_copy = buflen;
+		buflen -= sg_copy;
+
+		while (sg_copy > 0) {
+			unsigned int page_copy;
+			void *p;
+
+			page_copy = PAGE_SIZE - sg_off;
+			if (page_copy > sg_copy)
+				page_copy = sg_copy;
+
+			page = nth_page(sg_page(sg), n);
+			p = kmap_atomic(page, KM_BIO_SRC_IRQ);
+
+			if (to_buf)
+				memcpy(buf + buf_off, p + sg_off, page_copy);
+			else {
+				memcpy(p + sg_off, buf + buf_off, page_copy);
+				flush_kernel_dcache_page(page);
+			}
+
+			kunmap_atomic(p, KM_BIO_SRC_IRQ);
+
+			buf_off += page_copy;
+			sg_off += page_copy;
+			if (sg_off == PAGE_SIZE) {
+				sg_off = 0;
+				n++;
+			}
+			sg_copy -= page_copy;
+		}
+
+		if (!buflen)
+			break;
+	}
+
+	return buf_off;
+}
+
+/**
+ * sg_copy_from_buffer - Copy from liner buffer to an SG table
+ * @sgl:		 The SG table
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy from
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied byte.
+ *
+ **/
+int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			void *buf, int buflen)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0);
+}
+EXPORT_SYMBOL(sg_copy_from_buffer);
+
+/**
+ * sg_copy_to_buffer - Copy from an SG table to liner buffer
+ * @sgl:		 The SG table
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy to
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied byte.
+ *
+ **/
+int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+		      void *buf, int buflen)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
+}
+EXPORT_SYMBOL(sg_copy_to_buffer);
-- 
1.5.3.7

