From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] scsi/atp870u: reduce huge stack usage
Date: Tue, 27 Jun 2006 22:01:28 -0700
Message-ID: <20060627220128.40fc3df8.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:58840 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1423146AbWF1E6m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 00:58:42 -0400
Received: from midway.site ([71.245.108.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 21:58:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <rdunlap@xenotime.net>

The atp870u driver is the largest stack eater reported by checkstack
(on x86_864, allmodconfig).  This converts the offending function
to kmalloc+kfree struct atp_unit instead of allocating it on the stack.
Was:
0x0000164c atp870u_probe [atp870u]:			3176
Now:
0x0000164c atp870u_probe [atp870u]:			408

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/atp870u.c |  157 +++++++++++++++++++++++++------------------------
 1 files changed, 83 insertions(+), 74 deletions(-)

--- linux-2617-g12.orig/drivers/scsi/atp870u.c
+++ linux-2617-g12/drivers/scsi/atp870u.c
@@ -2625,29 +2625,32 @@ static int atp870u_probe(struct pci_dev 
 	unsigned int base_io, tmport, error,n;
 	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
-	struct atp_unit atp_dev, *p;
+	struct atp_unit *atpdev, *p;
 	unsigned char setupdata[2][16];
 	int count = 0;
-	
+
+	atpdev = kzalloc(sizeof(*atpdev), GFP_KERNEL);
+	if (!atpdev)
+		return -ENOMEM;
+
 	if (pci_enable_device(pdev))
-		return -EIO;
+		goto err_eio;
 
         if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
                 printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
         } else {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
-                return -EIO;
+		goto err_eio;
         }
 
-	memset(&atp_dev, 0, sizeof atp_dev);
 	/*
 	 * It's probably easier to weed out some revisions like
 	 * this than via the PCI device table
 	 */
 	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
-		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atp_dev.chip_ver);
-		if (atp_dev.chip_ver < 2)
-			return -EIO;
+		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
+		if (atpdev->chip_ver < 2)
+			goto err_eio;
 	}
 
 	switch (ent->device) {
@@ -2656,15 +2659,15 @@ static int atp870u_probe(struct pci_dev 
 	case ATP880_DEVID1:	
 	case ATP880_DEVID2:	
 	case ATP885_DEVID:	
-		atp_dev.chip_ver = 0x04;
+		atpdev->chip_ver = 0x04;
 	default:
 		break;
 	}
 	base_io = pci_resource_start(pdev, 0);
 	base_io &= 0xfffffff8;
-	
+
 	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
-		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atp_dev.chip_ver);
+		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
 		host_id = inb(base_io + 0x39);
@@ -2672,17 +2675,17 @@ static int atp870u_probe(struct pci_dev 
 
 		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter: %d"
 			"    IO:%x, IRQ:%d.\n", count, base_io, pdev->irq);
-		atp_dev.ioport[0] = base_io + 0x40;
-		atp_dev.pciport[0] = base_io + 0x28;
-		atp_dev.dev_id = ent->device;
-		atp_dev.host_id[0] = host_id;
+		atpdev->ioport[0] = base_io + 0x40;
+		atpdev->pciport[0] = base_io + 0x28;
+		atpdev->dev_id = ent->device;
+		atpdev->host_id[0] = host_id;
 
 		tmport = base_io + 0x22;
-		atp_dev.scam_on = inb(tmport);
+		atpdev->scam_on = inb(tmport);
 		tmport += 0x13;
-		atp_dev.global_map[0] = inb(tmport);
+		atpdev->global_map[0] = inb(tmport);
 		tmport += 0x07;
-		atp_dev.ultra_map[0] = inw(tmport);
+		atpdev->ultra_map[0] = inw(tmport);
 
 		n = 0x3f09;
 next_fblk_880:
@@ -2695,57 +2698,57 @@ next_fblk_880:
 		if (inb(base_io + 0x30) == 0xff)
 			goto flash_ok_880;
 
-		atp_dev.sp[0][m++] = inb(base_io + 0x30);
-		atp_dev.sp[0][m++] = inb(base_io + 0x31);
-		atp_dev.sp[0][m++] = inb(base_io + 0x32);
-		atp_dev.sp[0][m++] = inb(base_io + 0x33);
+		atpdev->sp[0][m++] = inb(base_io + 0x30);
+		atpdev->sp[0][m++] = inb(base_io + 0x31);
+		atpdev->sp[0][m++] = inb(base_io + 0x32);
+		atpdev->sp[0][m++] = inb(base_io + 0x33);
 		outw(n, base_io + 0x34);
 		n += 0x0002;
-		atp_dev.sp[0][m++] = inb(base_io + 0x30);
-		atp_dev.sp[0][m++] = inb(base_io + 0x31);
-		atp_dev.sp[0][m++] = inb(base_io + 0x32);
-		atp_dev.sp[0][m++] = inb(base_io + 0x33);
+		atpdev->sp[0][m++] = inb(base_io + 0x30);
+		atpdev->sp[0][m++] = inb(base_io + 0x31);
+		atpdev->sp[0][m++] = inb(base_io + 0x32);
+		atpdev->sp[0][m++] = inb(base_io + 0x33);
 		outw(n, base_io + 0x34);
 		n += 0x0002;
-		atp_dev.sp[0][m++] = inb(base_io + 0x30);
-		atp_dev.sp[0][m++] = inb(base_io + 0x31);
-		atp_dev.sp[0][m++] = inb(base_io + 0x32);
-		atp_dev.sp[0][m++] = inb(base_io + 0x33);
+		atpdev->sp[0][m++] = inb(base_io + 0x30);
+		atpdev->sp[0][m++] = inb(base_io + 0x31);
+		atpdev->sp[0][m++] = inb(base_io + 0x32);
+		atpdev->sp[0][m++] = inb(base_io + 0x33);
 		outw(n, base_io + 0x34);
 		n += 0x0002;
-		atp_dev.sp[0][m++] = inb(base_io + 0x30);
-		atp_dev.sp[0][m++] = inb(base_io + 0x31);
-		atp_dev.sp[0][m++] = inb(base_io + 0x32);
-		atp_dev.sp[0][m++] = inb(base_io + 0x33);
+		atpdev->sp[0][m++] = inb(base_io + 0x30);
+		atpdev->sp[0][m++] = inb(base_io + 0x31);
+		atpdev->sp[0][m++] = inb(base_io + 0x32);
+		atpdev->sp[0][m++] = inb(base_io + 0x33);
 		n += 0x0018;
 		goto next_fblk_880;
 flash_ok_880:
 		outw(0, base_io + 0x34);
-		atp_dev.ultra_map[0] = 0;
-		atp_dev.async[0] = 0;
+		atpdev->ultra_map[0] = 0;
+		atpdev->async[0] = 0;
 		for (k = 0; k < 16; k++) {
 			n = 1;
 			n = n << k;
-			if (atp_dev.sp[0][k] > 1) {
-				atp_dev.ultra_map[0] |= n;
+			if (atpdev->sp[0][k] > 1) {
+				atpdev->ultra_map[0] |= n;
 			} else {
-				if (atp_dev.sp[0][k] == 0)
-					atp_dev.async[0] |= n;
+				if (atpdev->sp[0][k] == 0)
+					atpdev->async[0] |= n;
  			}
 	 	}
-		atp_dev.async[0] = ~(atp_dev.async[0]);
-		outb(atp_dev.global_map[0], base_io + 0x35);
+		atpdev->async[0] = ~(atpdev->async[0]);
+		outb(atpdev->global_map[0], base_io + 0x35);
  
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
 		if (!shpnt)
-			return -ENOMEM;
+			goto err_nomem;
 
 		p = (struct atp_unit *)&shpnt->hostdata;
 
-		atp_dev.host = shpnt;
-		atp_dev.pdev = pdev;
+		atpdev->host = shpnt;
+		atpdev->pdev = pdev;
 		pci_set_drvdata(pdev, p);
-		memcpy(p, &atp_dev, sizeof atp_dev);
+		memcpy(p, atpdev, sizeof(*atpdev));
 		if (atp870u_init_tables(shpnt) < 0) {
 			printk(KERN_ERR "Unable to allocate tables for Acard controller\n");
 			goto unregister;
@@ -2798,24 +2801,24 @@ flash_ok_880:
 			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%x, IRQ:%d.\n"
 			       , base_io, pdev->irq);
         	
-		atp_dev.pdev = pdev;	
-		atp_dev.dev_id  = ent->device;
-		atp_dev.baseport = base_io;
-		atp_dev.ioport[0] = base_io + 0x80;
-		atp_dev.ioport[1] = base_io + 0xc0;
-		atp_dev.pciport[0] = base_io + 0x40;
-		atp_dev.pciport[1] = base_io + 0x50;
+		atpdev->pdev = pdev;
+		atpdev->dev_id  = ent->device;
+		atpdev->baseport = base_io;
+		atpdev->ioport[0] = base_io + 0x80;
+		atpdev->ioport[1] = base_io + 0xc0;
+		atpdev->pciport[0] = base_io + 0x40;
+		atpdev->pciport[1] = base_io + 0x50;
 				
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
 		if (!shpnt)
-			return -ENOMEM;
+			goto err_nomem;
         	
 		p = (struct atp_unit *)&shpnt->hostdata;
         	
-		atp_dev.host = shpnt;
-		atp_dev.pdev = pdev;
+		atpdev->host = shpnt;
+		atpdev->pdev = pdev;
 		pci_set_drvdata(pdev, p);
-		memcpy(p, &atp_dev, sizeof(struct atp_unit));
+		memcpy(p, atpdev, sizeof(struct atp_unit));
 		if (atp870u_init_tables(shpnt) < 0)
 			goto unregister;
 			
@@ -2974,33 +2977,33 @@ flash_ok_885:
 		printk(KERN_INFO "   ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: %d "
 			"IO:%x, IRQ:%d.\n", count, base_io, pdev->irq);
 
-		atp_dev.ioport[0] = base_io;
-		atp_dev.pciport[0] = base_io + 0x20;
-		atp_dev.dev_id = ent->device;
+		atpdev->ioport[0] = base_io;
+		atpdev->pciport[0] = base_io + 0x20;
+		atpdev->dev_id = ent->device;
 		host_id &= 0x07;
-		atp_dev.host_id[0] = host_id;
+		atpdev->host_id[0] = host_id;
 		tmport = base_io + 0x22;
-		atp_dev.scam_on = inb(tmport);
+		atpdev->scam_on = inb(tmport);
 		tmport += 0x0b;
-		atp_dev.global_map[0] = inb(tmport++);
-		atp_dev.ultra_map[0] = inw(tmport);
+		atpdev->global_map[0] = inb(tmport++);
+		atpdev->ultra_map[0] = inw(tmport);
 
-		if (atp_dev.ultra_map[0] == 0) {
-			atp_dev.scam_on = 0x00;
-			atp_dev.global_map[0] = 0x20;
-			atp_dev.ultra_map[0] = 0xffff;
+		if (atpdev->ultra_map[0] == 0) {
+			atpdev->scam_on = 0x00;
+			atpdev->global_map[0] = 0x20;
+			atpdev->ultra_map[0] = 0xffff;
 		}
 
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
 		if (!shpnt)
-			return -ENOMEM;
+			goto err_nomem;
 
 		p = (struct atp_unit *)&shpnt->hostdata;
 		
-		atp_dev.host = shpnt;
-		atp_dev.pdev = pdev;
+		atpdev->host = shpnt;
+		atpdev->pdev = pdev;
 		pci_set_drvdata(pdev, p);
-		memcpy(p, &atp_dev, sizeof atp_dev);
+		memcpy(p, atpdev, sizeof(*atpdev));
 		if (atp870u_init_tables(shpnt) < 0)
 			goto unregister;
 
@@ -3010,7 +3013,7 @@ flash_ok_885:
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
-		if (atp_dev.chip_ver > 0x07) {	/* check if atp876 chip then enable terminator */
+		if (atpdev->chip_ver > 0x07) {	/* check if atp876 chip then enable terminator */
 			tmport = base_io + 0x3e;
 			outb(0x00, tmport);
 		}
@@ -3044,7 +3047,7 @@ flash_ok_885:
 		outb((inb(tmport) & 0xef), tmport);
 		tmport++;
 		outb((inb(tmport) | 0x20), tmport);
-		if (atp_dev.chip_ver == 4)
+		if (atpdev->chip_ver == 4)
 			shpnt->max_id = 16;
 		else		
 			shpnt->max_id = 8;
@@ -3093,6 +3096,12 @@ unregister:
 	printk("atp870u_prob:unregister\n");
 	scsi_host_put(shpnt);
 	return -1;		
+err_eio:
+	kfree(atpdev);
+	return -EIO;
+err_nomem:
+	kfree(atpdev);
+	return -ENOMEM;
 }
 
 /* The abort command does not leave the device in a clean state where


---
