From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] sr: implement sr_check_events()
Date: Wed,  8 Dec 2010 20:57:41 +0100
Message-ID: <1291838262-21274-8-git-send-email-tj@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59021 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab0LHT6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2010 14:58:05 -0500
In-Reply-To: <1291838262-21274-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>

Replace sr_media_change() with sr_check_events().  It normally only
uses GET_EVENT_STATUS_NOTIFICATION to check both media change and
eject request.  If @clearing includes DISK_EVENT_MEDIA_CHANGE, it
issues TUR and compares whether media presence has changed.  The SCSI
specific media change uevent is kept for compatibility.

sr_media_change() was doing both media change check and revalidation.
The revalidation part is split into sr_block_revalidate_disk().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/sr.c   |  147 +++++++++++++++++++++++++++++++++------------------
 drivers/scsi/sr.h   |    2 +-
 include/scsi/scsi.h |    1 +
 3 files changed, 98 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f6d8ee4..1e4b9b1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -104,14 +104,15 @@ static void sr_release(struct cdrom_device_info *);
 static void get_sectorsize(struct scsi_cd *);
 static void get_capabilities(struct scsi_cd *);
 
-static int sr_media_change(struct cdrom_device_info *, int);
+static unsigned int sr_check_events(struct cdrom_device_info *cdi,
+				    unsigned int clearing, int slot);
 static int sr_packet(struct cdrom_device_info *, struct packet_command *);
 
 static struct cdrom_device_ops sr_dops = {
 	.open			= sr_open,
 	.release	 	= sr_release,
 	.drive_status	 	= sr_drive_status,
-	.media_changed		= sr_media_change,
+	.check_events		= sr_check_events,
 	.tray_move		= sr_tray_move,
 	.lock_door		= sr_lock_door,
 	.select_speed		= sr_select_speed,
@@ -165,69 +166,96 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static unsigned int sr_get_events(struct scsi_device *sdev)
+{
+	u8 buf[8];
+	u8 cmd[] = { GET_EVENT_STATUS_NOTIFICATION,
+		     1,			/* polled */
+		     0, 0,		/* reserved */
+		     1 << 4,		/* notification class: media */
+		     0, 0,		/* reserved */
+		     0, sizeof(buf),	/* allocation length */
+		     0,			/* control */
+	};
+	struct event_header *eh = (void *)buf;
+	struct media_event_desc *med = (void *)(buf + 4);
+	struct scsi_sense_hdr sshdr;
+	int result;
+
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
+				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
+		return DISK_EVENT_MEDIA_CHANGE;
+
+	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
+		return 0;
+
+	if (eh->nea || eh->notification_class != 0x4)
+		return 0;
+
+	if (med->media_event_code == 1)
+		return DISK_EVENT_EJECT_REQUEST;
+	else if (med->media_event_code == 2)
+		return DISK_EVENT_MEDIA_CHANGE;
+	return 0;
+}
+
 /*
- * This function checks to see if the media has been changed in the
- * CDROM drive.  It is possible that we have already sensed a change,
- * or the drive may have sensed one and not yet reported it.  We must
- * be ready for either case. This function always reports the current
- * value of the changed bit.  If flag is 0, then the changed bit is reset.
- * This function could be done as an ioctl, but we would need to have
- * an inode for that to work, and we do not always have one.
+ * This function checks to see if the media has been changed or eject
+ * button has been pressed.  It is possible that we have already
+ * sensed a change, or the drive may have sensed one and not yet
+ * reported it.  The past events are accumulated in sdev->changed and
+ * returned together with the current state.
  */
-
-static int sr_media_change(struct cdrom_device_info *cdi, int slot)
+static unsigned int sr_check_events(struct cdrom_device_info *cdi,
+				    unsigned int clearing, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
-	int retval;
-	struct scsi_sense_hdr *sshdr;
+	bool last_present;
+	struct scsi_sense_hdr sshdr;
+	unsigned int events;
+	int ret;
 
-	if (CDSL_CURRENT != slot) {
-		/* no changer support */
-		return -EINVAL;
-	}
+	/* no changer support */
+	if (CDSL_CURRENT != slot)
+		return 0;
 
-	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	retval = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
-				      sshdr);
+	events = sr_get_events(cd->device);
+	/*
+	 * GET_EVENT_STATUS_NOTIFICATION is enough unless MEDIA_CHANGE
+	 * is being cleared.  Note that there are devices which hang
+	 * if asked to execute TUR repeatedly.
+	 */
+	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
+		goto skip_tur;
+
+	/* let's see whether the media is there with TUR */
+	last_present = cd->media_present;
+	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 	/*
 	 * Media is considered to be present if TUR succeeds or fails with
 	 * sense data indicating something other than media-not-present
 	 * (ASC 0x3a).
 	 */
-	if (!scsi_status_is_good(retval) &&
-	    (!scsi_sense_valid(sshdr) || sshdr->asc == 0x3a)) {
-		/*
-		 * Probably not media in the device.  Mark as changed, and
-		 * we will figure it out later once the drive is available
-		 * again.
-		 */
-		cd->device->changed = 1;
-		/* This will force a flush, if called from check_disk_change */
-		retval = 1;
-		goto out;
-	};
+	cd->media_present = scsi_status_is_good(ret) ||
+		(scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
 
-	retval = cd->device->changed;
-	cd->device->changed = 0;
-	/* If the disk changed, the capacity will now be different,
-	 * so we force a re-read of this information */
-	if (retval) {
-		/* check multisession offset etc */
-		sr_cd_check(cdi);
-		get_sectorsize(cd);
+	if (last_present != cd->media_present)
+		events |= DISK_EVENT_MEDIA_CHANGE;
+skip_tur:
+	if (cd->device->changed) {
+		events |= DISK_EVENT_MEDIA_CHANGE;
+		cd->device->changed = 0;
 	}
 
-out:
-	/* Notify userspace, that media has changed. */
-	if (retval != cd->previous_state)
+	/* for backward compatibility */
+	if (events & DISK_EVENT_MEDIA_CHANGE)
 		sdev_evt_send_simple(cd->device, SDEV_EVT_MEDIA_CHANGE,
 				     GFP_KERNEL);
-	cd->previous_state = retval;
-	kfree(sshdr);
 
-	return retval;
+	return events;
 }
- 
+
 /*
  * sr_done is the interrupt routine for the device driver.
  *
@@ -512,10 +540,25 @@ out:
 	return ret;
 }
 
-static int sr_block_media_changed(struct gendisk *disk)
+static unsigned int sr_block_check_events(struct gendisk *disk,
+					  unsigned int clearing)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	return cdrom_media_changed(&cd->cdi);
+	return cdrom_check_events(&cd->cdi, clearing);
+}
+
+static int sr_block_revalidate_disk(struct gendisk *disk)
+{
+	struct scsi_cd *cd = scsi_cd(disk);
+	struct scsi_sense_hdr sshdr;
+
+	/* if the unit is not ready, nothing more to do */
+	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
+		return 0;
+
+	sr_cd_check(&cd->cdi);
+	get_sectorsize(cd);
+	return 0;
 }
 
 static const struct block_device_operations sr_bdops =
@@ -524,7 +567,8 @@ static const struct block_device_operations sr_bdops =
 	.open		= sr_block_open,
 	.release	= sr_block_release,
 	.ioctl		= sr_block_ioctl,
-	.media_changed	= sr_block_media_changed,
+	.check_events	= sr_block_check_events,
+	.revalidate_disk = sr_block_revalidate_disk,
 	/* 
 	 * No compat_ioctl for now because sr_block_ioctl never
 	 * seems to pass arbitary ioctls down to host drivers.
@@ -597,6 +641,7 @@ static int sr_probe(struct device *dev)
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
 	disk->flags = GENHD_FL_CD;
+	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
 
 	blk_queue_rq_timeout(sdev->request_queue, SR_TIMEOUT);
 
@@ -606,7 +651,7 @@ static int sr_probe(struct device *dev)
 	cd->disk = disk;
 	cd->capacity = 0x1fffff;
 	cd->device->changed = 1;	/* force recheck CD type */
-	cd->previous_state = 1;
+	cd->media_present = 1;
 	cd->use = 1;
 	cd->readcd_known = 0;
 	cd->readcd_cdda = 0;
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 81fbc0b..e036f1d 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -40,7 +40,7 @@ typedef struct scsi_cd {
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
-	unsigned previous_state:1;	/* media has changed */
+	unsigned media_present:1;	/* media is present */
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 216af85..8675861 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -104,6 +104,7 @@ struct scsi_cmnd;
 #define UNMAP		      0x42
 #define READ_TOC              0x43
 #define READ_HEADER           0x44
+#define GET_EVENT_STATUS_NOTIFICATION 0x4a
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
 #define XDWRITEREAD_10        0x53
-- 
1.7.1

