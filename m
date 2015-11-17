From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 41/52] atp870u: Improve _probe()
Date: Tue, 17 Nov 2015 19:24:17 +0100
Message-ID: <1447784668-23713-42-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56553 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932580AbbKQShc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:32 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Move scsi_host_alloc() to the top of _probe() to remove code duplication,
*p and unneeded atpdev (de)allocation and copying.
While at it, fix the error paths to return real error codes and also add
missing pci_disble_device() call.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  236 +++++++++++++++++++++++-------------------------
 1 file changed, 113 insertions(+), 123 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 0b349bc..d0119f1 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1248,29 +1248,41 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned int base_io, error,n;
 	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
-	struct atp_unit *atpdev, *p;
+	struct atp_unit *atpdev;
 	unsigned char setupdata[2][16];
+	int err;
 
-	atpdev = kzalloc(sizeof(*atpdev), GFP_KERNEL);
-	if (!atpdev)
-		return -ENOMEM;
-
-	if (pci_enable_device(pdev))
-		goto err_eio;
+	err = pci_enable_device(pdev);
+	if (err)
+		goto fail;
 
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
-		goto err_eio;
+                err = -EIO;
+                goto disable_device;
         }
 
+        err = -ENOMEM;
+	shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
+	if (!shpnt)
+		goto disable_device;
+
+	atpdev = shost_priv(shpnt);
+
+	atpdev->host = shpnt;
+	atpdev->pdev = pdev;
+	pci_set_drvdata(pdev, atpdev);
+
 	/*
 	 * It's probably easier to weed out some revisions like
 	 * this than via the PCI device table
 	 */
 	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
 		atpdev->chip_ver = pdev->revision;
-		if (atpdev->chip_ver < 2)
-			goto err_eio;
+		if (atpdev->chip_ver < 2) {
+			err = -ENODEV;
+			goto unregister;
+		}
 	}
 
 	switch (ent->device) {
@@ -1358,41 +1370,33 @@ flash_ok_880:
 		atpdev->async[0] = ~(atpdev->async[0]);
 		atp_writeb_base(atpdev, 0x35, atpdev->global_map[0]);
  
-		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
-		if (!shpnt)
-			goto err_nomem;
-
-		p = (struct atp_unit *)&shpnt->hostdata;
-
-		atpdev->host = shpnt;
-		atpdev->pdev = pdev;
-		pci_set_drvdata(pdev, p);
-		memcpy(p, atpdev, sizeof(*atpdev));
 		if (atp870u_init_tables(shpnt) < 0) {
 			printk(KERN_ERR "Unable to allocate tables for Acard controller\n");
+			err = -ENOMEM;
 			goto unregister;
 		}
 
-		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt)) {
+		err = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt);
+		if (err) {
  			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
 			goto free_tables;
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
-		k = atp_readb_base(p, 0x38) & 0x80;
-		atp_writeb_base(p, 0x38, k);
-		atp_writeb_base(p, 0x3b, 0x20);
+		k = atp_readb_base(atpdev, 0x38) & 0x80;
+		atp_writeb_base(atpdev, 0x38, k);
+		atp_writeb_base(atpdev, 0x3b, 0x20);
 		mdelay(32);
-		atp_writeb_base(p, 0x3b, 0);
+		atp_writeb_base(atpdev, 0x3b, 0);
 		mdelay(32);
-		atp_readb_io(p, 0, 0x1b);
-		atp_readb_io(p, 0, 0x17);
+		atp_readb_io(atpdev, 0, 0x1b);
+		atp_readb_io(atpdev, 0, 0x17);
 
-		atp_set_host_id(p, 0, host_id);
+		atp_set_host_id(atpdev, 0, host_id);
 
 		tscam(shpnt);
-		atp_is(p, 0, true, atp_readb_base(p, 0x3f) & 0x40);
-		atp_writeb_base(p, 0x38, 0xb0);
+		atp_is(atpdev, 0, true, atp_readb_base(atpdev, 0x3f) & 0x40);
+		atp_writeb_base(atpdev, 0x38, 0xb0);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
 		shpnt->unique_id = base_io;
@@ -1410,50 +1414,43 @@ flash_ok_880:
 		atpdev->pciport[0] = base_io + 0x40;
 		atpdev->pciport[1] = base_io + 0x50;
 				
-		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
-		if (!shpnt)
-			goto err_nomem;
-        	
-		p = (struct atp_unit *)&shpnt->hostdata;
-        	
-		atpdev->host = shpnt;
-		atpdev->pdev = pdev;
-		pci_set_drvdata(pdev, p);
-		memcpy(p, atpdev, sizeof(struct atp_unit));
-		if (atp870u_init_tables(shpnt) < 0)
+		if (atp870u_init_tables(shpnt) < 0) {
+			err = -ENOMEM;
 			goto unregister;
+		}
 			
 #ifdef ED_DBGP		
-	printk("request_irq() shpnt %p hostdata %p\n", shpnt, p);
+	printk("request_irq() shpnt %p hostdata %p\n", shpnt, atpdev);
 #endif	        
-		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt)) {
+		err = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt);
+		if (err) {
 				printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
 			goto free_tables;
 		}
 		
 		spin_lock_irqsave(shpnt->host_lock, flags);        					
         			
-		c = atp_readb_base(p, 0x29);
-		atp_writeb_base(p, 0x29, c | 0x04);
+		c = atp_readb_base(atpdev, 0x29);
+		atp_writeb_base(atpdev, 0x29, c | 0x04);
         	
 		n=0x1f80;
 next_fblk_885:
 		if (n >= 0x2000) {
 		   goto flash_ok_885;
 		}
-		atp_writew_base(p, 0x3c, n);
-		if (atp_readl_base(p, 0x38) == 0xffffffff) {
+		atp_writew_base(atpdev, 0x3c, n);
+		if (atp_readl_base(atpdev, 0x38) == 0xffffffff) {
 		   goto flash_ok_885;
 		}
 		for (m=0; m < 2; m++) {
-		    p->global_map[m]= 0;
+		    atpdev->global_map[m]= 0;
 		    for (k=0; k < 4; k++) {
-			atp_writew_base(p, 0x3c, n++);
-			((unsigned long *)&setupdata[m][0])[k] = atp_readl_base(p, 0x38);
+			atp_writew_base(atpdev, 0x3c, n++);
+			((unsigned long *)&setupdata[m][0])[k] = atp_readl_base(atpdev, 0x38);
 		    }
 		    for (k=0; k < 4; k++) {
-			atp_writew_base(p, 0x3c, n++);
-			((unsigned long *)&p->sp[m][0])[k] = atp_readl_base(p, 0x38);
+			atp_writew_base(atpdev, 0x3c, n++);
+			((unsigned long *)&atpdev->sp[m][0])[k] = atp_readl_base(atpdev, 0x38);
 		    }
 		    n += 8;
 		}
@@ -1462,81 +1459,81 @@ flash_ok_885:
 #ifdef ED_DBGP
 		printk( "Flash Read OK\n");
 #endif	
-		c = atp_readb_base(p, 0x29);
-		atp_writeb_base(p, 0x29, c & 0xfb);
+		c = atp_readb_base(atpdev, 0x29);
+		atp_writeb_base(atpdev, 0x29, c & 0xfb);
 		for (c=0;c < 2;c++) {
-		    p->ultra_map[c]=0;
-		    p->async[c] = 0;
+		    atpdev->ultra_map[c]=0;
+		    atpdev->async[c] = 0;
 		    for (k=0; k < 16; k++) {
 			n=1;
 			n = n << k;
-			if (p->sp[c][k] > 1) {
-			   p->ultra_map[c] |= n;
+			if (atpdev->sp[c][k] > 1) {
+			   atpdev->ultra_map[c] |= n;
 			} else {
-			   if (p->sp[c][k] == 0) {
-			      p->async[c] |= n;
+			   if (atpdev->sp[c][k] == 0) {
+			      atpdev->async[c] |= n;
 			   }
 			}
 		    }
-		    p->async[c] = ~(p->async[c]);
+		    atpdev->async[c] = ~(atpdev->async[c]);
 
-		    if (p->global_map[c] == 0) {
+		    if (atpdev->global_map[c] == 0) {
 		       k=setupdata[c][1];
 		       if ((k & 0x40) != 0)
-			  p->global_map[c] |= 0x20;
+			  atpdev->global_map[c] |= 0x20;
 		       k &= 0x07;
-		       p->global_map[c] |= k;
+		       atpdev->global_map[c] |= k;
 		       if ((setupdata[c][2] & 0x04) != 0)
-			  p->global_map[c] |= 0x08;
-		       p->host_id[c] = setupdata[c][0] & 0x07;
+			  atpdev->global_map[c] |= 0x08;
+		       atpdev->host_id[c] = setupdata[c][0] & 0x07;
 		    }
 		}
 
-		k = atp_readb_base(p, 0x28) & 0x8f;
+		k = atp_readb_base(atpdev, 0x28) & 0x8f;
 		k |= 0x10;
-		atp_writeb_base(p, 0x28, k);
-		atp_writeb_pci(p, 0, 1, 0x80);
-		atp_writeb_pci(p, 1, 1, 0x80);
+		atp_writeb_base(atpdev, 0x28, k);
+		atp_writeb_pci(atpdev, 0, 1, 0x80);
+		atp_writeb_pci(atpdev, 1, 1, 0x80);
 		mdelay(100);
-		atp_writeb_pci(p, 0, 1, 0);
-		atp_writeb_pci(p, 1, 1, 0);
+		atp_writeb_pci(atpdev, 0, 1, 0);
+		atp_writeb_pci(atpdev, 1, 1, 0);
 		mdelay(1000);
-		atp_readb_io(p, 0, 0x1b);
-		atp_readb_io(p, 0, 0x17);
-		atp_readb_io(p, 1, 0x1b);
-		atp_readb_io(p, 1, 0x17);
+		atp_readb_io(atpdev, 0, 0x1b);
+		atp_readb_io(atpdev, 0, 0x17);
+		atp_readb_io(atpdev, 1, 0x1b);
+		atp_readb_io(atpdev, 1, 0x17);
 
-		k=p->host_id[0];
+		k=atpdev->host_id[0];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
-		atp_set_host_id(p, 0, k);
+		atp_set_host_id(atpdev, 0, k);
 
-		k=p->host_id[1];
+		k=atpdev->host_id[1];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
-		atp_set_host_id(p, 1, k);
+		atp_set_host_id(atpdev, 1, k);
 
 		mdelay(600); /* this delay used to be called tscam_885() */
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
-		atp_is(p, 0, true, atp_readb_io(p, 0, 0x1b) >> 7);
-		atp_writeb_io(p, 0, 0x16, 0x80);
+		atp_is(atpdev, 0, true, atp_readb_io(atpdev, 0, 0x1b) >> 7);
+		atp_writeb_io(atpdev, 0, 0x16, 0x80);
 		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
-		atp_is(p, 1, true, atp_readb_io(p, 1, 0x1b) >> 7);
-		atp_writeb_io(p, 1, 0x16, 0x80);
-		k = atp_readb_base(p, 0x28) & 0xcf;
+		atp_is(atpdev, 1, true, atp_readb_io(atpdev, 1, 0x1b) >> 7);
+		atp_writeb_io(atpdev, 1, 0x16, 0x80);
+		k = atp_readb_base(atpdev, 0x28) & 0xcf;
 		k |= 0xc0;
-		atp_writeb_base(p, 0x28, k);
-		k = atp_readb_base(p, 0x1f) | 0x80;
-		atp_writeb_base(p, 0x1f, k);
-		k = atp_readb_base(p, 0x29) | 0x01;
-		atp_writeb_base(p, 0x29, k);
+		atp_writeb_base(atpdev, 0x28, k);
+		k = atp_readb_base(atpdev, 0x1f) | 0x80;
+		atp_writeb_base(atpdev, 0x1f, k);
+		k = atp_readb_base(atpdev, 0x29) | 0x01;
+		atp_writeb_base(atpdev, 0x29, k);
 #ifdef ED_DBGP
 		//printk("atp885: atp_host[0] 0x%p\n", atp_host[0]);
 #endif		
 		shpnt->max_id = 16;
-		shpnt->max_lun = (p->global_map[0] & 0x07) + 1;
+		shpnt->max_lun = (atpdev->global_map[0] & 0x07) + 1;
 		shpnt->max_channel = 1;
-		shpnt->this_id = p->host_id[0];
+		shpnt->this_id = atpdev->host_id[0];
 		shpnt->unique_id = base_io;
 		shpnt->io_port = base_io;
 		shpnt->n_io_port = 0xff;	/* Number of bytes of I/O space used */
@@ -1563,41 +1560,35 @@ flash_ok_885:
 			atpdev->ultra_map[0] = 0xffff;
 		}
 
-		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
-		if (!shpnt)
-			goto err_nomem;
 
-		p = (struct atp_unit *)&shpnt->hostdata;
-		
-		atpdev->host = shpnt;
-		atpdev->pdev = pdev;
-		pci_set_drvdata(pdev, p);
-		memcpy(p, atpdev, sizeof(*atpdev));
-		if (atp870u_init_tables(shpnt) < 0)
+		if (atp870u_init_tables(shpnt) < 0) {
+			err = -ENOMEM;
 			goto unregister;
+		}
 
-		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt)) {
+		err = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt);
+		if (err) {
 			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
 			goto free_tables;
 		}
 
 		spin_lock_irqsave(shpnt->host_lock, flags);
 		if (atpdev->chip_ver > 0x07)	/* check if atp876 chip then enable terminator */
-			atp_writeb_base(p, 0x3e, 0x00);
+			atp_writeb_base(atpdev, 0x3e, 0x00);
  
-		k = (atp_readb_base(p, 0x3a) & 0xf3) | 0x10;
-		atp_writeb_base(p, 0x3a, k);
-		atp_writeb_base(p, 0x3a, k & 0xdf);
+		k = (atp_readb_base(atpdev, 0x3a) & 0xf3) | 0x10;
+		atp_writeb_base(atpdev, 0x3a, k);
+		atp_writeb_base(atpdev, 0x3a, k & 0xdf);
 		mdelay(32);
-		atp_writeb_base(p, 0x3a, k);
+		atp_writeb_base(atpdev, 0x3a, k);
 		mdelay(32);
-		atp_set_host_id(p, 0, host_id);
+		atp_set_host_id(atpdev, 0, host_id);
 
 		tscam(shpnt);
-		atp_writeb_base(p, 0x3a, atp_readb_base(p, 0x3a) | 0x10);
-		atp_is(p, 0, p->chip_ver == 4, 0);
-		atp_writeb_base(p, 0x3a, atp_readb_base(p, 0x3a) & 0xef);
-		atp_writeb_base(p, 0x3b, atp_readb_base(p, 0x3b) | 0x20);
+		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) | 0x10);
+		atp_is(atpdev, 0, atpdev->chip_ver == 4, 0);
+		atp_writeb_base(atpdev, 0x3a, atp_readb_base(atpdev, 0x3a) & 0xef);
+		atp_writeb_base(atpdev, 0x3b, atp_readb_base(atpdev, 0x3b) | 0x20);
 		if (atpdev->chip_ver == 4)
 			shpnt->max_id = 16;
 		else		
@@ -1609,9 +1600,12 @@ flash_ok_885:
 		shpnt->irq = pdev->irq;		
 	} 
 		spin_unlock_irqrestore(shpnt->host_lock, flags);
-		if (!request_region(base_io, shpnt->n_io_port, "atp870u"))
+		if (!request_region(base_io, shpnt->n_io_port, "atp870u")) {
+			err = -EBUSY;
 			goto request_io_fail;
-		if (scsi_add_host(shpnt, &pdev->dev))
+		}
+		err = scsi_add_host(shpnt, &pdev->dev);
+		if (err)
 			goto scsi_add_fail;
 		scsi_scan_host(shpnt);
 #ifdef ED_DBGP			
@@ -1629,15 +1623,11 @@ free_tables:
 	printk("atp870u_prob:free_table\n");
 	atp870u_free_tables(shpnt);
 unregister:
-	printk("atp870u_prob:unregister\n");
 	scsi_host_put(shpnt);
-	return -1;		
-err_eio:
-	kfree(atpdev);
-	return -EIO;
-err_nomem:
-	kfree(atpdev);
-	return -ENOMEM;
+disable_device:
+	pci_disable_device(pdev);
+fail:
+	return err;
 }
 
 /* The abort command does not leave the device in a clean state where
-- 
Ondrej Zary

