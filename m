From: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Subject: PATCH for disabling write cache on SATA drives
Date: Fri, 25 Jun 2004 18:21:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1F6D1D1660975A4887628A011443A1BC07734BF9@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2gw-2.online-age.net ([216.35.73.164]:44993 "EHLO
	ext-nj2gw-2.online-age.net") by vger.kernel.org with ESMTP
	id S266347AbUFYXV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 19:21:27 -0400
Received: from int-nj2gw-5.online-age.net (int-nj2gw-5 [3.159.236.69])
	by ext-nj2gw-2.online-age.net (8.12.9/8.12.9/990426-RLH) with ESMTP id i5PNLPNM007124
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2004 19:21:26 -0400 (EDT)
Received: from uswaumsxb1medge.med.ge.com (localhost [127.0.0.1])
	by int-nj2gw-5.online-age.net (8.12.9/8.12.8/990426-RLH) with ESMTP id i5PNLOTa010508
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2004 19:21:25 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


I don't know if this is useful for anyone or if anyone even cares, but just
in case someone does, this is the patch I made to disable the write cache on
the Serial ATA drives.  It doesn't make the write cache controllable from
the user level, it just ALWAYS disables it.  (I tried to make one that could
be sent via an ioctl, but there were far too many things that I didn't
understand and it didn't work.)  Since I have never done this before I don't
know if there is some protocol that I missed, if so I'm sorry.  If there are
glaring stupid mistakes (very likely) please let me know.

Thanks
  -Scott


diff -ru linux-2.6.7/drivers/scsi/libata-core.c
linux-2.6.7-dwc/drivers/scsi/libata-core.c
--- linux-2.6.7/drivers/scsi/libata-core.c	2004-06-15
23:18:38.000000000 -0600
+++ linux-2.6.7-dwc/drivers/scsi/libata-core.c	2004-06-25
16:39:16.000000000 -0600
@@ -55,6 +55,7 @@
 static void ata_host_set_udma(struct ata_port *ap);
 static void ata_dev_set_pio(struct ata_port *ap, unsigned int device);
 static void ata_dev_set_udma(struct ata_port *ap, unsigned int device);
+static void ata_dev_disable_wcache(struct ata_port *ap, unsigned int
device);
 static void ata_set_mode(struct ata_port *ap);
 static int ata_qc_issue_prot(struct ata_queued_cmd *qc);
 
@@ -1111,14 +1112,20 @@
 			dev->n_sectors = ata_id_u32(dev, 60);
 		}
 
+		if (dev->id[85] & (1 << 5)) {
+			dev->flags |= ATA_DFLAG_WCACHE;
+		}
+
 		ap->host->max_cmd_len = 16;
 
 		/* print device info to dmesg */
-		printk(KERN_INFO "ata%u: dev %u ATA, max %s, %Lu
sectors:%s\n",
+		printk(KERN_INFO 
+		       "ata%u: dev %u ATA, max %s, %Lu sectors:%s,
wcache:%s\n",
 		       ap->id, device,
 		       ata_udma_string(udma_modes),
 		       (unsigned long long)dev->n_sectors,
-		       dev->flags & ATA_DFLAG_LBA48 ? " lba48" : "");
+		       dev->flags & ATA_DFLAG_LBA48 ? " lba48" : "",
+		       dev->flags & ATA_DFLAG_WCACHE ? "on" : "off");
 	}
 
 	/* ATAPI-specific feature tests */
@@ -1297,6 +1304,12 @@
 		ata_dev_set_udma(ap, 1);
 	}
 
+	if (ap->device[0]->flags & ATA_DFLAG_WCACHE)
+		ata_dev_disable_wcache(ap, 0);
+
+	if (ap->device[1]->flags & ATA_DFLAG_WCACHE)
+		ata_dev_disable_wcache(ap, 1);
+
 	if (ap->flags & ATA_FLAG_PORT_DISABLED)
 		return;
 
@@ -1680,6 +1693,43 @@
 	ap->ops->port_disable(ap);
 }
 
+static void ata_dev_disable_wcache(struct ata_port *ap, unsigned int
device)
+{
+	struct ata_taskfile tf;
+
+	struct ata_device *dev = &ap->device[device];
+
+	if (!ata_dev_present(dev) || (ap->flags & ATA_FLAG_PORT_DISABLED))
+		return;
+
+	printk(KERN_INFO "disable write cache on dev: %u\n", device);
+
+	/* set up set-features taskfile */
+	DPRINTK("set features - disable write cache\n");
+	ata_tf_init(ap, &tf, dev->devno);
+	tf.ctl |= ATA_NIEN;
+	tf.command = ATA_CMD_SET_FEATURES;
+	tf.feature = SETFEATURES_XFER;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_NODATA;
+	tf.nsect = DISABLE_WRITE_CACHE;
+
+	/* do bus reset */
+	ata_tf_to_host(ap, &tf);
+
+	/* crazy ATAPI devices... */
+	if (dev->class == ATA_DEV_ATAPI)
+		msleep(150);
+
+	ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+
+	ata_irq_on(ap);	/* re-enable interrupts */
+
+	ata_wait_idle(ap);
+
+	DPRINTK("EXIT\n");
+}
+
 /**
  *	ata_dev_set_xfermode - Issue SET FEATURES - XFER MODE command
  *	@ap: Port associated with device @dev
diff -ru linux-2.6.7/include/linux/ata.h linux-2.6.7-dwc/include/linux/ata.h
--- linux-2.6.7/include/linux/ata.h	2004-06-15 23:19:36.000000000 -0600
+++ linux-2.6.7-dwc/include/linux/ata.h	2004-06-25 16:19:14.000000000 -0600
@@ -133,6 +133,8 @@
 	XFER_UDMA_0		= 0x40,
 	XFER_PIO_4		= 0x0C,
 	XFER_PIO_3		= 0x0B,
+	ENABLE_WRITE_CACHE      = 0x02,
+	DISABLE_WRITE_CACHE     = 0x82,
 
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),


