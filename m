From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_set_pci_device
Date: Thu, 13 Feb 2003 19:56:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030213195626.A12639@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

.. and update all callers to use the generic scsi_set_device.



--- 1.9/Documentation/scsi/scsi_mid_low_api.txt	Thu Dec  5 17:41:41 2002
+++ edited/Documentation/scsi/scsi_mid_low_api.txt	Wed Feb 12 22:06:47 2003
@@ -404,15 +404,15 @@
 
 
 /**
- * scsi_set_pci_device - place PCI device reference in host structure
+ * scsi_set_device - place device reference in host structure
  * @shost: a pointer to a scsi host instance
- * @pdev: pointer to PCI device instance to assign
+ * @pdev: pointer to device instance to assign
  *
  *	Returns nothing
  *
  *      Notes: Defined in drivers/scsi/hosts.h .
  **/
-void scsi_set_pci_device(struct Scsi_Host * shost, struct pci_dev * pdev)
+void scsi_set_device(struct Scsi_Host * shost, struct device * dev)
 
 
 /**
===== drivers/block/cciss_scsi.c 1.8 vs edited =====
--- 1.8/drivers/block/cciss_scsi.c	Mon Nov 18 08:09:49 2002
+++ edited/drivers/block/cciss_scsi.c	Thu Feb 13 15:32:08 2003
@@ -839,7 +839,7 @@
 	sh->hostdata[0] = (unsigned long) hba[i];
 	sh->irq = hba[i]->intr;
 	sh->unique_id = sh->irq;
-	scsi_set_pci_device(sh, hba[i]->pdev);
+	scsi_set_device(sh, &hba[i]->pdev->dev);
 
 	return 1;	/* Say we have 1 scsi adapter, this will be */
 			/* called multiple times, once for each adapter */
===== drivers/message/fusion/mptscsih.c 1.18 vs edited =====
--- 1.18/drivers/message/fusion/mptscsih.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/message/fusion/mptscsih.c	Thu Feb 13 15:32:28 2003
@@ -1769,7 +1769,7 @@
 
 				/* Set the pci device pointer in Scsi_Host structure.
 				 */
-				scsi_set_pci_device(sh, this->pcidev);
+				scsi_set_device(sh, &this->pcidev->dev);
 
 				spin_unlock_irqrestore(&this->FreeQlock, flags);
 
===== drivers/scsi/3w-xxxx.c 1.22 vs edited =====
--- 1.22/drivers/scsi/3w-xxxx.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/3w-xxxx.c	Wed Feb 12 22:05:55 2003
@@ -960,7 +960,9 @@
 			host->max_sectors = TW_MAX_SECTORS;
 #endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+			scsi_set_device(host, &tw_pci_dev->dev);
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
 			scsi_set_pci_device(host, tw_pci_dev);
 #endif
 
===== drivers/scsi/AM53C974.c 1.10 vs edited =====
--- 1.10/drivers/scsi/AM53C974.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/AM53C974.c	Wed Feb 12 22:06:00 2003
@@ -680,7 +680,7 @@
 		printk(KERN_WARNING "AM53C974: Unable to register host, aborting.\n");
 		return 0;
 	}
-	scsi_set_pci_device(instance, pdev);
+	scsi_set_device(instance, &pdev->dev);
 	hostdata = (struct AM53C974_hostdata *) instance->hostdata;
 	instance->base = 0;
 	instance->io_port = pci_resource_start(pdev, 0);
===== drivers/scsi/Kconfig 1.13 vs edited =====
--- 1.13/drivers/scsi/Kconfig	Tue Feb 11 19:54:45 2003
+++ edited/drivers/scsi/Kconfig	Wed Feb 12 17:00:53 2003
@@ -1707,6 +1707,13 @@
 	  see the picture at
 	  <http://amiga.multigraph.com/photos/oktagon.html>.
 
+config SCSI_PC980155
+	tristate "NEC PC-9801-55 SCSI support"
+	depends on X86_PC9800 && SCSI
+	help
+	  If you have the NEC PC-9801-55 SCSI interface card or compatibles
+	  for NEC PC-9801/PC-9821, say Y.
+
 #      bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERSTORMIII_SCSI
 #      bool 'GVP Turbo 040/060 SCSI support (EXPERIMENTAL)' CONFIG_GVP_TURBO_SCSI
 endmenu
--- 1.26/drivers/scsi/advansys.c	Tue Feb  4 17:27:21 2003
+++ edited/drivers/scsi/advansys.c	Wed Feb 12 21:59:26 2003
@@ -4791,9 +4791,8 @@
             if (shp == NULL) {
                 continue;
             }
-#ifdef CONFIG_PCI
-	    scsi_set_pci_device(shp, pci_devp);
-#endif
+
+	    scsi_set_device(shp, &pci_devp->dev);
 
             /* Save a pointer to the Scsi_host of each board found. */
             asc_host[asc_board_count++] = shp;
===== drivers/scsi/aic7xxx_old.c 1.42 vs edited =====
--- 1.42/drivers/scsi/aic7xxx_old.c	Thu Feb  6 16:33:47 2003
+++ edited/drivers/scsi/aic7xxx_old.c	Wed Feb 12 22:00:35 2003
@@ -8450,7 +8450,7 @@
     }
     p->host_no = host->host_no;
   }
-  scsi_set_pci_device(host, p->pdev);
+  scsi_set_device(host, &p->pdev->dev);
   return (p);
 }
 
===== drivers/scsi/cpqfcTSinit.c 1.30 vs edited =====
--- 1.30/drivers/scsi/cpqfcTSinit.c	Tue Feb  4 17:27:21 2003
+++ edited/drivers/scsi/cpqfcTSinit.c	Wed Feb 12 22:00:50 2003
@@ -337,7 +337,7 @@
       DEBUG_PCI(printk("  PciDev->baseaddress[3]= %lx\n", 
 				PciDev->resource[3].start));
 
-      scsi_set_pci_device(HostAdapter, PciDev);      
+      scsi_set_device(HostAdapter, &PciDev->dev);
       HostAdapter->irq = PciDev->irq;  // copy for Scsi layers
       
       // HP Tachlite uses two (255-byte) ranges of Port I/O (lower & upper),
===== drivers/scsi/dmx3191d.c 1.9 vs edited =====
--- 1.9/drivers/scsi/dmx3191d.c	Mon Nov 25 19:44:52 2002
+++ edited/drivers/scsi/dmx3191d.c	Wed Feb 12 22:01:01 2003
@@ -86,7 +86,7 @@
 			release_region(port, DMX3191D_REGION);
 			continue;
 		}
-		scsi_set_pci_device(instance, pdev);
+		scsi_set_device(instance, &pdev->dev);
 		instance->io_port = port;
 		instance->irq = pdev->irq;
 		NCR5380_init(instance, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
--- 1.16/drivers/scsi/fdomain.c	Mon Jan 13 21:36:37 2003
+++ edited/drivers/scsi/fdomain.c	Wed Feb 12 22:01:11 2003
@@ -960,7 +960,7 @@
    	return 0;
    shpnt->irq = interrupt_level;
    shpnt->io_port = port_base;
-   scsi_set_pci_device(shpnt, pdev);
+   scsi_set_device(shpnt, &pdev->dev);
    shpnt->n_io_port = 0x10;
    print_banner( shpnt );
 
===== drivers/scsi/hosts.h 1.52 vs edited =====
--- 1.52/drivers/scsi/hosts.h	Thu Feb  6 16:20:37 2003
+++ edited/drivers/scsi/hosts.h	Thu Feb 13 15:55:21 2003
@@ -27,7 +27,6 @@
 #include <linux/config.h>
 #include <linux/proc_fs.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 
 struct scsi_host_cmd_pool;
 
@@ -533,13 +532,6 @@
 {
         return shost->host_gendev;
 }
-
-static inline void scsi_set_pci_device(struct Scsi_Host *shost,
-                                       struct pci_dev *pdev)
-{
-        scsi_set_device(shost, &pdev->dev);
-}
-
 
 /*
  * Prototypes for functions/data in scsi_scan.c
===== drivers/scsi/ips.c 1.43 vs edited =====
--- 1.43/drivers/scsi/ips.c	Wed Jan 22 15:42:53 2003
+++ edited/drivers/scsi/ips.c	Wed Feb 12 22:01:38 2003
@@ -6731,7 +6731,7 @@
 	kfree(oldha);
 	ips_sh[index] = sh;
 	ips_ha[index] = ha;
-	scsi_set_pci_device(sh, ha->pcidev);
+	scsi_set_device(sh, &ha->pcidev->dev);
 
 	/* Store away needed values for later use */
 	sh->io_port = ha->io_addr;
===== drivers/scsi/megaraid.c 1.34 vs edited =====
--- 1.34/drivers/scsi/megaraid.c	Fri Feb  7 09:20:34 2003
+++ edited/drivers/scsi/megaraid.c	Wed Feb 12 22:02:03 2003
@@ -2963,7 +2963,7 @@
 		 */
 		host->max_sectors = 1024;
 
-		scsi_set_pci_device(host, pdev);
+		scsi_set_device(host, &pdev->dev);
 		megaCfg = (mega_host_config *) host->hostdata;
 		memset (megaCfg, 0, sizeof (mega_host_config));
 
===== drivers/scsi/nsp32.c 1.6 vs edited =====
--- 1.6/drivers/scsi/nsp32.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/nsp32.c	Wed Feb 12 22:02:14 2003
@@ -1661,7 +1661,7 @@
 	host->unique_id	  = data->BaseAddress;
 	host->n_io_port	  = data->NumAddress;
 	host->base        = data->MmioAddress;
-	scsi_set_pci_device(host, data->Pci);
+	scsi_set_device(host, &data->Pci->dev);
 
 	data->Host        = host;
 	spin_lock_init(&(data->Lock));
===== drivers/scsi/pci2000.c 1.12 vs edited =====
--- 1.12/drivers/scsi/pci2000.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/pci2000.c	Wed Feb 12 22:02:23 2003
@@ -707,7 +707,7 @@
 			goto unregister;
 			}
 		
-		scsi_set_pci_device(pshost, pdev);
+		scsi_set_device(pshost, &pdev->dev);
 		pshost->irq = pdev->irq;
 		setirq = 1;
 		padapter->irqOwned = 0;
===== drivers/scsi/pci2220i.c 1.15 vs edited =====
--- 1.15/drivers/scsi/pci2220i.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/pci2220i.c	Wed Feb 12 22:02:32 2003
@@ -2549,7 +2549,7 @@
 		if ( GetRegs (pshost, FALSE, pcidev) )
 			goto unregister;
 
-		scsi_set_pci_device(pshost, pcidev);
+		scsi_set_device(pshost, &pcidev->dev);
 		pshost->max_id = padapter->numberOfDrives;
 		for ( z = 0;  z < padapter->numberOfDrives;  z++ )
 			{
===== drivers/scsi/qla1280.c 1.30 vs edited =====
--- 1.30/drivers/scsi/qla1280.c	Fri Feb  7 09:20:35 2003
+++ edited/drivers/scsi/qla1280.c	Wed Feb 12 22:02:45 2003
@@ -814,7 +814,7 @@
 		goto error;
 	}
 
-	scsi_set_pci_device(host, pdev);
+	scsi_set_device(host, &pdev->dev);
 	ha = (struct scsi_qla_host *)host->hostdata;
 	/* Clear our data area */
 	memset(ha, 0, sizeof(struct scsi_qla_host));
===== drivers/scsi/qlogicfc.c 1.25 vs edited =====
--- 1.25/drivers/scsi/qlogicfc.c	Thu Feb  6 16:33:47 2003
+++ edited/drivers/scsi/qlogicfc.c	Wed Feb 12 22:02:56 2003
@@ -731,7 +731,7 @@
 			        printk("qlogicfc%d : could not register host.\n", hosts);
 				continue;
 			}
- 			scsi_set_pci_device(host, pdev);
+ 			scsi_set_device(host, &pdev->dev);
 			host->max_id = QLOGICFC_MAX_ID + 1;
 			host->max_lun = QLOGICFC_MAX_LUN;
 			hostdata = (struct isp2x00_hostdata *) host->hostdata;
===== drivers/scsi/qlogicisp.c 1.17 vs edited =====
--- 1.17/drivers/scsi/qlogicisp.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/qlogicisp.c	Wed Feb 12 22:03:35 2003
@@ -685,7 +685,7 @@
 		memset(hostdata, 0, sizeof(struct isp1020_hostdata));
 
 		hostdata->pci_dev = pdev;
-		scsi_set_pci_device(host, pdev);
+		scsi_set_device(host, &pdev->dev);
 
 		if (isp1020_init(host))
 			goto fail_and_unregister;
===== drivers/scsi/sym53c8xx.c 1.23 vs edited =====
--- 1.23/drivers/scsi/sym53c8xx.c	Fri Jan  3 19:58:50 2003
+++ edited/drivers/scsi/sym53c8xx.c	Wed Feb 12 22:03:46 2003
@@ -5890,7 +5890,7 @@
 	instance->dma_channel	= 0;
 	instance->cmd_per_lun	= MAX_TAGS;
 	instance->can_queue	= (MAX_START-4);
-	scsi_set_pci_device(instance, device->pdev);
+	scsi_set_device(instance, &device->pdev->dev);
 
 	np->check_integrity       = 0;
 
===== drivers/scsi/tmscsim.c 1.16 vs edited =====
--- 1.16/drivers/scsi/tmscsim.c	Fri Jan  3 19:58:50 2003
+++ edited/drivers/scsi/tmscsim.c	Wed Feb 12 22:04:13 2003
@@ -2206,7 +2206,7 @@
     psh = scsi_register( psht, sizeof(DC390_ACB) );
     if( !psh ) return( -1 );
 	
-    scsi_set_pci_device(psh, pdev);
+    scsi_set_device(psh, &pdev->dev);
     pACB = (PACB) psh->hostdata;
     DC390_LOCKA_INIT;
     DC390_LOCK_ACB;
--- 1.8/drivers/scsi/aacraid/linit.c	Tue Feb  4 20:10:04 2003
+++ edited/drivers/scsi/aacraid/linit.c	Wed Feb 12 21:59:06 2003
@@ -217,7 +217,7 @@
 			host_ptr->irq = dev->irq;		/* Adapter IRQ number */
 			/* host_ptr->base = ( char * )(dev->resource[0].start & ~0xff); */
 			host_ptr->base = dev->resource[0].start;
-			scsi_set_pci_device(host_ptr, dev);
+			scsi_set_device(host_ptr, &dev->dev);
 			dprintk((KERN_DEBUG "Device base address = 0x%lx [0x%lx].\n", host_ptr->base, dev->resource[0].start));
 			dprintk((KERN_DEBUG "Device irq = 0x%x.\n", dev->irq));
 			/*
===== drivers/scsi/aic7xxx/aic79xx_osm.c 1.19 vs edited =====
--- 1.19/drivers/scsi/aic7xxx/aic79xx_osm.c	Tue Feb 11 08:08:00 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	Wed Feb 12 22:00:24 2003
@@ -2381,7 +2381,9 @@
 		ahd_set_name(ahd, new_name);
 	}
 	host->unique_id = ahd->unit;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	scsi_set_device(host, &ahd->dev_softc->dev);
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
 	scsi_set_pci_device(host, ahd->dev_softc);
 #endif
 	ahd_linux_initialize_scsi_bus(ahd);
===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.16 vs edited =====
--- 1.16/drivers/scsi/aic7xxx/aic7xxx_osm.c	Mon Feb  3 21:47:17 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Feb 12 21:59:59 2003
@@ -1861,7 +1861,9 @@
 		ahc_set_name(ahc, new_name);
 	}
 	host->unique_id = ahc->unit;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	scsi_set_device(host, &ahc->dev_softc->dev);
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
 	scsi_set_pci_device(host, ahc->dev_softc);
 #endif
 	ahc_linux_initialize_scsi_bus(ahc);
===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.14 vs edited =====
--- 1.14/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Feb 10 16:36:04 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Wed Feb 12 22:03:59 2003
@@ -2130,7 +2130,7 @@
 
 	SYM_UNLOCK_HCB(np, flags);
 
-	scsi_set_pci_device(instance, dev->pdev);
+	scsi_set_device(instance, &dev->pdev->dev);
 
 	/*
 	 *  Now let the generic SCSI driver
