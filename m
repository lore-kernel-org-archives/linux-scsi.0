From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] bsg: bidi bio map failure fix
Date: Tue, 12 Feb 2008 15:40:24 -0500
Message-ID: <20080212204024.GA13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:44862 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764435AbYBLUka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:40:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

If blk_rq_map_user requires more than one bio, and fails mapping
somewhere after the first bio, it will return with rq->bio set to
non-NULL, but it will have already unmapped the partial bio.  The
"out:" error exit section will see the non-null bio and try to unmap
it again, triggering a mapcount bug via bad_page().

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 3337125..bba7154 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -295,8 +295,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
 		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
-		if (ret)
+		if (ret) {
+			next_rq->bio = NULL;  /* do not unmap twice */
 			goto out;
+		}
 	}
 
 	if (hdr->dout_xfer_len) {
-- 
1.5.3.8

