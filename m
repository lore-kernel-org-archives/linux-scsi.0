From: janitor@sternwelten.at
Subject: [patch 7/7]  scsi/wd7000: replace schedule_timeout() 	with msleep()
Date: Wed, 01 Sep 2004 21:55:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bCO-0005th-Bf@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:64158 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267478AbUIATzR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:55:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







I would appreciate any comments from the janitor@sternweltens list. 



Description: Use msleep() instead of schedule_timeout() to 
guarantee the task delays for the desired time.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/wd7000.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/wd7000.c~msleep-drivers_scsi_wd7000 drivers/scsi/wd7000.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/wd7000.c~msleep-drivers_scsi_wd7000	2004-09-01 19:35:49.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/wd7000.c	2004-09-01 19:35:49.000000000 +0200
@@ -1473,8 +1473,7 @@ static int wd7000_detect(struct scsi_hos
 			 * ASC reset...
 			 */
 			outb(ASC_RES, iobase + ASC_CONTROL);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ / 100);
+			msleep(10);
 			outb(0, iobase + ASC_CONTROL);
 
 			if (WAIT(iobase + ASC_STAT, ASC_STATMASK, CMD_RDY, 0)) {

_
