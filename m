From: Jason Chu <jasonchu@marvell.com>
Subject: [PATCH]remove redundant fields in sas_task structure.
Date: Tue, 22 Apr 2008 10:32:35 +0800
Message-ID: <1208831555.5741.0.camel@MVRL-SH-5F-5A01>
Reply-To: jasonchu@marvell.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:51980 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757121AbYDVCcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 22:32:46 -0400
Received: from sc-exch02.marvell.com (sc-exch02.marvell.com [10.68.76.199])
	by maili.marvell.com (Postfix) with ESMTP id B861F2C020
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 19:32:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

'timer' and 'completion' field in struct sas_task are used for discovery
sata and expander devices and
as such they are redundant for regular tasks. According to the process
of device discovery, we can use a dedicated timer and completion pair
for wait-for-completion discovery event.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
---
drivers/scsi/libsas/sas_ata.c       |   22 ++++++++++++----------
drivers/scsi/libsas/sas_expander.c  |   18 +++++++++---------
drivers/scsi/libsas/sas_init.c      |    4 ++++
drivers/scsi/libsas/sas_internal.h  |    5 +++++
drivers/scsi/libsas/sas_scsi_host.c |    7 +++++--
include/scsi/libsas.h               |    6 ------
 6 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c
b/drivers/scsi/libsas/sas_ata.c
index 744f06d..1294a3a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -421,14 +421,14 @@ static void sas_task_timedout(unsigned long _task)
 		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	complete(&task->completion);
+	complete(&disc_task_completion);
 }
 
 static void sas_disc_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->timer))
+	if (!del_timer(&disc_task_timer))
 		return;
-	complete(&task->completion);
+	complete(&disc_task_completion);
 }
 
 #define SAS_DEV_TIMEOUT 10
@@ -476,21 +476,21 @@ static int sas_execute_task(struct sas_task *task,
void *buffer, int size,
 
 	for (retries = 0; retries < 5; retries++) {
 		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_completion(&task->completion);
+		init_completion(&disc_task_completion);
 
-		task->timer.data = (unsigned long) task;
-		task->timer.function = sas_task_timedout;
-		task->timer.expires = jiffies + SAS_DEV_TIMEOUT*HZ;
-		add_timer(&task->timer);
+		disc_task_timer.data = (unsigned long) task;
+		disc_task_timer.function = sas_task_timedout;
+		disc_task_timer.expires = jiffies + SAS_DEV_TIMEOUT*HZ;
+		add_timer(&disc_task_timer);
 
 		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
 		if (res) {
-			del_timer(&task->timer);
+			del_timer(&disc_task_timer);
 			SAS_DPRINTK("executing SAS discovery task failed:%d\n",
 				    res);
 			goto ex_err;
 		}
-		wait_for_completion(&task->completion);
+		wait_for_completion(&disc_task_completion);
 		res = -ECOMM;
 		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 			int res2;
@@ -754,6 +754,8 @@ int sas_discover_sata(struct domain_device *dev)
 
 	switch (dev->dev_type) {
 	case SATA_DEV:
+		init_completion(&disc_task_completion);
+		init_timer(&disc_task_timer);
 		res = sas_discover_sata_dev(dev);
 		break;
 	case SATA_PM:
diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index aefd865..bc5625c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -49,14 +49,14 @@ static void smp_task_timedout(unsigned long _task)
 		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	complete(&task->completion);
+	complete(&disc_task_completion);
 }
 
 static void smp_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->timer))
+	if (!del_timer(&disc_task_timer))
 		return;
-	complete(&task->completion);
+	complete(&disc_task_completion);
 }
 
 /* Give it some long enough timeout. In seconds. */
@@ -82,20 +82,20 @@ static int smp_execute_task(struct domain_device
*dev, void *req, int req_size,
 
 		task->task_done = smp_task_done;
 
-		task->timer.data = (unsigned long) task;
-		task->timer.function = smp_task_timedout;
-		task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
-		add_timer(&task->timer);
+		disc_task_timer.data = (unsigned long) task;
+		disc_task_timer.function = smp_task_timedout;
+		disc_task_timer.expires = jiffies + SMP_TIMEOUT*HZ;
+		add_timer(&disc_task_timer);
 
 		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
 
 		if (res) {
-			del_timer(&task->timer);
+			del_timer(&disc_task_timer);
 			SAS_DPRINTK("executing SMP task failed:%d\n", res);
 			goto ex_err;
 		}
 
-		wait_for_completion(&task->completion);
+		wait_for_completion(&disc_task_completion);
 		res = -ECOMM;
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			SAS_DPRINTK("smp task timed out or aborted\n");
diff --git a/drivers/scsi/libsas/sas_init.c
b/drivers/scsi/libsas/sas_init.c
index 9cd5abe..ba193b2 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -36,6 +36,10 @@
 
 #include "../scsi_sas_internal.h"
 
+#if defined(CONFIG_SCSI_SAS_ATA) || defined(CONFIG_SCSI_SAS_HOST_SMP)
+struct completion disc_task_completion;
+struct timer_list disc_task_timer;
+#endif
 struct kmem_cache *sas_task_cache;
 
 /*------------ SAS addr hash -----------*/
diff --git a/drivers/scsi/libsas/sas_internal.h
b/drivers/scsi/libsas/sas_internal.h
index b4f9368..7d3b195 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -42,6 +42,11 @@
 #define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
 #define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *)
_t; } while (0)
 
+#if defined(CONFIG_SCSI_SAS_ATA) || defined(CONFIG_SCSI_SAS_HOST_SMP)
+extern struct completion disc_task_completion;
+extern struct timer_list disc_task_timer;
+#endif
+
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
 int sas_show_class(enum sas_class class, char *buf);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c
b/drivers/scsi/libsas/sas_scsi_host.c
index 601ec5b..86cec75 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1028,9 +1028,12 @@ void sas_task_abort(struct sas_task *task)
 
 	/* Escape for libsas internal commands */
 	if (!sc) {
-		if (!del_timer(&task->timer))
+#if defined(CONFIG_SCSI_SAS_HOST_SMP) || defined(CONFIG_SCSI_SAS_ATA)
+
+		if (!del_timer(&disc_task_timer))
 			return;
-		task->timer.function(task->timer.data);
+		disc_task_timer.function(disc_task_timer.data);
+#endif
 		return;
 	}
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 98724ba..1520d15 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -537,10 +537,6 @@ struct sas_task {
 
 	enum   sas_protocol      task_proto;
 
-	/* Used by the discovery code. */
-	struct timer_list     timer;
-	struct completion     completion;
-
 	union {
 		struct sas_ata_task ata_task;
 		struct sas_smp_task smp_task;
@@ -577,8 +573,6 @@ static inline struct sas_task *sas_alloc_task(gfp_t
flags)
 		INIT_LIST_HEAD(&task->list);
 		spin_lock_init(&task->task_state_lock);
 		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_timer(&task->timer);
-		init_completion(&task->completion);
 	}
 
 	return task;

