From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 1/9] lpfc: Check for active portpeerbeacon.
Date: Fri, 22 May 2015 10:42:35 -0400
Message-ID: <555f405b.edV1AAZPf7ciBGhe%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34150 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbbEVOmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:42 -0400
Received: by qkgx75 with SMTP id x75so12677307qkg.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:42 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id o65sm1405747qge.34.2015.05.22.07.42.41
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Check for active portpeerbeacon.

LCB requests to set Beacon would fail if the beacon was already enabled
internally as the mailbox command used to query the state failes with
an already-set status.

Correct by enhancing the check so we don't fail if if the already set
status comes back.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 19 +++++++++++++++----
 drivers/scsi/lpfc/lpfc_hw4.h |  6 ++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 011c8d8..3aad09f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5044,25 +5044,36 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_iocbq *elsiocb;
 	struct lpfc_nodelist *ndlp;
 	struct ls_rjt *stat;
+	union lpfc_sli4_cfg_shdr *shdr;
 	struct lpfc_lcb_context *lcb_context;
 	struct fc_lcb_res_frame *lcb_res;
-	uint32_t cmdsize;
+	uint32_t cmdsize, shdr_status, shdr_add_status;
 	int rc;
 
 	mb = &pmb->u.mb;
-
 	lcb_context = (struct lpfc_lcb_context *)pmb->context1;
 	ndlp = lcb_context->ndlp;
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
 
-	if (mb->mbxStatus) {
+	shdr = (union lpfc_sli4_cfg_shdr *)
+			&pmb->u.mqe.un.beacon_config.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX,
+				"0194 SET_BEACON_CONFIG mailbox "
+				"completed with status x%x add_status x%x,"
+				" mbx status x%x\n",
+				shdr_status, shdr_add_status, mb->mbxStatus);
+
+	if (mb->mbxStatus && !(shdr_status &&
+		shdr_add_status == ADD_STATUS_OPERATION_ALREADY_ACTIVE)) {
 		mempool_free(pmb, phba->mbox_mem_pool);
 		goto error;
 	}
 
 	mempool_free(pmb, phba->mbox_mem_pool);
-
 	cmdsize = sizeof(struct fc_lcb_res_frame);
 	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
 			lpfc_max_els_tries, ndlp,
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 7cc7bec..b94fa46 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1943,6 +1943,12 @@ struct lpfc_mbx_redisc_fcf_tbl {
 #define STATUS_FCF_IN_USE				0x3a
 #define STATUS_FCF_TABLE_EMPTY				0x43
 
+/*
+ * Additional status field for embedded SLI_CONFIG mailbox
+ * command.
+ */
+#define ADD_STATUS_OPERATION_ALREADY_ACTIVE		0x67
+
 struct lpfc_mbx_sli4_config {
 	struct mbox_header header;
 };
-- 
1.7.11.7

