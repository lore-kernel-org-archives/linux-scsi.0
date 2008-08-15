From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ibmvfc: Fix for lost async events
Date: Fri, 15 Aug 2008 10:59:23 -0500
Message-ID: <200808151600.m7FG05Uc024327@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40674 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYHOQAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 12:00:10 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FG09ta030372
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:09 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG095Z130950
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:09 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG083c024949
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If the client virtual fibre channel adapter is already logged into the
server and does an NPIV Login again, the async queue, which is used for
reporting Link Up/Link Down type of events, does not get reset on the
server side. Fix up the client driver so that we also do not reset it.
This fixes a problem of lost async events following relogins.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_lost_async_event_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_lost_async_event_fix	2008-08-13 15:46:28.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-08-13 15:46:28.000000000 -0500
@@ -556,11 +556,12 @@ static void ibmvfc_link_down(struct ibmv
 /**
  * ibmvfc_init_host - Start host initialization
  * @vhost:		ibmvfc host struct
+ * @relogin:	is this a re-login?
  *
  * Return value:
  *	nothing
  **/
-static void ibmvfc_init_host(struct ibmvfc_host *vhost)
+static void ibmvfc_init_host(struct ibmvfc_host *vhost, int relogin)
 {
 	struct ibmvfc_target *tgt;
 
@@ -574,6 +575,11 @@ static void ibmvfc_init_host(struct ibmv
 	}
 
 	if (!ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
+		if (!relogin) {
+			memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
+			vhost->async_crq.cur = 0;
+		}
+
 		list_for_each_entry(tgt, &vhost->targets, queue)
 			tgt->need_login = 1;
 		scsi_block_requests(vhost->host);
@@ -2084,11 +2090,11 @@ static void ibmvfc_handle_async(struct i
 	case IBMVFC_AE_LINK_UP:
 	case IBMVFC_AE_RESUME:
 		vhost->events_to_log |= IBMVFC_AE_LINKUP;
-		ibmvfc_init_host(vhost);
+		ibmvfc_init_host(vhost, 1);
 		break;
 	case IBMVFC_AE_SCN_FABRIC:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
-		ibmvfc_init_host(vhost);
+		ibmvfc_init_host(vhost, 1);
 		break;
 	case IBMVFC_AE_SCN_NPORT:
 	case IBMVFC_AE_SCN_GROUP:
@@ -2134,13 +2140,13 @@ static void ibmvfc_handle_crq(struct ibm
 			/* Send back a response */
 			rc = ibmvfc_send_crq_init_complete(vhost);
 			if (rc == 0)
-				ibmvfc_init_host(vhost);
+				ibmvfc_init_host(vhost, 0);
 			else
 				dev_err(vhost->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			break;
 		case IBMVFC_CRQ_INIT_COMPLETE:
 			dev_info(vhost->dev, "Partner initialization complete\n");
-			ibmvfc_init_host(vhost);
+			ibmvfc_init_host(vhost, 0);
 			break;
 		default:
 			dev_err(vhost->dev, "Unknown crq message type: %d\n", crq->format);
@@ -3358,8 +3364,6 @@ static void ibmvfc_npiv_login(struct ibm
 	mad->buffer.va = vhost->login_buf_dma;
 	mad->buffer.len = sizeof(*vhost->login_buf);
 
-	memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
-	vhost->async_crq.cur = 0;
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
 
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
_
