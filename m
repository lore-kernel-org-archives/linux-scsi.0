From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] missing scsi_host_alloc bits
Date: Fri, 6 Jun 2003 16:50:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606145038.GA23846@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:61397 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261808AbTFFOhH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:37:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Sorry, I sent you the old patch again.  Here's the missing driver bits.


diff -Nru a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c	Thu Jun  5 18:39:39 2003
+++ b/drivers/scsi/ips.c	Thu Jun  5 18:39:39 2003
@@ -725,7 +725,7 @@
    free_irq(ha->irq, ha);
 
    IPS_REMOVE_HOST(sh);
-   scsi_unregister(sh);
+   scsi_host_put(sh);
 
    ips_released_controllers++;
 
@@ -6732,7 +6732,7 @@
 ips_register_scsi( int index){
 	struct Scsi_Host *sh;
 	ips_ha_t *ha, *oldha = ips_ha[index];
-	sh = scsi_register(&ips_driver_template, sizeof(ips_ha_t));
+	sh = scsi_host_alloc(&ips_driver_template, sizeof(ips_ha_t));
 	if(!sh) {
 		IPS_PRINTK(KERN_WARNING, oldha->pcidev, "Unable to register controller with SCSI subsystem\n");
 		return -1;
@@ -6743,7 +6743,7 @@
 	/* Install the interrupt handler with the new ha */
 	if (request_irq(ha->irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to install interrupt handler\n" );
-		scsi_unregister(sh);
+		scsi_host_put(sh);
 		return -1;
 	}
 
diff -Nru a/drivers/usb/image/hpusbscsi.c b/drivers/usb/image/hpusbscsi.c
--- a/drivers/usb/image/hpusbscsi.c	Thu Jun  5 18:39:39 2003
+++ b/drivers/usb/image/hpusbscsi.c	Thu Jun  5 18:39:39 2003
@@ -45,7 +45,7 @@
 	struct usb_host_interface *altsetting =	intf->altsetting;
 	struct hpusbscsi *new;
 	int error = -ENOMEM;
-	int i, result;
+	int i;
 
 	if (altsetting->desc.bNumEndpoints != 3) {
 		printk (KERN_ERR "Wrong number of endpoints\n");
@@ -104,7 +104,7 @@
 		goto out_free_controlurb;
 
 	/* In host->hostdata we store a pointer to desc */
-	new->host = scsi_register(&hpusbscsi_scsi_host_template, sizeof(new));
+	new->host = scsi_host_alloc(&hpusbscsi_scsi_host_template, sizeof(new));
 	if (!new->host)
 		goto out_unlink_controlurb;
 
@@ -137,7 +137,7 @@
 
 	scsi_remove_host(desc->host);
 	usb_unlink_urb(desc->controlurb);
-	scsi_unregister(desc->host);
+	scsi_host_put(desc->host);
 
 	usb_free_urb(desc->controlurb);
 	usb_free_urb(desc->dataurb);
diff -Nru a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
--- a/drivers/usb/image/microtek.c	Thu Jun  5 18:39:39 2003
+++ b/drivers/usb/image/microtek.c	Thu Jun  5 18:39:39 2003
@@ -811,7 +811,7 @@
 		MTS_WARNING( "will this work? Image data EP is not usually %d\n",
 			     (int)new_desc->ep_image );
 
-	new_desc->host = scsi_register(&mts_scsi_host_template,
+	new_desc->host = scsi_host_alloc(&mts_scsi_host_template,
 			sizeof(new_desc));
 	if (!new_desc->host)
 		goto out_free_urb;
@@ -838,7 +838,7 @@
 
 	scsi_remove_host(desc->host);
 	usb_unlink_urb(desc->urb);
-	scsi_unregister(desc->host);
+	scsi_host_put(desc->host);
 
 	usb_free_urb(desc->urb);
 	kfree(desc);
