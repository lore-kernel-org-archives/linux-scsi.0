From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 52/52] atp870u: Introduce atp870_init()
Date: Tue, 17 Nov 2015 19:24:28 +0100
Message-ID: <1447784668-23713-53-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56600 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbbKQSiX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:38:23 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Move 870-specific init code to a separate function atp870_init()

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  104 +++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 584b90f..8b52a9d 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1249,6 +1249,57 @@ static void atp_set_host_id(struct atp_unit *atp, u8 c, u8 host_id)
 	atp_writeb_io(atp, c, 0x11, 0x20);
 }
 
+static void atp870_init(struct Scsi_Host *shpnt)
+{
+	struct atp_unit *atpdev = shost_priv(shpnt);
+	struct pci_dev *pdev = atpdev->pdev;
+	unsigned char k, host_id;
+	u8 scam_on;
+	bool wide_chip =
+		(pdev->device == PCI_DEVICE_ID_ARTOP_AEC7610 &&
+		 pdev->revision == 4) ||
+		(pdev->device == PCI_DEVICE_ID_ARTOP_AEC7612UW) ||
+		(pdev->device == PCI_DEVICE_ID_ARTOP_AEC7612SUW);
+
+	pci_read_config_byte(pdev, 0x49, &host_id);
+
+	dev_info(&pdev->dev, "ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: IO:%lx, IRQ:%d.\n",
+		 shpnt->io_port, shpnt->irq);
+
+	atpdev->ioport[0] = shpnt->io_port;
+	atpdev->pciport[0] = shpnt->io_port + 0x20;
+	host_id &= 0x07;
+	atpdev->host_id[0] = host_id;
+	scam_on = atp_readb_pci(atpdev, 0, 2);
+	atpdev->global_map[0] = atp_readb_base(atpdev, 0x2d);
+	atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x2e);
+
+	if (atpdev->ultra_map[0] == 0) {
+		scam_on = 0x00;
+		atpdev->global_map[0] = 0x20;
+		atpdev->ultra_map[0] = 0xffff;
+	}
+
+	if (pdev->revision > 0x07)	/* check if atp876 chip */
+		atp_writeb_base(atpdev, 0x3e, 0x00); /* enable terminator */
+
+	k = (atp_readb_base(atpdev, 0x3a) & 0xf3) | 0x10;
+	atp_writeb_base(atpdev, 0x3a, k);
+	atp_writeb_base(atpdev, 0x3a, k & 0xdf);
+	mdelay(32);
+	atp_writeb_base(atpdev, 0x3a, k);
+	mdelay(32);
+	atp_set_host_id(atpdev, 0, host_id);
+
+	tscam(shpnt, wide_chip, scam_on);
+	atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) | 0x10);
+	atp_is(atpdev, 0, wide_chip, 0);
+	atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) & 0xef);
+	atp_writeb_base(atpdev, 0x3b, atp_readb_base(atpdev, 0x3b) | 0x20);
+	shpnt->max_id = wide_chip ? 16 : 8;
+	shpnt->this_id = host_id;
+}
+
 static void atp880_init(struct Scsi_Host *shpnt)
 {
 	struct atp_unit *atpdev = shost_priv(shpnt);
@@ -1445,9 +1496,6 @@ static void atp885_init(struct Scsi_Host *shpnt)
 /* return non-zero on detection */
 static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	unsigned char k;
-	unsigned int error;
-	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
 	struct atp_unit *atpdev;
 	int err;
@@ -1500,53 +1548,9 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		atp880_init(shpnt);
 	else if (is885(atpdev))
 		atp885_init(shpnt);
-	else {
-		u8 scam_on;
-		bool wide_chip =
-			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 &&
-			 pdev->revision == 4) ||
-			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7612UW) ||
-			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7612SUW);
-		error = pci_read_config_byte(pdev, 0x49, &host_id);
-
-		printk(KERN_INFO "   ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: "
-			"IO:%lx, IRQ:%d.\n", shpnt->io_port, shpnt->irq);
-
-		atpdev->ioport[0] = shpnt->io_port;
-		atpdev->pciport[0] = shpnt->io_port + 0x20;
-		host_id &= 0x07;
-		atpdev->host_id[0] = host_id;
-		scam_on = atp_readb_pci(atpdev, 0, 2);
-		atpdev->global_map[0] = atp_readb_base(atpdev, 0x2d);
-		atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x2e);
-
-		if (atpdev->ultra_map[0] == 0) {
-			scam_on = 0x00;
-			atpdev->global_map[0] = 0x20;
-			atpdev->ultra_map[0] = 0xffff;
-		}
-
-		if (pdev->revision > 0x07)	/* check if atp876 chip then enable terminator */
-			atp_writeb_base(atpdev, 0x3e, 0x00);
- 
-		k = (atp_readb_base(atpdev, 0x3a) & 0xf3) | 0x10;
-		atp_writeb_base(atpdev, 0x3a, k);
-		atp_writeb_base(atpdev, 0x3a, k & 0xdf);
-		mdelay(32);
-		atp_writeb_base(atpdev, 0x3a, k);
-		mdelay(32);
-		atp_set_host_id(atpdev, 0, host_id);
-
-
-		tscam(shpnt, wide_chip, scam_on);
-		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) | 0x10);
-		atp_is(atpdev, 0, wide_chip, 0);
-		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) & 0xef);
-		atp_writeb_base(atpdev, 0x3b, atp_readb_base(atpdev, 0x3b) | 0x20);
-		shpnt->max_id = wide_chip ? 16 : 8;
-		shpnt->this_id = host_id;
-
-	} 
+	else
+		atp870_init(shpnt);
+
 	err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to allocate IRQ %d.\n", shpnt->irq);
-- 
Ondrej Zary

