From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] bsg-lib: handle bidi requests without block layer help
Date: Sun, 11 Nov 2018 14:32:09 +0100
Message-ID: <20181111133211.13926-7-hch@lst.de>
References: <20181111133211.13926-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111133211.13926-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We can just stash away the second request in struct bsg_job instead
of using the block layer req->next_rq field, allowing for the eventual
removal of the latter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg-lib.c                   | 44 +++++++++++++++++++---
 block/bsg.c                       | 62 ++++++-------------------------
 drivers/scsi/scsi_transport_sas.c |  1 -
 include/linux/bsg-lib.h           |  4 ++
 4 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 192129856342..005e2b75d775 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -51,11 +51,40 @@ static int bsg_transport_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 		fmode_t mode)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
+	int ret;
 
 	job->request_len = hdr->request_len;
 	job->request = memdup_user(uptr64(hdr->request), hdr->request_len);
+	if (IS_ERR(job->request))
+		return PTR_ERR(job->request);
+
+	if (hdr->dout_xfer_len && hdr->din_xfer_len) {
+		job->bidi_rq = blk_get_request(rq->q, REQ_OP_SCSI_IN, 0);
+		if (IS_ERR(job->bidi_rq)) {
+			ret = PTR_ERR(job->bidi_rq);
+			goto out;
+		}
+
+		ret = blk_rq_map_user(rq->q, job->bidi_rq, NULL,
+				uptr64(hdr->din_xferp), hdr->din_xfer_len,
+				GFP_KERNEL);
+		if (ret)
+			goto out_free_bidi_rq;
+
+		job->bidi_bio = job->bidi_rq->bio;
+	} else {
+		job->bidi_rq = NULL;
+		job->bidi_bio = NULL;
+	}
 
-	return PTR_ERR_OR_ZERO(job->request);
+	return 0;
+
+out_free_bidi_rq:
+	if (job->bidi_rq)
+		blk_put_request(job->bidi_rq);
+out:
+	kfree(job->request);
+	return ret;
 }
 
 static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
@@ -93,7 +122,7 @@ static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 	/* we assume all request payload was transferred, residual == 0 */
 	hdr->dout_resid = 0;
 
-	if (rq->next_rq) {
+	if (job->bidi_rq) {
 		unsigned int rsp_len = job->reply_payload.payload_len;
 
 		if (WARN_ON(job->reply_payload_rcv_len > rsp_len))
@@ -111,6 +140,11 @@ static void bsg_transport_free_rq(struct request *rq)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
 
+	if (job->bidi_rq) {
+		blk_rq_unmap_user(job->bidi_bio);
+		blk_put_request(job->bidi_rq);
+	}
+
 	kfree(job->request);
 }
 
@@ -200,7 +234,6 @@ static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
  */
 static bool bsg_prepare_job(struct device *dev, struct request *req)
 {
-	struct request *rsp = req->next_rq;
 	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 	int ret;
 
@@ -211,8 +244,8 @@ static bool bsg_prepare_job(struct device *dev, struct request *req)
 		if (ret)
 			goto failjob_rls_job;
 	}
-	if (rsp && rsp->bio) {
-		ret = bsg_map_buffer(&job->reply_payload, rsp);
+	if (job->bidi_rq) {
+		ret = bsg_map_buffer(&job->reply_payload, job->bidi_rq);
 		if (ret)
 			goto failjob_rls_rqst_payload;
 	}
@@ -369,7 +402,6 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	}
 
 	q->queuedata = dev;
-	blk_queue_flag_set(QUEUE_FLAG_BIDI, q);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
 	ret = bsg_register_queue(q, dev, name, &bsg_transport_ops);
diff --git a/block/bsg.c b/block/bsg.c
index 8bf3af9543d0..c82f7485b4c7 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -74,6 +74,9 @@ static int bsg_scsi_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 {
 	struct scsi_request *sreq = scsi_req(rq);
 
+	if (hdr->dout_xfer_len && hdr->din_xfer_len)
+		return -EOPNOTSUPP;
+
 	sreq->cmd_len = hdr->request_len;
 	if (sreq->cmd_len > BLK_MAX_CDB) {
 		sreq->cmd = kzalloc(sreq->cmd_len, GFP_KERNEL);
@@ -114,14 +117,10 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 			hdr->response_len = len;
 	}
 
-	if (rq->next_rq) {
-		hdr->dout_resid = sreq->resid_len;
-		hdr->din_resid = scsi_req(rq->next_rq)->resid_len;
-	} else if (rq_data_dir(rq) == READ) {
+	if (rq_data_dir(rq) == READ)
 		hdr->din_resid = sreq->resid_len;
-	} else {
+	else
 		hdr->dout_resid = sreq->resid_len;
-	}
 
 	return ret;
 }
@@ -140,8 +139,8 @@ static const struct bsg_ops bsg_scsi_ops = {
 
 static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 {
-	struct request *rq, *next_rq = NULL;
-	struct bio *bio, *bidi_bio = NULL;
+	struct request *rq;
+	struct bio *bio;
 	struct sg_io_v4 hdr;
 	int ret;
 
@@ -164,7 +163,7 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 
 	ret = q->bsg_dev.ops->fill_hdr(rq, &hdr, mode);
 	if (ret)
-		goto out;
+		return ret;
 
 	rq->timeout = msecs_to_jiffies(hdr.timeout);
 	if (!rq->timeout)
@@ -174,25 +173,6 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 	if (rq->timeout < BLK_MIN_SG_TIMEOUT)
 		rq->timeout = BLK_MIN_SG_TIMEOUT;
 
-	if (hdr.dout_xfer_len && hdr.din_xfer_len) {
-		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
-			ret = -EOPNOTSUPP;
-			goto out;
-		}
-
-		next_rq = blk_get_request(q, REQ_OP_SCSI_IN, 0);
-		if (IS_ERR(next_rq)) {
-			ret = PTR_ERR(next_rq);
-			goto out;
-		}
-
-		rq->next_rq = next_rq;
-		ret = blk_rq_map_user(q, next_rq, NULL, uptr64(hdr.din_xferp),
-				       hdr.din_xfer_len, GFP_KERNEL);
-		if (ret)
-			goto out_free_nextrq;
-	}
-
 	if (hdr.dout_xfer_len) {
 		ret = blk_rq_map_user(q, rq, NULL, uptr64(hdr.dout_xferp),
 				hdr.dout_xfer_len, GFP_KERNEL);
@@ -202,38 +182,20 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 	}
 
 	if (ret)
-		goto out_unmap_nextrq;
+		goto out_free_rq;
 
 	bio = rq->bio;
-	if (rq->next_rq)
-		bidi_bio = rq->next_rq->bio;
 
 	blk_execute_rq(q, NULL, rq, !(hdr.flags & BSG_FLAG_Q_AT_TAIL));
 	ret = rq->q->bsg_dev.ops->complete_rq(rq, &hdr);
-
-	if (rq->next_rq) {
-		blk_rq_unmap_user(bidi_bio);
-		blk_put_request(rq->next_rq);
-	}
-
 	blk_rq_unmap_user(bio);
+
+out_free_rq:
 	rq->q->bsg_dev.ops->free_rq(rq);
 	blk_put_request(rq);
-
-	if (copy_to_user(uarg, &hdr, sizeof(hdr)))
+	if (!ret && copy_to_user(uarg, &hdr, sizeof(hdr)))
 		return -EFAULT;
 	return ret;
-
-out_unmap_nextrq:
-	if (rq->next_rq)
-		blk_rq_unmap_user(rq->next_rq->bio);
-out_free_nextrq:
-	if (rq->next_rq)
-		blk_put_request(rq->next_rq);
-out:
-	q->bsg_dev.ops->free_rq(rq);
-	blk_put_request(rq);
-	return ret;
 }
 
 static struct bsg_device *bsg_alloc_device(void)
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 692b46937e52..60f1a81d2034 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -213,7 +213,6 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 		to_sas_host_attrs(shost)->q = q;
 	}
 
-	blk_queue_flag_set(QUEUE_FLAG_BIDI, q);
 	return 0;
 }
 
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index b356e0006731..7f14517a559b 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -69,6 +69,10 @@ struct bsg_job {
 	int result;
 	unsigned int reply_payload_rcv_len;
 
+	/* BIDI support */
+	struct request *bidi_rq;
+	struct bio *bidi_bio;
+
 	void *dd_data;		/* Used for driver-specific storage */
 };
 
-- 
2.19.1
