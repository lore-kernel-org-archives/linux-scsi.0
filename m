From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] ibmvscsi: gadget: at91_udc: remove driver_data direct
	access of struct device
Date: Mon, 4 May 2009 12:59:44 -0700
Message-ID: <20090504195944.GA22706@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZEDUFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2009 16:05:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    6 +++---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1657,7 +1657,7 @@ static int ibmvscsi_probe(struct vio_dev
 	unsigned long wait_switch = 0;
 	int rc;
 
-	vdev->dev.driver_data = NULL;
+	dev_set_drvdata(&vdev->dev, NULL);
 
 	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
 	if (!host) {
@@ -1723,7 +1723,7 @@ static int ibmvscsi_probe(struct vio_dev
 			scsi_scan_host(host);
 	}
 
-	vdev->dev.driver_data = hostdata;
+	dev_set_drvdata(&vdev->dev, hostdata);
 	return 0;
 
       add_srp_port_failed:
@@ -1740,7 +1740,7 @@ static int ibmvscsi_probe(struct vio_dev
 
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
-	struct ibmvscsi_host_data *hostdata = vdev->dev.driver_data;
+	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -892,7 +892,7 @@ free_vport:
 
 static int ibmvstgt_remove(struct vio_dev *dev)
 {
-	struct srp_target *target = (struct srp_target *) dev->dev.driver_data;
+	struct srp_target *target = dev_get_drvdata(&dev->dev);
 	struct Scsi_Host *shost = target->shost;
 	struct vio_port *vport = target->ldata;
 
