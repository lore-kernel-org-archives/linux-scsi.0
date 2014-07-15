From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 15/15] dm kcopyd: call copy offload with asynchronous
 callback
Date: Tue, 15 Jul 2014 15:44:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151543490.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408AbaGOTof (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2014 15:44:35 -0400
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Change dm kcopyd so that it calls blkdev_issue_copy with an asynchronous
callback. There can be large number of pending kcopyd requests and holding
a process context for each of them may put too much load on the workqueue
subsystem.

This patch changes it so that blkdev_issue_copy returns after it submitted
the requests and copy_offload_callback is called when the copy operation
finishes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

Index: linux-3.16-rc5/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.16-rc5.orig/drivers/md/dm-kcopyd.c	2014-07-15 19:24:20.000000000 +0200
+++ linux-3.16-rc5/drivers/md/dm-kcopyd.c	2014-07-15 19:24:54.000000000 +0200
@@ -361,8 +361,6 @@ struct kcopyd_job {
 	sector_t progress;
 
 	struct kcopyd_job *master_job;
-
-	struct work_struct copy_work;
 };
 
 static struct kmem_cache *_job_cache;
@@ -628,8 +626,9 @@ static void segment_complete(int read_er
 	struct kcopyd_job *sub_job = (struct kcopyd_job *) context;
 	struct kcopyd_job *job = sub_job->master_job;
 	struct dm_kcopyd_client *kc = job->kc;
+	unsigned long flags;
 
-	spin_lock(&job->lock);
+	spin_lock_irqsave(&job->lock, flags);
 
 	/* update the error */
 	if (read_err)
@@ -653,7 +652,7 @@ static void segment_complete(int read_er
 			job->progress += count;
 		}
 	}
-	spin_unlock(&job->lock);
+	spin_unlock_irqrestore(&job->lock, flags);
 
 	if (count) {
 		int i;
@@ -714,29 +713,25 @@ static void submit_job(struct kcopyd_job
 	}
 }
 
-static void copy_offload_work(struct work_struct *work)
+static void copy_offload_callback(void *ptr, int error)
 {
-	struct kcopyd_job *job = container_of(work, struct kcopyd_job, copy_work);
-	sector_t copied;
+	struct kcopyd_job *job = ptr;
 
-	blkdev_issue_copy(job->source.bdev, job->source.sector,
-			  job->dests[0].bdev, job->dests[0].sector,
-			  job->source.count,
-			  GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN,
-			  NULL, NULL, &copied);
-
-	job->source.sector += copied;
-	job->source.count -= copied;
-	job->dests[0].sector += copied;
-	job->dests[0].count -= copied;
+	job->source.sector += job->progress;
+	job->source.count -= job->progress;
+	job->dests[0].sector += job->progress;
+	job->dests[0].count -= job->progress;
 
 	submit_job(job);
 }
 
 static void try_copy_offload(struct kcopyd_job *job)
 {
-	INIT_WORK(&job->copy_work, copy_offload_work);
-	queue_work(job->kc->kcopyd_wq, &job->copy_work);
+	blkdev_issue_copy(job->source.bdev, job->source.sector,
+			  job->dests[0].bdev, job->dests[0].sector,
+			  job->source.count,
+			  GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN,
+			  copy_offload_callback, job, &job->progress);
 }
 
 int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,

