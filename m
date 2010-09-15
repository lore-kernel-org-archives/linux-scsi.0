From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] fnic: prep for fc host dev loss tmo support
Date: Wed, 15 Sep 2010 16:52:28 -0500
Message-ID: <1284587552-7617-2-git-send-email-michaelc@cs.wisc.edu>
References: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0IOVq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 17:46:58 -0400
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

This also adds a set rport dev loss function so the
fc class host dev loss tmp sysfs support being added
in the fc class patch can update rports.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/fnic/fnic_main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index df91a61..bb63f1a 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -110,12 +110,12 @@ static struct scsi_host_template fnic_host_template = {
 };
 
 static void
-fnic_get_host_def_loss_tmo(struct Scsi_Host *shost)
+fnic_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 {
-	struct fc_lport *lp = shost_priv(shost);
-	struct fnic *fnic = lport_priv(lp);
-
-	fc_host_def_dev_loss_tmo(shost) = fnic->config.port_down_timeout / 1000;
+	if (timeout)
+		rport->dev_loss_tmo = timeout;
+	else
+		rport->dev_loss_tmo = 1;
 }
 
 static void fnic_get_host_speed(struct Scsi_Host *shost);
@@ -145,9 +145,9 @@ static struct fc_function_template fnic_fc_functions = {
 	.show_starget_port_name = 1,
 	.show_starget_port_id = 1,
 	.show_rport_dev_loss_tmo = 1,
+	.set_rport_dev_loss_tmo = fnic_set_rport_dev_loss_tmo,
 	.issue_fc_host_lip = fnic_reset,
 	.get_fc_host_stats = fnic_get_stats,
-	.get_host_def_dev_loss_tmo = fnic_get_host_def_loss_tmo,
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.terminate_rport_io = fnic_terminate_rport_io,
 	.bsg_request = fc_lport_bsg_request,
@@ -712,6 +712,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 		goto err_out_free_exch_mgr;
 	}
 	fc_host_maxframe_size(lp->host) = lp->mfs;
+	fc_host_dev_loss_tmo(lp->host) = fnic->config.port_down_timeout / 1000;
 
 	sprintf(fc_host_symbolic_name(lp->host),
 		DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
-- 
1.7.2.2

