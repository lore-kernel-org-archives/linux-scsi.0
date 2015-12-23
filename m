From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v3 16/17] be2iscsi: Fix WRB leak in login/logout path
Date: Wed, 23 Dec 2015 14:04:35 +0530
Message-ID: <1450859676-22025-17-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55547 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933741AbbLWIfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2015 03:35:13 -0500
In-Reply-To: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Login/Logout loop was hanging after few hours. /var/log/message showed
that alloc_wrb_handle() function was not able to allocate any new WRB.

Sep 11 11:25:22 Jhelum10 kernel: connection32513:0: Could not send nopout
Sep 11 11:25:22 Jhelum10 kernel: scsi host10: BM_4989 : Alloc of WRB_HANDLE
Failedfor the CID : 384
Sep 11 11:25:22 Jhelum10 kernel: connection32513:0: Could not allocate pdu for
mgmt task.

Driver allocates WRB to pass login negotiated parameters information to FW
in beiscsi_offload_connection(). This allocated WRB was not freed so there
was WRB_Leak happening.

Put WRB used for posting the login-negotiated parameters back in pool.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_main.c | 72 ++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9a86044..d8cdb4e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1184,6 +1184,22 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->io_sgl_free_index++;
 }
 
+static inline struct wrb_handle *
+beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
+		       unsigned int wrbs_per_cxn)
+{
+	struct wrb_handle *pwrb_handle;
+
+	pwrb_handle = pwrb_context->pwrb_handle_base[pwrb_context->alloc_index];
+	pwrb_context->wrb_handles_available--;
+	if (pwrb_context->alloc_index == (wrbs_per_cxn - 1))
+		pwrb_context->alloc_index = 0;
+	else
+		pwrb_context->alloc_index++;
+
+	return pwrb_handle;
+}
+
 /**
  * alloc_wrb_handle - To allocate a wrb handle
  * @phba: The hba pointer
@@ -1193,30 +1209,30 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
  * This happens under session_lock until submission to chip
  */
 struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
-				     struct hwi_wrb_context **pcontext)
+				    struct hwi_wrb_context **pcontext)
 {
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
-	struct wrb_handle *pwrb_handle;
 	uint16_t cri_index = BE_GET_CRI_FROM_CID(cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
-	if (pwrb_context->wrb_handles_available >= 2) {
-		pwrb_handle = pwrb_context->pwrb_handle_base[
-					    pwrb_context->alloc_index];
-		pwrb_context->wrb_handles_available--;
-		if (pwrb_context->alloc_index ==
-						(phba->params.wrbs_per_cxn - 1))
-			pwrb_context->alloc_index = 0;
-		else
-			pwrb_context->alloc_index++;
+	/* return the context address */
+	*pcontext = pwrb_context;
+	return beiscsi_get_wrb_handle(pwrb_context, phba->params.wrbs_per_cxn);
+}
 
-		/* Return the context address */
-		*pcontext = pwrb_context;
-	} else
-		pwrb_handle = NULL;
-	return pwrb_handle;
+static inline void
+beiscsi_put_wrb_handle(struct hwi_wrb_context *pwrb_context,
+		       struct wrb_handle *pwrb_handle,
+		       unsigned int wrbs_per_cxn)
+{
+	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
+	pwrb_context->wrb_handles_available++;
+	if (pwrb_context->free_index == (wrbs_per_cxn - 1))
+		pwrb_context->free_index = 0;
+	else
+		pwrb_context->free_index++;
 }
 
 /**
@@ -1231,13 +1247,9 @@ static void
 free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 		struct wrb_handle *pwrb_handle)
 {
-	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
-	pwrb_context->wrb_handles_available++;
-	if (pwrb_context->free_index == (phba->params.wrbs_per_cxn - 1))
-		pwrb_context->free_index = 0;
-	else
-		pwrb_context->free_index++;
-
+	beiscsi_put_wrb_handle(pwrb_context,
+			       pwrb_handle,
+			       phba->params.wrbs_per_cxn);
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
 		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x"
@@ -4715,6 +4727,20 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 	iowrite32(doorbell, phba->db_va +
 		  beiscsi_conn->doorbell_offset);
+
+	/*
+	 * There is no completion for CONTEXT_UPDATE. The completion of next
+	 * WRB posted guarantees FW's processing and DMA'ing of it.
+	 * Use beiscsi_put_wrb_handle to put it back in the pool which makes
+	 * sure zero'ing or reuse of the WRB only after wrbs_per_cxn.
+	 */
+	beiscsi_put_wrb_handle(pwrb_context, pwrb_handle,
+			       phba->params.wrbs_per_cxn);
+	beiscsi_log(phba, KERN_INFO,
+		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+		    "BM_%d : put CONTEXT_UPDATE pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
+		    pwrb_handle, pwrb_context->free_index,
+		    pwrb_context->wrb_handles_available);
 }
 
 static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,
-- 
1.9.1

