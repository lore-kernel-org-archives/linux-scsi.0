From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 49/52] atp870u: Initialize tables earlier
Date: Tue, 17 Nov 2015 19:24:25 +0100
Message-ID: <1447784668-23713-50-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56472 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:35:56 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Call _init_tables before chip-specific initialization. This avoids code
duplication and fixes a bug(?) in 880 init where the values read from flash
into atpdev->sp are then overwritten by calling init_tables.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index dd0b520..3c66539 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1298,6 +1298,12 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	shpnt->unique_id = shpnt->io_port;
 	shpnt->irq = pdev->irq;
 
+	err = atp870u_init_tables(shpnt);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to allocate tables for Acard controller\n");
+		goto unregister;
+	}
+
 	if (is880(atpdev)) {
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
@@ -1366,11 +1372,6 @@ flash_ok_880:
 		atpdev->async[0] = ~(atpdev->async[0]);
 		atp_writeb_base(atpdev, 0x35, atpdev->global_map[0]);
  
-		if (atp870u_init_tables(shpnt) < 0) {
-			printk(KERN_ERR "Unable to allocate tables for Acard controller\n");
-			err = -ENOMEM;
-			goto unregister;
-		}
 
 		k = atp_readb_base(atpdev, 0x38) & 0x80;
 		atp_writeb_base(atpdev, 0x38, k);
@@ -1398,11 +1399,6 @@ flash_ok_880:
 		atpdev->pciport[0] = shpnt->io_port + 0x40;
 		atpdev->pciport[1] = shpnt->io_port + 0x50;
 				
-		if (atp870u_init_tables(shpnt) < 0) {
-			err = -ENOMEM;
-			goto unregister;
-		}
-			
 		c = atp_readb_base(atpdev, 0x29);
 		atp_writeb_base(atpdev, 0x29, c | 0x04);
         	
@@ -1533,12 +1529,6 @@ flash_ok_885:
 			atpdev->ultra_map[0] = 0xffff;
 		}
 
-
-		if (atp870u_init_tables(shpnt) < 0) {
-			err = -ENOMEM;
-			goto unregister;
-		}
-
 		if (pdev->revision > 0x07)	/* check if atp876 chip then enable terminator */
 			atp_writeb_base(atpdev, 0x3e, 0x00);
  
-- 
Ondrej Zary

