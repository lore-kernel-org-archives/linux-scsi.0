From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ibmvfc: Fix adapter cancel flags for terminate_rport_io
Date: Mon, 19 Oct 2009 14:19:46 -0500
Message-ID: <200910191919.n9JJJkkQ013427@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56214 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbZJSTTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2009 15:19:43 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JJILnq008341
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:18:21 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JJJlBX254076
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:19:47 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9JJJleu013472
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:19:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


When issuing a Cancel to the virtual fibre channel adapter,
the interface specifies a flags field for the client to indicate
what kind of error recovery is being performed. Fix up these
flags for terminate_rport_io to indicate an abort task set
rather than a target reset.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_terminate_rport drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_terminate_rport	2009-10-05 10:30:48.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-10-05 10:30:48.000000000 -0500
@@ -2064,12 +2064,24 @@ static int ibmvfc_eh_device_reset_handle
 }
 
 /**
- * ibmvfc_dev_cancel_all - Device iterated cancel all function
+ * ibmvfc_dev_cancel_all_abts - Device iterated cancel all function
  * @sdev:	scsi device struct
  * @data:	return code
  *
  **/
-static void ibmvfc_dev_cancel_all(struct scsi_device *sdev, void *data)
+static void ibmvfc_dev_cancel_all_abts(struct scsi_device *sdev, void *data)
+{
+	unsigned long *rc = data;
+	*rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
+}
+
+/**
+ * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
+ * @sdev:	scsi device struct
+ * @data:	return code
+ *
+ **/
+static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
 {
 	unsigned long *rc = data;
 	*rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_TGT_RESET);
@@ -2105,7 +2117,7 @@ static int ibmvfc_eh_target_reset_handle
 
 	ENTER;
 	ibmvfc_wait_while_resetting(vhost);
-	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all);
+	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
 	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
 
 	if (!cancel_rc && !reset_rc)
@@ -2147,7 +2159,7 @@ static void ibmvfc_terminate_rport_io(st
 	int rc = FAILED;
 
 	ENTER;
-	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all);
+	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_abts);
 	starget_for_each_device(starget, &abort_rc, ibmvfc_dev_abort_all);
 
 	if (!cancel_rc && !abort_rc)
_
