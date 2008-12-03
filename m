From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ibmvfc: Fix errors due to inconsistent command data
Date: Wed, 03 Dec 2008 11:02:56 -0600
Message-ID: <200812031703.mB3H3eL5001373@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52547 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLCRDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 12:03:48 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB3H2NZs028608
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 10:02:23 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB3H3gv4075706
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 10:03:43 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB3H3f8Y001516
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 10:03:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


In order to ensure the VIOS sees a consistent command buffer, we
need to add a memory barrier after building the command buffer
but before sending the command.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_add_sync drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_add_sync	2008-11-26 15:05:03.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-12-02 12:19:50.000000000 -0600
@@ -1381,6 +1381,8 @@ static int ibmvfc_send_event(struct ibmv
 		add_timer(&evt->timer);
 	}
 
+	mb();
+
 	if ((rc = ibmvfc_send_crq(vhost, crq_as_u64[0], crq_as_u64[1]))) {
 		list_del(&evt->queue);
 		del_timer(&evt->timer);
_
