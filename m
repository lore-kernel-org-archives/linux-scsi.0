From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ibmvfc: Miscellaneous fixes
Date: Tue, 22 Jul 2008 08:31:46 -0500
Message-ID: <200807221332.m6MDW8jF023476@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43541 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbYGVNcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 09:32:14 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6MDWBgZ012632
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 09:32:11 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6MDW9XU161636
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 07:32:10 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6MDW8cP023498
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 07:32:09 -0600
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
