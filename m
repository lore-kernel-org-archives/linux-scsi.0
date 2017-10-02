From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 07/14] scsi: sd_zbc: Initialize device request queue zoned data
Date: Mon,  2 Oct 2017 16:15:28 +0900
Message-ID: <20171002071535.8007-8-damien.lemoal@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22502 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdJBHPp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 03:15:45 -0400
In-Reply-To: <20171002071535.8007-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Initialize the seq_zone_bitmap and nr_zones fields of the disk request
queue on disk revalidate. As the seq_zone_bitmap allocation is
identical to the allocation of the zone write lock bitmap, introduce
the helper sd_zbc_alloc_zone_bitmap(). Using this helper, wait for the
disk capacity and number of zones to stabilize on the second
revalidation pass to allocate and initialize the bitmaps.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 133 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 27793b9f54c0..4ccb20074cb3 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -586,8 +586,121 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	return 0;
 }
 
+/**
+ * sd_zbc_alloc_zone_bitmap - Allocate a zone bitmap (one bit per zone).
+ * @sdkp: The disk of the bitmap
+ */
+static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+
+	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
+			    * sizeof(unsigned long),
+			    GFP_KERNEL, q->node);
+}
+
+/**
+ * sd_zbc_get_seq_zones - Parse report zones reply to identify sequential zones
+ * @sdkp: disk used
+ * @buf: report reply buffer
+ * @seq_zone_bitamp: bitmap of sequential zones to set
+ *
+ * Parse reported zone descriptors in @buf to identify sequential zones and
+ * set the reported zone bit in @seq_zone_bitmap accordingly.
+ * Since read-only and offline zones cannot be written, do not
+ * mark them as sequential in the bitmap.
+ * Return the LBA after the last zone reported.
+ */
+static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
+				     unsigned int buflen,
+				     unsigned long *seq_zone_bitmap)
+{
+	sector_t lba, next_lba = sdkp->capacity;
+	unsigned int buf_len, list_length;
+	unsigned char *rec;
+	u8 type, cond;
+
+	list_length = get_unaligned_be32(&buf[0]) + 64;
+	buf_len = min(list_length, buflen);
+	rec = buf + 64;
+
+	while (rec < buf + buf_len) {
+		type = rec[0] & 0x0f;
+		cond = (rec[1] >> 4) & 0xf;
+		lba = get_unaligned_be64(&rec[16]);
+		if (type != ZBC_ZONE_TYPE_CONV &&
+		    cond != ZBC_ZONE_COND_READONLY &&
+		    cond != ZBC_ZONE_COND_OFFLINE)
+			set_bit(lba >> sdkp->zone_shift, seq_zone_bitmap);
+		next_lba = lba + get_unaligned_be64(&rec[8]);
+		rec += 64;
+	}
+
+	return next_lba;
+}
+
+/**
+ * sd_zbc_setup_seq_zone_bitmap - Initialize the disk seq zone bitmap.
+ * @sdkp: target disk
+ *
+ * Allocate a zone bitmap and initialize it by identifying sequential zones.
+ */
+static int sd_zbc_setup_seq_zone_bitmap(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned long *seq_zone_bitmap;
+	sector_t lba = 0;
+	unsigned char *buf;
+	int ret = -ENOMEM;
+
+	seq_zone_bitmap = sd_zbc_alloc_zone_bitmap(sdkp);
+	if (!seq_zone_bitmap)
+		return -ENOMEM;
+
+	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	while (lba < sdkp->capacity) {
+		ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, lba);
+		if (ret)
+			goto out;
+		lba = sd_zbc_get_seq_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
+					   seq_zone_bitmap);
+	}
+
+	if (lba != sdkp->capacity) {
+		/* Something went wrong */
+		ret = -EIO;
+	}
+
+out:
+	kfree(buf);
+	if (ret) {
+		kfree(seq_zone_bitmap);
+		return ret;
+	}
+
+	q->seq_zone_bitmap = seq_zone_bitmap;
+
+	return 0;
+}
+
+static void sd_zbc_cleanup(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+
+	kfree(q->seq_zone_bitmap);
+	q->seq_zone_bitmap = NULL;
+
+	kfree(sdkp->zones_wlock);
+	sdkp->zones_wlock = NULL;
+}
+
 static int sd_zbc_setup(struct scsi_disk *sdkp)
 {
+	struct request_queue *q = sdkp->disk->queue;
+	int ret;
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
@@ -599,14 +712,29 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	sdkp->nr_zones =
 		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
 
+	/*
+	 * Wait for the disk capacity to stabilize before
+	 * initializing zone related information.
+	 */
+	if (sdkp->first_scan)
+		return 0;
+
 	if (!sdkp->zones_wlock) {
-		sdkp->zones_wlock = kcalloc(BITS_TO_LONGS(sdkp->nr_zones),
-					    sizeof(unsigned long),
-					    GFP_KERNEL);
+		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
 			return -ENOMEM;
 	}
 
+	if (!q->seq_zone_bitmap) {
+		ret = sd_zbc_setup_seq_zone_bitmap(sdkp);
+		if (ret) {
+			sd_zbc_cleanup(sdkp);
+			return ret;
+		}
+	}
+
+	q->nr_zones = sdkp->nr_zones;
+
 	return 0;
 }
 
@@ -661,14 +789,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 err:
 	sdkp->capacity = 0;
+	sd_zbc_cleanup(sdkp);
 
 	return ret;
 }
 
 void sd_zbc_remove(struct scsi_disk *sdkp)
 {
-	kfree(sdkp->zones_wlock);
-	sdkp->zones_wlock = NULL;
+	sd_zbc_cleanup(sdkp);
 }
 
 void sd_zbc_print_zones(struct scsi_disk *sdkp)
-- 
2.13.6
