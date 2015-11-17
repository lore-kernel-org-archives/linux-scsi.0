From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 31/52] atp870u: Convert remaining in[bwl] and out[bwl] to wrappers
Date: Tue, 17 Nov 2015 19:24:07 +0100
Message-ID: <1447784668-23713-32-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56478 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:02 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  222 +++++++++++++++++++++++++-----------------------
 1 file changed, 118 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 0b7d3bd..bccf872 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -49,6 +49,11 @@ static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
 	outb(val, atp->baseport + reg);
 }
 
+static inline void atp_writew_base(struct atp_unit *atp, u8 reg, u16 val)
+{
+	outw(val, atp->baseport + reg);
+}
+
 static inline void atp_writeb_io(struct atp_unit *atp, u8 channel, u8 reg, u8 val)
 {
 	outb(val, atp->ioport[channel] + reg);
@@ -74,6 +79,16 @@ static inline u8 atp_readb_base(struct atp_unit *atp, u8 reg)
 	return inb(atp->baseport + reg);
 }
 
+static inline u16 atp_readw_base(struct atp_unit *atp, u8 reg)
+{
+	return inw(atp->baseport + reg);
+}
+
+static inline u32 atp_readl_base(struct atp_unit *atp, u8 reg)
+{
+	return inl(atp->baseport + reg);
+}
+
 static inline u8 atp_readb_io(struct atp_unit *atp, u8 channel, u8 reg)
 {
 	return inb(atp->ioport[channel] + reg);
@@ -1268,19 +1283,20 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		atpdev->chip_ver = pdev->revision;
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
-		host_id = inb(base_io + 0x39);
+		atpdev->ioport[0] = base_io + 0x40;
+		atpdev->pciport[0] = base_io + 0x28;
+
+		host_id = atp_readb_base(atpdev, 0x39);
 		host_id >>= 0x04;
 
 		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter: %d"
 			"    IO:%x, IRQ:%d.\n", count, base_io, pdev->irq);
-		atpdev->ioport[0] = base_io + 0x40;
-		atpdev->pciport[0] = base_io + 0x28;
 		atpdev->dev_id = ent->device;
 		atpdev->host_id[0] = host_id;
 
-		atpdev->scam_on = inb(base_io + 0x22);
-		atpdev->global_map[0] = inb(base_io + 0x35);
-		atpdev->ultra_map[0] = inw(base_io + 0x3c);
+		atpdev->scam_on = atp_readb_base(atpdev, 0x22);
+		atpdev->global_map[0] = atp_readb_base(atpdev, 0x35);
+		atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x3c);
 
 		n = 0x3f09;
 next_fblk_880:
@@ -1288,37 +1304,37 @@ next_fblk_880:
 			goto flash_ok_880;
 
 		m = 0;
-		outw(n, base_io + 0x34);
+		atp_writew_base(atpdev, 0x34, n);
 		n += 0x0002;
-		if (inb(base_io + 0x30) == 0xff)
+		if (atp_readb_base(atpdev, 0x30) == 0xff)
 			goto flash_ok_880;
 
-		atpdev->sp[0][m++] = inb(base_io + 0x30);
-		atpdev->sp[0][m++] = inb(base_io + 0x31);
-		atpdev->sp[0][m++] = inb(base_io + 0x32);
-		atpdev->sp[0][m++] = inb(base_io + 0x33);
-		outw(n, base_io + 0x34);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		atp_writew_base(atpdev, 0x34, n);
 		n += 0x0002;
-		atpdev->sp[0][m++] = inb(base_io + 0x30);
-		atpdev->sp[0][m++] = inb(base_io + 0x31);
-		atpdev->sp[0][m++] = inb(base_io + 0x32);
-		atpdev->sp[0][m++] = inb(base_io + 0x33);
-		outw(n, base_io + 0x34);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		atp_writew_base(atpdev, 0x34, n);
 		n += 0x0002;
-		atpdev->sp[0][m++] = inb(base_io + 0x30);
-		atpdev->sp[0][m++] = inb(base_io + 0x31);
-		atpdev->sp[0][m++] = inb(base_io + 0x32);
-		atpdev->sp[0][m++] = inb(base_io + 0x33);
-		outw(n, base_io + 0x34);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
+		atp_writew_base(atpdev, 0x34, n);
 		n += 0x0002;
-		atpdev->sp[0][m++] = inb(base_io + 0x30);
-		atpdev->sp[0][m++] = inb(base_io + 0x31);
-		atpdev->sp[0][m++] = inb(base_io + 0x32);
-		atpdev->sp[0][m++] = inb(base_io + 0x33);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x30);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x31);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x32);
+		atpdev->sp[0][m++] = atp_readb_base(atpdev, 0x33);
 		n += 0x0018;
 		goto next_fblk_880;
 flash_ok_880:
-		outw(0, base_io + 0x34);
+		atp_writew_base(atpdev, 0x34, 0);
 		atpdev->ultra_map[0] = 0;
 		atpdev->async[0] = 0;
 		for (k = 0; k < 16; k++) {
@@ -1332,7 +1348,7 @@ flash_ok_880:
  			}
 	 	}
 		atpdev->async[0] = ~(atpdev->async[0]);
-		outb(atpdev->global_map[0], base_io + 0x35);
+		atp_writeb_base(atpdev, 0x35, atpdev->global_map[0]);
  
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
 		if (!shpnt)
@@ -1355,26 +1371,26 @@ flash_ok_880:
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
-		k = inb(base_io + 0x38) & 0x80;
-		outb(k, base_io + 0x38);
-		outb(0x20, base_io + 0x3b);
+		k = atp_readb_base(p, 0x38) & 0x80;
+		atp_writeb_base(p, 0x38, k);
+		atp_writeb_base(p, 0x3b, 0x20);
 		mdelay(32);
-		outb(0, base_io + 0x3b);
+		atp_writeb_base(p, 0x3b, 0);
 		mdelay(32);
-		inb(base_io + 0x5b);
-		inb(base_io + 0x57);
-		outb((host_id | 0x08), base_io + 0x40);
-		outb(0, base_io + 0x58);
-		while ((inb(base_io + 0x5f) & 0x80) == 0)
+		atp_readb_io(p, 0, 0x1b);
+		atp_readb_io(p, 0, 0x17);
+		atp_writeb_io(p, 0, 0, host_id | 0x08);
+		atp_writeb_io(p, 0, 0x18, 0);
+		while ((atp_readb_io(p, 0, 0x1f) & 0x80) == 0)
 			mdelay(1);
-		inb(base_io + 0x57);
-		outb(8, base_io + 0x41);
-		outb(0x7f, base_io + 0x42);
-		outb(0x20, base_io + 0x51);
+		atp_readb_io(p, 0, 0x17);
+		atp_writeb_io(p, 0, 1, 8);
+		atp_writeb_io(p, 0, 2, 0x7f);
+		atp_writeb_io(p, 0, 0x11, 0x20);
 
 		tscam(shpnt);
 		atp_is(p, 0, true, atp_readb_base(p, 0x3f) & 0x40);
-		outb(0xb0, base_io + 0x38);
+		atp_writeb_base(p, 0x38, 0xb0);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
 		shpnt->unique_id = base_io;
@@ -1415,27 +1431,27 @@ flash_ok_880:
 		
 		spin_lock_irqsave(shpnt->host_lock, flags);        					
         			
-		c=inb(base_io + 0x29);
-		outb((c | 0x04),base_io + 0x29);
+		c = atp_readb_base(p, 0x29);
+		atp_writeb_base(p, 0x29, c | 0x04);
         	
 		n=0x1f80;
 next_fblk_885:
 		if (n >= 0x2000) {
 		   goto flash_ok_885;
 		}
-		outw(n,base_io + 0x3c);
-		if (inl(base_io + 0x38) == 0xffffffff) {
+		atp_writew_base(p, 0x3c, n);
+		if (atp_readl_base(p, 0x38) == 0xffffffff) {
 		   goto flash_ok_885;
 		}
 		for (m=0; m < 2; m++) {
 		    p->global_map[m]= 0;
 		    for (k=0; k < 4; k++) {
-			outw(n++,base_io + 0x3c);
-			((unsigned long *)&setupdata[m][0])[k]=inl(base_io + 0x38);
+			atp_writew_base(p, 0x3c, n++);
+			((unsigned long *)&setupdata[m][0])[k] = atp_readl_base(p, 0x38);
 		    }
 		    for (k=0; k < 4; k++) {
-			outw(n++,base_io + 0x3c);
-			((unsigned long *)&p->sp[m][0])[k]=inl(base_io + 0x38);
+			atp_writew_base(p, 0x3c, n++);
+			((unsigned long *)&p->sp[m][0])[k] = atp_readl_base(p, 0x38);
 		    }
 		    n += 8;
 		}
@@ -1444,8 +1460,8 @@ flash_ok_885:
 #ifdef ED_DBGP
 		printk( "Flash Read OK\n");
 #endif	
-		c=inb(base_io + 0x29);
-		outb((c & 0xfb),base_io + 0x29);
+		c = atp_readb_base(p, 0x29);
+		atp_writeb_base(p, 0x29, c & 0xfb);
 		for (c=0;c < 2;c++) {
 		    p->ultra_map[c]=0;
 		    p->async[c] = 0;
@@ -1474,48 +1490,48 @@ flash_ok_885:
 		    }
 		}
 
-		k = inb(base_io + 0x28) & 0x8f;
+		k = atp_readb_base(p, 0x28) & 0x8f;
 		k |= 0x10;
-		outb(k, base_io + 0x28);
-		outb(0x80, base_io + 0x41);
-		outb(0x80, base_io + 0x51);
+		atp_writeb_base(p, 0x28, k);
+		atp_writeb_pci(p, 0, 1, 0x80);
+		atp_writeb_pci(p, 1, 1, 0x80);
 		mdelay(100);
-		outb(0, base_io + 0x41);
-		outb(0, base_io + 0x51);
+		atp_writeb_pci(p, 0, 1, 0);
+		atp_writeb_pci(p, 1, 1, 0);
 		mdelay(1000);
-		inb(base_io + 0x9b);
-		inb(base_io + 0x97);
-		inb(base_io + 0xdb);
-		inb(base_io + 0xd7);
+		atp_readb_io(p, 0, 0x1b);
+		atp_readb_io(p, 0, 0x17);
+		atp_readb_io(p, 1, 0x1b);
+		atp_readb_io(p, 1, 0x17);
 		k=p->host_id[0];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
 		k |= 0x08;
-		outb(k, base_io + 0x80);
-		outb(0, base_io + 0x98);
+		atp_writeb_io(p, 0, 0, k);
+		atp_writeb_io(p, 0, 0x18, 0);
 
-		while ((inb(base_io + 0x9f) & 0x80) == 0)
+		while ((atp_readb_io(p, 0, 0x1f) & 0x80) == 0)
 			cpu_relax();
 	
-		inb(base_io + 0x97);
-		outb(8, base_io + 0x81);
-		outb(0x7f, base_io + 0x82);
-		outb(0x20, base_io + 0x91);
+		atp_readb_io(p, 0, 0x17);
+		atp_writeb_io(p, 0, 1, 8);
+		atp_writeb_io(p, 0, 2, 0x7f);
+		atp_writeb_io(p, 0, 0x11, 0x20);
 
 		k=p->host_id[1];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
 		k |= 0x08;
-		outb(k, base_io + 0xc0);
-		outb(0, base_io + 0xd8);
+		atp_writeb_io(p, 1, 0, k);
+		atp_writeb_io(p, 1, 0x18, 0);
 
-		while ((inb(base_io + 0xdf) & 0x80) == 0)
+		while ((atp_readb_io(p, 1, 0x1f) & 0x80) == 0)
 			cpu_relax();
 
-		inb(base_io + 0xd7);
-		outb(8, base_io + 0xc1);
-		outb(0x7f, base_io + 0xc2);
-		outb(0x20, base_io + 0xd1);
+		atp_readb_io(p, 1, 0x17);
+		atp_writeb_io(p, 1, 1, 8);
+		atp_writeb_io(p, 1, 2, 0x7f);
+		atp_writeb_io(p, 1, 0x11, 0x20);
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
@@ -1524,13 +1540,13 @@ flash_ok_885:
 		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
 		atp_is(p, 1, true, atp_readb_io(p, 1, 0x1b) >> 7);
 		atp_writeb_io(p, 1, 0x16, 0x80);
-		k = inb(base_io + 0x28) & 0xcf;
+		k = atp_readb_base(p, 0x28) & 0xcf;
 		k |= 0xc0;
-		outb(k, base_io + 0x28);
-		k = inb(base_io + 0x1f) | 0x80;
-		outb(k, base_io + 0x1f);
-		k = inb(base_io + 0x29) | 0x01;
-		outb(k, base_io + 0x29);
+		atp_writeb_base(p, 0x28, k);
+		k = atp_readb_base(p, 0x1f) | 0x80;
+		atp_writeb_base(p, 0x1f, k);
+		k = atp_readb_base(p, 0x29) | 0x01;
+		atp_writeb_base(p, 0x29, k);
 #ifdef ED_DBGP
 		//printk("atp885: atp_host[0] 0x%p\n", atp_host[0]);
 #endif		
@@ -1554,9 +1570,9 @@ flash_ok_885:
 		atpdev->dev_id = ent->device;
 		host_id &= 0x07;
 		atpdev->host_id[0] = host_id;
-		atpdev->scam_on = inb(base_io + 0x22);
-		atpdev->global_map[0] = inb(base_io + 0x2d);
-		atpdev->ultra_map[0] = inw(base_io + 0x2e);
+		atpdev->scam_on = atp_readb_pci(atpdev, 0, 2);
+		atpdev->global_map[0] = atp_readb_base(atpdev, 0x2d);
+		atpdev->ultra_map[0] = atp_readw_base(atpdev, 0x2e);
 
 		if (atpdev->ultra_map[0] == 0) {
 			atpdev->scam_on = 0x00;
@@ -1583,32 +1599,30 @@ flash_ok_885:
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
-		if (atpdev->chip_ver > 0x07) {	/* check if atp876 chip then enable terminator */
-			outb(0x00, base_io + 0x3e);
-		}
+		if (atpdev->chip_ver > 0x07)	/* check if atp876 chip then enable terminator */
+			atp_writeb_base(p, 0x3e, 0x00);
  
-		k = (inb(base_io + 0x3a) & 0xf3) | 0x10;
-		outb(k, base_io + 0x3a);
-		outb((k & 0xdf), base_io + 0x3a);
+		k = (atp_readb_base(p, 0x3a) & 0xf3) | 0x10;
+		atp_writeb_base(p, 0x3a, k);
+		atp_writeb_base(p, 0x3a, k & 0xdf);
 		mdelay(32);
-		outb(k, base_io + 0x3a);
+		atp_writeb_base(p, 0x3a, k);
 		mdelay(32);
-		outb((host_id | 0x08), base_io + 0);
-		outb(0, base_io + 0x18);
-		while ((inb(base_io + 0x1f) & 0x80) == 0)
+		atp_writeb_io(p, 0, 0, host_id | 0x08);
+		atp_writeb_io(p, 0, 0x18, 0);
+		while ((atp_readb_io(p, 0, 0x1f) & 0x80) == 0)
 			mdelay(1);
 
-		inb(base_io + 0x17);
-		outb(8, base_io + 1);
-		outb(0x7f, base_io + 2);
-		outb(0x20, base_io + 0x11);
+		atp_readb_io(p, 0, 0x17);
+		atp_writeb_io(p, 0, 1, 8);
+		atp_writeb_io(p, 0, 2, 0x7f);
+		atp_writeb_io(p, 0, 0x11, 0x20);
 
 		tscam(shpnt);
-		atp_writeb_io(p, 0, 0x3a, atp_readb_io(p, 0, 0x3a) | 0x10);
+		atp_writeb_base(p, 0x3a, atp_readb_base(p, 0x3a) | 0x10);
 		atp_is(p, 0, p->chip_ver == 4, 0);
-		atp_writeb_io(p, 0, 0x3a, atp_readb_io(p, 0, 0x3a) & 0xef);
-		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
-		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
+		atp_writeb_base(p, 0x3a, atp_readb_base(p, 0x3a) & 0xef);
+		atp_writeb_base(p, 0x3b, atp_readb_base(p, 0x3b) | 0x20);
 		if (atpdev->chip_ver == 4)
 			shpnt->max_id = 16;
 		else		
-- 
Ondrej Zary

