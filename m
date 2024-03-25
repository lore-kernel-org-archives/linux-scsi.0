Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977561C321C;
	Mon, 25 Mar 2024 04:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341923; cv=none; b=jXjyQrElmqVr3B2zU0jYhNdQ9EOtCNDDbL6HDyPdmAanHX32hA45SbNlaMVPwL59jCouipaGa20OGrruUFcgqIzsnBa88U6uI+fWojMRDbAmaXo0K/lt/Jf+g6iDqfqD+I5fSLtQrDxc/yO9wuPp87U1LlvZpurTuBIR7Pehr3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341923; c=relaxed/simple;
	bh=sZP3admnq4D8bNfUCECeVE52VUly4BERQ3949qdQpdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSTMn6fS0D/JzGQSDftDzSFvbDACTSuBb7CgaaZAlPs/KoVdryO5F+hmySG1tQRFFeDcU224BaSUbkZxq1DlFK7hLcMlbyjE9LPRyUDClbL318JpXrMdzI09nmmB/Lq8Zwddig5jGpd//DrIrhcMU0uyxT6/PIlxvZA7zgpRUTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EEftUz5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EEftUz5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FF9C43394;
	Mon, 25 Mar 2024 04:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341923;
	bh=sZP3admnq4D8bNfUCECeVE52VUly4BERQ3949qdQpdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEftUz5+uVGQ+IUWsrKWCL9Z91CCBIffBPH1UZ0U6JbICfwrkbaAqxu7vGxNKlULM
	 I1riO1DeKdchaDfngcUUM1rTgA529ShCK3yn1g56ixsC2BzeOfnSB+5GYjsH/xCQQg
	 o7+rJ2S4r5GwU5XXhbE87iE0hepY4lo21pvk+qsQ9bOdH+mxIzCHJtoztQ0hgJgWHn
	 eB9oSaA0nD2Hc5UhoUJo3uuy8TsGT47yOv9A4jQyqPu2YZ/zZ9iyVDrkCmVekNznHb
	 ntBa7SdhhE/ydjjIcEZ+ZY/FsNKhuMEJYx5ZufbPY8J75XfzNWU3agNXIeLWgKD/8t
	 WETZF4L9vrNnA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 14/28] scsi: sd: Use the block layer zone append emulation
Date: Mon, 25 Mar 2024 13:44:38 +0900
Message-ID: <20240325044452.3125418-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the request queue of a TYPE_ZBC device as needing zone append
emulation by setting the device queue max_zone_append_sectors limit to
0. This enables the block layer generic implementation provided by zone
write plugging. With this, the sd driver will never see a
REQ_OP_ZONE_APPEND request and the zone append emulation code
implemented in sd_zbc.c can be removed.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c     |   8 -
 drivers/scsi/sd.h     |  19 ---
 drivers/scsi/sd_zbc.c | 335 ++----------------------------------------
 3 files changed, 10 insertions(+), 352 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ccff8f2e2e75..35a486232a76 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1260,12 +1260,6 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (req_op(rq) == REQ_OP_ZONE_APPEND) {
-		ret = sd_zbc_prepare_zone_append(cmd, &lba, nr_blocks);
-		if (ret)
-			goto fail;
-	}
-
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
 	dix = scsi_prot_sg_count(cmd);
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
@@ -1348,7 +1342,6 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 		return sd_setup_flush_cmnd(cmd);
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
-	case REQ_OP_ZONE_APPEND:
 		return sd_setup_read_write_cmnd(cmd);
 	case REQ_OP_ZONE_RESET:
 		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_RESET_WRITE_POINTER,
@@ -3979,7 +3972,6 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
 	ida_free(&sd_index_ida, sdkp->index);
-	sd_zbc_free_zone_info(sdkp);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5c4285a582b2..49dd600bfa48 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -104,12 +104,6 @@ struct scsi_disk {
 	 * between zone starting LBAs is constant.
 	 */
 	u32		zone_starting_lba_gran;
-	u32		*zones_wp_offset;
-	spinlock_t	zones_wp_offset_lock;
-	u32		*rev_wp_offset;
-	struct mutex	rev_mutex;
-	struct work_struct zone_wp_offset_work;
-	char		*zone_wp_update_buf;
 #endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
@@ -245,7 +239,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-void sd_zbc_free_zone_info(struct scsi_disk *sdkp);
 int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
@@ -255,13 +248,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, report_zones_cb cb, void *data);
 
-blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
-				        unsigned int nr_blocks);
-
 #else /* CONFIG_BLK_DEV_ZONED */
 
-static inline void sd_zbc_free_zone_info(struct scsi_disk *sdkp) {}
-
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 {
 	return 0;
@@ -285,13 +273,6 @@ static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 	return good_bytes;
 }
 
-static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
-						      sector_t *lba,
-						      unsigned int nr_blocks)
-{
-	return BLK_STS_TARGET;
-}
-
 #define sd_zbc_report_zones NULL
 
 #endif /* CONFIG_BLK_DEV_ZONED */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 26af5ab7d7c1..d0ead9858954 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -23,36 +23,6 @@
 #define CREATE_TRACE_POINTS
 #include "sd_trace.h"
 
-/**
- * sd_zbc_get_zone_wp_offset - Get zone write pointer offset.
- * @zone: Zone for which to return the write pointer offset.
- *
- * Return: offset of the write pointer from the start of the zone.
- */
-static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
-{
-	if (zone->type == ZBC_ZONE_TYPE_CONV)
-		return 0;
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_IMP_OPEN:
-	case BLK_ZONE_COND_EXP_OPEN:
-	case BLK_ZONE_COND_CLOSED:
-		return zone->wp - zone->start;
-	case BLK_ZONE_COND_FULL:
-		return zone->len;
-	case BLK_ZONE_COND_EMPTY:
-	case BLK_ZONE_COND_OFFLINE:
-	case BLK_ZONE_COND_READONLY:
-	default:
-		/*
-		 * Offline and read-only zones do not have a valid
-		 * write pointer. Use 0 as for an empty zone.
-		 */
-		return 0;
-	}
-}
-
 /* Whether or not a SCSI zone descriptor describes a gap zone. */
 static bool sd_zbc_is_gap_zone(const u8 buf[64])
 {
@@ -121,9 +91,6 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 	if (ret)
 		return ret;
 
-	if (sdkp->rev_wp_offset)
-		sdkp->rev_wp_offset[idx] = sd_zbc_get_zone_wp_offset(&zone);
-
 	return 0;
 }
 
@@ -347,123 +314,6 @@ static blk_status_t sd_zbc_cmnd_checks(struct scsi_cmnd *cmd)
 	return BLK_STS_OK;
 }
 
-#define SD_ZBC_INVALID_WP_OFST	(~0u)
-#define SD_ZBC_UPDATING_WP_OFST	(SD_ZBC_INVALID_WP_OFST - 1)
-
-static int sd_zbc_update_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
-				    void *data)
-{
-	struct scsi_disk *sdkp = data;
-
-	lockdep_assert_held(&sdkp->zones_wp_offset_lock);
-
-	sdkp->zones_wp_offset[idx] = sd_zbc_get_zone_wp_offset(zone);
-
-	return 0;
-}
-
-/*
- * An attempt to append a zone triggered an invalid write pointer error.
- * Reread the write pointer of the zone(s) in which the append failed.
- */
-static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
-{
-	struct scsi_disk *sdkp;
-	unsigned long flags;
-	sector_t zno;
-	int ret;
-
-	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
-
-	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
-	for (zno = 0; zno < sdkp->zone_info.nr_zones; zno++) {
-		if (sdkp->zones_wp_offset[zno] != SD_ZBC_UPDATING_WP_OFST)
-			continue;
-
-		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
-		ret = sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,
-					     SD_BUF_SIZE,
-					     zno * sdkp->zone_info.zone_blocks, true);
-		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
-		if (!ret)
-			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,
-					    zno, sd_zbc_update_wp_offset_cb,
-					    sdkp);
-	}
-	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
-
-	scsi_device_put(sdkp->device);
-}
-
-/**
- * sd_zbc_prepare_zone_append() - Prepare an emulated ZONE_APPEND command.
- * @cmd: the command to setup
- * @lba: the LBA to patch
- * @nr_blocks: the number of LBAs to be written
- *
- * Called from sd_setup_read_write_cmnd() for REQ_OP_ZONE_APPEND.
- * @sd_zbc_prepare_zone_append() handles the necessary zone wrote locking and
- * patching of the lba for an emulated ZONE_APPEND command.
- *
- * In case the cached write pointer offset is %SD_ZBC_INVALID_WP_OFST it will
- * schedule a REPORT ZONES command and return BLK_STS_IOERR.
- */
-blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
-					unsigned int nr_blocks)
-{
-	struct request *rq = scsi_cmd_to_rq(cmd);
-	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
-	unsigned int wp_offset, zno = blk_rq_zone_no(rq);
-	unsigned long flags;
-	blk_status_t ret;
-
-	ret = sd_zbc_cmnd_checks(cmd);
-	if (ret != BLK_STS_OK)
-		return ret;
-
-	if (!blk_rq_zone_is_seq(rq))
-		return BLK_STS_IOERR;
-
-	/* Unlock of the write lock will happen in sd_zbc_complete() */
-	if (!blk_req_zone_write_trylock(rq))
-		return BLK_STS_ZONE_RESOURCE;
-
-	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
-	wp_offset = sdkp->zones_wp_offset[zno];
-	switch (wp_offset) {
-	case SD_ZBC_INVALID_WP_OFST:
-		/*
-		 * We are about to schedule work to update a zone write pointer
-		 * offset, which will cause the zone append command to be
-		 * requeued. So make sure that the scsi device does not go away
-		 * while the work is being processed.
-		 */
-		if (scsi_device_get(sdkp->device)) {
-			ret = BLK_STS_IOERR;
-			break;
-		}
-		sdkp->zones_wp_offset[zno] = SD_ZBC_UPDATING_WP_OFST;
-		schedule_work(&sdkp->zone_wp_offset_work);
-		fallthrough;
-	case SD_ZBC_UPDATING_WP_OFST:
-		ret = BLK_STS_DEV_RESOURCE;
-		break;
-	default:
-		wp_offset = sectors_to_logical(sdkp->device, wp_offset);
-		if (wp_offset + nr_blocks > sdkp->zone_info.zone_blocks) {
-			ret = BLK_STS_IOERR;
-			break;
-		}
-
-		trace_scsi_prepare_zone_append(cmd, *lba, wp_offset);
-		*lba += wp_offset;
-	}
-	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
-	if (ret)
-		blk_req_zone_write_unlock(rq);
-	return ret;
-}
-
 /**
  * sd_zbc_setup_zone_mgmt_cmnd - Prepare a zone ZBC_OUT command. The operations
  *			can be RESET WRITE POINTER, OPEN, CLOSE or FINISH.
@@ -504,96 +354,6 @@ blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 	return BLK_STS_OK;
 }
 
-static bool sd_zbc_need_zone_wp_update(struct request *rq)
-{
-	switch (req_op(rq)) {
-	case REQ_OP_ZONE_APPEND:
-	case REQ_OP_ZONE_FINISH:
-	case REQ_OP_ZONE_RESET:
-	case REQ_OP_ZONE_RESET_ALL:
-		return true;
-	case REQ_OP_WRITE:
-	case REQ_OP_WRITE_ZEROES:
-		return blk_rq_zone_is_seq(rq);
-	default:
-		return false;
-	}
-}
-
-/**
- * sd_zbc_zone_wp_update - Update cached zone write pointer upon cmd completion
- * @cmd: Completed command
- * @good_bytes: Command reply bytes
- *
- * Called from sd_zbc_complete() to handle the update of the cached zone write
- * pointer value in case an update is needed.
- */
-static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
-					  unsigned int good_bytes)
-{
-	int result = cmd->result;
-	struct request *rq = scsi_cmd_to_rq(cmd);
-	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
-	unsigned int zno = blk_rq_zone_no(rq);
-	enum req_op op = req_op(rq);
-	unsigned long flags;
-
-	/*
-	 * If we got an error for a command that needs updating the write
-	 * pointer offset cache, we must mark the zone wp offset entry as
-	 * invalid to force an update from disk the next time a zone append
-	 * command is issued.
-	 */
-	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
-
-	if (result && op != REQ_OP_ZONE_RESET_ALL) {
-		if (op == REQ_OP_ZONE_APPEND) {
-			/* Force complete completion (no retry) */
-			good_bytes = 0;
-			scsi_set_resid(cmd, blk_rq_bytes(rq));
-		}
-
-		/*
-		 * Force an update of the zone write pointer offset on
-		 * the next zone append access.
-		 */
-		if (sdkp->zones_wp_offset[zno] != SD_ZBC_UPDATING_WP_OFST)
-			sdkp->zones_wp_offset[zno] = SD_ZBC_INVALID_WP_OFST;
-		goto unlock_wp_offset;
-	}
-
-	switch (op) {
-	case REQ_OP_ZONE_APPEND:
-		trace_scsi_zone_wp_update(cmd, rq->__sector,
-				  sdkp->zones_wp_offset[zno], good_bytes);
-		rq->__sector += sdkp->zones_wp_offset[zno];
-		fallthrough;
-	case REQ_OP_WRITE_ZEROES:
-	case REQ_OP_WRITE:
-		if (sdkp->zones_wp_offset[zno] < sd_zbc_zone_sectors(sdkp))
-			sdkp->zones_wp_offset[zno] +=
-						good_bytes >> SECTOR_SHIFT;
-		break;
-	case REQ_OP_ZONE_RESET:
-		sdkp->zones_wp_offset[zno] = 0;
-		break;
-	case REQ_OP_ZONE_FINISH:
-		sdkp->zones_wp_offset[zno] = sd_zbc_zone_sectors(sdkp);
-		break;
-	case REQ_OP_ZONE_RESET_ALL:
-		memset(sdkp->zones_wp_offset, 0,
-		       sdkp->zone_info.nr_zones * sizeof(unsigned int));
-		break;
-	default:
-		break;
-	}
-
-unlock_wp_offset:
-	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
-
-	return good_bytes;
-}
-
 /**
  * sd_zbc_complete - ZBC command post processing.
  * @cmd: Completed command
@@ -619,11 +379,7 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		 * so be quiet about the error.
 		 */
 		rq->rq_flags |= RQF_QUIET;
-	} else if (sd_zbc_need_zone_wp_update(rq))
-		good_bytes = sd_zbc_zone_wp_update(cmd, good_bytes);
-
-	if (req_op(rq) == REQ_OP_ZONE_APPEND)
-		blk_req_zone_write_unlock(rq);
+	}
 
 	return good_bytes;
 }
@@ -780,46 +536,6 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_info.zone_blocks);
 }
 
-static int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	sdkp->zones_wp_offset = NULL;
-	spin_lock_init(&sdkp->zones_wp_offset_lock);
-	sdkp->rev_wp_offset = NULL;
-	mutex_init(&sdkp->rev_mutex);
-	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
-	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!sdkp->zone_wp_update_buf)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void sd_zbc_free_zone_info(struct scsi_disk *sdkp)
-{
-	if (!sdkp->zone_wp_update_buf)
-		return;
-
-	/* Serialize against revalidate zones */
-	mutex_lock(&sdkp->rev_mutex);
-
-	kvfree(sdkp->zones_wp_offset);
-	sdkp->zones_wp_offset = NULL;
-	kfree(sdkp->zone_wp_update_buf);
-	sdkp->zone_wp_update_buf = NULL;
-
-	sdkp->early_zone_info = (struct zoned_disk_info){ };
-	sdkp->zone_info = (struct zoned_disk_info){ };
-
-	mutex_unlock(&sdkp->rev_mutex);
-}
-
-static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
-{
-	struct scsi_disk *sdkp = scsi_disk(disk);
-
-	swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
-}
-
 /*
  * Call blk_revalidate_disk_zones() if any of the zoned disk properties have
  * changed that make it necessary to call that function. Called by
@@ -831,18 +547,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	struct request_queue *q = disk->queue;
 	u32 zone_blocks = sdkp->early_zone_info.zone_blocks;
 	unsigned int nr_zones = sdkp->early_zone_info.nr_zones;
-	int ret = 0;
 	unsigned int flags;
-
-	/*
-	 * For all zoned disks, initialize zone append emulation data if not
-	 * already done.
-	 */
-	if (sd_is_zoned(sdkp) && !sdkp->zone_wp_update_buf) {
-		ret = sd_zbc_init_disk(sdkp);
-		if (ret)
-			return ret;
-	}
+	int ret;
 
 	/*
 	 * There is nothing to do for regular disks, including host-aware disks
@@ -851,50 +557,32 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	if (!blk_queue_is_zoned(q))
 		return 0;
 
-	/*
-	 * Make sure revalidate zones are serialized to ensure exclusive
-	 * updates of the scsi disk data.
-	 */
-	mutex_lock(&sdkp->rev_mutex);
-
 	if (sdkp->zone_info.zone_blocks == zone_blocks &&
 	    sdkp->zone_info.nr_zones == nr_zones &&
 	    disk->nr_zones == nr_zones)
-		goto unlock;
+		return 0;
 
-	flags = memalloc_noio_save();
 	sdkp->zone_info.zone_blocks = zone_blocks;
 	sdkp->zone_info.nr_zones = nr_zones;
-	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);
-	if (!sdkp->rev_wp_offset) {
-		ret = -ENOMEM;
-		memalloc_noio_restore(flags);
-		goto unlock;
-	}
 
 	blk_queue_chunk_sectors(q,
 			logical_to_sectors(sdkp->device, zone_blocks));
-	blk_queue_max_zone_append_sectors(q,
-			q->limits.max_segments << PAGE_SECTORS_SHIFT);
 
-	ret = blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb);
+	/* Enable block layer zone append emulation */
+	blk_queue_max_zone_append_sectors(q, 0);
 
+	flags = memalloc_noio_save();
+	ret = blk_revalidate_disk_zones(disk, NULL);
 	memalloc_noio_restore(flags);
-	kvfree(sdkp->rev_wp_offset);
-	sdkp->rev_wp_offset = NULL;
-
 	if (ret) {
 		sdkp->zone_info = (struct zoned_disk_info){ };
 		sdkp->capacity = 0;
-		goto unlock;
+		return ret;
 	}
 
 	sd_zbc_print_zones(sdkp);
 
-unlock:
-	mutex_unlock(&sdkp->rev_mutex);
-
-	return ret;
+	return 0;
 }
 
 /**
@@ -917,10 +605,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	if (!sd_is_zoned(sdkp)) {
 		/*
 		 * Device managed or normal SCSI disk, no special handling
-		 * required. Nevertheless, free the disk zone information in
-		 * case the device type changed.
+		 * required.
 		 */
-		sd_zbc_free_zone_info(sdkp);
 		return 0;
 	}
 
@@ -941,7 +627,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 
 	/* The drive satisfies the kernel restrictions: set it up */
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	if (sdkp->zones_max_open == U32_MAX)
 		disk_set_max_open_zones(disk, 0);
 	else
-- 
2.44.0

