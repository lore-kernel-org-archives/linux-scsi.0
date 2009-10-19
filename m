From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 2/6] ibmvfc: Fix locking in ibmvfc_remove
Date: Mon, 19 Oct 2009 15:07:48 -0500
Message-ID: <200910192007.n9JK7n1n005399@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42134 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZJSUHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2009 16:07:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JK3qHF026021
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 16:03:52 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JK7oDs247844
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 16:07:50 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9JK7ni5005528
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 16:07:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Need to grab the host lock around the call to ibmvfc_link_down.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_remove_locking drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_remove_locking	2009-08-05 11:11:01.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-08-05 11:11:01.000000000 -0500
@@ -4420,7 +4420,11 @@ static int ibmvfc_remove(struct vio_dev
 
 	ENTER;
 	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_attr);
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
 	ibmvfc_wait_while_resetting(vhost);
 	ibmvfc_release_crq_queue(vhost);
 	kthread_stop(vhost->work_thread);
_
