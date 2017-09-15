From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 09/12] scsi: sd_zbc: Initialize device queue zoned structure
Date: Fri, 15 Sep 2017 19:06:42 +0900
Message-ID: <20170915100645.17999-10-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Allocate and initialize the disk request queue zoned structure on disk
revalidate. As the bitmap allocation for the seq_zones field of the
zoned structure is identical to the allocation of the zones write lock
bitmap, introduce the helper sd_zbc_alloc_zone_bitmap().
Using this helper, wait for the disk capacity and number of zones to
stabilize on the second revalidation pass to allocate and initialize
the bitmaps.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 114 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7e30d0c22930..534e747e8bcf 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -534,8 +534,103 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	return 0;
 }
 
+/*
+ * Allocate a zone bitmap (one bit per zone).
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
+/*
+ * Initialize the seq_zones bitmap to allow identifying sequential zones.
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
+	q->zoned.seq_zones = seq_zones;
+
+	return 0;
+}
+
+static void sd_zbc_cleanup(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+
+	kfree(q->zoned.seq_zones);
+	q->zoned.seq_zones = NULL;
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
@@ -547,14 +642,28 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
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
 
+	q->zoned.nr_zones = sdkp->nr_zones;
+	if (!q->zoned.seq_zones) {
+		ret = sd_zbc_setup_seq_zones(sdkp);
+		if (ret) {
+			sd_zbc_cleanup(sdkp);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -609,14 +718,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
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
