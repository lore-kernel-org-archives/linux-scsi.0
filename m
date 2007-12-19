From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/7] sg_ring: introduce sg_ring: a ring of scatterlist arrays.
Date: Wed, 19 Dec 2007 17:33:15 +1100
Message-ID: <200712191733.15409.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712191731.26512.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
@@ -0,0 +1,107 @@
+#ifndef _LINUX_SG_RING_H
+#define _LINUX_SG_RING_H
+#include <linux/scatterlist.h>
+
+/**
+ * struct sg_ring - a ring of scatterlists
+ * @list: the list_head chaining them together
+ * @num: the number of valid sg entries
+ * @max: the maximum number of sg entries (size of the sg array).
+ * @sg: the array of scatterlist entries.
+ *
+ * This provides a convenient encapsulation of one or more scatter gather
+ * arrays.
+ */
+struct sg_ring
+{
+	struct list_head list;
+	unsigned int num, max;
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
+static inline struct sg_ring *sg_ring_next(struct sg_ring *sg,
+					   const struct sg_ring *head)
+{
+	sg = list_first_entry(&sg->list, struct sg_ring, list);
+	if (sg == head)
+		sg = NULL;
+	return sg;
+}
+
+/* Helper for writing for loops */
+static inline struct sg_ring *sg_ring_iter(const struct sg_ring *head,
+					   struct sg_ring *sg, unsigned int *i)
+{
+	(*i)++;
+	/* While loop lets us skip any zero-entry sg_ring arrays */
+	while (*i == sg->num) {
+		*i = 0;
+		sg = sg_ring_next(sg, head);
+		if (!sg)
+			break;
+	}
+	return sg;
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
+#endif /* _LINUX_SG_RING_H */
