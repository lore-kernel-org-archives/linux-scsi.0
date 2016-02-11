From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 7/7] ibmvscsi: use H_CLOSED instead of magic number
Date: Wed, 10 Feb 2016 19:32:28 -0600
Message-ID: <1455154348-3226-8-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52971 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbcBKBcs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2016 20:32:48 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 10 Feb 2016 18:32:48 -0700
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

In a couple places the magic value of 2 is used to check the return
code of hypercalls. This translates to H_CLOSED.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6025481..d9534ee 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -314,7 +314,7 @@ static int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
 	rc = plpar_hcall_norets(H_REG_CRQ,
 				vdev->unit_address,
 				queue->msg_token, PAGE_SIZE);
-	if (rc == 2) {
+	if (rc == H_CLOSED) {
 		/* Adapter is good, but other end is not ready */
 		dev_warn(hostdata->dev, "Partner adapter not ready\n");
 	} else if (rc != 0) {
@@ -364,7 +364,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 		rc = ibmvscsi_reset_crq_queue(queue,
 					      hostdata);
 
-	if (rc == 2) {
+	if (rc == H_CLOSED) {
 		/* Adapter is good, but other end is not ready */
 		dev_warn(hostdata->dev, "Partner adapter not ready\n");
 		retrc = 0;
-- 
2.5.0

