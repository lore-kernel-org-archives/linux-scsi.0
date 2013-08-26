From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 5/5] scsi: Rename scsi_evt_thread() to scsi_evt_work()
Date: Mon, 26 Aug 2013 11:03:40 -0400
Message-ID: <1377529420-31775-6-git-send-email-emilne@redhat.com>
References: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3HZPDn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 11:03:43 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3hNA002251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:43 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3eJb014378
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:43 -0400
In-Reply-To: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The scsi_evt_thread() function is not actually a thread, it is
a work function.  So it should be named scsi_evt_work() instead.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c  | 4 ++--
 drivers/scsi/scsi_priv.h | 1 +
 drivers/scsi/scsi_scan.c | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6585049..97699a5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2198,13 +2198,13 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 }
 
 /**
- * 	sdev_evt_thread - send a uevent for each scsi event
+ *	scsi_evt_work - send a uevent for each scsi event
  *	@work: work struct for scsi_device
  *
  *	Dispatch queued events to their associated scsi_device kobjects
  *	as uevents.
  */
-void scsi_evt_thread(struct work_struct *work)
+void scsi_evt_work(struct work_struct *work)
 {
 	struct scsi_device *sdev;
 	LIST_HEAD(event_list);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 07ce3f5..ed80f21 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -90,6 +90,7 @@ extern void scsi_exit_queue(void);
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
+extern void scsi_evt_work(struct work_struct *work);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2e5fe58..0adfecb 100644
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
+	INIT_WORK(&sdev->event_work, scsi_evt_work);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
-- 
1.7.11.7

