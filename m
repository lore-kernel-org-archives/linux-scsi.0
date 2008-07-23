From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 14/16 v4] ibmvscsi: driver enablement for CMO
Date: Wed, 23 Jul 2008 13:35:27 -0500
Message-ID: <20080723183527.GQ12905@linux.vnet.ibm.com>
References: <20080723181932.GC12905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:56059 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYGWSfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 14:35:32 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6NIZULx019611
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 14:35:30 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6NIZSaQ166910
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 12:35:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6NIZRE6000935
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 12:35:28 -0600
Content-Disposition: inline
In-Reply-To: <20080723181932.GC12905@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: paulus@samba.org, benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Santiago Leon <santil@us.ibm.com>, Nathan Fontenot <nfont@austin.ibm.com>, David Darrington <ddarring@linux.vnet.ibm.com>

From: Robert Jennings <rcj@linux.vnet.ibm.com>

Enable the driver to function in a Cooperative Memory Overcommitment (CMO)
environment.

The following changes are made to enable the driver for CMO:
 * DMA mapping errors will not result in error messages if entitlement has
   been exceeded and resources were not available.
 * The driver has a get_desired_dma function defined to function
   in a CMO environment. It will indicate how much IO memory it would like
   to function.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Acked by: Brian King <brking@linux.vnet.ibm.com>

---
We would like to take this patch through linuxppc-dev with the full
change set for this feature.  We are copying linux-scsi for review and ack.

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   45 +++++++++++++++++++++++++++++++++------
 drivers/scsi/ibmvscsi/ibmvscsi.h |    2 ++
 2 files changed, 40 insertions(+), 7 deletions(-)

Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -72,6 +72,7 @@
 #include <linux/delay.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
+#include <asm/firmware.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -426,8 +427,10 @@ static int map_sg_data(struct scsi_cmnd 
 					   SG_ALL * sizeof(struct srp_direct_buf),
 					   &evt_struct->ext_list_token, 0);
 		if (!evt_struct->ext_list) {
-			sdev_printk(KERN_ERR, cmd->device,
-				    "Can't allocate memory for indirect table\n");
+			if (!firmware_has_feature(FW_FEATURE_CMO))
+				sdev_printk(KERN_ERR, cmd->device,
+				            "Can't allocate memory "
+				            "for indirect table\n");
 			return 0;
 		}
 	}
@@ -743,7 +746,9 @@ static int ibmvscsi_queuecommand(struct 
 	srp_cmd->lun = ((u64) lun) << 48;
 
 	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)) {
-		sdev_printk(KERN_ERR, cmnd->device, "couldn't convert cmd to srp_cmd\n");
+		if (!firmware_has_feature(FW_FEATURE_CMO))
+			sdev_printk(KERN_ERR, cmnd->device,
+			            "couldn't convert cmd to srp_cmd\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -855,7 +860,10 @@ static void send_mad_adapter_info(struct
 					    DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(req->buffer)) {
-		dev_err(hostdata->dev, "Unable to map request_buffer for adapter_info!\n");
+		if (!firmware_has_feature(FW_FEATURE_CMO))
+			dev_err(hostdata->dev,
+			        "Unable to map request_buffer for "
+			        "adapter_info!\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return;
 	}
@@ -1400,7 +1408,9 @@ static int ibmvscsi_do_host_config(struc
 						    DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(host_config->buffer)) {
-		dev_err(hostdata->dev, "dma_mapping error getting host config\n");
+		if (!firmware_has_feature(FW_FEATURE_CMO))
+			dev_err(hostdata->dev,
+			        "dma_mapping error getting host config\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return -1;
 	}
@@ -1604,7 +1614,7 @@ static struct scsi_host_template driver_
 	.eh_host_reset_handler = ibmvscsi_eh_host_reset_handler,
 	.slave_configure = ibmvscsi_slave_configure,
 	.change_queue_depth = ibmvscsi_change_queue_depth,
-	.cmd_per_lun = 16,
+	.cmd_per_lun = IBMVSCSI_CMDS_PER_LUN_DEFAULT,
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
@@ -1613,6 +1623,26 @@ static struct scsi_host_template driver_
 };
 
 /**
+ * ibmvscsi_get_desired_dma - Calculate IO memory desired by the driver
+ *
+ * @vdev: struct vio_dev for the device whose desired IO mem is to be returned
+ *
+ * Return value:
+ *	Number of bytes of IO data the driver will need to perform well.
+ */
+static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
+{
+	/* iu_storage data allocated in initialize_event_pool */
+	unsigned long desired_io = max_requests * sizeof(union viosrp_iu);
+
+	/* add io space for sg data */
+	desired_io += (IBMVSCSI_MAX_SECTORS_DEFAULT *
+	                     IBMVSCSI_CMDS_PER_LUN_DEFAULT);
+
+	return desired_io;
+}
+
+/**
  * Called by bus code for each adapter
  */
 static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
@@ -1641,7 +1671,7 @@ static int ibmvscsi_probe(struct vio_dev
 	hostdata->host = host;
 	hostdata->dev = dev;
 	atomic_set(&hostdata->request_limit, -1);
-	hostdata->host->max_sectors = 32 * 8; /* default max I/O 32 pages */
+	hostdata->host->max_sectors = IBMVSCSI_MAX_SECTORS_DEFAULT;
 
 	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_requests);
 	if (rc != 0 && rc != H_RESOURCE) {
@@ -1735,6 +1765,7 @@ static struct vio_driver ibmvscsi_driver
 	.id_table = ibmvscsi_device_table,
 	.probe = ibmvscsi_probe,
 	.remove = ibmvscsi_remove,
+	.get_desired_dma = ibmvscsi_get_desired_dma,
 	.driver = {
 		.name = "ibmvscsi",
 		.owner = THIS_MODULE,
Index: b/drivers/scsi/ibmvscsi/ibmvscsi.h
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -45,6 +45,8 @@ struct Scsi_Host;
 #define MAX_INDIRECT_BUFS 10
 
 #define IBMVSCSI_MAX_REQUESTS_DEFAULT 100
+#define IBMVSCSI_CMDS_PER_LUN_DEFAULT 16
+#define IBMVSCSI_MAX_SECTORS_DEFAULT 256 /* 32 * 8 = default max I/O 32 pages */
 #define IBMVSCSI_MAX_CMDS_PER_LUN 64
 
 /* ------------------------------------------------------------
