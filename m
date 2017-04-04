From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 06/19] Fix discovery error handling in NVME initiator
Date: Tue,  4 Apr 2017 10:16:59 -0700
Message-ID: <1491326232-11255-7-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38171 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755131AbdDDRZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:40 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 72B8430C0AE
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:28 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

performance lab running tests on upstream 4.10-rc5
POC and observing error during the NVME connect process.  Here
are the errors:

Issue 1:
The initiator is claiming the nvme_fc_unregister_remoteport upcall is
not completing the unregister in the time allotted.
[ 2186.151317] lpfc 0000:07:00.0: 0:(0):6169 Unreg nvme wait failed 0

Issue 2:
In this case, the NVME initiator is sending an LS REQ command on an NDLP
that is not MAPPED.  The FW rejects it.
[ 2186.165689] lpfc 0000:07:00.0: 0:(0):6051 ENTER.  lport ffff8817c75f7f00, rport ffff8817d2ab3bc0 lsreqffff8817cdad1900 rqstlen:48 rsplen:24 102234921368x 102234921416
[ 2186.165691] lpfc 0000:07:00.0: 0:(0):6050 Issue GEN REQ WQE to NPORT x560100 Data: x7a5 x20 wq:ffff8817c7f5ce00 lsreq:ffff8817cdad1900 bmp:ffff8817c7492400 xmit:48 1st:48
[ 2186.165700] lpfc 0000:07:00.0: 0:(0):6047 nvme cmpl Enter Data ffff8817cdad1900 DID 560100 Xri: 3d status 3 cmd:ffff8817c7f5ce00 lsreg:ffff8817cdad1900 bmp:ffff8817c7492400 ndlp:ffff8817c8c4b600

Issue 3:
There is a panic in the lpfc_nvme_io_cmd_wqe_cmpl routine whenever the NVME IO logging is enabled.
This is because the initiator is touching the NDLP post unregister.

Cause: Summarized:
Issue 1:  The wait_for_completion_timeout returns 0 when the wait has
been outstanding for the jiffies passed by the caller.  In this error
message, the nvme initiator passed value 5 - meaning 5 jiffies -
and this is just wrong.

Issue 2: The lpfc_nvme_ls_req routine checks for a NULL ndlp pointer
but does not check the NDLP state.  This allows the routine
to send an LS IO when the ndlp is disconnected.

Issue 3: The driver checks for NULL pointers but the log message
in the driver references the null ndlp anyway.

Fix: Summarized:
Issue 1:  Calculate 5 seconds in Jiffies and pass that value
from the current jiffies.

Issue 2: Check the ndlp for NULL, actual node, Target and MAPPED
or Initiator and UNMAPPED. This avoids Fabric nodes getting
the Create Association or Create Connection commands.  Initiators
are free to Reject either Create.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 0024de1..6465aa6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -417,11 +417,26 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
-	if (!ndlp) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
-				 "6043 Could not find node for DID %x\n",
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
+				 "6051 DID x%06x not an active rport.\n",
 				 pnvme_rport->port_id);
-		return 1;
+		return -ENODEV;
+	}
+
+	/* The remote node has to be a mapped nvme target or an
+	 * unmapped nvme initiator or it's an error.
+	 */
+	if (((ndlp->nlp_type & NLP_NVME_TARGET) &&
+	     (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) ||
+	    ((ndlp->nlp_type & NLP_NVME_INITIATOR) &&
+	     (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
+				 "6088 DID x%06x not ready for "
+				 "IO. State x%x, Type x%x\n",
+				 pnvme_rport->port_id,
+				 ndlp->nlp_state, ndlp->nlp_type);
+		return -ENODEV;
 	}
 	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!bmp) {
@@ -456,7 +471,7 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 
 	/* Expand print to include key fields. */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-			 "6051 ENTER.  lport %p, rport %p lsreq%p rqstlen:%d "
+			 "6149 ENTER.  lport %p, rport %p lsreq%p rqstlen:%d "
 			 "rsplen:%d %pad %pad\n",
 			 pnvme_lport, pnvme_rport,
 			 pnvme_lsreq, pnvme_lsreq->rqstlen,
@@ -772,9 +787,9 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	ndlp = rport->ndlp;
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
-				 "6061 rport %p, ndlp %p, DID x%06x ndlp "
+				 "6061 rport %p, DID x%06x node "
 				 "not ready.\n",
-				 rport, ndlp, rport->remoteport->port_id);
+				 rport, rport->remoteport->port_id);
 
 		ndlp = lpfc_findnode_did(vport, rport->remoteport->port_id);
 		if (!ndlp) {
@@ -2409,6 +2424,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport;
 	struct nvme_fc_remote_port *remoteport;
+	unsigned long wait_tmo;
 
 	localport = vport->localport;
 
@@ -2451,11 +2467,12 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * before proceeding.  This guarantees the transport and driver
 		 * have completed the unreg process.
 		 */
-		ret = wait_for_completion_timeout(&rport->rport_unreg_done, 5);
+		wait_tmo = jiffies + msecs_to_jiffies(5000);
+		ret = wait_for_completion_timeout(&rport->rport_unreg_done,
+						  wait_tmo);
 		if (ret == 0) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
-					 "6169 Unreg nvme wait failed %d\n",
-					 ret);
+					 "6169 Unreg nvme wait timeout failure\n");
 		}
 	}
 	return;
-- 
2.1.0
