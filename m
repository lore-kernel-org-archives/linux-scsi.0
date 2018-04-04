From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] sd_zbc: Avoid errors due to sd_zbc_setup() execution
Date: Wed,  4 Apr 2018 17:54:18 +0900
Message-ID: <20180404085418.29205-3-damien.lemoal@wdc.com>
References: <20180404085418.29205-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404085418.29205-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@wdc.com>

Since SCSI scanning occurs asynchronously, since sd_revalidate_disk()
is called from sd_probe_async() and since sd_revalidate_disk() calls
sd_zbc_read_zones() it can happen that sd_zbc_read_zones() is called
concurrently with operations referencing a drive zone bitmaps and number
of zones. Make sure that this race does not cause failures when
revalidate does not detect any change by making the following changes to
sd_zbc_setup():
- Ensure that sd_zbc_setup_seq_zones_bitmap() does not change any
  ZBC metadata in the request queue.
- Only modify the ZBC information in the request queue that has
  changed. If the number of zones has changed, update q->nr_zones,
  q->seq_zones_wlock and q->seq_zones_bitmap. If the type of some
  zones has changed but not the number of zones, only update the
  zone type information.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
[Damien] Updated commit message and changed nr_zones/bitmap swap order.
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/sd_zbc.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index b59454ed5087..39ddbe92769c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -551,14 +551,13 @@ static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
 }
 
 /**
- * sd_zbc_setup_seq_zones_bitmap - Initialize the disk seq zone bitmap.
+ * sd_zbc_setup_seq_zones_bitmap - Initialize a seq zone bitmap.
  * @sdkp: target disk
  *
  * Allocate a zone bitmap and initialize it by identifying sequential zones.
  */
-static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
+static unsigned long *sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
 {
-	struct request_queue *q = sdkp->disk->queue;
 	unsigned long *seq_zones_bitmap;
 	sector_t lba = 0;
 	unsigned char *buf;
@@ -566,7 +565,7 @@ static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
 
 	seq_zones_bitmap = sd_zbc_alloc_zone_bitmap(sdkp);
 	if (!seq_zones_bitmap)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -589,12 +588,9 @@ static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
 	kfree(buf);
 	if (ret) {
 		kfree(seq_zones_bitmap);
-		return ret;
+		return ERR_PTR(ret);
 	}
-
-	q->seq_zones_bitmap = seq_zones_bitmap;
-
-	return 0;
+	return seq_zones_bitmap;
 }
 
 static void sd_zbc_cleanup(struct scsi_disk *sdkp)
@@ -630,24 +626,37 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	 * of zones changed.
 	 */
 	if (sdkp->nr_zones != q->nr_zones) {
+		struct request_queue *q = sdkp->disk->queue;
+		unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
+		size_t zone_bitmap_size;
 
-		sd_zbc_cleanup(sdkp);
-
-		q->nr_zones = sdkp->nr_zones;
 		if (sdkp->nr_zones) {
-			q->seq_zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
-			if (!q->seq_zones_wlock) {
+			seq_zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
+			if (!seq_zones_wlock) {
 				ret = -ENOMEM;
 				goto err;
 			}
 
-			ret = sd_zbc_setup_seq_zones_bitmap(sdkp);
-			if (ret) {
-				sd_zbc_cleanup(sdkp);
+			seq_zones_bitmap = sd_zbc_setup_seq_zones_bitmap(sdkp);
+			if (IS_ERR(seq_zones_bitmap)) {
+				ret = PTR_ERR(seq_zones_bitmap);
+				kfree(seq_zones_wlock);
 				goto err;
 			}
 		}
-
+		zone_bitmap_size = BITS_TO_LONGS(sdkp->nr_zones) *
+			sizeof(unsigned long);
+		if (q->nr_zones != sdkp->nr_zones) {
+			swap(q->seq_zones_wlock, seq_zones_wlock);
+			swap(q->seq_zones_bitmap, seq_zones_bitmap);
+			q->nr_zones = sdkp->nr_zones;
+		} else if (memcmp(q->seq_zones_bitmap, seq_zones_bitmap,
+				  zone_bitmap_size) != 0) {
+			memcpy(q->seq_zones_bitmap, seq_zones_bitmap,
+			       zone_bitmap_size);
+		}
+		kfree(seq_zones_wlock);
+		kfree(seq_zones_bitmap);
 	}
 
 	return 0;
-- 
2.14.3
