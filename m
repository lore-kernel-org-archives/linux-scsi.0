From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Improve CRQ reset reliability
Date: Wed, 27 Apr 2011 10:27:08 -0500
Message-ID: <201104271527.p3RFR4pA013930@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40459 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1D0P1m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2011 11:27:42 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3RF5Eoj012188
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 11:05:14 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3RFROZB643092
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 11:27:25 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3RFR5Q2014031
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 09:27:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This patch fixes an issue seen where an event occurs
which causes the ibmvscsi driver to reset its CRQ. Upon
re-registering its CRQ, it receives H_CLOSED, indicating
the Virtual I/O Server is not yet ready to receive commands.
This resulted in the ibmvscsi driver essentially offlining
the adapter and not recovering. The fix is to re-enable
our interrupt so that when the Virtual I/O server is ready
and sends a CRQ init, we will be able to receive it and
resume initialization of the VSCSI adapter.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_recover_reset_notready drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_recover_reset_notready	2011-04-27 10:23:52.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2011-04-27 10:24:43.000000000 -0500
@@ -1849,8 +1849,7 @@ static void ibmvscsi_do_work(struct ibmv
 		rc = ibmvscsi_ops->reset_crq_queue(&hostdata->queue, hostdata);
 		if (!rc)
 			rc = ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0);
-		if (!rc)
-			rc = vio_enable_interrupts(to_vio_dev(hostdata->dev));
+		vio_enable_interrupts(to_vio_dev(hostdata->dev));
 	} else if (hostdata->reenable_crq) {
 		smp_rmb();
 		action = "enable";
_
