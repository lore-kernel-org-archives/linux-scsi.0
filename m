From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 5/9] [SCSI] Add support for scsi_target events
Date: Fri, 18 Jan 2013 11:27:10 -0500
Message-ID: <1358526434-1173-6-git-send-email-emilne@redhat.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3ARQ1S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 11:27:18 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRIjo017105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:18 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRFnI026564
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:17 -0500
In-Reply-To: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Added capability to generate uevents on scsi_target objects.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 135 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h   |   3 +
 drivers/scsi/scsi_scan.c   |  17 ++++++
 include/scsi/scsi_device.h |  34 ++++++++++++
 4 files changed, 189 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9de1186..056030a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2393,6 +2393,141 @@ scsi_target_resume(struct scsi_target *starget)
 }
 EXPORT_SYMBOL(scsi_target_resume);
 
+#ifdef CONFIG_SCSI_ENHANCED_UA
+/**
+ *	starget_evt_emit - emit a single SCSI target uevent
+ *	@starget: associated SCSI target
+ *	@evt: event to emit
+ *
+ *	Send a single uevent (starget_event) to the associated scsi_target.
+ */
+static void starget_evt_emit(struct scsi_target *starget,
+			     struct starget_event *evt)
+{
+	int idx = 0;
+	char *envp[3];
+
+	switch (evt->evt_type) {
+	case STARGET_EVT_LUN_CHANGE_REPORTED:
+		envp[idx++] = "STARGET_LUN_CHANGE_REPORTED=1";
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+
+	envp[idx++] = NULL;
+
+	kobject_uevent_env(&starget->dev.kobj, KOBJ_CHANGE, envp);
+}
+
+/**
+ *	starget_evt_thread - send a uevent for each scsi event
+ *	@work: work struct for scsi_target
+ *
+ *	Dispatch queued events to their associated scsi_target kobjects
+ *	as uevents.
+ */
+void starget_evt_thread(struct work_struct *work)
+{
+	struct scsi_target *starget;
+	LIST_HEAD(event_list);
+
+	starget = container_of(work, struct scsi_target, event_work);
+
+	while (1) {
+		struct starget_event *evt;
+		struct list_head *this, *tmp;
+		unsigned long flags;
+
+		spin_lock_irqsave(&starget->list_lock, flags);
+		list_splice_init(&starget->event_list, &event_list);
+		spin_unlock_irqrestore(&starget->list_lock, flags);
+
+		if (list_empty(&event_list))
+			break;
+
+		list_for_each_safe(this, tmp, &event_list) {
+			evt = list_entry(this, struct starget_event, node);
+			list_del(&evt->node);
+			starget_evt_emit(starget, evt);
+			kfree(evt);
+		}
+	}
+}
+
+/**
+ *	starget_evt_send - send asserted event to uevent thread
+ *	@starget: scsi_target event occurred on
+ *	@evt: event to send
+ *
+ *	Assert scsi target event asynchronously.
+ */
+void starget_evt_send(struct scsi_target *starget, struct starget_event *evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&starget->list_lock, flags);
+	list_add_tail(&evt->node, &starget->event_list);
+	schedule_work(&starget->event_work);
+	spin_unlock_irqrestore(&starget->list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(starget_evt_send);
+
+/**
+ *	starget_evt_alloc - allocate a new scsi_target event
+ *	@evt_type: type of event to allocate
+ *	@gfpflags: GFP flags for allocation
+ *
+ *	Allocates and returns a new starget_event.
+ */
+struct starget_event *starget_evt_alloc(enum scsi_target_event evt_type,
+					gfp_t gfpflags)
+{
+	struct starget_event *evt = kzalloc(sizeof(struct starget_event),
+					    gfpflags);
+	if (!evt)
+		return NULL;
+
+	evt->evt_type = evt_type;
+	INIT_LIST_HEAD(&evt->node);
+
+	/* evt_type-specific initialization, if any */
+	switch (evt_type) {
+	case STARGET_EVT_LUN_CHANGE_REPORTED:
+	default:
+		/* do nothing */
+		break;
+	}
+
+	return evt;
+}
+EXPORT_SYMBOL_GPL(starget_evt_alloc);
+
+/**
+ *	starget_evt_send_simple - send asserted event to uevent thread
+ *	@starget: scsi_target event occurred on
+ *	@evt_type: type of event to send
+ *	@gfpflags: GFP flags for allocation
+ *
+ *	Assert scsi target event asynchronously, given an event type.
+ */
+void starget_evt_send_simple(struct scsi_target *starget,
+			     enum scsi_target_event evt_type, gfp_t gfpflags)
+{
+	struct starget_event *evt = starget_evt_alloc(evt_type, gfpflags);
+	if (!evt) {
+		starget_printk(KERN_ERR, starget, "event %d eaten due to OOM\n",
+			       evt_type);
+		return;
+	}
+
+	starget_evt_send(starget, evt);
+}
+EXPORT_SYMBOL_GPL(starget_evt_send_simple);
+
+#endif
+
 /**
  * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
  * @sdev:	device to block
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 658a51a..e271792 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -91,6 +91,9 @@ struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
 extern void sdev_evt_thread(struct work_struct *work);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+extern void starget_evt_thread(struct work_struct *work);
+#endif
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8f444aa..3b0e5b5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -425,6 +425,11 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	INIT_LIST_HEAD(&starget->event_list);
+	spin_lock_init(&starget->list_lock);
+	INIT_WORK(&starget->event_work, starget_evt_thread);
+#endif
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
@@ -472,7 +477,19 @@ static void scsi_target_reap_usercontext(struct work_struct *work)
 {
 	struct scsi_target *starget =
 		container_of(work, struct scsi_target, ew.work);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	struct list_head *this, *tmp;
+
+	cancel_work_sync(&starget->event_work);
+
+	list_for_each_safe(this, tmp, &starget->event_list) {
+		struct starget_event *evt;
 
+		evt = list_entry(this, struct starget_event, node);
+		list_del(&evt->node);
+		kfree(evt);
+	}
+#endif
 	transport_remove_device(&starget->dev);
 	device_del(&starget->dev);
 	scsi_target_destroy(starget);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dad0a37..240aa6d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -230,6 +230,24 @@ enum scsi_target_state {
 	STARGET_DEL,
 };
 
+#ifdef CONFIG_SCSI_ENHANCED_UA
+enum scsi_target_event {
+	STARGET_EVT_LUN_CHANGE_REPORTED	= 1,	/* UA reported */
+
+	STARGET_EVT_LAST	= STARGET_EVT_LUN_CHANGE_REPORTED,
+	STARGET_EVT_MAXBITS	= STARGET_EVT_LAST + 1
+};
+
+struct starget_event {
+	enum scsi_target_event	evt_type;
+	struct list_head	node;
+
+	/* put union of data structures, for non-simple event types,
+	 * here
+	 */
+};
+#endif
+
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -252,6 +270,13 @@ struct scsi_target {
 						 * means no lun present. */
 	unsigned int		no_report_luns:1;	/* Don't use
 						 * REPORT LUNS for scanning. */
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	DECLARE_BITMAP(supported_events, STARGET_EVT_MAXBITS);
+	struct list_head	event_list;	/* asserted events */
+	struct work_struct	event_work;
+	spinlock_t list_lock;
+#endif
+
 	/* commands actually active on LLD. protected by host lock. */
 	unsigned int		target_busy;
 	/*
@@ -369,6 +394,15 @@ extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+extern struct starget_event *starget_evt_alloc(enum scsi_target_event evt_type,
+					       gfp_t gfpflags);
+extern void starget_evt_send(struct scsi_target *starget,
+			     struct starget_event *evt);
+extern void starget_evt_send_simple(struct scsi_target *starget,
+				    enum scsi_target_event evt_type,
+				    gfp_t gfpflags);
+#endif
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
 			     unsigned int id, unsigned int lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
-- 
1.7.11.7

