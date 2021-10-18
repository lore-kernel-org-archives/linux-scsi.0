Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83927C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E31260FDA
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhJRGKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 02:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhJRGKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 02:10:17 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E837C06161C
        for <linux-scsi@vger.kernel.org>; Sun, 17 Oct 2021 23:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=vKRYhom35mbaBUGnKqiRIJxSGEvWvhjNp+91d9uB0NA=; b=N+rlisNmiH53fcAudqtrivF6a0
        n/OFcdbQNXcbNMNPdhE2yc4rQgP9QtDYMbhwyC0OcJFZjEXXsdwveyy62nCMfn0qLHS9WLJWtuvEs
        CSawz3vDIL3pf6/6JRjAMkzwZKzu/OM+U9kdqW3ZldOIrHdRC+KdEei0FxsQitgGLMOyCD8BilWqF
        sFwCvgk+n/1chNOzGnNjznWCltbgQgC+mqRZM95e0JMLpzkB+aAN3APWW+08kUOfNzEA27JZnQxeX
        UZLttXOXNBDQMO4Pki+RrmwLpY39JWaxRHQ6gDJ44rYKD3ZUu8cSIvUaMLJKp1k4Ud5lXRSm9BNBR
        uiRixurQ==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcLoc-00EHfh-8H; Mon, 18 Oct 2021 06:08:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] aha1542: use memcpy_{from,to}_bvec
Date:   Mon, 18 Oct 2021 08:08:02 +0200
Message-Id: <20211018060802.1815982-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the memcpy_{from,to}_bvec helpers instead of open coding them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aha1542.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 584a59522038b..07efdad1ae378 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -268,8 +268,7 @@ static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 		struct bio_vec bv;
 
 		rq_for_each_segment(bv, rq, iter) {
-			memcpy_to_page(bv.bv_page, bv.bv_offset, buf,
-				       bv.bv_len);
+			memcpy_to_bvec(&bv, buf);
 			buf += bv.bv_len;
 		}
 	}
@@ -454,8 +453,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		struct bio_vec bv;
 
 		rq_for_each_segment(bv, rq, iter) {
-			memcpy_from_page(buf, bv.bv_page, bv.bv_offset,
-					 bv.bv_len);
+			memcpy_from_bvec(buf, &bv);
 			buf += bv.bv_len;
 		}
 	}
-- 
2.30.2

