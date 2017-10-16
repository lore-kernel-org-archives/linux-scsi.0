From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 1/8] lib/scatterlist: Introduce sgl_alloc() and sgl_free()
Date: Mon, 16 Oct 2017 15:49:33 -0700
Message-ID: <20171016224940.1332-2-bart.vanassche@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016224940.1332-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Many kernel drivers contain code that allocates and frees both a
scatterlist and the pages that populate that scatterlist.
Introduce functions in lib/scatterlist.c that perform these tasks
instead of duplicating this functionality in multiple drivers.
Only include these functions in the build if CONFIG_SGL_ALLOC=y
to avoid that the kernel size increases if this functionality is
not used.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 include/linux/scatterlist.h |  10 +++++
 lib/Kconfig                 |   4 ++
 lib/scatterlist.c           | 105 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4b3286ac60c8..3642511918d5 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -266,6 +266,16 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
 
+#ifdef CONFIG_SGL_ALLOC
+struct scatterlist *sgl_alloc_order(unsigned long long length,
+				    unsigned int order, bool chainable,
+				    gfp_t gfp, unsigned int *nent_p);
+struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
+			      unsigned int *nent_p);
+void sgl_free_order(struct scatterlist *sgl, int order);
+void sgl_free(struct scatterlist *sgl);
+#endif /* CONFIG_SGL_ALLOC */
+
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 		      size_t buflen, off_t skip, bool to_buffer);
 
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
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index be7b4dd6b68d..e2b5a78ceb44 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -433,6 +433,111 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 }
 EXPORT_SYMBOL(sg_alloc_table_from_pages);
 
+#ifdef CONFIG_SGL_ALLOC
+
+/**
+ * sgl_alloc_order - allocate a scatterlist and its pages
+ * @length: Length in bytes of the scatterlist. Must be at least one
+ * @order: Second argument for alloc_pages()
+ * @chainable: Whether or not to allocate an extra element in the scatterlist
+ *	for scatterlist chaining purposes
+ * @gfp: Memory allocation flags
+ * @nent_p: [out] Number of entries in the scatterlist that have pages
+ *
+ * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
+ */
+struct scatterlist *sgl_alloc_order(unsigned long long length,
+				    unsigned int order, bool chainable,
+				    gfp_t gfp, unsigned int *nent_p)
+{
+	struct scatterlist *sgl, *sg;
+	struct page *page;
+	unsigned int nent, nalloc;
+	u32 elem_len;
+
+	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
+	/* Check for integer overflow */
+	if (length > (nent << (PAGE_SHIFT + order)))
+		return NULL;
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
+ * @gfp: Memory allocation flags
+ * @nent_p: [out] Number of entries in the scatterlist
+ *
+ * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
+ */
+struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
+			      unsigned int *nent_p)
+{
+	return sgl_alloc_order(length, 0, false, gfp, nent_p);
+}
+EXPORT_SYMBOL(sgl_alloc);
+
+/**
+ * sgl_free_order - free a scatterlist and its pages
+ * @sgl: Scatterlist with one or more elements
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
+ * @sgl: Scatterlist with one or more elements
+ */
+void sgl_free(struct scatterlist *sgl)
+{
+	sgl_free_order(sgl, 0);
+}
+EXPORT_SYMBOL(sgl_free);
+
+#endif /* CONFIG_SGL_ALLOC */
+
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset)
-- 
2.14.2
