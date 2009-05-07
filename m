From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] libosd: Use new blk_rq_map_kern
Date: Thu, 07 May 2009 19:14:20 +0300
Message-ID: <4A0308DC.6020602@panasas.com>
References: <4A0307F4.50205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:10709 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbZEGQO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 12:14:28 -0400
In-Reply-To: <4A0307F4.50205@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>


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
index 3f5ec57..a36c406 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -921,26 +921,6 @@ int osd_req_add_set_attr_list(struct osd_request *or,
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
@@ -956,14 +936,14 @@ static int _req_append_segment(struct osd_request *or,
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


