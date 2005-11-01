From: brking@us.ibm.com
Subject: [PATCH 09/26] ipr: slave_alloc optimization
Date: Tue, 01 Nov 2005 17:01:07 -0600
Message-ID: <200511012301.jA1N180B023870@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:4311 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751405AbVKAXBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:01:09 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N19wC020853
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:09 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N2CDC519284
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:12 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N18LQ023887
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Optimize ipr's slave_alloc to return -ENXIO for devices that
do not exist.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_slave_alloc_optimization drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_slave_alloc_optimization	2005-10-31 21:53:05.562942664 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:05.618934152 -0600
@@ -2815,13 +2815,14 @@ static int ipr_slave_configure(struct sc
  * handling new commands.
  *
  * Return value:
- * 	0 on success
+ * 	0 on success / -ENXIO if device does not exist
  **/
 static int ipr_slave_alloc(struct scsi_device *sdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
 	unsigned long lock_flags;
+	int rc = -ENXIO;
 
 	sdev->hostdata = NULL;
 
@@ -2836,13 +2837,14 @@ static int ipr_slave_alloc(struct scsi_d
 			res->in_erp = 0;
 			sdev->hostdata = res;
 			res->needs_sync_complete = 1;
+			rc = 0;
 			break;
 		}
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	return 0;
+	return rc;
 }
 
 /**
_
