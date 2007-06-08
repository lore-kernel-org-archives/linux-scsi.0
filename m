From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] bsg: add SCSI transport-level request support
Date: Sat, 9 Jun 2007 00:12:01 +0900 (JST)
Message-ID: <20070608133042I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:45459 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938968AbXFHPMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 11:12:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

SCSI transport-level requests such as SAS management protocol (SMP)
skip blk_verify_command().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c         |   27 +++++++++++++++++++++------
 include/linux/bsg.h |    6 ++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 13ecc95..f2a9979 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -208,7 +208,11 @@ static int blk_fill_sgv4_hdr_rq(request_
 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
 			   hdr->request_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, has_write_perm))
+
+	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
+		if (blk_verify_command(rq->cmd, has_write_perm))
+			return -EPERM;
+	} else if (capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	/*
@@ -232,6 +236,8 @@ static int blk_fill_sgv4_hdr_rq(request_
 static int
 bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 {
+	int ret = 0;
+
 	if (hdr->guard != 'Q')
 		return -EINVAL;
 	if (hdr->request_len > BLK_MAX_CDB)
@@ -240,13 +246,22 @@ bsg_validate_sgv4_hdr(request_queue_t *q
 	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
 
-	/* not supported currently */
-	if (hdr->protocol || hdr->subprotocol)
-		return -EINVAL;
+	switch (hdr->protocol) {
+	case BSG_PROTOCOL_SCSI:
+		switch (hdr->subprotocol) {
+		case BSG_SUB_PROTOCOL_SCSI_CMD:
+		case BSG_SUB_PROTOCOL_SCSI_TRANSPORT:
+			break;
+		default:
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
 
 	*rw = hdr->dout_xfer_len ? WRITE : READ;
-
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0dd01f9..bd998ca 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -1,6 +1,12 @@
 #ifndef BSG_H
 #define BSG_H
 
+#define BSG_PROTOCOL_SCSI		0
+
+#define BSG_SUB_PROTOCOL_SCSI_CMD	0
+#define BSG_SUB_PROTOCOL_SCSI_TMF	1
+#define BSG_SUB_PROTOCOL_SCSI_TRANSPORT	2
+
 struct sg_io_v4 {
 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
 	__u32 protocol;		/* [i] 0 -> SCSI , .... */
-- 
1.4.3.2

