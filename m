From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 6/6] bsg: add SG_IO to SG v4
Date: Wed, 20 Dec 2006 14:43:13 +0900
Message-ID: <20061220144313T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:61023 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbWLTFnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 00:43:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

This adds SG_IO support to SG v4.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 6d139d2..9dc5d36 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -945,8 +945,27 @@ bsg_ioctl(struct inode *inode, struct fi
 		void __user *uarg = (void __user *) arg;
 		return scsi_cmd_ioctl(file, bd->disk, cmd, uarg);
 	}
-	case SG_IO:
-		return -EINVAL;
+	case SG_IO: {
+		struct request *rq;
+		struct bio *bio;
+		struct sg_io_v4 hdr;
+
+		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
+			return -EFAULT;
+
+		rq = bsg_map_hdr(bd, &hdr);
+		if (IS_ERR(rq))
+			return PTR_ERR(rq);
+
+		bio = rq->bio;
+		blk_execute_rq(bd->queue, bd->disk, rq, 0);
+		blk_complete_sgv4_hdr_rq(rq, &hdr, bio);
+
+		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
+			return -EFAULT;
+		else
+			return 0;
+	}
 	/*
 	 * block device ioctls
 	 */
-- 
1.4.3.2

