From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/31] block: Avoid that blk_exit_rl() triggers a use-after-free
Date: Tue, 23 May 2017 17:33:58 -0700
Message-ID: <20170524003420.5381-10-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since the introduction of the .init_rq_fn() and .exit_rq_fn() it
is essential that the memory allocated for struct request_queue
stays around until all blk_exit_rl() calls have finished. Hence
make blk_init_rl() take a reference on struct request_queue.

This patch fixes the following crash:

general protection fault: 0000 [#2] SMP
CPU: 3 PID: 28 Comm: ksoftirqd/3 Tainted: G      D         4.12.0-rc2-dbg+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
task: ffff88013a108040 task.stack: ffffc9000071c000
RIP: 0010:free_request_size+0x1a/0x30
RSP: 0018:ffffc9000071fd38 EFLAGS: 00010202
RAX: 6b6b6b6b6b6b6b6b RBX: ffff880067362a88 RCX: 0000000000000003
RDX: ffff880067464178 RSI: ffff880067362a88 RDI: ffff880135ea4418
RBP: ffffc9000071fd40 R08: 0000000000000000 R09: 0000000100180009
R10: ffffc9000071fd38 R11: ffffffff81110800 R12: ffff88006752d3d8
R13: ffff88006752d3d8 R14: ffff88013a108040 R15: 000000000000000a
FS:  0000000000000000(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa8ec1edb00 CR3: 0000000138ee8000 CR4: 00000000001406e0
Call Trace:
 mempool_destroy.part.10+0x21/0x40
 mempool_destroy+0xe/0x10
 blk_exit_rl+0x12/0x20
 blkg_free+0x4d/0xa0
 __blkg_release_rcu+0x59/0x170
 rcu_process_callbacks+0x260/0x4e0
 __do_softirq+0x116/0x250
 smpboot_thread_fn+0x123/0x1e0
 kthread+0x109/0x140
 ret_from_fork+0x31/0x40

Fixes: commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <stable@vger.kernel.org> # v4.11+
---
 block/blk-cgroup.c |  2 +-
 block/blk-core.c   | 10 ++++++++--
 block/blk-sysfs.c  |  2 +-
 block/blk.h        |  2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7c2947128f58..0480892e97e5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -74,7 +74,7 @@ static void blkg_free(struct blkcg_gq *blkg)
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
 	if (blkg->blkcg != &blkcg_root)
-		blk_exit_rl(&blkg->rl);
+		blk_exit_rl(blkg->q, &blkg->rl);
 
 	blkg_rwstat_exit(&blkg->stat_ios);
 	blkg_rwstat_exit(&blkg->stat_bytes);
diff --git a/block/blk-core.c b/block/blk-core.c
index c7068520794b..55a7b76db7c2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -648,13 +648,19 @@ int blk_init_rl(struct request_list *rl, struct request_queue *q,
 	if (!rl->rq_pool)
 		return -ENOMEM;
 
+	if (rl != &q->root_rl)
+		blk_get_queue(q);
+
 	return 0;
 }
 
-void blk_exit_rl(struct request_list *rl)
+void blk_exit_rl(struct request_queue *q, struct request_list *rl)
 {
-	if (rl->rq_pool)
+	if (rl->rq_pool) {
 		mempool_destroy(rl->rq_pool);
+		if (rl != &q->root_rl)
+			blk_put_queue(q);
+	}
 }
 
 struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 504fee940052..2ff8842f0dc1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -809,7 +809,7 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_free_queue_stats(q->stats);
 
-	blk_exit_rl(&q->root_rl);
+	blk_exit_rl(q, &q->root_rl);
 
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
diff --git a/block/blk.h b/block/blk.h
index 2ed70228e44f..83c8e1100525 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -59,7 +59,7 @@ void blk_free_flush_queue(struct blk_flush_queue *q);
 
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
-void blk_exit_rl(struct request_list *rl);
+void blk_exit_rl(struct request_queue *q, struct request_list *rl);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 void blk_queue_bypass_start(struct request_queue *q);
-- 
2.12.2
