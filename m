From: janitor@sternwelten.at
Subject: [patch 09/10]  scsi/scsi_lib: replace 	schedule_timeout() with msleep_interruptible()
Date: Thu, 21 Oct 2004 10:47:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYbP-0004Rp-Fi@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:8883 "EHLO baikonur.stro.at")
	by vger.kernel.org with ESMTP id S270517AbUJUIrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~msleep_interruptible-drivers_scsi_scsi_lib drivers/scsi/scsi_lib.c
--- linux-2.6.9/drivers/scsi/scsi_lib.c~msleep_interruptible-drivers_scsi_scsi_lib	2004-10-21 02:41:54.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/scsi_lib.c	2004-10-21 02:41:54.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -1739,7 +1740,7 @@ scsi_device_quiesce(struct scsi_device *
 
 	scsi_run_queue(sdev->request_queue);
 	while (sdev->device_busy) {
-		schedule_timeout(HZ/5);
+		msleep_interruptible(200);
 		scsi_run_queue(sdev->request_queue);
 	}
 	return 0;
_
