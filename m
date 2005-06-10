From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_set_device
Date: Sat, 11 Jun 2005 01:05:01 +0200
Message-ID: <20050610230501.GA9581@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:53428 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261402AbVFJXFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 19:05:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

scsi_add_host is the proper place to set the device, but people copy
the scsi_set_device usage from older drivers again and again.

note that this leaves some legacy drivers like qlogicisp/qlogicfc
without pci association in sysfs, but they're scheduled to go away soon
anyway.

Index: scsi-misc-2.6/drivers/scsi/ncr53c8xx.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ncr53c8xx.c	2005-05-31 17:29:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ncr53c8xx.c	2005-06-11 00:54:30.000000000 +0200
@@ -7756,7 +7756,6 @@
 	 * your module_init */
 	BUG_ON(!ncr53c8xx_transport_template);
 	instance->transportt	= ncr53c8xx_transport_template;
-	scsi_set_device(instance, device->dev);
 
 	/* Patch script to physical addresses */
 	ncr_script_fill(&script0, &scripth0);
Index: scsi-misc-2.6/drivers/message/fusion/mptspi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptspi.c	2005-05-31 17:29:24.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptspi.c	2005-06-11 00:56:30.000000000 +0200
@@ -287,10 +287,6 @@
 		sh->sg_tablesize = numSGE;
 	}
 
-	/* Set the pci device pointer in Scsi_Host structure.
-	 */
-	scsi_set_device(sh, &ioc->pcidev->dev);
-
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	hd = (MPT_SCSI_HOST *) sh->hostdata;
Index: scsi-misc-2.6/drivers/scsi/megaraid/megaraid_mbox.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/megaraid/megaraid_mbox.c	2005-05-31 17:29:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/megaraid/megaraid_mbox.c	2005-06-11 00:54:16.000000000 +0200
@@ -719,7 +719,6 @@
 
 	// export the parameters required by the mid-layer
 	scsi_assign_lock(host, adapter->host_lock);
-	scsi_set_device(host, &adapter->pdev->dev);
 
 	host->irq		= adapter->irq;
 	host->unique_id		= adapter->unique_id;
Index: scsi-misc-2.6/drivers/scsi/nsp32.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/nsp32.c	2005-05-31 17:29:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/nsp32.c	2005-06-11 00:53:51.000000000 +0200
@@ -2720,9 +2720,7 @@
 	host->unique_id = data->BaseAddress;
 	host->n_io_port	= data->NumAddress;
 	host->base      = (unsigned long)data->MmioAddress;
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,63))
-	scsi_set_device(host, &PCIDEV->dev);
-#else
+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,63))
 	scsi_set_pci_device(host, PCIDEV);
 #endif
 
Index: scsi-misc-2.6/drivers/scsi/libata-core.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/libata-core.c	2005-05-31 17:29:52.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/libata-core.c	2005-06-11 00:54:41.000000000 +0200
@@ -3365,7 +3365,7 @@
 	host->max_channel = 1;
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = 12;
-	scsi_set_device(host, ent->dev);
+
 	scsi_assign_lock(host, &host_set->lock);
 
 	ap->flags = ATA_FLAG_PORT_DISABLED;
Index: scsi-misc-2.6/drivers/scsi/ips.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ips.h	2005-05-31 17:29:52.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ips.h	2005-06-11 00:55:36.000000000 +0200
@@ -111,7 +111,7 @@
       #define IPS_UNREGISTER_HOSTS(SHT)
       #define IPS_ADD_HOST(shost,device)   do { scsi_add_host(shost,device); scsi_scan_host(shost); } while (0)
       #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)
-      #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_device(sh, &(ha)->pcidev->dev)
+      #define IPS_SCSI_SET_DEVICE(sh,ha)   do { } while (0)
       #define IPS_PRINTK(level, pcidev, format, arg...)                 \
             dev_printk(level , &((pcidev)->dev) , format , ## arg)
    #endif
Index: scsi-misc-2.6/drivers/message/fusion/mptfc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptfc.c	2005-05-31 17:29:24.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptfc.c	2005-06-11 00:56:22.000000000 +0200
@@ -267,10 +267,6 @@
 		sh->sg_tablesize = numSGE;
 	}
 
-	/* Set the pci device pointer in Scsi_Host structure.
-	 */
-	scsi_set_device(sh, &ioc->pcidev->dev);
-
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	hd = (MPT_SCSI_HOST *) sh->hostdata;
Index: scsi-misc-2.6/drivers/scsi/qlogicisp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qlogicisp.c	2005-05-31 17:29:56.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qlogicisp.c	2005-06-11 01:00:44.000000000 +0200
@@ -694,7 +694,6 @@
 		memset(hostdata, 0, sizeof(struct isp1020_hostdata));
 
 		hostdata->pci_dev = pdev;
-		scsi_set_device(host, &pdev->dev);
 
 		if (isp1020_init(host))
 			goto fail_and_unregister;
Index: scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt	2005-05-31 17:28:05.000000000 +0200
+++ scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt	2005-06-11 01:01:49.000000000 +0200
@@ -388,7 +388,6 @@
    scsi_remove_device - detach and remove a SCSI device
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
-   scsi_set_device - place device reference in host structure
    scsi_track_queue_full - track successive QUEUE_FULL events 
    scsi_unblock_requests - allow further commands to be queued to given host
    scsi_unregister - [calls scsi_host_put()]
@@ -741,20 +740,6 @@
 
 
 /**
- * scsi_set_device - place device reference in host structure
- * @shost: a pointer to a scsi host instance
- * @pdev: pointer to device instance to assign
- *
- *      Returns nothing
- *
- *      Might block: no
- *
- *      Defined in: include/scsi/scsi_host.h .
- **/
-void scsi_set_device(struct Scsi_Host * shost, struct device * dev)
-
-
-/**
  * scsi_track_queue_full - track successive QUEUE_FULL events on given
  *                      device to determine if and when there is a need
  *                      to adjust the queue depth on the device.
Index: scsi-misc-2.6/drivers/scsi/advansys.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/advansys.c	2005-05-31 17:29:48.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/advansys.c	2005-06-11 01:00:06.000000000 +0200
@@ -4556,8 +4556,6 @@
                 continue;
             }
 
-	    scsi_set_device(shp, dev);
-
             /* Save a pointer to the Scsi_Host of each board found. */
             asc_host[asc_board_count++] = shp;
 
Index: scsi-misc-2.6/include/scsi/scsi_host.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_host.h	2005-05-31 17:32:56.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_host.h	2005-06-11 01:02:03.000000000 +0200
@@ -641,12 +641,6 @@
 	shost->host_lock = lock;
 }
 
-static inline void scsi_set_device(struct Scsi_Host *shost,
-                                   struct device *dev)
-{
-        shost->shost_gendev.parent = dev;
-}
-
 static inline struct device *scsi_get_device(struct Scsi_Host *shost)
 {
         return shost->shost_gendev.parent;
Index: scsi-misc-2.6/drivers/scsi/qlogicfc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qlogicfc.c	2005-05-31 17:29:56.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qlogicfc.c	2005-06-11 01:00:49.000000000 +0200
@@ -746,7 +746,6 @@
 			        printk("qlogicfc%d : could not register host.\n", hosts);
 				continue;
 			}
- 			scsi_set_device(host, &pdev->dev);
 			host->max_id = QLOGICFC_MAX_ID + 1;
 			host->max_lun = QLOGICFC_MAX_LUN;
 			hostdata = (struct isp2x00_hostdata *) host->hostdata;
Index: scsi-misc-2.6/drivers/scsi/gdth.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth.c	2005-05-31 17:29:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth.c	2005-06-11 01:00:17.000000000 +0200
@@ -4521,9 +4521,7 @@
             ha->virt_bus = hdr_channel;
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            scsi_set_device(shp, &pcistr[ctr].pdev->dev);
-#else
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
             scsi_set_pci_device(shp, pcistr[ctr].pdev);
 #endif
             if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &GDT_64BIT)||
Index: scsi-misc-2.6/drivers/scsi/hosts.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2005-05-31 17:29:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/hosts.c	2005-06-11 01:02:28.000000000 +0200
@@ -180,11 +180,6 @@
 	scsi_destroy_command_freelist(shost);
 	kfree(shost->shost_data);
 
-	/*
-	 * Some drivers (eg aha1542) do scsi_register()/scsi_unregister()
-	 * during probing without performing a scsi_set_device() in between.
-	 * In this case dev->parent is NULL.
-	 */
 	if (parent)
 		put_device(parent);
 	kfree(shost);
Index: scsi-misc-2.6/drivers/scsi/fdomain.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fdomain.c	2005-05-31 17:29:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fdomain.c	2005-06-11 01:01:05.000000000 +0200
@@ -938,7 +938,6 @@
    }
    shpnt->irq = interrupt_level;
    shpnt->io_port = port_base;
-   scsi_set_device(shpnt, &pdev->dev);
    shpnt->n_io_port = 0x10;
    print_banner( shpnt );
 
Index: scsi-misc-2.6/drivers/scsi/aic7xxx_old.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx_old.c	2005-05-31 17:29:49.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx_old.c	2005-06-11 01:00:33.000000000 +0200
@@ -8448,7 +8448,6 @@
     }
     p->host_no = host->host_no;
   }
-  scsi_set_device(host, &p->pdev->dev);
   return (p);
 }
 
Index: scsi-misc-2.6/drivers/scsi/cpqfcTSinit.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/cpqfcTSinit.c	2005-05-31 17:29:50.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/cpqfcTSinit.c	2005-06-11 01:01:12.000000000 +0200
@@ -336,7 +336,6 @@
       DEBUG_PCI(printk("  PciDev->baseaddress[3]= %lx\n", 
 				PciDev->resource[3].start));
 
-      scsi_set_device(HostAdapter, &PciDev->dev);
       HostAdapter->irq = PciDev->irq;  // copy for Scsi layers
       
       // HP Tachlite uses two (255-byte) ranges of Port I/O (lower & upper),
