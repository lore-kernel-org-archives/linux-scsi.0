From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] sd_zbc: Fix handling of ZBC read after write pointer
Date: Tue, 19 Jul 2016 15:25:10 +0200
Message-ID: <1468934710-93876-6-git-send-email-hare@suse.de>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbcGSNZP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:25:15 -0400
In-Reply-To: <1468934710-93876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>

From: Damien Le Moal <damien.lemoal@hgst.com>

For read requests beyond a sequential write required
zone write pointer, zero-out the request buffer and
directly complete the command. For read requests
straddling the write pointer position, limit the
request size to the number of valid sectors. The
remaining will be processed as a second request
and the buffer zeroed out.

Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 drivers/scsi/sd.c     |  4 ++--
 drivers/scsi/sd.h     |  4 ++--
 drivers/scsi/sd_zbc.c | 33 +++++++++++++++++++++++++++------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3a9d96e..4b704b0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -881,7 +881,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
 		/* sd_zbc_setup_read_write uses block layer sector units */
-		ret = sd_zbc_setup_read_write(sdkp, rq, sector, nr_sectors);
+		ret = sd_zbc_setup_read_write(sdkp, rq, sector, &nr_sectors);
 		if (ret != BLKPREP_OK)
 			return ret;
 	}
@@ -1007,7 +1007,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 
 	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
 		/* sd_zbc_setup_read_write uses block layer sector units */
-		ret = sd_zbc_setup_read_write(sdkp, rq, block, this_count);
+		ret = sd_zbc_setup_read_write(sdkp, rq, block, &this_count);
 		if (ret != BLKPREP_OK)
 			goto out;
 	}
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5827b62..47f922f 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -293,7 +293,7 @@ extern void sd_zbc_reset_zones(struct scsi_disk *);
 extern int sd_zbc_setup_discard(struct scsi_disk *, struct request *,
 				sector_t, unsigned int);
 extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
-				   sector_t, unsigned int);
+				   sector_t, unsigned int *);
 extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, bool);
 extern void sd_zbc_refresh_zone_work(struct work_struct *);
 
@@ -323,7 +323,7 @@ static inline int sd_zbc_setup_discard(struct scsi_disk *sdkp,
 
 static inline int sd_zbc_setup_read_write(struct scsi_disk *sdkp,
 					  struct request *rq, sector_t sector,
-					  unsigned int num_sectors)
+					  unsigned int *num_sectors)
 {
 	return BLKPREP_OK;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 75cef62..0485c61 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -426,9 +426,10 @@ out:
 }
 
 int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
-			    sector_t sector, unsigned int num_sectors)
+			    sector_t sector, unsigned int *num_sectors)
 {
 	struct blk_zone *zone;
+	unsigned int sectors = *num_sectors;
 	int ret = BLKPREP_OK;
 	unsigned long flags;
 
@@ -478,12 +479,32 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 			ret = BLKPREP_KILL;
 			goto out;
 		}
-		zone->wp += num_sectors;
-	} else if (blk_zone_is_smr(zone) && (zone->wp <= sector)) {
+		zone->wp += sectors;
+	} else if (zone->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
+		   zone->wp <= sector + sectors) {
+		if (zone->wp <= sector) {
+			/* Read beyond WP: clear request buffer */
+			struct req_iterator iter;
+			struct bio_vec bvec;
+			void *buf;
+			sd_zbc_debug(sdkp,
+				     "Read beyond wp %zu+%u/%zu\n",
+				     sector, sectors, zone->wp);
+			rq_for_each_segment(bvec, rq, iter) {
+				buf = bvec_kmap_irq(&bvec, &flags);
+				memset(buf, 0, bvec.bv_len);
+				flush_dcache_page(bvec.bv_page);
+				bvec_kunmap_irq(buf, &flags);
+			}
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+		/* Read straddle WP position: limit request size */
+		*num_sectors = zone->wp - sector;
 		sd_zbc_debug(sdkp,
-			     "Read beyond wp %zu/%zu\n",
-			     sector, zone->wp);
-		ret = BLKPREP_DONE;
+			     "Read straddle wp %zu+%u/%zu => %zu+%u\n",
+			     sector, sectors, zone->wp,
+			     sector, *num_sectors);
 	}
 
 out:
-- 
1.8.5.6

