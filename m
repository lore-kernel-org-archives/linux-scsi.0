From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 09/10] ibmvfc: Improve LOGO/PRLO ELS handling
Date: Thu, 28 May 2009 16:17:33 -0500
Message-ID: <200905282115.n4SLFREd030795@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50999 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763187AbZE1VRc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 17:17:32 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLBwSA026254
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:11:58 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHYTg232550
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:34 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLFRer030822
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:15:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


There are several scenarios where the ibmvfc driver needs to
try to log back into a target on the fabric. Today when these events
occur, we simply go through re-discovery for all attached targets,
assuming that either the query of the name server or an ADISC will
indicate we might need to log back into the target, which doesn't
work for all scenarios. Fix this by taking note of the affected target(s)
in these conditions and ensuring we try to PLOGI back into the target.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_better_relogin drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_better_relogin	2009-05-20 10:30:06.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-05-20 10:30:06.000000000 -0500
@@ -1485,6 +1485,27 @@ static void ibmvfc_log_error(struct ibmv
 }
 
 /**
+ * ibmvfc_relogin - Log back into the specified device
+ * @sdev:	scsi device struct
+ *
+ **/
+static void ibmvfc_relogin(struct scsi_device *sdev)
+{
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct ibmvfc_target *tgt;
+
+	list_for_each_entry(tgt, &vhost->targets, queue) {
+		if (rport == tgt->rport) {
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			break;
+		}
+	}
+
+	ibmvfc_reinit_host(vhost);
+}
+
+/**
  * ibmvfc_scsi_done - Handle responses from commands
  * @evt:	ibmvfc event to be handled
  *
@@ -1516,7 +1537,7 @@ static void ibmvfc_scsi_done(struct ibmv
 			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len && rsp_len <= 8)
 				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);
 			if ((vfc_cmd->status & IBMVFC_VIOS_FAILURE) && (vfc_cmd->error == IBMVFC_PLOGI_REQUIRED))
-				ibmvfc_reinit_host(evt->vhost);
+				ibmvfc_relogin(cmnd->device);
 
 			if (!cmnd->result && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESID_OVER)))
 				cmnd->result = (DID_ERROR << 16);
@@ -2181,6 +2202,7 @@ static void ibmvfc_handle_async(struct i
 				struct ibmvfc_host *vhost)
 {
 	const char *desc = ibmvfc_get_ae_desc(crq->event);
+	struct ibmvfc_target *tgt;
 
 	ibmvfc_log(vhost, 3, "%s event received. scsi_id: %llx, wwpn: %llx,"
 		   " node_name: %llx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
@@ -2218,9 +2240,23 @@ static void ibmvfc_handle_async(struct i
 	case IBMVFC_AE_SCN_NPORT:
 	case IBMVFC_AE_SCN_GROUP:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
+		ibmvfc_reinit_host(vhost);
+		break;
 	case IBMVFC_AE_ELS_LOGO:
 	case IBMVFC_AE_ELS_PRLO:
 	case IBMVFC_AE_ELS_PLOGI:
+		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
+				break;
+			if (crq->scsi_id && tgt->scsi_id != crq->scsi_id)
+				continue;
+			if (crq->wwpn && tgt->ids.port_name != crq->wwpn)
+				continue;
+			if (crq->node_name && tgt->ids.node_name != crq->node_name)
+				continue;
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		}
+
 		ibmvfc_reinit_host(vhost);
 		break;
 	case IBMVFC_AE_LINK_DOWN:
_
