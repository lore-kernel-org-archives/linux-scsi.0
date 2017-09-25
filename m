From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 07/14] scsi: sd_zbc: Initialize device request queue zoned data
Date: Mon, 25 Sep 2017 15:14:47 +0900
Message-ID: <20170925061454.5533-8-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Initialize the seq_zone_bitmap and nr_zones fields of the disk request
queue on disk revalidate. As the seq_zone_bitmap allocation is
identical to the allocation of the zone write lock bitmap, introduce
the helper sd_zbc_alloc_zone_bitmap(). Using this helper, wait for the
disk capacity and number of zones to stabilize on the second
revalidation pass to allocate and initialize the bitmaps.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 144 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 139 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 27793b9f54c0..cc64fada9cd9 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -586,8 +586,127 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
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
+ * @zno: Zone number of the first zone in the report
+ *
+ * Parse reported zone descriptors to find sequiential zones.
+ * Since read-only and offline zones cannot be written, do not
+ * mark them as sequential in the bitmap.
+ * Return the LBA after the last zone reported.
+ */
+static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
+				     unsigned int buflen,
+				     unsigned long *seq_zone_bitmap,
+				     unsigned int *zno)
+{
+	sector_t last_lba = sdkp->capacity;
+	unsigned int buf_len, list_length;
+	unsigned int n = *zno;
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
+		if (type != ZBC_ZONE_TYPE_CONV &&
+		    cond != ZBC_ZONE_COND_READONLY &&
+		    cond != ZBC_ZONE_COND_OFFLINE)
+			set_bit(n, seq_zone_bitmap);
+		last_lba = get_unaligned_be64(&rec[8]) +
+			get_unaligned_be64(&rec[16]);
+		rec += 64;
+		n++;
+	}
+
+	*zno = n;
+
+	return last_lba;
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
+	unsigned int n = 0;
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
+					   seq_zone_bitmap, &n);
+	}
+
+	if (n != sdkp->nr_zones) {
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
@@ -599,14 +718,29 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
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
 
@@ -661,14 +795,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
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
