From: mchristi@redhat.com
Subject: [PATCH 26/42] block: copy bio op to request op
Date: Wed, 13 Apr 2016 14:36:12 -0500
Message-ID: <1460576188-5751-27-git-send-email-mchristi@redhat.com>
References: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

The bio users should now always be setting up the bio->bi_op. This patch
has us copy that to the struct request op field.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6bcc22e..4224775 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2990,6 +2990,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 {
 	/* tmp compat. Allow users to set bi_op or bi_rw */
 	rq->cmd_flags |= bio_data_dir(bio);
+	rq->op = bio->bi_op;
 
 	if (bio_has_data(bio))
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
@@ -3074,6 +3075,7 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
+	dst->op = src->op;
 	dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
-- 
2.7.2
