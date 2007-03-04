From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] mv user buffer copy access_ok test to block helper
Date: Sun, 04 Mar 2007 12:31:24 -0600
Message-ID: <11730330902393-git-send-email-michaelc@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <11730330852430-git-send-email-michaelc@cs.wisc.edu> <11730330851234-git-send-email-michaelc@cs.wisc.edu> <11730330861995-git-send-email-michaelc@cs.wisc.edu> <11730330872229-git-send-email-michaelc@cs.wisc.edu> <11730330881574-git-send-email-michaelc@cs.wisc.edu> <11730330893660-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXCDSbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 13:31:41 -0500
In-Reply-To: <11730330893660-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

sg.c does a access_ok test on the user buffer when doing
indirect IO. bsg and scsi_ioctl.c did not, but it seems
like it would be ok to be common. This patch moves that
test to the block layer helpers.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 35b66ed..4327e23 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2527,6 +2527,7 @@ static int copy_user_iov(struct bio *hea
 {
 	unsigned int iov_len = 0;
 	int ret, i = 0, iov_index = 0;
+	int read = bio_data_dir(head) == READ;
 	struct bio *bio;
 	struct bio_vec *bvec;
 	char __user *p = NULL;
@@ -2560,10 +2561,15 @@ continue_from_bvec:
 					 */
 					goto continue_from_bvec;
 				}
+
+				if (!access_ok(read ?
+					       VERIFY_WRITE : VERIFY_READ,
+					       p, iov_len))
+					return -EFAULT;
 			}
 
 			copy_bytes = min(iov_len, bvec->bv_len - bvec_offset);
-			if (bio_data_dir(head) == READ)
+			if (read)
 				ret = copy_to_user(p, addr, copy_bytes);
 			else
 				ret = copy_from_user(addr, p, copy_bytes);
-- 
1.4.1.1

