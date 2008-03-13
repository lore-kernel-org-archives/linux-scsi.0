From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Thu, 13 Mar 2008 09:03:24 +0900
Message-ID: <20080313085733M.tomof@acm.org>
References: <20080312091400V.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.0803121132210.4595-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0803121132210.4595-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, 12 Mar 2008 12:01:57 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index a3d567a..8951e3c 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -213,6 +213,13 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
> >  		     sg_alloc_fn *);
> >  int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
> >  
> > +int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
> > +		   unsigned long *offset, void *buf, int buflen, int to_buffer);
> > +int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
> > +			void *buf, int buflen);
> > +int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
> > +		      void *buf, int buflen);
> 
> These routines probably should not return int.  Maybe unsigned int or 
> unsigned long.  If you really want to be picky, it should be size_t.
> 
> Same goes for the type of the buflen parameter.

OK, let's use size_t.


> > +int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
> > +		   unsigned long *offset, void *buf, int buflen, int to_buffer)
> > +{
> > +	struct scatterlist *sg;
> > +	unsigned long buf_off = 0;
> 
> The type of buf_off should be the same as the function's return type.

Fixed.


> > +	int i;
> > +
> > +	WARN_ON(!irqs_disabled());
> > +
> > +	for_each_sg(*sgl, sg, nents, i) {
> 
> Will there be a problem in subsequent calls if *sgl has been
> incremented but nents hasn't been changed?  Maybe nents needs to be a 
> pointer also.

usb_stor_access_xfer_buf doesn't check scsi_sg_count (the number of sg
entries). It assumes that callers take care about the issue.

If you want nents to be a pointer, I'm fine with it.


> > +		struct page *page;
> > +		int n = 0;
> > +		unsigned int sg_off = sg->offset;
> > +		unsigned int sg_copy = sg->length;
> > +
> > +		BUG_ON(*offset > sg_copy);
> > +
> > +		if (!buflen)
> > +			break;
> > +
> > +		sg_off += *offset;
> > +		n = sg_off >> PAGE_SHIFT;
> > +		sg_off &= ~PAGE_MASK;
> > +		sg_copy -= *offset;
> > +
> > +		if (sg_copy > buflen) {
> > +			sg_copy = buflen;
> > +			*offset += sg_copy;
> > +		} else
> > +			*offset = 0;
> > +
> > +		buflen -= sg_copy;
> > +
> > +		while (sg_copy > 0) {
> > +			unsigned int page_copy;
> > +			void *p;
> > +
> > +			page_copy = PAGE_SIZE - sg_off;
> > +			if (page_copy > sg_copy)
> > +				page_copy = sg_copy;
> > +
> > +			page = nth_page(sg_page(sg), n);
> > +			p = kmap_atomic(page, KM_BIO_SRC_IRQ);
> > +
> > +			if (to_buffer)
> > +				memcpy(buf + buf_off, p + sg_off, page_copy);
> > +			else {
> > +				memcpy(p + sg_off, buf + buf_off, page_copy);
> > +				flush_kernel_dcache_page(page);
> > +			}
> > +
> > +			kunmap_atomic(p, KM_BIO_SRC_IRQ);
> > +
> > +			buf_off += page_copy;
> > +			sg_off += page_copy;
> > +			if (sg_off == PAGE_SIZE) {
> > +				sg_off = 0;
> > +				n++;
> > +			}
> > +			sg_copy -= page_copy;
> > +		}
> 
> Here you need to add:
> 
> 		if (*offset)
> 			break;
> 
> Otherwise *sgl will be incremented wrongly if the transfer ends in the
> middle of an sg entry.

Thanks, fixed.


> > +	}
> > +
> > +	*sgl = sg;
> > +
> > +	return buf_off;
> > +}
> 
> > +
> > +/**
> > + * sg_copy_from_buffer - Copy from liner buffer to an SG table
> 
> s/liner/linear/

It was fixed in the git tree.


> > + * @sgl:		 The SG table
> > + * @nents:		 Number of SG entries
> > + * @buf:		 Where to copy from
> > + * @buflen:		 The number of bytes to copy
> > + *
> > + * Returns the number of copied byte.
> 
> s/byte/bytes/

Fixed, thanks.


> > + *
> > + **/
> > +int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
> > +			void *buf, int buflen)
> > +{
> > +	struct scatterlist *s = sgl;
> > +	unsigned long offset = 0;
> > +
> > +	return sg_copy_buffer(&s, nents, &offset, buf, buflen, 0);
> 
> You don't have to copy sgl into s.  Just pass &sgl directly.

Duh, fixed.

Here's an updated version.

=
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index a3d567a..2f863f3 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -213,6 +213,14 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 
+size_t sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
+		      unsigned int *offset, void *buf, size_t buflen,
+		      int to_buffer);
+size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			   void *buf, size_t buflen);
+size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			 void *buf, size_t buflen);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index acca490..4f0813c 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -8,6 +8,7 @@
  */
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -292,3 +293,129 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 	return ret;
 }
 EXPORT_SYMBOL(sg_alloc_table);
+
+/**
+ * sg_copy_buffer - Copy data between a linear buffer and an SG list
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @offset:		 start data transfer in the first SG entry at
+ * @buf:		 Where to copy from
+ * @buflen:		 The number of bytes to copy
+ * @to_buffer: 		 transfer direction (non zero == from an sg list to a
+ * 			 buffer, 0 == from a buffer to an sg list
+ *
+ * Returns the number of copied bytes.
+ *
+ * *sgl is updated to point a SG list that next data transfer should
+ * start with. *offset is updated to a value that next data transfer
+ * should use.
+ *
+ **/
+size_t sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
+		      unsigned int *offset, void *buf, size_t buflen,
+		      int to_buffer)
+{
+	struct scatterlist *sg;
+	size_t buf_off = 0;
+	int i;
+
+	WARN_ON(!irqs_disabled());
+
+	for_each_sg(*sgl, sg, nents, i) {
+		struct page *page;
+		int n = 0;
+		unsigned int sg_off = sg->offset;
+		unsigned int sg_copy = sg->length;
+
+		BUG_ON(*offset > sg_copy);
+
+		if (!buflen)
+			break;
+
+		sg_off += *offset;
+		n = sg_off >> PAGE_SHIFT;
+		sg_off &= ~PAGE_MASK;
+		sg_copy -= *offset;
+
+		if (sg_copy > buflen) {
+			sg_copy = buflen;
+			*offset += sg_copy;
+		} else
+			*offset = 0;
+
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
+			if (to_buffer)
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
+		if (*offset)
+			break;
+	}
+
+	*sgl = sg;
+
+	return buf_off;
+}
+EXPORT_SYMBOL(sg_copy_buffer);
+
+/**
+ * sg_copy_from_buffer - Copy from a linear buffer to an SG list
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy from
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			   void *buf, size_t buflen)
+{
+	unsigned int offset = 0;
+	return sg_copy_buffer(&sgl, nents, &offset, buf, buflen, 0);
+}
+EXPORT_SYMBOL(sg_copy_from_buffer);
+
+/**
+ * sg_copy_to_buffer - Copy from an SG list to a linear buffer
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy to
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			 void *buf, size_t buflen)
+{
+	unsigned int offset = 0;
+	return sg_copy_buffer(&sgl, nents, &offset, buf, buflen, 1);
+}
+EXPORT_SYMBOL(sg_copy_to_buffer);
