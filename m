From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] scsi: sym53c416: avoid section mismatch with LTO
Date: Fri,  2 Feb 2018 14:12:17 +0100
Message-ID: <20180202131225.1658853-4-arnd@arndb.de>
References: <20180202131225.1658853-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56919 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbeBBNSM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 08:18:12 -0500
In-Reply-To: <20180202131225.1658853-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org

Building with link time optimizations produces a false-postive section
mismatch warning:

WARNING: vmlinux.o(.data+0xf8c8): Section mismatch in reference from the variable driver_template.lto_priv.6915 to the function .init.text:sym53c416_detect()
The variable driver_template.lto_priv.6915 references
the function __init sym53c416_detect()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

The ->detect callback is always entered from the init_this_scsi_driver()
init function, but apparently LTO turns the optimized direct function
call into an indirect call through a non-__initdata pointer.

All drivers using init_this_scsi_driver() are for ancient hardware,
and most don't mark the detect() callback as __init(), so I'm
just removing the annotation here to kill off the warning instead
of doing a larger rework.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/sym53c416.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 5bdcbe8fa958..e68bcdc75bc3 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -608,7 +608,7 @@ static void sym53c416_probe(void)
 	}
 }
 
-int __init sym53c416_detect(struct scsi_host_template *tpnt)
+int sym53c416_detect(struct scsi_host_template *tpnt)
 {
 	unsigned long flags;
 	struct Scsi_Host * shpnt = NULL;
-- 
2.9.0
