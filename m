From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] aic7xxx_old iomem annotations (for real, this time)
Date: Fri, 22 Oct 2004 03:16:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022021643.GU24336@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45006 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271212AbUJVCQo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 22:16:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

annotated, ioremap() use simplified (it can deal with addresses that are not
page-aligned just fine).
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-qlogicisp/drivers/scsi/aic7xxx_old.c RC9-bk4-aic-old/drivers/scsi/aic7xxx_old.c
--- RC9-bk4-qlogicisp/drivers/scsi/aic7xxx_old.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-old/drivers/scsi/aic7xxx_old.c	Wed Oct 20 19:24:37 2004
@@ -924,7 +924,7 @@
   volatile long            flags;
   ahc_feature              features;         /* chip features */
   unsigned long            base;             /* card base address */
-  volatile unsigned char  *maddr;            /* memory mapped address */
+  volatile unsigned char  __iomem *maddr;            /* memory mapped address */
   unsigned long            isr_count;        /* Interrupt count */
   unsigned long            spurious_int;
   scb_data_type           *scb_data;
@@ -7967,8 +7967,8 @@
     printk(KERN_INFO "(scsi%d) BIOS %sabled, IO Port 0x%lx, IRQ %d\n",
       p->host_no, (p->flags & AHC_BIOS_ENABLED) ? "en" : "dis",
       p->base, p->irq);
-    printk(KERN_INFO "(scsi%d) IO Memory at 0x%lx, MMAP Memory at 0x%lx\n",
-      p->host_no, p->mbase, (unsigned long)p->maddr);
+    printk(KERN_INFO "(scsi%d) IO Memory at 0x%lx, MMAP Memory at %p\n",
+      p->host_no, p->mbase, p->maddr);
   }
 
 #ifdef CONFIG_PCI
@@ -9311,14 +9311,9 @@
                ((temp_p->chip != (AHC_AIC7870 | AHC_PCI)) &&
                 (temp_p->chip != (AHC_AIC7880 | AHC_PCI))) )
           {
-            unsigned long page_offset, base;
-
-            base = temp_p->mbase & PAGE_MASK;
-            page_offset = temp_p->mbase - base;
-            temp_p->maddr = ioremap_nocache(base, page_offset + 256);
+            temp_p->maddr = ioremap_nocache(temp_p->mbase, 256);
             if(temp_p->maddr)
             {
-              temp_p->maddr += page_offset;
               /*
                * We need to check the I/O with the MMAPed address.  Some machines
                * simply fail to work with MMAPed I/O and certain controllers.
@@ -9335,7 +9330,7 @@
                   PCI_FUNC(temp_p->pci_device_fn));
                 printk(KERN_INFO "aic7xxx: MMAPed I/O failed, reverting to "
                                  "Programmed I/O.\n");
-                iounmap((void *) (((unsigned long) temp_p->maddr) & PAGE_MASK));
+                iounmap(temp_p->maddr);
                 temp_p->maddr = NULL;
                 if(temp_p->base == 0)
                 {
@@ -10965,7 +10960,7 @@
 #ifdef MMAPIO
   if(p->maddr)
   {
-    iounmap((void *) (((unsigned long) p->maddr) & PAGE_MASK));
+    iounmap(p->maddr);
   }
 #endif /* MMAPIO */
   if(!p->pdev)
