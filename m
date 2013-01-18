From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 4/9] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and scsi_event to sdev_event
Date: Fri, 18 Jan 2013 11:27:09 -0500
Message-ID: <1358526434-1173-5-git-send-email-emilne@redhat.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab3ARQ1R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 11:27:17 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRHfp017100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:17 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRFnH026564
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:17 -0500
In-Reply-To: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The names of the struct and some of the functions for scsi_device
events are too generic and do not match the comments in the source.
Changed all of the names to begin with sdev_ in order to avoid
naming issues and confusion with scsi_target events to be added.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 22 +++++++++++-----------
 drivers/scsi/scsi_priv.h   |  1 +
 drivers/scsi/scsi_scan.c   |  3 +--
 drivers/scsi/scsi_sysfs.c  |  4 ++--
 include/scsi/scsi_device.h |  6 +++---
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eba68de..9de1186 100644
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
@@ -2206,7 +2206,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
  *	Dispatch queued events to their associated scsi_device kobjects
  *	as uevents.
  */
-void scsi_evt_thread(struct work_struct *work)
+void sdev_evt_thread(struct work_struct *work)
 {
 	struct scsi_device *sdev;
 	LIST_HEAD(event_list);
@@ -2214,7 +2214,7 @@ void scsi_evt_thread(struct work_struct *work)
 	sdev = container_of(work, struct scsi_device, event_work);
 
 	while (1) {
-		struct scsi_event *evt;
+		struct sdev_event *evt;
 		struct list_head *this, *tmp;
 		unsigned long flags;
 
@@ -2226,9 +2226,9 @@ void scsi_evt_thread(struct work_struct *work)
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
@@ -2241,7 +2241,7 @@ void scsi_evt_thread(struct work_struct *work)
  *
  *	Assert scsi device event asynchronously.
  */
-void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
+void sdev_evt_send(struct scsi_device *sdev, struct sdev_event *evt)
 {
 	unsigned long flags;
 
@@ -2267,12 +2267,12 @@ EXPORT_SYMBOL_GPL(sdev_evt_send);
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
 
@@ -2303,7 +2303,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_alloc);
 void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags)
 {
-	struct scsi_event *evt = sdev_evt_alloc(evt_type, gfpflags);
+	struct sdev_event *evt = sdev_evt_alloc(evt_type, gfpflags);
 	if (!evt) {
 		sdev_printk(KERN_ERR, sdev, "event %d eaten due to OOM\n",
 			    evt_type);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 07ce3f5..658a51a 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -90,6 +90,7 @@ extern void scsi_exit_queue(void);
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
+extern void sdev_evt_thread(struct work_struct *work);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2e5fe58..8f444aa 100644
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
+	INIT_WORK(&sdev->event_work, sdev_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ba7da3b..b22210d 100644
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
index e4c964e..dad0a37 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -57,7 +57,7 @@ enum scsi_device_event {
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
-struct scsi_event {
+struct sdev_event {
 	enum scsi_device_event	evt_type;
 	struct list_head	node;
 
@@ -360,9 +360,9 @@ extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
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

