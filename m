From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block: Ensure we only enable integrity metadata for reads and writes
Date: Tue,  8 Apr 2014 22:59:31 -0400
Message-ID: <1397012371-15272-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaDIC7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 22:59:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

We'd occasionally attempt to generate protection information for flushes
and other requests with a zero payload. Make sure we only attempt to
enable integrity for reads and writes.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 183f1ae74675..812920dbf5f9 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -182,6 +182,9 @@ static int bdev_integrity_enabled(struct block_device *bdev, int rw)
  */
 int bio_integrity_enabled(struct bio *bio)
 {
+	if (!bio_is_rw(bio))
+		return 0;
+
 	/* Already protected? */
 	if (bio_integrity(bio))
 		return 0;
-- 
1.8.3.1

