From: mchristi@redhat.com
Subject: [PATCH 21/45] ocfs2: use bio op accessors
Date: Sun,  5 Jun 2016 14:32:01 -0500
Message-ID: <1465155145-10812-22-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

Separate the op from the rq_flag_bits and have ocfs2
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/ocfs2/cluster/heartbeat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8b1d86e..636abcb 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -530,7 +530,8 @@ static void o2hb_bio_end_io(struct bio *bio)
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 				      struct o2hb_bio_wait_ctxt *wc,
 				      unsigned int *current_slot,
-				      unsigned int max_slots, int rw)
+				      unsigned int max_slots, int op,
+				      int op_flags)
 {
 	int len, current_page;
 	unsigned int vec_len, vec_start;
@@ -556,7 +557,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
-	bio->bi_rw = rw;
+	bio_set_op_attrs(bio, op, op_flags);
 
 	vec_start = (cs << bits) % PAGE_SIZE;
 	while(cs < max_slots) {
@@ -593,7 +594,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 
 	while(current_slot < max_slots) {
 		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
-					 READ);
+					 REQ_OP_READ, 0);
 		if (IS_ERR(bio)) {
 			status = PTR_ERR(bio);
 			mlog_errno(status);
@@ -625,7 +626,8 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 
 	slot = o2nm_this_node();
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, WRITE_SYNC);
+	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, REQ_OP_WRITE,
+				 WRITE_SYNC);
 	if (IS_ERR(bio)) {
 		status = PTR_ERR(bio);
 		mlog_errno(status);
-- 
2.7.2
