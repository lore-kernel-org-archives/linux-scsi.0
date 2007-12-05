From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: retry on H_DROPPED during send_crq
Date: Wed, 5 Dec 2007 10:24:51 -0600
Message-ID: <20071205162451.GA9995@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57383 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXLEQZT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 11:25:19 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB5GPIH9009303
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 11:25:18 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB5GPGC5200198
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 09:25:17 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB5GPEku009074
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 09:25:15 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, santil@linux.vnet.ibm.com, brking@linux.vnet.ibm.com

Currently the vscsi client driver responds to the case where H_SEND_CRQ
returns H_DROPPED by returning DID_ERROR.  If the server CRQ is full,
either from mismanaging the request_limit or problems on the server,
we should return SCSI_MLQUEUE_HOST_BUSY instead.

The places where we are calling send_srp_login are not checking the
return code.  We could get H_DROPPED or H_CLOSED and in that case we
should reset and retry.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -629,14 +629,15 @@ static int ibmvscsi_send_srp_event(struc
 		list_del(&evt_struct->list);
 		del_timer(&evt_struct->timer);
 
-		/* If send_crq returns H_CLOSED, return SCSI_MLQUEUE_HOST_BUSY.
-		 * Firmware will send a CRQ with a transport event (0xFF) to
-		 * tell this client what has happened to the transport.  This
-		 * will be handled in ibmvscsi_handle_crq()
+		/* If send_crq returns H_CLOSED or H_DROPPED, return
+		 * SCSI_MLQUEUE_HOST_BUSY.  Firmware will send a CRQ with
+		 * a transport event (0xFF) to tell this client what has
+		 * happened to the transport.  This  will be handled in
+		 * ibmvscsi_handle_crq().
 		 */
-		if (rc == H_CLOSED) {
+		if (rc == H_CLOSED || rc == H_DROPPED) {
 			dev_warn(hostdata->dev, "send warning. "
-			         "Receive queue closed, will retry.\n");
+			         "Receive queue unavailable, will retry.\n");
 			goto send_busy;
 		}
 		dev_err(hostdata->dev, "send error %d\n", rc);
@@ -1270,7 +1271,8 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			if ((rc = ibmvscsi_ops->send_crq(hostdata,
 							 0xC002000000000000LL, 0)) == 0) {
 				/* Now login */
-				send_srp_login(hostdata);
+				if (send_srp_login(hostdata))
+					ibmvscsi_reset_host(hostdata);
 			} else {
 				dev_err(hostdata->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			}
@@ -1280,7 +1282,8 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			dev_info(hostdata->dev, "partner initialization complete\n");
 
 			/* Now login */
-			send_srp_login(hostdata);
+			if (send_srp_login(hostdata))
+				ibmvscsi_reset_host(hostdata);
 			break;
 		default:
 			dev_err(hostdata->dev, "unknown crq message type: %d\n", crq->format);
