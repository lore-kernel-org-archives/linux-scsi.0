From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] pull scsi_scan_host out of scsi_add_host
Date: Mon, 7 Jul 2003 16:30:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030707143056.GA1177@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:50855 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264994AbTGGOQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 10:16:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

As Douglas mentioned on this list a while ago there's hardware these
days where we don't want to automatically perform an initial bus scan
in scsi_add_host.  Currently we only have ieee1394 in the tree but
I can imagine more uses like iscsi or certain fc setups.

This patch removes the call to scsi_scan_host from scsi_add_host
and moves it into the drivers that want in.


diff -Nru a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/block/cciss_scsi.c	Sun Jul  6 18:14:28 2003
@@ -712,7 +712,8 @@
 	sh->hostdata[0] = (unsigned long) hba[ctlr];
 	sh->irq = hba[ctlr]->intr;
 	sh->unique_id = sh->irq;
-	scsi_add_host(sh, &hba[ctlr]->pdev->dev);
+	scsi_add_host(sh, &hba[ctlr]->pdev->dev); /* XXX handle failure */
+	scsi_scan_host(sh);
 
 	return 1;
 }
diff -Nru a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/NCR_D700.c	Sun Jul  6 18:14:28 2003
@@ -218,7 +218,8 @@
 		goto irq_failed;
 	}
 
-	scsi_add_host(host, p->dev);
+	scsi_add_host(host, p->dev); /* XXX handle failure */
+	scsi_scan_host(host);
 
 	p->hosts[siop] = host;
 	hostdata->dev = p->dev;
diff -Nru a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
--- a/drivers/scsi/aha1740.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/aha1740.c	Sun Jul  6 18:14:28 2003
@@ -636,7 +636,8 @@
 	}
 
 	eisa_set_drvdata (edev, shpnt);
-	scsi_add_host (shpnt, dev);
+	scsi_add_host (shpnt, dev); /* XXX handle failure */
+	scsi_scan_host (shpnt)
 	return 0;
 
  err_unmap:
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c	Sun Jul  6 18:14:28 2003
@@ -2173,7 +2173,8 @@
 	ahd_unlock(ahd, &s);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_add_host(host, &ahd->dev_softc->dev);
+	scsi_add_host(host, &ahd->dev_softc->dev); /* XXX handle failure */
+	scsi_scan_host(host);
 #endif
 	return (0);
 }
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c	Sun Jul  6 18:14:28 2003
@@ -1811,7 +1811,8 @@
 	ahc_unlock(ahc, &s);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL));
+	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failure */
+	scsi_scan_host(host);
 #endif
 	return (0);
 }
diff -Nru a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
--- a/drivers/scsi/arm/acornscsi.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/arm/acornscsi.c	Sun Jul  6 18:14:28 2003
@@ -3043,9 +3043,13 @@
 	acornscsi_resetcard(ashost);
 
 	ret = scsi_add_host(host, &ec->dev);
-	if (ret == 0)
-		goto out;
+	if (ret)
+		goto err_7;
 
+	scsi_scan_host(host);
+	goto out;
+
+ err_7:
 	free_irq(host->irq, ashost);
  err_6:
 	release_region(host->io_port, 2048);
diff -Nru a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
--- a/drivers/scsi/arm/cumana_1.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/arm/cumana_1.c	Sun Jul  6 18:14:28 2003
@@ -297,9 +297,13 @@
 	printk("\n");
 
 	ret = scsi_add_host(host, &ec->dev);
-	if (ret == 0)
-		goto out;
+	if (ret)
+		goto out_free_irq;
 
+	scsi_scan_host(host);
+	goto out;
+
+ out_free_irq:
 	free_irq(host->irq, host);
  out_release:
 	release_region(host->io_port, host->n_io_port);
diff -Nru a/drivers/scsi/arm/ecoscsi.c b/drivers/scsi/arm/ecoscsi.c
--- a/drivers/scsi/arm/ecoscsi.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/arm/ecoscsi.c	Sun Jul  6 18:14:29 2003
@@ -205,7 +205,8 @@
 	NCR5380_print_options(host);
 	printk("\n");
 
-	scsi_add_host(host, NULL);
+	scsi_add_host(host, NULL); /* XXX handle failure */
+	scsi_scan_host(host);
 	return 0;
 
 release_reg:
diff -Nru a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
--- a/drivers/scsi/arm/fas216.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/arm/fas216.c	Sun Jul  6 18:14:28 2003
@@ -2861,6 +2861,8 @@
 	ret = scsi_add_host(host, dev);
 	if (ret)
 		fas216_writeb(info, REG_CMD, CMD_RESETCHIP);
+	else
+		scsi_scan_host(host);
 
 	return ret;
 }
diff -Nru a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
--- a/drivers/scsi/arm/oak.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/arm/oak.c	Sun Jul  6 18:14:28 2003
@@ -158,9 +158,13 @@
 	printk("\n");
 
 	ret = scsi_add_host(host, &ec->dev);
-	if (ret == 0)
-		goto out;
+	if (ret)
+		goto out_release;
 
+	scsi_scan_host(host);
+	goto out;
+
+ out_release:
 	release_region(host->io_port, host->n_io_port);
  unreg:
 	scsi_host_put(host);
diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/dc395x.c	Sun Jul  6 18:14:28 2003
@@ -6214,7 +6214,8 @@
 	pci_set_drvdata(pdev, scsi_host);
 
 	/* get the scsi mid level to scan for new devices on the bus */
-	scsi_add_host(scsi_host, &pdev->dev);
+	scsi_add_host(scsi_host, &pdev->dev);	/* XXX handle failure */
+	scsi_scan_host(scsi_host);
 
 	return 0;
 }
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/hosts.c	Sun Jul  6 18:14:28 2003
@@ -81,19 +81,15 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	error = scsi_sysfs_add_host(shost, dev);
-
 	if (!shost->can_queue) {
 		printk(KERN_ERR "%s: can_queue = 0 no longer supported\n",
 				sht->name);
 		error = -EINVAL;
 	}
 
-	if (!error) {
+	error = scsi_sysfs_add_host(shost, dev);
+	if (!error)
 		scsi_proc_host_add(shost);
-		scsi_scan_host(shost);
-	}
-			
 	return error;
 }
 
diff -Nru a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/ide-scsi.c	Sun Jul  6 18:14:29 2003
@@ -978,8 +978,10 @@
 		idescsi_setup (drive, idescsi);
 		drive->disk->fops = &idescsi_ops;
 		err = scsi_add_host(host, &idescsi_primary);
-		if (!err)
+		if (!err) {
+			scsi_scan_host(host);
 			return 0;
+		}
 		/* fall through on error */
 		ide_unregister_subdriver(drive);
 	}
diff -Nru a/drivers/scsi/ips.h b/drivers/scsi/ips.h
--- a/drivers/scsi/ips.h	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/ips.h	Sun Jul  6 18:14:28 2003
@@ -111,7 +111,7 @@
    #else
       #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))
       #define IPS_UNREGISTER_HOSTS(SHT)
-      #define IPS_ADD_HOST(shost,device)   scsi_add_host(shost,device)
+      #define IPS_ADD_HOST(shost,device)   do { scsi_add_host(shost,device); scsi_scan_host(shost); } while (0)
       #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)
       #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_device(sh, &(ha)->pcidev->dev)
       #define IPS_PRINTK(level, pcidev, format, arg...)                 \
diff -Nru a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
--- a/drivers/scsi/lasi700.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/lasi700.c	Sun Jul  6 18:14:28 2003
@@ -128,7 +128,8 @@
 	}
 
 	dev_set_drvdata(&dev->dev, host);
-	scsi_add_host(host, &dev->dev);
+	scsi_add_host(host, &dev->dev); /* XXX handle failure */
+	scsi_scan_host(host);
 
 	return 0;
 
diff -Nru a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/nsp32.c	Sun Jul  6 18:14:28 2003
@@ -1820,7 +1820,8 @@
 		goto free_irq;
         }
 
-	scsi_add_host(host, &pdev->dev);
+	scsi_add_host(host, &pdev->dev); /* XXX handle failure */
+	scsi_scan_host(host);
 	pci_set_drvdata(pdev, host);
 	return 0;
 
diff -Nru a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
--- a/drivers/scsi/pcmcia/aha152x_stub.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/pcmcia/aha152x_stub.c	Sun Jul  6 18:14:29 2003
@@ -278,7 +278,8 @@
 	goto cs_failed;
     }
 
-    scsi_add_host(host, NULL);
+    scsi_add_host(host, NULL); /* XXX handle failure */
+    scsi_scan_host(host);
 
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
     link->dev = &info->node;
diff -Nru a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
--- a/drivers/scsi/pcmcia/fdomain_stub.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/pcmcia/fdomain_stub.c	Sun Jul  6 18:14:28 2003
@@ -254,7 +254,8 @@
 	goto cs_failed;
     }
  
-    scsi_add_host(host, NULL);
+    scsi_add_host(host, NULL); /* XXX handle failure */
+    scsi_scan_host(host);
 
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
     link->dev = &info->node;
diff -Nru a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/pcmcia/nsp_cs.c	Sun Jul  6 18:14:29 2003
@@ -1773,7 +1773,8 @@
 		       req.Base+req.Size-1);
 	printk("\n");
 
-	scsi_add_host(host, NULL);
+	scsi_add_host(host, NULL); /* XXX handle failure */
+	scsi_scan_host(host);
 	link->state &= ~DEV_CONFIG_PENDING;
 	return;
 
diff -Nru a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
--- a/drivers/scsi/pcmcia/qlogic_stub.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/pcmcia/qlogic_stub.c	Sun Jul  6 18:14:28 2003
@@ -270,7 +270,8 @@
 	link->dev = &info->node;
 	info->host = host;
 
-	scsi_add_host(host, NULL);
+	scsi_add_host(host, NULL); /* XXX handle failure */
+	scsi_scan_host(host);
 
 out:
 	link->state &= ~DEV_CONFIG_PENDING;
diff -Nru a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/scsi_debug.c	Sun Jul  6 18:14:29 2003
@@ -1701,7 +1701,8 @@
                 printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
                 error = -ENODEV;
 		scsi_host_put(hpnt);
-        }
+        } else
+		scsi_scan_host(hpnt);
 
 
         return error;
diff -Nru a/drivers/scsi/scsi_module.c b/drivers/scsi/scsi_module.c
--- a/drivers/scsi/scsi_module.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/scsi_module.c	Sun Jul  6 18:14:28 2003
@@ -40,6 +40,7 @@
 		error = scsi_add_host(shost, NULL);
 		if (error)
 			goto fail;
+		scsi_scan_host(shost);
 	}
 	return 0;
  fail:
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/scsi_priv.h	Sun Jul  6 18:14:29 2003
@@ -102,7 +102,6 @@
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
-extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_free_shost(struct Scsi_Host *);
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/scsi/scsi_syms.c	Sun Jul  6 18:14:28 2003
@@ -34,6 +34,7 @@
 EXPORT_SYMBOL(scsi_register_interface);
 EXPORT_SYMBOL(scsi_host_alloc);
 EXPORT_SYMBOL(scsi_add_host);
+EXPORT_SYMBOL(scsi_scan_host);
 EXPORT_SYMBOL(scsi_remove_host);
 EXPORT_SYMBOL(scsi_host_get);
 EXPORT_SYMBOL(scsi_host_put);
diff -Nru a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
--- a/drivers/scsi/sim710.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/scsi/sim710.c	Sun Jul  6 18:14:29 2003
@@ -138,7 +138,8 @@
 		goto out_unregister;
 	}
 
-	scsi_add_host(host, dev);
+	scsi_add_host(host, dev); /* XXX handle failure */
+	scsi_scan_host(host);
 	hostdata->dev = dev;
 
 	return 0;
diff -Nru a/drivers/usb/image/hpusbscsi.c b/drivers/usb/image/hpusbscsi.c
--- a/drivers/usb/image/hpusbscsi.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/usb/image/hpusbscsi.c	Sun Jul  6 18:14:29 2003
@@ -109,7 +109,8 @@
 		goto out_unlink_controlurb;
 
 	new->host->hostdata[0] = (unsigned long)new;
-	scsi_add_host(new->host, &intf->dev);
+	scsi_add_host(new->host, &intf->dev); /* XXX handle failure */
+	scsi_scan_host(new->host);
 
 	new->sense_command[0] = REQUEST_SENSE;
 	new->sense_command[4] = HPUSBSCSI_SENSE_LENGTH;
diff -Nru a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
--- a/drivers/usb/image/microtek.c	Sun Jul  6 18:14:29 2003
+++ b/drivers/usb/image/microtek.c	Sun Jul  6 18:14:29 2003
@@ -817,7 +817,8 @@
 		goto out_free_urb;
 
 	new_desc->host->hostdata[0] = (unsigned long)new_desc;
-	scsi_add_host(new_desc->host, NULL);
+	scsi_add_host(new_desc->host, NULL); /* XXX handle failure */
+	scsi_scan_host(new_desc->host);
 
 	usb_set_intfdata(intf, new_desc);
 	return 0;
diff -Nru a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c	Sun Jul  6 18:14:28 2003
+++ b/drivers/usb/storage/usb.c	Sun Jul  6 18:14:28 2003
@@ -958,6 +958,8 @@
 		goto BadDevice;
 	}
 
+	scsi_scan_host(us->host);
+
 	printk(KERN_DEBUG 
 	       "WARNING: USB Mass Storage data integrity not assured\n");
 	printk(KERN_DEBUG 
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sun Jul  6 18:14:28 2003
+++ b/include/scsi/scsi_host.h	Sun Jul  6 18:14:28 2003
@@ -477,6 +477,7 @@
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
+extern void scsi_scan_host(struct Scsi_Host *);
 extern int scsi_remove_host(struct Scsi_Host *);
 extern void scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
diff -Nru a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
--- a/drivers/scsi/NCR_Q720.c	Sun Jul  6 18:41:18 2003
+++ b/drivers/scsi/NCR_Q720.c	Sun Jul  6 18:41:18 2003
@@ -85,6 +85,7 @@
 	__u8 scsr1 = readb(vaddr + NCR_Q720_SCSR_OFFSET + 1);
 	__u8 differential = readb(vaddr + NCR_Q720_SCSR_OFFSET) & 0x20;
 	__u8 version;
+	int error;
 
 	scsi_id = scsr1 >> 4;
 	/* enable burst length 16 (FIXME: should allow this) */
@@ -120,9 +121,12 @@
 	scsr1 &= ~0x01;
 	writeb(scsr1, vaddr + NCR_Q720_SCSR_OFFSET + 1);
 
-	scsi_add_host(p->hosts[siop], p->dev);
-
-	return 0;
+	error = scsi_add_host(p->hosts[siop], p->dev);
+	if (error)
+		ncr53c8xx_release(p->hosts[siop]);
+	else
+		scsi_scan_host(p->hosts[siop]);
+	return error;
 
  fail:
 	return -ENODEV;
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sun Jul  6 18:41:18 2003
+++ b/drivers/scsi/sd.c	Sun Jul  6 18:41:18 2003
@@ -606,35 +606,8 @@
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct gendisk *gd;
-	struct scsi_request *SRpnt;
-	unsigned char *buffer;
-
-	if (!sdkp || sdp->online == FALSE || !sdkp->media_present)
-		return;
-		
-	gd = sdkp->disk;
-	
-	SCSI_LOG_HLQUEUE(3, printk("sd_rescan: disk=%s\n", gd->disk_name));
-	
-	SRpnt = scsi_allocate_request(sdp);
-	if (!SRpnt) {
-		printk(KERN_WARNING "(sd_rescan:) Request allocation "
-		       "failure.\n");
-		return;
-	}
-
-	if (sdkp->device->host->unchecked_isa_dma)
-		buffer = kmalloc(512, GFP_DMA);
-	else
-		buffer = kmalloc(512, GFP_KERNEL);
-
-    	sd_read_capacity(sdkp, gd->disk_name, SRpnt, buffer);
-	set_capacity(gd, sdkp->capacity);	
-	scsi_release_request(SRpnt);
-	kfree(buffer);
+	sd_revalidate_disk(sdkp->disk);
 }
 
 static struct block_device_operations sd_fops = {
diff -Nru a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
--- a/drivers/scsi/zalon.c	Sun Jul  6 18:41:18 2003
+++ b/drivers/scsi/zalon.c	Sun Jul  6 18:41:18 2003
@@ -85,7 +85,7 @@
 {
 	struct gsc_irq gsc_irq;
 	u32 zalon_vers;
-	int irq;
+	int irq, error = -ENODEV;
 	unsigned long zalon = dev->hpa;
 	unsigned long io_port = zalon + GSC_SCSI_ZALON_OFFSET;
 	static int unit = 0;
@@ -147,11 +147,18 @@
 
 	dev_set_drvdata(&dev->dev, host);
 
-	scsi_add_host(host, &dev->dev);
+	error = scsi_add_host(host, &dev->dev);
+	if (error)
+		goto fail_free_irq;
 
+	scsi_scan_host(host);
 	return 0;
+
+ fail_free_irq:
+	free_irq(irq, host);
  fail:
-	return -ENODEV;
+	ncr53c8xx_release(host);
+	return error;
 }
 
 static struct parisc_device_id zalon_tbl[] = {
