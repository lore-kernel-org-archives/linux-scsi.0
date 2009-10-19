From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/6] ibmvfc: Fix locking in ibmvfc_remove
Date: Mon, 19 Oct 2009 14:19:43 -0500
Message-ID: <200910191921.n9JJLCqX024738@d03av06.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51419 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbZJSTUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 15:20:02 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JJF5IN009006
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 13:15:05 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JJJneY154428
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 13:19:50 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9JJLCFK024788
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 13:21:13 -0600
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
