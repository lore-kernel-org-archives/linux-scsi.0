From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.14 RFC PATCH 1/2] dm rq: avoid deadlock if dm-mq is stacked on old .request_fn device(s)
Date: Thu, 13 Jul 2017 17:12:16 -0400
Message-ID: <20170713211217.52361-2-snitzer@redhat.com>
References: <20170713211217.52361-1-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35528 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdGMVMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2017 17:12:25 -0400
In-Reply-To: <20170713211217.52361-1-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Conditionally use __blk_put_request() or blk_put_request() instead of
just blk_put_request() in multipath_release_clone().

Otherwise a deadlock will occur because scsi_end_request() will take the
clone request's queue_lock, around its call to blk_finish_request(), and
then the later blk_put_request() also tries to take it:

[12749.916332]  queued_spin_lock_slowpath+0xb/0xf
[12749.916335]  _raw_spin_lock_irqsave+0x37/0x40
[12749.916339]  blk_put_request+0x39/0x60
[12749.916342]  multipath_release_clone+0xe/0x10 [dm_multipath]
[12749.916350]  dm_softirq_done+0x156/0x240 [dm_mod]
[12749.916353]  __blk_mq_complete_request+0x90/0x140
[12749.916355]  blk_mq_complete_request+0x16/0x20
[12749.916360]  dm_complete_request+0x23/0x40 [dm_mod]
[12749.916365]  end_clone_request+0x1d/0x20 [dm_mod]
[12749.916367]  blk_finish_request+0x83/0x120
[12749.916370]  scsi_end_request+0x12d/0x1d0
[12749.916371]  scsi_io_completion+0x13c/0x630
[12749.916374]  ? set_next_entity+0x7c/0x780
[12749.916376]  scsi_finish_command+0xd9/0x120
[12749.916378]  scsi_softirq_done+0x12a/0x150
[12749.916380]  blk_done_softirq+0x9e/0xd0
[12749.916382]  __do_softirq+0xc9/0x269
[12749.916384]  run_ksoftirqd+0x29/0x50
[12749.916385]  smpboot_thread_fn+0x110/0x160
[12749.916387]  kthread+0x109/0x140
[12749.916389]  ? sort_range+0x30/0x30
[12749.916390]  ? kthread_park+0x60/0x60
[12749.916391]  ret_from_fork+0x25/0x30

This "fix" is gross in that the long-term fitness of stacking blk-mq DM
multipath (dm-mq) ontop of old .request_fn devices is questionable.  The
above stack trace shows just how ugly it is to have old .request_fn SCSI
code cascade into blk-mq code during DM multipath request completion.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         | 16 ++++++++++++++--
 drivers/md/dm-rq.c            |  8 +++++---
 drivers/md/dm-target.c        |  4 ++--
 include/linux/device-mapper.h |  3 ++-
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0e8ab5b..34cf7b6 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -520,9 +520,21 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_REMAPPED;
 }
 
-static void multipath_release_clone(struct request *clone)
+static void multipath_release_clone(struct dm_target *ti, struct request *clone)
 {
-	blk_put_request(clone);
+	struct multipath *m = ti->private;
+	struct request_queue *q = clone->q;
+
+	if (!q->mq_ops && m->queue_mode == DM_TYPE_MQ_REQUEST_BASED) {
+		/*
+		 * dm-mq on .request_fn already holds clone->q->queue_lock
+		 * via blk_finish_request()...
+		 * - true for .request_fn SCSI, but is it _always_ true?
+		 */
+		lockdep_assert_held(q->queue_lock);
+		__blk_put_request(q, clone);
+	} else
+		blk_put_request(clone);
 }
 
 /*
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c6ebc5b..95bb44c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -220,11 +220,12 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 {
 	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct dm_target *ti = tio->ti;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
 	blk_rq_unprep_clone(clone);
-	tio->ti->type->release_clone_rq(clone);
+	ti->type->release_clone_rq(ti, clone);
 
 	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
@@ -267,6 +268,7 @@ static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
 
 static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_requeue)
 {
+	struct dm_target *ti = tio->ti;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 	int rw = rq_data_dir(rq);
@@ -274,7 +276,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	rq_end_stats(md, rq);
 	if (tio->clone) {
 		blk_rq_unprep_clone(tio->clone);
-		tio->ti->type->release_clone_rq(tio->clone);
+		ti->type->release_clone_rq(ti, tio->clone);
 	}
 
 	if (!rq->q->mq_ops)
@@ -488,7 +490,7 @@ static int map_request(struct dm_rq_target_io *tio)
 	case DM_MAPIO_REMAPPED:
 		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
 			/* -ENOMEM */
-			ti->type->release_clone_rq(clone);
+			ti->type->release_clone_rq(ti, clone);
 			return DM_MAPIO_REQUEUE;
 		}
 
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index c0d7e60..adbd17b 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -138,12 +138,12 @@ static int io_err_clone_and_map_rq(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_KILL;
 }
 
-static void io_err_release_clone_rq(struct request *clone)
+static void io_err_release_clone_rq(struct dm_target *ti, struct request *clone)
 {
 }
 
 static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+				     long nr_pages, void **kaddr, pfn_t *pfn)
 {
 	return -EIO;
 }
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0c1b50ad..f2ca0ab 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -61,7 +61,8 @@ typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
 					    struct request *rq,
 					    union map_info *map_context,
 					    struct request **clone);
-typedef void (*dm_release_clone_request_fn) (struct request *clone);
+typedef void (*dm_release_clone_request_fn) (struct dm_target *ti,
+					     struct request *clone);
 
 /*
  * Returns:
-- 
2.10.1
