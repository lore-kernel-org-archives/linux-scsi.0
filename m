From: domen@coderock.org
Subject: [patch 01/11] Re: scsi/ide-scsi: use msleep()
Date: Sun, 06 Mar 2005 23:26:50 +0100
Message-ID: <20050306222651.3F0FF1EC90@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:47790 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261518AbVCFW04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:26:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com



Use msleep() instead of schedule_timeout() to guarantee the
task delays as expected. Remove set_current_state() as it is taken care of by
msleep().

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/ide-scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ide-scsi.c~msleep-drivers_scsi_ide-scsi drivers/scsi/ide-scsi.c
--- kj/drivers/scsi/ide-scsi.c~msleep-drivers_scsi_ide-scsi	2005-03-05 16:10:50.000000000 +0100
+++ kj-domen/drivers/scsi/ide-scsi.c	2005-03-05 16:10:50.000000000 +0100
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/bitops.h>
@@ -979,9 +980,8 @@ static int idescsi_eh_reset (struct scsi
 	/* ide_do_reset starts a polling handler which restarts itself every 50ms until the reset finishes */
 
 	do {
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(cmd->device->host->host_lock);
-		schedule_timeout(HZ/20);
+		msleep(50);
 		spin_lock_irq(cmd->device->host->host_lock);
 	} while ( HWGROUP(drive)->handler );
 
_
