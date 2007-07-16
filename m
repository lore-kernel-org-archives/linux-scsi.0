From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/33] Add chained sg support to linux/scatterlist.h
Date: Mon, 16 Jul 2007 11:47:19 +0200
Message-ID: <11845792671254-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9289 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758672AbXGPJse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:34 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

The core of the patch - allow the last sg element in a scatterlist
table to point to the start of a new table. We overload the LSB of
the page pointer to indicate whether this is a valid sg entry, or
merely a link to the next list.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |   79 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index bed5ab4..10f6223 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,8 +20,36 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
-#define sg_next(sg)		((sg) + 1)
-#define sg_last(sg, nents)	(&(sg[(nents) - 1]))
+/*
+ * We overload the LSB of the page pointer to indicate whether it's
+ * a valid sg entry, or whether it points to the start of a new scatterlist.
+ * Those low bits are there for everyone! (thanks mason :-)
+ */
+#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
+#define sg_chain_ptr(sg)	\
+	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
+
+/**
+ * sg_next - return the next scatterlist entry in a list
+ * @sg:		The current sg entry
+ *
+ * Usually the next entry will be @sg@ + 1, but if this sg element is part
+ * of a chained scatterlist, it could jump to the start of a new
+ * scatterlist array.
+ *
+ * Note that the caller must ensure that there are further entries after
+ * the current entry, this function will NOT return NULL for an end-of-list.
+ *
+ */
+static inline struct scatterlist *sg_next(struct scatterlist *sg)
+{
+	sg++;
+
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
 
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
@@ -29,4 +57,51 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 #define for_each_sg(sglist, sg, nr, __i)	\
 	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
 
+/**
+ * sg_last - return the last scatterlist entry in a list
+ * @sgl:	First entry in the scatterlist
+ * @nents:	Number of entries in the scatterlist
+ *
+ * Should only be used casually, it (currently) scan the entire list
+ * to get the last entry.
+ *
+ * Note that the @sgl@ pointer passed in need not be the first one,
+ * the important bit is that @nents@ denotes the number of entries that
+ * exist from @sgl@.
+ *
+ */
+static inline struct scatterlist *sg_last(struct scatterlist *sgl,
+					  unsigned int nents)
+{
+#ifdef ARCH_HAS_SG_CHAIN
+	struct scatterlist *ret = &sgl[nents - 1];
+#else
+	struct scatterlist *sg, *ret = NULL;
+	int i;
+
+	for_each_sg(sgl, sg, nents, i)
+		ret = sg;
+
+#endif
+	return ret;
+}
+
+/**
+ * sg_chain - Chain two sglists together
+ * @prv:	First scatterlist
+ * @prv_nents:	Number of entries in prv
+ * @sgl:	Second scatterlist
+ *
+ * Links @prv@ and @sgl@ together, to form a longer scatterlist.
+ *
+ */
+static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
+			    struct scatterlist *sgl)
+{
+#ifndef ARCH_HAS_SG_CHAIN
+	BUG();
+#endif
+	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
+}
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.3.rc0.90.gbaa79

