From: janitor@sternwelten.at
Subject: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout() with msleep_interruptible()
Date: Thu, 21 Oct 2004 10:47:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYbM-0004Oy-Cq@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:32695 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270712AbUJUIrS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o drivers/scsi/dpt_i2o.c
--- linux-2.6.9/drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o	2004-10-21 02:41:53.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/dpt_i2o.c	2004-10-21 02:41:53.000000000 +0200
@@ -1179,7 +1179,7 @@ static int adpt_i2o_post_wait(adpt_hba* 
 				// dangerous.
 				status = -ETIME;
 			}
-			schedule_timeout(timeout*HZ);
+			msleep_interruptible(timeout * 1000);
 		}
 		if(pHba->host)
 			spin_lock_irq(pHba->host->host_lock);
_
