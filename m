From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ibmvfc: Fix endless PRLI loop in discovery
Date: Thu, 18 Jun 2009 09:06:55 -0500
Message-ID: <200906181406.n5IE6t1o011412@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54418 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbZFROGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 10:06:55 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e9.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5IDsOAM014601
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 09:54:24 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5IE6woN185842
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 10:06:58 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5IE6vQ0011598
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 10:06:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fixes a problem seen where sending a PRLI to a target
resulted in it sending a LOGO. This caused the ibmvfc
driver to go back through discovery again, which caused
another PRLI attempt, which caused another LOGO. Fix this
behavior by ignoring LOGO if we haven't even logged into
the target yet.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   16 ++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_logo_loop2 drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_logo_loop2	2009-06-16 13:30:31.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-06-16 16:17:19.000000000 -0500
@@ -2254,10 +2254,13 @@ static void ibmvfc_handle_async(struct i
 				continue;
 			if (crq->node_name && tgt->ids.node_name != crq->node_name)
 				continue;
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			if (tgt->need_login && crq->event == IBMVFC_AE_ELS_LOGO)
+				tgt->logo_rcvd = 1;
+			if (!tgt->need_login || crq->event == IBMVFC_AE_ELS_PLOGI) {
+				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+				ibmvfc_reinit_host(vhost);
+			}
 		}
-
-		ibmvfc_reinit_host(vhost);
 		break;
 	case IBMVFC_AE_LINK_DOWN:
 	case IBMVFC_AE_ADAPTER_FAILED:
@@ -2927,7 +2930,11 @@ static void ibmvfc_tgt_prli_done(struct
 		break;
 	case IBMVFC_MAD_FAILED:
 	default:
-		if (ibmvfc_retry_cmd(rsp->status, rsp->error))
+		if ((rsp->status & IBMVFC_VIOS_FAILURE) && rsp->error == IBMVFC_PLOGI_REQUIRED)
+			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_plogi);
+		else if (tgt->logo_rcvd)
+			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_plogi);
+		else if (ibmvfc_retry_cmd(rsp->status, rsp->error))
 			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
 		else
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
@@ -3054,6 +3061,7 @@ static void ibmvfc_tgt_send_plogi(struct
 		return;
 
 	kref_get(&tgt->kref);
+	tgt->logo_rcvd = 0;
 	evt = ibmvfc_get_event(vhost);
 	vhost->discovery_threads++;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fix_logo_loop2 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fix_logo_loop2	2009-06-16 16:17:11.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-06-16 16:17:19.000000000 -0500
@@ -605,6 +605,7 @@ struct ibmvfc_target {
 	int need_login;
 	int add_rport;
 	int init_retries;
+	int logo_rcvd;
 	u32 cancel_key;
 	struct ibmvfc_service_parms service_parms;
 	struct ibmvfc_service_parms service_parms_change;
_
