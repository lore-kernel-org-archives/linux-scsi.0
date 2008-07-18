From: Tejun Heo <htejun@gmail.com>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Fri, 18 Jul 2008 21:38:56 +0900
Message-ID: <48808EE0.2060603@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au> <200807170053.36661.rjw@sisk.pl> <1216249292.3358.66.camel@localhost.localdomain> <200807170109.30655.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <200807170109.30655.rjw@sisk.pl>
Sender: linux-next-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de, drzeus@drzeus.cx
List-Id: linux-scsi@vger.kernel.org

Hello,

Rafael J. Wysocki wrote:
>>> Crashes during boot on a box with Phenom X4 and AMD 790-based mainboard.
>>> AFAICS, the Linus' tree is unaffected and linux-next from yesterday was fine
>>> on the same box with the same .config.
>> OK, that means that all the current SCSI patches were merged and it was
>> still OK (they're all in linus and I haven't put together the next slice
>> yet).  I'd suspect something in drivers/ata (cc ide list added).
>>
>> James
> 
> OK, let's ask Tejun and Jeff too.
> 
> I suspect the AHCI driver, because the same kernel works on my other boxes
> with different SATA controllers.
>  
>>> Full dmesg: http://www.sisk.pl/kernel/debug/next/20080716/crash-M3A32-MVP.log
>>> Kernel config: http://www.sisk.pl/kernel/debug/next/20080716/M3A32-MVP-config
>>>
>>> scsi scan: INQUIRY result too short (5), using 36
>>> scsi 2:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
>>> ------------[ cut here ]------------
>>> kernel BUG at /home/rafael/src/linux-next/mm/slab.c:2822!

The offending commit was 83e7d317cef3ee624886f128401a72e414c0a99d
which implements sg iterator but it forgot to add offset to the
kmapped address and copy goes out of bounds.  Takashi, this could also
be the problem you were seeing if you don't have slab debugging turned
on.

The implemented iterator didn't look too pretty and the usage was
quite awkward involving a callback and end condition check distributed
between the callback and the outer user who runs the loop.  For
copying, end of buffer condition was tested by testing whether the
callback returned 0 copied bytes for the iteration but AFAIK there's
no restriction against zero length sg entry in the middle and it will
terminate the copying prematurely.

So, I implemented slightly different version which follows below.

Subject: [PATCH next-20080716] sg: reimplement sg mapping iterator

sg mapping iterator implemented by 83e7d317... had a bug and was a bit
awkard to use.  Reimplement it as more regular iterator with start,
next and stop.  As there's already an sg iterator which iterates over
sg entries themselves, name this sg_mapping_iterator.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
---
 include/linux/scatterlist.h |   43 +++++++---
 lib/scatterlist.c           |  186 ++++++++++++++++++++++----------------------
 2 files changed, 125 insertions(+), 104 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 93411a1..c9058b0 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -13,12 +13,6 @@ struct sg_table {
 	unsigned int orig_nents;	/* original size of list */
 };
 
-struct sg_iterator {
-	struct scatterlist *sg;		/* current entry */
-	unsigned int nents;		/* number of remaining entries */
-	unsigned int offset;		/* offset within sg */
-};
-
 /*
  * Notes on SG table design.
  *
@@ -219,12 +213,6 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 
-typedef size_t (sg_iter_fn)(void *, size_t, struct page *, void *);
-
-void sg_iter_init(struct sg_iterator *iter, struct scatterlist *sgl,
-		  unsigned int nents);
-size_t sg_iterate(struct sg_iterator *iter, sg_iter_fn *fn, void *priv);
-
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
@@ -236,4 +224,35 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
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
+ */
+
+#define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
+
+struct sg_mapping_iter {
+	/* the following three fields can be accessed directly */
+	struct page		*page;		/* currently mapped page */
+	void			*addr;		/* pointer to the mapped area */
+	size_t			length;		/* length of the mapped area */
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
index ea8c3a1..6d51bd3 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -295,115 +295,107 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);
 
 /**
- * sg_iter_init - Initialize/reset an sg iterator structure
- * @iter:	The sg iterator structure
- * @sgl:	The sg list to iterate over
- * @nents:	Number of sg entries
+ * sg_miter_start - start mapping iteration over a sg list
+ * @miter: sg mapping iter to be started
+ * @sgl: sg list to iterate over
+ * @nents: number of sg entries
  *
- *  Description:
- *    Sets up the internal state of the sg iterator structure
- *    to the beginning of the given sg list.
+ * Description:
+ *   Starts mapping iterator @miter.
+ *
+ * Context:
+ *   Don't care.
  */
-void sg_iter_init(struct sg_iterator *iter, struct scatterlist *sgl,
-		  unsigned int nents)
+void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
+		    unsigned int nents, unsigned int flags)
 {
-	memset(iter, 0, sizeof(struct sg_iterator));
+	memset(miter, 0, sizeof(struct sg_mapping_iter));
 
-	iter->sg = sgl;
-	iter->nents = nents;
-	iter->offset = 0;
+	miter->__sg = sgl;
+	miter->__nents = nents;
+	miter->__offset = 0;
+	miter->__flags = flags;
 }
-EXPORT_SYMBOL(sg_iter_init);
+EXPORT_SYMBOL(sg_miter_start);
 
 /**
- * sg_iterate - Process the next chunk of the sg list
- * @iter:	The sg iterator structure
- * @fn:		Function that will process the data
- * @priv:	Private data passed on to @fn@
+ * sg_miter_next - proceed mapping iterator to the next mapping
+ * @miter: sg mapping iter to proceed
  *
- *  Description:
- *    The main worker of sg list iteration. Each invokation will
- *    call @fn@ with a chunk of data that has been mapped into
- *    kernel reachable virtual memory. The function must return
- *    the number of bytes processed, which may be less than the
- *    total size of the current chunk.
+ * Description:
+ *   Proceeds @miter@ to the next mapping.  @miter@ should have been
+ *   started using sg_miter_start().  On successful return,
+ *   @miter@->page, @miter@->addr and @miter@->length point to the
+ *   current mapping.
  *
- *    It is not required that @fn@ and @priv@ are identical between
- *    each invokation, allowing separate processing of different
- *    sections of the sg list.
+ * Context:
+ *   IRQ disabled if SG_MITER_ATOMIC.  IRQ must stay disabled till
+ *   @miter@ is stopped.  May sleep if !SG_MITER_ATOMIC.
  *
- *    The return value is that given by @fn@, or 0 if the end of
- *    the sg list has been reached.
+ * Returns:
+ *   true if @miter contains the next mapping.  false if end of sg
+ *   list is reached.
  */
-size_t sg_iterate(struct sg_iterator *iter, sg_iter_fn *fn, void *priv)
+bool sg_miter_next(struct sg_mapping_iter *miter)
 {
-	struct page *page;
-	int n;
-	size_t buflen;
-	unsigned int sg_offset, sg_remain;
-
-	void *buf;
-	size_t result;
-
-	WARN_ON(!irqs_disabled());
+	unsigned int off, len;
 
-	if (iter->nents == 0)
-		return 0;
+	/* check for end and drop resources from the last iteration */
+	if (!miter->__nents)
+		return false;
 
-	sg_offset = iter->sg->offset + iter->offset;
-	sg_remain = iter->sg->length - iter->offset;
+	sg_miter_stop(miter);
 
-	n = sg_offset / PAGE_SIZE;
-	page = nth_page(sg_page(iter->sg), n);
+	/* map the next page */
+	off = miter->__sg->offset + miter->__offset;
+	len = miter->__sg->length - miter->__offset;
 
-	buflen = PAGE_SIZE - (sg_offset % PAGE_SIZE);
-	if (buflen > sg_remain)
-		buflen = sg_remain;
+	miter->page = nth_page(sg_page(miter->__sg), off >> PAGE_SHIFT);
+	off &= ~PAGE_MASK;
+	miter->length = min_t(unsigned int, len, PAGE_SIZE - off);
 
-	buf = kmap_atomic(page, KM_BIO_SRC_IRQ);
-	result = fn(buf, buflen, page, priv);
-	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
-
-	WARN_ON(result > buflen);
-
-	iter->offset += result;
+	if (miter->__flags & SG_MITER_ATOMIC)
+		miter->addr = kmap_atomic(miter->page, KM_BIO_SRC_IRQ) + off;
+	else
+		miter->addr = kmap(miter->page) + off;
 
-	if (iter->offset == iter->sg->length) {
-		iter->nents--;
-		if (iter->nents)
-			iter->sg = sg_next(iter->sg);
-		iter->offset = 0;
+	/* proceed the iterator */
+	miter->__offset += miter->length;
+	if (miter->__offset == miter->__sg->length && --miter->__nents) {
+		miter->__sg = sg_next(miter->__sg);
+		miter->__offset = 0;
 	}
 
-	return result;
+	return true;
 }
-EXPORT_SYMBOL(sg_iterate);
+EXPORT_SYMBOL(sg_miter_next);
 
-struct sg_copy_state {
-	void *buf;
-	size_t offset, buflen;
-	int to_buffer;
-};
-
-static size_t sg_copy_worker(void *buf, size_t buflen,
-			     struct page *page, void *priv)
+/**
+ * sg_miter_stop - stop mapping iteration
+ * @miter: sg mapping iter to be stopped
+ *
+ * Description:
+ *   Stops mapping iterator @miter.
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+void sg_miter_stop(struct sg_mapping_iter *miter)
 {
-	struct sg_copy_state *st = priv;
-
-	if (buflen > (st->buflen - st->offset))
-		buflen = st->buflen - st->offset;
+	/* drop resources from the last iteration */
+	if (miter->addr) {
+		if (miter->__flags & SG_MITER_ATOMIC) {
+			WARN_ON(!irqs_disabled());
+			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
+		} else
+			kunmap(miter->addr);
 
-	if (st->to_buffer)
-		memcpy(st->buf + st->offset, buf, buflen);
-	else {
-		memcpy(buf, st->buf + st->offset, buflen);
-		flush_kernel_dcache_page(page);
+		miter->page = NULL;
+		miter->addr = NULL;
+		miter->length = 0;
 	}
-
-	st->offset += buflen;
-
-	return buflen;
 }
+EXPORT_SYMBOL(sg_miter_stop);
 
 /**
  * sg_copy_buffer - Copy data between a linear buffer and an SG list
@@ -420,19 +412,29 @@ static size_t sg_copy_worker(void *buf, size_t buflen,
 static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 			     void *buf, size_t buflen, int to_buffer)
 {
-	struct sg_iterator iter;
-	struct sg_copy_state state;
+	unsigned int offset = 0;
+	struct sg_mapping_iter miter;
+
+	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
+
+	while (sg_miter_next(&miter) && offset < buflen) {
+		unsigned int len;
 
-	sg_iter_init(&iter, sgl, nents);
+		len = min(miter.length, buflen - offset);
 
-	state.buf = buf;
-	state.offset = 0;
-	state.buflen = buflen;
-	state.to_buffer = to_buffer;
+		if (to_buffer)
+			memcpy(buf + offset, miter.addr, len);
+		else {
+			memcpy(miter.addr, buf + offset, len);
+			flush_kernel_dcache_page(miter.page);
+		}
+
+		offset += len;
+	}
 
-	while (sg_iterate(&iter, sg_copy_worker, &state));
+	sg_miter_stop(&miter);
 
-	return state.offset;
+	return offset;
 }
 
 /**
