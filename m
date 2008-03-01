From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] scsi_error: add target reset handler
Date: Fri, 29 Feb 2008 18:25:19 -0600
Message-ID: <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYCAA0B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 19:26:01 -0500
In-Reply-To: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The problem is that serveral drivers are sending a target reset from the
device reset handler, and if we have multiple devices a target reset gets
sent for each device when only one would be sufficient. And if we do a target
reset it affects all the commands on the target so the device reset handler
code only cleaning up one devices's commands makes programming the driver a
little more difficult than it should be.

This patch adds a target reset handler, which drivers can use to send
a target reset. If successful it cleans up the commands for a devices
accessed through that starget.

The next patches will convert drivers to use it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |  122 ++++++++++++++++++++++++++++++++++++++-------
 include/scsi/scsi_eh.h    |    1 +
 include/scsi/scsi_host.h  |    1 +
 3 files changed, 106 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 045a086..1221d2c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -524,6 +524,41 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
+static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
+{
+	sdev->was_reset = 1;
+	sdev->expecting_cc_ua = 1;
+}
+
+/**
+ * scsi_try_target_reset - Ask host to perform a target reset
+ * @scmd:	SCSI cmd used to send a target reset
+ *
+ * Notes:
+ *    There is no timeout for this operation.  if this operation is
+ *    unreliable for a given host, then the host itself needs to put a
+ *    timer on it, and set the host back to a consistent state prior to
+ *    returning.
+ */
+static int scsi_try_target_reset(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	int rtn;
+
+	if (!scmd->device->host->hostt->eh_target_reset_handler)
+		return FAILED;
+
+	rtn = scmd->device->host->hostt->eh_target_reset_handler(scmd);
+	if (rtn == SUCCESS) {
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		__starget_for_each_device(scsi_target(scmd->device), NULL,
+					  __scsi_report_device_reset);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	}
+
+	return rtn;
+}
+
 /**
  * scsi_try_bus_device_reset - Ask host to perform a BDR on a dev
  * @scmd:	SCSI cmd used to send BDR
@@ -542,11 +577,8 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 		return FAILED;
 
 	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
-	if (rtn == SUCCESS) {
-		scmd->device->was_reset = 1;
-		scmd->device->expecting_cc_ua = 1;
-	}
-
+	if (rtn == SUCCESS)
+		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
 }
 
@@ -584,8 +616,9 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
 	if (__scsi_try_to_abort_cmd(scmd) != SUCCESS)
 		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
-			if (scsi_try_bus_reset(scmd) != SUCCESS)
-				scsi_try_host_reset(scmd);
+			if (scsi_try_target_reset(scmd) != SUCCESS)
+				if (scsi_try_bus_reset(scmd) != SUCCESS)
+					scsi_try_host_reset(scmd);
 }
 
 /**
@@ -1060,6 +1093,56 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 }
 
 /**
+ * scsi_eh_target_reset - send target reset if needed
+ * @shost:	scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
+ *
+ * Notes:
+ *    Try a target reset.
+ */
+static int scsi_eh_target_reset(struct Scsi_Host *shost,
+				struct list_head *work_q,
+				struct list_head *done_q)
+{
+	struct scsi_cmnd *scmd, *tgtr_scmd, *next;
+	unsigned int id;
+	int rtn;
+
+	for (id = 0; id <= shost->max_id; id++) {
+		tgtr_scmd = NULL;
+		list_for_each_entry(scmd, work_q, eh_entry) {
+			if (id == scmd_id(scmd)) {
+				tgtr_scmd = scmd;
+				break;
+			}
+		}
+		if (!tgtr_scmd)
+			continue;
+
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
+						  "to target %d\n",
+						  current->comm, id));
+		rtn = scsi_try_target_reset(tgtr_scmd);
+		if (rtn == SUCCESS) {
+			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
+				if (id == scmd_id(scmd))
+					if (!scsi_device_online(scmd->device) ||
+					    !scsi_eh_tur(tgtr_scmd))
+						scsi_eh_finish_cmd(scmd,
+								   done_q);
+			}
+		} else
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Target reset"
+							  " failed target: "
+							  "%d\n",
+							  current->comm, id));
+	}
+
+	return list_empty(work_q);
+}
+
+/**
  * scsi_eh_bus_reset - send a bus reset 
  * @shost:	&scsi host being recovered.
  * @work_q:     &list_head for pending commands.
@@ -1447,9 +1530,11 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 {
 	if (!scsi_eh_stu(shost, work_q, done_q))
 		if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
-			if (!scsi_eh_bus_reset(shost, work_q, done_q))
-				if (!scsi_eh_host_reset(work_q, done_q))
-					scsi_eh_offline_sdevs(work_q, done_q);
+			if (!scsi_eh_target_reset(shost, work_q, done_q))
+				if (!scsi_eh_bus_reset(shost, work_q, done_q))
+					if (!scsi_eh_host_reset(work_q, done_q))
+						scsi_eh_offline_sdevs(work_q,
+								      done_q);
 }
 EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 
@@ -1619,10 +1704,8 @@ void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev)) {
-			sdev->was_reset = 1;
-			sdev->expecting_cc_ua = 1;
-		}
+		if (channel == sdev_channel(sdev))
+			__scsi_report_device_reset(sdev, NULL);
 	}
 }
 EXPORT_SYMBOL(scsi_report_bus_reset);
@@ -1655,10 +1738,8 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 
 	__shost_for_each_device(sdev, shost) {
 		if (channel == sdev_channel(sdev) &&
-		    target == sdev_id(sdev)) {
-			sdev->was_reset = 1;
-			sdev->expecting_cc_ua = 1;
-		}
+		    target == sdev_id(sdev))
+			__scsi_report_device_reset(sdev, NULL);
 	}
 }
 EXPORT_SYMBOL(scsi_report_device_reset);
@@ -1714,6 +1795,11 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 		if (rtn == SUCCESS)
 			break;
 		/* FALLTHROUGH */
+	case SCSI_TRY_RESET_TARGET:
+		rtn = scsi_try_target_reset(scmd);
+		if (rtn == SUCCESS)
+			break;
+		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_BUS:
 		rtn = scsi_try_bus_reset(scmd);
 		if (rtn == SUCCESS)
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 25071d5..37a7614 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -64,6 +64,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 #define SCSI_TRY_RESET_DEVICE	1
 #define SCSI_TRY_RESET_BUS	2
 #define SCSI_TRY_RESET_HOST	3
+#define SCSI_TRY_RESET_TARGET	4
 
 extern int scsi_reset_provider(struct scsi_device *, int);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 530ff4c..4913286 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -172,6 +172,7 @@ struct scsi_host_template {
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	int (* eh_target_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
-- 
1.5.4.1

