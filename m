From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ibmvfc: Add support for fc_block_scsi_eh
Date: Thu, 17 Jun 2010 13:55:15 -0500
Message-ID: <201006171855.o5HItFbb008528@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:34401 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab0FQSz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:55:28 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HIkI7T021662
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:46:18 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5HItHpS085286
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:55:19 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HItGuK008637
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:55:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds support for fc_block_scsi_eh to block the EH handlers if
the target device is in the blocked state to ensure we don't
take devices offline.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_block_eh drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_block_eh	2010-06-17 10:36:04.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-06-17 10:36:04.000000000 -0500
@@ -2311,6 +2311,7 @@ static int ibmvfc_eh_abort_handler(struc
 	int rc = FAILED;
 
 	ENTER;
+	fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
 	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
 	abort_rc = ibmvfc_abort_task_set(sdev);
@@ -2337,6 +2338,7 @@ static int ibmvfc_eh_device_reset_handle
 	int rc = FAILED;
 
 	ENTER;
+	fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
 	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
 	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
@@ -2401,6 +2403,7 @@ static int ibmvfc_eh_target_reset_handle
 	unsigned long cancel_rc = 0;
 
 	ENTER;
+	fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
 	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
 	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
@@ -2422,6 +2425,7 @@ static int ibmvfc_eh_host_reset_handler(
 	int rc;
 	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
 
+	fc_block_scsi_eh(cmd);
 	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
 	rc = ibmvfc_issue_fc_host_lip(vhost->host);
 	return rc ? FAILED : SUCCESS;
_
