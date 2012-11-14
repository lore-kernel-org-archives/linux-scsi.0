From: "Jason J. Herne" <hernejj@gmail.com>
Subject: [PATCH] Use SCSI read/write(16) with >2TB drives
Date: Tue, 13 Nov 2012 19:54:13 -0500
Message-ID: <1352854453-3781-1-git-send-email-hernejj@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52587 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab2KNAyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2012 19:54:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org, pbonzini@redhat.com, JBottomley@parallels.com, stern@rowland.harvard.edu, "Jason J. Herne" <hernejj@gmail.com>

From: "Jason J. Herne" <hernejj@gmail.com>

Force large capacity (> 2TB) drives to use READ/WRITE(16) instead of
READ/WRITE(10). Some(most/all?) USB enclosures do not like READ(10) commands
when a large capacity drive is installed.

Signed-off-by: Jason J. Herne <hernejj@gmail.com>
---
 drivers/scsi/sd.c          |    5 ++++-
 include/scsi/scsi_device.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..0790f69 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -887,7 +887,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (block > 0xffffffff) {
+	} else if (sdp->use_16_for_rw) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
@@ -2067,6 +2067,9 @@ got_data:
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
+
+	/* Use read/write(16) for > 2TB disks */
+	sdp->use_16_for_rw = (sdkp->capacity > 0xffffffff);
 }
 
 /* called with buffer of length 512 */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 88fae8d..19ab8f1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -135,6 +135,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
-- 
1.7.9.5

