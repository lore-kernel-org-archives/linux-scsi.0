From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 14/17] Preserve all 8 bytes of LUN ID for logical
	drives.
Date: Thu, 20 Aug 2009 10:18:54 -0500
Message-ID: <20090820151854.22833.58786.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754816AbZHTPSz@vger.kernel.org>
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Preserve all 8 bytes of the LunID field returned
by CCISS_REPORT_LOGICAL instead of only saving 4 bytes.
This fixes a bug with logical volume addressing encountered on
an MSA2012.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   48 ++++++++++++++++++++++++------------------------
 drivers/block/cciss.h |    2 +-
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 239c4f5..56eeb68 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -845,7 +845,8 @@ static int cciss_open(struct block_device *bdev, fmode_t mode)
 			if (MINOR(bdev->bd_dev) & 0x0f) {
 				return -ENXIO;
 				/* if it is, make sure we have a LUN ID */
-			} else if (drv->LunID == 0) {
+			} else if (memcmp(drv->LunID, CTLR_LUNID,
+				sizeof(drv->LunID))) {
 				return -ENXIO;
 			}
 		}
@@ -1215,7 +1216,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETLUNINFO:{
 			LogvolInfo_struct luninfo;
 
-			luninfo.LunID = drv->LunID;
+			memcpy(&luninfo.LunID, drv->LunID,
+				sizeof(luninfo.LunID));
 			luninfo.num_opens = drv->usage_count;
 			luninfo.num_parts = 0;
 			if (copy_to_user(argp, &luninfo,
@@ -1610,13 +1612,11 @@ static void cciss_softirq_done(struct request *rq)
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
-static void log_unit_to_scsi3addr(ctlr_info_t *h, unsigned char scsi3addr[],
-	uint32_t log_unit)
+static inline void log_unit_to_scsi3addr(ctlr_info_t *h,
+	unsigned char scsi3addr[], uint32_t log_unit)
 {
-	log_unit = h->drv[log_unit].LunID & 0x03fff;
-	memset(&scsi3addr[4], 0, 4);
-	memcpy(&scsi3addr[0], &log_unit, 4);
-	scsi3addr[3] |= 0x40;
+	memcpy(scsi3addr, h->drv[log_unit].LunID,
+		sizeof(h->drv[log_unit].LunID));
 }
 
 /* This function gets the SCSI vendor, model, and revision of a logical drive
@@ -1923,7 +1923,8 @@ static void cciss_free_gendisk(ctlr_info_t *h, int drv_index)
  * a means to talk to the controller in case no logical
  * drives have yet been configured.
  */
-static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
+static int cciss_add_gendisk(ctlr_info_t *h, unsigned char lunid[],
+	int controller_node)
 {
 	int drv_index;
 
@@ -1942,7 +1943,8 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 			return -1;
 		}
 	}
-	h->drv[drv_index].LunID = lunid;
+	memcpy(h->drv[drv_index].LunID, lunid,
+		sizeof(h->drv[drv_index].LunID));
 	if (h->drv[drv_index].dev == NULL) {
 		if (cciss_create_ld_sysfs_entry(h, drv_index))
 			goto err_free_disk;
@@ -1972,7 +1974,7 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 	if (h->gendisk[0] != NULL) /* already did this? Then bail. */
 		return;
 
-	drv_index = cciss_add_gendisk(h, 0, 1);
+	drv_index = cciss_add_gendisk(h, CTLR_LUNID, 1);
 	if (drv_index == -1)
 		goto error;
 	h->drv[drv_index].block_size = 512;
@@ -2011,7 +2013,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 	int i;
 	int drv_found;
 	int drv_index = 0;
-	__u32 lunid = 0;
+	unsigned char lunid[8] = CTLR_LUNID;
 	unsigned long flags;
 
 	if (!capable(CAP_SYS_RAWIO))
@@ -2068,9 +2070,9 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 			continue;
 
 		for (j = 0; j < num_luns; j++) {
-			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
-			lunid = le32_to_cpu(lunid);
-			if (h->drv[i].LunID == lunid) {
+			memcpy(lunid, &ld_buff->LUN[j][0], sizeof(lunid));
+			if (memcmp(h->drv[i].LunID, lunid,
+				sizeof(lunid)) == 0) {
 				drv_found = 1;
 				break;
 			}
@@ -2095,9 +2097,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 
 		drv_found = 0;
 
-		memcpy(&lunid, &ld_buff->LUN[i][0], 4);
-		lunid = le32_to_cpu(lunid);
-
+		memcpy(lunid, &ld_buff->LUN[i][0], sizeof(lunid));
 		/* Find if the LUN is already in the drive array
 		 * of the driver.  If so then update its info
 		 * if not in use.  If it does not exist then find
@@ -2105,7 +2105,8 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 		 */
 		for (j = 0; j <= h->highest_lun; j++) {
 			if (h->drv[j].raid_level != -1 &&
-				h->drv[j].LunID == lunid) {
+				memcmp(h->drv[j].LunID, lunid,
+					sizeof(h->drv[j].LunID)) == 0) {
 				drv_index = j;
 				drv_found = 1;
 				break;
@@ -2253,8 +2254,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 			}
 			h->highest_lun = newhighest;
 		}
-
-		drv->LunID = 0;
+		memset(drv->LunID, 0, sizeof(drv->LunID));
 	}
 	return 0;
 }
@@ -2685,7 +2685,8 @@ static int cciss_revalidate(struct gendisk *disk)
 	InquiryData_struct *inq_buff = NULL;
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
-		if (h->drv[logvol].LunID == drv->LunID) {
+		if (memcmp(h->drv[logvol].LunID, drv->LunID,
+			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;
 			break;
 		}
@@ -3170,8 +3171,7 @@ static void do_cciss_request(struct request_queue *q)
 	/* The first 2 bits are reserved for controller error reporting. */
 	c->Header.Tag.lower = (c->cmdindex << 3);
 	c->Header.Tag.lower |= 0x04;	/* flag for direct lookup. */
-	c->Header.LUN.LogDev.VolId = drv->LunID;
-	c->Header.LUN.LogDev.Mode = 1;
+	memcpy(&c->Header.LUN, drv->LunID, sizeof(drv->LunID));
 	c->Request.CDBLen = 10;	// 12 byte commands not in FW yet;
 	c->Request.Type.Type = TYPE_CMD;	// It is a command.
 	c->Request.Type.Attribute = ATTR_SIMPLE;
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 9679342..5188f71 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -30,7 +30,7 @@ struct access_method {
 };
 typedef struct _drive_info_struct
 {
- 	__u32   LunID;	
+	unsigned char LunID[8];
 	int 	usage_count;
 	struct request_queue *queue;
 	sector_t nr_blocks;
