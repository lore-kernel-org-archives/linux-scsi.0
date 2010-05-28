From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 6/6] cciss: new controller support and bump driver version
Date: Fri, 28 May 2010 15:42:16 -0500
Message-ID: <20100528204216.GE6989@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4545 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0E1Uhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 16:37:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <scameron@beardog.cce.hp.com>

Patch 6 of 6
cciss: add new controller support
This patch adds support for new controllers due out next year. HP must
continue to support new controllers in older distros. All vendors require
support be upstream. These controllers support only 16 commands in simple
mode but can support up to 1024 in performant mode. See patch 5/6/
We have no marketing names yet.

From: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 08a2e61..5e215ff 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -56,16 +56,14 @@
 #include <linux/kthread.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.26)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 26)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
 MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
-MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
-			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
-			" Smart Array G2 Series SAS/SATA Controllers");
-MODULE_VERSION("3.6.20");
+MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
+MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 
 static int cciss_allow_hpsa;
@@ -107,6 +105,11 @@ static const struct pci_device_id cciss_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
 	{0,}
 };
 
@@ -146,6 +149,11 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
+	{0x3250103C, "Smart Array", &SA5_access},
+	{0x3251103C, "Smart Array", &SA5_access},
+	{0x3252103C, "Smart Array", &SA5_access},
+	{0x3253103C, "Smart Array", &SA5_access},
+	{0x3254103C, "Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
