From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] block,scsi: Low water mark disk event
Date: Wed,  9 Mar 2016 14:16:30 +0100
Message-ID: <1457529392-53970-3-git-send-email-hare@suse.de>
References: <1457529392-53970-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457529392-53970-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Mahoney <jeffm@suse.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Add a disk event for a 'low water mark' condition, signalling when
a device is about to run out of space. This event is mapped to a
Thin Provisioning Soft Threshold Reached UA.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/genhd.c           |  2 ++
 drivers/scsi/scsi_lib.c | 10 +++++-----
 drivers/scsi/sd.c       | 19 +++++++++++++++++++
 drivers/scsi/sd.h       |  1 +
 include/linux/genhd.h   |  1 +
 5 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 229c760..48334e6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1437,11 +1437,13 @@ struct disk_events {
 static const char *disk_events_strs[] = {
 	[ilog2(DISK_EVENT_MEDIA_CHANGE)]	= "media_change",
 	[ilog2(DISK_EVENT_EJECT_REQUEST)]	= "eject_request",
+	[ilog2(DISK_EVENT_LOWAT)]		= "low_water_mark",
 };
 
 static char *disk_uevents[] = {
 	[ilog2(DISK_EVENT_MEDIA_CHANGE)]	= "DISK_MEDIA_CHANGE=1",
 	[ilog2(DISK_EVENT_EJECT_REQUEST)]	= "DISK_EJECT_REQUEST=1",
+	[ilog2(DISK_EVENT_LOWAT)]		= "DISK_LOW_WATER_MARK=1",
 };
 
 /* list of all disk_events */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6532c32..e8955da 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2683,7 +2683,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 EXPORT_SYMBOL(scsi_device_set_state);
 
 /**
- * 	sdev_evt_emit - emit a single SCSI device uevent
+ *	sdev_evt_emit - emit a single SCSI device uevent
  *	@sdev: associated SCSI device
  *	@evt: event to emit
  *
@@ -2711,7 +2711,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 		envp[idx++] = "SDEV_UA=CAPACITY_DATA_HAS_CHANGED";
 		break;
 	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
-	       envp[idx++] = "SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED";
+		envp[idx++] = "SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED";
 		break;
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
 		envp[idx++] = "SDEV_UA=MODE_PARAMETERS_CHANGED";
@@ -2733,7 +2733,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 }
 
 /**
- * 	sdev_evt_thread - send a uevent for each scsi event
+ *	sdev_evt_thread - send a uevent for each scsi event
  *	@work: work struct for scsi_device
  *
  *	Dispatch queued events to their associated scsi_device kobjects
@@ -2773,7 +2773,7 @@ void scsi_evt_thread(struct work_struct *work)
 }
 
 /**
- * 	sdev_evt_send - send asserted event to uevent thread
+ *	sdev_evt_send - send asserted event to uevent thread
  *	@sdev: scsi_device event occurred on
  *	@evt: event to send
  *
@@ -2791,7 +2791,7 @@ void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
 EXPORT_SYMBOL_GPL(sdev_evt_send);
 
 /**
- * 	sdev_evt_alloc - allocate a new scsi event
+ *	sdev_evt_alloc - allocate a new scsi event
  *	@evt_type: type of event to allocate
  *	@gfpflags: GFP flags for allocation
  *
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b001c139..34de425 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1425,6 +1425,16 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 		return DISK_EVENT_MEDIA_CHANGE;
 	}
 
+	if (sdkp->tp_lowat) {
+		/*
+		 * Thin Provisioning Low Watermark reached;
+		 * don't send TEST_UNIT_READY but rather return
+		 * immediately.
+		 */
+		sdkp->tp_lowat = false;
+		return DISK_EVENT_LOWAT;
+	}
+
 	/*
 	 * Using TEST_UNIT_READY enables differentiation between drive with
 	 * no cartridge loaded - NOT READY, drive with changed cartridge -
@@ -1729,6 +1739,9 @@ static void sd_ua_event(struct scsi_device *sdev, enum scsi_device_event evt)
 	if (evt == SDEV_EVT_MEDIA_CHANGE) {
 		sdev->changed = 1;
 		disk_clear_events(sdkp->disk, DISK_EVENT_MEDIA_CHANGE);
+	} else if (evt == SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED) {
+		sdkp->tp_lowat = true;
+		disk_clear_events(sdkp->disk, DISK_EVENT_LOWAT);
 	}
 }
 
@@ -3044,6 +3057,12 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
 	}
+	if (sdkp->lbpme) {
+		gd->events |= DISK_EVENT_LOWAT;
+		gd->async_events |= DISK_EVENT_LOWAT;
+		set_bit(SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,
+			sdp->supported_events);
+	}
 
 	blk_pm_runtime_init(sdp->request_queue, dev);
 	add_disk(gd);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5f2a84a..b22b8f0 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -94,6 +94,7 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned	tp_lowat : 1;	/* TP soft threshold reached */
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5c70676..d6fe7e1 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -143,6 +143,7 @@ struct hd_struct {
 enum {
 	DISK_EVENT_MEDIA_CHANGE			= 1 << 0, /* media changed */
 	DISK_EVENT_EJECT_REQUEST		= 1 << 1, /* eject requested */
+	DISK_EVENT_LOWAT			= 1 << 2, /* Low watermark reached */
 };
 
 #define BLK_SCSI_MAX_CMDS	(256)
-- 
1.8.5.6

