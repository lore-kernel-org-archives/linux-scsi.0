From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi_debug: check for bigger value first
Date: Thu, 26 Nov 2015 20:22:50 +0200
Message-ID: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbbKZSWy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 13:22:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jbottomley@odin.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>

From: Andy Shevchenko <andy.shevchenko@gmail.com>

Even for signed types we have to check for bigger positive value first.
Otherwise it will be never happened.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index dfcc45b..f773b34 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4846,10 +4846,10 @@ static int __init scsi_debug_init(void)
 	/* play around with geometry, don't waste too much on track 0 */
 	sdebug_heads = 8;
 	sdebug_sectors_per = 32;
-	if (scsi_debug_dev_size_mb >= 16)
-		sdebug_heads = 32;
-	else if (scsi_debug_dev_size_mb >= 256)
+	if (scsi_debug_dev_size_mb >= 256)
 		sdebug_heads = 64;
+	else if (scsi_debug_dev_size_mb >= 16)
+		sdebug_heads = 32;
 	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
 			       (sdebug_sectors_per * sdebug_heads);
 	if (sdebug_cylinders_per >= 1024) {
-- 
2.6.2

