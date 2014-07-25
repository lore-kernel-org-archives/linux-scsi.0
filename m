From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06/14] block: Make protection interval calculation generic
Date: Fri, 25 Jul 2014 16:34:21 -0400
Message-ID: <1406320469-29352-7-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760932AbaGYUdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:40 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXdTF028192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:39 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s6PKXc5A017241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:38 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXcXZ014411
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:38 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Now that the protection interval has been detached from the sector size
we need to be able to handle sizes that are different from 4K and
512. Make the interval calculation generic.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/bio-integrity.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8c03c78281e9..320ce7df1a5f 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -203,11 +203,7 @@ EXPORT_SYMBOL(bio_integrity_enabled);
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

