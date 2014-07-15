From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 12/15] dm kcopyd: introduce the function submit_job
Date: Tue, 15 Jul 2014 15:42:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151541350.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We move some code to a function submit_job. It is needed for the next
patch that calls submit_job from another place.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: linux-3.16-rc5/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.16-rc5.orig/drivers/md/dm-kcopyd.c	2014-07-14 16:45:23.000000000 +0200
+++ linux-3.16-rc5/drivers/md/dm-kcopyd.c	2014-07-14 17:28:36.000000000 +0200
@@ -698,6 +698,17 @@ static void split_job(struct kcopyd_job 
 	}
 }
 
+static void submit_job(struct kcopyd_job *job)
+{
+	if (job->source.count <= SUB_JOB_SIZE)
+		dispatch_job(job);
+	else {
+		mutex_init(&job->lock);
+		job->progress = 0;
+		split_job(job);
+	}
+}
+
 int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		   unsigned int num_dests, struct dm_io_region *dests,
 		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
@@ -746,13 +757,7 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->context = context;
 	job->master_job = job;
 
-	if (job->source.count <= SUB_JOB_SIZE)
-		dispatch_job(job);
-	else {
-		mutex_init(&job->lock);
-		job->progress = 0;
-		split_job(job);
-	}
+	submit_job(job);
 
 	return 0;
 }
