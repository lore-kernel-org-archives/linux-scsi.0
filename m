From: Jamie Lenehan <lenehan@twibble.org>
Subject: [2.6 patch] SCSI dc395x.c: Call pci_disable during cleanup.
Date: Tue, 16 Nov 2004 07:30:11 +1100
Message-ID: <20041115203011.GB26952@twibble.org>
References: <20041115015609.GG2249@stusta.de> <20041115202231.GA26873@twibble.org> <20041115202633.GA26928@twibble.org> <20041115202853.GA26952@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nynaeve.twibble.org ([202.173.155.194]:3993 "EHLO
	nynaeve.twibble.org") by vger.kernel.org with ESMTP id S261686AbUKOUaM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:30:12 -0500
Content-Disposition: inline
In-Reply-To: <20041115202853.GA26952@twibble.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Call pci_disable_device if initialisation fails and during cleanup.

Signed-off-by: Jamie Lenehan <lenehan@twibble.org>

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-06-30 20:33:16.815742524 +1000
+++ b/drivers/scsi/dc395x.c	2004-06-30 20:37:59.465770335 +1000
@@ -4789,8 +4789,8 @@
 static int __devinit dc395x_init_one(struct pci_dev *dev,
 		const struct pci_device_id *id)
 {
-	struct Scsi_Host *scsi_host;
-	struct AdapterCtlBlk *acb;
+	struct Scsi_Host *scsi_host = NULL;
+	struct AdapterCtlBlk *acb = NULL;
 	unsigned long io_port_base;
 	unsigned int io_port_len;
 	unsigned int irq;
@@ -4813,7 +4813,7 @@
 				    sizeof(struct AdapterCtlBlk));
 	if (!scsi_host) {
 		dprintkl(KERN_INFO, "scsi_host_alloc failed\n");
-		return -ENOMEM;
+		goto fail;
 	}
  	acb = (struct AdapterCtlBlk*)scsi_host->hostdata;
  	acb->scsi_host = scsi_host;
@@ -4822,8 +4822,7 @@
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
 		dprintkl(KERN_INFO, "adapter init failed\n");
-		scsi_host_put(scsi_host);
-		return -ENODEV;
+		goto fail;
 	}
 
 	pci_set_master(dev);
@@ -4831,14 +4830,20 @@
 	/* get the scsi mid level to scan for new devices on the bus */
 	if (scsi_add_host(scsi_host, &dev->dev)) {
 		dprintkl(KERN_ERR, "scsi_add_host failed\n");
-		adapter_uninit(acb);
-		scsi_host_put(scsi_host);
-		return -ENODEV;
+		goto fail;
 	}
 	pci_set_drvdata(dev, scsi_host);
 	scsi_scan_host(scsi_host);
         	
 	return 0;
+
+fail:
+	if (acb != NULL)
+		adapter_uninit(acb);
+	if (scsi_host != NULL)
+		scsi_host_put(scsi_host);
+	pci_disable_device(dev);
+	return -ENODEV;
 }
 
 
@@ -4857,6 +4862,7 @@
 
 	scsi_remove_host(scsi_host);
 	adapter_uninit(acb);
+	pci_disable_device(dev);
 	scsi_host_put(scsi_host);
 	pci_set_drvdata(dev, NULL);
 }

-- 
 Jamie Lenehan <lenehan@twibble.org>
