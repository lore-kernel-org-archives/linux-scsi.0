Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEAEC55178
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 21:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39F0D2087D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 21:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbgKEVw1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 16:52:27 -0500
Received: from smtp.infotech.no ([82.134.31.41]:34318 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgKEVw1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Nov 2020 16:52:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id CB7F620426C;
        Thu,  5 Nov 2020 22:52:24 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eUVnhS7OG68Z; Thu,  5 Nov 2020 22:52:22 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 0C6E7204248;
        Thu,  5 Nov 2020 22:52:20 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, bostroesser@gmail.com,
        bvanassche@acm.org, ddiss@suse.de
Subject: [PATCH v4 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free() warning
Date:   Thu,  5 Nov 2020 16:52:13 -0500
Message-Id: <20201105215216.23304-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201105215216.23304-1-dgilbert@interlog.com>
References: <20201105215216.23304-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a check done by sgl_alloc_order() before it starts
any allocations. The comment in the original said: "Check for integer
overflow" but the check itself contained an integer overflow! The
right hand side (rhs) of the expression in the condition is resolved
as u32 so it could not exceed UINT32_MAX (4 GiB) which means 'length'
could not exceed that value. If that was the intention then the
comment above it could be dropped and the condition rewritten more
clearly as:
     if (length > UINT32_MAX) <<failure path >>;

Get around the integer overflow problem in the rhs of the original
check by taking ilog2() of both sides.

This function may be used to replace vmalloc(unsigned long) for a
large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
it seems unreasonable that:
    sgl_alloc_order(unsigned long long length, ....)
does. sgl_s made with sgl_alloc_order() have equally sized segments
placed in a scatter gather array. That allows O(1) navigation around
a big sgl using some simple integer arithmetic.

Revise some of this function's description to more accurately reflect
what this function is doing.

An earlier patch fixed a memory leak in sg_alloc_order() due to the
misuse of sgl_free(). Take the opportunity to put a one line comment
above sgl_free()'s declaration warning that it is not suitable when
order > 0 .

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  1 +
 lib/scatterlist.c           | 14 ++++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 36c47e7e66a2..d9443ebd0a8e 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -308,6 +308,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
 			      unsigned int *nent_p);
 void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
 void sgl_free_order(struct scatterlist *sgl, int order);
+/* Only use sgl_free() when order is 0 */
 void sgl_free(struct scatterlist *sgl);
 #endif /* CONFIG_SGL_ALLOC */
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a59778946404..4986545beef9 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -554,13 +554,15 @@ EXPORT_SYMBOL(sg_alloc_table_from_pages);
 #ifdef CONFIG_SGL_ALLOC
 
 /**
- * sgl_alloc_order - allocate a scatterlist and its pages
+ * sgl_alloc_order - allocate a scatterlist with equally sized elements
  * @length: Length in bytes of the scatterlist. Must be at least one
- * @order: Second argument for alloc_pages()
+ * @order: Second argument for alloc_pages(). Each sgl element size will
+ *	   be (PAGE_SIZE*2^order) bytes
  * @chainable: Whether or not to allocate an extra element in the scatterlist
- *	for scatterlist chaining purposes
+ *	       for scatterlist chaining purposes
  * @gfp: Memory allocation flags
- * @nent_p: [out] Number of entries in the scatterlist that have pages
+ * @nent_p: [out] Number of entries in the scatterlist that have pages.
+ *		  Ignored if NULL is given.
  *
  * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
  */
@@ -574,8 +576,8 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 	u32 elem_len;
 
 	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
-	/* Check for integer overflow */
-	if (length > (nent << (PAGE_SHIFT + order)))
+	/* Integer overflow if:  length > nent*2^(PAGE_SHIFT+order) */
+	if (ilog2(length) > ilog2(nent) + PAGE_SHIFT + order)
 		return NULL;
 	nalloc = nent;
 	if (chainable) {
-- 
2.25.1

