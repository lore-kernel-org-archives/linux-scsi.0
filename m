From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH A 2/2] libosd: Use new blk_rq_map_kern
Date: Thu, 19 Mar 2009 16:27:06 +0200
Message-ID: <49C2563A.8030609@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6908 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752489AbZCSO2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:28:20 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


Now that blk_rq_map_kern will append the buffer onto the
request we can use it easily for adding extra segments
(eg. attributes)

This patch is dependent on a block layer patch titled:
   [BLOCK] allow blk_rq_map_kern to append to requests

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 6c921ce..ccfd347 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -834,26 +834,6 @@ int osd_req_add_set_attr_list(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_add_set_attr_list);
 
-static int _append_map_kern(struct request *req,
-	void *buff, unsigned len, gfp_t flags)
-{
-	struct bio *bio;
-	int ret;
-
-	bio = bio_map_kern(req->q, buff, len, flags);
-	if (IS_ERR(bio)) {
-		OSD_ERR("Failed bio_map_kern(%p, %d) => %ld\n", buff, len,
-			PTR_ERR(bio));
-		return PTR_ERR(bio);
-	}
-	ret = blk_rq_append_bio(req->q, req, bio);
-	if (ret) {
-		OSD_ERR("Failed blk_rq_append_bio(%p) => %d\n", bio, ret);
-		bio_put(bio);
-	}
-	return ret;
-}
-
 static int _req_append_segment(struct osd_request *or,
 	unsigned padding, struct _osd_req_data_segment *seg,
 	struct _osd_req_data_segment *last_seg, struct _osd_io_info *io)
@@ -869,14 +849,14 @@ static int _req_append_segment(struct osd_request *or,
 		else
 			pad_buff = io->pad_buff;
 
-		ret = _append_map_kern(io->req, pad_buff, padding,
+		ret = blk_rq_map_kern(io->req->q, io->req, pad_buff, padding,
 				       or->alloc_flags);
 		if (ret)
 			return ret;
 		io->total_bytes += padding;
 	}
 
-	ret = _append_map_kern(io->req, seg->buff, seg->total_bytes,
+	ret = blk_rq_map_kern(io->req->q, io->req, seg->buff, seg->total_bytes,
 			       or->alloc_flags);
 	if (ret)
 		return ret;
-- 
1.6.2.1


