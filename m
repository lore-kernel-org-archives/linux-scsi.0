From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/18] block: don't assign cmd_flags in __blk_rq_prep_clone
Date: Wed, 25 Jan 2017 18:25:26 +0100
Message-ID: <1485365126-23210-19-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

These days we have the proper flags set since request allocation time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 33c5d05e..6bf5ba0 100644
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

