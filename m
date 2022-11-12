Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E120C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Nov 2022 19:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiKLTtw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Nov 2022 14:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLTtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2022 14:49:52 -0500
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 571F49FE6
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2022 11:49:48 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id BEEE72041AF;
        Sat, 12 Nov 2022 20:49:46 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZuNTJRzRd9rU; Sat, 12 Nov 2022 20:49:44 +0100 (CET)
Received: from treten.bingwo.ca (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        by smtp.infotech.no (Postfix) with ESMTPA id 6DCBA20416D;
        Sat, 12 Nov 2022 20:49:43 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, bostroesser@gmail.com, jgg@ziepe.ca
Subject: [PATCH v2 1/5] sgl_alloc_order: remove 4 GiB limit
Date:   Sat, 12 Nov 2022 14:49:35 -0500
Message-Id: <20221112194939.4823-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221112194939.4823-1-dgilbert@interlog.com>
References: <20221112194939.4823-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a check done by sgl_alloc_order() before it starts
any allocations. The comment in the original said: "Check for integer
overflow" but the right hand side of the expression in the condition
is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
means 'length' can not exceed that value.

This function may be used to replace vmalloc(unsigned long) for a
large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
it seems unreasonable that sgl_alloc_order() whose length type is
unsigned long long should be limited to 4 GB.

Solutions to this issue were discussed by Jason Gunthorpe
<jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com>. This
version is base on a linux-scsi post by Jason titled: "Re:
[PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit" dated 20220201.

An earlier patch fixed a memory leak in sg_alloc_order() due to the
misuse of sgl_free(). Take the opportunity to put a one line comment
above sgl_free()'s declaration warning that it is not suitable when
order > 0 .

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  1 +
 lib/scatterlist.c           | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 375a5e90d86a..0930755a756e 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -426,6 +426,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
 			      unsigned int *nent_p);
 void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
 void sgl_free_order(struct scatterlist *sgl, int order);
+/* Only use sgl_free() when order is 0 */
 void sgl_free(struct scatterlist *sgl);
 #endif /* CONFIG_SGL_ALLOC */
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c8c3d675845c..ee69d33d1228 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -585,13 +585,16 @@ EXPORT_SYMBOL(sg_alloc_table_from_pages_segment);
 #ifdef CONFIG_SGL_ALLOC
 
 /**
- * sgl_alloc_order - allocate a scatterlist and its pages
+ * sgl_alloc_order - allocate a scatterlist with equally sized elements each
+ *		     of which has 2^@order continuous pages
  * @length: Length in bytes of the scatterlist. Must be at least one
- * @order: Second argument for alloc_pages()
+ * @order:  Second argument for alloc_pages(). Each sgl element size will
+ *	    be (PAGE_SIZE*2^@order) bytes. @order must not exceed 16.
  * @chainable: Whether or not to allocate an extra element in the scatterlist
- *	for scatterlist chaining purposes
+ *	       for scatterlist chaining purposes
  * @gfp: Memory allocation flags
- * @nent_p: [out] Number of entries in the scatterlist that have pages
+ * @nent_p: [out] Number of entries in the scatterlist that have pages.
+ *		  Ignored if @nent_p is NULL.
  *
  * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
  */
@@ -601,14 +604,16 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 {
 	struct scatterlist *sgl, *sg;
 	struct page *page;
-	unsigned int nent, nalloc;
+	uint64_t nent;
+	unsigned int nalloc;
 	u32 elem_len;
 
+	if (WARN_ON_ONCE(order >= MAX_ORDER))
+		return NULL;
 	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
-	/* Check for integer overflow */
-	if (length > (nent << (PAGE_SHIFT + order)))
+	if (nent > UINT_MAX)
 		return NULL;
-	nalloc = nent;
+	nalloc = (unsigned int)nent;
 	if (chainable) {
 		/* Check for integer overflow */
 		if (nalloc + 1 < nalloc)
@@ -636,7 +641,7 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 	}
 	WARN_ONCE(length, "length = %lld\n", length);
 	if (nent_p)
-		*nent_p = nent;
+		*nent_p = (unsigned int)nent;
 	return sgl;
 }
 EXPORT_SYMBOL(sgl_alloc_order);
-- 
2.37.2

