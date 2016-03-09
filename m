From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi,block: enable disk event forwarding
Date: Wed,  9 Mar 2016 14:16:29 +0100
Message-ID: <1457529392-53970-2-git-send-email-hare@suse.de>
References: <1457529392-53970-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457529392-53970-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Mahoney <jeffm@suse.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Some SCSI events relate to block events (eg media change), so this
patch implements a forwarding mechanism for SCSI events to the
corresponding block event.
It redefines the currently unused 'supported_events' bitmap to
signal which SCSI events should be forwarded to block events.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/genhd.c              |  1 +
 drivers/scsi/scsi_lib.c    | 15 +++++----------
 drivers/scsi/sd.c          | 26 ++++++++++++++++++++++++++
 include/scsi/scsi_driver.h |  2 ++
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9f42526..229c760 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1636,6 +1636,7 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 
 	return pending;
 }
+EXPORT_SYMBOL_GPL(disk_clear_events);
 
 /*
  * Separate this part out so that a different pointer for clearing_ptr can be
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d46193a..6532c32 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2691,9 +2691,14 @@ EXPORT_SYMBOL(scsi_device_set_state);
  */
 static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 {
+	struct device *dev = &sdev->sdev_gendev;
+	struct scsi_driver *sdrv = to_scsi_driver(dev->driver);
 	int idx = 0;
 	char *envp[3];
 
+	if (sdrv->ua_event && test_bit(evt->evt_type, sdev->supported_events))
+		sdrv->ua_event(sdev, evt->evt_type);
+
 	switch (evt->evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
 		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
@@ -2778,16 +2783,6 @@ void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
 {
 	unsigned long flags;
 
-#if 0
-	/* FIXME: currently this check eliminates all media change events
-	 * for polled devices.  Need to update to discriminate between AN
-	 * and polled events */
-	if (!test_bit(evt->evt_type, sdev->supported_events)) {
-		kfree(evt);
-		return;
-	}
-#endif
-
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_add_tail(&evt->node, &sdev->event_list);
 	schedule_work(&sdev->event_work);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d749da7..b001c139 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -114,6 +114,7 @@ static int sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
+static void sd_ua_event(struct scsi_device *, enum scsi_device_event);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
@@ -525,6 +526,7 @@ static struct scsi_driver sd_template = {
 	.uninit_command		= sd_uninit_command,
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
+	.ua_event		= sd_ua_event,
 };
 
 /*
@@ -1415,6 +1417,14 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 		goto out;
 	}
 
+	if (sdp->changed) {
+		/*
+		 * Media change AN
+		 */
+		sdp->changed = 0;
+		return DISK_EVENT_MEDIA_CHANGE;
+	}
+
 	/*
 	 * Using TEST_UNIT_READY enables differentiation between drive with
 	 * no cartridge loaded - NOT READY, drive with changed cartridge -
@@ -1706,6 +1716,22 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	return eh_disp;
 }
 
+/**
+ *	sd_ua_event - unit attention event callback
+ *	@scmd:		sd-issued command which triggered the UA
+ *	@evt_type:	Triggered event type
+ *
+ **/
+static void sd_ua_event(struct scsi_device *sdev, enum scsi_device_event evt)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(&sdev->sdev_gendev);
+
+	if (evt == SDEV_EVT_MEDIA_CHANGE) {
+		sdev->changed = 1;
+		disk_clear_events(sdkp->disk, DISK_EVENT_MEDIA_CHANGE);
+	}
+}
+
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
 	u64 start_lba = blk_rq_pos(scmd->request);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 891a658..1d1002a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -7,6 +7,7 @@ struct module;
 struct request;
 struct scsi_cmnd;
 struct scsi_device;
+enum scsi_device_event;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -16,6 +17,7 @@ struct scsi_driver {
 	void (*uninit_command)(struct scsi_cmnd *);
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
+	void (*ua_event)(struct scsi_device *, enum scsi_device_event evt);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
1.8.5.6

