From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Unmap discard alignment needs to be converted to bytes
Date: Wed, 18 May 2011 00:31:07 -0400
Message-ID: <yq1y624fx4k.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:20910 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1EREbU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 00:31:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org


The block layer discard alignment is reported in bytes, not in units of
the logical block size.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd0806e..1c69c14 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -490,7 +490,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int max_blocks = 0;
 
 	q->limits.discard_zeroes_data = sdkp->lbprz;
-	q->limits.discard_alignment = sdkp->unmap_alignment;
+	q->limits.discard_alignment = sdkp->unmap_alignment *
+		logical_block_size;
 	q->limits.discard_granularity =
 		max(sdkp->physical_block_size,
 		    sdkp->unmap_granularity * logical_block_size);
