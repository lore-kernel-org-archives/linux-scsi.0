From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 43/52] atp870u: Remove chip_ver from struct atp_unit
Date: Tue, 17 Nov 2015 19:24:19 +0100
Message-ID: <1447784668-23713-44-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56520 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbbKQSgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:44 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

chip_ver is used for wide chip detection only. Remove it and use a local
variable instead (for 870; 880 and 885 are always wide).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   39 ++++++++++++++-------------------------
 drivers/scsi/atp870u.h |    1 -
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 128613e..f92eb00 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -954,7 +954,7 @@ static unsigned char fun_scam(struct atp_unit *dev, unsigned short int *val)
 	return j;
 }
 
-static void tscam(struct Scsi_Host *host)
+static void tscam(struct Scsi_Host *host, bool wide_chip)
 {
 
 	unsigned char i, j, k;
@@ -983,7 +983,7 @@ static void tscam(struct Scsi_Host *host)
 	m = 1;
 	m <<= dev->host_id[0];
 	j = 16;
-	if (dev->chip_ver < 4) {
+	if (!wide_chip) {
 		m |= 0xff00;
 		j = 8;
 	}
@@ -1012,7 +1012,7 @@ static void tscam(struct Scsi_Host *host)
 			k = i;
 		}
 		atp_writeb_io(dev, 0, 0x15, k);
-		if (dev->chip_ver == 4)
+		if (wide_chip)
 			atp_writeb_io(dev, 0, 0x1b, 0x01);
 		else
 			atp_writeb_io(dev, 0, 0x1b, 0x00);
@@ -1278,25 +1278,11 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	atpdev->pdev = pdev;
 	pci_set_drvdata(pdev, atpdev);
 
-	switch (ent->device) {
-	case PCI_DEVICE_ID_ARTOP_AEC7610:
-		atpdev->chip_ver = pdev->revision;
-		break;
-	case PCI_DEVICE_ID_ARTOP_AEC7612UW:
-	case PCI_DEVICE_ID_ARTOP_AEC7612SUW:
-	case ATP880_DEVID1:	
-	case ATP880_DEVID2:	
-	case ATP885_DEVID:	
-		atpdev->chip_ver = 0x04;
-	default:
-		break;
-	}
 	base_io = pci_resource_start(pdev, 0);
 	base_io &= 0xfffffff8;
 	atpdev->baseport = base_io;
 
 	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
-		atpdev->chip_ver = pdev->revision;
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
 		atpdev->ioport[0] = base_io + 0x40;
@@ -1390,7 +1376,7 @@ flash_ok_880:
 
 		atp_set_host_id(atpdev, 0, host_id);
 
-		tscam(shpnt);
+		tscam(shpnt, true);
 		atp_is(atpdev, 0, true, atp_readb_base(atpdev, 0x3f) & 0x40);
 		atp_writeb_base(atpdev, 0x38, 0xb0);
 		shpnt->max_id = 16;
@@ -1536,6 +1522,11 @@ flash_ok_885:
 		shpnt->irq = pdev->irq;
 				
 	} else {
+		bool wide_chip =
+			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 &&
+			 pdev->revision == 4) ||
+			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7612UW) ||
+			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7612SUW);
 		error = pci_read_config_byte(pdev, 0x49, &host_id);
 
 		printk(KERN_INFO "   ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: "
@@ -1569,7 +1560,7 @@ flash_ok_885:
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
-		if (atpdev->chip_ver > 0x07)	/* check if atp876 chip then enable terminator */
+		if (pdev->revision > 0x07)	/* check if atp876 chip then enable terminator */
 			atp_writeb_base(atpdev, 0x3e, 0x00);
  
 		k = (atp_readb_base(atpdev, 0x3a) & 0xf3) | 0x10;
@@ -1580,15 +1571,13 @@ flash_ok_885:
 		mdelay(32);
 		atp_set_host_id(atpdev, 0, host_id);
 
-		tscam(shpnt);
+
+		tscam(shpnt, wide_chip);
 		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) | 0x10);
-		atp_is(atpdev, 0, atpdev->chip_ver == 4, 0);
+		atp_is(atpdev, 0, wide_chip, 0);
 		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) & 0xef);
 		atp_writeb_base(atpdev, 0x3b, atp_readb_base(atpdev, 0x3b) | 0x20);
-		if (atpdev->chip_ver == 4)
-			shpnt->max_id = 16;
-		else		
-			shpnt->max_id = 8;
+		shpnt->max_id = wide_chip ? 16 : 8;
 		shpnt->this_id = host_id;
 		shpnt->unique_id = base_io;
 		shpnt->io_port = base_io;
diff --git a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
index c3c6c13..8c47c53 100644
--- a/drivers/scsi/atp870u.h
+++ b/drivers/scsi/atp870u.h
@@ -32,7 +32,6 @@ struct atp_unit
 	unsigned char quhd[2];
 	unsigned char quend[2];
 	unsigned char global_map[2];
-	unsigned char chip_ver;
 	unsigned char scam_on;
 	unsigned char host_id[2];
 	unsigned int working[2];
-- 
Ondrej Zary

