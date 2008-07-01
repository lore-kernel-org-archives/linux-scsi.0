From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] sg: Add target reset support
Date: Tue, 01 Jul 2008 13:03:19 -0500
Message-ID: <200807011803.m61I3OoD030274@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44355 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYGASEU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2008 14:04:20 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m61I4JcX016208
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2008 14:04:19 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m61I3Pwc158250
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2008 14:03:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m61I3O9A030321
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2008 14:03:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds support for target reset to SG_SCSI_RESET.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/sg.c |    3 +++
 include/scsi/sg.h |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/scsi/sg.c~sg_target_reset drivers/scsi/sg.c
--- linux-2.6/drivers/scsi/sg.c~sg_target_reset	2008-06-16 15:34:16.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/sg.c	2008-06-16 15:36:48.000000000 -0500
@@ -1026,6 +1026,9 @@ sg_ioctl(struct inode *inode, struct fil
 		case SG_SCSI_RESET_DEVICE:
 			val = SCSI_TRY_RESET_DEVICE;
 			break;
+		case SG_SCSI_RESET_TARGET:
+			val = SCSI_TRY_RESET_TARGET;
+			break;
 		case SG_SCSI_RESET_BUS:
 			val = SCSI_TRY_RESET_BUS;
 			break;
diff -puN include/scsi/sg.h~sg_target_reset include/scsi/sg.h
--- linux-2.6/include/scsi/sg.h~sg_target_reset	2008-06-16 15:36:05.000000000 -0500
+++ linux-2.6-bjking1/include/scsi/sg.h	2008-06-16 15:36:17.000000000 -0500
@@ -206,6 +206,7 @@ typedef struct sg_req_info { /* used by 
 #define		SG_SCSI_RESET_DEVICE	1
 #define		SG_SCSI_RESET_BUS	2
 #define		SG_SCSI_RESET_HOST	3
+#define		SG_SCSI_RESET_TARGET	4
 
 /* synchronous SCSI command ioctl, (only in version 3 interface) */
 #define SG_IO 0x2285   /* similar effect as write() followed by read() */
_
