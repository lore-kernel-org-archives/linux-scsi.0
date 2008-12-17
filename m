From: michaelc@cs.wisc.edu
Subject: [PATCH] scsi_lib: don't decrement busy counters when inserting commands
Date: Tue, 16 Dec 2008 23:55:43 -0600
Message-ID: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYLQFzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 00:55:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch fixes a regression in scsi-misc introduced with:
312efe5efcdb02d604ea37a41d965f32ca276d6a
[SCSI] simplify scsi_io_completion().

The problem is that in previous kernels scsi_io_completion would call
scsi_requeue_command, but now it can call scsi_queue_insert for
something like a UNIT_ATTENTION (for netapp targets we get
UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
will call scsi_device_unbusy, but in the scsi_io_completion code path
scsi_finish_command has already called this so we now end up
with invalid host, target and device busy values.

Patch was made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |   16 +++++++++-------
 include/scsi/scsi.h     |    9 +++++++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 111f9e9..a47fcac 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -139,6 +139,7 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 		host->host_blocked = host->max_host_blocked;
 		break;
 	case SCSI_MLQUEUE_DEVICE_BUSY:
+	case SCSI_IO_COMPL_DEV_BUSY:
 		device->device_blocked = device->max_device_blocked;
 		break;
 	case SCSI_MLQUEUE_TARGET_BUSY:
@@ -146,11 +147,12 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 		break;
 	}
 
-	/*
-	 * Decrement the counters, since these commands are no longer
-	 * active on the host/device.
-	 */
-	scsi_device_unbusy(device);
+	if (!SCSI_IO_COMPL_RET(reason))
+		/*
+		 * Decrement the counters, since these commands are no longer
+		 * active on the host/device.
+		 */
+		scsi_device_unbusy(device);
 
 	/*
 	 * Requeue this command.  It will go before all other commands
@@ -1071,11 +1073,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
+		scsi_queue_insert(cmd, SCSI_IO_COMPL_EH_RETRY);
 		break;
 	case ACTION_DELAYED_RETRY:
 		/* Retry the same command after a delay */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		scsi_queue_insert(cmd, SCSI_IO_COMPL_DEV_BUSY);
 		break;
 	}
 }
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a109165..e9cc4fc 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -434,6 +434,15 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define SCSI_MLQUEUE_TARGET_BUSY 0x1058
 
 /*
+ * Midlevel io completeion path return values
+ */
+#define SCSI_IO_COMPL_EH_RETRY	 0x1059
+#define SCSI_IO_COMPL_DEV_BUSY	 0x1060
+
+#define SCSI_IO_COMPL_RET(_ret) \
+	(_ret == SCSI_IO_COMPL_EH_RETRY || _ret == SCSI_IO_COMPL_DEV_BUSY)
+
+/*
  *  Use these to separate status msg and our bytes
  *
  *  These are set by:
-- 
1.6.0.4

