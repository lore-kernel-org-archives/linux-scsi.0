From: Jeff Garzik <jeff@garzik.org>
Subject: [git patches] Add and use media change notification
Date: Sun, 4 Nov 2007 10:07:11 -0500
Message-ID: <20071104150711.GA29087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:47155 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXKDPHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Nov 2007 10:07:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


The end to CD-ROM polling...  newer SATA ATAPI hardware will emit
'asynchronous notification' events when media is changed.  This adds
support.

The libata change /using/ the infrastructure is tiny, encompassed
entirely in the first file patched, drivers/ata/libata-scsi.c.

Been working since August (and in -mm), but has gone through various
revisions to try and make SCSI maintainer happy.  Every step of the way,
it was upstream-mergeable in my opinion.

Everyone agrees this should go upstream; indeed, the key change from
me "[SCSI] add asynchronous event notification API" is even found
in jejb/scsi-misc-2.6.git (db0e2c76011f25f22f71e9c0d69ce95d15f21e8a).

There are minor disagreements with regards to userspace API, with a
more complex "solve all your problems" change currently being discussed,
blocked behind sysfs changes that don't exist yet (and are still being
discussed).

I am ready and waiting to address further feedback -- each feedback
I received so far was addressed in under 24 hours -- but let us not
delay this anymore.

Changes can and should be iterated upstream... that is what the bug fix
process is for...  getting final feedback and polish on working, testing
changes that have been waiting in the wings for months.

Please pull from 'an' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git an

to receive the following updates:

 drivers/ata/libata-scsi.c  |    8 ++-
 drivers/scsi/scsi_lib.c    |  136 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   |    3 +
 drivers/scsi/scsi_sysfs.c  |   47 +++++++++++++++
 include/scsi/scsi_device.h |   25 ++++++++
 5 files changed, 216 insertions(+), 3 deletions(-)


commit f26792d5c63344e14540ced4b19deb29e360bb8d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Oct 29 17:18:39 2007 -0400

    [libata] Utilize new SCSI event infrastructure
    
    An end to CD-ROM polling (if you have a device that supports AN)...
    hooray!
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

commit a341cd0f6a0fde1f85fec9aa8f81f824ea4a3f92
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Oct 29 17:15:22 2007 -0400

    SCSI: add asynchronous event notification API
    
    Originally based on a patch by Kristen Carlson Accardi @ Intel.
    Copious input from James Bottomley.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 245057d..94144ed 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -841,6 +841,9 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 
@@ -3296,10 +3299,9 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
  */
 void ata_scsi_media_change_notify(struct ata_device *dev)
 {
-#ifdef OTHER_AN_PATCHES_HAVE_BEEN_APPLIED
 	if (dev->sdev)
-		scsi_device_event_notify(dev->sdev, SDEV_MEDIA_CHANGE);
-#endif
+		sdev_evt_send_simple(dev->sdev, SDEV_EVT_MEDIA_CHANGE,
+				     GFP_ATOMIC);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 88de771..0e81e4c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2115,6 +2115,142 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 EXPORT_SYMBOL(scsi_device_set_state);
 
 /**
+ * 	sdev_evt_emit - emit a single SCSI device uevent
+ *	@sdev: associated SCSI device
+ *	@evt: event to emit
+ *
+ *	Send a single uevent (scsi_event) to the associated scsi_device.
+ */
+static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
+{
+	int idx = 0;
+	char *envp[3];
+
+	switch (evt->evt_type) {
+	case SDEV_EVT_MEDIA_CHANGE:
+		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
+		break;
+
+	default:
+		/* do nothing */
+		break;
+	}
+
+	envp[idx++] = NULL;
+
+	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+}
+
+/**
+ * 	sdev_evt_thread - send a uevent for each scsi event
+ *	@work: work struct for scsi_device
+ *
+ *	Dispatch queued events to their associated scsi_device kobjects
+ *	as uevents.
+ */
+void scsi_evt_thread(struct work_struct *work)
+{
+	struct scsi_device *sdev;
+	LIST_HEAD(event_list);
+
+	sdev = container_of(work, struct scsi_device, event_work);
+
+	while (1) {
+		struct scsi_event *evt;
+		struct list_head *this, *tmp;
+		unsigned long flags;
+
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_splice_init(&sdev->event_list, &event_list);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+
+		if (list_empty(&event_list))
+			break;
+
+		list_for_each_safe(this, tmp, &event_list) {
+			evt = list_entry(this, struct scsi_event, node);
+			list_del(&evt->node);
+			scsi_evt_emit(sdev, evt);
+			kfree(evt);
+		}
+	}
+}
+
+/**
+ * 	sdev_evt_send - send asserted event to uevent thread
+ *	@sdev: scsi_device event occurred on
+ *	@evt: event to send
+ *
+ *	Assert scsi device event asynchronously.
+ */
+void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
+{
+	unsigned long flags;
+
+	if (!test_bit(evt->evt_type, sdev->supported_events)) {
+		kfree(evt);
+		return;
+	}
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_add_tail(&evt->node, &sdev->event_list);
+	schedule_work(&sdev->event_work);
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdev_evt_send);
+
+/**
+ * 	sdev_evt_alloc - allocate a new scsi event
+ *	@evt_type: type of event to allocate
+ *	@gfpflags: GFP flags for allocation
+ *
+ *	Allocates and returns a new scsi_event.
+ */
+struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
+				  gfp_t gfpflags)
+{
+	struct scsi_event *evt = kzalloc(sizeof(struct scsi_event), gfpflags);
+	if (!evt)
+		return NULL;
+
+	evt->evt_type = evt_type;
+	INIT_LIST_HEAD(&evt->node);
+
+	/* evt_type-specific initialization, if any */
+	switch (evt_type) {
+	case SDEV_EVT_MEDIA_CHANGE:
+	default:
+		/* do nothing */
+		break;
+	}
+
+	return evt;
+}
+EXPORT_SYMBOL_GPL(sdev_evt_alloc);
+
+/**
+ * 	sdev_evt_send_simple - send asserted event to uevent thread
+ *	@sdev: scsi_device event occurred on
+ *	@evt_type: type of event to send
+ *	@gfpflags: GFP flags for allocation
+ *
+ *	Assert scsi device event asynchronously, given an event type.
+ */
+void sdev_evt_send_simple(struct scsi_device *sdev,
+			  enum scsi_device_event evt_type, gfp_t gfpflags)
+{
+	struct scsi_event *evt = sdev_evt_alloc(evt_type, gfpflags);
+	if (!evt) {
+		sdev_printk(KERN_ERR, sdev, "event %d eaten due to OOM\n",
+			    evt_type);
+		return;
+	}
+
+	sdev_evt_send(sdev, evt);
+}
+EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
+
+/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b53c5f6..40ea71c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -236,6 +236,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	extern void scsi_evt_thread(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -254,7 +255,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
+	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
+	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d531cee..f374fdc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -268,6 +268,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_device *sdev;
 	struct device *parent;
 	struct scsi_target *starget;
+	struct list_head *this, *tmp;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
@@ -282,6 +283,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
+	cancel_work_sync(&sdev->event_work);
+
+	list_for_each_safe(this, tmp, &sdev->event_list) {
+		struct scsi_event *evt;
+
+		evt = list_entry(this, struct scsi_event, node);
+		list_del(&evt->node);
+		kfree(evt);
+	}
+
 	if (sdev->request_queue) {
 		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
@@ -614,6 +625,41 @@ sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
+#define DECLARE_EVT_SHOW(name, Cap_name)				\
+static ssize_t								\
+sdev_show_evt_##name(struct device *dev, struct device_attribute *attr,	\
+				char *buf)				\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	int val = test_bit(SDEV_EVT_##Cap_name, sdev->supported_events);\
+	return snprintf(buf, 20, "%d\n", val);				\
+}
+
+#define DECLARE_EVT_STORE(name, Cap_name)				\
+static ssize_t								\
+sdev_store_evt_##name(struct device *dev, struct device_attribute *attr, \
+		      const char *buf, size_t count)			\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	int val = simple_strtoul(buf, NULL, 0);				\
+	if (val == 0)							\
+		clear_bit(SDEV_EVT_##Cap_name, sdev->supported_events);	\
+	else if (val == 1)						\
+		set_bit(SDEV_EVT_##Cap_name, sdev->supported_events);	\
+	else								\
+		return -EINVAL;						\
+	return count;							\
+}
+
+#define DECLARE_EVT(name, Cap_name)					\
+	DECLARE_EVT_SHOW(name, Cap_name)				\
+	DECLARE_EVT_STORE(name, Cap_name)				\
+	static DEVICE_ATTR(evt_##name, S_IRUGO, sdev_show_evt_##name,	\
+			   sdev_store_evt_##name);
+#define REF_EVT(name) &dev_attr_evt_##name.attr
+
+DECLARE_EVT(media_change, MEDIA_CHANGE)
+
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_device_blocked.attr,
@@ -631,6 +677,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
+	REF_EVT(media_change),
 	NULL
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d5057bc..66e9058 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -46,6 +46,22 @@ enum scsi_device_state {
 				 * to the scsi lld. */
 };
 
+enum scsi_device_event {
+	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
+
+	SDEV_EVT_LAST		= SDEV_EVT_MEDIA_CHANGE,
+	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
+};
+
+struct scsi_event {
+	enum scsi_device_event	evt_type;
+	struct list_head	node;
+
+	/* put union of data structures, for non-simple event types,
+	 * here
+	 */
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -127,6 +143,10 @@ struct scsi_device {
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 
+	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
+	struct list_head event_list;	/* asserted events */
+	struct work_struct event_work;
+
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
@@ -275,6 +295,11 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
+extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
+					  gfp_t gfpflags);
+extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt);
+extern void sdev_evt_send_simple(struct scsi_device *sdev,
+			  enum scsi_device_event evt_type, gfp_t gfpflags);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
