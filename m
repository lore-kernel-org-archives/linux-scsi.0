From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] scsi: relax PAGE LENGTH check for thin provisioning UNMAP support
Date: Wed,  5 May 2010 17:50:03 -0400
Message-ID: <1273096203-3164-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab0EEVuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 17:50:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>

Thin Provisioning fields are assumed available in the BLOCK LIMITS VPD
page if PAGE LENGTH is 0x3c.  The BLOCK LIMITS VPD page may be extended
over time.  Allow for the possibility that the PAGE LENGTH exceeds 0x3c.

Further details:
Linux SCSI defaults to using WRITE SAME(16) with UNMAP bit set for
discards.

If PAGE LENGTH is 0x3c and both MAXIMUM UNMAP LBA COUNT and MAXIMUM
UNMAP BLOCK DESCRIPTOR COUNT are set (in BLOCK LIMITS VPD page), Linux
SCSI will issue UNMAP instead of using the default (WRITE SAME(16) with
UNMAP bit set).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b827f3..40ab22e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1963,7 +1963,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			 get_unaligned_be32(&buffer[12]) * sector_sz);
 
 	/* Thin provisioning enabled and page length indicates TP support */
-	if (sdkp->thin_provisioning && buffer[3] == 0x3c) {
+	if (sdkp->thin_provisioning && buffer[3] >= 0x3c) {
 		unsigned int lba_count, desc_count, granularity;
 
 		lba_count = get_unaligned_be32(&buffer[20]);
-- 
1.6.6.1

