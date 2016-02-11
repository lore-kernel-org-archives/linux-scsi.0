From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: byteswap scsi_id, wwpn, and node_name prior to logging
Date: Thu, 11 Feb 2016 16:24:35 -0600
Message-ID: <1455229475-3984-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35957 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbcBKWYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 17:24:42 -0500
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Thu, 11 Feb 2016 15:24:41 -0700
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B3F4B19D8042
	for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2016 15:12:37 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1BMOdIr31457462
	for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2016 15:24:39 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1BMOclN024382
	for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2016 15:24:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

When logging async events the scsi_id, wwpn, and node_name values
are used directly from the CRQ struct which are of type __be64. This
can be confusing to someone looking through the log on a LE system.
Instead byteswap these values to host endian prior to logging.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6aa317c..fc523c3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2636,7 +2636,8 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	struct ibmvfc_target *tgt;
 
 	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
-		   " node_name: %llx%s\n", desc->desc, crq->scsi_id, crq->wwpn, crq->node_name,
+		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
+		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
 		   ibmvfc_get_link_state(crq->link_state));
 
 	switch (be64_to_cpu(crq->event)) {
-- 
2.5.0

