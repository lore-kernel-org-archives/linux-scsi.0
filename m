From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Handle non SCSI error status
Date: Fri, 25 Apr 2008 16:58:29 -0500
Message-ID: <15544.1067101949$1209160797@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52858 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYDYV6w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 17:58:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3PLwjDi001643
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 17:58:45 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3PLwjWe291428
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 17:58:45 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3PLwYnG030636
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 17:58:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, santil@us.ibm.com, brking@linux.vnet.ibm.com


Adds support to the ibmvscsi driver to handle non SCSI error
status. This is needed to support some new VIOS enhancements.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Santiago Leon <santil@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    5 ++++-
 linux-2.6-bjking1/drivers/scsi/ibmvscsi/viosrp.h   |    9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_non_scsi_error_status drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_non_scsi_error_status	2008-04-25 16:36:21.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-04-25 16:36:21.000000000 -0500
@@ -686,7 +686,7 @@ static void handle_cmd_rsp(struct srp_ev
 	}
 	
 	if (cmnd) {
-		cmnd->result = rsp->status;
+		cmnd->result |= rsp->status;
 		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
 			memcpy(cmnd->sense_buffer,
 			       rsp->data,
@@ -730,6 +730,7 @@ static int ibmvscsi_queuecommand(struct 
 	u16 lun = lun_from_dev(cmnd->device);
 	u8 out_fmt, in_fmt;
 
+	cmnd->result = (DID_OK << 16);
 	evt_struct = get_event_struct(&hostdata->pool);
 	if (!evt_struct)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1347,6 +1348,8 @@ void ibmvscsi_handle_crq(struct viosrp_c
 
 	del_timer(&evt_struct->timer);
 
+	if (crq->status != VIOSRP_OK && evt_struct->cmnd)
+		evt_struct->cmnd->result = DID_ERROR << 16;
 	if (evt_struct->done)
 		evt_struct->done(evt_struct);
 	else
diff -puN drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_non_scsi_error_status drivers/scsi/ibmvscsi/viosrp.h
--- linux-2.6/drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_non_scsi_error_status	2008-04-25 16:36:21.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/viosrp.h	2008-04-25 16:36:21.000000000 -0500
@@ -59,6 +59,15 @@ enum viosrp_crq_formats {
 	VIOSRP_INLINE_FORMAT = 0x07
 };
 
+enum viosrp_crq_status {
+	VIOSRP_OK = 0x0,
+	VIOSRP_NONRECOVERABLE_ERR = 0x1,
+	VIOSRP_VIOLATES_MAX_XFER = 0x2,
+	VIOSRP_PARTNER_PANIC = 0x3,
+	VIOSRP_DEVICE_BUSY = 0x8,
+	VIOSRP_ADAPTER_FAIL = 0x10
+};
+
 struct viosrp_crq {
 	u8 valid;		/* used by RPA */
 	u8 format;		/* SCSI vs out-of-band */
_
