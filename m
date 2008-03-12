From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Wed, 12 Mar 2008 09:14:00 +0900
Message-ID: <20080312091400V.fujita.tomonori@lab.ntt.co.jp>
References: <20080311070956E.tomof@acm.org>
	<Pine.LNX.4.44L0.0803111543220.26916-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:59013 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYCLAQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 20:16:09 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803111543220.26916-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: tomof@acm.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org

On Tue, 11 Mar 2008 16:09:26 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 11 Mar 2008, FUJITA Tomonori wrote:
> 
> > On Mon, 10 Mar 2008 16:10:36 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > > Have you had a look at drivers/usb/storage/protocol.c usb_stor_access_xfer_buf() ?
> > > It looks like it could also use these, but there they have a twist where they want
> > > to do it in parts. Do you think that the code there could also use the helpers 
> > > presented here somehow? (I know that one of the USB guys was asking about it)
> > 
> > I've not. If the USB people are eager to use the new APIs, I'll try
> > though I prefer to keep them simple.
> 
> It would be great if the code could be removed from usb-storage and put
> in a central library.  The problem is, as Boaz mentioned, that some of
> the subdrivers need to transfer their data in pieces.

I'm fine with add a trick for USB to the APIs as long as USB people
inspect and test the trick ;)


> It may be that the device is able to send or receive only a few blocks 
> at a time, or it may be that the blocks aren't stored in continguous 
> locations on the device.  Either way, the drivers need to do multiple 
> transfers, each starting from where the previous one left off.
> 
> It shouldn't be too hard to adjust your code to make this work.  
> Instead of passing sgl and nents directly to sg_copy_buffer(), pass a
> pointer to a structure containing fields for sgl, nents, n, sg_off, and
> sg_copy.  Then the caller could retain the ending values for use in a
> later call.
> 
> Does this sound reasonable?

How about this?

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index a3d567a..8951e3c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -213,6 +213,13 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 
+int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
+		   unsigned long *offset, void *buf, int buflen, int to_buffer);
+int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			void *buf, int buflen);
+int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+		      void *buf, int buflen);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index acca490..587188c 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -8,6 +8,7 @@
  */
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -292,3 +293,111 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 	return ret;
 }
 EXPORT_SYMBOL(sg_alloc_table);
+
+int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
+		   unsigned long *offset, void *buf, int buflen, int to_buffer)
+{
+	struct scatterlist *sg;
+	unsigned long buf_off = 0;
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
+	}
+
+	*sgl = sg;
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
+	struct scatterlist *s = sgl;
+	unsigned long offset = 0;
+
+	return sg_copy_buffer(&s, nents, &offset, buf, buflen, 0);
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
+	struct scatterlist *s = sgl;
+	unsigned long offset = 0;
+
+	return sg_copy_buffer(&s, nents, &offset, buf, buflen, 1);
+}
+EXPORT_SYMBOL(sg_copy_to_buffer);
