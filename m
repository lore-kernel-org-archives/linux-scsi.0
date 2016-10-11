From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 35/44] block: add reference counting for struct bsg_job
Date: Tue, 11 Oct 2016 13:29:06 +0200
Message-ID: <153309f7b4d7a182cfc4b15f0d8c307b878c95df.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753209AbcJKL3h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 07:29:37 -0400
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>

Add reference counting to 'struct bsg_job' so we can implement a reuqest
timeout handler for bsg_jobs, which is needed for Fibre Channel.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c         | 7 +++++--
 include/linux/bsg-lib.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 650f427..632fb40 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -32,8 +32,10 @@
  * bsg_destroy_job - routine to teardown/delete a bsg job
  * @job: bsg_job that is to be torn down
  */
-static void bsg_destroy_job(struct bsg_job *job)
+static void bsg_destroy_job(struct kref *kref)
 {
+	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
+
 	put_device(job->dev);	/* release reference for the request */
 
 	kfree(job->request_payload.sg_list);
@@ -84,7 +86,7 @@ static void bsg_softirq_done(struct request *rq)
 	struct bsg_job *job = rq->special;
 
 	blk_end_request_all(rq, rq->errors);
-	bsg_destroy_job(job);
+	kref_put(&job->kref, bsg_destroy_job);
 }
 
 static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
@@ -142,6 +144,7 @@ static int bsg_create_job(struct device *dev, struct request *req)
 	job->dev = dev;
 	/* take a reference for the request */
 	get_device(job->dev);
+	kref_init(&job->kref);
 	return 0;
 
 failjob_rls_rqst_payload:
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index a226652..58e0717 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -40,6 +40,8 @@ struct bsg_job {
 	struct device *dev;
 	struct request *req;
 
+	struct kref kref;
+
 	/* Transport/driver specific request/reply structs */
 	void *request;
 	void *reply;
-- 
1.8.5.6

