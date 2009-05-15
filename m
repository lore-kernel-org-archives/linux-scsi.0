From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10/13] sd: Block limits VPD support
Date: Fri, 15 May 2009 00:40:32 -0400
Message-ID: <1242362435-11953-11-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Query the block limits VPD page and adjust queue minimum and optimal I/O
sizes.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ee61136..6bdf931 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1801,6 +1801,29 @@ void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
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
@@ -1860,6 +1883,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_read_block_limits(sdkp);
 		sd_read_block_characteristics(sdkp);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
-- 
1.6.0.6

