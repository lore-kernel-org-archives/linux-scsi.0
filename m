From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 4/4] libosd: Use of new blk_make_request
Date: Thu, 07 May 2009 19:18:58 +0300
Message-ID: <4A0309F2.4060203@panasas.com>
References: <4A0307F4.50205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:10850 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753837AbZEGQTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 12:19:11 -0400
In-Reply-To: <4A0307F4.50205@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>


Use new blk_make_request() to allocate a request from bio
and avoid using deprecated blk_rq_append_bio().

This patch is dependent on a block layer patch titled:
    [BLOCK] New blk_make_request() takes bio returns request

This is the last usage of blk_rq_append_bio in osd, it can now
be un-exported.

Also at this point Jeff's osdblk driver will properly
work, as osd_initiator now supports chained-bios.

Request-comments-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Jeff Garzik <jeff@garzik.org>
CC: Tejun Heo <tj@kernel.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>
---
 drivers/scsi/osd/osd_initiator.c |   48 ++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index a36c406..3d460f8 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1304,6 +1304,21 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 /*
  * osd_finalize_request and helpers
  */
+static struct request *_make_request(struct request_queue *q, bool has_write,
+			      struct _osd_io_info *oii, gfp_t flags)
+{
+	if (oii->bio)
+		return blk_make_request(q, oii->bio, flags);
+	else {
+		struct request *req;
+
+		req = blk_get_request(q, has_write ? WRITE : READ, flags);
+		if (unlikely(!req))
+			return ERR_PTR(-ENOMEM);
+
+		return req;
+	}
+}
 
 static int _init_blk_request(struct osd_request *or,
 	bool has_in, bool has_out)
@@ -1312,11 +1327,13 @@ static int _init_blk_request(struct osd_request *or,
 	struct scsi_device *scsi_device = or->osd_dev->scsi_device;
 	struct request_queue *q = scsi_device->request_queue;
 	struct request *req;
-	int ret = -ENOMEM;
+	int ret;
 
-	req = blk_get_request(q, has_out, flags);
-	if (!req)
+	req = _make_request(q, has_out, has_out ? &or->out : &or->in, flags);
+	if (IS_ERR(req)) {
+		ret = PTR_ERR(req);
 		goto out;
+	}
 
 	or->request = req;
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
@@ -1329,9 +1346,10 @@ static int _init_blk_request(struct osd_request *or,
 		or->out.req = req;
 		if (has_in) {
 			/* allocate bidi request */
-			req = blk_get_request(q, READ, flags);
-			if (!req) {
+			req = _make_request(q, false, &or->in, flags);
+			if (IS_ERR(req)) {
 				OSD_DEBUG("blk_get_request for bidi failed\n");
+				ret = PTR_ERR(req);
 				goto out;
 			}
 			req->cmd_type = REQ_TYPE_BLOCK_PC;
@@ -1376,26 +1394,6 @@ int osd_finalize_request(struct osd_request *or,
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


