From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 50/52] atp870u: Introduce atp880_init()
Date: Tue, 17 Nov 2015 19:24:26 +0100
Message-ID: <1447784668-23713-51-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56469 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSfy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:35:54 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Move 880-specific init code to a separate function atp880_init()

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  174 ++++++++++++++++++++++++------------------------
 1 file changed, 88 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 3c66539..c1fd9fb 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1249,6 +1249,91 @@ static void atp_set_host_id(struct atp_unit *atp, u8 c, u8 host_id)
 	atp_writeb_io(atp, c, 0x11, 0x20);
 }
 
+static void atp880_init(struct Scsi_Host *shpnt)
+{
+	struct atp_unit *atpdev = shost_priv(shpnt);
+	struct pci_dev *pdev = atpdev->pdev;
+	unsigned char k, m, host_id;
+	unsigned int n;
+
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);
+
+	atpdev->ioport[0] = shpnt->io_port + 0x40;
+	atpdev->pciport[0] = shpnt->io_port + 0x28;
+
+	host_id = atp_readb_base(atpdev, 0x39) >> 4;
+
+	dev_info(&pdev->dev, "ACARD AEC-67160 PCI Ultra3 LVD Host Adapter: IO:%lx, IRQ:%d.\n",
+		 shpnt->io_port, shpnt->irq);
+	atpdev->host_id[0] = host_id;
+
+	atpdev->global_map[0] = atp_readb_base(atpdev, 0x35);
+	atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x3c);
+
+	n = 0x3f09;
+	while (n < 0x4000) {
+		m = 0;
+		atp_writew_base(atpdev, 0x34, n);
+		n += 0x0002;
+		if (atp_readb_base(atpdev, 0x30) == 0xff)
+			break;
+
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		atp_writew_base(atpdev, 0x34, n);
+		n += 0x0002;
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		atp_writew_base(atpdev, 0x34, n);
+		n += 0x0002;
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		atp_writew_base(atpdev, 0x34, n);
+		n += 0x0002;
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		n += 0x0018;
+	}
+	atp_writew_base(atpdev, 0x34, 0);
+	atpdev->ultra_map[0] = 0;
+	atpdev->async[0] = 0;
+	for (k = 0; k < 16; k++) {
+		n = 1 << k;
+		if (atpdev->sp[0][k] > 1)
+			atpdev->ultra_map[0] |= n;
+		else
+			if (atpdev->sp[0][k] == 0)
+				atpdev->async[0] |= n;
+	}
+	atpdev->async[0] = ~(atpdev->async[0]);
+	atp_writeb_base(atpdev, 0x35, atpdev->global_map[0]);
+
+	k = atp_readb_base(atpdev, 0x38) & 0x80;
+	atp_writeb_base(atpdev, 0x38, k);
+	atp_writeb_base(atpdev, 0x3b, 0x20);
+	mdelay(32);
+	atp_writeb_base(atpdev, 0x3b, 0);
+	mdelay(32);
+	atp_readb_io(atpdev, 0, 0x1b);
+	atp_readb_io(atpdev, 0, 0x17);
+
+	atp_set_host_id(atpdev, 0, host_id);
+
+	tscam(shpnt, true, atp_readb_base(atpdev, 0x22));
+	atp_is(atpdev, 0, true, atp_readb_base(atpdev, 0x3f) & 0x40);
+	atp_writeb_base(atpdev, 0x38, 0xb0);
+	shpnt->max_id = 16;
+	shpnt->this_id = host_id;
+}
+
 /* return non-zero on detection */
 static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -1304,92 +1389,9 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto unregister;
 	}
 
-	if (is880(atpdev)) {
-		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
-
-		atpdev->ioport[0] = shpnt->io_port + 0x40;
-		atpdev->pciport[0] = shpnt->io_port + 0x28;
-
-		host_id = atp_readb_base(atpdev, 0x39);
-		host_id >>= 0x04;
-
-		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter:"
-			"    IO:%lx, IRQ:%d.\n", shpnt->io_port, shpnt->irq);
-		atpdev->host_id[0] = host_id;
-
-		atpdev->global_map[0] = atp_readb_base(atpdev, 0x35);
-		atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x3c);
-
-		n = 0x3f09;
-next_fblk_880:
-		if (n >= 0x4000)
-			goto flash_ok_880;
-
-		m = 0;
-		atp_writew_base(atpdev, 0x34, n);
-		n += 0x0002;
-		if (atp_readb_base(atpdev, 0x30) == 0xff)
-			goto flash_ok_880;
-
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
-		atp_writew_base(atpdev, 0x34, n);
-		n += 0x0002;
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
-		atp_writew_base(atpdev, 0x34, n);
-		n += 0x0002;
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
-		atp_writew_base(atpdev, 0x34, n);
-		n += 0x0002;
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
-		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
-		n += 0x0018;
-		goto next_fblk_880;
-flash_ok_880:
-		atp_writew_base(atpdev, 0x34, 0);
-		atpdev->ultra_map[0] = 0;
-		atpdev->async[0] = 0;
-		for (k = 0; k < 16; k++) {
-			n = 1;
-			n = n << k;
-			if (atpdev->sp[0][k] > 1) {
-				atpdev->ultra_map[0] |= n;
-			} else {
-				if (atpdev->sp[0][k] == 0)
-					atpdev->async[0] |= n;
- 			}
-	 	}
-		atpdev->async[0] = ~(atpdev->async[0]);
-		atp_writeb_base(atpdev, 0x35, atpdev->global_map[0]);
- 
-
-		k = atp_readb_base(atpdev, 0x38) & 0x80;
-		atp_writeb_base(atpdev, 0x38, k);
-		atp_writeb_base(atpdev, 0x3b, 0x20);
-		mdelay(32);
-		atp_writeb_base(atpdev, 0x3b, 0);
-		mdelay(32);
-		atp_readb_io(atpdev, 0, 0x1b);
-		atp_readb_io(atpdev, 0, 0x17);
-
-		atp_set_host_id(atpdev, 0, host_id);
-
-		tscam(shpnt, true, atp_readb_base(atpdev, 0x22));
-		atp_is(atpdev, 0, true, atp_readb_base(atpdev, 0x3f) & 0x40);
-		atp_writeb_base(atpdev, 0x38, 0xb0);
-		shpnt->max_id = 16;
-		shpnt->this_id = host_id;
-	} else if (is885(atpdev)) {
+	if (is880(atpdev))
+		atp880_init(shpnt);
+	else if (is885(atpdev)) {
 			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%lx, IRQ:%d.\n"
 			       , shpnt->io_port, shpnt->irq);
         	
-- 
Ondrej Zary

