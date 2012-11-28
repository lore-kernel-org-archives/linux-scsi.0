From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 10/13] Make scsi_remove_host() wait for device removal
Date: Wed, 28 Nov 2012 13:51:13 +0100
Message-ID: <50B608C1.6080803@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:57404 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2K1MvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:51:15 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

SCSI LLDs may start cleaning up host resources needed by their
queuecommand() callback as soon as scsi_remove_host() finished.
Hence scsi_remove_host() must wait until blk_cleanup_queue() for
all devices associated with the host has finished. That avoids
that queuecommand() gets invoked after scsi_remove_host()
finished. Also, avoid adding new SCSI devices after
scsi_remove_host() started.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c      |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  |    1 +
 drivers/scsi/scsi_sysfs.c |    1 +
 include/scsi/scsi_host.h  |    1 +
 4 files changed, 33 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6ae16cd..7bd944e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -150,12 +150,31 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
 }
 EXPORT_SYMBOL(scsi_host_set_state);
 
+/* Return true if and only if scsi_remove_host() is allowed to finish. */
+static bool __scsi_remove_host_done(struct Scsi_Host *shost)
+{
+	lockdep_assert_held(shost->host_lock);
+
+	return list_empty(&shost->__devices);
+}
+
+/* Test whether scsi_remove_host() may finish, and if so, wake it up. */
+void __scsi_check_remove_host_done(struct Scsi_Host *shost)
+{
+	lockdep_assert_held(shost->host_lock);
+
+	if (__scsi_remove_host_done(shost))
+		wake_up(&shost->remove_host);
+}
+
 /**
  * scsi_remove_host - remove a scsi host
  * @shost:	a pointer to a scsi host to remove
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	DEFINE_WAIT(wait);
+
 	mutex_lock(&shost->scan_mutex);
 	spin_lock_irq(shost->host_lock);
 	if (scsi_host_set_state(shost, SHOST_CANCEL))
@@ -174,6 +193,16 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	spin_lock_irq(shost->host_lock);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
+	while (!__scsi_remove_host_done(shost)) {
+		prepare_to_wait_exclusive(&shost->remove_host, &wait,
+					  TASK_INTERRUPTIBLE);
+		if (__scsi_remove_host_done(shost))
+			break;
+		spin_unlock_irq(shost->host_lock);
+		schedule();
+		spin_lock_irq(shost->host_lock);
+	}
+	finish_wait(&shost->remove_host, &wait);
 	spin_unlock_irq(shost->host_lock);
 
 	transport_unregister_device(&shost->shost_gendev);
@@ -349,6 +378,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
+	init_waitqueue_head(&shost->remove_host);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 8f9a0ca..143517c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -26,6 +26,7 @@ struct scsi_nl_hdr;
 /* hosts.c */
 extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
+extern void __scsi_check_remove_host_done(struct Scsi_Host *shost);
 
 /* scsi.c */
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2661a957..89195e2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -348,6 +348,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
+	__scsi_check_remove_host_done(sdev->host);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..1b7fd89 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -577,6 +577,7 @@ struct Scsi_Host {
 	struct completion     * eh_action; /* Wait for specific actions on the
 					      host. */
 	wait_queue_head_t       host_wait;
+	wait_queue_head_t	remove_host;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
 
-- 
1.7.10.4

