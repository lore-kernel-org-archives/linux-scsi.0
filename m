From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 22/29] cxlflash: Recheck state after adapter reset
Date: Fri, 11 Sep 2015 16:17:54 -0500
Message-ID: <1442006274-47271-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35252 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbIKVSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:18:12 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:18:12 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 7E4C83E40048
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:18:09 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLH4vZ39583848
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:17:04 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLI7E1013406
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:18:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Add a state recheck in the device reset handler such that a TMF
will still be send out after an adapter reset.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 1625aea..922fac7 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1931,6 +1931,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
+retry:
 	switch (cfg->state) {
 	case STATE_NORMAL:
 		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
@@ -1939,9 +1940,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		break;
 	case STATE_RESET:
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
-		if (cfg->state == STATE_NORMAL)
-			break;
-		/* fall through */
+		goto retry;
 	default:
 		rc = FAILED;
 		break;
-- 
2.1.0

