From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: call blk_rq_map_user only for commands with data
 transfer
Date: Sat, 25 Nov 2006 10:22:57 +0900
Message-ID: <200611250122.kAP1MvHi021546@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo00.iij4u.or.jp ([210.130.0.19]:34804 "EHLO mo00.iij4u.or.jp")
	by vger.kernel.org with ESMTP id S935104AbWKYBXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 20:23:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com

bsg_map_hdr always calls blk_rq_map_user so commands without data
transfer fail.

This is against the bsg branch in the block tree.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 5d23f97..65729fd 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -301,7 +301,7 @@ bsg_map_hdr(struct bsg_device *bd, int r
 		return ERR_PTR(ret);
 	}
 
-	if (!hdr->iovec_count) {
+	if (!hdr->iovec_count && hdr->dxfer_len) {
 		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
 		if (ret)
 			goto out;
-- 
1.4.1.1

