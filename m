From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/16] lpfc 8.3.35: Fix interrupt delay multipler conversion
 for eq_create
Date: Sat, 29 Sep 2012 11:28:52 -0400
Message-ID: <1348932532.23909.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33773 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2I2PeZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:34:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix interrupt delay multipler conversion for eq_create


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c  |   15 +++++++++++----
 lpfc_sli4.h |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2012-09-26 21:11:18.456153500 -0400
@@ -626,7 +626,7 @@ void lpfc_sli4_hba_reset(struct lpfc_hba
 struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
 			uint32_t);
 void lpfc_sli4_queue_free(struct lpfc_queue *);
-uint32_t lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint16_t);
+uint32_t lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
 uint32_t lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint16_t);
 uint32_t lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:18.464153500 -0400
@@ -12099,6 +12099,7 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba
 	struct lpfc_queue *eq;
 	int cnt, rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
+	uint32_t result;
 	int fcp_eqidx;
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint16_t dmult;
@@ -12117,8 +12118,11 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba
 	eq_delay = &mbox->u.mqe.un.eq_delay;
 
 	/* Calculate delay multiper from maximum interrupt per second */
-	dmult = phba->cfg_fcp_imax / phba->cfg_fcp_io_channel;
-	dmult = LPFC_DMULT_CONST/dmult - 1;
+	result = phba->cfg_fcp_imax / phba->cfg_fcp_io_channel;
+	if (result > LPFC_DMULT_CONST)
+		dmult = 0;
+	else
+		dmult = LPFC_DMULT_CONST/result - 1;
 
 	cnt = 0;
 	for (fcp_eqidx = startq; fcp_eqidx < phba->cfg_fcp_io_channel;
@@ -12174,7 +12178,7 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba
  * fails this function will return -ENXIO.
  **/
 uint32_t
-lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint16_t imax)
+lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 {
 	struct lpfc_mbx_eq_create *eq_create;
 	LPFC_MBOXQ_t *mbox;
@@ -12206,7 +12210,10 @@ lpfc_eq_create(struct lpfc_hba *phba, st
 	       LPFC_EQE_SIZE);
 	bf_set(lpfc_eq_context_valid, &eq_create->u.request.context, 1);
 	/* Calculate delay multiper from maximum interrupt per second */
-	dmult = LPFC_DMULT_CONST/imax - 1;
+	if (imax > LPFC_DMULT_CONST)
+		dmult = 0;
+	else
+		dmult = LPFC_DMULT_CONST/imax - 1;
 	bf_set(lpfc_eq_context_delay_multi, &eq_create->u.request.context,
 	       dmult);
 	switch (eq->entry_count) {



