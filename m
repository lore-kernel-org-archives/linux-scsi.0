From: janitor@sternwelten.at
Subject: [patch 02/10]  scsi/ide-scsi: replace 	schedule_timeout() with msleep()
Date: Thu, 21 Oct 2004 10:46:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYb3-00048k-Oz@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:58760 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270617AbUJUIrB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/ide-scsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ide-scsi.c~msleep-drivers_scsi_ide-scsi drivers/scsi/ide-scsi.c
--- linux-2.6.9/drivers/scsi/ide-scsi.c~msleep-drivers_scsi_ide-scsi	2004-10-21 02:41:25.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/ide-scsi.c	2004-10-21 02:41:25.000000000 +0200
@@ -45,6 +45,7 @@
 #include <linux/hdreg.h>
 #include <linux/slab.h>
 #include <linux/ide.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/bitops.h>
@@ -1049,7 +1050,7 @@ static int idescsi_eh_reset (struct scsi
 	do {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(cmd->device->host->host_lock);
-		schedule_timeout(HZ/20);
+		msleep(50);
 		spin_lock_irq(cmd->device->host->host_lock);
 	} while ( HWGROUP(drive)->handler );
 
_
