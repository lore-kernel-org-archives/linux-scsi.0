From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 44/52] atp870u: Simplify _probe()
Date: Tue, 17 Nov 2015 19:24:20 +0100
Message-ID: <1447784668-23713-45-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56517 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbbKQSgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:41 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Move shpnt common code to the top, remove base_io, use pci_resource_len.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   65 +++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index f92eb00..8af51a9 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1245,7 +1245,7 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned char k, m, c;
 	unsigned long flags;
-	unsigned int base_io, error,n;
+	unsigned int error,n;
 	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
 	struct atp_unit *atpdev;
@@ -1278,21 +1278,24 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	atpdev->pdev = pdev;
 	pci_set_drvdata(pdev, atpdev);
 
-	base_io = pci_resource_start(pdev, 0);
-	base_io &= 0xfffffff8;
-	atpdev->baseport = base_io;
+	shpnt->io_port = pci_resource_start(pdev, 0);
+	shpnt->io_port &= 0xfffffff8;
+	shpnt->n_io_port = pci_resource_len(pdev, 0);
+	atpdev->baseport = shpnt->io_port;
+	shpnt->unique_id = shpnt->io_port;
+	shpnt->irq = pdev->irq;
 
 	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
-		atpdev->ioport[0] = base_io + 0x40;
-		atpdev->pciport[0] = base_io + 0x28;
+		atpdev->ioport[0] = shpnt->io_port + 0x40;
+		atpdev->pciport[0] = shpnt->io_port + 0x28;
 
 		host_id = atp_readb_base(atpdev, 0x39);
 		host_id >>= 0x04;
 
 		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter:"
-			"    IO:%x, IRQ:%d.\n", base_io, pdev->irq);
+			"    IO:%lx, IRQ:%d.\n", shpnt->io_port, shpnt->irq);
 		atpdev->dev_id = ent->device;
 		atpdev->host_id[0] = host_id;
 
@@ -1358,9 +1361,9 @@ flash_ok_880:
 			goto unregister;
 		}
 
-		err = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt);
+		err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt);
 		if (err) {
- 			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
+			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", shpnt->irq);
 			goto free_tables;
 		}
 
@@ -1381,20 +1384,16 @@ flash_ok_880:
 		atp_writeb_base(atpdev, 0x38, 0xb0);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
-		shpnt->unique_id = base_io;
-		shpnt->io_port = base_io;
-		shpnt->n_io_port = 0x60;	/* Number of bytes of I/O space used */
-		shpnt->irq = pdev->irq;			
 	} else if (ent->device == ATP885_DEVID) {	
-			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%x, IRQ:%d.\n"
-			       , base_io, pdev->irq);
+			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%lx, IRQ:%d.\n"
+			       , shpnt->io_port, shpnt->irq);
         	
 		atpdev->pdev = pdev;
 		atpdev->dev_id  = ent->device;
-		atpdev->ioport[0] = base_io + 0x80;
-		atpdev->ioport[1] = base_io + 0xc0;
-		atpdev->pciport[0] = base_io + 0x40;
-		atpdev->pciport[1] = base_io + 0x50;
+		atpdev->ioport[0] = shpnt->io_port + 0x80;
+		atpdev->ioport[1] = shpnt->io_port + 0xc0;
+		atpdev->pciport[0] = shpnt->io_port + 0x40;
+		atpdev->pciport[1] = shpnt->io_port + 0x50;
 				
 		if (atp870u_init_tables(shpnt) < 0) {
 			err = -ENOMEM;
@@ -1404,7 +1403,7 @@ flash_ok_880:
 #ifdef ED_DBGP		
 	printk("request_irq() shpnt %p hostdata %p\n", shpnt, atpdev);
 #endif	        
-		err = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt);
+		err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt);
 		if (err) {
 				printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
 			goto free_tables;
@@ -1516,11 +1515,6 @@ flash_ok_885:
 		shpnt->max_lun = (atpdev->global_map[0] & 0x07) + 1;
 		shpnt->max_channel = 1;
 		shpnt->this_id = atpdev->host_id[0];
-		shpnt->unique_id = base_io;
-		shpnt->io_port = base_io;
-		shpnt->n_io_port = 0xff;	/* Number of bytes of I/O space used */
-		shpnt->irq = pdev->irq;
-				
 	} else {
 		bool wide_chip =
 			(ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 &&
@@ -1530,10 +1524,10 @@ flash_ok_885:
 		error = pci_read_config_byte(pdev, 0x49, &host_id);
 
 		printk(KERN_INFO "   ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: "
-			"IO:%x, IRQ:%d.\n", base_io, pdev->irq);
+			"IO:%lx, IRQ:%d.\n", shpnt->io_port, shpnt->irq);
 
-		atpdev->ioport[0] = base_io;
-		atpdev->pciport[0] = base_io + 0x20;
+		atpdev->ioport[0] = shpnt->io_port;
+		atpdev->pciport[0] = shpnt->io_port + 0x20;
 		atpdev->dev_id = ent->device;
 		host_id &= 0x07;
 		atpdev->host_id[0] = host_id;
@@ -1553,9 +1547,9 @@ flash_ok_885:
 			goto unregister;
 		}
 
-		err = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt);
+		err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt);
 		if (err) {
-			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
+			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", shpnt->irq);
 			goto free_tables;
 		}
 
@@ -1579,13 +1573,10 @@ flash_ok_885:
 		atp_writeb_base(atpdev, 0x3b, atp_readb_base(atpdev, 0x3b) | 0x20);
 		shpnt->max_id = wide_chip ? 16 : 8;
 		shpnt->this_id = host_id;
-		shpnt->unique_id = base_io;
-		shpnt->io_port = base_io;
-		shpnt->n_io_port = 0x40;	/* Number of bytes of I/O space used */
-		shpnt->irq = pdev->irq;		
+
 	} 
 		spin_unlock_irqrestore(shpnt->host_lock, flags);
-		if (!request_region(base_io, shpnt->n_io_port, "atp870u")) {
+		if (!request_region(shpnt->io_port, shpnt->n_io_port, "atp870u")) {
 			err = -EBUSY;
 			goto request_io_fail;
 		}
@@ -1600,10 +1591,10 @@ flash_ok_885:
 
 scsi_add_fail:
 	printk("atp870u_prob:scsi_add_fail\n");
-	release_region(base_io, shpnt->n_io_port);
+	release_region(shpnt->io_port, shpnt->n_io_port);
 request_io_fail:
 	printk("atp870u_prob:request_io_fail\n");
-	free_irq(pdev->irq, shpnt);
+	free_irq(shpnt->irq, shpnt);
 free_tables:
 	printk("atp870u_prob:free_table\n");
 	atp870u_free_tables(shpnt);
-- 
Ondrej Zary

