From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ibmvfc: Fix command timeout errors
Date: Wed, 04 Feb 2009 16:13:08 -0600
Message-ID: <200902042214.n14MEgkq032485@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42694 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760785AbZBDWOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2009 17:14:44 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n14MFFE5025498
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:15:15 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n14MEgW0136752
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:14:43 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n14MEgLM032615
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:14:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Currently the ibmvfc driver sets the IBMVFC_CLASS_3_ERR flag
in the VFC Frame if both the adapter and the device claim support
for Class 3. However, this bit actually refers to Class 3 Error
Recovery, which is currently not supported by the VIOS. Setting this
bit can cause lots of command timeout responses from the VIOS resulting
in general instability. Fix this by never setting this bit.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_class3 drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_class3	2009-02-03 15:56:49.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-02-03 17:21:36.000000000 -0600
@@ -1573,9 +1573,6 @@ static int ibmvfc_queuecommand(struct sc
 	vfc_cmd->resp_len = sizeof(vfc_cmd->rsp);
 	vfc_cmd->cancel_key = (unsigned long)cmnd->device->hostdata;
 	vfc_cmd->tgt_scsi_id = rport->port_id;
-	if ((rport->supported_classes & FC_COS_CLASS3) &&
-	    (fc_host_supported_classes(vhost->host) & FC_COS_CLASS3))
-		vfc_cmd->flags = IBMVFC_CLASS_3_ERR;
 	vfc_cmd->iu.xfer_len = scsi_bufflen(cmnd);
 	int_to_scsilun(cmnd->device->lun, &vfc_cmd->iu.lun);
 	memcpy(vfc_cmd->iu.cdb, cmnd->cmnd, cmnd->cmd_len);
_
