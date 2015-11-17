From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 47/52] atp870u: Request IRQ later, remove weird locking
Date: Tue, 17 Nov 2015 19:24:23 +0100
Message-ID: <1447784668-23713-48-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56559 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbbKQShn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:43 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Allocate IRQ later during probe to avoid code duplication and also remove
the need for weird locking in _probe.
(It was probably there to prevent race with the IRQ handler?)

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   47 ++++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 87dd886..4719df4 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1253,7 +1253,6 @@ static void atp_set_host_id(struct atp_unit *atp, u8 c, u8 host_id)
 static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned char k, m, c;
-	unsigned long flags;
 	unsigned int error,n;
 	unsigned char host_id;
 	struct Scsi_Host *shpnt = NULL;
@@ -1374,13 +1373,6 @@ flash_ok_880:
 			goto unregister;
 		}
 
-		err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt);
-		if (err) {
-			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", shpnt->irq);
-			goto free_tables;
-		}
-
-		spin_lock_irqsave(shpnt->host_lock, flags);
 		k = atp_readb_base(atpdev, 0x38) & 0x80;
 		atp_writeb_base(atpdev, 0x38, k);
 		atp_writeb_base(atpdev, 0x3b, 0x20);
@@ -1412,17 +1404,6 @@ flash_ok_880:
 			goto unregister;
 		}
 			
-#ifdef ED_DBGP		
-	printk("request_irq() shpnt %p hostdata %p\n", shpnt, atpdev);
-#endif	        
-		err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt);
-		if (err) {
-				printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
-			goto free_tables;
-		}
-		
-		spin_lock_irqsave(shpnt->host_lock, flags);        					
-        			
 		c = atp_readb_base(atpdev, 0x29);
 		atp_writeb_base(atpdev, 0x29, c | 0x04);
         	
@@ -1558,13 +1539,6 @@ flash_ok_885:
 			goto unregister;
 		}
 
-		err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt);
-		if (err) {
-			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", shpnt->irq);
-			goto free_tables;
-		}
-
-		spin_lock_irqsave(shpnt->host_lock, flags);
 		if (pdev->revision > 0x07)	/* check if atp876 chip then enable terminator */
 			atp_writeb_base(atpdev, 0x3e, 0x00);
  
@@ -1586,15 +1560,18 @@ flash_ok_885:
 		shpnt->this_id = host_id;
 
 	} 
-		spin_unlock_irqrestore(shpnt->host_lock, flags);
-		err = scsi_add_host(shpnt, &pdev->dev);
-		if (err)
-			goto scsi_add_fail;
-		scsi_scan_host(shpnt);
-#ifdef ED_DBGP			
-		printk("atp870u_prob : exit\n");
-#endif		
-		return 0;
+	err = request_irq(shpnt->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to allocate IRQ %d.\n", shpnt->irq);
+		goto free_tables;
+	}
+
+	err = scsi_add_host(shpnt, &pdev->dev);
+	if (err)
+		goto scsi_add_fail;
+	scsi_scan_host(shpnt);
+
+	return 0;
 
 scsi_add_fail:
 	free_irq(shpnt->irq, shpnt);
-- 
Ondrej Zary

