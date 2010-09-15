From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] ibmvfc: prep for fc host dev loss tmo support
Date: Wed, 15 Sep 2010 16:52:29 -0500
Message-ID: <1284587552-7617-3-git-send-email-michaelc@cs.wisc.edu>
References: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0IOVrA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 17:47:00 -0400
In-Reply-To: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This removes the driver's get_host_def_dev_loss_tmo
callback and just has the driver set the dev loss
using the fc class fc_host_dev_loss_tmo macro like is
done for other fc params.

This patch also removes the module dev loss param.
To override the value the fc host sysfs value being
added in the fc class patch can be used instead of the driver
module param.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a5dd9b4..da0926c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -50,7 +50,6 @@ static unsigned int max_lun = IBMVFC_MAX_LUN;
 static unsigned int max_targets = IBMVFC_MAX_TARGETS;
 static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
-static unsigned int dev_loss_tmo = IBMVFC_DEV_LOSS_TMO;
 static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
 static unsigned int log_level = IBMVFC_DEFAULT_LOG_LEVEL;
 static LIST_HEAD(ibmvfc_head);
@@ -84,11 +83,6 @@ MODULE_PARM_DESC(disc_threads, "Number of device discovery threads to use. "
 module_param_named(debug, ibmvfc_debug, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable driver debug information. "
 		 "[Default=" __stringify(IBMVFC_DEBUG) "]");
-module_param_named(dev_loss_tmo, dev_loss_tmo, uint, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(dev_loss_tmo, "Maximum number of seconds that the FC "
-		 "transport should insulate the loss of a remote port. Once this "
-		 "value is exceeded, the scsi target is removed. "
-		 "[Default=" __stringify(IBMVFC_DEV_LOSS_TMO) "]");
 module_param_named(log_level, log_level, uint, 0);
 MODULE_PARM_DESC(log_level, "Set to 0 - 4 for increasing verbosity of device driver. "
 		 "[Default=" __stringify(IBMVFC_DEFAULT_LOG_LEVEL) "]");
@@ -1030,11 +1024,6 @@ static void ibmvfc_get_host_port_state(struct Scsi_Host *shost)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-static void ibmvfc_set_host_def_dev_loss_tmo(struct Scsi_Host *shost)
-{
-	fc_host_def_dev_loss_tmo(shost) = dev_loss_tmo;
-}
-
 /**
  * ibmvfc_set_rport_dev_loss_tmo - Set rport's device loss timeout
  * @rport:		rport struct
@@ -4746,6 +4735,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if ((rc = scsi_add_host(shost, dev)))
 		goto release_event_pool;
 
+	fc_host_dev_loss_tmo(shost) = IBMVFC_DEV_LOSS_TMO;
+
 	if ((rc = ibmvfc_create_trace_file(&shost->shost_dev.kobj,
 					   &ibmvfc_trace_attr))) {
 		dev_err(dev, "Failed to create trace file. rc=%d\n", rc);
@@ -4891,8 +4882,6 @@ static struct fc_function_template ibmvfc_transport_functions = {
 	.get_host_speed = ibmvfc_get_host_speed,
 	.show_host_speed = 1,
 
-	.get_host_def_dev_loss_tmo = ibmvfc_set_host_def_dev_loss_tmo,
-
 	.issue_fc_host_lip = ibmvfc_issue_fc_host_lip,
 	.terminate_rport_io = ibmvfc_terminate_rport_io,
 
-- 
1.7.2.2

