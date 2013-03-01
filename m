From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/11] lpfc 8.3.38: Fixed deadlock condition in FCF round
 robin handling
Date: Fri, 1 Mar 2013 16:36:54 -0500
Message-ID: <1362173814.8283.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41659 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3CAViW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:38:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed deadlock condition in FCF round robin handling


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    2 ++
 lpfc_sli.c     |    9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-02-27 08:17:19.696047400 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-02-27 08:17:23.290047483 -0500
@@ -1793,6 +1793,8 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc
 	virt_addr = mboxq->sge_array->addr[0];
 
 	shdr = (union lpfc_sli4_cfg_shdr *)virt_addr;
+	lpfc_sli_pcimem_bcopy(shdr, shdr,
+			      sizeof(union lpfc_sli4_cfg_shdr));
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-02-27 08:17:19.736047401 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-02-27 08:17:23.341047483 -0500
@@ -15507,11 +15507,18 @@ lpfc_check_next_fcf_pri_level(struct lpf
 			LPFC_SLI4_FCF_TBL_INDX_MAX);
 	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
 			"3060 Last IDX %d\n", last_index);
-	if (list_empty(&phba->fcf.fcf_pri_list)) {
+
+	/* Verify the priority list has 2 or more entries */
+	spin_lock_irq(&phba->hbalock);
+	if (list_empty(&phba->fcf.fcf_pri_list) ||
+	    list_is_singular(&phba->fcf.fcf_pri_list)) {
+		spin_unlock_irq(&phba->hbalock);
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
 			"3061 Last IDX %d\n", last_index);
 		return 0; /* Empty rr list */
 	}
+	spin_unlock_irq(&phba->hbalock);
+
 	next_fcf_pri = 0;
 	/*
 	 * Clear the rr_bmask and set all of the bits that are at this



