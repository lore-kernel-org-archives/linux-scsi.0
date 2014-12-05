From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it isn't provided
Date: Fri,  5 Dec 2014 20:35:51 +0800
Message-ID: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57248 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLEMhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 07:37:32 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so614857pab.40
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2014 04:37:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>

The commit 7985090aa0201(sd: Disable discard_zeroes_data for UNMAP)
introduces regresion for QEMU SCSI.

QEMU SCSI device claims to support UNMAP, WRITE SAME and WRITE SAME
16 in LBP VPD page, but only provides "Maximum unmap LBA count"
in block limits VPD page, and "Maximum write same length" isn't set.

The default max_discard_sectors(SD_MAX_WS16_BLOCKS) can't work at
all since it is much bigger than the actual Maximum unmap LBA count.

This patch trys to fix the regression by setting 'max_ws_blocks'
as 'max_unmap_blocks' when block limits VPD page doesn't provide
"Maximum write same length" under the situation. This approach is
reasonable because device server supports the use of the WRITE
SAME or WRITE SAME 10 command to unmap LBAs when LBPWS or LBPWS10
is set in LBP VPD page.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/scsi/sd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fedab3c..2a69fee 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2624,6 +2624,14 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		} else {	/* LBP VPD page tells us what to use */
 
+			/*
+			 * Borrow max_unmap_blocks if max_ws_blocks isn't
+			 * provided from block limits VPD page
+			 */
+			if ((sdkp->lbpws10 || sdkp->lbpws) &&
+			    !sdkp->max_ws_blocks)
+				sdkp->max_ws_blocks = sdkp->max_unmap_blocks;
+
 			if (sdkp->lbpws)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 			else if (sdkp->lbpws10)
-- 
1.7.9.5

