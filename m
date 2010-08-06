From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] ibmvfc: do not reset dev_loss_tmo in slave callout
Date: Fri,  6 Aug 2010 03:02:41 -0500
Message-ID: <1281081761-24586-6-git-send-email-michaelc@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853Ab0HFH7D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 03:59:03 -0400
In-Reply-To: <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jeykholt@cisco.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This fixes a bug where the driver was resetting the
rport dev_loss_tmo when devices were added by adding
support for the get_host_def_dev_loss_tmo callout.

Patch has only been compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bd96cec..56b68a8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1027,6 +1027,11 @@ static void ibmvfc_get_host_port_state(struct Scsi_Host *shost)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
+static void ibmvfc_set_host_def_dev_loss_tmo(struct Scsi_Host *shost)
+{
+	fc_host_def_dev_loss_tmo(shost) = dev_loss_tmo;
+}
+
 /**
  * ibmvfc_set_rport_dev_loss_tmo - Set rport's device loss timeout
  * @rport:		rport struct
@@ -2751,7 +2756,6 @@ static int ibmvfc_target_alloc(struct scsi_target *starget)
 static int ibmvfc_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
-	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -2763,8 +2767,6 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
 		scsi_activate_tcq(sdev, sdev->queue_depth);
 	} else
 		scsi_deactivate_tcq(sdev, sdev->queue_depth);
-
-	rport->dev_loss_tmo = dev_loss_tmo;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return 0;
 }
@@ -4847,6 +4849,8 @@ static struct fc_function_template ibmvfc_transport_functions = {
 	.get_host_speed = ibmvfc_get_host_speed,
 	.show_host_speed = 1,
 
+	.get_host_def_dev_loss_tmo = ibmvfc_set_host_def_dev_loss_tmo,
+
 	.issue_fc_host_lip = ibmvfc_issue_fc_host_lip,
 	.terminate_rport_io = ibmvfc_terminate_rport_io,
 
-- 
1.6.6.1

