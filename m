From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH]: Switch fdomain to the pci_get API
Date: Mon, 16 Oct 2006 16:55:46 +0100
Message-ID: <1161014146.24237.106.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:6033 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1422637AbWJPP3H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 11:29:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Doesn't make the hardware hot pluggable but does ensure the driver won't
crash when another device is hot-unplugged at the wrong moment. Soon I
propose to deprecate pci_find_device() and some of its friends.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.19-rc1-mm1/drivers/scsi/fdomain.c linux-2.6.19-rc1-mm1/drivers/scsi/fdomain.c
--- linux.vanilla-2.6.19-rc1-mm1/drivers/scsi/fdomain.c	2006-10-13 15:10:07.000000000 +0100
+++ linux-2.6.19-rc1-mm1/drivers/scsi/fdomain.c	2006-10-13 17:21:00.000000000 +0100
@@ -387,6 +387,7 @@
 static int               bios_major;
 static int               bios_minor;
 static int               PCI_bus;
+static struct pci_dev	*PCI_dev;
 static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
 static volatile int      in_command;
@@ -816,9 +817,10 @@
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
@@ -833,9 +835,9 @@
 
    pci_base = pci_resource_start(pdev, 0);
    pci_irq = pdev->irq;
-
+   
    if (!request_region( pci_base, 0x10, "fdomain" ))
-	return 0;
+   	goto fail;
 
    /* Now we have the I/O base address and interrupt from the PCI
       configuration registers. */
@@ -852,17 +854,22 @@
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
@@ -913,8 +920,7 @@
       if (setup_called) {
 	 printk(KERN_ERR "scsi: <fdomain> Bad LILO/INSMOD parameters?\n");
       }
-      release_region(port_base, 0x10);
-      return NULL;
+      goto fail;
    }
 
    if (this_id) {
@@ -946,8 +952,7 @@
    /* Log IRQ with kernel */   
    if (!interrupt_level) {
       printk(KERN_ERR "scsi: <fdomain> Card Detected, but driver not loaded (no IRQ)\n" );
-      release_region(port_base, 0x10);
-      return NULL;
+      goto fail;
    } else {
       /* Register the IRQ with the kernel */
 
@@ -968,11 +973,14 @@
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
@@ -1718,6 +1726,8 @@
 		free_irq(shpnt->irq, shpnt);
 	if (shpnt->io_port && shpnt->n_io_port)
 		release_region(shpnt->io_port, shpnt->n_io_port);
+	if (PCI_bus)
+		pci_dev_put(PCI_dev);
 	return 0;
 }
 

