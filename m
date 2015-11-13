From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] sd: Make discard granularity match logical block size when LBPRZ=1
Date: Fri, 13 Nov 2015 16:46:47 -0500
Message-ID: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34409 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbKMVrD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2015 16:47:03 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tADLl2x3011521
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 21:47:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tADLl10k005358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 21:47:02 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tADLl1mT011249
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 21:47:01 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

A device may report an OPTIMAL UNMAP GRANULARITY and UNMAP GRANULARITY
ALIGNMENT in the Block Limits VPD. These parameters describe the
device's internal provisioning allocation units. By default the block
layer will round and align any discard requests based on these limits.

If a device reports LBPRZ=1 to guarantee zeroes after discard, however,
it is imperative that the block layer does not leave out any parts of
the requested block range. Otherwise the device can not do the required
zeroing of any partial allocation units and this can lead to data
corruption.

Since the dm thinp personality relies on the block layer's current
behavior and is unable to deal with partial discard blocks we work
around the problem by setting the granularity to match the logical block
size when LBPRZ is enabled.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f370228bf31..c322969026bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -636,11 +636,24 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int max_blocks = 0;
 
 	q->limits.discard_zeroes_data = 0;
-	q->limits.discard_alignment = sdkp->unmap_alignment *
-		logical_block_size;
-	q->limits.discard_granularity =
-		max(sdkp->physical_block_size,
-		    sdkp->unmap_granularity * logical_block_size);
+
+	/*
+	 * When LBPRZ is reported, discard alignment and granularity
+	 * must be fixed to the logical block size. Otherwise the block
+	 * layer will drop misaligned portions of the request which can
+	 * lead to data corruption. If LBPRZ is not set, we honor the
+	 * device preference.
+	 */
+	if (sdkp->lbprz) {
+		q->limits.discard_alignment = 0;
+		q->limits.discard_granularity = 1;
+	} else {
+		q->limits.discard_alignment = sdkp->unmap_alignment *
+			logical_block_size;
+		q->limits.discard_granularity =
+			max(sdkp->physical_block_size,
+			    sdkp->unmap_granularity * logical_block_size);
+	}
 
 	sdkp->provisioning_mode = mode;
 
-- 
2.4.3

