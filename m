From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 13/15] lpfc: Fix incorrect log message reported for
 empty FCF record.
Date: Thu, 21 May 2015 13:55:29 -0400
Message-ID: <555e1c11.Q6zoYETblypfLzLN%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36801 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804AbbEURze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:34 -0400
Received: by qget53 with SMTP id t53so45126308qge.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:33 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id p73sm13607835qha.20.2015.05.21.10.55.33
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix incorrect log message reported for empty FCF record.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
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

