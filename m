From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ibmvfc: Quiet gcc warning in ibmvfc_reset_device
Date: Wed, 29 Oct 2008 08:46:47 -0500
Message-ID: <200810291347.m9TDlFRV013156@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57978 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYJ2Nrc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 09:47:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m9TDlVnj008663
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:31 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TDlRB2120372
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:28 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TDlGrY013264
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Stops gcc from complaining about a possible uninitialized
variable being used in ibmvfc_reset_device. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_gcc_warn drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_gcc_warn	2008-10-28 14:08:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-10-28 14:09:41.000000000 -0500
@@ -1631,7 +1631,7 @@ static int ibmvfc_reset_device(struct sc
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_cmd *tmf;
-	struct ibmvfc_event *evt;
+	struct ibmvfc_event *evt = NULL;
 	union ibmvfc_iu rsp_iu;
 	struct ibmvfc_fcp_rsp *fc_rsp = &rsp_iu.cmd.rsp;
 	int rsp_rc = -EBUSY;
_
