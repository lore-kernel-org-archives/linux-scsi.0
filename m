From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Fix for offlining devices during error recovery
Date: Tue, 20 Aug 2013 11:08:42 -0500
Message-ID: <201308201608.r7KG8hCR015363@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39181 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3HTQIr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Aug 2013 12:08:47 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 20 Aug 2013 17:08:47 +0100
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id A05C538C805C
	for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2013 12:08:42 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r7KG8ick107872
	for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2013 12:08:44 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r7KG8hnr015375
	for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2013 12:08:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


This fixes an issue seen with devices getting marked offline
in a scenario where a VIOS was getting rebooted while a
client VFC adapter is in SCSI EH and prevents unnecessary
EH escalation in some scenarios.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_during_reset drivers/scsi/ibmvscsi/ibmvfc.c
--- linux/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_during_reset	2013-08-06 15:10:04.000000000 -0500
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-08-06 15:10:04.000000000 -0500
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

