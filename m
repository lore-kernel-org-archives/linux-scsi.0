From: brking@us.ibm.com
Subject: [PATCH 06/16] ipr: Properly enable/disable TCQ
Date: Wed, 04 Aug 2004 17:32:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042232.i74MW6u7175130@westrelay04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:9184 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267470AbUHDWcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:32:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


This patch correctly enables tagged command queuing for the ipr driver.
I had misinterpreted scsi_mid_low_api.txt. The following patch has the
appropriate scsi_activate_tcq/scsi_deactivate_tcq calls.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_enable_tcqing drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_enable_tcqing	2004-08-04 17:17:29.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:29.000000000 -0500
@@ -2692,8 +2692,6 @@ static ssize_t ipr_store_tcq_enable(stru
 	struct ipr_resource_entry *res;
 	unsigned long lock_flags = 0;
 	int tcq_active = simple_strtoul(buf, NULL, 10);
-	int qdepth = IPR_MAX_CMD_PER_LUN;
-	int tagged = 0;
 	ssize_t len = -ENXIO;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -2701,13 +2699,13 @@ static ssize_t ipr_store_tcq_enable(stru
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 
 	if (res) {
-		res->tcq_active = 0;
-		qdepth = res->qdepth;
-
 		if (ipr_is_gscsi(res) && sdev->tagged_supported) {
 			if (tcq_active) {
-				tagged = MSG_ORDERED_TAG;
 				res->tcq_active = 1;
+				scsi_activate_tcq(sdev, res->qdepth);
+			} else {
+				res->tcq_active = 0;
+				scsi_deactivate_tcq(sdev, res->qdepth);
 			}
 
 			len = strlen(buf);
@@ -2717,7 +2715,6 @@ static ssize_t ipr_store_tcq_enable(stru
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	scsi_adjust_queue_depth(sdev, tagged, qdepth);
 	return len;
 }
 
_
