From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] scsi: NCR53c406a: avoid section mismatch with LTO
Date: Fri,  2 Feb 2018 14:12:16 +0100
Message-ID: <20180202131225.1658853-3-arnd@arndb.de>
References: <20180202131225.1658853-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:62108 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeBBNNV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 08:13:21 -0500
In-Reply-To: <20180202131225.1658853-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org

Building with link time optimizations produces a false-postive section
mismatch warning:

WARNING: vmlinux.o(.data+0xf7e8): Section mismatch in reference from the variable driver_template.lto_priv.6914 to the function .init.text:NCR53c406a_detect()
The variable driver_template.lto_priv.6914 references
the function __init NCR53c406a_detect()
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
 drivers/scsi/NCR53c406a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 6e110c630d2c..44b09870bf51 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -448,7 +448,7 @@ static __inline__ int NCR53c406a_pio_write(unsigned char *request, unsigned int
 }
 #endif				/* USE_PIO */
 
-static int __init NCR53c406a_detect(struct scsi_host_template * tpnt)
+static int NCR53c406a_detect(struct scsi_host_template * tpnt)
 {
 	int present = 0;
 	struct Scsi_Host *shpnt = NULL;
-- 
2.9.0
