From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ibmvfc: Fix command timeouts due to cached CRQ access
Date: Fri, 14 Nov 2008 13:33:52 -0600
Message-ID: <200811141934.mAEJYLjO012936@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36522 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbYKNTeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2008 14:34:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAEJYERK032447
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 14:34:14 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAEJYMsV144598
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 14:34:22 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAEJYMKm012991
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 14:34:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The CRQs used by the ibmvfc driver are read and written by both
the client and the server. Therefore, we need to mark them volatile
so that we do not cache their contents when handling an interrupt.
This fixes a problem which can surface as occasional command timeouts.
No commands were actually timing out, but due to accessing cached data
for the CRQ in the interrupt handler, the interrupt was not processing
all command completions as it should.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_volatile drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_volatile	2008-10-31 11:13:07.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-10-31 12:35:53.000000000 -0500
@@ -523,10 +523,10 @@ enum ibmvfc_async_event {
 };
 
 struct ibmvfc_crq {
-	u8 valid;
-	u8 format;
+	volatile u8 valid;
+	volatile u8 format;
 	u8 reserved[6];
-	u64 ioba;
+	volatile u64 ioba;
 }__attribute__((packed, aligned (8)));
 
 struct ibmvfc_crq_queue {
@@ -536,13 +536,13 @@ struct ibmvfc_crq_queue {
 };
 
 struct ibmvfc_async_crq {
-	u8 valid;
+	volatile u8 valid;
 	u8 pad[3];
 	u32 pad2;
-	u64 event;
-	u64 scsi_id;
-	u64 wwpn;
-	u64 node_name;
+	volatile u64 event;
+	volatile u64 scsi_id;
+	volatile u64 wwpn;
+	volatile u64 node_name;
 	u64 reserved;
 }__attribute__((packed, aligned (8)));
 
_
