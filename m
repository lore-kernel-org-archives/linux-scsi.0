From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/5] ibmvfc: Suppress ABTS if target gone
Date: Fri, 12 Apr 2013 08:25:18 -0500
Message-ID: <201304121325.r3CDPIMI025055@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58987 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab3DLNZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 09:25:24 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 12 Apr 2013 09:25:23 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 2BE6B6E8059
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:17 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3CDPJYj344608
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:19 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3CDPIYB025073
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcjenn@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


Adds support for a new VIOS feature that allows ibmvfc to
optimize terminate_rport_io by telling the VIOS the target
is no longer accessible on the fabric and that it should
not send an ABTS out on the fabric to the device.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   13 +++++++------
 drivers/scsi/ibmvscsi/ibmvfc.h |    3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_supress_abts drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_supress_abts	2013-01-25 14:29:11.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-01-25 14:29:24.000000000 -0600
@@ -2190,10 +2190,12 @@ static int ibmvfc_cancel_all(struct scsi
 		tmf->common.length = sizeof(*tmf);
 		tmf->scsi_id = rport->port_id;
 		int_to_scsilun(sdev->lun, &tmf->lun);
+		if (!(vhost->login_buf->resp.capabilities & IBMVFC_CAN_SUPPRESS_ABTS))
+			type &= ~IBMVFC_TMF_SUPPRESS_ABTS;
 		if (vhost->state == IBMVFC_ACTIVE)
 			tmf->flags = (type | IBMVFC_TMF_LUA_VALID);
 		else
-			tmf->flags = IBMVFC_TMF_LUA_VALID;
+			tmf->flags = ((type & IBMVFC_TMF_SUPPRESS_ABTS) | IBMVFC_TMF_LUA_VALID);
 		tmf->cancel_key = (unsigned long)sdev->hostdata;
 		tmf->my_cancel_key = (unsigned long)starget->hostdata;
 
@@ -2402,7 +2404,7 @@ static int ibmvfc_eh_abort_handler(struc
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
 		ibmvfc_abort_task_set(sdev);
 	} else
-		cancel_rc = ibmvfc_cancel_all(sdev, 0);
+		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
 
 	if (!cancel_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
@@ -2435,7 +2437,7 @@ static int ibmvfc_eh_device_reset_handle
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
 		reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
 	} else
-		cancel_rc = ibmvfc_cancel_all(sdev, 0);
+		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
 
 	if (!cancel_rc && !reset_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
@@ -2456,7 +2458,7 @@ static int ibmvfc_eh_device_reset_handle
 static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
 {
 	unsigned long *rc = data;
-	*rc |= ibmvfc_cancel_all(sdev, 0);
+	*rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
 }
 
 /**
@@ -2547,8 +2549,7 @@ static void ibmvfc_terminate_rport_io(st
 		dev_rport = starget_to_rport(scsi_target(sdev));
 		if (dev_rport != rport)
 			continue;
-		ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
-		ibmvfc_abort_task_set(sdev);
+		ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
 	}
 
 	rc = ibmvfc_wait_for_ops(vhost, rport, ibmvfc_match_rport);
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_supress_abts drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_supress_abts	2013-01-25 14:29:11.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2013-01-25 14:29:11.000000000 -0600
@@ -208,10 +208,10 @@ struct ibmvfc_npiv_login_resp {
 	u16 error;
 	u32 flags;
 #define IBMVFC_NATIVE_FC		0x01
-#define IBMVFC_CAN_FLUSH_ON_HALT	0x08
 	u32 reserved;
 	u64 capabilities;
 #define IBMVFC_CAN_FLUSH_ON_HALT	0x08
+#define IBMVFC_CAN_SUPPRESS_ABTS	0x10
 	u32 max_cmds;
 	u32 scsi_id_sz;
 	u64 max_dma_len;
@@ -351,6 +351,7 @@ struct ibmvfc_tmf {
 #define IBMVFC_TMF_LUN_RESET		0x10
 #define IBMVFC_TMF_TGT_RESET		0x20
 #define IBMVFC_TMF_LUA_VALID		0x40
+#define IBMVFC_TMF_SUPPRESS_ABTS	0x80
 	u32 cancel_key;
 	u32 my_cancel_key;
 	u32 pad;
_

