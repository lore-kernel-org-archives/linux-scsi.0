From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments about VMERGE
Date: Tue, 15 Jul 2008 19:44:36 +0900
Message-ID: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51794 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYGOKxI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 06:53:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mikulas Patocka <mpatocka@redhat.com>, David Miller <davem@davemloft.net>

blk_recalc_rq_segments assumes that any segments can be merged in the
case of BIOVEC_VIRT_MERGEABLE && !BIOVEC_VIRT_OVERSIZE. However, an
IOMMU can't merge segments if the total length of the segments is
larger than max_segment_size (the LLD restriction).

Due to this bug, a LLD may get the larger number of segments than
nr_hw_segments because the block layer puts more segments in a request
than it should do.

This bug could happen on alpha, parisc, and sparc, which use VMERGE.

Like blk_hw_contig_segment() does, this patch uses hw_seg_size for
simplicity, which is a bit larger than an exact value (we don't need
BIOVEC_VIRT_START_SIZE here).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: David Miller <davem@davemloft.net>
---
 block/blk-merge.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..39a22f8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -83,7 +83,8 @@ void blk_recalc_rq_segments(struct request *rq)
 			continue;
 		}
 new_segment:
-		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
+		if (hw_seg_size + bv->bv_len <= q->max_segment_size &&
+		    BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
 		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
 			hw_seg_size += bv->bv_len;
 		else {
-- 
1.5.5.GIT

