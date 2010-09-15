From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] lpfc: prep for fc host dev loss tmo support
Date: Wed, 15 Sep 2010 16:52:31 -0500
Message-ID: <1284587552-7617-5-git-send-email-michaelc@cs.wisc.edu>
References: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0IOVrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 17:47:11 -0400
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

It also adds compat support for the driver's existing
dev loss and nodev sysfs and modparams.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_attr.c |   16 ++++++----------
 drivers/scsi/lpfc/lpfc_init.c |    2 ++
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 87c2b6b..f6efc6f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2159,6 +2159,11 @@ lpfc_nodev_tmo_set(struct lpfc_vport *vport, int val)
 	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
 		vport->cfg_nodev_tmo = val;
 		vport->cfg_devloss_tmo = val;
+		/*
+		 * For compat: set the fc_host dev loss so new rports
+		 * will get the value.
+		 */
+		fc_host_dev_loss_tmo(lpfc_shost_from_vport(vport)) = val;
 		lpfc_update_rport_devloss_tmo(vport);
 		return 0;
 	}
@@ -2208,6 +2213,7 @@ lpfc_devloss_tmo_set(struct lpfc_vport *vport, int val)
 		vport->cfg_nodev_tmo = val;
 		vport->cfg_devloss_tmo = val;
 		vport->dev_loss_tmo_changed = 1;
+		fc_host_dev_loss_tmo(lpfc_shost_from_vport(vport)) = val;
 		lpfc_update_rport_devloss_tmo(vport);
 		return 0;
 	}
@@ -4370,14 +4376,6 @@ lpfc_get_starget_port_name(struct scsi_target *starget)
 		ndlp ? wwn_to_u64(ndlp->nlp_portname.u.wwn) : 0;
 }
 
-static void
-lpfc_get_host_def_loss_tmo(struct Scsi_Host *shost)
-{
-        struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-
-	fc_host_def_dev_loss_tmo(shost) = vport->cfg_devloss_tmo;
-}
-
 /**
  * lpfc_set_rport_loss_tmo - Set the rport dev loss tmo
  * @rport: fc rport address.
@@ -4486,7 +4484,6 @@ struct fc_function_template lpfc_transport_functions = {
 	.get_host_fabric_name = lpfc_get_host_fabric_name,
 	.show_host_fabric_name = 1,
 
-	.get_host_def_dev_loss_tmo = lpfc_get_host_def_loss_tmo,
 	/*
 	 * The LPFC driver treats linkdown handling as target loss events
 	 * so there are no sysfs handlers for link_down_tmo.
@@ -4554,7 +4551,6 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.get_host_fabric_name = lpfc_get_host_fabric_name,
 	.show_host_fabric_name = 1,
 
-	.get_host_def_dev_loss_tmo = lpfc_get_host_def_loss_tmo,
 	/*
 	 * The LPFC driver treats linkdown handling as target loss events
 	 * so there are no sysfs handlers for link_down_tmo.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index da9ba06..87a4d09 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2817,6 +2817,8 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 		(((uint32_t) vport->fc_sparam.cmn.bbRcvSizeMsb & 0x0F) << 8) |
 		(uint32_t) vport->fc_sparam.cmn.bbRcvSizeLsb;
 
+	fc_host_dev_loss_tmo(shost) = vport->cfg_devloss_tmo;
+
 	/* This value is also unchanging */
 	memset(fc_host_active_fc4s(shost), 0,
 	       sizeof(fc_host_active_fc4s(shost)));
-- 
1.7.2.2

