From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x - 3/3 fix-failures
Date: Sun, 3 Aug 2003 18:29:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030803082929.GC4611@twibble.org>
References: <20030803082718.GA4594@twibble.org> <20030803082759.GA4611@twibble.org> <20030803082836.GB4611@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:41139 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S270823AbTHCI3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2003 04:29:37 -0400
Content-Disposition: inline
In-Reply-To: <20030803082836.GB4611@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Handle the case where scsi_add_host fails and update the removal
function to correctly unregister everything.

diff -r -du a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-03 18:09:08.178692696 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-03 18:09:11.006262840 +1000
@@ -5807,6 +5807,7 @@
 	u8 irq;
 	struct Scsi_Host *scsi_host;
 	static int banner_done = 0;
+	int error = 0;
 
 	dprintkdbg(DBG_0, "Init one instance of the dc395x\n");
 	if (!banner_done)
@@ -5832,20 +5833,21 @@
 		dprintkdbg(DBG_0, "host_init failed\n");
 		return -ENOMEM;
 	}
-
-	pci_set_master(dev);
-
-	/* store pci devices in out host data object. */
 	((struct AdapterCtlBlk *)(scsi_host->hostdata))->dev = dev;
-
-	/* store ptr to scsi host in the PCI device structure */
+	pci_set_master(dev);
 	pci_set_drvdata(dev, scsi_host);
 
 	/* get the scsi mid level to scan for new devices on the bus */
-	scsi_add_host(scsi_host, &dev->dev);	/* XXX handle failure */
-	scsi_scan_host(scsi_host);
-
-	return 0;
+	error = scsi_add_host(scsi_host, &dev->dev);
+	if (error) {
+		dprintkl(KERN_ERR, "scsi_add_host failed\n");
+                error = -ENODEV;
+                host_release(scsi_host);
+                scsi_host_put(scsi_host);
+	} else
+        	scsi_scan_host(scsi_host);
+        	
+	return error;
 }
 
 
@@ -5858,9 +5860,18 @@
 static void __devexit dc395x_remove_one(struct pci_dev *dev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(dev);
+
 	dprintkdbg(DBG_0, "Removing instance\n");
-	scsi_remove_host(host);
+	if (!host) {
+		dprintkl(KERN_ERR, "no host allocated\n");
+		return;
+	}
+	if (scsi_remove_host(host)) {
+		dprintkl(KERN_ERR, "scsi_remove_host failed\n");
+		return;
+	}
 	host_release(host);
+	scsi_host_put(host);
 	pci_set_drvdata(dev, NULL);
 }
 

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
