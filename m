From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 1/1] bsg-lib: fix use-after-free under memory-pressure
Date: Thu, 21 Sep 2017 20:17:44 +0200
Message-ID: <9040282c25a027344945e9be2c3afc3d90386909.1506016742.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751646AbdIUSSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Sep 2017 14:18:10 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8LIG4Ck113021
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 14:18:09 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d4f1mkq92-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 14:18:09 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Thu, 21 Sep 2017 19:18:07 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v8LII61X17825910
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 18:18:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C29BFAE04D
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 19:12:56 +0100 (BST)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5DCDAE045
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 19:12:56 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.154])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 19:12:56 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org

When under memory-pressure it is possible that the mempool which backs
the 'struct request_queue' will make use of up to BLKDEV_MIN_RQ count
emergency buffers - in case it can't get a regular allocation. These
buffers are preallocated and once they are also used, they are
re-supplied with old finished requests from the same request_queue (see
mempool_free()).

The bug is, when re-supplying the emergency pool, the old requests are
not again ran through the callback mempool_t->alloc(), and thus also not
through the callback bsg_init_rq(). Thus we skip initialization, and
while the sense-buffer still should be good, scsi_request->cmd might
have become to be an invalid pointer in the meantime. When the request
is initialized in bsg.c, and the user's CDB is larger than BLK_MAX_CDB,
bsg will replace it with a custom allocated buffer, which is freed when
the user's command is finished, thus it dangles afterwards. When next a
command is sent by the user that has a smaller/similar CDB as
BLK_MAX_CDB, bsg will assume that scsi_request->cmd is backed by
scsi_request->__cmd, will not make a custom allocation, and write into
undefined memory.

Fix this by splitting bsg_init_rq() into two functions:
 - bsg_init_job() directly replace bsg_init_rq() and only does the
   allocation of the sense-buffer, which is used to back the bsg job's
   reply buffer. This pointer should never change during the lifetime of
   a scsi_request, so it doesn't need re-initialization.
 - bsg_init_rq() is a new function that make use of
   'struct request_queue's initialize_rq_fn callback (which was
   introduced in v4.12). This is always called before the request is
   given out via blk_get_request(). This function does the remaining
   initialization that was previously done in bsg_init_rq(), and will
   also do it when the request is taken from the emergency-pool of the
   backing mempool.

Also rename bsg_exit_rq() into bsg_exit_job(), to make it fit the
name-scheme.

Fixes: 50b4d485528d ("bsg-lib: fix kernel panic resulting from missing allocation of reply-buffer")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---

Notes:
    I did test this on zFCP with FC CT commands send via the ioctl() and
    write() system-call. That did work fine. But I would very much
    appreciate if anyone could run this against an other HBA or even an
    other implementer of bsg-lib, such as now SAS, because I have no access
    to such hardware here.
    
    This should make no difference to the normal cases - where each request
    is allocated via slab - with- or without this patch; if I didn't miss
    anything. Only the order is a bit mixed up - the memset is done after
    the sense-allocation, so I have to buffer the sense-pointer for that.
    But otherwise there is no difference I am aware of, so it should behave
    the same (does for me).
    
    I could not reproduce the memory-pressure case here in the lab.. I
    don't see any reason why it should work now, but I am open to
    suggestions :)
    
                                                Beste Grüße / Best regards,
                                                  - Benjamin Block

 block/bsg-lib.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index c82408c7cc3c..634d1557da38 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -203,28 +203,42 @@ static void bsg_request_fn(struct request_queue *q)
 	spin_lock_irq(q->queue_lock);
 }
 
-static int bsg_init_rq(struct request_queue *q, struct request *req, gfp_t gfp)
+static int bsg_init_job(struct request_queue *q, struct request *req, gfp_t gfp)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 	struct scsi_request *sreq = &job->sreq;
 
-	memset(job, 0, sizeof(*job));
+	/* called right after the request is allocated for the request_queue */
 
-	scsi_req_init(sreq);
-	sreq->sense_len = SCSI_SENSE_BUFFERSIZE;
-	sreq->sense = kzalloc(sreq->sense_len, gfp);
+	sreq->sense = kzalloc(SCSI_SENSE_BUFFERSIZE, gfp);
 	if (!sreq->sense)
 		return -ENOMEM;
 
-	job->req = req;
-	job->reply = sreq->sense;
-	job->reply_len = sreq->sense_len;
-	job->dd_data = job + 1;
-
 	return 0;
 }
 
-static void bsg_exit_rq(struct request_queue *q, struct request *req)
+static void bsg_init_rq(struct request *req)
+{
+	struct bsg_job *job = blk_mq_rq_to_pdu(req);
+	struct scsi_request *sreq = &job->sreq;
+	void *sense = sreq->sense;
+
+	/* called right before the request is given to the request_queue user */
+
+	memset(job, 0, sizeof(*job));
+
+	scsi_req_init(sreq);
+
+	sreq->sense = sense;
+	sreq->sense_len = SCSI_SENSE_BUFFERSIZE;
+
+	job->req = req;
+	job->reply = sense;
+	job->reply_len = sreq->sense_len;
+	job->dd_data = job + 1;
+}
+
+static void bsg_exit_job(struct request_queue *q, struct request *req)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 	struct scsi_request *sreq = &job->sreq;
@@ -250,8 +264,9 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	if (!q)
 		return ERR_PTR(-ENOMEM);
 	q->cmd_size = sizeof(struct bsg_job) + dd_job_size;
-	q->init_rq_fn = bsg_init_rq;
-	q->exit_rq_fn = bsg_exit_rq;
+	q->init_rq_fn = bsg_init_job;
+	q->exit_rq_fn = bsg_exit_job;
+	q->initialize_rq_fn = bsg_init_rq;
 	q->request_fn = bsg_request_fn;
 
 	ret = blk_init_allocated_queue(q);
-- 
2.14.1
