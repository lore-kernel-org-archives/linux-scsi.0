From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: performance improvements for the sglist API (Re: [PATCH] scsi:
 virtio-scsi: Fix address translation failure of HighMem pages used by sg
 list)
Date: Wed, 25 Jul 2012 17:16:29 +0200
Message-ID: <50100DCD.7030102@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <500FF656.6000203@redhat.com> <5010047D.6070807@panasas.com> <50100C37.1060408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50100C37.1060408@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 17:09, Paolo Bonzini ha scritto:
> Il 25/07/2012 16:36, Boaz Harrosh ha scritto:
>>>>
>>>> I did test the patch with value-assignment.
>>>>
>>
>> Still you should use the sg_set_page()!!
>> 1. It is not allowed to directly manipulate sg entries. One should always
>>    use the proper accessor. Even if open coding does work and is not a bug
>>    it should not be used anyway!
>> 2. Future code that will support chaining will need to do as I say so why
>>    change it then, again?
> 
> Future code that will support chaining will not copy anything at all.
> 
> Also, and more important, note that I am _not_ calling sg_init_table
> before the loop, only once in the driver initialization.  That's because
> memset in sg_init_table is an absolute performance killer, especially if
> you have to do it in a critical section; and I'm not making this up, see
> blk_rq_map_sg:
> 
>                           * If the driver previously mapped a shorter
>                           * list, we could see a termination bit
>                           * prematurely unless it fully inits the sg
>                           * table on each mapping. We KNOW that there
>                           * must be more entries here or the driver
>                           * would be buggy, so force clear the
>                           * termination bit to avoid doing a full
>                           * sg_init_table() in drivers for each command.
>                           */
>                           sg->page_link &= ~0x02;
>                           sg = sg_next(sg);
> 
> So let's instead fix the API so that I (and blk-merge.c) can touch
> memory just once.  For example you could add __sg_set_page and
> __sg_set_buf, basically the equivalent of
> 
>     memset(sg, 0, sizeof(*sg));
>     sg_set_{page,buf}(sg, page, len, offset);
> 
> Calling these functions would be fine if you later add a manual call to
> sg_mark_end, again the same as blk-merge.c does.  See the attached
> untested/uncompiled patch.
> 
> And value assignment would be the same as a
> 
>     __sg_set_page(sg, sg_page(page), sg->length, sg->offset);

ENOPATCH...

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..00ba3d4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -146,7 +146,9 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 new_segment:
 			if (!sg)
 				sg = sglist;
-			else {
+			else
+				sg = sg_next(sg);
+
 				/*
 				 * If the driver previously mapped a shorter
 				 * list, we could see a termination bit
@@ -158,11 +160,7 @@ new_segment:
 				 * termination bit to avoid doing a full
 				 * sg_init_table() in drivers for each command.
 				 */
-				sg->page_link &= ~0x02;
-				sg = sg_next(sg);
-			}
-
-			sg_set_page(sg, bvec->bv_page, nbytes, bvec->bv_offset);
+			__sg_set_page(sg, bvec->bv_page, nbytes, bvec->bv_offset);
 			nsegs++;
 		}
 		bvprv = bvec;
@@ -182,12 +180,11 @@ new_segment:
 		if (rq->cmd_flags & REQ_WRITE)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
-		sg->page_link &= ~0x02;
 		sg = sg_next(sg);
-		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
-			    q->dma_drain_size,
-			    ((unsigned long)q->dma_drain_buffer) &
-			    (PAGE_SIZE - 1));
+		__sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
+			      q->dma_drain_size,
+			      ((unsigned long)q->dma_drain_buffer) &
+			      (PAGE_SIZE - 1));
 		nsegs++;
 		rq->extra_len += q->dma_drain_size;
 	}
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ac9586d..d6a937e 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -44,32 +44,23 @@ struct sg_table {
 #define sg_chain_ptr(sg)	\
 	((struct scatterlist *) ((sg)->page_link & ~0x03))
 
-/**
- * sg_assign_page - Assign a given page to an SG entry
- * @sg:		    SG entry
- * @page:	    The page
- *
- * Description:
- *   Assign page to sg entry. Also see sg_set_page(), the most commonly used
- *   variant.
- *
- **/
-static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
+static inline void __sg_set_page(struct scatterlist *sg, struct page *page,
+				 unsigned int len, unsigned int offset)
 {
-	unsigned long page_link = sg->page_link & 0x3;
-
 	/*
 	 * In order for the low bit stealing approach to work, pages
 	 * must be aligned at a 32-bit boundary as a minimum.
 	 */
 	BUG_ON((unsigned long) page & 0x03);
 #ifdef CONFIG_DEBUG_SG
-	BUG_ON(sg->sg_magic != SG_MAGIC);
-	BUG_ON(sg_is_chain(sg));
+	sg->sg_magic = SG_MAGIC;
 #endif
-	sg->page_link = page_link | (unsigned long) page;
+	sg->page_link = page;
+	sg->offset = offset;
+	sg->length = len;
 }
 
+
 /**
  * sg_set_page - Set sg entry to point at given page
  * @sg:		 SG entry
@@ -87,9 +78,13 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
-	sg_assign_page(sg, page);
-	sg->offset = offset;
-	sg->length = len;
+	unsigned long flags = sg->page_link & 0x3;
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	__sg_set_page(sg, page, len, offset);
+	sg->page_link |= flags;
 }
 
 static inline struct page *sg_page(struct scatterlist *sg)
@@ -101,6 +96,12 @@ static inline struct page *sg_page(struct scatterlist *sg)
 	return (struct page *)((sg)->page_link & ~0x3);
 }
 
+static inline void __sg_set_buf(struct scatterlist *sg, const void *buf,
+				unsigned int buflen)
+{
+	__sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
+}
+
 /**
  * sg_set_buf - Set sg entry to point at given data
  * @sg:		 SG entry
