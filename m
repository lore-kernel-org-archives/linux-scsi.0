From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 5/8] scatterlist: Modify SG copy functions to support io
 memory.
Date: Mon, 3 Apr 2017 15:20:57 -0600
Message-ID: <445bc352-75d7-438f-96ef-c2411215628d@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
 <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <435d4471-436b-87e6-8827-c9fc6cbdde2c-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

What are your thoughts on an approach like the following untested
draft patch.

The patch (if fleshed out) makes it so iomem can be used in an sgl
and WARN_ONs will occur in places where drivers attempt to access
iomem directly through the sgl.

I'd also probably create a p2pmem_alloc_sgl helper function so driver
writers wouldn't have to mess with sg_set_iomem_page.

With all that in place, it should be relatively safe for drivers to
implement p2pmem even though we'd still technically be violating the
__iomem boundary in some places.

Logan


commit b435a154a4ec4f82766f6ab838092c3c5a9388ac
Author: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Date:   Wed Feb 8 12:44:52 2017 -0700

    scatterlist: Add support for iomem pages

    This patch steals another bit from the page_link field to indicate the
    sg points to iomem. In sg_copy_buffer we use this flag to select
    between memcpy and iomemcpy. Other sg_miter users will get an WARN_ON
    unless they indicate they support iomemory by setting the
    SG_MITER_IOMEM flag.

    Also added are sg_kmap functions which would replace a common pattern
    of kmap(sg_page(sg)). These new functions then also warn if the caller
    tries to map io memory. Another option may be to automatically copy
    the iomem to a new page and return that transparently to the driver.

    Another coccinelle patch would then be done to convert kmap(sg_page(sg))
    instances to the appropriate sg_kmap calls.

    Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0007b79..bd690a2c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -37,6 +37,9 @@

 #include <uapi/linux/dma-buf.h>

+/* Avoid the highmem.h macro from aliasing our ops->kunmap_atomic */
+#undef kunmap_atomic
+
 static inline int is_dma_buf_file(struct file *);

 struct dma_buf_list {
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cb3c8fe..7608da0 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/io.h>

 struct scatterlist {
@@ -53,6 +54,9 @@ struct sg_table {
  *
  * If bit 1 is set, then this sg entry is the last element in a list.
  *
+ * We also use bit 2 to indicate whether the page_link points to an
+ * iomem page or not.
+ *
  * See sg_next().
  *
  */
@@ -64,10 +68,17 @@ struct sg_table {
  * a valid sg entry, or whether it points to the start of a new
scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define PAGE_LINK_MASK	0x7
+#define PAGE_LINK_CHAIN	0x1
+#define PAGE_LINK_LAST	0x2
+#define PAGE_LINK_IOMEM	0x4
+
+#define sg_is_chain(sg)		((sg)->page_link & PAGE_LINK_CHAIN)
+#define sg_is_last(sg)		((sg)->page_link & PAGE_LINK_LAST)
 #define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((sg)->page_link & ~0x03))
+	((struct scatterlist *) ((sg)->page_link & ~(PAGE_LINK_CHAIN | \
+						     PAGE_LINK_LAST)))
+#define sg_is_iomem(sg)		((sg)->page_link & PAGE_LINK_IOMEM)

 /**
  * sg_assign_page - Assign a given page to an SG entry
@@ -81,13 +92,13 @@ struct sg_table {
  **/
 static inline void sg_assign_page(struct scatterlist *sg, struct page
*page)
 {
-	unsigned long page_link = sg->page_link & 0x3;
+	unsigned long page_link = sg->page_link & PAGE_LINK_MASK;

 	/*
 	 * In order for the low bit stealing approach to work, pages
-	 * must be aligned at a 32-bit boundary as a minimum.
+	 * must be aligned at a 64-bit boundary as a minimum.
 	 */
-	BUG_ON((unsigned long) page & 0x03);
+	BUG_ON((unsigned long) page & PAGE_LINK_MASK);
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
@@ -117,13 +128,56 @@ static inline void sg_set_page(struct scatterlist
*sg, struct page *page,
 	sg->length = len;
 }

+/**
+ * sg_set_page - Set sg entry to point at given iomem page
+ * @sg:		 SG entry
+ * @page:	 The page
+ * @len:	 Length of data
+ * @offset:	 Offset into page
+ *
+ * Description:
+ *   Same as sg_set_page but used when the page is a ZONE_DEVICE page that
+ *   points to IO memory.
+ *
+ **/
+static inline void sg_set_iomem_page(struct scatterlist *sg, struct
page *page,
+				     unsigned int len, unsigned int offset)
+{
+	sg_set_page(sg, page, len, offset);
+	sg->page_link |= PAGE_LINK_IOMEM;
+}
+
 static inline struct page *sg_page(struct scatterlist *sg)
 {
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
 #endif
-	return (struct page *)((sg)->page_link & ~0x3);
+	return (struct page *)((sg)->page_link & ~PAGE_LINK_MASK);
+}
+
+static inline void *sg_kmap(struct scatterlist *sg)
+{
+	WARN_ON(sg_is_iomem(sg));
+
+	return kmap(sg_page(sg));
+}
+
+static inline void sg_kunmap(struct scatterlist *sg, void *addr)
+{
+	kunmap(addr);
+}
+
+static inline void *sg_kmap_atomic(struct scatterlist *sg)
+{
+	WARN_ON(sg_is_iomem(sg));
+
+	return kmap(sg_page(sg));
+}
+
+static inline void sg_kunmap_atomic(struct scatterlist *sg, void *addr)
+{
+	kunmap_atomic(addr);
 }

 /**
@@ -171,7 +225,8 @@ static inline void sg_chain(struct scatterlist *prv,
unsigned int prv_nents,
 	 * Set lowest bit to indicate a link pointer, and make sure to clear
 	 * the termination bit if it happens to be set.
 	 */
-	prv[prv_nents - 1].page_link = ((unsigned long) sgl | 0x01) & ~0x02;
+	prv[prv_nents - 1].page_link =
+		((unsigned long) sgl & ~PAGE_LINK_MASK) | PAGE_LINK_CHAIN;
 }

 /**
@@ -191,8 +246,8 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	/*
 	 * Set termination bit, clear potential chain bit
 	 */
-	sg->page_link |= 0x02;
-	sg->page_link &= ~0x01;
+	sg->page_link &= ~PAGE_LINK_MASK;
+	sg->page_link |= PAGE_LINK_LAST;
 }

 /**
@@ -208,7 +263,7 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 #endif
-	sg->page_link &= ~0x02;
+	sg->page_link &= ~PAGE_LINK_LAST;
 }

 /**
@@ -383,6 +438,7 @@ static inline dma_addr_t
sg_page_iter_dma_address(struct sg_page_iter *piter)
 #define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
 #define SG_MITER_TO_SG		(1 << 1)	/* flush back to phys on unmap */
 #define SG_MITER_FROM_SG	(1 << 2)	/* nop */
+#define SG_MITER_IOMEM		(1 << 3)	/* support iomem in miter ops */

 struct sg_mapping_iter {
 	/* the following three fields can be accessed directly */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c6cf822..6d8f39b 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -580,6 +580,9 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	if (!sg_miter_get_next_page(miter))
 		return false;

+	if (!(miter->__flags & SG_MITER_IOMEM))
+		WARN_ON(sg_is_iomem(miter->piter.sg));
+
 	miter->page = sg_page_iter_page(&miter->piter);
 	miter->consumed = miter->length = miter->__remaining;

@@ -651,7 +654,7 @@ size_t sg_copy_buffer(struct scatterlist *sgl,
unsigned int nents, void *buf,
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
-	unsigned int sg_flags = SG_MITER_ATOMIC;
+	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_IOMEM;

 	if (to_buffer)
 		sg_flags |= SG_MITER_FROM_SG;
@@ -668,10 +671,17 @@ size_t sg_copy_buffer(struct scatterlist *sgl,
unsigned int nents, void *buf,

 		len = min(miter.length, buflen - offset);

-		if (to_buffer)
-			memcpy(buf + offset, miter.addr, len);
-		else
-			memcpy(miter.addr, buf + offset, len);
+		if (sg_is_iomem(miter.piter.sg)) {
+			if (to_buffer)
+				memcpy_fromio(buf + offset,  miter.addr, len);
+			else
+				memcpy_toio(miter.addr, buf + offset, len);
+		} else {
+			if (to_buffer)
+				memcpy(buf + offset, miter.addr, len);
+			else
+				memcpy(miter.addr, buf + offset, len);
+		}

 		offset += len;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
