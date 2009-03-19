From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC B 2/2] libosd: Use of new blk_make_request
Date: Thu, 19 Mar 2009 16:31:41 +0200
Message-ID: <49C2574D.6090401@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:5465 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753148AbZCSOc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:32:56 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


Use new blk_make_request() to allocate a request from bio
and avoid using deprecated blk_rq_append_bio().

This patch is dependent on a block layer patch titled:
    [BLOCK] Export new blk_make_request() which takes bio \
            and returns request

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   33 +++++++++++----------------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index ccfd347..66c3e92 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1208,6 +1208,14 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 /*
  * osd_finalize_request and helpers
  */
+struct request *_make_request(struct request_queue *q, bool has_write,
+			      struct bio *bio, gfp_t flags)
+{
+	if (bio)
+		return blk_make_request(q, bio, flags);
+	else
+		return blk_get_request(q, has_write ? WRITE : READ, flags);
+}
 
 static int _init_blk_request(struct osd_request *or,
 	bool has_in, bool has_out)
@@ -1218,7 +1226,8 @@ static int _init_blk_request(struct osd_request *or,
 	struct request *req;
 	int ret = -ENOMEM;
 
-	req = blk_get_request(q, has_out, flags);
+	req = _make_request(q, has_out, has_out ? or->out.bio : or->in.bio,
+			    flags);
 	if (!req)
 		goto out;
 
@@ -1233,7 +1242,7 @@ static int _init_blk_request(struct osd_request *or,
 		or->out.req = req;
 		if (has_in) {
 			/* allocate bidi request */
-			req = blk_get_request(q, READ, flags);
+			req = _make_request(q, false, or->in.bio, flags);
 			if (!req) {
 				OSD_DEBUG("blk_get_request for bidi failed\n");
 				goto out;
@@ -1279,26 +1288,6 @@ int osd_finalize_request(struct osd_request *or,
 		return ret;
 	}
 
-	if (or->out.bio) {
-		ret = blk_rq_append_bio(or->request->q, or->out.req,
-					or->out.bio);
-		if (ret) {
-			OSD_DEBUG("blk_rq_append_bio out failed\n");
-			return ret;
-		}
-		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
-			_LLU(or->out.total_bytes), or->out.req->data_len);
-	}
-	if (or->in.bio) {
-		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
-		if (ret) {
-			OSD_DEBUG("blk_rq_append_bio in failed\n");
-			return ret;
-		}
-		OSD_DEBUG("in bytes=%llu (bytes_req=%u)\n",
-			_LLU(or->in.total_bytes), or->in.req->data_len);
-	}
-
 	or->out.pad_buff = sg_out_pad_buffer;
 	or->in.pad_buff = sg_in_pad_buffer;
 
-- 
1.6.2.1


