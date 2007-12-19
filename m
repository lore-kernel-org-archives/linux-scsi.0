From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] scsi error: add target reset eh handler
Date: Tue, 18 Dec 2007 22:11:08 -0600
Message-ID: <1198037477766-git-send-email-michaelc@cs.wisc.edu>
References: <1198037469664-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXLSEL6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2007 23:11:58 -0500
In-Reply-To: <1198037469664-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Drivers like qla4xxx and bnx2i (and it looks like some fcp drivers too),
want to be able to send a lun reset in the eh device handler and then a
target reset in some other handler. The old linux-iscsi driver, which did
the host per session like open-iscsi did the target reset in the host reset,
because the scsi command accounting that scsi_error.c does worked out
nicely for software iscsi, but does not work for hardware iscsi well.

This patch adds a eh_target_reset_handler any driver can use to send
a target reset.

The next patch will hook qla4xxx into it, and patches for iscsi_tcp/iser
and bnx2i will follow later when bnx2i is closer to getting merged.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |  121 ++++++++++++++++++++++++++++++++++++++-------
 include/scsi/scsi_eh.h    |    1 +
 include/scsi/scsi_host.h  |    1 +
 3 files changed, 105 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 169bc59..fb1f5bc 100644
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
@@ -1064,6 +1097,56 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
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
@@ -1451,9 +1534,11 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
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
 
@@ -1623,10 +1708,8 @@ void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
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
@@ -1659,10 +1742,8 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 
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
@@ -1724,6 +1805,10 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 		if (rtn == SUCCESS)
 			break;
 		/* FALLTHROUGH */
+	case SCSI_TRY_RESET_TARGET:
+		rtn = scsi_try_target_reset(scmd);
+		if (rtn == SUCCESS)
+			break;
 	case SCSI_TRY_RESET_HOST:
 		rtn = scsi_try_host_reset(scmd);
 		break;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index d21b891..8bfdee8 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -64,6 +64,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 #define SCSI_TRY_RESET_DEVICE	1
 #define SCSI_TRY_RESET_BUS	2
 #define SCSI_TRY_RESET_HOST	3
+#define SCSI_TRY_RESET_TARGET	4
 
 extern int scsi_reset_provider(struct scsi_device *, int);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..8bb0644 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -171,6 +171,7 @@ struct scsi_host_template {
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	int (* eh_target_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
-- 
1.5.1.2

