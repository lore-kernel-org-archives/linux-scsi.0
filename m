From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] lpfc: do not reset dev_loss_tmo in slave callout
Date: Fri,  6 Aug 2010 03:02:39 -0500
Message-ID: <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760668Ab0HFH6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 03:58:47 -0400
In-Reply-To: <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jeykholt@cisco.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This fixes a bug where the driver was resetting the
rport dev_loss_tmo when devices were added by adding
support for the get_host_def_dev_loss_tmo callout.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_attr.c |   10 ++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 868874c..a998375 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4328,6 +4328,14 @@ lpfc_get_starget_port_name(struct scsi_target *starget)
 		ndlp ? wwn_to_u64(ndlp->nlp_portname.u.wwn) : 0;
 }
 
+static void
+lpfc_get_host_def_loss_tmo(struct Scsi_Host *shost)
+{
+        struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+
+	fc_host_def_dev_loss_tmo(shost) = vport->cfg_devloss_tmo;
+}
+
 /**
  * lpfc_set_rport_loss_tmo - Set the rport dev loss tmo
  * @rport: fc rport address.
@@ -4436,6 +4444,7 @@ struct fc_function_template lpfc_transport_functions = {
 	.get_host_fabric_name = lpfc_get_host_fabric_name,
 	.show_host_fabric_name = 1,
 
+	.get_host_def_dev_loss_tmo = lpfc_get_host_def_loss_tmo,
 	/*
 	 * The LPFC driver treats linkdown handling as target loss events
 	 * so there are no sysfs handlers for link_down_tmo.
@@ -4503,6 +4512,7 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.get_host_fabric_name = lpfc_get_host_fabric_name,
 	.show_host_fabric_name = 1,
 
+	.get_host_def_dev_loss_tmo = lpfc_get_host_def_loss_tmo,
 	/*
 	 * The LPFC driver treats linkdown handling as target loss events
 	 * so there are no sysfs handlers for link_down_tmo.
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c818a72..be91350 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3656,7 +3656,6 @@ lpfc_slave_alloc(struct scsi_device *sdev)
  *
  * This routine configures following items
  *   - Tag command queuing support for @sdev if supported.
- *   - Dev loss time out value of fc_rport.
  *   - Enable SLI polling for fcp ring if ENABLE_FCP_RING_POLLING flag is set.
  *
  * Return codes:
@@ -3667,21 +3666,12 @@ lpfc_slave_configure(struct scsi_device *sdev)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct fc_rport   *rport = starget_to_rport(sdev->sdev_target);
 
 	if (sdev->tagged_supported)
 		scsi_activate_tcq(sdev, vport->cfg_lun_queue_depth);
 	else
 		scsi_deactivate_tcq(sdev, vport->cfg_lun_queue_depth);
 
-	/*
-	 * Initialize the fc transport attributes for the target
-	 * containing this scsi device.  Also note that the driver's
-	 * target pointer is stored in the starget_data for the
-	 * driver's sysfs entry point functions.
-	 */
-	rport->dev_loss_tmo = vport->cfg_devloss_tmo;
-
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
-- 
1.6.6.1

