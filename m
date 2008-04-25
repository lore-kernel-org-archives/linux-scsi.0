From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/6] block: add large command support
Date: Sat, 26 Apr 2008 01:23:19 +0900
Message-ID: <1209140607-28654-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:32992 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761548AbYDYQaq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:30:46 -0400
In-Reply-To: <1209140607-28654-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org, bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>

This patch changes rq->cmd from the static array to a pointer to
support large commands.

We rarely handle large commands. So for optimization, a struct request
still has a static array for a command. rq_init sets rq->cmd pointer
to the static array.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |    1 +
 include/linux/blkdev.h |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a89adcc..35ae1c0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -117,6 +117,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->sector = rq->hard_sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
+	rq->cmd = rq->__cmd;
 	rq->tag = -1;
 	rq->ref_count = 1;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d17032c..08df1ea 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -215,8 +215,9 @@ struct request {
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	unsigned short cmd_len;
+	unsigned char __cmd[BLK_MAX_CDB];
+	unsigned char *cmd;
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
-- 
1.5.4.2

