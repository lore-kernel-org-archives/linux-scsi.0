From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] cxlflash: Select IRQ_POLL
Date: Fri,  5 May 2017 16:31:47 -0700
Message-ID: <1494027107-11234-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:41559 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdEEXbv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2017 19:31:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Manoj N . Kumar" <manoj@linux.vnet.ibm.com>
Cc: "Matthew R . Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>

The driver now uses IRQ_POLL and needs to select it to avoid the following
build error.

ERROR: ".irq_poll_complete" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
ERROR: ".irq_poll_sched" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
ERROR: ".irq_poll_disable" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
ERROR: ".irq_poll_init" [drivers/scsi/cxlflash/cxlflash.ko] undefined!

Fixes: cba06e6de403 ("scsi: cxlflash: Implement IRQ polling for RRQ processing")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/scsi/cxlflash/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
index c052104e523e..a011c5dbf214 100644
--- a/drivers/scsi/cxlflash/Kconfig
+++ b/drivers/scsi/cxlflash/Kconfig
@@ -5,6 +5,7 @@
 config CXLFLASH
 	tristate "Support for IBM CAPI Flash"
 	depends on PCI && SCSI && CXL && EEH
+	select IRQ_POLL
 	default m
 	help
 	  Allows CAPI Accelerated IO to Flash
-- 
2.7.4
