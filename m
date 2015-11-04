From: mchristi@redhat.com
Subject: [PATCH 24/32] dm: pass dm stats data dir instead of bi_rw
Date: Wed,  4 Nov 2015 16:08:21 -0600
Message-ID: <1446674909-5371-25-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

It looks like dm stats primarily cares about the data direction
(READ vs WRITE) and does not need the bio/request flags
and in the future operation value. REQ_DISCARD is always set with
REQ_WRITE, so the check for either one in dm_stats_account_io
is not needed.

This patch has it use the bio and request data_dir helpers
instead of accessing the bi_rw/cmd_flags directly. This makes
the next patches that remove the operation from the cmd_flags
and bi_rw cleaner since we do not have to check for multiple
operations.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/dm-stats.c | 6 +++---
 drivers/md/dm.c       | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 8289804..96b5c1b 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -518,7 +518,7 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 			      struct dm_stats_aux *stats_aux, bool end,
 			      unsigned long duration_jiffies)
 {
-	unsigned long idx = bi_rw & REQ_WRITE;
+	unsigned long idx = bi_rw;
 	struct dm_stat_shared *shared = &s->stat_shared[entry];
 	struct dm_stat_percpu *p;
 
@@ -645,8 +645,8 @@ void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
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
index d2cf6d9..ea4bc70 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -655,7 +655,7 @@ static void start_io_acct(struct dm_io *io)
 		atomic_inc_return(&md->pending[rw]));
 
 	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_iter.bi_sector,
+		dm_stats_account_io(&md->stats, bio_data_dir(bio), bio->bi_iter.bi_sector,
 				    bio_sectors(bio), false, 0, &io->stats_aux);
 }
 
@@ -670,7 +670,7 @@ static void end_io_acct(struct dm_io *io)
 	generic_end_io_acct(rw, &dm_disk(md)->part0, io->start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_iter.bi_sector,
+		dm_stats_account_io(&md->stats, bio_data_dir(bio), bio->bi_iter.bi_sector,
 				    bio_sectors(bio), true, duration, &io->stats_aux);
 
 	/*
@@ -1053,7 +1053,7 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
 	if (unlikely(dm_stats_used(&md->stats))) {
 		struct dm_rq_target_io *tio = tio_from_request(orig);
 		tio->duration_jiffies = jiffies - tio->duration_jiffies;
-		dm_stats_account_io(&md->stats, orig->cmd_flags, blk_rq_pos(orig),
+		dm_stats_account_io(&md->stats, rq_data_dir(orig), blk_rq_pos(orig),
 				    tio->n_sectors, true, tio->duration_jiffies,
 				    &tio->stats_aux);
 	}
@@ -1988,7 +1988,7 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 		struct dm_rq_target_io *tio = tio_from_request(orig);
 		tio->duration_jiffies = jiffies;
 		tio->n_sectors = blk_rq_sectors(orig);
-		dm_stats_account_io(&md->stats, orig->cmd_flags, blk_rq_pos(orig),
+		dm_stats_account_io(&md->stats, rq_data_dir(orig), blk_rq_pos(orig),
 				    tio->n_sectors, false, 0, &tio->stats_aux);
 	}
 
-- 
1.8.3.1
