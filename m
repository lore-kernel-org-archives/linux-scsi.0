From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/14] lpfc: Fix incorrect log message reported for empty
 FCF record.
Date: Mon, 20 Apr 2015 09:56:36 -0400
Message-ID: <55350594.bW/DSxlYGUx2MwXR%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:29298 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbbDTN5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix incorrect log message reported for empty FCF record.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 88af258..72a69d4 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1777,7 +1777,7 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	dma_addr_t phys_addr;
 	struct lpfc_mbx_sge sge;
 	struct lpfc_mbx_read_fcf_tbl *read_fcf;
-	uint32_t shdr_status, shdr_add_status;
+	uint32_t shdr_status, shdr_add_status, if_type;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct fcf_record *new_fcf_record;
 
@@ -1798,9 +1798,11 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	lpfc_sli_pcimem_bcopy(shdr, shdr,
 			      sizeof(union lpfc_sli4_cfg_shdr));
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status) {
-		if (shdr_status == STATUS_FCF_TABLE_EMPTY)
+		if (shdr_status == STATUS_FCF_TABLE_EMPTY ||
+					if_type == LPFC_SLI_INTF_IF_TYPE_2)
 			lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
 					"2726 READ_FCF_RECORD Indicates empty "
 					"FCF table.\n");
-- 
1.7.11.7

