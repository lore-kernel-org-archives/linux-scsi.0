From: janitor@sternwelten.at
Subject: [patch 07/10]  scsi/53c700: replace 	schedule_timeout() with msleep_interruptible()
Date: Thu, 21 Oct 2004 10:47:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYbJ-0004M7-9s@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:50326 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270711AbUJUIrQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/53c700.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/53c700.c~msleep_interruptible-drivers_scsi_53c700 drivers/scsi/53c700.c
--- linux-2.6.9/drivers/scsi/53c700.c~msleep_interruptible-drivers_scsi_53c700	2004-10-21 02:41:52.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/53c700.c	2004-10-21 02:41:52.000000000 +0200
@@ -1988,7 +1988,7 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 	 * reset via sg or something */
 	while(hostdata->eh_complete != NULL) {
 		spin_unlock_irq(SCp->device->host->host_lock);
-		schedule_timeout(HZ/10);
+		msleep_interruptible(100);
 		spin_lock_irq(SCp->device->host->host_lock);
 	}
 	hostdata->eh_complete = &complete;
_
