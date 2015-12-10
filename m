From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 13/15] dm kcopyd: support copy offload
Date: Thu, 10 Dec 2015 12:31:09 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101215370.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbbLJRbK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2015 12:31:10 -0500
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

This patch adds copy offload support to dm-kcopyd. If copy offload fails,
copying is performed using dm-io, just like before.

There is a module parameter "copy_offload" that can be set to enable or
disable this feature. It can be used to test performance of copy offload.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

Index: linux-3.18-rc3/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.18-rc3.orig/drivers/md/dm-kcopyd.c	2014-11-05 18:09:23.000000000 +0100
+++ linux-3.18-rc3/drivers/md/dm-kcopyd.c	2014-11-05 18:13:04.000000000 +0100
@@ -96,6 +96,9 @@ static DEFINE_SPINLOCK(throttle_spinlock
  */
 #define MAX_SLEEPS			10
 
+static bool copy_offload = true;
+module_param(copy_offload, bool, S_IRUGO | S_IWUSR);
+
 static void io_job_start(struct dm_kcopyd_throttle *t)
 {
 	unsigned throttle, now, difference;
@@ -358,6 +361,8 @@ struct kcopyd_job {
 	sector_t progress;
 
 	struct kcopyd_job *master_job;
+
+	struct work_struct copy_work;
 };
 
 static struct kmem_cache *_job_cache;
@@ -709,6 +714,31 @@ static void submit_job(struct kcopyd_job
 	}
 }
 
+static void copy_offload_work(struct work_struct *work)
+{
+	struct kcopyd_job *job = container_of(work, struct kcopyd_job, copy_work);
+	sector_t copied;
+
+	blkdev_issue_copy(job->source.bdev, job->source.sector,
+			  job->dests[0].bdev, job->dests[0].sector,
+			  job->source.count,
+			  GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN,
+			  NULL, NULL, &copied);
+
+	job->source.sector += copied;
+	job->source.count -= copied;
+	job->dests[0].sector += copied;
+	job->dests[0].count -= copied;
+
+	submit_job(job);
+}
+
+static void try_copy_offload(struct kcopyd_job *job)
+{
+	INIT_WORK(&job->copy_work, copy_offload_work);
+	queue_work(job->kc->kcopyd_wq, &job->copy_work);
+}
+
 int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		   unsigned int num_dests, struct dm_io_region *dests,
 		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
@@ -733,10 +763,20 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
+	job->fn = fn;
+	job->context = context;
+	job->master_job = job;
+
 	if (from) {
 		job->source = *from;
 		job->pages = NULL;
 		job->rw = READ;
+		if (copy_offload && num_dests == 1 &&
+		    bdev_copy_offload(job->source.bdev) &&
+		    bdev_copy_offload(job->dests[0].bdev)) {
+			try_copy_offload(job);
+			return 0;
+		}
 	} else {
 		memset(&job->source, 0, sizeof job->source);
 		job->source.count = job->dests[0].count;
@@ -753,10 +793,6 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 			}
 	}
 
-	job->fn = fn;
-	job->context = context;
-	job->master_job = job;
-
 	submit_job(job);
 
 	return 0;

