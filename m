From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 3/6] ibmvfc: Remove unnecessary parameter to ibmvfc_init_host
Date: Mon, 19 Oct 2009 15:07:49 -0500
Message-ID: <200910192009.n9JK9K67026257@d03av06.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36881 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZJSUH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 16:07:58 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JK5Xi0025359
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:05:33 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JK7rha083090
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:07:55 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9JK9K3x026272
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:09:21 -0600
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
