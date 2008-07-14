From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ibmvfc: Miscellaneous fixes
Date: Mon, 14 Jul 2008 14:36:34 -0500
Message-ID: <200807141936.m6EJakkZ021154@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54240 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbYGNTg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:58 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EJdM4Q030709
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:39:22 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EJalGC218812
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:47 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EJak6C021185
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Properly setup the size of the async event queue. This fixes a bug where async events
were not getting processed by the driver.

Setup target_id field in the driver's target struct so that target sysfs attributes
work for multiple targets.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_misc_fixes drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_misc_fixes	2008-07-11 08:54:59.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-07-11 08:56:38.000000000 -0500
@@ -1136,7 +1136,7 @@ static void ibmvfc_set_login_info(struct
 	login_info->max_cmds = max_requests + IBMVFC_NUM_INTERNAL_REQ;
 	login_info->capabilities = IBMVFC_CAN_MIGRATE;
 	login_info->async.va = vhost->async_crq.msg_token;
-	login_info->async.len = vhost->async_crq.size;
+	login_info->async.len = vhost->async_crq.size * sizeof(*vhost->async_crq.msgs);
 	strncpy(login_info->partition_name, vhost->partition_name, IBMVFC_MAX_NAME);
 	strncpy(login_info->device_name,
 		vhost->host->shost_gendev.bus_id, IBMVFC_MAX_NAME);
@@ -3348,6 +3348,7 @@ static void ibmvfc_tgt_add_rport(struct 
 		tgt_dbg(tgt, "rport add succeeded\n");
 		rport->maxframe_size = tgt->service_parms.common.bb_rcv_sz & 0x0fff;
 		rport->supported_classes = 0;
+		tgt->target_id = rport->scsi_target_id;
 		if (tgt->service_parms.class1_parms[0] & 0x80000000)
 			rport->supported_classes |= FC_COS_CLASS1;
 		if (tgt->service_parms.class2_parms[0] & 0x80000000)
_
