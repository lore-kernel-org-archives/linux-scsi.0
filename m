From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v4 1/2] SCSI: Asynchronous event notification infrastructure
Date: Mon, 29 Oct 2007 10:42:08 -0400 (EDT)
Message-ID: <20071029144208.676251F8168@havoc.gtf.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:45039 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbXJ2OmJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 10:42:09 -0400
In-Reply-To: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
Cc: akpm@linux-foundation.org

Originally based on a patch by Kristen Carlson Accardi @ Intel.
Copious input from James Bottomley.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/scsi_lib.c    |   66 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   |    2 +
 drivers/scsi/scsi_sysfs.c  |   20 +++++++++++++
 include/scsi/scsi_device.h |   12 ++++++++
 4 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fdaf0..f55ec80 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <linux/bitmap.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2115,6 +2116,71 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 EXPORT_SYMBOL(scsi_device_set_state);
 
 /**
+ * 	sdev_evt_thread - send a uevent for each scsi event
+ *	@work: work struct for scsi_device
+ *
+ *	Emit all queued media events as environment variables
+ *	sent during a uevent.
+ */
+void scsi_evt_thread(struct work_struct *work)
+{
+	struct scsi_device *sdev;
+	char *envp[SDEV_EVT_LAST + 2];
+	DECLARE_BITMAP(mask, SDEV_EVT_MAXBITS);
+	unsigned long flags;
+	int evt, idx;
+
+	sdev = container_of(work, struct scsi_device, event_work);
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	bitmap_copy(mask, sdev->event_mask, SDEV_EVT_MAXBITS);
+	bitmap_zero(sdev->event_mask, SDEV_EVT_MAXBITS);
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+
+	idx = 0;
+	for (evt = 0; evt < SDEV_EVT_LAST; evt++) {
+		if (!test_bit(evt, mask))
+			continue;
+
+		switch (evt) {
+		case SDEV_EVT_MEDIA_CHANGE:
+			envp[idx++] = "SDEV_MEDIA_CHANGE=1";
+			break;
+		}
+	}
+	envp[idx++] = NULL;
+
+	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+}
+
+/**
+ * 	sdev_evt_notify - send asserted events to uevent thread
+ *	@sdev: scsi_device event occurred on
+ *	@map: the bitmapped list of asserted events (SDEV_EVT_xxx)
+ *
+ *	
+ */
+void sdev_evt_notify(struct scsi_device *sdev, const unsigned long *map)
+{
+	DECLARE_BITMAP(tmp_map, SDEV_EVT_MAXBITS);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+
+	bitmap_and(tmp_map, sdev->supported_events, map, SDEV_EVT_MAXBITS);
+
+	if (!bitmap_empty(tmp_map, SDEV_EVT_MAXBITS)) {
+		bitmap_or(sdev->event_mask, sdev->event_mask, tmp_map,
+			  SDEV_EVT_MAXBITS);
+
+		schedule_work(&sdev->event_work);
+	}
+
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdev_evt_notify);
+
+/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b53c5f6..3632b62 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -236,6 +236,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	extern void scsi_evt_thread(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -255,6 +256,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	spin_lock_init(&sdev->list_lock);
+	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d531cee..9a1b0c5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -282,6 +282,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
+	cancel_work_sync(&sdev->event_work);
+
 	if (sdev->request_queue) {
 		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
@@ -614,6 +616,23 @@ sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
+#define DECLARE_EVT_SHOW(name, Cap_name)				\
+static ssize_t								\
+sdev_show_##name(struct device *dev, struct device_attribute *attr,	\
+				char *buf)				\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	int val = test_bit(SDEV_EVT_##Cap_name, sdev->supported_events);\
+	return snprintf(buf, 20, "%d\n", val);				\
+}
+
+#define DECLARE_EVT(name, Cap_name) \
+	DECLARE_EVT_SHOW(name, Cap_name) \
+	static DEVICE_ATTR(evt_##name, S_IRUGO, sdev_show_##name, NULL);
+#define REF_EVT(name) &dev_attr_evt_##name.attr
+
+DECLARE_EVT(media_change, MEDIA_CHANGE)
+
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_device_blocked.attr,
@@ -631,6 +650,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
+	REF_EVT(media_change),
 	NULL
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d5057bc..063827a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -46,6 +46,13 @@ enum scsi_device_state {
 				 * to the scsi lld. */
 };
 
+enum scsi_device_event {
+	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
+
+	SDEV_EVT_LAST		= SDEV_EVT_MEDIA_CHANGE,
+	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -127,6 +134,10 @@ struct scsi_device {
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 
+	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
+	DECLARE_BITMAP(event_mask, SDEV_EVT_MAXBITS); /* asserted events */
+	struct work_struct event_work;
+
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
@@ -275,6 +286,7 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
+extern void sdev_evt_notify(struct scsi_device *sdev, const unsigned long *map);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
-- 
1.5.2.4

