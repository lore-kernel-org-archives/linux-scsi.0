From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] advansys: fix compilation errors and warnings when CONFIG_PCI is not set
Date: Wed,  3 Jun 2015 09:56:42 +0200
Message-ID: <1433318202-1455-1-git-send-email-jthumshirn@suse.de>
References: <CA+r1ZhgMztLi-9E6cV=W1xJkMYG_rTtaJFj4Bv0TFPHmjSU+oQ@mail.gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CA+r1ZhgMztLi-9E6cV=W1xJkMYG_rTtaJFj4Bv0TFPHmjSU+oQ@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>, JBottomley@odin.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Fix compilation errors on forgotten #include <linux/dmapool.h> and warnings when
CONFIG_PCI is not set.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/advansys.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 14d3aa5..4305178 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/firmware.h>
+#include <linux/dmapool.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -9435,6 +9436,7 @@ static int AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
  * on big-endian platforms so char fields read as words are actually being
  * unswapped on big-endian platforms.
  */
+#ifdef CONFIG_PCI
 static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config = {
 	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
 	0x0000,			/* cfg_msw */
@@ -9771,7 +9773,6 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar = {
 	0			/* 63 reserved */
 };
 
-#ifdef CONFIG_PCI
 /*
  * Wait for EEPROM command to complete
  */
@@ -11385,7 +11386,9 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
  err_unmap:
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
+#ifdef CONFIG_PCI
  err_shost:
+#endif
 	return ret;
 }
 
-- 
1.8.5.2
