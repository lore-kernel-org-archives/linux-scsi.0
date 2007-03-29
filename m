From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Thu, 29 Mar 2007 15:25:52 -0500
Message-ID: <2174.02031780711$1175199980@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53381 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030682AbXC2UZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 16:25:54 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2TKPsIE013797
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 16:25:54 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2TKPsm4170386
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 14:25:54 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2TKPrRX027893
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 14:25:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Currently, the scsi error handler will issue a START_UNIT
command if the drive indicates it needs its motor started
and the allow_restart flag is set in the scsi_device. If,
after the scsi error handler invokes a host adapter reset
due to error recovery, a device is in a unit attention
state AND also needs a START_UNIT, that device will be placed
offline. The disk array devices on an ipr RAID adapter
will do exactly this when in a dual initiator configuration.
This patch adds a single retry to the EH initiated
START_UNIT.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/scsi_error.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_error.c~scsi_eh_stu_retry drivers/scsi/scsi_error.c
--- linux-2.6/drivers/scsi/scsi_error.c~scsi_eh_stu_retry	2007-03-14 15:04:17.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_error.c	2007-03-14 15:04:17.000000000 -0500
@@ -923,12 +923,22 @@ static int scsi_eh_try_stu(struct scsi_c
 	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
 
 	if (scmd->device->allow_restart) {
-		int rtn;
+		int retry_cnt = 1, rtn;
 
+retry_stu:
 		rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
 					START_UNIT_TIMEOUT, 0);
-		if (rtn == SUCCESS)
+
+		switch (rtn) {
+		case SUCCESS:
 			return 0;
+		case NEEDS_RETRY:
+			if (retry_cnt--)
+				goto retry_stu;
+			/*FALLTHRU*/
+		default:
+			return 1;
+		}
 	}
 
 	return 1;
_
