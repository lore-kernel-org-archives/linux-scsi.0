From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06/14] block: Make protection interval calculation generic
Date: Thu, 28 Aug 2014 15:31:24 -0400
Message-ID: <1409254292-2540-7-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaH1Tah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:37 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

Now that the protection interval has been detached from the sector size
we need to be able to handle sizes that are different from 4K and
512. Make the interval calculation generic.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a2b3e994b55b..396244b1e774 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -197,11 +197,7 @@ EXPORT_SYMBOL(bio_integrity_enabled);
 static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
 						   unsigned int sectors)
 {
-	/* At this point there are only 512b or 4096b DIF/EPP devices */
-	if (bi->interval == 4096)
-		return sectors >>= 3;
-
-	return sectors;
+	return sectors >> (ilog2(bi->interval) - 9);
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
-- 
1.9.3

