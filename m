Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71686C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 03:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiBADtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 22:49:25 -0500
Received: from smtp.infotech.no ([82.134.31.41]:32817 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbiBADtZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 22:49:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id BAF4C2041BD;
        Tue,  1 Feb 2022 04:49:22 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZC7obR1We4LR; Tue,  1 Feb 2022 04:49:19 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 6A29D2041AC;
        Tue,  1 Feb 2022 04:49:18 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit
Date:   Mon, 31 Jan 2022 22:49:12 -0500
Message-Id: <20220201034915.183117-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201034915.183117-1-dgilbert@interlog.com>
References: <20220201034915.183117-1-dgilbert@interlog.com>
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

In early 2021 there was discussion between Jason Gunthorpe
<jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com> about the
way to check for overflow caused by order (an exponent) being
too large. Take the solution proposed by Bodo in post dated
20210118 to the linux-scsi and linux-block lists.

An earlier patch fixed a memory leak in sg_alloc_order() due to the
misuse of sgl_free(). Take the opportunity to put a one line comment
above sgl_free()'s declaration warning that it is not suitable when
order > 0 .

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  1 +
 lib/scatterlist.c           | 24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 7ff9d6386c12..03130be581bb 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -357,6 +357,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
 			      unsigned int *nent_p);
 void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
 void sgl_free_order(struct scatterlist *sgl, int order);
+/* Only use sgl_free() when order is 0 */
 void sgl_free(struct scatterlist *sgl);
 #endif /* CONFIG_SGL_ALLOC */
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d5e82e4a57ad..ed6d0465c78e 100644
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
@@ -604,16 +607,15 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 	unsigned int nent, nalloc;
 	u32 elem_len;
 
-	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
-	/* Check for integer overflow */
-	if (length > (nent << (PAGE_SHIFT + order)))
+	if (length >> (PAGE_SHIFT + order) >= UINT_MAX)
 		return NULL;
-	nalloc = nent;
+	nent = DIV_ROUND_UP(length, PAGE_SIZE << order);
+
 	if (chainable) {
-		/* Check for integer overflow */
-		if (nalloc + 1 < nalloc)
+		if (check_add_overflow(nent, 1U, &nalloc))
 			return NULL;
-		nalloc++;
+	} else {
+		nalloc = nent;
 	}
 	sgl = kmalloc_array(nalloc, sizeof(struct scatterlist),
 			    gfp & ~GFP_DMA);
-- 
2.25.1

