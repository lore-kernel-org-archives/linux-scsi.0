From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/16] block: don't assign cmd_flags in __blk_rq_prep_clone
Date: Mon, 23 Jan 2017 16:29:21 +0100
Message-ID: <1485185361-29786-17-git-send-email-hch@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

These days we have the proper flags set since request allocation time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fe5cc98..93a9e0b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2983,7 +2983,6 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
-	dst->cmd_flags = src->cmd_flags | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
-- 
2.1.4

