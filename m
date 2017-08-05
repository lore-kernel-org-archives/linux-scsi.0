From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 01/20] lpfc: Fix plogi collision that causes illegal state transition
Date: Fri,  4 Aug 2017 17:47:12 -0700
Message-ID: <20170805004731.1335-2-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34553 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752535AbdHEArm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:47:42 -0400
Received: by mail-pg0-f68.google.com with SMTP id y192so3120794pgd.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:47:42 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Message "0271 Illegal State Transition: node" seen in logs, all
luns are unuseable for that target.

A window exists in the rcv_plogi path where if the state is plogi
issue but the driver has not issued a plogi, then two reglogins will
be sent for the same RPI. The first one to complete will advance
the state to prli issue the second one will be detected as an
illegal state, and leave the node in an unusable state.

Correct the completion routine for the PLOGI ACC that detects the
state change when the driver starts discovery on the node again
and drop the REGLOGIN mailbox command.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6d1d6f691df4..9e9aa8bb7001 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3930,7 +3930,31 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (mbox) {
 		if ((rspiocb->iocb.ulpStatus == 0)
 		    && (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
-			lpfc_unreg_rpi(vport, ndlp);
+			if (!lpfc_unreg_rpi(vport, ndlp)) {
+				if (ndlp->nlp_state ==  NLP_STE_PLOGI_ISSUE ||
+				    ndlp->nlp_state ==
+				     NLP_STE_REG_LOGIN_ISSUE) {
+					lpfc_printf_vlog(vport, KERN_INFO,
+							 LOG_DISCOVERY,
+							 "0314 PLOGI recov "
+							 "DID x%x "
+							 "Data: x%x x%x x%x\n",
+							 ndlp->nlp_DID,
+							 ndlp->nlp_state,
+							 ndlp->nlp_rpi,
+							 ndlp->nlp_flag);
+					mp = (struct lpfc_dmabuf *)
+					      mbox->context1;
+					if (mp) {
+						lpfc_mbuf_free(phba, mp->virt,
+							       mp->phys);
+						kfree(mp);
+					}
+					mempool_free(mbox, phba->mbox_mem_pool);
+					goto out;
+				}
+			}
+
 			/* Increment reference count to ndlp to hold the
 			 * reference to ndlp for the callback function.
 			 */
-- 
2.13.1
