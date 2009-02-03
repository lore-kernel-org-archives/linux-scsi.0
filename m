From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Better handle other FC initiators
Date: Mon, 02 Feb 2009 18:39:40 -0600
Message-ID: <200902030041.n130f6V7004930@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36116 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZBCAlJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2009 19:41:09 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n130fduF019332
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2009 19:41:39 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n130f8Iv155426
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2009 19:41:08 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n130f7Od004955
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2009 19:41:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc driver currently always sets the role of all rports
to FC_PORT_ROLE_FCP_TARGET, which is not correct for other initiators.
This can cause problems if other initiators are on the fabric
when we then try to scan the rport for LUNs. Fix this by looking
at the service parameters returned in the PRLI to set the roles
appropriately. Also look at the returned service parameters to
decide whether or not we were actually able to successfully log into
the target.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   62 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 58 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_prli_initiator_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_prli_initiator_fix	2009-01-30 15:13:25.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-02-02 13:17:39.000000000 -0600
@@ -2770,6 +2770,40 @@ static void ibmvfc_retry_tgt_init(struct
 		ibmvfc_init_tgt(tgt, job_step);
 }
 
+/* Defined in FC-LS */
+static const struct {
+	int code;
+	int retry;
+	int logged_in;
+} prli_rsp [] = {
+	{ 0, 1, 0 },
+	{ 1, 0, 1 },
+	{ 2, 1, 0 },
+	{ 3, 1, 0 },
+	{ 4, 0, 0 },
+	{ 5, 0, 0 },
+	{ 6, 0, 1 },
+	{ 7, 0, 0 },
+	{ 8, 1, 0 },
+};
+
+/**
+ * ibmvfc_get_prli_rsp - Find PRLI response index
+ * @flags:	PRLI response flags
+ *
+ **/
+static int ibmvfc_get_prli_rsp(u16 flags)
+{
+	int i;
+	int code = (flags & 0x0f00) >> 8;
+
+	for (i = 0; i < ARRAY_SIZE(prli_rsp); i++)
+		if (prli_rsp[i].code == code)
+			return i;
+
+	return 0;
+}
+
 /**
  * ibmvfc_tgt_prli_done - Completion handler for Process Login
  * @evt:	ibmvfc event struct
@@ -2780,15 +2814,36 @@ static void ibmvfc_tgt_prli_done(struct 
 	struct ibmvfc_target *tgt = evt->tgt;
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_process_login *rsp = &evt->xfer_iu->prli;
+	struct ibmvfc_prli_svc_parms *parms = &rsp->parms;
 	u32 status = rsp->common.status;
+	int index;
 
 	vhost->discovery_threads--;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
-		tgt_dbg(tgt, "Process Login succeeded\n");
-		tgt->need_login = 0;
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_ADD_RPORT);
+		tgt_dbg(tgt, "Process Login succeeded: %X %02X %04X\n",
+			parms->type, parms->flags, parms->service_parms);
+
+		if (parms->type == IBMVFC_SCSI_FCP_TYPE) {
+			index = ibmvfc_get_prli_rsp(parms->flags);
+			if (prli_rsp[index].logged_in) {
+				if (parms->flags & IBMVFC_PRLI_EST_IMG_PAIR) {
+					tgt->need_login = 0;
+					tgt->ids.roles = 0;
+					if (parms->service_parms & IBMVFC_PRLI_TARGET_FUNC)
+						tgt->ids.roles |= FC_PORT_ROLE_FCP_TARGET;
+					if (parms->service_parms & IBMVFC_PRLI_INITIATOR_FUNC)
+						tgt->ids.roles |= FC_PORT_ROLE_FCP_INITIATOR;
+					ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_ADD_RPORT);
+				} else
+					ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			} else if (prli_rsp[index].retry)
+				ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
+			else
+				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		} else
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
@@ -2877,7 +2932,6 @@ static void ibmvfc_tgt_plogi_done(struct
 		tgt->ids.node_name = wwn_to_u64(rsp->service_parms.node_name);
 		tgt->ids.port_name = wwn_to_u64(rsp->service_parms.port_name);
 		tgt->ids.port_id = tgt->scsi_id;
-		tgt->ids.roles = FC_PORT_ROLE_FCP_TARGET;
 		memcpy(&tgt->service_parms, &rsp->service_parms,
 		       sizeof(tgt->service_parms));
 		memcpy(&tgt->service_parms_change, &rsp->service_parms_change,
_
