From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 14/15] dm kcopyd: change mutex to spinlock
Date: Tue, 15 Jul 2014 15:43:46 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151543220.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

job->lock is only taken for a finite amount of time and the process
doesn't block while holding it, so change it from mutex to spinlock.

This change is needed for the next patch that makes it possible to call
segment_complete from an interrupt. Taking mutexes inside an interrupt is
not allowed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-3.16-rc5/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.16-rc5.orig/drivers/md/dm-kcopyd.c	2014-07-15 19:20:34.000000000 +0200
+++ linux-3.16-rc5/drivers/md/dm-kcopyd.c	2014-07-15 19:24:20.000000000 +0200
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-kcopyd.h>
@@ -356,7 +356,7 @@ struct kcopyd_job {
 	 * These fields are only used if the job has been split
 	 * into more manageable parts.
 	 */
-	struct mutex lock;
+	spinlock_t lock;
 	atomic_t sub_jobs;
 	sector_t progress;
 
@@ -629,7 +629,7 @@ static void segment_complete(int read_er
 	struct kcopyd_job *job = sub_job->master_job;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	mutex_lock(&job->lock);
+	spin_lock(&job->lock);
 
 	/* update the error */
 	if (read_err)
@@ -653,7 +653,7 @@ static void segment_complete(int read_er
 			job->progress += count;
 		}
 	}
-	mutex_unlock(&job->lock);
+	spin_unlock(&job->lock);
 
 	if (count) {
 		int i;
@@ -708,7 +708,7 @@ static void submit_job(struct kcopyd_job
 	if (job->source.count <= SUB_JOB_SIZE)
 		dispatch_job(job);
 	else {
-		mutex_init(&job->lock);
+		spin_lock_init(&job->lock);
 		job->progress = 0;
 		split_job(job);
 	}
