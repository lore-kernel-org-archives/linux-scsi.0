From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Fix for offlining devices during error recovery
Date: Wed, 15 May 2013 10:24:47 -0500
Message-ID: <201305151524.r4FFOlW0012047@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:35504 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab3EOPYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 May 2013 11:24:52 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 15 May 2013 09:24:51 -0600
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 1F06A6E8040
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2013 11:24:46 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r4FFOmqY332308
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2013 11:24:49 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r4FFOm7H012073
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2013 11:24:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This fixes an issue seen with devices getting marked offline
in a scenario where a VIOS was getting rebooted while a
client VFC adapter is in SCSI EH and prevents unnecessary
EH escalation in some scenarios.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_during_reset drivers/scsi/ibmvscsi/ibmvfc.c
--- linux/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_during_reset	2013-05-15 10:02:13.000000000 -0500
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-05-15 10:02:13.000000000 -0500
@@ -2208,7 +2208,10 @@ static int ibmvfc_cancel_all(struct scsi
 
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, sdev, "Failed to send cancel event. rc=%d\n", rsp_rc);
-		return -EIO;
+		/* If failure is received, the host adapter is most likely going
+		 through reset, return success so the caller will wait for the command
+		 being cancelled to get returned */
+		return 0;
 	}
 
 	sdev_printk(KERN_INFO, sdev, "Cancelling outstanding commands.\n");
@@ -2221,7 +2224,15 @@ static int ibmvfc_cancel_all(struct scsi
 
 	if (status != IBMVFC_MAD_SUCCESS) {
 		sdev_printk(KERN_WARNING, sdev, "Cancel failed with rc=%x\n", status);
-		return -EIO;
+		switch (status) {
+		case IBMVFC_MAD_DRIVER_FAILED:
+		case IBMVFC_MAD_CRQ_ERROR:
+			/* Host adapter most likely going through reset, return success to
+			 the caller will wait for the command being cancelled to get returned */
+			return 0;
+		default:
+			return -EIO;
+		};
 	}
 
 	sdev_printk(KERN_INFO, sdev, "Successfully cancelled outstanding commands\n");
_

