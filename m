From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 11/13] Make scsi_remove_host() wait until error handling
 finished
Date: Wed, 28 Nov 2012 13:52:51 +0100
Message-ID: <50B60923.3080207@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:57141 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2K1Mwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:52:53 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

A SCSI LLD may start cleaning up host resources as soon as
scsi_remove_host() returns. These host resources may be needed by
the LLD in an implementation of one of the eh_* functions. So if
one of the eh_* functions is in progress when scsi_remove_host()
is invoked, wait until the eh_* function has finished. Also, do
not invoke any of the eh_* functions after scsi_remove_host() has
started.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/hosts.c      |    2 +-
 drivers/scsi/scsi_error.c |  114 ++++++++++++++++++++++++++++++++++-----------
 include/scsi/scsi_host.h  |    1 +
 3 files changed, 89 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7bd944e..477b8d6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -155,7 +155,7 @@ static bool __scsi_remove_host_done(struct Scsi_Host *shost)
 {
 	lockdep_assert_held(shost->host_lock);
 
-	return list_empty(&shost->__devices);
+	return list_empty(&shost->__devices) && !shost->eh_active;
 }
 
 /* Test whether scsi_remove_host() may finish, and if so, wake it up. */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..cab2ac3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -536,8 +536,52 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 }
 
 /**
+ * scsi_begin_eh - start host-related error handling
+ *
+ * Must be called before invoking any of the scsi_host_template.eh_* functions
+ * to avoid that scsi_remove_host() returns while one of these callback
+ * functions is in progress.
+ *
+ * Returns true if invoking the eh_* function is allowed and false if not.
+ * If this function returns true then scsi_end_eh() must be called eventually.
+ *
+ * Note: scsi_send_eh_cmnd() calls do not have to be protected by a
+ * scsi_begin_eh() / scsi_end_eh() pair since these operate on an unfinished
+ * block layer request. Since scsi_remove_host() waits until all SCSI devices
+ * have been removed and since blk_cleanup_queue() is invoked during SCSI
+ * device removal scsi_remove_host() won't finish while a scsi_send_eh_cmnd()
+ * call is in progress.
+ */
+static bool scsi_begin_eh(struct Scsi_Host *host)
+{
+	bool res;
+
+	spin_lock_irq(host->host_lock);
+	res = scsi_host_scan_allowed(host);
+	if (res) {
+		WARN_ON_ONCE(host->eh_active < 0 || host->eh_active > 1);
+		host->eh_active++;
+	}
+	spin_unlock_irq(host->host_lock);
+
+	return res;
+}
+
+/**
+ * scsi_end_eh - finish host-related error handling
+ */
+static void scsi_end_eh(struct Scsi_Host *host)
+{
+	spin_lock_irq(host->host_lock);
+	host->eh_active--;
+	WARN_ON_ONCE(host->eh_active < 0 || host->eh_active > 1);
+	__scsi_check_remove_host_done(host);
+	spin_unlock_irq(host->host_lock);
+}
+
+/**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
+ * @scmd:	SCSI cmd to send host reset.
  */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
@@ -552,14 +596,17 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_host_reset_handler(scmd);
-
-	if (rtn == SUCCESS) {
-		if (!hostt->skip_settle_delay)
-			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
-		spin_unlock_irqrestore(host->host_lock, flags);
+	rtn = FAST_IO_FAIL;
+	if (scsi_begin_eh(host)) {
+		rtn = hostt->eh_host_reset_handler(scmd);
+		if (rtn == SUCCESS) {
+			if (!hostt->skip_settle_delay)
+				ssleep(HOST_RESET_SETTLE_TIME);
+			spin_lock_irqsave(host->host_lock, flags);
+			scsi_report_bus_reset(host, scmd_channel(scmd));
+			spin_unlock_irqrestore(host->host_lock, flags);
+		}
+		scsi_end_eh(host);
 	}
 
 	return rtn;
@@ -582,14 +629,17 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_bus_reset_handler(scmd);
-
-	if (rtn == SUCCESS) {
-		if (!hostt->skip_settle_delay)
-			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
-		spin_unlock_irqrestore(host->host_lock, flags);
+	rtn = FAST_IO_FAIL;
+	if (scsi_begin_eh(host)) {
+		rtn = hostt->eh_bus_reset_handler(scmd);
+		if (rtn == SUCCESS) {
+			if (!hostt->skip_settle_delay)
+				ssleep(BUS_RESET_SETTLE_TIME);
+			spin_lock_irqsave(host->host_lock, flags);
+			scsi_report_bus_reset(host, scmd_channel(scmd));
+			spin_unlock_irqrestore(host->host_lock, flags);
+		}
+		scsi_end_eh(host);
 	}
 
 	return rtn;
@@ -621,12 +671,17 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_target_reset_handler(scmd);
-	if (rtn == SUCCESS) {
-		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(scsi_target(scmd->device), NULL,
-					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(host->host_lock, flags);
+	rtn = FAST_IO_FAIL;
+	if (scsi_begin_eh(host)) {
+		rtn = hostt->eh_target_reset_handler(scmd);
+		if (rtn == SUCCESS) {
+			spin_lock_irqsave(host->host_lock, flags);
+			__starget_for_each_device(scsi_target(scmd->device),
+						  NULL,
+						  __scsi_report_device_reset);
+			spin_unlock_irqrestore(host->host_lock, flags);
+		}
+		scsi_end_eh(host);
 	}
 
 	return rtn;
@@ -645,14 +700,19 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
-	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd);
-	if (rtn == SUCCESS)
-		__scsi_report_device_reset(scmd->device, NULL);
+	rtn = FAST_IO_FAIL;
+	if (scsi_begin_eh(host)) {
+		rtn = hostt->eh_device_reset_handler(scmd);
+		if (rtn == SUCCESS)
+			__scsi_report_device_reset(scmd->device, NULL);
+		scsi_end_eh(host);
+	}
 	return rtn;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 1b7fd89..5e2fcd2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -576,6 +576,7 @@ struct Scsi_Host {
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the
 					      host. */
+	int			eh_active;
 	wait_queue_head_t       host_wait;
 	wait_queue_head_t	remove_host;
 	struct scsi_host_template *hostt;
-- 
1.7.10.4

