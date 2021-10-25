Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268D7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 102DC60F9C
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhJYHIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhJYHIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:08:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CFCC061745;
        Mon, 25 Oct 2021 00:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=AXC2/w3YpyqIN7KuSnBwUBGLzmoGyNL2SawuN6uJg2o=; b=Fcvpi2fbBxgA1O9ZuEjAuspcvv
        Vc7KCr1eDyXod3ZEXx2yT9hB0Wh8pPajD6gc8n5x+HjJ+d23fiOz2Y3Qjbu+7b7BhKUScBGknRS5l
        p/TNnlsHWAltZaL+ubYlUFX3+CidCJNzTtuHCskE12MWRYQM2eptbD7wAamrf7jGFIq6d7n7EkMAi
        FqbGQhF05alfAvU83NjPjRgURtmokV6oJBBNF0R3fWMizX2tCBvFVQvg8mOqV250xBJQJVnlATUiw
        Fh/quqHfbS7VqxfN3iuPn3oSE4YQDW71HooDKtRoTibLZxMjZKeuZvFUpfgvltCpMI2305HXG/dpb
        hAHZnQQQ==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu3K-00FUaP-HR; Mon, 25 Oct 2021 07:05:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 12/12] block: don't include blk-mq headers in blk-core.c
Date:   Mon, 25 Oct 2021 09:05:17 +0200
Message-Id: <20211025070517.1548584-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All request based code is in the blk-mq files now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ebcea0dac973d..94b76d62a4396 100644
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

