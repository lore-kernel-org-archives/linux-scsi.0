From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v3 2/6] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and scsi_event to sdev_event
Date: Wed, 19 Jun 2013 13:42:37 -0400
Message-ID: <1371663761-22481-3-git-send-email-emilne@redhat.com>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab3FSRmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jun 2013 13:42:45 -0400
In-Reply-To: <1371663761-22481-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, rwheeler@redhat.com

From: "Ewan D. Milne" <emilne@redhat.com>

The names of the struct and some of the functions for scsi_device
events are too generic and do not match the comments in the source.
Changed all of the names to begin with sdev_ in order to avoid
naming issues and confusion with scsi_target events to be added.
Also changed name of sdev_evt_thread() to sdev_evt_work().

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 24 ++++++++++++------------
 drivers/scsi/scsi_priv.h   |  1 +
 drivers/scsi/scsi_scan.c   |  3 +--
 drivers/scsi/scsi_sysfs.c  |  4 ++--
 include/scsi/scsi_device.h |  6 +++---
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6dfb978..53f074d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2175,9 +2175,9 @@ EXPORT_SYMBOL(scsi_device_set_state);
  *	@sdev: associated SCSI device
  *	@evt: event to emit
  *
- *	Send a single uevent (scsi_event) to the associated scsi_device.
+ *	Send a single uevent (sdev_event) to the associated scsi_device.
  */
-static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
+static void sdev_evt_emit(struct scsi_device *sdev, struct sdev_event *evt)
 {
 	int idx = 0;
 	char *envp[3];
@@ -2198,13 +2198,13 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 }
 
 /**
- * 	sdev_evt_thread - send a uevent for each scsi event
+ *	sdev_evt_work - send a uevent for each scsi event
  *	@work: work struct for scsi_device
  *
  *	Dispatch queued events to their associated scsi_device kobjects
  *	as uevents.
  */
-void scsi_evt_thread(struct work_struct *work)
+void sdev_evt_work(struct work_struct *work)
 {
 	struct scsi_device *sdev;
 	LIST_HEAD(event_list);
@@ -2212,7 +2212,7 @@ void scsi_evt_thread(struct work_struct *work)
 	sdev = container_of(work, struct scsi_device, event_work);
 
 	while (1) {
-		struct scsi_event *evt;
+		struct sdev_event *evt;
 		struct list_head *this, *tmp;
 		unsigned long flags;
 
@@ -2224,9 +2224,9 @@ void scsi_evt_thread(struct work_struct *work)
 			break;
 
 		list_for_each_safe(this, tmp, &event_list) {
-			evt = list_entry(this, struct scsi_event, node);
+			evt = list_entry(this, struct sdev_event, node);
 			list_del(&evt->node);
-			scsi_evt_emit(sdev, evt);
+			sdev_evt_emit(sdev, evt);
 			kfree(evt);
 		}
 	}
@@ -2239,7 +2239,7 @@ void scsi_evt_thread(struct work_struct *work)
  *
  *	Assert scsi device event asynchronously.
  */
-void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
+void sdev_evt_send(struct scsi_device *sdev, struct sdev_event *evt)
 {
 	unsigned long flags;
 
@@ -2265,12 +2265,12 @@ EXPORT_SYMBOL_GPL(sdev_evt_send);
  *	@evt_type: type of event to allocate
  *	@gfpflags: GFP flags for allocation
  *
- *	Allocates and returns a new scsi_event.
+ *	Allocates and returns a new sdev_event.
  */
-struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
+struct sdev_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 				  gfp_t gfpflags)
 {
-	struct scsi_event *evt = kzalloc(sizeof(struct scsi_event), gfpflags);
+	struct sdev_event *evt = kzalloc(sizeof(struct sdev_event), gfpflags);
 	if (!evt)
 		return NULL;
 
@@ -2300,7 +2300,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_alloc);
 void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags)
 {
-	struct scsi_event *evt = sdev_evt_alloc(evt_type, gfpflags);
+	struct sdev_event *evt = sdev_evt_alloc(evt_type, gfpflags);
 	if (!evt) {
 		sdev_printk(KERN_ERR, sdev, "event %d eaten due to OOM\n",
 			    evt_type);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 07ce3f5..7f00813 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -90,6 +90,7 @@ extern void scsi_exit_queue(void);
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
+extern void sdev_evt_work(struct work_struct *work);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2e5fe58..47348ed 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -244,7 +244,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	extern void scsi_evt_thread(struct work_struct *work);
 	extern void scsi_requeue_run_queue(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
@@ -267,7 +266,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
-	INIT_WORK(&sdev->event_work, scsi_evt_thread);
+	INIT_WORK(&sdev->event_work, sdev_evt_work);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..686211e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -353,9 +353,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	cancel_work_sync(&sdev->event_work);
 
 	list_for_each_safe(this, tmp, &sdev->event_list) {
-		struct scsi_event *evt;
+		struct sdev_event *evt;
 
-		evt = list_entry(this, struct scsi_event, node);
+		evt = list_entry(this, struct sdev_event, node);
 		list_del(&evt->node);
 		kfree(evt);
 	}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..ea16419 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -56,7 +56,7 @@ enum scsi_device_event {
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
-struct scsi_event {
+struct sdev_event {
 	enum scsi_device_event	evt_type;
 	struct list_head	node;
 
@@ -359,9 +359,9 @@ extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
-extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
+extern struct sdev_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 					  gfp_t gfpflags);
-extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt);
+extern void sdev_evt_send(struct scsi_device *sdev, struct sdev_event *evt);
 extern void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
-- 
1.7.11.7

