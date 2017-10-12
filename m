From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/8] lib: Introduce sgl_alloc() and sgl_free()
Date: Thu, 12 Oct 2017 15:45:43 -0700
Message-ID: <20171012224550.25440-2-bart.vanassche@wdc.com>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37809 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753464AbdJLWrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2017 18:47:13 -0400
In-Reply-To: <20171012224550.25440-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>

Many kernel drivers contain code that allocate and free both a
scatterlist and the pages that populate that scatterlist.
Introduce functions under lib/ that perform these tasks instead
of duplicating this functionality in multiple drivers.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 include/linux/sgl_alloc.h |  16 ++++++++
 lib/Kconfig               |   4 ++
 lib/Makefile              |   1 +
 lib/sgl_alloc.c           | 102 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+)
 create mode 100644 include/linux/sgl_alloc.h
 create mode 100644 lib/sgl_alloc.c

diff --git a/include/linux/sgl_alloc.h b/include/linux/sgl_alloc.h
new file mode 100644
index 000000000000..a0f719690c9e
--- /dev/null
+++ b/include/linux/sgl_alloc.h
@@ -0,0 +1,16 @@
+#ifndef _SGL_ALLOC_H_
+#define _SGL_ALLOC_H_
+
+#include <linux/types.h> /* bool, gfp_t */
+
+struct scatterlist;
+
+struct scatterlist *sgl_alloc_order(unsigned long long length,
+				    unsigned int order, unsigned int *nent_p,
+				    gfp_t gfp, bool chainable);
+struct scatterlist *sgl_alloc(unsigned long long length, unsigned int *nent_p,
+			      gfp_t gfp);
+void sgl_free_order(struct scatterlist *sgl, int order);
+void sgl_free(struct scatterlist *sgl);
+
+#endif /* _SGL_ALLOC_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index b1445b22a6de..8396c4cfa1ab 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -413,6 +413,10 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config SGL_ALLOC
+	bool
+	default n
+
 config DMA_NOOP_OPS
 	bool
 	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
diff --git a/lib/Makefile b/lib/Makefile
index dafa79613fb4..4a0e9caf3c0e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -27,6 +27,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
+lib-$(CONFIG_SGL_ALLOC) += sgl_alloc.o
 lib-$(CONFIG_DMA_NOOP_OPS) += dma-noop.o
 lib-$(CONFIG_DMA_VIRT_OPS) += dma-virt.o
 
diff --git a/lib/sgl_alloc.c b/lib/sgl_alloc.c
new file mode 100644
index 000000000000..d96b395dd5c8
--- /dev/null
+++ b/lib/sgl_alloc.c
@@ -0,0 +1,102 @@
+#include <linux/kernel.h>
+#include <linux/scatterlist.h>
+#include <linux/sgl_alloc.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <asm/page.h>
+
+/**
+ * sgl_alloc_order - allocate a scatterlist and its pages
+ * @length: Length in bytes of the scatterlist. Must be at least one
+ * @order: Second argument for alloc_pages()
+ * @nent_p: [out] Number of entries in the scatterlist that have pages
+ * @gfp: Memory allocation flags
+ * @chainable: Whether or not to allocate an extra element in the scatterlist
+ *	for scatterlist chaining purposes
+ *
+ * Returns: %NULL upon failure or a pointer to an initialized scatterlist.
+ */
+struct scatterlist *sgl_alloc_order(unsigned long long length,
+				    unsigned int order, unsigned int *nent_p,
+				    gfp_t gfp, bool chainable)
+{
+	struct scatterlist *sgl, *sg;
+	struct page *page;
+	unsigned int nent, nalloc;
+	u32 elem_len;
+
+	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
+	nalloc = nent;
+	if (chainable) {
+		/* Check for integer overflow */
+		if (nalloc + 1 < nalloc)
+			return NULL;
+		nalloc++;
+	}
+	sgl = kmalloc_array(nalloc, sizeof(struct scatterlist),
+			    (gfp & ~GFP_DMA) | __GFP_ZERO);
+	if (!sgl)
+		return NULL;
+
+	sg_init_table(sgl, nent);
+	sg = sgl;
+	while (length) {
+		elem_len = min_t(u64, length, PAGE_SIZE << order);
+		page = alloc_pages(gfp, order);
+		if (!page) {
+			sgl_free(sgl);
+			return NULL;
+		}
+
+		sg_set_page(sg, page, elem_len, 0);
+		length -= elem_len;
+		sg = sg_next(sg);
+	}
+	WARN_ON_ONCE(sg);
+	if (nent_p)
+		*nent_p = nent;
+	return sgl;
+}
+EXPORT_SYMBOL(sgl_alloc_order);
+
+/**
+ * sgl_alloc - allocate a scatterlist and its pages
+ * @length: Length in bytes of the scatterlist
+ * @nent_p: [out] Number of entries in the scatterlist
+ * @gfp: Memory allocation flags
+ */
+struct scatterlist *sgl_alloc(unsigned long long length, unsigned int *nent_p,
+			      gfp_t gfp)
+{
+	return sgl_alloc_order(length, 0, nent_p, gfp, false);
+}
+EXPORT_SYMBOL(sgl_alloc);
+
+/**
+ * sgl_free_order - free a scatterlist and its pages
+ * @sg: Scatterlist with one or more elements
+ * @order: Second argument for __free_pages()
+ */
+void sgl_free_order(struct scatterlist *sgl, int order)
+{
+	struct scatterlist *sg;
+	struct page *page;
+
+	for (sg = sgl; sg; sg = sg_next(sg)) {
+		page = sg_page(sg);
+		if (page)
+			__free_pages(page, order);
+	}
+	kfree(sgl);
+}
+EXPORT_SYMBOL(sgl_free_order);
+
+/**
+ * sgl_free - free a scatterlist and its pages
+ * @sg: Scatterlist with one or more elements
+ */
+void sgl_free(struct scatterlist *sgl)
+{
+	sgl_free_order(sgl, 0);
+}
+EXPORT_SYMBOL(sgl_free);
-- 
2.14.2
