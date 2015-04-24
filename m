From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/22] advansys: Update to version 3.5 and remove compilation warning
Date: Fri, 24 Apr 2015 10:32:57 +0200
Message-ID: <1429864377-67002-23-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966524AbbDXIdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:21 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The driver has now been converted to DMA-API, so we should
increase the version number and remove the compilation
warning.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 MAINTAINERS             |  1 +
 drivers/scsi/Kconfig    |  2 +-
 drivers/scsi/advansys.c | 25 +++++++++----------------
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea00017..e784106 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -445,6 +445,7 @@ F:	drivers/input/misc/adxl34x.c
 
 ADVANSYS SCSI DRIVER
 M:	Matthew Wilcox <matthew@wil.cx>
+M:	Hannes Reinecke <hare@suse.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/advansys.txt
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b021bcb..ae7daf2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -503,7 +503,7 @@ config SCSI_DPT_I2O
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on SCSI && VIRT_TO_BUS && !ARM
+	depends on SCSI && !ARM
 	depends on ISA || EISA || PCI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2c4efb4..2963286 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1,12 +1,10 @@
-#define DRV_NAME "advansys"
-#define ASC_VERSION "3.4"	/* AdvanSys Driver Version */
-
 /*
  * advansys.c - Linux Host Driver for AdvanSys SCSI Adapters
  *
  * Copyright (c) 1995-2000 Advanced System Products, Inc.
  * Copyright (c) 2000-2001 ConnectCom Solutions, Inc.
  * Copyright (c) 2007 Matthew Wilcox <matthew@wil.cx>
+ * Copyright (c) 2014 Hannes Reinecke <hare@suse.de>
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -49,26 +47,21 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 
+#define DRV_NAME "advansys"
+#define ASC_VERSION "3.5"	/* AdvanSys Driver Version */
+
 /* FIXME:
  *
- *  1. Although all of the necessary command mapping places have the
- *     appropriate dma_map.. APIs, the driver still processes its internal
- *     queue using bus_to_virt() and virt_to_bus() which are illegal under
- *     the API.  The entire queue processing structure will need to be
- *     altered to fix this.
- *  2. Need to add memory mapping workaround. Test the memory mapping.
+ *  1. Need to add memory mapping workaround. Test the memory mapping.
  *     If it doesn't work revert to I/O port access. Can a test be done
  *     safely?
- *  3. Handle an interrupt not working. Keep an interrupt counter in
+ *  2. Handle an interrupt not working. Keep an interrupt counter in
  *     the interrupt handler. In the timeout function if the interrupt
  *     has not occurred then print a message and run in polled mode.
- *  4. Need to add support for target mode commands, cf. CAM XPT.
- *  5. check DMA mapping functions for failure
- *  6. Use scsi_transport_spi
- *  7. advansys_info is not safe against multiple simultaneous callers
- *  8. Add module_param to override ISA/VLB ioport array
+ *  3. Use scsi_transport_spi
+ *  4. advansys_info is not safe against multiple simultaneous callers
+ *  5. Add module_param to override ISA/VLB ioport array
  */
-#warning this driver is still not properly converted to the DMA API
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
-- 
1.8.5.2

