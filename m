From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 11/13] scsi: remove scsi_device_online from scsi_decide_disposition
Date: Mon, 22 Sep 2008 09:33:40 -0700
Message-ID: <1222101222-15079-12-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52111 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYIVQeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:08 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY7RU014095
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:07 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY6Kh203756
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY64W005414
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:06 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYT003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:06 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove scsi_device_online from scsi_decide_disposition as the
check is now performed in scsi_attempt_requeue_command if a
retry is attempted.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4fbc28a..a0f4123 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1271,17 +1271,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
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

