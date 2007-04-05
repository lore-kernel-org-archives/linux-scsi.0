From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: update sg_io_v4 structure
Date: Thu, 5 Apr 2007 10:28:40 +0900 (JST)
Message-ID: <20070405102902M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63386 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXDEB27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 21:28:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

This updates sg_io_v4 structure (based on Doug's RFC, release 1.3).

One minor change I made is using 'spare_out' and 'padding' instead of
'spare_out' and 'spare_out2' to be consistent with 'spare_in'.

I added dout_iovec_count and din_iovec_count though I'm not sure bsg
needs to implement iovec support (and how if bsgs needs to do). But I
think that it would be better to put them for possible future
changes. Even if bsg doesn't support it, it's not bad to be kind to
other OSes that might use sg_io_v4 structure and support iovec.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/bsg.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0dd01f9..094c0a0 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -9,17 +9,21 @@ struct sg_io_v4 {
 
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
-	__u64 dout_xferp;	/* [i], [*i] */
-	__u64 din_xferp;	/* [i], [*o] */
+	__u64 dout_xfer;	/* [i], [*i] */
+	__u64 din_xfer;		/* [i], [*o] */
 
 	__u32 timeout;		/* [i] units: millisecond */
 	__u32 flags;		/* [i] bit mask */
@@ -34,7 +38,8 @@ struct sg_io_v4 {
 	__u32 duration;		/* [o] time to complete, in milliseconds */
 	__u32 response_len;	/* [o] bytes of response actually written */
 	__s32 din_resid;	/* [o] actual_din_xfer_len - din_xfer_len */
-	__u32 generated_tag;	/* [o] {SCSI: task tag that transport chose} */
+	__s32 dout_resid;	/* [o] actual_dout_xfer_len - dout_xfer_len */
+	__u64 generated_tag;	/* [o] {SCSI: transport generated task tag} */
 	__u32 spare_out;	/* [o] */
 
 	__u32 padding;
-- 
1.4.4.3

