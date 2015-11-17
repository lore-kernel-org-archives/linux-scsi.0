From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 08/52] atp870u: Untangle tmport #6
Date: Tue, 17 Nov 2015 19:23:44 +0100
Message-ID: <1447784668-23713-9-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56419 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  136 +++++++++++++++++-------------------------------
 1 file changed, 49 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 3bf01fc..e398ea5 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -2264,7 +2264,7 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned char k, m, c;
 	unsigned long flags;
-	unsigned int base_io, tmport, error,n;
+	unsigned int base_io, error,n;
 	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
 	struct atp_unit *atpdev, *p;
@@ -2322,12 +2322,9 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		atpdev->dev_id = ent->device;
 		atpdev->host_id[0] = host_id;
 
-		tmport = base_io + 0x22;
-		atpdev->scam_on = inb(tmport);
-		tmport += 0x13;
-		atpdev->global_map[0] = inb(tmport);
-		tmport += 0x07;
-		atpdev->ultra_map[0] = inw(tmport);
+		atpdev->scam_on = inb(base_io + 0x22);
+		atpdev->global_map[0] = inb(base_io + 0x35);
+		atpdev->ultra_map[0] = inw(base_io + 0x3c);
 
 		n = 0x3f09;
 next_fblk_880:
@@ -2402,37 +2399,26 @@ flash_ok_880:
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
-		tmport = base_io + 0x38;
-		k = inb(tmport) & 0x80;
-		outb(k, tmport);
-		tmport += 0x03;
-		outb(0x20, tmport);
+		k = inb(base_io + 0x38) & 0x80;
+		outb(k, base_io + 0x38);
+		outb(0x20, base_io + 0x3b);
 		mdelay(32);
-		outb(0, tmport);
+		outb(0, base_io + 0x3b);
 		mdelay(32);
-		tmport = base_io + 0x5b;
-		inb(tmport);
-		tmport -= 0x04;
-		inb(tmport);
-		tmport = base_io + 0x40;
-		outb((host_id | 0x08), tmport);
-		tmport += 0x18;
-		outb(0, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0)
+		inb(base_io + 0x5b);
+		inb(base_io + 0x57);
+		outb((host_id | 0x08), base_io + 0x40);
+		outb(0, base_io + 0x58);
+		while ((inb(base_io + 0x5f) & 0x80) == 0)
 			mdelay(1);
-		tmport -= 0x08;
-		inb(tmport);
-		tmport = base_io + 0x41;
-		outb(8, tmport++);
-		outb(0x7f, tmport);
-		tmport = base_io + 0x51;
-		outb(0x20, tmport);
+		inb(base_io + 0x57);
+		outb(8, base_io + 0x41);
+		outb(0x7f, base_io + 0x42);
+		outb(0x20, base_io + 0x51);
 
 		tscam(shpnt);
 		is880(p, base_io);
-		tmport = base_io + 0x38;
-		outb(0xb0, tmport);
+		outb(0xb0, base_io + 0x38);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
 		shpnt->unique_id = base_io;
@@ -2546,47 +2532,35 @@ flash_ok_885:
 		inb(base_io + 0x97);
 		inb(base_io + 0xdb);
 		inb(base_io + 0xd7);
-		tmport = base_io + 0x80;
 		k=p->host_id[0];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
 		k |= 0x08;
-		outb(k, tmport);
-		tmport += 0x18;
-		outb(0, tmport);
-		tmport += 0x07;
+		outb(k, base_io + 0x80);
+		outb(0, base_io + 0x98);
 
-		while ((inb(tmport) & 0x80) == 0)
+		while ((inb(base_io + 0x9f) & 0x80) == 0)
 			cpu_relax();
 	
-		tmport -= 0x08;
-		inb(tmport);
-		tmport = base_io + 0x81;
-		outb(8, tmport++);
-		outb(0x7f, tmport);
-		tmport = base_io + 0x91;
-		outb(0x20, tmport);
+		inb(base_io + 0x97);
+		outb(8, base_io + 0x81);
+		outb(0x7f, base_io + 0x82);
+		outb(0x20, base_io + 0x91);
 
-		tmport = base_io + 0xc0;
 		k=p->host_id[1];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
 		k |= 0x08;
-		outb(k, tmport);
-		tmport += 0x18;
-		outb(0, tmport);
-		tmport += 0x07;
+		outb(k, base_io + 0xc0);
+		outb(0, base_io + 0xd8);
 
-		while ((inb(tmport) & 0x80) == 0)
+		while ((inb(base_io + 0xdf) & 0x80) == 0)
 			cpu_relax();
 
-		tmport -= 0x08;
-		inb(tmport);
-		tmport = base_io + 0xc1;
-		outb(8, tmport++);
-		outb(0x7f, tmport);
-		tmport = base_io + 0xd1;
-		outb(0x20, tmport);
+		inb(base_io + 0xd7);
+		outb(8, base_io + 0xc1);
+		outb(0x7f, base_io + 0xc2);
+		outb(0x20, base_io + 0xd1);
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
@@ -2624,11 +2598,9 @@ flash_ok_885:
 		atpdev->dev_id = ent->device;
 		host_id &= 0x07;
 		atpdev->host_id[0] = host_id;
-		tmport = base_io + 0x22;
-		atpdev->scam_on = inb(tmport);
-		tmport += 0x0b;
-		atpdev->global_map[0] = inb(tmport++);
-		atpdev->ultra_map[0] = inw(tmport);
+		atpdev->scam_on = inb(base_io + 0x22);
+		atpdev->global_map[0] = inb(base_io + 0x2d);
+		atpdev->ultra_map[0] = inw(base_io + 0x2e);
 
 		if (atpdev->ultra_map[0] == 0) {
 			atpdev->scam_on = 0x00;
@@ -2656,39 +2628,29 @@ flash_ok_885:
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
 		if (atpdev->chip_ver > 0x07) {	/* check if atp876 chip then enable terminator */
-			tmport = base_io + 0x3e;
-			outb(0x00, tmport);
+			outb(0x00, base_io + 0x3e);
 		}
  
-		tmport = base_io + 0x3a;
-		k = (inb(tmport) & 0xf3) | 0x10;
-		outb(k, tmport);
-		outb((k & 0xdf), tmport);
+		k = (inb(base_io + 0x3a) & 0xf3) | 0x10;
+		outb(k, base_io + 0x3a);
+		outb((k & 0xdf), base_io + 0x3a);
 		mdelay(32);
-		outb(k, tmport);
+		outb(k, base_io + 0x3a);
 		mdelay(32);
-		tmport = base_io;
-		outb((host_id | 0x08), tmport);
-		tmport += 0x18;
-		outb(0, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0)
+		outb((host_id | 0x08), base_io + 0);
+		outb(0, base_io + 0x18);
+		while ((inb(base_io + 0x1f) & 0x80) == 0)
 			mdelay(1);
 
-		tmport -= 0x08;
-		inb(tmport);
-		tmport = base_io + 1;
-		outb(8, tmport++);
-		outb(0x7f, tmport);
-		tmport = base_io + 0x11;
-		outb(0x20, tmport);
+		inb(base_io + 0x17);
+		outb(8, base_io + 1);
+		outb(0x7f, base_io + 2);
+		outb(0x20, base_io + 0x11);
 
 		tscam(shpnt);
 		is870(p, base_io);
-		tmport = base_io + 0x3a;
-		outb((inb(tmport) & 0xef), tmport);
-		tmport++;
-		outb((inb(tmport) | 0x20), tmport);
+		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
+		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
 		if (atpdev->chip_ver == 4)
 			shpnt->max_id = 16;
 		else		
-- 
Ondrej Zary

