From: janitor@sternwelten.at
Subject: [patch 5/7]  scsi/sata_sx4: replace schedule_timeout() 	with msleep()
Date: Wed, 01 Sep 2004 21:55:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bCD-0005sH-CE@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:37013 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267480AbUIATzK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:55:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







I would appreciate any comments from the janitor@sternweltens list. 



Description: Use msleep() instead of schedule_timeout() to 
guarantee the task delays for the desired time.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/sata_sx4.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/sata_sx4.c~msleep-drivers_scsi_sata_sx4 drivers/scsi/sata_sx4.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/sata_sx4.c~msleep-drivers_scsi_sata_sx4	2004-09-01 19:35:48.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/sata_sx4.c	2004-09-01 19:35:48.000000000 +0200
@@ -1189,8 +1189,7 @@ static unsigned int pdc20621_prog_dimm_g
 	   		error = 0;
 	   		break;     
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout((i * 100) * HZ / 1000 + 1);
+		msleep(i*100);
    	}
    	return error;
 }
@@ -1223,8 +1222,7 @@ static unsigned int pdc20621_dimm_init(s
 	readl(mmio + PDC_TIME_CONTROL);
 
 	/* Wait 3 seconds */
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule_timeout(3 * HZ);
+	msleep(3000);
 
 	/* 
 	   When timer is enabled, counter is decreased every internal

_
