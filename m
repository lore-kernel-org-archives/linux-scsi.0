From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] sd: Limit WRITE SAME / WRITE SAME(16) w/UNMAP length for certain devices
Date: Tue, 19 Sep 2017 12:14:21 -0400
Message-ID: <1505837661-2280-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48609 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750972AbdISQOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 12:14:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7999F267C0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2017 16:14:24 +0000 (UTC)
Received: from emilne.com (unknown [10.18.25.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34AA25D984
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2017 16:14:24 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Some devices do not support a WRITE SAME / WRITE SAME(16) with the UNMAP
bit set up to the length specified in the MAXIMUM WRITE SAME LENGTH field
in the block limits VPD page (or, the field is zero, indicating there is
no limit).  Limit the length by the MAXIMUM UNMAP LBA COUNT value.
Otherwise the command might be rejected.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6549e5c..fa07ac2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -693,6 +693,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
+	u32 max_ws_blocks = sdkp->max_ws_blocks;
 
 	q->limits.discard_alignment =
 		sdkp->unmap_alignment * logical_block_size;
@@ -701,6 +702,13 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		    sdkp->unmap_granularity * logical_block_size);
 	sdkp->provisioning_mode = mode;
 
+	/*
+	 * Some devices limit WRITE SAME / WRITE SAME(16) w/UNMAP
+	 * by MAXIMUM UNMAP LBA COUNT instead of MAXIMUM WRITE SAME LENGTH.
+	 * Use the smaller of the two values to avoid ILLEGAL REQUEST errors.
+	 */
+	max_ws_blocks = min_not_zero(max_ws_blocks, sdkp->max_unmap_blocks);
+
 	switch (mode) {
 
 	case SD_LBP_FULL:
@@ -715,17 +723,17 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 
 	case SD_LBP_WS16:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+		max_blocks = min_not_zero(max_ws_blocks,
 					  (u32)SD_MAX_WS16_BLOCKS);
 		break;
 
 	case SD_LBP_WS10:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+		max_blocks = min_not_zero(max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
 		break;
 
 	case SD_LBP_ZERO:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+		max_blocks = min_not_zero(max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
 		break;
 	}
-- 
2.1.0
