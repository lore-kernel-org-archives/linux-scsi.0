From: janitor@sternwelten.at
Subject: [patch 3/7]  scsi/qla_init: replace 	schedule_timeout() with msleep()
Date: Wed, 01 Sep 2004 21:54:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bC2-0005qp-Cz@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:58772 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267522AbUIATyz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:54:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







Error in the patch, corrected below. Thanks, Domen.



Description: Replaces schedule_timeout() with msleep() to guarantee task
delays as desired.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/qla2xxx/qla_init.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_init.c~msleep-drivers_scsi_qla2xxx_qla_init drivers/scsi/qla2xxx/qla_init.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/qla2xxx/qla_init.c~msleep-drivers_scsi_qla2xxx_qla_init	2004-09-01 19:35:46.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/qla2xxx/qla_init.c	2004-09-01 19:35:46.000000000 +0200
@@ -967,8 +967,7 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 			break;
 
 		/* Delay for a while */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ / 2);
+		msleep(500);
 
 		DEBUG3(printk("scsi(%ld): fw_state=%x curr time=%lx.\n",
 		    ha->host_no, fw_state, jiffies));

_
