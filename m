From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/9] bsg-lib: remove bsg_job.req
Date: Tue,  3 Oct 2017 12:48:43 +0200
Message-ID: <20171003104845.10417-8-hch@lst.de>
References: <20171003104845.10417-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Users of the bsg-lib interface should only use the bsg_job data structure
and not know about implementation details of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg-lib.c         | 14 ++++++--------
 include/linux/bsg-lib.h |  1 -
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 0d5bbf6a2ddd..6299526bd2c3 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -35,7 +35,7 @@
 static void bsg_teardown_job(struct kref *kref)
 {
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
-	struct request *rq = job->req;
+	struct request *rq = blk_mq_rq_from_pdu(job);
 
 	put_device(job->dev);	/* release reference for the request */
 
@@ -68,19 +68,18 @@ EXPORT_SYMBOL_GPL(bsg_job_get);
 void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len)
 {
-	struct request *req = job->req;
+	struct request *req = blk_mq_rq_from_pdu(job);
 	struct request *rsp = req->next_rq;
-	struct scsi_request *rq = scsi_req(req);
 	int err;
 
-	err = scsi_req(job->req)->result = result;
+	err = job->sreq.result = result;
 	if (err < 0)
 		/* we're only returning the result field in the reply */
-		rq->sense_len = sizeof(u32);
+		job->sreq.sense_len = sizeof(u32);
 	else
-		rq->sense_len = job->reply_len;
+		job->sreq.sense_len = job->reply_len;
 	/* we assume all request payload was transferred, residual == 0 */
-	rq->resid_len = 0;
+	job->sreq.resid_len = 0;
 
 	if (rsp) {
 		WARN_ON(reply_payload_rcv_len > scsi_req(rsp)->resid_len);
@@ -232,7 +231,6 @@ static void bsg_initialize_rq(struct request *req)
 	sreq->sense = sense;
 	sreq->sense_len = SCSI_SENSE_BUFFERSIZE;
 
-	job->req = req;
 	job->reply = sense;
 	job->reply_len = sreq->sense_len;
 	job->dd_data = job + 1;
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 402223c95ce1..08762d297cbd 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -40,7 +40,6 @@ struct bsg_buffer {
 struct bsg_job {
 	struct scsi_request sreq;
 	struct device *dev;
-	struct request *req;
 
 	struct kref kref;
 
-- 
2.14.1
