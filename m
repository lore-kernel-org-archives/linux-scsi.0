From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 30/41] gfs2: replace barriers with explicit flush
	/ FUA usage
Date: Fri,  3 Sep 2010 12:29:45 +0200
Message-ID: <1283509796-1510-31-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes, remove the EOPNOTSUPP
detection for barriers and stop setting the barrier flag for discards.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/gfs2/log.c  |   19 +++++--------------
 fs/gfs2/rgrp.c |    5 ++---
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index cde1248..9c65170 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -592,22 +592,13 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	lh->lh_hash = cpu_to_be32(hash);
 
 	bh->b_end_io = end_buffer_write_sync;
-	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		goto skip_barrier;
 	get_bh(bh);
-	submit_bh(WRITE_BARRIER | REQ_META, bh);
-	wait_on_buffer(bh);
-	if (buffer_eopnotsupp(bh)) {
-		clear_buffer_eopnotsupp(bh);
-		set_buffer_uptodate(bh);
-		fs_info(sdp, "barrier sync failed - disabling barriers\n");
-		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
-		lock_buffer(bh);
-skip_barrier:
-		get_bh(bh);
+	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
 		submit_bh(WRITE_SYNC | REQ_META, bh);
-		wait_on_buffer(bh);
-	}
+	else
+		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
+	wait_on_buffer(bh);
+
 	if (!buffer_uptodate(bh))
 		gfs2_io_error_bh(sdp, bh);
 	brelse(bh);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 171a744..3793164 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -854,8 +854,7 @@ static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				if ((start + nr_sects) != blk) {
 					rv = blkdev_issue_discard(bdev, start,
 							    nr_sects, GFP_NOFS,
-							    BLKDEV_IFL_WAIT |
-							    BLKDEV_IFL_BARRIER);
+							    BLKDEV_IFL_WAIT);
 					if (rv)
 						goto fail;
 					nr_sects = 0;
@@ -870,7 +869,7 @@ start_new_extent:
 	}
 	if (nr_sects) {
 		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS,
-					 BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+					 BLKDEV_IFL_WAIT);
 		if (rv)
 			goto fail;
 	}
-- 
1.7.1
