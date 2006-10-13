From: Santiago Leon <santil@us.ibm.com>
Subject: [PATCH] ibmvscsi: correctly reenable CRQ
Date: Fri, 13 Oct 2006 10:22:50 -0500
Message-ID: <20061013152250.19701.18521.sendpatchset@ltcml8p1.rchland.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:12251 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751738AbWJMQZu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:25:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9DGPj5T014259
	for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2006 12:25:46 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9DGPj3v126146
	for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2006 12:25:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9DGPjgJ018603
	for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2006 12:25:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Santiago Leon <santil@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>

From: Santiago Leon <santil@us.ibm.com>

The "ibmvscsi: treat busy and error conditions separately" patch submitted by Dave Boutcher back in June incorrectly reenables the CRQ.  The broken logic causes the adapter to get disabled if the CRQ connection happens to close temporarily.  This patch "fixes that obviously wrong logic check" (Dave's words).  Please apply.

Signed-off-by: Santiago Leon <santil@us.ibm.com>
Signed-off-by: David Boutcher <sleddog@us.ibm.com>
---
 ibmvscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ibmvscsi/ibmvscsi.c	2006-09-27 16:38:48.000000000 -0500
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c	2006-10-13 13:34:22.000000000 -0500
@@ -1213,7 +1213,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			       "ibmvscsi: Re-enabling adapter!\n");
 			purge_requests(hostdata, DID_REQUEUE);
 			if ((ibmvscsi_reenable_crq_queue(&hostdata->queue,
-							hostdata) == 0) ||
+							hostdata)) ||
 			    (ibmvscsi_send_crq(hostdata,
 					       0xC001000000000000LL, 0))) {
 					atomic_set(&hostdata->request_limit,
