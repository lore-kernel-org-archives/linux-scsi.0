From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
Date: Fri, 21 Dec 2007 13:47:31 +1100
Message-ID: <200712211347.31694.rusty@rustcorp.com.au>
References: <200712210958.56994.rusty@rustcorp.com.au> <200712211135.13150.rusty@rustcorp.com.au> <20071220.164000.210277365.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:60805 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbXLUCre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 21:47:34 -0500
In-Reply-To: <20071220.164000.210277365.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

On Friday 21 December 2007 11:40:00 David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Fri, 21 Dec 2007 11:35:12 +1100
>
> > On Friday 21 December 2007 11:00:27 FUJITA Tomonori wrote:
> > > We need to pass the whole sg entries to the IOMMUs at a time.
> >
> > Hi Fujita,
> >
> >     OK, it's certainly possible to have an arch override.  For which
> > architecture is this BTW?
>
> SPARC64, POWERPC, maybe IA-64 etc.
>
> Basically any platform that potentially does virtual
> remamping and thus linearization.

Fujita said "need" which confused me.  I already said it should be handed
down as an optimization; I was curious what I had broken :)

> I think it should always be provided, the new APIs give
> less information to the implementation and that's a step
> backwards.

Absolutely.  In fact, I think the sg_ring header would be made safer if it
had the "dma_num" in it as well: it's more explicit and less surprising to
the caller than mangling sg->num.

How are these two patches then?

===
Introduce sg_ring: a ring of scatterlist arrays.

This patch introduces 'struct sg_ring', a layer on top of scatterlist
arrays.  It meshes nicely with routines which expect a simple array of
'struct scatterlist' because it is easy to break down the ring into
its constituent arrays.

The sg_ring header also encodes the maximum number of entries, useful
for routines which populate an sg.  We need never hand around a number
of elements any more.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/sg_ring.h |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/sgring.h

diff --git a/include/linux/sg_ring.h b/include/linux/sg_ring.h
new file mode 100644
--- /dev/null
+++ b/include/linux/sg_ring.h
@@ -0,0 +1,128 @@
+#ifndef _LINUX_SG_RING_H
+#define _LINUX_SG_RING_H
+#include <linux/scatterlist.h>
+
+/**
+ * struct sg_ring - a ring of scatterlists
+ * @list: the list_head chaining them together
+ * @num: the number of valid sg entries
+ * @dma_num: the number of valid sg entries after dma mapping
+ * @max: the maximum number of sg entries (size of the sg array).
+ * @sg: the array of scatterlist entries.
+ *
+ * This provides a convenient encapsulation of one or more scatter gather
+ * arrays.  dma_map_sg_ring() (and friends) set @dma_num: some architectures
+ * coalesce sg entries, to this will be < num.
+ */
+struct sg_ring
+{
+	struct list_head list;
+	unsigned int num, dma_num, max;
+	struct scatterlist sg[0];
+};
+
+/* This helper declares an sg ring on the stack or in a struct. */
+#define DECLARE_SG_RING(name, max)		\
+	struct {				\
+		struct sg_ring ring;		\
+		struct scatterlist sg[max];	\
+	} name
+
+/**
+ * sg_ring_init - initialize a scatterlist ring.
+ * @sg: the sg_ring.
+ * @max: the size of the trailing sg array.
+ *
+ * After initialization sg is alone in the ring.
+ */
+static inline void sg_ring_init(struct sg_ring *sg, unsigned int max)
+{
+#ifdef CONFIG_DEBUG_SG
+	unsigned int i;
+	for (i = 0; i < max; i++)
+		sg->sg[i].sg_magic = SG_MAGIC;
+	sg->num = 0xFFFFFFFF;
+	sg->dma_num = 0xFFFFFFFF;
+#endif
+	INIT_LIST_HEAD(&sg->list);
+	sg->max = max;
+	/* FIXME: This is to clear the page bits. */
+	sg_init_table(sg->sg, sg->max);
+}
+
+/**
+ * sg_ring_single - initialize a one-element scatterlist ring.
+ * @sg: the sg_ring.
+ * @buf: the pointer to the buffer.
+ * @buflen: the length of the buffer.
+ *
+ * Does sg_ring_init and also sets up first (and only) sg element.
+ */
+static inline void sg_ring_single(struct sg_ring *sg,
+				  const void *buf,
+				  unsigned int buflen)
+{
+	sg_ring_init(sg, 1);
+	sg->num = 1;
+	sg_init_one(&sg->sg[0], buf, buflen);
+}
+
+/**
+ * sg_ring_next - next array in a scatterlist ring.
+ * @sg: the sg_ring.
+ * @head: the sg_ring head.
+ *
+ * This will return NULL once @sg has looped back around to @head.
+ */
+static inline struct sg_ring *sg_ring_next(const struct sg_ring *sg,
+					   const struct sg_ring *head)
+{
+	sg = list_first_entry(&sg->list, struct sg_ring, list);
+	if (sg == head)
+		sg = NULL;
+	return (struct sg_ring *)sg;
+}
+
+/* Helper for writing for loops. */
+static inline struct sg_ring *sg_ring_iter(const struct sg_ring *head,
+					   const struct sg_ring *sg,
+					   unsigned int *i)
+{
+	(*i)++;
+	/* While loop lets us skip any zero-entry sg_ring arrays */
+	while (*i == sg->num) {
+		*i = 0;
+		sg = sg_ring_next(sg, head);
+		if (!sg)
+			break;
+	}
+	return (struct sg_ring *)sg;
+}
+
+/**
+ * sg_ring_for_each - iterate through an entire sg_ring ring
+ * @head: the head of the sg_ring.
+ * @sg: the sg_ring iterator.
+ * @i: an (unsigned) integer which refers to sg->sg[i].
+ *
+ * The current scatterlist element is sg->sg[i].
+ */
+#define sg_ring_for_each(head, sg, i) \
+	for (sg = head, i = 0; sg; sg = sg_ring_iter(head, sg, &i))
+
+/**
+ * sg_ring_num - how many struct scatterlists are used in this sg_ring.
+ * @head: the sg_ring
+ *
+ * Simple helper function to add up the number of scatterlists.
+ */
+static inline unsigned sg_ring_num(const struct sg_ring *head)
+{
+	unsigned int num = 0, i;
+	const struct sg_ring *sg;
+
+	sg_ring_for_each(head, sg, i)
+		num += sg->num;
+	return num;
+}
+#endif /* _LINUX_SG_RING_H */


dma_map_sg_ring() helper

Obvious counterpart to dma_map_sg.  Note that this is arch-independent
code; sg_rings are backwards compatible with simple sg arrays.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/base/dma-mapping.c  |   13 +++++++++++++
 include/linux/dma-mapping.h |    4 ++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/sg_ring.h>
 
 /*
  * Managed DMA API
@@ -162,6 +163,60 @@ void dmam_free_noncoherent(struct device
 }
 EXPORT_SYMBOL(dmam_free_noncoherent);
 
+#ifndef ARCH_HAS_DMA_MAP_SG_RING
+/**
+ * dma_map_sg_ring - Map an entire sg ring
+ * @dev: Device to free noncoherent memory for
+ * @sg: The sg_ring
+ * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+ *
+ * This returns -ENOMEM if mapping fails.  It's not clear that telling you
+ * it failed is useful though.
+ */
+int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
+		     enum dma_data_direction direction)
+{
+	struct sg_ring *i;
+
+	for (i = sg; i; i = sg_ring_next(i, sg)) {
+		BUG_ON(i->num > i->max);
+		i->dma_num = dma_map_sg(dev, i->sg, i->num, direction);
+		if (i->dma_num == 0 && i->num != 0)
+			goto unmap;
+	}
+	return 0;
+
+unmap:
+	while (sg) {
+		dma_unmap_sg(dev, sg->sg, sg->dma_num, direction);
+		sg = sg_ring_next(sg, i);
+	}
+	return -ENOMEM;
+
+}
+EXPORT_SYMBOL(dma_map_sg_ring);
+
+/**
+ * dma_unmap_sg_ring - Unmap an entire sg ring
+ * @dev: Device to free noncoherent memory for
+ * @sg: The sg_ring
+ * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+ *
+ * Call after dma_map_sg_ring() succeeds.
+ */
+void dma_unmap_sg_ring(struct device *dev, struct sg_ring *sg,
+		       enum dma_data_direction direction)
+{
+	struct sg_ring *i;
+
+	for (i = sg; i; i = sg_ring_next(i, sg)) {
+		BUG_ON(i->dma_num > i->max);
+		dma_unmap_sg(dev, i->sg, i->dma_num, direction);
+	}
+}
+EXPORT_SYMBOL(dma_unmap_sg_ring);
+#endif /* !ARCH_HAS_DMA_MAP_SG_RING */
+
 #ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 
 static void dmam_coherent_decl_release(struct device *dev, void *res)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -87,6 +87,14 @@ dma_mark_declared_memory_occupied(struct
 }
 #endif
 
+#ifndef ARCH_HAS_DMA_MAP_SG_RING
+struct sg_ring;
+extern int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
+			   enum dma_data_direction direction);
+extern void dma_unmap_sg_ring(struct device *dev, struct sg_ring *sg,
+			      enum dma_data_direction direction);
+#endif
+
 /*
  * Managed DMA API
  */


