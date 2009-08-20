From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 11/17] Fix usage_count check in rebuild_lun_table when
	triggered via sysfs.
Date: Thu, 20 Aug 2009 10:18:38 -0500
Message-ID: <20090820151838.22833.24533.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754668AbZHTPSj@vger.kernel.org>
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

When rebuild_lun_table is reached via sysfs, the usage count that
is checked prior to messing with c0d0 has different constraints
(must be zero) than if rebuild_lun_table is reached via ioctl
(must be one.)  Fix rebuild_lun_table to take that into account.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8cd2f8e..14d4cd6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -169,9 +169,9 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static int cciss_revalidate(struct gendisk *disk);
-static int rebuild_lun_table(ctlr_info_t *h, int first_time);
+static int rebuild_lun_table(ctlr_info_t *h, int first_time, int via_ioctl);
 static int deregister_disk(ctlr_info_t *h, int drv_index,
-			   int clear_all);
+			   int clear_all, int via_ioctl);
 
 static void cciss_read_capacity(int ctlr, int logvol, int withirq,
 			sector_t *total_size, unsigned int *block_size);
@@ -1210,7 +1210,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_DEREGDISK:
 	case CCISS_REGNEWD:
 	case CCISS_REVALIDVOLS:
-		return rebuild_lun_table(host, 0);
+		return rebuild_lun_table(host, 0, 1);
 
 	case CCISS_GETLUNINFO:{
 			LogvolInfo_struct luninfo;
@@ -1756,7 +1756,8 @@ init_queue_failure:
  * is also the controller node.  Any changes to disk 0 will show up on
  * the next reboot.
  */
-static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
+static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
+	int via_ioctl)
 {
 	ctlr_info_t *h = hba[ctlr];
 	struct gendisk *disk;
@@ -1834,7 +1835,7 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 		 * which keeps the interrupt handler from starting
 		 * the queue.
 		 */
-		ret = deregister_disk(h, drv_index, 0);
+		ret = deregister_disk(h, drv_index, 0, via_ioctl);
 		h->drv[drv_index].busy_configuring = 0;
 	}
 
@@ -1999,7 +2000,8 @@ error:
  * INPUT
  * h		= The controller to perform the operations on
  */
-static int rebuild_lun_table(ctlr_info_t *h, int first_time)
+static int rebuild_lun_table(ctlr_info_t *h, int first_time,
+	int via_ioctl)
 {
 	int ctlr = h->ctlr;
 	int num_luns;
@@ -2078,7 +2080,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 			spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-			return_code = deregister_disk(h, i, 1);
+			return_code = deregister_disk(h, i, 1, via_ioctl);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -2116,7 +2118,8 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 			if (drv_index == -1)
 				goto freeret;
 		}
-		cciss_update_drive_info(ctlr, drv_index, first_time);
+		cciss_update_drive_info(ctlr, drv_index, first_time,
+			via_ioctl);
 	}		/* end for */
 
 freeret:
@@ -2166,9 +2169,15 @@ static void cciss_clear_drive_info(drive_info_struct *drive_info)
  *             the disk in preparation for re-adding it.  In this case
  *             the highest_lun should be left unchanged and the LunID
  *             should not be cleared.
+ * via_ioctl
+ *    This indicates whether we've reached this path via ioctl.
+ *    This affects the maximum usage count allowed for c0d0 to be messed with.
+ *    If this path is reached via ioctl(), then the max_usage_count will
+ *    be 1, as the process calling ioctl() has got to have the device open.
+ *    If we get here via sysfs, then the max usage count will be zero.
 */
 static int deregister_disk(ctlr_info_t *h, int drv_index,
-			   int clear_all)
+			   int clear_all, int via_ioctl)
 {
 	int i;
 	struct gendisk *disk;
@@ -2182,7 +2191,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 
 	/* make sure logical volume is NOT is use */
 	if (clear_all || (h->gendisk[0] == disk)) {
-		if (drv->usage_count > 1)
+		if (drv->usage_count > via_ioctl)
 			return -EBUSY;
 	} else if (drv->usage_count > 0)
 		return -EBUSY;
@@ -3451,7 +3460,7 @@ static int scan_thread(void *data)
 			mutex_unlock(&scan_mutex);
 
 			if (h) {
-				rebuild_lun_table(h, 0);
+				rebuild_lun_table(h, 0, 0);
 				complete_all(&h->scan_wait);
 				mutex_lock(&scan_mutex);
 				h->busy_scanning = 0;
@@ -4251,7 +4260,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	hba[i]->cciss_max_sectors = 2048;
 
-	rebuild_lun_table(hba[i], 1);
+	rebuild_lun_table(hba[i], 1, 0);
 	hba[i]->busy_initializing = 0;
 	return 1;
 
