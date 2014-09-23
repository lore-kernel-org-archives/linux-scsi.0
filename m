From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-3.18/core] blk-mq: start q->mq_usage_counter in
 atomic mode
Date: Tue, 23 Sep 2014 02:08:12 -0400
Message-ID: <20140923060812.GH11740@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140919113815.GA10791@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From 83b06f4fc6ca2f7f3d706a168b71c248bdada668 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 23 Sep 2014 01:58:34 -0400

blk-mq uses percpu_ref for its usage counter which tracks the number
of in-flight commands and used to synchronously drain the queue on
freeze.  percpu_ref shutdown takes measureable wallclock time as it
involves a sched RCU grace period.  This means that draining a blk-mq
takes measureable wallclock time.  One would think that this shouldn't
matter as queue shutdown should be a rare event which takes place
asynchronously w.r.t. userland.

Unfortunately, SCSI probing involves synchronously setting up and then
tearing down a lot of request_queues back-to-back for non-existent
LUNs.  This means that SCSI probing may take above ten seconds when
scsi-mq is used.

  [    0.949892] scsi host0: Virtio SCSI HBA
  [    1.007864] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    1.1. PQ: 0 ANSI: 5
  [    1.021299] scsi 0:0:1:0: Direct-Access     QEMU     QEMU HARDDISK    1.1. PQ: 0 ANSI: 5
  [    1.520356] tsc: Refined TSC clocksource calibration: 2491.910 MHz

  <stall>

  [   16.186549] sd 0:0:0:0: Attached scsi generic sg0 type 0
  [   16.190478] sd 0:0:1:0: Attached scsi generic sg1 type 0
  [   16.194099] osd: LOADED open-osd 0.2.1
  [   16.203202] sd 0:0:0:0: [sda] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
  [   16.208478] sd 0:0:0:0: [sda] Write Protect is off
  [   16.211439] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  [   16.218771] sd 0:0:1:0: [sdb] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
  [   16.223264] sd 0:0:1:0: [sdb] Write Protect is off
  [   16.225682] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

This is also the reason why request_queues start in bypass mode which
is ended on blk_register_queue() as shutting down a fully functional
queue also involves a RCU grace period and the queues for non-existent
SCSI devices never reach registration.

blk-mq basically needs to do the same thing - start the mq in a
degraded mode which is faster to shut down and then make it fully
functional only after the queue reaches registration.  percpu_ref
recently grew facilities to force atomic operation until explicitly
switched to percpu mode, which can be used for this purpose.  This
patch makes blk-mq initialize q->mq_usage_counter in atomic mode and
switch it to percpu mode only once blk_register_queue() is reached.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Christoph Hellwig <hch@infradead.org>
Link: http://lkml.kernel.org/g/20140919113815.GA10791@lst.de
Fixes: add703fda981 ("blk-mq: use percpu_ref for mq usage count")
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
Hello,

This patch is on top of

  block/for-3.18/core fe052529e465 ("scsi: move blk_mq_start_request call earlier")
+ [PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()
  http://lkml.kernel.org/g/1411451718-17807-1-git-send-email-tj@kernel.org

and available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-blk_mq-latency-fix

Thanks.

 block/blk-mq-sysfs.c   |  6 ++++++
 block/blk-mq.c         |  6 +++++-
 block/blk-sysfs.c      | 11 +++++++++--
 include/linux/blk-mq.h |  1 +
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index ed52178..371d880 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -402,6 +402,12 @@ static void blk_mq_sysfs_init(struct request_queue *q)
 	}
 }
 
+/* see blk_register_queue() */
+void blk_mq_finish_init(struct request_queue *q)
+{
+	percpu_ref_switch_to_percpu(&q->mq_usage_counter);
+}
+
 int blk_mq_register_disk(struct gendisk *disk)
 {
 	struct device *dev = disk_to_dev(disk);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 91c49b3..4ae58b1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1783,8 +1783,12 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (!q)
 		goto err_hctxs;
 
+	/*
+	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
+	 * See blk_register_queue() for details.
+	 */
 	if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
-			    0, GFP_KERNEL))
+			    PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
 		goto err_map;
 
 	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 17f5c84..521ae90 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -551,12 +551,19 @@ int blk_register_queue(struct gendisk *disk)
 		return -ENXIO;
 
 	/*
-	 * Initialization must be complete by now.  Finish the initial
-	 * bypass from queue allocation.
+	 * SCSI probing may synchronously create and destroy a lot of
+	 * request_queues for non-existent devices.  Shutting down a fully
+	 * functional queue takes measureable wallclock time as RCU grace
+	 * periods are involved.  To avoid excessive latency in these
+	 * cases, a request_queue starts out in a degraded mode which is
+	 * faster to shut down and is made fully functional here as
+	 * request_queues for non-existent devices never get registered.
 	 */
 	if (!blk_queue_init_done(q)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
 		blk_queue_bypass_end(q);
+		if (q->mq_ops)
+			blk_mq_finish_init(q);
 	}
 
 	ret = blk_trace_init_sysfs(dev);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 3253495..4495dd4 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -144,6 +144,7 @@ enum {
 };
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
+void blk_mq_finish_init(struct request_queue *q);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
 
-- 
1.9.3


-- 
tejun
