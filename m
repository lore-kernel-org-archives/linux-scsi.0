Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71716C43467
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 17:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4869A2222B
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 17:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgJRRNt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 13:13:49 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52020 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgJRRNt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 13:13:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 849A220425B;
        Sun, 18 Oct 2020 19:13:46 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P5SUJaaRNZ+X; Sun, 18 Oct 2020 19:13:43 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 8AB1520424C;
        Sun, 18 Oct 2020 19:13:41 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org,
        bostroesser@gmail.com
Subject: [PATCH v2 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free() warning
Date:   Sun, 18 Oct 2020 13:13:33 -0400
Message-Id: <20201018171336.63839-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018171336.63839-1-dgilbert@interlog.com>
References: <20201018171336.63839-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes a check done by sgl_alloc_order() before it starts
any allocations. The comment before the removed code says: "Check for
integer overflow" arguably gives a false sense of security. The right
hand side of the expression in the condition is resolved as u32 so
cannot exceed UINT32_MAX (4 GiB) which means 'length' cannot exceed
that amount. If that was the intention then the comment above it
could be dropped and the condition rewritten more clearly as:
     if (length > UINT32_MAX) <<failure path >>;

The author's intention is to use sgl_alloc_order() to replace
vmalloc(unsigned long) for a large allocation (debug ramdisk).
vmalloc has no limit at 4 GiB so its seems unreasonable that:
    sgl_alloc_order(unsigned long long length, ....)
does. sgl_s made with sgl_alloc_order(chainable=false) have equally
sized segments placed in a scatter gather array. That allows O(1)
navigation around a big sgl using some simple integer maths.

Having previously sent a patch to fix a memory leak in
sg_alloc_order() take the opportunity to put a one line comment above
sgl_free()'s declaration that it is not suitable when order > 0 . The
mis-use of sgl_free() when order > 0 was the reason for the memory
leak. The other users of sgl_alloc_order() in the kernel where
checked and found to handle free-ing properly.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h | 1 +
 lib/scatterlist.c           | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 45cf7b69d852..80178afc2a4a 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -302,6 +302,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
 			      unsigned int *nent_p);
 void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
 void sgl_free_order(struct scatterlist *sgl, int order);
+/* Only use sgl_free() when order is 0 */
 void sgl_free(struct scatterlist *sgl);
 #endif /* CONFIG_SGL_ALLOC */
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c448642e0f78..d5770e7f1030 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -493,9 +493,6 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 	u32 elem_len;
 
 	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
-	/* Check for integer overflow */
-	if (length > (nent << (PAGE_SHIFT + order)))
-		return NULL;
 	nalloc = nent;
 	if (chainable) {
 		/* Check for integer overflow */
-- 
2.25.1

