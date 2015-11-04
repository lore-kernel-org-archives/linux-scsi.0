From: mchristi@redhat.com
Subject: [PATCH 27/32] cfq/cgroup: pass operation and flags
	seperately
Date: Wed,  4 Nov 2015 16:08:24 -0600
Message-ID: <1446674909-5371-28-git-send-email-mchristi@redhat.com>
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

The operation is about to be separated from the flags, so this
patch has users pass them in separately to the cgroup stats.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/cfq-iosched.c        | 49 +++++++++++++++++++++++++++-------------------
 include/linux/blk-cgroup.h | 13 ++++++------
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 04de884..dbc3da4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -660,9 +660,10 @@ static inline void cfqg_put(struct cfq_group *cfqg)
 } while (0)
 
 static inline void cfqg_stats_update_io_add(struct cfq_group *cfqg,
-					    struct cfq_group *curr_cfqg, int rw)
+					    struct cfq_group *curr_cfqg, int op,
+					    int op_flags)
 {
-	blkg_rwstat_add(&cfqg->stats.queued, rw, 1);
+	blkg_rwstat_add(&cfqg->stats.queued, op, op_flags, 1);
 	cfqg_stats_end_empty_time(&cfqg->stats);
 	cfqg_stats_set_start_group_wait_time(cfqg, curr_cfqg);
 }
@@ -676,26 +677,30 @@ static inline void cfqg_stats_update_timeslice_used(struct cfq_group *cfqg,
 #endif
 }
 
-static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int rw)
+static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int op,
+					       int op_flags)
 {
-	blkg_rwstat_add(&cfqg->stats.queued, rw, -1);
+	blkg_rwstat_add(&cfqg->stats.queued, op, op_flags, -1);
 }
 
-static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int rw)
+static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int op,
+					       int op_flags)
 {
-	blkg_rwstat_add(&cfqg->stats.merged, rw, 1);
+	blkg_rwstat_add(&cfqg->stats.merged, op, op_flags, 1);
 }
 
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
-			uint64_t start_time, uint64_t io_start_time, int rw)
+			uint64_t start_time, uint64_t io_start_time, int op,
+			int op_flags)
 {
 	struct cfqg_stats *stats = &cfqg->stats;
 	unsigned long long now = sched_clock();
 
 	if (time_after64(now, io_start_time))
-		blkg_rwstat_add(&stats->service_time, rw, now - io_start_time);
+		blkg_rwstat_add(&stats->service_time, op, op_flags,
+				now - io_start_time);
 	if (time_after64(io_start_time, start_time))
-		blkg_rwstat_add(&stats->wait_time, rw,
+		blkg_rwstat_add(&stats->wait_time, op, op_flags,
 				io_start_time - start_time);
 }
 
@@ -769,13 +774,16 @@ static inline void cfqg_put(struct cfq_group *cfqg) { }
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 
 static inline void cfqg_stats_update_io_add(struct cfq_group *cfqg,
-			struct cfq_group *curr_cfqg, int rw) { }
+			struct cfq_group *curr_cfqg, int op, int op_flags) { }
 static inline void cfqg_stats_update_timeslice_used(struct cfq_group *cfqg,
 			unsigned long time, unsigned long unaccounted_time) { }
-static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int rw) { }
-static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int rw) { }
+static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int op,
+			int op_flags) { }
+static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int op,
+			int op_flags) { }
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
-			uint64_t start_time, uint64_t io_start_time, int rw) { }
+			uint64_t start_time, uint64_t io_start_time, int op,
+			int op_flags) { }
 
 #endif	/* CONFIG_CFQ_GROUP_IOSCHED */
 
@@ -2449,10 +2457,10 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
-	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->cmd_flags);
+	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->op, rq->cmd_flags);
 	cfq_add_rq_rb(rq);
 	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqq->cfqd->serving_group,
-				 rq->cmd_flags);
+				 rq->op, rq->cmd_flags);
 }
 
 static struct request *
@@ -2505,7 +2513,7 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
-	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->cmd_flags);
+	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->op, rq->cmd_flags);
 	if (rq->cmd_flags & REQ_PRIO) {
 		WARN_ON(!cfqq->prio_pending);
 		cfqq->prio_pending--;
@@ -2540,7 +2548,7 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
-	cfqg_stats_update_io_merged(RQ_CFQG(req), bio->bi_rw);
+	cfqg_stats_update_io_merged(RQ_CFQG(req), bio->bi_op, bio->bi_rw);
 }
 
 static void
@@ -2563,7 +2571,7 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
-	cfqg_stats_update_io_merged(RQ_CFQG(rq), next->cmd_flags);
+	cfqg_stats_update_io_merged(RQ_CFQG(rq), next->op, next->cmd_flags);
 
 	cfqq = RQ_CFQQ(next);
 	/*
@@ -4085,7 +4093,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	rq->fifo_time = jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)];
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
-	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
+	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group, rq->op,
 				 rq->cmd_flags);
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
@@ -4183,7 +4191,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqq->dispatched--;
 	(RQ_CFQG(rq))->dispatched--;
 	cfqg_stats_update_completion(cfqq->cfqg, rq_start_time_ns(rq),
-				     rq_io_start_time_ns(rq), rq->cmd_flags);
+				     rq_io_start_time_ns(rq), rq->op,
+				     rq->cmd_flags);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c02e669..0b230b9 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -590,25 +590,26 @@ static inline void blkg_rwstat_exit(struct blkg_rwstat *rwstat)
 /**
  * blkg_rwstat_add - add a value to a blkg_rwstat
  * @rwstat: target blkg_rwstat
- * @rw: mask of REQ_{WRITE|SYNC}
+ * @op: REQ_OP
+ * @op_flags: rq_flag_bits
  * @val: value to add
  *
  * Add @val to @rwstat.  The counters are chosen according to @rw.  The
  * caller is responsible for synchronizing calls to this function.
  */
 static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
-				   int rw, uint64_t val)
+				   int op, int op_flags, uint64_t val)
 {
 	struct percpu_counter *cnt;
 
-	if (rw & REQ_WRITE)
+	if (op_to_data_dir(op))
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_WRITE];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_READ];
 
 	__percpu_counter_add(cnt, val, BLKG_STAT_CPU_BATCH);
 
-	if (rw & REQ_SYNC)
+	if (op_flags & REQ_SYNC)
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_SYNC];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_ASYNC];
@@ -713,9 +714,9 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 
 	if (!throtl) {
 		blkg = blkg ?: q->root_blkg;
-		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_rw,
+		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_op, bio->bi_rw,
 				bio->bi_iter.bi_size);
-		blkg_rwstat_add(&blkg->stat_ios, bio->bi_rw, 1);
+		blkg_rwstat_add(&blkg->stat_ios, bio->bi_op, bio->bi_rw, 1);
 	}
 
 	rcu_read_unlock();
-- 
1.8.3.1
