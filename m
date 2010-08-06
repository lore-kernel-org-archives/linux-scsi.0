From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] fnic: do not reset dev_loss_tmo in slave callout
Date: Fri,  6 Aug 2010 03:02:40 -0500
Message-ID: <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760668Ab0HFH6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 03:58:51 -0400
In-Reply-To: <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
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
 drivers/scsi/fnic/fnic_main.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 9eb7a9e..df91a61 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -80,8 +80,6 @@ static struct libfc_function_template fnic_transport_template = {
 static int fnic_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	struct fc_lport *lp = shost_priv(sdev->host);
-	struct fnic *fnic = lport_priv(lp);
 
 	sdev->tagged_supported = 1;
 
@@ -89,8 +87,6 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 		return -ENXIO;
 
 	scsi_activate_tcq(sdev, FNIC_DFLT_QUEUE_DEPTH);
-	rport->dev_loss_tmo = fnic->config.port_down_timeout / 1000;
-
 	return 0;
 }
 
@@ -113,6 +109,15 @@ static struct scsi_host_template fnic_host_template = {
 	.shost_attrs = fnic_attrs,
 };
 
+static void
+fnic_get_host_def_loss_tmo(struct Scsi_Host *shost)
+{
+	struct fc_lport *lp = shost_priv(shost);
+	struct fnic *fnic = lport_priv(lp);
+
+	fc_host_def_dev_loss_tmo(shost) = fnic->config.port_down_timeout / 1000;
+}
+
 static void fnic_get_host_speed(struct Scsi_Host *shost);
 static struct scsi_transport_template *fnic_fc_transport;
 static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *);
@@ -142,6 +147,7 @@ static struct fc_function_template fnic_fc_functions = {
 	.show_rport_dev_loss_tmo = 1,
 	.issue_fc_host_lip = fnic_reset,
 	.get_fc_host_stats = fnic_get_stats,
+	.get_host_def_dev_loss_tmo = fnic_get_host_def_loss_tmo,
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.terminate_rport_io = fnic_terminate_rport_io,
 	.bsg_request = fc_lport_bsg_request,
-- 
1.6.6.1

