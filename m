From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 37/44] block: export bsg_destroy_job
Date: Tue, 11 Oct 2016 13:29:08 +0200
Message-ID: <4fda6115b14a11250f132cec1bf07b423fb2dda7.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Export bsg_destroy_job so we can use it from clients of bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c         | 3 ++-
 include/linux/bsg-lib.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 632fb40..6b99c7f 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -32,7 +32,7 @@
  * bsg_destroy_job - routine to teardown/delete a bsg job
  * @job: bsg_job that is to be torn down
  */
-static void bsg_destroy_job(struct kref *kref)
+void bsg_destroy_job(struct kref *kref)
 {
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 
@@ -42,6 +42,7 @@ static void bsg_destroy_job(struct kref *kref)
 	kfree(job->reply_payload.sg_list);
 	kfree(job);
 }
+EXPORT_SYMBOL_GPL(bsg_destroy_job);
 
 /**
  * bsg_job_done - completion routine for bsg requests
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 58e0717..67f7de6 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -69,5 +69,6 @@ void bsg_job_done(struct bsg_job *job, int result,
 int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
+void bsg_destroy_job(struct kref *kref);
 
 #endif
-- 
1.8.5.6
