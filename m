From: janitor@sternwelten.at
Subject: [patch 01/10]  scsi/ibmvscsi: replace 	schedule_timeout() with msleep()
Date: Thu, 21 Oct 2004 10:46:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYb0-000467-NL@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:2468 "EHLO baikonur.stro.at")
	by vger.kernel.org with ESMTP id S270700AbUJUIq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:46:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/ibmvscsi/ibmvscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~msleep-drivers_scsi_ibmvscsi drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6.9/drivers/scsi/ibmvscsi/ibmvscsi.c~msleep-drivers_scsi_ibmvscsi	2004-10-21 02:41:22.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-10-21 02:41:22.000000000 +0200
@@ -69,6 +69,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
+#include <linux/delay.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1327,8 +1328,7 @@ static int ibmvscsi_probe(struct vio_dev
 		     time_before(jiffies, wait_switch) &&
 		     atomic_read(&hostdata->request_limit) < 0;) {
 
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ / 100);
+			msleep(10);
 		}
 
 		/* if we now have a valid request_limit, initiate a scan */
_
