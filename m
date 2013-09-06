From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/18] lpfc 8.3.42: Fixed back to back RSCNs discovery
 failure.
Date: Fri, 6 Sep 2013 12:20:07 -0400
Message-ID: <1378484407.14051.27.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22787 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3IFQUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:20:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed back to back RSCNs discovery failure.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-09-06 10:04:06.298058357 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-09-06 10:04:14.323058540 -0400
@@ -4457,7 +4457,15 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 	int rc;
 	uint16_t rpi;
 
-	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
+	if (ndlp->nlp_flag & NLP_RPI_REGISTERED ||
+	    ndlp->nlp_flag & NLP_REG_LOGIN_SEND) {
+		if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+					 "3366 RPI x%x needs to be "
+					 "unregistered nlp_flag x%x "
+					 "did x%x\n",
+					 ndlp->nlp_rpi, ndlp->nlp_flag,
+					 ndlp->nlp_DID);
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mbox) {
 			/* SLI4 ports require the physical rpi value. */



