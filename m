From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cdrom: add ->check_events() support
Date: Mon,  1 Nov 2010 19:44:38 +0100
Message-ID: <1288637081-5183-5-git-send-email-tj@kernel.org>
References: <1288637081-5183-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288637081-5183-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

In principle, cdrom just needs to pass through ->check_events() but
CDROM_MEDIA_CHANGED ioctl makes things a bit more complex.  Just as
with ->media_changed() support, cdrom code needs to buffer the events
and serve them to ioctl and vfs as requested.  It may be a good idea
to deprecate CDROM_MEDIA_CHANGED ioctl in the long run.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/cdrom/cdrom.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/cdrom.h |    6 +++++
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index af13c62..1ea8f8d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1348,7 +1348,10 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	if (!CDROM_CAN(CDC_SELECT_DISC))
 		return -EDRIVE_CANT_DO_THIS;
 
-	(void) cdi->ops->media_changed(cdi, slot);
+	if (cdi->ops->check_events)
+		cdi->ops->check_events(cdi, 0, slot);
+	else
+		cdi->ops->media_changed(cdi, slot);
 
 	if (slot == CDSL_NONE) {
 		/* set media changed bits, on both queues */
@@ -1392,6 +1395,41 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	return slot;
 }
 
+/*
+ * As cdrom implements an extra ioctl consumer for media changed
+ * event, it needs to buffer ->check_events() output, such that event
+ * is not lost for both the usual VFS and ioctl paths.
+ * cdi->{vfs|ioctl}_events are used to buffer pending events for each
+ * path.
+ *
+ * XXX: Locking is non-existent.  cdi->ops->check_events() can be
+ * called in parallel and buffering fields are accessed without any
+ * exclusion.  The original media_changed code had the same problem.
+ * It might be better to simply deprecate CDROM_MEDIA_CHANGED ioctl
+ * and remove this cruft altogether.  It doesn't have much usefulness
+ * at this point.
+ */
+static void cdrom_update_events(struct cdrom_device_info *cdi,
+				unsigned int clearing)
+{
+	unsigned int events;
+
+	events = cdi->ops->check_events(cdi, clearing, CDSL_CURRENT);
+	cdi->vfs_events |= events;
+	cdi->ioctl_events |= events;
+}
+
+unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
+				unsigned int clearing)
+{
+	unsigned int events;
+
+	cdrom_update_events(cdi, clearing);
+	events = cdi->vfs_events;
+	cdi->vfs_events = 0;
+	return events;
+}
+
 /* We want to make media_changed accessible to the user through an
  * ioctl. The main problem now is that we must double-buffer the
  * low-level implementation, to assure that the VFS and the user both
@@ -1403,15 +1441,26 @@ int media_changed(struct cdrom_device_info *cdi, int queue)
 {
 	unsigned int mask = (1 << (queue & 1));
 	int ret = !!(cdi->mc_flags & mask);
+	bool changed;
 
 	if (!CDROM_CAN(CDC_MEDIA_CHANGED))
-	    return ret;
+		return ret;
+
 	/* changed since last call? */
-	if (cdi->ops->media_changed(cdi, CDSL_CURRENT)) {
+	if (cdi->ops->check_events) {
+		BUG_ON(!queue);	/* shouldn't be called from VFS path */
+		cdrom_update_events(cdi, DISK_EVENT_MEDIA_CHANGE);
+		changed = cdi->ioctl_events & DISK_EVENT_MEDIA_CHANGE;
+		cdi->ioctl_events = 0;
+	} else
+		changed = cdi->ops->media_changed(cdi, CDSL_CURRENT);
+
+	if (changed) {
 		cdi->mc_flags = 0x3;    /* set bit on both queues */
 		ret |= 1;
 		cdi->media_written = 0;
 	}
+
 	cdi->mc_flags &= ~mask;         /* clear bit */
 	return ret;
 }
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 78e9047..35eae4b 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -946,6 +946,8 @@ struct cdrom_device_info {
 /* device-related storage */
 	unsigned int options	: 30;	/* options flags */
 	unsigned mc_flags	: 2;	/* media change buffer flags */
+	unsigned int vfs_events;	/* cached events for vfs path */
+	unsigned int ioctl_events;	/* cached events for ioctl path */
     	int use_count;                  /* number of times device opened */
     	char name[20];                  /* name of the device type */
 /* per-device flags */
@@ -965,6 +967,8 @@ struct cdrom_device_ops {
 	int (*open) (struct cdrom_device_info *, int);
 	void (*release) (struct cdrom_device_info *);
 	int (*drive_status) (struct cdrom_device_info *, int);
+	unsigned int (*check_events) (struct cdrom_device_info *cdi,
+				      unsigned int clearing, int slot);
 	int (*media_changed) (struct cdrom_device_info *, int);
 	int (*tray_move) (struct cdrom_device_info *, int);
 	int (*lock_door) (struct cdrom_device_info *, int);
@@ -993,6 +997,8 @@ extern int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
 extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 		       fmode_t mode, unsigned int cmd, unsigned long arg);
+extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
+				       unsigned int clearing);
 extern int cdrom_media_changed(struct cdrom_device_info *);
 
 extern int register_cdrom(struct cdrom_device_info *cdi);
-- 
1.7.1
