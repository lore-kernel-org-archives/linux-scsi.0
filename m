From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/64] ibmvscsi: gadget: at91_udc: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:40 -0700
Message-ID: <1245131213-24168-51-git-send-email-gregkh@suse.de>
References: <20090616051351.GA23627@kroah.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899AbZFPFvh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:37 -0400
In-Reply-To: <20090616051351.GA23627@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>

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

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 11d2602..869a11b 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1877,7 +1877,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	unsigned long wait_switch = 0;
 	int rc;
 
-	vdev->dev.driver_data = NULL;
+	dev_set_drvdata(&vdev->dev, NULL);
 
 	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
 	if (!host) {
@@ -1949,7 +1949,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 			scsi_scan_host(host);
 	}
 
-	vdev->dev.driver_data = hostdata;
+	dev_set_drvdata(&vdev->dev, hostdata);
 	return 0;
 
       add_srp_port_failed:
@@ -1968,7 +1968,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
-	struct ibmvscsi_host_data *hostdata = vdev->dev.driver_data;
+	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
 	unmap_persist_bufs(hostdata);
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index e2dd6a4..d5eaf97 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -892,7 +892,7 @@ free_vport:
 
 static int ibmvstgt_remove(struct vio_dev *dev)
 {
-	struct srp_target *target = (struct srp_target *) dev->dev.driver_data;
+	struct srp_target *target = dev_get_drvdata(&dev->dev);
 	struct Scsi_Host *shost = target->shost;
 	struct vio_port *vport = target->ldata;
 
-- 
1.6.3.2

