Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84EFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE3661BFE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhKQGRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhKQGR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5582C061206;
        Tue, 16 Nov 2021 22:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=viN/M0s94isJpAI9XG+tAyGwzk5B+gYmCJUD6Ta5toY=; b=DmCyOSBxb/zzr/09ETedwRIi2e
        wWu/BkxWyRBfumSegeofjM4bpJqi0m9vEI6i0xBOuwI9Gwh9MMNARP0J1F9Vi9I05uDZZCDVSr+W7
        v9lYzYgc/g9CT+TAXDZrBx3TfrOM9xdGQVNfZ5UL98rTwqUPY69IfH0kbS2cMcJum/4sAFZCyejEl
        Ld9+aLsy/l6DJB7tm7Tuw0xxCu6mDG81/dFRT8+GIjorxEdkJ7tDF6hlJWRn+vUKnOlAoGTIyotui
        COsMsboULPAegSzeAsB1bqpm86SsCfyVxLTBY193JUQFR0jleXGT9xRyU2za1UJ6jIBPeHLvLrHJd
        qU0PwygQ==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnED9-007MHU-OQ; Wed, 17 Nov 2021 06:14:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 11/11] block: don't include blk-mq headers in blk-core.c
Date:   Wed, 17 Nov 2021 07:14:04 +0100
Message-Id: <20211117061404.331732-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All request based code is in the blk-mq files now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5722c1d9da09c..ee54b34d5e99c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/blk-mq.h>
 #include <linux/blk-pm.h>
 #include <linux/blk-integrity.h>
 #include <linux/highmem.h>
@@ -47,8 +46,6 @@
 #include <trace/events/block.h>
 
 #include "blk.h"
-#include "blk-mq.h"
-#include "blk-mq-sched.h"
 #include "blk-pm.h"
 #include "blk-throttle.h"
 
-- 
2.30.2

