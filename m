From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Make max_requests module parameter more accurate
Date: Wed, 17 Dec 2008 17:19:33 -0600
Message-ID: <200812180020.mBI0KjXi011701@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54073 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYLQXUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 18:20:36 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mBHNJjk4013462
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 18:19:45 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBHNKZ1B157912
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 18:20:35 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBI0KjA6011767
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 19:20:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


In a previous patch to fix an issue with error recovery,
the behavior of the max_requests module paramater was also
changed. If, for some reason, max_requests is set to one by
the user, we will end up with a negative number for can_queue.
Fix this by making max_requests not include the two event structs
needed to do error recovery.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_can_queue_fix drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_can_queue_fix	2008-12-15 15:23:33.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-12-15 15:23:33.000000000 -0600
@@ -89,6 +89,7 @@ static int max_id = 64;
 static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
+static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -1633,7 +1634,7 @@ static struct scsi_host_template driver_
 static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
 {
 	/* iu_storage data allocated in initialize_event_pool */
-	unsigned long desired_io = max_requests * sizeof(union viosrp_iu);
+	unsigned long desired_io = max_events * sizeof(union viosrp_iu);
 
 	/* add io space for sg data */
 	desired_io += (IBMVSCSI_MAX_SECTORS_DEFAULT * 512 *
@@ -1657,7 +1658,6 @@ static int ibmvscsi_probe(struct vio_dev
 
 	vdev->dev.driver_data = NULL;
 
-	driver_template.can_queue = max_requests - 2;
 	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
 	if (!host) {
 		dev_err(&vdev->dev, "couldn't allocate host data\n");
@@ -1673,12 +1673,12 @@ static int ibmvscsi_probe(struct vio_dev
 	atomic_set(&hostdata->request_limit, -1);
 	hostdata->host->max_sectors = IBMVSCSI_MAX_SECTORS_DEFAULT;
 
-	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_requests);
+	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_events);
 	if (rc != 0 && rc != H_RESOURCE) {
 		dev_err(&vdev->dev, "couldn't initialize crq. rc=%d\n", rc);
 		goto init_crq_failed;
 	}
-	if (initialize_event_pool(&hostdata->pool, max_requests, hostdata) != 0) {
+	if (initialize_event_pool(&hostdata->pool, max_events, hostdata) != 0) {
 		dev_err(&vdev->dev, "couldn't initialize event pool\n");
 		goto init_pool_failed;
 	}
@@ -1730,7 +1730,7 @@ static int ibmvscsi_probe(struct vio_dev
       add_host_failed:
 	release_event_pool(&hostdata->pool, hostdata);
       init_pool_failed:
-	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata, max_requests);
+	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata, max_events);
       init_crq_failed:
 	scsi_host_put(host);
       scsi_host_alloc_failed:
@@ -1742,7 +1742,7 @@ static int ibmvscsi_remove(struct vio_de
 	struct ibmvscsi_host_data *hostdata = vdev->dev.driver_data;
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
-					max_requests);
+					max_events);
 
 	srp_remove_host(hostdata->host);
 	scsi_remove_host(hostdata->host);
@@ -1779,6 +1779,10 @@ int __init ibmvscsi_module_init(void)
 {
 	int ret;
 
+	/* Ensure we have two requests to do error recovery */
+	driver_template.can_queue = max_requests;
+	max_events = max_requests + 2;
+
 	if (firmware_has_feature(FW_FEATURE_ISERIES))
 		ibmvscsi_ops = &iseriesvscsi_ops;
 	else if (firmware_has_feature(FW_FEATURE_VIO))
_
