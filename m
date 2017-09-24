From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 07/16] scsi: sd_zbc: Initialize device request queue zoned data
Date: Sun, 24 Sep 2017 16:02:38 +0900
Message-ID: <20170924070247.25560-8-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22595 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdIXHDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:01 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Initialize the seq_zones bitmap and nr_zones field of the disk request
queue on disk revalidate. As the seq_zones bitmap allocation is
identical to the allocation of the zone write lock bitmap, introduce
the helper sd_zbc_alloc_zone_bitmap(). Using this helper, wait for the
disk capacity and number of zones to stabilize on the second
revalidation pass to allocate and initialize the bitmaps.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 130 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 124 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 27793b9f54c0..50340c9d265b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -586,8 +586,110 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
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
+ * sd_zbc_setup_seq_zones - Initialize the disk request queue zone type bitmap.
+ * @sdkp: The disk of the bitmap
+ *
+ * Allocate a zone bitmap and initialize it by identifying sequential zones.
+ */
+static int sd_zbc_setup_seq_zones(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned long *seq_zones;
+	sector_t block = 0;
+	unsigned char *buf;
+	unsigned char *rec;
+	unsigned int buf_len;
+	unsigned int list_length;
+	unsigned int n = 0;
+	u8 type, cond;
+	int ret = -ENOMEM;
+
+	kfree(q->seq_zones);
+	q->seq_zones = NULL;
+
+	seq_zones = sd_zbc_alloc_zone_bitmap(sdkp);
+	if (!seq_zones)
+		return -ENOMEM;
+
+	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	while (block < sdkp->capacity) {
+
+		ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, block);
+		if (ret)
+			goto out;
+
+		/*
+		 * Parse reported zone descriptors to find sequiential zones.
+		 * Since read-only and offline zones cannot be written, do not
+		 * mark them as sequential in the bitmap.
+		 */
+		list_length = get_unaligned_be32(&buf[0]) + 64;
+		rec = buf + 64;
+		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
+		while (rec < buf + buf_len) {
+			type = rec[0] & 0x0f;
+			cond = (rec[1] >> 4) & 0xf;
+			if (type != ZBC_ZONE_TYPE_CONV &&
+			    cond != ZBC_ZONE_COND_READONLY &&
+			    cond != ZBC_ZONE_COND_OFFLINE)
+				set_bit(n, seq_zones);
+			block = get_unaligned_be64(&rec[8]) +
+				get_unaligned_be64(&rec[16]);
+			rec += 64;
+			n++;
+		}
+
+	}
+
+	if (n != sdkp->nr_zones) {
+		/* Something was wrong */
+		ret = -EIO;
+	}
+
+out:
+	kfree(buf);
+	if (ret) {
+		kfree(seq_zones);
+		return ret;
+	}
+
+	q->seq_zones = seq_zones;
+
+	return 0;
+}
+
+static void sd_zbc_cleanup(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+
+	kfree(q->seq_zones);
+	q->seq_zones = NULL;
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
@@ -599,14 +701,30 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	sdkp->nr_zones =
 		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
 
-	if (!sdkp->zones_wlock) {
-		sdkp->zones_wlock = kcalloc(BITS_TO_LONGS(sdkp->nr_zones),
-					    sizeof(unsigned long),
-					    GFP_KERNEL);
+	/*
+	 * Wait for the disk capacity to stabilize before
+	 * initializing zone related information.
+	 */
+	if (sdkp->first_scan)
+		return 0;
+
+	if (!sdkp->zones_wlock || q->nr_zones != sdkp->nr_zones) {
+		kfree(sdkp->zones_wlock);
+		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
 			return -ENOMEM;
 	}
 
+	if (!q->seq_zones || q->nr_zones != sdkp->nr_zones) {
+		ret = sd_zbc_setup_seq_zones(sdkp);
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
 
@@ -661,14 +779,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
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
2.13.5
