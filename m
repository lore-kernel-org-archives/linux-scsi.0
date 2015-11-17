From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 51/52] atp870u: Introduce atp885_init()
Date: Tue, 17 Nov 2015 19:24:27 +0100
Message-ID: <1447784668-23713-52-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56466 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:35:51 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Move 885-specific init code to a separate function atp885_init()

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  231 +++++++++++++++++++++++-------------------------
 1 file changed, 113 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index c1fd9fb..584b90f 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1334,15 +1334,122 @@ static void atp880_init(struct Scsi_Host *shpnt)
 	shpnt->this_id = host_id;
 }
 
+static void atp885_init(struct Scsi_Host *shpnt)
+{
+	struct atp_unit *atpdev = shost_priv(shpnt);
+	struct pci_dev *pdev = atpdev->pdev;
+	unsigned char k, m, c;
+	unsigned int n;
+	unsigned char setupdata[2][16];
+
+	dev_info(&pdev->dev, "ACARD AEC-67162 PCI Ultra3 LVD Host Adapter: IO:%lx, IRQ:%d.\n",
+		 shpnt->io_port, shpnt->irq);
+
+	atpdev->ioport[0] = shpnt->io_port + 0x80;
+	atpdev->ioport[1] = shpnt->io_port + 0xc0;
+	atpdev->pciport[0] = shpnt->io_port + 0x40;
+	atpdev->pciport[1] = shpnt->io_port + 0x50;
+
+	c = atp_readb_base(atpdev, 0x29);
+	atp_writeb_base(atpdev, 0x29, c | 0x04);
+
+	n = 0x1f80;
+	while (n < 0x2000) {
+		atp_writew_base(atpdev, 0x3c, n);
+		if (atp_readl_base(atpdev, 0x38) == 0xffffffff)
+			break;
+		for (m = 0; m < 2; m++) {
+			atpdev->global_map[m] = 0;
+			for (k = 0; k < 4; k++) {
+				atp_writew_base(atpdev, 0x3c, n++);
+				((unsigned long *)&setupdata[m][0])[k] = atp_readl_base(atpdev, 0x38);
+			}
+			for (k = 0; k < 4; k++) {
+				atp_writew_base(atpdev, 0x3c, n++);
+				((unsigned long *)&atpdev->sp[m][0])[k] = atp_readl_base(atpdev, 0x38);
+			}
+			n += 8;
+		}
+	}
+	c = atp_readb_base(atpdev, 0x29);
+	atp_writeb_base(atpdev, 0x29, c & 0xfb);
+	for (c = 0; c < 2; c++) {
+		atpdev->ultra_map[c] = 0;
+		atpdev->async[c] = 0;
+		for (k = 0; k < 16; k++) {
+			n = 1 << k;
+			if (atpdev->sp[c][k] > 1)
+				atpdev->ultra_map[c] |= n;
+			else
+				if (atpdev->sp[c][k] == 0)
+					atpdev->async[c] |= n;
+		}
+		atpdev->async[c] = ~(atpdev->async[c]);
+
+		if (atpdev->global_map[c] == 0) {
+			k = setupdata[c][1];
+			if ((k & 0x40) != 0)
+				atpdev->global_map[c] |= 0x20;
+			k &= 0x07;
+			atpdev->global_map[c] |= k;
+			if ((setupdata[c][2] & 0x04) != 0)
+				atpdev->global_map[c] |= 0x08;
+			atpdev->host_id[c] = setupdata[c][0] & 0x07;
+		}
+	}
+
+	k = atp_readb_base(atpdev, 0x28) & 0x8f;
+	k |= 0x10;
+	atp_writeb_base(atpdev, 0x28, k);
+	atp_writeb_pci(atpdev, 0, 1, 0x80);
+	atp_writeb_pci(atpdev, 1, 1, 0x80);
+	mdelay(100);
+	atp_writeb_pci(atpdev, 0, 1, 0);
+	atp_writeb_pci(atpdev, 1, 1, 0);
+	mdelay(1000);
+	atp_readb_io(atpdev, 0, 0x1b);
+	atp_readb_io(atpdev, 0, 0x17);
+	atp_readb_io(atpdev, 1, 0x1b);
+	atp_readb_io(atpdev, 1, 0x17);
+
+	k = atpdev->host_id[0];
+	if (k > 7)
+		k = (k & 0x07) | 0x40;
+	atp_set_host_id(atpdev, 0, k);
+
+	k = atpdev->host_id[1];
+	if (k > 7)
+		k = (k & 0x07) | 0x40;
+	atp_set_host_id(atpdev, 1, k);
+
+	mdelay(600); /* this delay used to be called tscam_885() */
+	dev_info(&pdev->dev, "Scanning Channel A SCSI Device ...\n");
+	atp_is(atpdev, 0, true, atp_readb_io(atpdev, 0, 0x1b) >> 7);
+	atp_writeb_io(atpdev, 0, 0x16, 0x80);
+	dev_info(&pdev->dev, "Scanning Channel B SCSI Device ...\n");
+	atp_is(atpdev, 1, true, atp_readb_io(atpdev, 1, 0x1b) >> 7);
+	atp_writeb_io(atpdev, 1, 0x16, 0x80);
+	k = atp_readb_base(atpdev, 0x28) & 0xcf;
+	k |= 0xc0;
+	atp_writeb_base(atpdev, 0x28, k);
+	k = atp_readb_base(atpdev, 0x1f) | 0x80;
+	atp_writeb_base(atpdev, 0x1f, k);
+	k = atp_readb_base(atpdev, 0x29) | 0x01;
+	atp_writeb_base(atpdev, 0x29, k);
+	shpnt->max_id = 16;
+	shpnt->max_lun = (atpdev->global_map[0] & 0x07) + 1;
+	shpnt->max_channel = 1;
+	shpnt->this_id = atpdev->host_id[0];
+}
+
 /* return non-zero on detection */
 static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	unsigned char k, m, c;
-	unsigned int error,n;
+	unsigned char k;
+	unsigned int error;
 	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
 	struct atp_unit *atpdev;
-	unsigned char setupdata[2][16];
 	int err;
 
 	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 && pdev->revision < 2) {
@@ -1391,121 +1498,9 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (is880(atpdev))
 		atp880_init(shpnt);
-	else if (is885(atpdev)) {
-			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%lx, IRQ:%d.\n"
-			       , shpnt->io_port, shpnt->irq);
-        	
-		atpdev->pdev = pdev;
-		atpdev->ioport[0] = shpnt->io_port + 0x80;
-		atpdev->ioport[1] = shpnt->io_port + 0xc0;
-		atpdev->pciport[0] = shpnt->io_port + 0x40;
-		atpdev->pciport[1] = shpnt->io_port + 0x50;
-				
-		c = atp_readb_base(atpdev, 0x29);
-		atp_writeb_base(atpdev, 0x29, c | 0x04);
-        	
-		n=0x1f80;
-next_fblk_885:
-		if (n >= 0x2000) {
-		   goto flash_ok_885;
-		}
-		atp_writew_base(atpdev, 0x3c, n);
-		if (atp_readl_base(atpdev, 0x38) == 0xffffffff) {
-		   goto flash_ok_885;
-		}
-		for (m=0; m < 2; m++) {
-		    atpdev->global_map[m]= 0;
-		    for (k=0; k < 4; k++) {
-			atp_writew_base(atpdev, 0x3c, n++);
-			((unsigned long *)&setupdata[m][0])[k] = atp_readl_base(atpdev, 0x38);
-		    }
-		    for (k=0; k < 4; k++) {
-			atp_writew_base(atpdev, 0x3c, n++);
-			((unsigned long *)&atpdev->sp[m][0])[k] = atp_readl_base(atpdev, 0x38);
-		    }
-		    n += 8;
-		}
-		goto next_fblk_885;
-flash_ok_885:
-#ifdef ED_DBGP
-		printk( "Flash Read OK\n");
-#endif	
-		c = atp_readb_base(atpdev, 0x29);
-		atp_writeb_base(atpdev, 0x29, c & 0xfb);
-		for (c=0;c < 2;c++) {
-		    atpdev->ultra_map[c]=0;
-		    atpdev->async[c] = 0;
-		    for (k=0; k < 16; k++) {
-			n=1;
-			n = n << k;
-			if (atpdev->sp[c][k] > 1) {
-			   atpdev->ultra_map[c] |= n;
-			} else {
-			   if (atpdev->sp[c][k] == 0) {
-			      atpdev->async[c] |= n;
-			   }
-			}
-		    }
-		    atpdev->async[c] = ~(atpdev->async[c]);
-
-		    if (atpdev->global_map[c] == 0) {
-		       k=setupdata[c][1];
-		       if ((k & 0x40) != 0)
-			  atpdev->global_map[c] |= 0x20;
-		       k &= 0x07;
-		       atpdev->global_map[c] |= k;
-		       if ((setupdata[c][2] & 0x04) != 0)
-			  atpdev->global_map[c] |= 0x08;
-		       atpdev->host_id[c] = setupdata[c][0] & 0x07;
-		    }
-		}
-
-		k = atp_readb_base(atpdev, 0x28) & 0x8f;
-		k |= 0x10;
-		atp_writeb_base(atpdev, 0x28, k);
-		atp_writeb_pci(atpdev, 0, 1, 0x80);
-		atp_writeb_pci(atpdev, 1, 1, 0x80);
-		mdelay(100);
-		atp_writeb_pci(atpdev, 0, 1, 0);
-		atp_writeb_pci(atpdev, 1, 1, 0);
-		mdelay(1000);
-		atp_readb_io(atpdev, 0, 0x1b);
-		atp_readb_io(atpdev, 0, 0x17);
-		atp_readb_io(atpdev, 1, 0x1b);
-		atp_readb_io(atpdev, 1, 0x17);
-
-		k=atpdev->host_id[0];
-		if (k > 7)
-		   k = (k & 0x07) | 0x40;
-		atp_set_host_id(atpdev, 0, k);
-
-		k=atpdev->host_id[1];
-		if (k > 7)
-		   k = (k & 0x07) | 0x40;
-		atp_set_host_id(atpdev, 1, k);
-
-		mdelay(600); /* this delay used to be called tscam_885() */
-		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
-		atp_is(atpdev, 0, true, atp_readb_io(atpdev, 0, 0x1b) >> 7);
-		atp_writeb_io(atpdev, 0, 0x16, 0x80);
-		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
-		atp_is(atpdev, 1, true, atp_readb_io(atpdev, 1, 0x1b) >> 7);
-		atp_writeb_io(atpdev, 1, 0x16, 0x80);
-		k = atp_readb_base(atpdev, 0x28) & 0xcf;
-		k |= 0xc0;
-		atp_writeb_base(atpdev, 0x28, k);
-		k = atp_readb_base(atpdev, 0x1f) | 0x80;
-		atp_writeb_base(atpdev, 0x1f, k);
-		k = atp_readb_base(atpdev, 0x29) | 0x01;
-		atp_writeb_base(atpdev, 0x29, k);
-#ifdef ED_DBGP
-		//printk("atp885: atp_host[0] 0x%p\n", atp_host[0]);
-#endif		
-		shpnt->max_id = 16;
-		shpnt->max_lun = (atpdev->global_map[0] & 0x07) + 1;
-		shpnt->max_channel = 1;
-		shpnt->this_id = atpdev->host_id[0];
-	} else {
+	else if (is885(atpdev))
+		atp885_init(shpnt);
+	else {
 		u8 scam_on;
 		bool wide_chip =
 			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 &&
-- 
Ondrej Zary

