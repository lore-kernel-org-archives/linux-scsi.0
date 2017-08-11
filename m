From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
        allocation of a reply-buffer
Date: Fri, 11 Aug 2017 17:35:53 +0200
Message-ID: <20170811153553.GA6372@lst.de>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com> <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com> <20170810093217.GL24539@lst.de> <20170810221038.GA918@bblock-ThinkPad-W530> <20170811083808.GA5497@lst.de> <20170811091415.GA8099@lst.de> <20170811134929.GA1249@bblock-ThinkPad-W530> <20170811143649.GA32381@lst.de> <20170811153203.GA31625@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40013 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbdHKPfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 11:35:55 -0400
Content-Disposition: inline
In-Reply-To: <20170811153203.GA31625@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com

On Fri, Aug 11, 2017 at 05:32:03PM +0200, Benjamin Block wrote:
> So when the bsg interface is used with something different than the
> bsg-lib request queue?

Yes.

> I haven't actually thought about that (presuming
> the bsg-lib queue was the only one being used). Fair enough, I haven't
> completely read that code now, but that seems bad then, to reassign a
> space allocated in someone else's request queue. 
> 
> That still leaves open that we now over-allocate space in bsg-lib, or?

Which space do we over-allocate?

> My diff tells that this was the same patch as before.

Next try:

---
>From f5b03b82df0569c035022c1c2535696186907f1a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 11 Aug 2017 11:03:29 +0200
Subject: bsg-lib: allocate sense data for each request

Since we split the scsi_request out of the request the driver is supposed
to provide storage for the sense buffer.  The bsg-lib code failed to do so,
though and will crash anytime it is used.

This patch moves bsg-lib to allocate and setup the bsg_job ahead of time,
and allocate the sense data, which is used as reply buffer in bsg.

Reported-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Fixes: 82ed4db499b8 ("block: split scsi_request out of struct request")
Cc: <stable@vger.kernel.org> #4.11+
---
 block/bsg-lib.c         | 51 +++++++++++++++++++++++++++----------------------
 include/linux/blkdev.h  |  1 -
 include/linux/bsg-lib.h |  2 ++
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index c4513b23f57a..c07333c3b785 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -37,13 +37,11 @@ static void bsg_destroy_job(struct kref *kref)
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 	struct request *rq = job->req;
 
-	blk_end_request_all(rq, BLK_STS_OK);
-
 	put_device(job->dev);	/* release reference for the request */
 
 	kfree(job->request_payload.sg_list);
 	kfree(job->reply_payload.sg_list);
-	kfree(job);
+	blk_end_request_all(rq, BLK_STS_OK);
 }
 
 void bsg_job_put(struct bsg_job *job)
@@ -100,7 +98,7 @@ EXPORT_SYMBOL_GPL(bsg_job_done);
  */
 static void bsg_softirq_done(struct request *rq)
 {
-	struct bsg_job *job = rq->special;
+	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
 
 	bsg_job_put(job);
 }
@@ -129,24 +127,11 @@ static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 static int bsg_create_job(struct device *dev, struct request *req)
 {
 	struct request *rsp = req->next_rq;
-	struct request_queue *q = req->q;
+	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 	struct scsi_request *rq = scsi_req(req);
-	struct bsg_job *job;
 	int ret;
 
-	BUG_ON(req->special);
-
-	job = kzalloc(sizeof(struct bsg_job) + q->bsg_job_size, GFP_KERNEL);
-	if (!job)
-		return -ENOMEM;
-
-	req->special = job;
-	job->req = req;
-	if (q->bsg_job_size)
-		job->dd_data = (void *)&job[1];
-	job->request = rq->cmd;
 	job->request_len = rq->cmd_len;
-	job->reply = rq->sense;
 	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
 						 * allocated */
 	if (req->bio) {
@@ -187,7 +172,6 @@ static void bsg_request_fn(struct request_queue *q)
 {
 	struct device *dev = q->queuedata;
 	struct request *req;
-	struct bsg_job *job;
 	int ret;
 
 	if (!get_device(dev))
@@ -207,8 +191,7 @@ static void bsg_request_fn(struct request_queue *q)
 			continue;
 		}
 
-		job = req->special;
-		ret = q->bsg_job_fn(job);
+		ret = q->bsg_job_fn(blk_mq_rq_to_pdu(req));
 		spin_lock_irq(q->queue_lock);
 		if (ret)
 			break;
@@ -219,6 +202,27 @@ static void bsg_request_fn(struct request_queue *q)
 	spin_lock_irq(q->queue_lock);
 }
 
+static int bsg_init_rq(struct request_queue *q, struct request *req, gfp_t gfp)
+{
+	struct bsg_job *job = blk_mq_rq_to_pdu(req);
+
+	memset(job, 0, sizeof(*job));
+	job->req = req;
+	job->request = job->sreq.cmd;
+	job->dd_data = job + 1;
+	job->reply = job->sreq.sense = kzalloc(job->reply_len, gfp);
+	if (!job->reply)
+		return -ENOMEM;
+	return 0;
+}
+
+static void bsg_exit_rq(struct request_queue *q, struct request *req)
+{
+	struct bsg_job *job = blk_mq_rq_to_pdu(req);
+
+	kfree(job->reply);
+}
+
 /**
  * bsg_setup_queue - Create and add the bsg hooks so we can receive requests
  * @dev: device to attach bsg device to
@@ -235,7 +239,9 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
 	q = blk_alloc_queue(GFP_KERNEL);
 	if (!q)
 		return ERR_PTR(-ENOMEM);
-	q->cmd_size = sizeof(struct scsi_request);
+	q->cmd_size = sizeof(struct bsg_job) + dd_job_size;
+	q->init_rq_fn = bsg_init_rq;
+	q->exit_rq_fn = bsg_exit_rq;
 	q->request_fn = bsg_request_fn;
 
 	ret = blk_init_allocated_queue(q);
@@ -243,7 +249,6 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
 		goto out_cleanup_queue;
 
 	q->queuedata = dev;
-	q->bsg_job_size = dd_job_size;
 	q->bsg_job_fn = job_fn;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
 	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f45f157b2910..6ae9aa6f93f0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -568,7 +568,6 @@ struct request_queue {
 
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
-	int			bsg_job_size;
 	struct bsg_class_device bsg_dev;
 #endif
 
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index e34dde2da0ef..637a20cfb237 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -24,6 +24,7 @@
 #define _BLK_BSG_
 
 #include <linux/blkdev.h>
+#include <scsi/scsi_request.h>
 
 struct request;
 struct device;
@@ -37,6 +38,7 @@ struct bsg_buffer {
 };
 
 struct bsg_job {
+	struct scsi_request sreq;
 	struct device *dev;
 	struct request *req;
 
-- 
2.11.0
