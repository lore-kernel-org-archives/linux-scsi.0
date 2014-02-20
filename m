From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 1/2] advansys: change buildtime warning into runtime error
Date: Thu, 20 Feb 2014 10:13:37 +0100
Message-ID: <1392887617.5070.43.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Building advansys.o triggers this warning:
    drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API [-Wcpp]

This warning can be traced back to a patch called "advansys: add warning
and convert #includes" which was included in v2.6.10. That patch also
marked the driver as BROKEN.

Commit 4661e3eace2c7b8433476b5bf0ee437ab3c7dfd4 ("[SCSI] advansys
driver: limp along on x86") enabled this driver for x86-32. And commit
9d511a4b29de6764931343d03e493f2e04df0271 ("[SCSI] advansys: Changes to
work on parisc") enabled this driver for all architectures. But the
commit explanation stated:
    I haven't removed the #warning yet because virt_to_bus/bus_to_virt are
    only eliminated for narrow boards.  Wide boards need more work.

Six years have passed and, apparently, those wide boards still need
more work. So let's change the buildtime warning into a runtime error,
only printed for those wide boards. Perhaps that might push the people
using those wide boards to convert this driver. And for all others
there's now one less buildtime warning to ignore.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only. I don't have any Advansys SCSI boards (neither
narrow nor wide).

 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d814588..5999c60 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -68,7 +68,6 @@
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
-#warning this driver is still not properly converted to the DMA API
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
@@ -12260,6 +12259,7 @@ static int advansys_pci_probe(struct pci_dev *pdev,
 	    pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
 	    pdev->device == PCI_DEVICE_ID_38C1600_REV1) {
 		board->flags |= ASC_IS_WIDE_BOARD;
+		pr_err("This driver is still not properly converted to the DMA API");
 	}
 
 	err = advansys_board_found(shost, ioport, ASC_IS_PCI);
-- 
1.8.5.3
