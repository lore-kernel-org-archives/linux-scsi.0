From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 04/21] lpfc: Fix lpfc nvme host rejecting IO with Not Ready message
Date: Fri, 29 Sep 2017 17:34:30 -0700
Message-ID: <20170930003447.10747-5-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:37523 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdI3Ae7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:34:59 -0400
Received: by mail-qk0-f194.google.com with SMTP id z143so773940qkb.4
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:34:59 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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
