From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/3] sd: Block limits VPD support
Date: Sat, 23 May 2009 11:43:39 -0400
Message-ID: <1243093419-14371-4-git-send-email-martin.petersen@oracle.com>
References: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:36037 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZEWPnw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 May 2009 11:43:52 -0400
In-Reply-To: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Query the block limits VPD page and adjust queue minimum and optimal I/O
sizes.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2f3a78e..d4eb5a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1795,6 +1795,29 @@ void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 }
 
 /**
+ * sd_read_block_limits - Query disk device for preferred I/O sizes.
+ * @disk: disk to query
+ */
+static void sd_read_block_limits(struct scsi_disk *sdkp)
+{
+	unsigned int sector_sz = sdkp->device->sector_size;
+	char *buffer;
+
+	/* Block Limits VPD */
+	buffer = scsi_get_vpd_page(sdkp->device, 0xb0);
+
+	if (buffer == NULL)
+		return;
+
+	blk_queue_io_min(sdkp->disk->queue,
+			 get_unaligned_be16(&buffer[6]) * sector_sz);
+	blk_queue_io_opt(sdkp->disk->queue,
+			 get_unaligned_be32(&buffer[12]) * sector_sz);
+
+	kfree(buffer);
+}
+
+/**
  * sd_read_block_characteristics - Query block dev. characteristics
  * @disk: disk to query
  */
@@ -1854,6 +1877,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_read_block_limits(sdkp);
 		sd_read_block_characteristics(sdkp);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
-- 
1.6.0.6

