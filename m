From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ibmvscsi: Fix possible request_limit issue
Date: Thu, 17 Jun 2010 13:56:03 -0500
Message-ID: <201006171856.o5HIu3nm013102@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59633 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab0FQS4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:56:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HIqmFF007922
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:52:48 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o5HIu5dA073790
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HIu42k013130
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If we encounter an error when sending a management datagram (i.e. non
SCSI command, such as virtual adapter initialization command), we
end up incrementing the request_limit, even though we don't decrement
it for these commands. Fix this up by doing this increment in
the error path for SRP commands only.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_send_event_fix drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_send_event_fix	2010-06-17 12:47:03.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2010-06-17 13:17:54.000000000 -0500
@@ -548,6 +548,7 @@ static int ibmvscsi_send_srp_event(struc
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
 	int request_status = 0;
 	int rc;
+	int srp_req = 0;
 
 	/* If we have exhausted our request limit, just fail this request,
 	 * unless it is for a reset or abort.
@@ -556,6 +557,7 @@ static int ibmvscsi_send_srp_event(struc
 	 * can handle more requests (can_queue) when we actually can't
 	 */
 	if (evt_struct->crq.format == VIOSRP_SRP_FORMAT) {
+		srp_req = 1;
 		request_status =
 			atomic_dec_if_positive(&hostdata->request_limit);
 		/* If request limit was -1 when we started, it is now even
@@ -630,7 +632,8 @@ static int ibmvscsi_send_srp_event(struc
 			goto send_busy;
 		}
 		dev_err(hostdata->dev, "send error %d\n", rc);
-		atomic_inc(&hostdata->request_limit);
+		if (srp_req)
+			atomic_inc(&hostdata->request_limit);
 		goto send_error;
 	}
 
@@ -640,7 +643,7 @@ static int ibmvscsi_send_srp_event(struc
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
 
 	free_event_struct(&hostdata->pool, evt_struct);
-	if (request_status != -1)
+	if (srp_req && request_status != -1)
 		atomic_inc(&hostdata->request_limit);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
_
