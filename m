From: Doug Ledford <dledford@redhat.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Thu, 12 Dec 2002 15:20:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212202052.GC8842@redhat.com>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1221760000.1039627865@aslan.btc.adaptec.com> <20021211181745.A30253@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021211181745.A30253@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2002 at 06:17:46PM +0000, Christoph Hellwig wrote:
> 
> Yupp, it currently crashes when I have both compiled in.  Dough, any chance
> you could fix that?  A PCI driver is not supposed to stop over already
> claimed device.

If you've got a test machine, the attached patch would I think fix the 
problem.  Let me know if it does in fact work for you and I'll commit it 
to the tree.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aic-playnice.patch"

===== drivers/scsi/aic7xxx_old.c 1.37 vs edited =====
--- 1.37/drivers/scsi/aic7xxx_old.c	Fri Nov 22 00:34:44 2002
+++ edited/drivers/scsi/aic7xxx_old.c	Thu Dec 12 13:35:23 2002
@@ -9246,12 +9246,22 @@
 	    {
               /* duplicate PCI entry, skip it */
 	      kfree(temp_p);
-	      temp_p = NULL;
+              continue;
 	    }
 	    current_p = current_p->next;
 	  }
-	  if ( temp_p == NULL )
+          if(!pci_request_regions(temp_p->pdev, "aic7xxx"))
+          {
+            printk("aic7xxx: <%s> at PCI %d/%d/%d\n", 
+              board_names[aic_pdevs[i].board_name_index],
+              temp_p->pci_bus,
+              PCI_SLOT(temp_p->pci_device_fn),
+              PCI_FUNC(temp_p->pci_device_fn));
+            printk("aic7xxx: I/O ports already in use, ignoring.\n");
+            kfree(temp_p);
             continue;
+          }
+
           if (aic7xxx_verbose & VERBOSE_PROBE2)
             printk("aic7xxx: <%s> at PCI %d/%d\n", 
               board_names[aic_pdevs[i].board_name_index],
@@ -9283,20 +9293,6 @@
           pci_write_config_dword(pdev, DEVCONFIG, devconfig);
 #endif /* AIC7XXX_STRICT_PCI_SETUP */
 
-          if(temp_p->base && !request_region(temp_p->base, MAXREG - MINREG,
-				  "aic7xxx"))
-          {
-            printk("aic7xxx: <%s> at PCI %d/%d/%d\n", 
-              board_names[aic_pdevs[i].board_name_index],
-              temp_p->pci_bus,
-              PCI_SLOT(temp_p->pci_device_fn),
-              PCI_FUNC(temp_p->pci_device_fn));
-            printk("aic7xxx: I/O ports already in use, ignoring.\n");
-            kfree(temp_p);
-            temp_p = NULL;
-            continue;
-          }
-
           temp_p->unpause = INTEN;
           temp_p->pause = temp_p->unpause | PAUSE;
           if ( ((temp_p->base == 0) &&
@@ -9309,9 +9305,7 @@
               PCI_SLOT(temp_p->pci_device_fn),
               PCI_FUNC(temp_p->pci_device_fn));
             printk("aic7xxx: Controller disabled by BIOS, ignoring.\n");
-            kfree(temp_p);
-            temp_p = NULL;
-            continue;
+            goto skip_pci_controller;
           }
 
 #ifdef MMAPIO
@@ -9353,9 +9347,7 @@
                     PCI_SLOT(temp_p->pci_device_fn),
                     PCI_FUNC(temp_p->pci_device_fn));
                   printk("aic7xxx: Controller disabled by BIOS, ignoring.\n");
-                  kfree(temp_p);
-                  temp_p = NULL;
-                  continue;
+                  goto skip_pci_controller;
                 }
               }
             }
@@ -9398,10 +9390,7 @@
 
           if (aic7xxx_chip_reset(temp_p) == -1)
           {
-            release_region(temp_p->base, MAXREG - MINREG);
-            kfree(temp_p);
-            temp_p = NULL;
-            continue;
+            goto skip_pci_controller;
           }
           /*
            * Very quickly put the term setting back into the register since
@@ -9687,6 +9676,10 @@
           }
           temp_p->next = NULL;
           found++;
+	  continue;
+skip_pci_controller:
+	  pci_release_regions(temp_p->pdev);
+	  kfree(temp_p);
         }  /* Found an Adaptec PCI device. */
         else /* Well, we found one, but we couldn't get any memory */
         {
@@ -10969,14 +10962,16 @@
 
   if(p->irq)
     free_irq(p->irq, p);
-  if(p->base)
-    release_region(p->base, MAXREG - MINREG);
 #ifdef MMAPIO
   if(p->maddr)
   {
     iounmap((void *) (((unsigned long) p->maddr) & PAGE_MASK));
   }
 #endif /* MMAPIO */
+  if(!p->pdev)
+    release_region(p->base, MAXREG - MINREG);
+  else
+    pci_release_regions(p->pdev);
   prev = NULL;
   next = first_aic7xxx;
   while(next != NULL)

--3V7upXqbjpZ4EhLz--
