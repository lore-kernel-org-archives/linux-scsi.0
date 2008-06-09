From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: add bounce support to blk_rq_map_user_iov
Date: Mon, 9 Jun 2008 16:13:52 +0900
Message-ID: <20080609161728C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39242 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYFIHO4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2008 03:14:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

blk_rq_map_user_iov can't handle the bounce buffer (it means that the
bio_map_user_iov path doesn't work with a LLD that needs GFP_DMA).

This patch fixes blk_rq_map_user_iov to support the bounce buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0b1af5a..813011e 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -210,6 +210,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
 		rq->cmd_flags |= REQ_COPY_USER;
 
+	blk_queue_bounce(q, &bio);
 	bio_get(bio);
 	blk_rq_bio_prep(q, rq, bio);
 	rq->buffer = rq->data = NULL;
-- 
1.5.5.GIT

