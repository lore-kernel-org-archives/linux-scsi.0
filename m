From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Don't fail EH due to insufficient resources
Date: Mon, 08 Dec 2008 17:01:47 -0600
Message-ID: <200812090002.mB902llg031906@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41433 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbYLHXCj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 18:02:39 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB8N228p007223
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 18:02:02 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB8N2cdS198692
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 18:02:38 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB902mrI031932
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 19:02:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, santil@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


The ibmvscsi driver currently has a bug in it which can result
in it using up all its event structs for commands. If something
results in all those commands timing out, we won't have any resources
left to send aborts or resets. This results in escalating to a host reset
in order to recover, which is a bit heavy handed. This fixes it
by reducing can_queue by two in order to have resources to do EH.
It also changes the max_requests module parameter so that it is not
writable at runtime, since the code really does not handle it changing
at runtime.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_save_events_for_eh drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_save_events_for_eh	2008-12-08 15:07:08.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-12-08 15:09:28.000000000 -0600
@@ -107,7 +107,7 @@ module_param_named(max_channel, max_chan
 MODULE_PARM_DESC(max_channel, "Largest channel value");
 module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
-module_param_named(max_requests, max_requests, int, S_IRUGO | S_IWUSR);
+module_param_named(max_requests, max_requests, int, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
 
 /* ------------------------------------------------------------
@@ -1657,7 +1657,7 @@ static int ibmvscsi_probe(struct vio_dev
 
 	vdev->dev.driver_data = NULL;
 
-	driver_template.can_queue = max_requests;
+	driver_template.can_queue = max_requests - 2;
 	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
 	if (!host) {
 		dev_err(&vdev->dev, "couldn't allocate host data\n");
_
