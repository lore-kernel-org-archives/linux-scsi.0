Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C196C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 01:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJXBMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 21:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJXBMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 21:12:01 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9223B62A52
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 18:12:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7216F2041CB;
        Mon, 24 Oct 2022 03:02:50 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PM5aLRrSRZbs; Mon, 24 Oct 2022 03:02:48 +0200 (CEST)
Received: from treten.bingwo.ca (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        by smtp.infotech.no (Postfix) with ESMTPA id 5F3D12041AF;
        Mon, 24 Oct 2022 03:02:47 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Date:   Sun, 23 Oct 2022 21:02:40 -0400
Message-Id: <20221024010244.9522-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024010244.9522-1-dgilbert@interlog.com>
References: <20221024010244.9522-1-dgilbert@interlog.com>
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
 lib/scatterlist.c           | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

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
index c8c3d675845c..f633e2d669fe 100644
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
@@ -601,14 +604,14 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 {
 	struct scatterlist *sgl, *sg;
 	struct page *page;
-	unsigned int nent, nalloc;
+	uint64_t nent;
+	unsigned int nalloc;
 	u32 elem_len;
 
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
@@ -636,7 +639,7 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 	}
 	WARN_ONCE(length, "length = %lld\n", length);
 	if (nent_p)
-		*nent_p = nent;
+		*nent_p = (unsigned int)nent;
 	return sgl;
 }
 EXPORT_SYMBOL(sgl_alloc_order);
-- 
2.37.3

