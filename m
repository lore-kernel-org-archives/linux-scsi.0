From: mchristi@redhat.com
Subject: [PATCH 20/42] dm: pass dm stats data dir instead of
	bi_rw
Date: Wed, 13 Apr 2016 14:36:06 -0500
Message-ID: <1460576188-5751-21-git-send-email-mchristi@redhat.com>
References: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

It looks like dm stats cares about the data direction
(READ vs WRITE) and does not need the bio/request flags.
Commands like REQ_FLUSH, REQ_DISCARD and REQ_WRITE_SAME
are currently always set with REQ_WRITE, so the extra check for
REQ_DISCARD in dm_stats_account_io is not needed.

This patch has it use the bio and request data_dir helpers
instead of accessing the bi_rw/cmd_flags directly. This makes
the next patches that remove the operation from the cmd_flags
and bi_rw easier, because we will no longer have the REQ_WRITE
bit set for operations like discards.

This patch is compile tested only.

v2:

1. Merged Mike Snitzer's fixes to pass in int instead of
unsigned long.

2. Fix 80 char col issues.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-stats.c |  9 ++++-----
 drivers/md/dm.c       | 21 ++++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 8289804..4fba26c 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -514,11 +514,10 @@ static void dm_stat_round(struct dm_stat *s, struct dm_stat_shared *shared,
 }
 
 static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
-			      unsigned long bi_rw, sector_t len,
+			      int idx, sector_t len,
 			      struct dm_stats_aux *stats_aux, bool end,
 			      unsigned long duration_jiffies)
 {
-	unsigned long idx = bi_rw & REQ_WRITE;
 	struct dm_stat_shared *shared = &s->stat_shared[entry];
 	struct dm_stat_percpu *p;
 
@@ -584,7 +583,7 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 #endif
 }
 
-static void __dm_stat_bio(struct dm_stat *s, unsigned long bi_rw,
+static void __dm_stat_bio(struct dm_stat *s, int bi_rw,
 			  sector_t bi_sector, sector_t end_sector,
 			  bool end, unsigned long duration_jiffies,
 			  struct dm_stats_aux *stats_aux)
@@ -645,8 +644,8 @@ void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
 			(bi_sector == (ACCESS_ONCE(last->last_sector) &&
-				       ((bi_rw & (REQ_WRITE | REQ_DISCARD)) ==
-					(ACCESS_ONCE(last->last_rw) & (REQ_WRITE | REQ_DISCARD)))
+				       ((bi_rw == WRITE) ==
+					(ACCESS_ONCE(last->last_rw) == WRITE))
 				       ));
 		ACCESS_ONCE(last->last_sector) = end_sector;
 		ACCESS_ONCE(last->last_rw) = bi_rw;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5432da7..98fea0e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -723,8 +723,9 @@ static void start_io_acct(struct dm_io *io)
 		atomic_inc_return(&md->pending[rw]));
 
 	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_iter.bi_sector,
-				    bio_sectors(bio), false, 0, &io->stats_aux);
+		dm_stats_account_io(&md->stats, bio_data_dir(bio),
+				    bio->bi_iter.bi_sector, bio_sectors(bio),
+				    false, 0, &io->stats_aux);
 }
 
 static void end_io_acct(struct dm_io *io)
@@ -738,8 +739,9 @@ static void end_io_acct(struct dm_io *io)
 	generic_end_io_acct(rw, &dm_disk(md)->part0, io->start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_iter.bi_sector,
-				    bio_sectors(bio), true, duration, &io->stats_aux);
+		dm_stats_account_io(&md->stats, bio_data_dir(bio),
+				    bio->bi_iter.bi_sector, bio_sectors(bio),
+				    true, duration, &io->stats_aux);
 
 	/*
 	 * After this is decremented the bio must not be touched if it is
@@ -1121,9 +1123,9 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
 	if (unlikely(dm_stats_used(&md->stats))) {
 		struct dm_rq_target_io *tio = tio_from_request(orig);
 		tio->duration_jiffies = jiffies - tio->duration_jiffies;
-		dm_stats_account_io(&md->stats, orig->cmd_flags, blk_rq_pos(orig),
-				    tio->n_sectors, true, tio->duration_jiffies,
-				    &tio->stats_aux);
+		dm_stats_account_io(&md->stats, rq_data_dir(orig),
+				    blk_rq_pos(orig), tio->n_sectors, true,
+				    tio->duration_jiffies, &tio->stats_aux);
 	}
 }
 
@@ -2082,8 +2084,9 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 		struct dm_rq_target_io *tio = tio_from_request(orig);
 		tio->duration_jiffies = jiffies;
 		tio->n_sectors = blk_rq_sectors(orig);
-		dm_stats_account_io(&md->stats, orig->cmd_flags, blk_rq_pos(orig),
-				    tio->n_sectors, false, 0, &tio->stats_aux);
+		dm_stats_account_io(&md->stats, rq_data_dir(orig),
+				    blk_rq_pos(orig), tio->n_sectors, false, 0,
+				    &tio->stats_aux);
 	}
 
 	/*
-- 
2.7.2
