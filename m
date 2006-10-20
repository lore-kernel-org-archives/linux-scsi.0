From: akpm@osdl.org
Subject: [patch 42/45] Switch fdomain to the pci_get API
Date: Fri, 20 Oct 2006 14:48:38 -0700
Message-ID: <200610202148.k9KLmctu004201@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:3975 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992793AbWJTVtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:49:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Doesn't make the hardware hot pluggable but does ensure the driver won't
crash when another device is hot-unplugged at the wrong moment. Soon I
propose to deprecate pci_find_device() and some of its friends.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/fdomain.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/fdomain.c~switch-fdomain-to-the-pci_get-api drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c~switch-fdomain-to-the-pci_get-api
+++ a/drivers/scsi/fdomain.c
@@ -387,6 +387,7 @@ static void __iomem *    bios_mem;
 static int               bios_major;
 static int               bios_minor;
 static int               PCI_bus;
+static struct pci_dev	*PCI_dev;
 static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
 static volatile int      in_command;
@@ -816,9 +817,10 @@ static int fdomain_pci_bios_detect( int 
 	   PCI_DEVICE_ID_FD_36C70 );
 #endif 
 
-   if ((pdev = pci_find_device(PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70, pdev)) == NULL)
+   if ((pdev = pci_get_device(PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70, pdev)) == NULL)
 		return 0;
-   if (pci_enable_device(pdev)) return 0;
+   if (pci_enable_device(pdev))
+   	goto fail;
        
 #if DEBUG_DETECT
    printk( "scsi: <fdomain> TMC-3260 detect:"
@@ -835,7 +837,7 @@ static int fdomain_pci_bios_detect( int 
    pci_irq = pdev->irq;
 
    if (!request_region( pci_base, 0x10, "fdomain" ))
-	return 0;
+   	goto fail;
 
    /* Now we have the I/O base address and interrupt from the PCI
       configuration registers. */
@@ -852,17 +854,22 @@ static int fdomain_pci_bios_detect( int 
    if (!fdomain_is_valid_port(pci_base)) {
       printk(KERN_ERR "scsi: <fdomain> PCI card detected, but driver not loaded (invalid port)\n" );
       release_region(pci_base, 0x10);
-      return 0;
+      goto fail;
    }
 
 				/* Fill in a few global variables.  Ugh. */
    bios_major = bios_minor = -1;
    PCI_bus    = 1;
+   PCI_dev    = pdev;
    Quantum    = 0;
    bios_base  = 0;
    
    return 1;
+fail:
+   pci_dev_put(pdev);
+   return 0;
 }
+
 #endif
 
 struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
@@ -913,8 +920,7 @@ struct Scsi_Host *__fdomain_16x0_detect(
       if (setup_called) {
 	 printk(KERN_ERR "scsi: <fdomain> Bad LILO/INSMOD parameters?\n");
       }
-      release_region(port_base, 0x10);
-      return NULL;
+      goto fail;
    }
 
    if (this_id) {
@@ -946,8 +952,7 @@ struct Scsi_Host *__fdomain_16x0_detect(
    /* Log IRQ with kernel */   
    if (!interrupt_level) {
       printk(KERN_ERR "scsi: <fdomain> Card Detected, but driver not loaded (no IRQ)\n" );
-      release_region(port_base, 0x10);
-      return NULL;
+      goto fail;
    } else {
       /* Register the IRQ with the kernel */
 
@@ -968,11 +973,14 @@ struct Scsi_Host *__fdomain_16x0_detect(
 	    printk(KERN_ERR "                Send mail to faith@acm.org\n" );
 	 }
 	 printk(KERN_ERR "scsi: <fdomain> Detected, but driver not loaded (IRQ)\n" );
-         release_region(port_base, 0x10);
-	 return NULL;
+	 goto fail;
       }
    }
    return shpnt;
+fail:
+   pci_dev_put(pdev);
+   release_region(port_base, 0x10);
+   return NULL;
 }
 
 static int fdomain_16x0_detect(struct scsi_host_template *tpnt)
@@ -1718,6 +1726,8 @@ static int fdomain_16x0_release(struct S
 		free_irq(shpnt->irq, shpnt);
 	if (shpnt->io_port && shpnt->n_io_port)
 		release_region(shpnt->io_port, shpnt->n_io_port);
+	if (PCI_bus)
+		pci_dev_put(PCI_dev);
 	return 0;
 }
 
_
