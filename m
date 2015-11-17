From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 48/52] atp870u: Remove scam_on from struct atp_unit
Date: Tue, 17 Nov 2015 19:24:24 +0100
Message-ID: <1447784668-23713-49-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56562 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbbKQShq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:46 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

scam_on is used only during probe, no need to keep it later.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   14 +++++++-------
 drivers/scsi/atp870u.h |    1 -
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 4719df4..dd0b520 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -963,7 +963,7 @@ static unsigned char fun_scam(struct atp_unit *dev, unsigned short int *val)
 	return j;
 }
 
-static void tscam(struct Scsi_Host *host, bool wide_chip)
+static void tscam(struct Scsi_Host *host, bool wide_chip, u8 scam_on)
 {
 
 	unsigned char i, j, k;
@@ -986,7 +986,7 @@ static void tscam(struct Scsi_Host *host, bool wide_chip)
 	atp_writeb_io(dev, 0, 2, 0x7f);
 	atp_writeb_io(dev, 0, 0x11, 0x20);
 
-	if ((dev->scam_on & 0x40) == 0) {
+	if ((scam_on & 0x40) == 0) {
 		return;
 	}
 	m = 1;
@@ -1311,7 +1311,6 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			"    IO:%lx, IRQ:%d.\n", shpnt->io_port, shpnt->irq);
 		atpdev->host_id[0] = host_id;
 
-		atpdev->scam_on = atp_readb_base(atpdev, 0x22);
 		atpdev->global_map[0] = atp_readb_base(atpdev, 0x35);
 		atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x3c);
 
@@ -1384,7 +1383,7 @@ flash_ok_880:
 
 		atp_set_host_id(atpdev, 0, host_id);
 
-		tscam(shpnt, true);
+		tscam(shpnt, true, atp_readb_base(atpdev, 0x22));
 		atp_is(atpdev, 0, true, atp_readb_base(atpdev, 0x3f) & 0x40);
 		atp_writeb_base(atpdev, 0x38, 0xb0);
 		shpnt->max_id = 16;
@@ -1509,6 +1508,7 @@ flash_ok_885:
 		shpnt->max_channel = 1;
 		shpnt->this_id = atpdev->host_id[0];
 	} else {
+		u8 scam_on;
 		bool wide_chip =
 			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 &&
 			 pdev->revision == 4) ||
@@ -1523,12 +1523,12 @@ flash_ok_885:
 		atpdev->pciport[0] = shpnt->io_port + 0x20;
 		host_id &= 0x07;
 		atpdev->host_id[0] = host_id;
-		atpdev->scam_on = atp_readb_pci(atpdev, 0, 2);
+		scam_on = atp_readb_pci(atpdev, 0, 2);
 		atpdev->global_map[0] = atp_readb_base(atpdev, 0x2d);
 		atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x2e);
 
 		if (atpdev->ultra_map[0] == 0) {
-			atpdev->scam_on = 0x00;
+			scam_on = 0x00;
 			atpdev->global_map[0] = 0x20;
 			atpdev->ultra_map[0] = 0xffff;
 		}
@@ -1551,7 +1551,7 @@ flash_ok_885:
 		atp_set_host_id(atpdev, 0, host_id);
 
 
-		tscam(shpnt, wide_chip);
+		tscam(shpnt, wide_chip, scam_on);
 		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) | 0x10);
 		atp_is(atpdev, 0, wide_chip, 0);
 		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) & 0xef);
diff --git a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
index f9d62a2..9b839b1 100644
--- a/drivers/scsi/atp870u.h
+++ b/drivers/scsi/atp870u.h
@@ -32,7 +32,6 @@ struct atp_unit
 	unsigned char quhd[2];
 	unsigned char quend[2];
 	unsigned char global_map[2];
-	unsigned char scam_on;
 	unsigned char host_id[2];
 	unsigned int working[2];
 	unsigned short wide_id[2];
-- 
Ondrej Zary

