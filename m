From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/12] lpfc 8.3.34: Fixed leaking memory from pci dma pool
Date: Tue, 14 Aug 2012 14:26:35 -0400
Message-ID: <1344968795.4432.26.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:26712 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2HNS07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed leaking memory from pci dma pool


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   25 ++++++++++++++++---------
 lpfc_mbox.c    |    2 +-
 2 files changed, 17 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-08-11 12:24:51.416924282 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-08-11 12:24:52.768924234 -0400
@@ -3509,7 +3509,7 @@ lpfc_create_static_vport(struct lpfc_hba
 	LPFC_MBOXQ_t *pmb = NULL;
 	MAILBOX_t *mb;
 	struct static_vport_info *vport_info;
-	int rc = 0, i;
+	int mbx_wait_rc = 0, i;
 	struct fc_vport_identifiers vport_id;
 	struct fc_vport *new_fc_vport;
 	struct Scsi_Host *shost;
@@ -3526,7 +3526,7 @@ lpfc_create_static_vport(struct lpfc_hba
 				" allocate mailbox memory\n");
 		return;
 	}
-
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
 	mb = &pmb->u.mb;
 
 	vport_info = kzalloc(sizeof(struct static_vport_info), GFP_KERNEL);
@@ -3540,24 +3540,31 @@ lpfc_create_static_vport(struct lpfc_hba
 
 	vport_buff = (uint8_t *) vport_info;
 	do {
+		/* free dma buffer from previous round */
+		if (pmb->context1) {
+			mp = (struct lpfc_dmabuf *)pmb->context1;
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+		}
 		if (lpfc_dump_static_vport(phba, pmb, offset))
 			goto out;
 
 		pmb->vport = phba->pport;
-		rc = lpfc_sli_issue_mbox_wait(phba, pmb, LPFC_MBOX_TMO);
+		mbx_wait_rc = lpfc_sli_issue_mbox_wait(phba, pmb,
+							LPFC_MBOX_TMO);
 
-		if ((rc != MBX_SUCCESS) || mb->mbxStatus) {
+		if ((mbx_wait_rc != MBX_SUCCESS) || mb->mbxStatus) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0544 lpfc_create_static_vport failed to"
 				" issue dump mailbox command ret 0x%x "
 				"status 0x%x\n",
-				rc, mb->mbxStatus);
+				mbx_wait_rc, mb->mbxStatus);
 			goto out;
 		}
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			byte_count = pmb->u.mqe.un.mb_words[5];
-			mp = (struct lpfc_dmabuf *) pmb->context2;
+			mp = (struct lpfc_dmabuf *)pmb->context1;
 			if (byte_count > sizeof(struct static_vport_info) -
 					offset)
 				byte_count = sizeof(struct static_vport_info)
@@ -3621,9 +3628,9 @@ lpfc_create_static_vport(struct lpfc_hba
 
 out:
 	kfree(vport_info);
-	if (rc != MBX_TIMEOUT) {
-		if (pmb->context2) {
-			mp = (struct lpfc_dmabuf *) pmb->context2;
+	if (mbx_wait_rc != MBX_TIMEOUT) {
+		if (pmb->context1) {
+			mp = (struct lpfc_dmabuf *)pmb->context1;
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			kfree(mp);
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2012-08-11 12:18:40.449937168 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2012-08-11 12:24:52.775924236 -0400
@@ -92,7 +92,7 @@ lpfc_dump_static_vport(struct lpfc_hba *
 	memset(mp->virt, 0, LPFC_BPL_SIZE);
 	INIT_LIST_HEAD(&mp->list);
 	/* save address for completion */
-	pmb->context2 = (uint8_t *) mp;
+	pmb->context1 = (uint8_t *)mp;
 	mb->un.varWords[3] = putPaddrLow(mp->phys);
 	mb->un.varWords[4] = putPaddrHigh(mp->phys);
 	mb->un.varDmp.sli4_length = sizeof(struct static_vport_info);



