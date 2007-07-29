From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] bsg: update sg_io_v4 structure
Date: Sun, 29 Jul 2007 23:00:46 +0900
Message-ID: <200707291401.l6TE1Jhx026386@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47342 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763514AbXG2OEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2007 10:04:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, dougg@torque.net, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This updates sg_io_v4 structure (based on Doug's RFC, release 1.3).

The major changes are:

- add dout_resid field
- increase tag size to 64 bits to comply with SAM-4 and SRP
- add dout_iovec_count and din_iovec_count

dout_iovec_count and din_iovec_count aren't supported now. I'm not
sure whether they will be supported or not but they were added for the
possible future changes.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c         |   10 +++++++---
 include/linux/bsg.h |   13 +++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 12c287b..ccfa5f8 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1,5 +1,5 @@
 /*
- * bsg.c - block layer implementation of the sg v3 interface
+ * bsg.c - block layer implementation of the sg v4 interface
  *
  * Copyright (C) 2004 Jens Axboe <axboe@suse.de> SUSE Labs
  * Copyright (C) 2004 Peter M. Jones <pjones@redhat.com>
@@ -421,7 +421,6 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->din_resid = rq->data_len;
 	hdr->response_len = 0;
 
 	if (rq->sense_len && hdr->response) {
@@ -437,9 +436,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
+		hdr->dout_resid = rq->data_len;
+		hdr->din_resid = rq->next_rq->data_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
-	}
+	} else if (rq_data_dir(rq) == READ)
+		hdr->din_resid = rq->data_len;
+	else
+		hdr->dout_resid = rq->data_len;
 
 	blk_rq_unmap_user(bio);
 	blk_put_request(rq);
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 102dc09..60e377b 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -15,14 +15,18 @@ struct sg_io_v4 {
 
 	__u32 request_len;	/* [i] in bytes */
 	__u64 request;		/* [i], [*i] {SCSI: cdb} */
+	__u64 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
 	__u32 request_attr;	/* [i] {SCSI: task attribute} */
-	__u32 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
 	__u32 request_priority;	/* [i] {SCSI: task priority} */
+	__u32 request_extra;	/* [i] {spare, for padding} */
 	__u32 max_response_len;	/* [i] in bytes */
 	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
 
-	/* "din_" for data in (from device); "dout_" for data out (to device) */
+        /* "dout_": data out (to device); "din_": data in (from device) */
+	__u32 dout_iovec_count;	/* [i] 0 -> "flat" dout transfer else
+				   dout_xfer points to array of iovec */
 	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
+	__u32 din_iovec_count;	/* [i] 0 -> "flat" din transfer */
 	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
 	__u64 dout_xferp;	/* [i], [*i] */
 	__u64 din_xferp;	/* [i], [*o] */
@@ -39,8 +43,9 @@ struct sg_io_v4 {
 	__u32 info;		/* [o] additional information */
 	__u32 duration;		/* [o] time to complete, in milliseconds */
 	__u32 response_len;	/* [o] bytes of response actually written */
-	__s32 din_resid;	/* [o] actual_din_xfer_len - din_xfer_len */
-	__u32 generated_tag;	/* [o] {SCSI: task tag that transport chose} */
+	__s32 din_resid;	/* [o] din_xfer_len - actual_din_xfer_len */
+	__s32 dout_resid;	/* [o] dout_xfer_len - actual_dout_xfer_len */
+	__u64 generated_tag;	/* [o] {SCSI: transport generated task tag} */
 	__u32 spare_out;	/* [o] */
 
 	__u32 padding;
-- 
1.5.2.4

