From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2] hpsa: use check_signature
Date: Wed,  4 Apr 2012 22:14:59 +0900
Message-ID: <1333545299-13040-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Miller <mike.miller@hp.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use check_signature to find a signature in the mmio address.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
v2: select CHECK_SIGNATURE in Kconfig

 drivers/scsi/Kconfig |    1 +
 drivers/scsi/hpsa.c  |    5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 29684c8..bea04e5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -408,6 +408,7 @@ config BLK_DEV_3W_XXXX_RAID
 config SCSI_HPSA
 	tristate "HP Smart Array SCSI driver"
 	depends on PCI && SCSI
+	select CHECK_SIGNATURE
 	help
 	  This driver supports HP Smart Array Controllers (circa 2009).
 	  It is a SCSI alternative to the cciss driver, which is a block
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ddbf5fe..c867eeb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3839,10 +3839,7 @@ static void __devinit hpsa_find_board_params(struct ctlr_info *h)
 
 static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 {
-	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
 		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
 		return false;
 	}
-- 
1.7.4.4
