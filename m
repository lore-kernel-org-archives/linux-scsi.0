From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Fix discard granularity when LBPRZ=1
Date: Sat,  5 Mar 2016 18:10:21 -0500
Message-ID: <1457219421-836-1-git-send-email-martin.petersen@oracle.com>
References: <20160304152409.GA31358@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35107 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbcCEXKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2016 18:10:34 -0500
In-Reply-To: <20160304152409.GA31358@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: snitzer@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org#4.4+

Commit 397737223c59 ("sd: Make discard granularity match logical block
size when LBPRZ=1") accidentally set the granularity to one byte instead
of one logical block on devices that provide determistic zeroes after
UNMAP.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Mike Snitzer <snitzer@redhat.com>
Fixes: 397737223c59e89dca7305feb6528caef8fbef84
Cc: <stable@vger.kernel.org> # 4.4+
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d749da765df1..5a5457ac9cdb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -648,7 +648,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	 */
 	if (sdkp->lbprz) {
 		q->limits.discard_alignment = 0;
-		q->limits.discard_granularity = 1;
+		q->limits.discard_granularity = logical_block_size;
 	} else {
 		q->limits.discard_alignment = sdkp->unmap_alignment *
 			logical_block_size;
-- 
2.7.0

