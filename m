From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 2/4] lib/scatterlist: introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
Date: Tue, 18 Jun 2013 22:31:32 +0900
Message-ID: <1371562294-13642-3-git-send-email-akinobu.mita@gmail.com>
References: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The only difference between sg_pcopy_{from,to}_buffer() and
sg_copy_{from,to}_buffer() is an additional argument that specifies
the number of bytes to skip the SG list before copying.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---

* Change from v2
- Separate the change that factors out sg_miter_get_next_page()
- Add function comment for internal function sg_miter_seek()

 include/linux/scatterlist.h |  5 +++
 lib/scatterlist.c           | 88 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2680677..adae88f 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -244,6 +244,11 @@ size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
 
+size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			    void *buf, size_t buflen, off_t skip);
+size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			  void *buf, size_t buflen, off_t skip);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c35b929..f167392 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -476,6 +476,43 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
 }
 
 /**
+ * sg_miter_seek - reposition mapping iterator
+ * @miter: sg mapping iter to be seeked
+ * @offset: number of bytes to plus the current location
+ *
+ * Description:
+ *   Sets the offset of @miter to its current location plus @offset bytes.
+ *
+ * Notes:
+ *   This function must be called just after sg_miter_start() or sg_miter_stop()
+ *
+ * Context:
+ *   Don't care.
+ *
+ * Returns:
+ *   true if @miter contains the valid mapping.  false if end of sg
+ *   list is reached.
+ */
+static bool sg_miter_seek(struct sg_mapping_iter *miter, off_t offset)
+{
+	WARN_ON(miter->addr);
+
+	while (offset) {
+		off_t consumed;
+
+		if (!sg_miter_get_next_page(miter))
+			return false;
+
+		consumed = min_t(off_t, offset, miter->__remaining);
+		miter->__offset += consumed;
+		miter->__remaining -= consumed;
+		offset -= consumed;
+	}
+
+	return true;
+}
+
+/**
  * sg_miter_next - proceed mapping iterator to the next mapping
  * @miter: sg mapping iter to proceed
  *
@@ -561,14 +598,16 @@ EXPORT_SYMBOL(sg_miter_stop);
  * @nents:		 Number of SG entries
  * @buf:		 Where to copy from
  * @buflen:		 The number of bytes to copy
- * @to_buffer: 		 transfer direction (non zero == from an sg list to a
- * 			 buffer, 0 == from a buffer to an sg list
+ * @skip:		 Number of bytes to skip before copying
+ * @to_buffer:		 transfer direction (true == from an sg list to a
+ *			 buffer, false == from a buffer to an sg list
  *
  * Returns the number of copied bytes.
  *
  **/
 static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
-			     void *buf, size_t buflen, int to_buffer)
+			     void *buf, size_t buflen, off_t skip,
+			     bool to_buffer)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -582,6 +621,9 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 
 	sg_miter_start(&miter, sgl, nents, sg_flags);
 
+	if (!sg_miter_seek(&miter, skip))
+		return false;
+
 	local_irq_save(flags);
 
 	while (sg_miter_next(&miter) && offset < buflen) {
@@ -616,7 +658,7 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 0);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, false);
 }
 EXPORT_SYMBOL(sg_copy_from_buffer);
 
@@ -633,6 +675,42 @@ EXPORT_SYMBOL(sg_copy_from_buffer);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+/**
+ * sg_pcopy_from_buffer - Copy from a linear buffer to an SG list
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy from
+ * @skip:		 Number of bytes to skip before copying
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			    void *buf, size_t buflen, off_t skip)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, skip, false);
+}
+EXPORT_SYMBOL(sg_pcopy_from_buffer);
+
+/**
+ * sg_pcopy_to_buffer - Copy from an SG list to a linear buffer
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy to
+ * @skip:		 Number of bytes to skip before copying
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			  void *buf, size_t buflen, off_t skip)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
+}
+EXPORT_SYMBOL(sg_pcopy_to_buffer);
-- 
1.8.1.4
