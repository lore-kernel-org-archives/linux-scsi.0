From: janitor@sternwelten.at
Subject: [patch 06/10]  scsi/qla1280: replace 	schedule_timeout() with msleep()
Date: Thu, 21 Oct 2004 10:47:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYbG-0004JG-74@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:16288 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270710AbUJUIrN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/qla1280.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla1280.c~msleep-drivers_scsi_qla1280 drivers/scsi/qla1280.c
--- linux-2.6.9/drivers/scsi/qla1280.c~msleep-drivers_scsi_qla1280	2004-10-21 02:41:35.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/qla1280.c	2004-10-21 02:41:35.000000000 +0200
@@ -2938,7 +2938,7 @@ qla1280_bus_reset(struct scsi_qla_host *
 		ha->bus_settings[bus].failed_reset_count++;
 	} else {
 		spin_unlock_irq(HOST_LOCK);
-		schedule_timeout(reset_delay * HZ);
+		msleep(reset_delay * 1000);
 		spin_lock_irq(HOST_LOCK);
 
 		ha->bus_settings[bus].scsi_bus_dead = 0;
_
