From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] sd: implement sd_check_events()
Date: Mon,  1 Nov 2010 19:44:41 +0100
Message-ID: <1288637081-5183-8-git-send-email-tj@kernel.org>
References: <1288637081-5183-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:41150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab0KASpU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 14:45:20 -0400
In-Reply-To: <1288637081-5183-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>

Replace sd_media_change() with sd_check_events().  sd used to set the
changed state whenever the device is not ready, which can cause event
loop while the device is not ready.  Media presence handling code is
changed such that the changed state is set iff the media presence
actually changes.  UA still always sets the changed state and
NOT_READY always (at least where it used to set ->changed) clears
media presence, so no event is lost.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/sd.c |   89 ++++++++++++++++++++++++++++------------------------
 drivers/scsi/sd.h |    1 -
 2 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8d488a9..34760bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -991,30 +991,50 @@ out:
 
 static void set_media_not_present(struct scsi_disk *sdkp)
 {
+	if (sdkp->media_present)
+		sdkp->device->changed = 1;
 	sdkp->media_present = 0;
 	sdkp->capacity = 0;
-	sdkp->device->changed = 1;
+}
+
+static int media_not_present(struct scsi_disk *sdkp,
+			     struct scsi_sense_hdr *sshdr)
+{
+	if (!scsi_sense_valid(sshdr))
+		return 0;
+
+	/* not invoked for commands that could return deferred errors */
+	switch (sshdr->sense_key) {
+	case UNIT_ATTENTION:
+		sdkp->device->changed = 1;
+		/* fall through */
+	case NOT_READY:
+		/* medium not present */
+		if (sshdr->asc == 0x3A) {
+			set_media_not_present(sdkp);
+			return 1;
+		}
+	}
+	return 0;
 }
 
 /**
- *	sd_media_changed - check if our medium changed
- *	@disk: kernel device descriptor 
+ *	sd_check_events - check media events
+ *	@disk: kernel device descriptor
+ *	@clearing: disk events currently being cleared
  *
- *	Returns 0 if not applicable or no change; 1 if change
+ *	Returns mask of DISK_EVENT_*.
  *
  *	Note: this function is invoked from the block subsystem.
  **/
-static int sd_media_changed(struct gendisk *disk)
+static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_sense_hdr *sshdr = NULL;
 	int retval;
 
-	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_media_changed\n"));
-
-	if (!sdp->removable)
-		return 0;
+	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_check_events\n"));
 
 	/*
 	 * If the device is offline, don't send any commands - just pretend as
@@ -1024,7 +1044,6 @@ static int sd_media_changed(struct gendisk *disk)
 	 */
 	if (!scsi_device_online(sdp)) {
 		set_media_not_present(sdkp);
-		retval = 1;
 		goto out;
 	}
 
@@ -1045,26 +1064,30 @@ static int sd_media_changed(struct gendisk *disk)
 					      sshdr);
 	}
 
-	if (retval) {
+	/* failed to execute TUR, assume media not present */
+	if (host_byte(retval)) {
 		set_media_not_present(sdkp);
-		retval = 1;
 		goto out;
 	}
 
+	if (media_not_present(sdkp, sshdr))
+		goto out;
+
 	/*
 	 * For removable scsi disk we have to recognise the presence
-	 * of a disk in the drive. This is kept in the struct scsi_disk
-	 * struct and tested at open !  Daniel Roche (dan@lectra.fr)
+	 * of a disk in the drive.
 	 */
+	if (!sdkp->media_present)
+		sdp->changed = 1;
 	sdkp->media_present = 1;
-
-	retval = sdp->changed;
-	sdp->changed = 0;
 out:
-	if (retval != sdkp->previous_state)
+	/* for backward compatibility */
+	if (sdp->changed)
 		sdev_evt_send_simple(sdp, SDEV_EVT_MEDIA_CHANGE, GFP_KERNEL);
-	sdkp->previous_state = retval;
 	kfree(sshdr);
+
+	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
+	sdp->changed = 0;
 	return retval;
 }
 
@@ -1157,7 +1180,7 @@ static const struct block_device_operations sd_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sd_compat_ioctl,
 #endif
-	.media_changed		= sd_media_changed,
+	.check_events		= sd_check_events,
 	.revalidate_disk	= sd_revalidate_disk,
 	.unlock_native_capacity	= sd_unlock_native_capacity,
 };
@@ -1293,23 +1316,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	return good_bytes;
 }
 
-static int media_not_present(struct scsi_disk *sdkp,
-			     struct scsi_sense_hdr *sshdr)
-{
-
-	if (!scsi_sense_valid(sshdr))
-		return 0;
-	/* not invoked for commands that could return deferred errors */
-	if (sshdr->sense_key != NOT_READY &&
-	    sshdr->sense_key != UNIT_ATTENTION)
-		return 0;
-	if (sshdr->asc != 0x3A) /* medium not present */
-		return 0;
-
-	set_media_not_present(sdkp);
-	return 1;
-}
-
 /*
  * spinup disk - called only in sd_revalidate_disk()
  */
@@ -1484,7 +1490,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	 */
 	if (sdp->removable &&
 	    sense_valid && sshdr->sense_key == NOT_READY)
-		sdp->changed = 1;
+		set_media_not_present(sdkp);
 
 	/*
 	 * We used to set media_present to 0 here to indicate no media
@@ -2325,7 +2331,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
 	sdkp->capacity = 0;
-	sdkp->media_present = 1;
+	sdkp->media_present = 0;
 	sdkp->write_prot = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
@@ -2339,8 +2345,10 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
-	if (sdp->removable)
+	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
+		gd->events |= DISK_EVENT_MEDIA_CHANGE;
+	}
 
 	add_disk(gd);
 	sd_dif_config_host(sdkp);
@@ -2422,7 +2430,6 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	atomic_set(&sdkp->openers, 0);
-	sdkp->previous_state = 1;
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 55488fa..c9d8f6c 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -55,7 +55,6 @@ struct scsi_disk {
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
-	unsigned	previous_state : 1;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
-- 
1.7.1

