From: brking@us.ibm.com
Subject: [PATCH 09/16] ipr: Set allow_restart for disk devices only
Date: Wed, 04 Aug 2004 17:32:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042233.i74MXcCu134178@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:53388 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267474AbUHDWc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:32:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


This fixes ipr to only allow eh initiated start_unit commands
following erp to disk devices.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_only_disk_start_unit drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_only_disk_start_unit	2004-08-04 17:17:33.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:33.000000000 -0500
@@ -2851,8 +2851,8 @@ static int ipr_slave_configure(struct sc
 			sdev->scsi_level = 4;
 		if (ipr_is_vset_device(res))
 			sdev->timeout = IPR_VSET_RW_TIMEOUT;
-
-		sdev->allow_restart = 1;
+		if (IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
+			sdev->allow_restart = 1;
 		scsi_adjust_queue_depth(sdev, 0, res->qdepth);
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
_
