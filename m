From: mchristi@redhat.com
Subject: [PATCH 17/35] ocfs2: set bi_op to REQ_OP
Date: Tue,  5 Jan 2016 14:53:20 -0600
Message-ID: <1452027218-32303-18-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch has ocfs2 set the bio bi_op to a REQ_OP, and
rq_flag_bits to bi_rw.

This patch is compile tested only.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/ocfs2/cluster/heartbeat.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 41039c2..38596aa 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -391,7 +391,8 @@ static void o2hb_bio_end_io(struct bio *bio)
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 				      struct o2hb_bio_wait_ctxt *wc,
 				      unsigned int *current_slot,
-				      unsigned int max_slots, int rw)
+				      unsigned int max_slots, int op,
+				      int op_flags)
 {
 	int len, current_page;
 	unsigned int vec_len, vec_start;
@@ -417,7 +418,8 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
-	bio->bi_rw |= rw;
+	bio->bi_op = op;
+	bio->bi_rw |= op_flags;
 
 	vec_start = (cs << bits) % PAGE_CACHE_SIZE;
 	while(cs < max_slots) {
@@ -454,7 +456,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 
 	while(current_slot < max_slots) {
 		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
-					 READ);
+					 REQ_OP_READ, 0);
 		if (IS_ERR(bio)) {
 			status = PTR_ERR(bio);
 			mlog_errno(status);
@@ -486,7 +488,8 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 
 	slot = o2nm_this_node();
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, WRITE_SYNC);
+	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, REQ_OP_WRITE,
+				 WRITE_SYNC);
 	if (IS_ERR(bio)) {
 		status = PTR_ERR(bio);
 		mlog_errno(status);
-- 
1.8.3.1
