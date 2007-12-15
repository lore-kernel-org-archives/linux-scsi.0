From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] bsg: fix SG_IO error path
Date: Sat, 15 Dec 2007 14:50:49 +0900
Message-ID: <20071215145326S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:47699 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXLOFvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Dec 2007 00:51:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

bsg SG_IO needs to return -EFAULT for the response field in struct
sg_io_v4.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 8e181ab..7781e63 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -877,6 +877,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct request *rq;
 		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
+		int ret;
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
 			return -EFAULT;
@@ -889,12 +890,12 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (rq->next_rq)
 			bidi_bio = rq->next_rq->bio;
 		blk_execute_rq(bd->queue, NULL, rq, 0);
-		blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
 			return -EFAULT;
 
-		return 0;
+		return ret;
 	}
 	/*
 	 * block device ioctls
-- 
1.5.3.4

