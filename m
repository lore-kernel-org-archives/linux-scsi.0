From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 03/19] lpfc: Fix lpfc nvme host rejecting IO with Not Ready message
Date: Thu, 21 Sep 2017 23:17:25 -0700
Message-ID: <20170922061741.12347-4-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36701 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdIVGR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:17:58 -0400
Received: by mail-pg0-f66.google.com with SMTP id d8so120474pgt.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:17:58 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

In a link bounce scenario, a condition can occur where the
discovery engine swaps an ndlp structure (address changbe for
an nport). While the swap was successfully executed by the
discovery engine, the driver did not properly detect a change in
the ndlp bound to the nvme rport.  This error resulted in the nvme
host transport issuing an IO to the correct nvme rport, but the
lpfc driver addressed a ndlp with an NLP_UNUSED status and failed
the io. This resulting it it looking like there were missing
namespaces and applications failed due to io errors.

To fix, in lpfc_nvme_register_rport, rework the "rebind" case
to break the nvme rport<->ndlp association when the ndlp
already has an nrport. Then rebind the rport to the correct
ndlp data and backpointers.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 46 ++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 79ba3ce063a4..2ad23b356bfe 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2296,6 +2296,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_nvme_rport *rport;
 	struct nvme_fc_remote_port *remote_port;
 	struct nvme_fc_port_info rpinfo;
+	struct lpfc_nodelist *prev_ndlp;
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NVME_DISC,
 			 "6006 Register NVME PORT. DID x%06x nlptype x%x\n",
@@ -2332,7 +2333,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * new rport.
 		 */
 		rport = remote_port->private;
-		if (ndlp->nrport == rport) {
+		if (ndlp->nrport) {
 			lpfc_printf_vlog(ndlp->vport, KERN_INFO,
 					 LOG_NVME_DISC,
 					 "6014 Rebinding lport to "
@@ -2343,24 +2344,33 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 					 remote_port->port_role,
 					 ndlp->nlp_type,
 					 ndlp->nlp_DID);
-		} else {
-			/* New rport. */
-			rport->remoteport = remote_port;
-			rport->lport = lport;
-			rport->ndlp = lpfc_nlp_get(ndlp);
-			if (!rport->ndlp)
-				return -1;
-			ndlp->nrport = rport;
-			lpfc_printf_vlog(vport, KERN_INFO,
-					 LOG_NVME_DISC | LOG_NODE,
-					 "6022 Binding new rport to "
-					 "lport %p Rport WWNN 0x%llx, "
-					 "Rport WWPN 0x%llx DID "
-					 "x%06x Role x%x\n",
-					 lport,
-					 rpinfo.node_name, rpinfo.port_name,
-					 rpinfo.port_id, rpinfo.port_role);
+			prev_ndlp = rport->ndlp;
+
+			/* Sever the ndlp<->rport connection before dropping
+			 * the ndlp ref from register.
+			 */
+			ndlp->nrport = NULL;
+			rport->ndlp = NULL;
+			if (prev_ndlp)
+				lpfc_nlp_put(ndlp);
 		}
+
+		/* Clean bind the rport to the ndlp. */
+		rport->remoteport = remote_port;
+		rport->lport = lport;
+		rport->ndlp = lpfc_nlp_get(ndlp);
+		if (!rport->ndlp)
+			return -1;
+		ndlp->nrport = rport;
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_NVME_DISC | LOG_NODE,
+				 "6022 Binding new rport to "
+				 "lport %p Rport WWNN 0x%llx, "
+				 "Rport WWPN 0x%llx DID "
+				 "x%06x Role x%x\n",
+				 lport,
+				 rpinfo.node_name, rpinfo.port_name,
+				 rpinfo.port_id, rpinfo.port_role);
 	} else {
 		lpfc_printf_vlog(vport, KERN_ERR,
 				 LOG_NVME_DISC | LOG_NODE,
-- 
2.13.1
