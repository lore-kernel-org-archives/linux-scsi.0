From: brking@us.ibm.com
Subject: [PATCH 12/16] ipr: replace schedule_timeout() with msleep()
Date: Wed, 04 Aug 2004 17:32:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042232.i74MWloo325450@westrelay02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:14777 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S267474AbUHDWct
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 18:32:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, nacc@us.ibm.com



From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [PATCH] scsi/ipr: replace schedule_timeout() with msleep()
Description: Use msleep() instead of schedule_timeout() to 
guarantee the task delays for the desired time.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_remove_schedule_timeout_usage drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_remove_schedule_timeout_usage	2004-08-04 17:17:37.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:37.000000000 -0500
@@ -2012,7 +2012,7 @@ static ssize_t ipr_store_diagnostics(str
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 
 		/* Wait for a second for any errors to be logged */
-		schedule_timeout(HZ);
+		msleep(1000);
 	} else {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return -EIO;
_
