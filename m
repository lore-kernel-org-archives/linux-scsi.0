From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] complain about missing host template initializations
Date: Sat, 30 Nov 2002 01:03:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021130010347.A14052@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Currently scsi_register_host silently fixes up missing initializations
of max_sectors and release.  Add some printks complaining about this
so we can get rid of it sooner or later.


--- 1.38/drivers/scsi/hosts.c	Thu Nov 28 02:02:19 2002
+++ edited/drivers/scsi/hosts.c	Fri Nov 29 23:56:41 2002
@@ -171,14 +171,14 @@
 }
 
 /**
- * scsi_host_generic_release - default release function for hosts
+ * scsi_host_legacy_release - default release function for hosts
  * @shost: 
  * 
  * Description:
  * 	This is the default case for the release function.  Its completely
  *	useless for anything but old ISA adapters
  **/
-static void scsi_host_legacy_release(struct Scsi_Host *shost)
+static int scsi_host_legacy_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
@@ -186,6 +186,8 @@
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
+
+	return 0;
 }
 
 static int scsi_remove_legacy_host(struct Scsi_Host *shost)
@@ -193,14 +195,8 @@
 	int error;
 
 	error = scsi_remove_host(shost);
-	if (error)
-		return error;
-
-	if (shost->hostt->release)
+	if (!error)
 		(*shost->hostt->release)(shost);
-	else
-		scsi_host_legacy_release(shost);
-
 	return 0;
 }
 
@@ -487,27 +483,22 @@
 {
 	struct Scsi_Host *shost;
 
-	/*
-	 * Check no detect routine.
-	 */
-	if (!shost_tp->detect)
-		return 1;
+	BUG_ON(!shost_tp->detect);
 
-	/* If max_sectors isn't set, default to max */
-	if (!shost_tp->max_sectors)
+	if (!shost_tp->max_sectors) {
+		printk(KERN_WARNING
+		    "scsi HBA driver %s didn't set max_sectors, "
+		    "please fix the template", shost_tp->name);
 		shost_tp->max_sectors = 1024;
+	}
 
-	/*
-	 * The detect routine must carefully spinunlock/spinlock if it
-	 * enables interrupts, since all interrupt handlers do spinlock as
-	 * well.
-	 */
+	if (!shost_tp->release) {
+		printk(KERN_WARNING
+		    "scsi HBA driver %s didn't set a release method, "
+		    "please fix the template", shost_tp->name);
+		shost_tp->release = &scsi_host_legacy_release;
+	}
 
-	/*
-	 * detect should do its own locking
-	 * FIXME present is now set is scsi_register which breaks manual
-	 * registration code below.
-	 */
 	shost_tp->detect(shost_tp);
 	if (!shost_tp->present)
 		return 0;
