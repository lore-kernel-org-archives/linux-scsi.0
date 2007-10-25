From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] Remove #warnings for longstanding conditions.
Date: Thu, 25 Oct 2007 04:06:15 -0400 (EDT)
Message-ID: <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:55016 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbXJYIGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 04:06:16 -0400
In-Reply-To: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, willy@linux.intel.com, kkeil@suse.de

These two warnings...

drivers/isdn/capi/capidrv.c:2126:3: warning: #warning FIXME: maybe a
race condition the card should be removed here from global list /kkeil

drivers/scsi/advansys.c:71:2: warning: #warning this driver is still
not properly converted to the DMA API

...represent conditions that have existed for years, and are duly noted
in FIXMEs.  There does not seem to be much need to warn on every kernel
build for a driver bug or handicap that has existed for years.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/capi/capidrv.c |    3 ++-
 drivers/scsi/advansys.c     |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 476012b..44f954d 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -2123,7 +2123,8 @@ static int capidrv_delcontr(u16 contr)
 		printk(KERN_ERR "capidrv: delcontr: no contr %u\n", contr);
 		return -1;
 	}
-	#warning FIXME: maybe a race condition the card should be removed here from global list /kkeil
+
+	/* FIXME: maybe a race condition the card should be removed here from global list /kkeil */
 	spin_unlock_irqrestore(&global_lock, flags);
 
 	del_timer(&card->listentimer);
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9dd3952..e13e3a8 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -68,7 +68,6 @@
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
-#warning this driver is still not properly converted to the DMA API
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
-- 
1.5.2.4

