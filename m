From: mchristi@redhat.com
Subject: [PATCH 07/45] bcache: use op_is_write instead of checking for
	REQ_WRITE
Date: Sun,  5 Jun 2016 14:31:47 -0500
Message-ID: <1465155145-10812-8-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

We currently set REQ_WRITE/WRITE for all non READ IOs
like discard, flush, writesame, etc. In the next patches where we
no longer set up the op as a bitmap, we will not be able to
detect a operation direction like writesame by testing if REQ_WRITE is
set.

This has bcache use the op_is_write helper which will do the right
thing.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/bcache/io.c      | 2 +-
 drivers/md/bcache/request.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 86a0bb8..fd885cc 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -111,7 +111,7 @@ void bch_bbio_count_io_errors(struct cache_set *c, struct bio *bio,
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct cache *ca = PTR_CACHE(c, &b->key, 0);
 
-	unsigned threshold = bio->bi_rw & REQ_WRITE
+	unsigned threshold = op_is_write(bio_op(bio))
 		? c->congested_write_threshold_us
 		: c->congested_read_threshold_us;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 25fa844..6b85a23 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -383,7 +383,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (mode == CACHE_MODE_NONE ||
 	    (mode == CACHE_MODE_WRITEAROUND &&
-	     (bio->bi_rw & REQ_WRITE)))
+	     op_is_write(bio_op(bio))))
 		goto skip;
 
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
@@ -404,7 +404,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (!congested &&
 	    mode == CACHE_MODE_WRITEBACK &&
-	    (bio->bi_rw & REQ_WRITE) &&
+	    op_is_write(bio_op(bio)) &&
 	    (bio->bi_rw & REQ_SYNC))
 		goto rescale;
 
@@ -657,7 +657,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->cache_miss		= NULL;
 	s->d			= d;
 	s->recoverable		= 1;
-	s->write		= (bio->bi_rw & REQ_WRITE) != 0;
+	s->write		= op_is_write(bio_op(bio));
 	s->read_dirty_data	= 0;
 	s->start_time		= jiffies;
 
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
