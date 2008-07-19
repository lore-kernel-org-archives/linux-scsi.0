From: Tejun Heo <htejun@gmail.com>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Sat, 19 Jul 2008 23:03:35 +0900
Message-ID: <4881F437.7000503@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com>	<20080719033050.552f9b49@mjolnir.drzeus.cx>	<48814D81.8060001@gmail.com> <20080719140717.7b296eae@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080719140717.7b296eae@mjolnir.drzeus.cx>
Sender: linux-next-owner@vger.kernel.org
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
List-Id: linux-scsi@vger.kernel.org

Pierre Ossman wrote:
> On Sat, 19 Jul 2008 11:12:17 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Oh... I see.  How about adding sg_miter_consume(@miter, @bytes)?  If the
>> function is never called, the whole chunk is assumed to be consumed.  If
>> the function is called only @bytes are consumed.
>>
> 
> Sounds reasonable. Care to make an independent patch so that I can
> continue my PIO hacking adventures? :)

Sure thing.  Here you go.  :-)

Subject: [PATCH 2.6.26] sg: reimplement sg mapping iterator

This is alternative implementation of sg content iterator introduced
by commit 83e7d317... from Pierre Ossman in next-20080716.  As there's
already an sg iterator which iterates over sg entries themselves, name
this sg_mapping_iterator.

Slightly edited description from the original implementation follows.

Iteration over a sg list is not that trivial when you take into
account that memory pages might have to be mapped before being used.
Unfortunately, that means that some parts of the kernel restrict
themselves to directly accesible memory just to not have to deal with
the mess.

This patch adds a simple iterator system that allows any code to
easily traverse an sg list and not have to deal with all the details.
The user can decide to consume part of the iteration.  Also, iteration
can be stopped and resumed later if releasing the kmap between
iteration steps is necessary.  These features are useful to implement
piecemeal sg copying for interrupt drive PIO for example.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
---
 include/linux/scatterlist.h |   38 +++++++++
 lib/scatterlist.c           |  176 ++++++++++++++++++++++++++++++++------------
 2 files changed, 168 insertions(+), 46 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 71fc813..e599698 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -224,4 +224,42 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
  */
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
+
+/*
+ * Mapping sg iterator
+ *
+ * Iterates over sg entries mapping page-by-page.  On each successful
+ * iteration, @miter->page points to the mapped page and
+ * @miter->length bytes of data can be accessed at @miter->addr.  As
+ * long as an interation is enclosed between start and stop, the user
+ * is free to choose control structure and when to stop.
+ *
+ * @miter->consumed is set to @miter->length on each iteration.  It
+ * can be adjusted if the user can't consume all the bytes in one go.
+ * Also, a stopped iteration can be resumed by calling next on it.
+ * This is useful when iteration needs to release all resources and
+ * continue later (e.g. at the next interrupt).
+ */
+
+#define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
+
+struct sg_mapping_iter {
+	/* the following three fields can be accessed directly */
+	struct page		*page;		/* currently mapped page */
+	void			*addr;		/* pointer to the mapped area */
+	size_t			length;		/* length of the mapped area */
+	size_t			consumed;	/* number of consumed bytes */
+
+	/* these are internal states, keep away */
+	struct scatterlist	*__sg;		/* current entry */
+	unsigned int		__nents;	/* nr of remaining entries */
+	unsigned int		__offset;	/* offset within sg */
+	unsigned int		__flags;
+};
+
+void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
+		    unsigned int nents, unsigned int flags);
+bool sg_miter_next(struct sg_mapping_iter *miter);
+void sg_miter_stop(struct sg_mapping_iter *miter);
+
 #endif /* _LINUX_SCATTERLIST_H */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b80c211..876ba6d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -295,6 +295,117 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);
 
 /**
+ * sg_miter_start - start mapping iteration over a sg list
+ * @miter: sg mapping iter to be started
+ * @sgl: sg list to iterate over
+ * @nents: number of sg entries
+ *
+ * Description:
+ *   Starts mapping iterator @miter.
+ *
+ * Context:
+ *   Don't care.
+ */
+void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
+		    unsigned int nents, unsigned int flags)
+{
+	memset(miter, 0, sizeof(struct sg_mapping_iter));
+
+	miter->__sg = sgl;
+	miter->__nents = nents;
+	miter->__offset = 0;
+	miter->__flags = flags;
+}
+EXPORT_SYMBOL(sg_miter_start);
+
+/**
+ * sg_miter_next - proceed mapping iterator to the next mapping
+ * @miter: sg mapping iter to proceed
+ *
+ * Description:
+ *   Proceeds @miter@ to the next mapping.  @miter@ should have been
+ *   started using sg_miter_start().  On successful return,
+ *   @miter@->page, @miter@->addr and @miter@->length point to the
+ *   current mapping.
+ *
+ * Context:
+ *   IRQ disabled if SG_MITER_ATOMIC.  IRQ must stay disabled till
+ *   @miter@ is stopped.  May sleep if !SG_MITER_ATOMIC.
+ *
+ * Returns:
+ *   true if @miter contains the next mapping.  false if end of sg
+ *   list is reached.
+ */
+bool sg_miter_next(struct sg_mapping_iter *miter)
+{
+	unsigned int off, len;
+
+	/* check for end and drop resources from the last iteration */
+	if (!miter->__nents)
+		return false;
+
+	sg_miter_stop(miter);
+
+	/* get to the next sg if necessary.  __offset is adjusted by stop */
+	if (miter->__offset == miter->__sg->length && --miter->__nents) {
+		miter->__sg = sg_next(miter->__sg);
+		miter->__offset = 0;
+	}
+
+	/* map the next page */
+	off = miter->__sg->offset + miter->__offset;
+	len = miter->__sg->length - miter->__offset;
+
+	miter->page = nth_page(sg_page(miter->__sg), off >> PAGE_SHIFT);
+	off &= ~PAGE_MASK;
+	miter->length = min_t(unsigned int, len, PAGE_SIZE - off);
+	miter->consumed = miter->length;
+
+	if (miter->__flags & SG_MITER_ATOMIC)
+		miter->addr = kmap_atomic(miter->page, KM_BIO_SRC_IRQ) + off;
+	else
+		miter->addr = kmap(miter->page) + off;
+
+	return true;
+}
+EXPORT_SYMBOL(sg_miter_next);
+
+/**
+ * sg_miter_stop - stop mapping iteration
+ * @miter: sg mapping iter to be stopped
+ *
+ * Description:
+ *   Stops mapping iterator @miter.  @miter should have been started
+ *   started using sg_miter_start().  A stopped iteration can be
+ *   resumed by calling sg_miter_next() on it.  This is useful when
+ *   resources (kmap) need to be released during iteration.
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+void sg_miter_stop(struct sg_mapping_iter *miter)
+{
+	WARN_ON(miter->consumed > miter->length);
+
+	/* drop resources from the last iteration */
+	if (miter->addr) {
+		miter->__offset += miter->consumed;
+
+		if (miter->__flags & SG_MITER_ATOMIC) {
+			WARN_ON(!irqs_disabled());
+			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
+		} else
+			kunmap(miter->addr);
+
+		miter->page = NULL;
+		miter->addr = NULL;
+		miter->length = 0;
+		miter->consumed = 0;
+	}
+}
+EXPORT_SYMBOL(sg_miter_stop);
+
+/**
  * sg_copy_buffer - Copy data between a linear buffer and an SG list
  * @sgl:		 The SG list
  * @nents:		 Number of SG entries
@@ -309,56 +420,29 @@ EXPORT_SYMBOL(sg_alloc_table);
 static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 			     void *buf, size_t buflen, int to_buffer)
 {
-	struct scatterlist *sg;
-	size_t buf_off = 0;
-	int i;
-
-	WARN_ON(!irqs_disabled());
-
-	for_each_sg(sgl, sg, nents, i) {
-		struct page *page;
-		int n = 0;
-		unsigned int sg_off = sg->offset;
-		unsigned int sg_copy = sg->length;
-
-		if (sg_copy > buflen)
-			sg_copy = buflen;
-		buflen -= sg_copy;
-
-		while (sg_copy > 0) {
-			unsigned int page_copy;
-			void *p;
-
-			page_copy = PAGE_SIZE - sg_off;
-			if (page_copy > sg_copy)
-				page_copy = sg_copy;
-
-			page = nth_page(sg_page(sg), n);
-			p = kmap_atomic(page, KM_BIO_SRC_IRQ);
-
-			if (to_buffer)
-				memcpy(buf + buf_off, p + sg_off, page_copy);
-			else {
-				memcpy(p + sg_off, buf + buf_off, page_copy);
-				flush_kernel_dcache_page(page);
-			}
-
-			kunmap_atomic(p, KM_BIO_SRC_IRQ);
-
-			buf_off += page_copy;
-			sg_off += page_copy;
-			if (sg_off == PAGE_SIZE) {
-				sg_off = 0;
-				n++;
-			}
-			sg_copy -= page_copy;
+	unsigned int offset = 0;
+	struct sg_mapping_iter miter;
+
+	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
+
+	while (sg_miter_next(&miter) && offset < buflen) {
+		unsigned int len;
+
+		len = min(miter.length, buflen - offset);
+
+		if (to_buffer)
+			memcpy(buf + offset, miter.addr, len);
+		else {
+			memcpy(miter.addr, buf + offset, len);
+			flush_kernel_dcache_page(miter.page);
 		}
 
-		if (!buflen)
-			break;
+		offset += len;
 	}
 
-	return buf_off;
+	sg_miter_stop(&miter);
+
+	return offset;
 }
 
 /**
