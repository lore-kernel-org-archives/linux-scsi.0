From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi: Fix lost EH commands
Date: Tue, 30 Jan 2007 17:51:17 -0600
Message-ID: <11180.6885608987$1170201110@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58186 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXA3XvW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 18:51:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l0UNpJQl004831
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 18:51:19 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0UNpKOR296700
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 18:51:20 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0UNpJ6A002714
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 18:51:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brazilnut@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


If an EH command times out today, the LLDD's abort handler
will be called to abort the command. It is assumed that this
completes successfully, which can result in the command getting
completed later resulting in an oops. Improve the current
implementation by escalating all the way to host reset if
necessary in order to clean up the EH command.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/scsi_error.c |  239 ++++++++++++++--------------
 1 files changed, 123 insertions(+), 116 deletions(-)

diff -puN drivers/scsi/scsi_error.c~scsi_fix_eh_lost_cmds drivers/scsi/scsi_error.c
--- linux-2.6/drivers/scsi/scsi_error.c~scsi_fix_eh_lost_cmds	2007-01-12 15:42:11.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/scsi_error.c	2007-01-12 15:42:11.000000000 -0600
@@ -453,6 +453,128 @@ static void scsi_eh_done(struct scsi_cmn
 }
 
 /**
+ * scsi_try_host_reset - ask host adapter to reset itself
+ * @scmd:	SCSI cmd to send hsot reset.
+ **/
+static int scsi_try_host_reset(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	int rtn;
+
+	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
+					  __FUNCTION__));
+
+	if (!scmd->device->host->hostt->eh_host_reset_handler)
+		return FAILED;
+
+	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+
+	if (rtn == SUCCESS) {
+		if (!scmd->device->host->hostt->skip_settle_delay)
+			ssleep(HOST_RESET_SETTLE_TIME);
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		scsi_report_bus_reset(scmd->device->host,
+				      scmd_channel(scmd));
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	}
+
+	return rtn;
+}
+
+/**
+ * scsi_try_bus_reset - ask host to perform a bus reset
+ * @scmd:	SCSI cmd to send bus reset.
+ **/
+static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	int rtn;
+
+	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
+					  __FUNCTION__));
+
+	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+		return FAILED;
+
+	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+
+	if (rtn == SUCCESS) {
+		if (!scmd->device->host->hostt->skip_settle_delay)
+			ssleep(BUS_RESET_SETTLE_TIME);
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		scsi_report_bus_reset(scmd->device->host,
+				      scmd_channel(scmd));
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	}
+
+	return rtn;
+}
+
+/**
+ * scsi_try_bus_device_reset - Ask host to perform a BDR on a dev
+ * @scmd:	SCSI cmd used to send BDR
+ *
+ * Notes:
+ *    There is no timeout for this operation.  if this operation is
+ *    unreliable for a given host, then the host itself needs to put a
+ *    timer on it, and set the host back to a consistent state prior to
+ *    returning.
+ **/
+static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
+{
+	int rtn;
+
+	if (!scmd->device->host->hostt->eh_device_reset_handler)
+		return FAILED;
+
+	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
+	if (rtn == SUCCESS) {
+		scmd->device->was_reset = 1;
+		scmd->device->expecting_cc_ua = 1;
+	}
+
+	return rtn;
+}
+
+static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
+{
+	if (!scmd->device->host->hostt->eh_abort_handler)
+		return FAILED;
+
+	return scmd->device->host->hostt->eh_abort_handler(scmd);
+}
+
+/**
+ * scsi_try_to_abort_cmd - Ask host to abort a running command.
+ * @scmd:	SCSI cmd to abort from Lower Level.
+ *
+ * Notes:
+ *    This function will not return until the user's completion function
+ *    has been called.  there is no timeout on this operation.  if the
+ *    author of the low-level driver wishes this operation to be timed,
+ *    they can provide this facility themselves.  helper functions in
+ *    scsi_error.c can be supplied to make this easier to do.
+ **/
+static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
+{
+	/*
+	 * scsi_done was called just after the command timed out and before
+	 * we had a chance to process it. (db)
+	 */
+	if (scmd->serial_number == 0)
+		return SUCCESS;
+	return __scsi_try_to_abort_cmd(scmd);
+}
+
+static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
+{
+	if (__scsi_try_to_abort_cmd(scmd) != SUCCESS)
+		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
+			if (scsi_try_bus_reset(scmd) != SUCCESS)
+				scsi_try_host_reset(scmd);
+}
+
+/**
  * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
  * @scmd:       SCSI command structure to hijack
  * @cmnd:       CDB to send
@@ -579,13 +701,7 @@ static int scsi_send_eh_cmnd(struct scsi
 			break;
 		}
 	} else {
-		/*
-		 * FIXME(eric) - we are not tracking whether we could
-		 * abort a timed out command or not.  not sure how
-		 * we should treat them differently anyways.
-		 */
-		if (shost->hostt->eh_abort_handler)
-			shost->hostt->eh_abort_handler(scmd);
+		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}
 
@@ -717,31 +833,6 @@ static int scsi_eh_get_sense(struct list
 }
 
 /**
- * scsi_try_to_abort_cmd - Ask host to abort a running command.
- * @scmd:	SCSI cmd to abort from Lower Level.
- *
- * Notes:
- *    This function will not return until the user's completion function
- *    has been called.  there is no timeout on this operation.  if the
- *    author of the low-level driver wishes this operation to be timed,
- *    they can provide this facility themselves.  helper functions in
- *    scsi_error.c can be supplied to make this easier to do.
- **/
-static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
-{
-	if (!scmd->device->host->hostt->eh_abort_handler)
-		return FAILED;
-
-	/*
-	 * scsi_done was called just after the command timed out and before
-	 * we had a chance to process it. (db)
-	 */
-	if (scmd->serial_number == 0)
-		return SUCCESS;
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
-}
-
-/**
  * scsi_eh_tur - Send TUR to device.
  * @scmd:	Scsi cmd to send TUR
  *
@@ -815,32 +906,6 @@ static int scsi_eh_abort_cmds(struct lis
 }
 
 /**
- * scsi_try_bus_device_reset - Ask host to perform a BDR on a dev
- * @scmd:	SCSI cmd used to send BDR	
- *
- * Notes:
- *    There is no timeout for this operation.  if this operation is
- *    unreliable for a given host, then the host itself needs to put a
- *    timer on it, and set the host back to a consistent state prior to
- *    returning.
- **/
-static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
-{
-	int rtn;
-
-	if (!scmd->device->host->hostt->eh_device_reset_handler)
-		return FAILED;
-
-	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
-	if (rtn == SUCCESS) {
-		scmd->device->was_reset = 1;
-		scmd->device->expecting_cc_ua = 1;
-	}
-
-	return rtn;
-}
-
-/**
  * scsi_eh_try_stu - Send START_UNIT to device.
  * @scmd:	Scsi cmd to send START_UNIT
  *
@@ -971,64 +1036,6 @@ static int scsi_eh_bus_device_reset(stru
 }
 
 /**
- * scsi_try_bus_reset - ask host to perform a bus reset
- * @scmd:	SCSI cmd to send bus reset.
- **/
-static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
-{
-	unsigned long flags;
-	int rtn;
-
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
-					  __FUNCTION__));
-
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
-		return FAILED;
-
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
-
-	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
-			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
-	}
-
-	return rtn;
-}
-
-/**
- * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
- **/
-static int scsi_try_host_reset(struct scsi_cmnd *scmd)
-{
-	unsigned long flags;
-	int rtn;
-
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
-					  __FUNCTION__));
-
-	if (!scmd->device->host->hostt->eh_host_reset_handler)
-		return FAILED;
-
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
-
-	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
-			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
-	}
-
-	return rtn;
-}
-
-/**
  * scsi_eh_bus_reset - send a bus reset 
  * @shost:	scsi host being recovered.
  * @eh_done_q:	list_head for processed commands.
_
