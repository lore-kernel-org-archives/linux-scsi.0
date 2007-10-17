From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swiotlb: fix map_sg failure handling
Date: Wed, 17 Oct 2007 17:03:29 +0900
Message-ID: <20071017170329B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:62596 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbXJQIDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 04:03:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

sg list elements might not be continuous.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index c419ecf..752fd95 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -696,7 +696,7 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				swiotlb_full(hwdev, sg->length, dir, 0);
-				swiotlb_unmap_sg(hwdev, sg - i, i, dir);
+				swiotlb_unmap_sg(hwdev, sgl, i, dir);
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-- 
1.5.2.4

