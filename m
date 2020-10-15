Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16E6C43457
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 18:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD56218AC
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 18:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391273AbgJOS5o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:57:44 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43262 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391266AbgJOS5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Oct 2020 14:57:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1F60A204238;
        Thu, 15 Oct 2020 20:57:41 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j+hTVM7Rc0O6; Thu, 15 Oct 2020 20:57:39 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 4EC58204193;
        Thu, 15 Oct 2020 20:57:38 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
Subject: [RESEND PATCH] sgl_alloc_order: fix memory leak
Date:   Thu, 15 Oct 2020 14:57:35 -0400
Message-Id: <20201015185735.5480-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sgl_alloc_order() can fail when 'length' is large on a memory
constrained system. When order > 0 it will potentially be
making several multi-page allocations with the later ones more
likely to fail than the earlier one. So it is important that
sgl_alloc_order() frees up any pages it has obtained before
returning NULL. In the case when order > 0 it calls the wrong
free page function and leaks. In testing the leak was
sufficient to bring down my 8 GiB laptop with OOM.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 5d63a8857f36..c448642e0f78 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -514,7 +514,7 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 		elem_len = min_t(u64, length, PAGE_SIZE << order);
 		page = alloc_pages(gfp, order);
 		if (!page) {
-			sgl_free(sgl);
+			sgl_free_order(sgl, order);
 			return NULL;
 		}
 
-- 
2.25.1

