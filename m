From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvfc: Fix command completion handling
Date: Tue, 20 Apr 2010 14:21:33 -0500
Message-ID: <201004201921.o3KJLZsQ031463@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47938 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0DTTVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2010 15:21:45 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e7.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3KJCAKF019446
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2010 15:12:10 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3KJLhZS160044
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2010 15:21:43 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3KJLZNd031490
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2010 13:21:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Commands which are completed by the VIOS are placed on a CRQ
in kernel memory for the ibmvfc driver to process. Each CRQ
entry is 16 bytes. The ibmvfc driver reads the first 8 bytes
to check if the entry is valid, then reads the next 8 bytes to get
the handle, which is a pointer the completed command. This fixes
an issue seen on Power 7 where the processor reordered the
loads from memory, resulting in processing command completion
with a stale handle. This could result in command timeouts,
and also early completion of commands.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_barrier drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_barrier	2010-04-20 08:47:48.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-04-20 08:47:48.000000000 -0500
@@ -3012,6 +3012,7 @@ static struct ibmvfc_async_crq *ibmvfc_n
 	if (crq->valid & 0x80) {
 		if (++async_crq->cur == async_crq->size)
 			async_crq->cur = 0;
+		rmb();
 	} else
 		crq = NULL;
 
@@ -3034,6 +3035,7 @@ static struct ibmvfc_crq *ibmvfc_next_cr
 	if (crq->valid & 0x80) {
 		if (++queue->cur == queue->size)
 			queue->cur = 0;
+		rmb();
 	} else
 		crq = NULL;
 
@@ -3082,12 +3084,14 @@ static void ibmvfc_tasklet(void *data)
 		while ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
 			ibmvfc_handle_async(async, vhost);
 			async->valid = 0;
+			wmb();
 		}
 
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = ibmvfc_next_crq(vhost)) != NULL) {
 			ibmvfc_handle_crq(crq, vhost);
 			crq->valid = 0;
+			wmb();
 		}
 
 		vio_enable_interrupts(vdev);
@@ -3095,10 +3099,12 @@ static void ibmvfc_tasklet(void *data)
 			vio_disable_interrupts(vdev);
 			ibmvfc_handle_async(async, vhost);
 			async->valid = 0;
+			wmb();
 		} else if ((crq = ibmvfc_next_crq(vhost)) != NULL) {
 			vio_disable_interrupts(vdev);
 			ibmvfc_handle_crq(crq, vhost);
 			crq->valid = 0;
+			wmb();
 		} else
 			done = 1;
 	}
_
