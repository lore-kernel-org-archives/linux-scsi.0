From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/13] cciss: remove controllers supported by hpsa
Date: Fri, 08 Oct 2010 15:06:06 -0500
Message-ID: <20101008200606.24279.37953.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We would prefer not to have any overlap between the two drivers.
Remove the cciss_allow_hpsa option, as it it is no longer needed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   38 +-------------------------------------
 1 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5e4fadc..ca900ea 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -66,12 +66,6 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
 MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 
-static int cciss_allow_hpsa;
-module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(cciss_allow_hpsa,
-	"Prevent cciss driver from accessing hardware known to be "
-	" supported by the hpsa driver");
-
 #include "cciss_cmd.h"
 #include "cciss.h"
 #include <linux/cciss_ioctl.h>
@@ -98,18 +92,6 @@ static const struct pci_device_id cciss_pci_device_id[] = {
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
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
 	{0,}
 };
 
@@ -137,23 +119,9 @@ static struct board_type products[] = {
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
-	{0x3250103C, "Smart Array", &SA5_access},
-	{0x3251103C, "Smart Array", &SA5_access},
-	{0x3252103C, "Smart Array", &SA5_access},
-	{0x3253103C, "Smart Array", &SA5_access},
-	{0x3254103C, "Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
@@ -3985,13 +3953,9 @@ static int __devinit cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
 			subsystem_vendor_id;
 
-	for (i = 0; i < ARRAY_SIZE(products); i++) {
-		/* Stand aside for hpsa driver on request */
-		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
-			return -ENODEV;
+	for (i = 0; i < ARRAY_SIZE(products); i++)
 		if (*board_id == products[i].board_id)
 			return i;
-	}
 	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x, ignoring.\n",
 		*board_id);
 	return -ENODEV;
