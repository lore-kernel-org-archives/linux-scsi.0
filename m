From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ibmvfc: Remove unnecessary parameter to ibmvfc_init_host
Date: Mon, 19 Oct 2009 14:19:44 -0500
Message-ID: <200910191919.n9JJJjIL013304@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56207 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbZJSTTl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2009 15:19:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JJIKSX008300
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:18:20 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JJJkkZ258278
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:19:46 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9JJJj36013340
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:19:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Remove a parameter to ibmvfc_init_host which is always set to
zero by all callers.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_init_host_cleanup drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_init_host_cleanup	2009-08-26 17:10:22.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-08-26 17:12:06.000000000 -0500
@@ -558,12 +558,11 @@ static void ibmvfc_link_down(struct ibmv
 /**
  * ibmvfc_init_host - Start host initialization
  * @vhost:		ibmvfc host struct
- * @relogin:	is this a re-login?
  *
  * Return value:
  *	nothing
  **/
-static void ibmvfc_init_host(struct ibmvfc_host *vhost, int relogin)
+static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_target *tgt;
 
@@ -577,10 +576,8 @@ static void ibmvfc_init_host(struct ibmv
 	}
 
 	if (!ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
-		if (!relogin) {
-			memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
-			vhost->async_crq.cur = 0;
-		}
+		memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
+		vhost->async_crq.cur = 0;
 
 		list_for_each_entry(tgt, &vhost->targets, queue)
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
@@ -2303,13 +2300,13 @@ static void ibmvfc_handle_crq(struct ibm
 			/* Send back a response */
 			rc = ibmvfc_send_crq_init_complete(vhost);
 			if (rc == 0)
-				ibmvfc_init_host(vhost, 0);
+				ibmvfc_init_host(vhost);
 			else
 				dev_err(vhost->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			break;
 		case IBMVFC_CRQ_INIT_COMPLETE:
 			dev_info(vhost->dev, "Partner initialization complete\n");
-			ibmvfc_init_host(vhost, 0);
+			ibmvfc_init_host(vhost);
 			break;
 		default:
 			dev_err(vhost->dev, "Unknown crq message type: %d\n", crq->format);
@@ -3731,7 +3728,7 @@ static void ibmvfc_npiv_logout_done(stru
 	case IBMVFC_MAD_SUCCESS:
 		if (list_empty(&vhost->sent) &&
 		    vhost->action == IBMVFC_HOST_ACTION_LOGO_WAIT) {
-			ibmvfc_init_host(vhost, 0);
+			ibmvfc_init_host(vhost);
 			return;
 		}
 		break;
_
