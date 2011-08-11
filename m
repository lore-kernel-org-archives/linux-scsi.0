From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/9] drivers/scsi/atp870u.c: add missing kfree
Date: Thu, 11 Aug 2011 13:36:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1108111335490.18938@ask.diku.dk>
References: <1312802283-9107-1-git-send-email-julia@diku.dk>
 <20110808181238.GB7659@shale.localdomain> <Pine.LNX.4.64.1108082036451.12465@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1108082036451.12465@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Atpdev is only used as a local buffer, so it should be freed in both the
normal exist case and in all error handling code.

The initial comment is also incorrect - non-zero is returned on failure.

-1 is no longer used as an error return value, and is replaced by a value
that is somehow related to the cause of the error.  -EBUSY is used in the
case of the failure of request_region.

This patch also includes a lot of cleanups to satisfy checkpatch.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression x;
statement S,S1;
expression E;
identifier fl;
expression *ptr != NULL;
@@

x = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...kfree(x)...+> }
     when any
     when != true x == NULL
x->fl
...>
(
if (x == NULL) S1
|
if (...) { ... when != x
               when forall
(
 return \(0\|<+...x...+>\|ptr\);
|
* return ...;
)
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
As compared to the previous version, -1 is no longer used as a return value
and some missing braces have been added.

 drivers/scsi/atp870u.c |  126 +++++++++++++++++++++++++++++--------------------
 1 file changed, 76 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7e6eca4..99b1da1 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -2552,7 +2552,7 @@ static int atp870u_init_tables(struct Scsi_Host *host)
 	return 0;
 }
 
-/* return non-zero on detection */
+/* return zero on detection */
 static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned char k, m, c;
@@ -2563,19 +2563,23 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct atp_unit *atpdev, *p;
 	unsigned char setupdata[2][16];
 	int count = 0;
+	int ret = 0;
 
 	atpdev = kzalloc(sizeof(*atpdev), GFP_KERNEL);
 	if (!atpdev)
 		return -ENOMEM;
 
-	if (pci_enable_device(pdev))
-		goto err_eio;
+	if (pci_enable_device(pdev)) {
+		ret = -EIO;
+		goto out;
+	}
 
         if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
                 printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
         } else {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
-		goto err_eio;
+		ret = -EIO;
+		goto out;
         }
 
 	/*
@@ -2584,8 +2588,10 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
 		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
-		if (atpdev->chip_ver < 2)
-			goto err_eio;
+		if (atpdev->chip_ver < 2) {
+			ret = -EIO;
+			goto out;
+		}
 	}
 
 	switch (ent->device) {
@@ -2675,8 +2681,10 @@ flash_ok_880:
 		outb(atpdev->global_map[0], base_io + 0x35);
  
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
-		if (!shpnt)
-			goto err_nomem;
+		if (!shpnt) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		p = (struct atp_unit *)&shpnt->hostdata;
 
@@ -2684,12 +2692,15 @@ flash_ok_880:
 		atpdev->pdev = pdev;
 		pci_set_drvdata(pdev, p);
 		memcpy(p, atpdev, sizeof(*atpdev));
-		if (atp870u_init_tables(shpnt) < 0) {
+		ret = atp870u_init_tables(shpnt);
+		if (ret < 0) {
 			printk(KERN_ERR "Unable to allocate tables for Acard controller\n");
 			goto unregister;
 		}
 
-		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt)) {
+		ret = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED,
+				  "atp880i", shpnt);
+		if (ret) {
  			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
 			goto free_tables;
 		}
@@ -2745,8 +2756,10 @@ flash_ok_880:
 		atpdev->pciport[1] = base_io + 0x50;
 				
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
-		if (!shpnt)
-			goto err_nomem;
+		if (!shpnt) {
+			ret = -ENOMEM;
+			goto out;
+		}
         	
 		p = (struct atp_unit *)&shpnt->hostdata;
         	
@@ -2754,14 +2767,17 @@ flash_ok_880:
 		atpdev->pdev = pdev;
 		pci_set_drvdata(pdev, p);
 		memcpy(p, atpdev, sizeof(struct atp_unit));
-		if (atp870u_init_tables(shpnt) < 0)
+		ret = atp870u_init_tables(shpnt);
+		if (ret < 0)
 			goto unregister;
 			
 #ifdef ED_DBGP		
-	printk("request_irq() shpnt %p hostdata %p\n", shpnt, p);
+		printk("request_irq() shpnt %p hostdata %p\n", shpnt, p);
 #endif	        
-		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt)) {
-				printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
+		ret = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED,
+				  "atp870u", shpnt);
+		if (ret) {
+			printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
 			goto free_tables;
 		}
 		
@@ -2772,13 +2788,11 @@ flash_ok_880:
         	
 		n=0x1f80;
 next_fblk_885:
-		if (n >= 0x2000) {
-		   goto flash_ok_885;
-		}
+		if (n >= 0x2000)
+			goto flash_ok_885;
 		outw(n,base_io + 0x3c);
-		if (inl(base_io + 0x38) == 0xffffffff) {
-		   goto flash_ok_885;
-		}
+		if (inl(base_io + 0x38) == 0xffffffff)
+			goto flash_ok_885;
 		for (m=0; m < 2; m++) {
 		    p->global_map[m]= 0;
 		    for (k=0; k < 4; k++) {
@@ -2930,8 +2944,10 @@ flash_ok_885:
 		}
 
 		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
-		if (!shpnt)
-			goto err_nomem;
+		if (!shpnt) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		p = (struct atp_unit *)&shpnt->hostdata;
 		
@@ -2939,10 +2955,13 @@ flash_ok_885:
 		atpdev->pdev = pdev;
 		pci_set_drvdata(pdev, p);
 		memcpy(p, atpdev, sizeof(*atpdev));
-		if (atp870u_init_tables(shpnt) < 0)
+		ret = atp870u_init_tables(shpnt);
+		if (ret < 0)
 			goto unregister;
 
-		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt)) {
+		ret = request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED,
+				  "atp870i", shpnt);
+		if (ret) {
 			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
 			goto free_tables;
 		}
@@ -2991,26 +3010,37 @@ flash_ok_885:
 		shpnt->io_port = base_io;
 		shpnt->n_io_port = 0x40;	/* Number of bytes of I/O space used */
 		shpnt->irq = pdev->irq;		
-	} 
-		spin_unlock_irqrestore(shpnt->host_lock, flags);
-		if(ent->device==ATP885_DEVID) {
-			if(!request_region(base_io, 0xff, "atp870u")) /* Register the IO ports that we use */
-				goto request_io_fail;
-		} else if((ent->device==ATP880_DEVID1)||(ent->device==ATP880_DEVID2)) {
-			if(!request_region(base_io, 0x60, "atp870u")) /* Register the IO ports that we use */
-				goto request_io_fail;
-		} else {
-			if(!request_region(base_io, 0x40, "atp870u")) /* Register the IO ports that we use */
-				goto request_io_fail;
-		}				
-		count++;
-		if (scsi_add_host(shpnt, &pdev->dev))
-			goto scsi_add_fail;
-		scsi_scan_host(shpnt);
+	}
+	spin_unlock_irqrestore(shpnt->host_lock, flags);
+	if (ent->device == ATP885_DEVID) {
+		/* Register the IO ports that we use */
+		if (!request_region(base_io, 0xff, "atp870u")) {
+			ret = -EBUSY;
+			goto request_io_fail;
+		}
+	} else if ((ent->device == ATP880_DEVID1) ||
+		   (ent->device == ATP880_DEVID2)) {
+		/* Register the IO ports that we use */
+		if (!request_region(base_io, 0x60, "atp870u")) {
+			ret = -EBUSY;
+			goto request_io_fail;
+		}
+	} else {
+		/* Register the IO ports that we use */
+		if (!request_region(base_io, 0x40, "atp870u")) {
+			ret = -EBUSY;
+			goto request_io_fail;
+		}
+	}
+	count++;
+	ret = scsi_add_host(shpnt, &pdev->dev);
+	if (ret)
+		goto scsi_add_fail;
+	scsi_scan_host(shpnt);
 #ifdef ED_DBGP			
-		printk("atp870u_prob : exit\n");
+	printk(KERN_DEBUG "atp870u_prob : exit\n");
 #endif		
-		return 0;
+	goto out;
 
 scsi_add_fail:
 	printk("atp870u_prob:scsi_add_fail\n");
@@ -3030,13 +3060,9 @@ free_tables:
 unregister:
 	printk("atp870u_prob:unregister\n");
 	scsi_host_put(shpnt);
-	return -1;		
-err_eio:
-	kfree(atpdev);
-	return -EIO;
-err_nomem:
+out:
 	kfree(atpdev);
-	return -ENOMEM;
+	return ret;
 }
 
 /* The abort command does not leave the device in a clean state where
