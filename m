From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: remove overlapping PCI IDs
Date: Tue, 26 Oct 2010 15:48:29 -0500
Message-ID: <20101026204829.GA31295@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:4676 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760051Ab0JZUsb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 16:48:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, iss_storagedev@hp.com

Patch 1 of 1

cciss: remove overlapping PCI IDs

From: Mike Miller <mike.miller@hp.com>

This patch removes the controller overlap between cciss and hpsa. It was
decided that no overlap should exist. All new controllers will use the hpsa
SCSI based driver.
---
 drivers/block/cciss.c |   36 ------------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f09e6df..5f754cf 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -66,11 +66,6 @@ MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 
 static DEFINE_MUTEX(cciss_mutex);
-static int cciss_allow_hpsa;
-module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(cciss_allow_hpsa,
-	"Prevent cciss driver from accessing hardware known to be "
-	" supported by the hpsa driver");
 
 #include "cciss_cmd.h"
 #include "cciss.h"
@@ -98,19 +93,6 @@ static const struct pci_device_id cciss_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{0,}
 };
 
@@ -138,24 +120,9 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
 	{0x3237103C, "Smart Array E500", &SA5_access},
-/* controllers below this line are also supported by the hpsa driver. */
-#define HPSA_BOUNDARY 0x3223103C
 	{0x3223103C, "Smart Array P800", &SA5_access},
 	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x323D103C, "Smart Array P700m", &SA5_access},
-	{0x3241103C, "Smart Array P212", &SA5_access},
-	{0x3243103C, "Smart Array P410", &SA5_access},
-	{0x3245103C, "Smart Array P410i", &SA5_access},
-	{0x3247103C, "Smart Array P411", &SA5_access},
-	{0x3249103C, "Smart Array P812", &SA5_access},
-	{0x324A103C, "Smart Array P712m", &SA5_access},
-	{0x324B103C, "Smart Array P711m", &SA5_access},
-	{0x3350103C, "Smart Array", &SA5_access},
-	{0x3351103C, "Smart Array", &SA5_access},
-	{0x3352103C, "Smart Array", &SA5_access},
-	{0x3353103C, "Smart Array", &SA5_access},
-	{0x3354103C, "Smart Array", &SA5_access},
-	{0x3355103C, "Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
@@ -3970,9 +3937,6 @@ static int __devinit cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 			subsystem_vendor_id;
 
 	for (i = 0; i < ARRAY_SIZE(products); i++) {
-		/* Stand aside for hpsa driver on request */
-		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
-			return -ENODEV;
 		if (*board_id == products[i].board_id)
 			return i;
 	}
