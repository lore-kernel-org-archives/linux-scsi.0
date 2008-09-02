From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 13/14] scsi: remove scsi_device_online from scsi_decide_disposition
Date: Tue,  2 Sep 2008 09:05:42 -0700
Message-ID: <1220371543-15099-14-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43067 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYIBQFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5pjt023614
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5peX235894
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5ov8021421
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:51 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Remove scsi_device_online from scsi_decide_disposition as the
check is now performed in scsi_attempt_requeue_command if a
retry is attempted.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c9b5598..446352d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1298,17 +1298,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
 
 	/*
-	 * if the device is offline, then we clearly just pass the result back
-	 * up to the top level.
-	 */
-	if (!scsi_device_online(scmd->device)) {
-		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
-						  " as SUCCESS\n",
-						  __func__));
-		return SCSI_MLQUEUE_DIS_FINISH;
-	}
-
-	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
 	 */
-- 
1.5.5.1

