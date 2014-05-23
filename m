From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 2/2] ibmvscsi: Add memory barriers for send / receive
Date: Fri, 23 May 2014 10:52:11 -0500
Message-ID: <201405231552.s4NFqB4h028030@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46161 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaEWPwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 11:52:16 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 23 May 2014 11:52:15 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 7AF836E802B
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 11:52:05 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4NFqDuS5898656
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 15:52:13 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4NFqCEx028070
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 11:52:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Add a memory barrier prior to sending a new command to the VIOS
to ensure the VIOS does not receive stale data in the command buffer.
Also add a memory barrier when processing the CRQ for completed commands.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_barrier drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_barrier	2014-05-23 10:41:35.000000000 -0500
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:42:53.000000000 -0500
@@ -185,6 +185,11 @@ static struct viosrp_crq *crq_queue_next
 	if (crq->valid & 0x80) {
 		if (++queue->cur == queue->size)
 			queue->cur = 0;
+
+		/* Ensure the read of the valid bit occurs before reading any
+		 * other bits of the CRQ entry
+		 */
+		rmb();
 	} else
 		crq = NULL;
 	spin_unlock_irqrestore(&queue->lock, flags);
@@ -203,6 +208,11 @@ static int ibmvscsi_send_crq(struct ibmv
 {
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
+	/*
+	 * Ensure the command buffer is flushed to memory before handing it
+	 * over to the VIOS to prevent it from fetching any stale data.
+	 */
+	mb();
 	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
 }
 
_

