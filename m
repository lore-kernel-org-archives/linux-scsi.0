From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/5] ibmvfc: Support FAST_IO_FAIL in EH handlers
Date: Fri, 12 Apr 2013 08:25:16 -0500
Message-ID: <201304121325.r3CDPGhF025011@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58939 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab3DLNZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 09:25:21 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 12 Apr 2013 09:25:20 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 1BFA838C8042
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:18 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3CDPHxQ54329426
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:17 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3CDPHlu025024
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcjenn@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


Adds support for receiving FAST_IO_FAIL from fc_block_scsi_eh
when in error recovery. This fixes cases of devices being
taken offline when they are no longer accessible on the fabric,
preventing them from coming back online when the fabric recovers.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   69 ++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_block_scsi_eh_fast_fail drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_block_scsi_eh_fast_fail	2013-01-22 07:51:01.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-02-06 14:56:06.000000000 -0600
@@ -2383,24 +2383,30 @@ out:
  * @cmd:	scsi command to abort
  *
  * Returns:
- *	SUCCESS / FAILED
+ *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
 static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	int cancel_rc, abort_rc;
+	int cancel_rc, block_rc, abort_rc = 0;
 	int rc = FAILED;
 
 	ENTER;
-	fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
-	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
-	abort_rc = ibmvfc_abort_task_set(sdev);
+	if (block_rc != FAST_IO_FAIL) {
+		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
+		abort_rc = ibmvfc_abort_task_set(sdev);
+	} else
+		cancel_rc = ibmvfc_cancel_all(sdev, 0);
 
 	if (!cancel_rc && !abort_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
 
+	if (block_rc == FAST_IO_FAIL && rc != FAILED)
+		rc = FAST_IO_FAIL;
+
 	LEAVE;
 	return rc;
 }
@@ -2410,29 +2416,47 @@ static int ibmvfc_eh_abort_handler(struc
  * @cmd:	scsi command struct
  *
  * Returns:
- *	SUCCESS / FAILED
+ *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
 static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	int cancel_rc, reset_rc;
+	int cancel_rc, block_rc, reset_rc = 0;
 	int rc = FAILED;
 
 	ENTER;
-	fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
-	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
-	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
+	if (block_rc != FAST_IO_FAIL) {
+		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
+		reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
+	} else
+		cancel_rc = ibmvfc_cancel_all(sdev, 0);
 
 	if (!cancel_rc && !reset_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
 
+	if (block_rc == FAST_IO_FAIL && rc != FAILED)
+		rc = FAST_IO_FAIL;
+
 	LEAVE;
 	return rc;
 }
 
 /**
+ * ibmvfc_dev_cancel_all_noreset - Device iterated cancel all function
+ * @sdev:	scsi device struct
+ * @data:	return code
+ *
+ **/
+static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
+{
+	unsigned long *rc = data;
+	*rc |= ibmvfc_cancel_all(sdev, 0);
+}
+
+/**
  * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
  * @sdev:	scsi device struct
  * @data:	return code
@@ -2449,26 +2473,33 @@ static void ibmvfc_dev_cancel_all_reset(
  * @cmd:	scsi command struct
  *
  * Returns:
- *	SUCCESS / FAILED
+ *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
 static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct scsi_target *starget = scsi_target(sdev);
-	int reset_rc;
+	int block_rc;
+	int reset_rc = 0;
 	int rc = FAILED;
 	unsigned long cancel_rc = 0;
 
 	ENTER;
-	fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
-	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
-	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
+	if (block_rc != FAST_IO_FAIL) {
+		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
+		reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
+	} else
+		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_noreset);
 
 	if (!cancel_rc && !reset_rc)
 		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
 
+	if (block_rc == FAST_IO_FAIL && rc != FAILED)
+		rc = FAST_IO_FAIL;
+
 	LEAVE;
 	return rc;
 }
@@ -2480,12 +2511,16 @@ static int ibmvfc_eh_target_reset_handle
  **/
 static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	int rc;
+	int rc, block_rc;
 	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
 
-	fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(cmd);
 	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
 	rc = ibmvfc_issue_fc_host_lip(vhost->host);
+
+	if (block_rc == FAST_IO_FAIL)
+		return FAST_IO_FAIL;
+
 	return rc ? FAILED : SUCCESS;
 }
 
_

