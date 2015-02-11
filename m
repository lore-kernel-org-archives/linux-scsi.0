From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] blk-mq: fix double-free in error path
Date: Wed, 11 Feb 2015 11:32:30 -0500
Message-ID: <54DB841E.6030108@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:61860 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbbBKQcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2015 11:32:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org

If the allocation of bt->bs fails, then bt->map can be freed twice, once
in blk_mq_init_bitmap_tags() -> bt_alloc(), and once in
blk_mq_init_bitmap_tags() -> bt_free().  Fix by setting the pointer to
NULL after the first free.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in kernel 3.20.

--- linux-3.19.0/block/blk-mq-tag.c.orig	2015-02-08 21:54:22.000000000 -0500
+++ linux-3.19.0/block/blk-mq-tag.c	2015-02-10 09:42:38.000000000 -0500
@@ -509,6 +509,7 @@ static int bt_alloc(struct blk_mq_bitmap
 	bt->bs = kzalloc(BT_WAIT_QUEUES * sizeof(*bt->bs), GFP_KERNEL);
 	if (!bt->bs) {
 		kfree(bt->map);
+		bt->map = NULL;
 		return -ENOMEM;
 	}
 

