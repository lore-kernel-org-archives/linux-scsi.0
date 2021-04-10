Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547D8C43600
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311E9611AE
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhDJRbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhDJRbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:03 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AB2C06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id ay2so4253385plb.3
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8BJXMZjEGaxUTt+UebTTe37Z0mV0i1yadTkWxxgDuys=;
        b=DA+6+mrt7cMDe/aaHL5o/H5S1772nEwCXPvM8PzyQeLTzKyfy/UxLXUdTA6W5fgoTB
         J2HpQlOTEsJq5SVGbLJNejAtFYpDq1C80jGLnsUQeuGgB+754UB3aQUbneJcRCPy+1WG
         6q+yEQ/fxOEjB507ED9oO/ec6qWWL5IMuLDkZ+RSpn7M6RtR/YbDkBWqzJHepbt/oHTY
         eRSNfVMw45WA1IDLJbpl56bjyuPg5SsxVB5fj11HSXs5+Tw+ah1tch+lBSsTn+OXbFBD
         Wyn0CYhwtGsJQ9/Xj/ZpwPnVwd+31v2dxlmw2aLCycFYTROaYpX+He2P9RE98svUcsXD
         Nd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8BJXMZjEGaxUTt+UebTTe37Z0mV0i1yadTkWxxgDuys=;
        b=r3zOwStBxpoCtcLqjs22dxb5oLQzo23DvpE8GjRYRZLIASfQbF7wbzNpjiRanIuOuI
         bA1Cq1DVfpD9VAEfncvN9hwxuv1OBisSR4mVlxXUkKuZF70VsoaSWXlfuUiAFuyf8//P
         KPzL3/cDLy66NFgVTF23eBRM9ErMoMFsy0y82OMRCmAq9wO9Ruqb0X4edsU7eQXnr8Li
         P/S8TXR/v9uX/NJ7bGj4aNbAcvWuMVzPa7xcTO8hdw2avLPdKzwrlwnuYdWhUE01fMew
         ugkdaG6Rsc0QmmJMGuygjfutO2X92H/FkY97iBYwOwSJbC7UA7CcgVBtrJiZFdtzhwuK
         a9mw==
X-Gm-Message-State: AOAM532anD+56WeZWskd6jpg41oCsJDZ69m1PF8WW4PnyrecmMJzVzf8
        6uovluY7AbeuRE6WXz6XNa15nNdU5j0=
X-Google-Smtp-Source: ABdhPJzq/b9cd3bLun8Jha81RGAlEgKzbwsyERgA3P8hobl0qIJ11RLpui7djyfQb1jVuwlARAyalw==
X-Received: by 2002:a17:902:684a:b029:e9:7f54:b7eb with SMTP id f10-20020a170902684ab02900e97f54b7ebmr15519901pln.36.1618075848031;
        Sat, 10 Apr 2021 10:30:48 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/16] lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
Date:   Sat, 10 Apr 2021 10:30:24 -0700
Message-Id: <20210410173034.67618-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In SLI-4, when performing a mailbox command with MBX_POLL, the driver
uses the BMBX register to send the command rather than the MQ. A flag
is set indicating the BMBX register is active and saves the mailbox
job struct (mboxq) in the mbox_active element of the adapter. The
routine then waits for completion or timeout. The mailbox job struct
is not freed by the routine. In cases of timeout, the adapter will be
reset. The lpfc_sli_mbox_sys_flush routine will clean up the mbox in
preparation for the reset. It clears the BMBX active flag and marks
the job structure as MBX_NOT_FINISHED. But, it never frees the mboxq
job structure. Expectation in both normal completion and timeout
cases is that the issuer of the mbx command will free the structure.
Unfortunately, not all calling paths are freeing the memory in cases
of error.

All calling paths were looked at and updated, if missing, to free
the mboxq memory regardless of completion status.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 75 +++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_init.c |  9 ++---
 drivers/scsi/lpfc/lpfc_sli.c  | 42 ++++++++++----------
 3 files changed, 70 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 8b4c42016865..b253be355b4f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1687,8 +1687,7 @@ lpfc_set_trunking(struct lpfc_hba *phba, char *buff_out)
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
 				"0071 Set trunk mode failed with status: %d",
 				rc);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+	mempool_free(mbox, phba->mbox_mem_pool);
 
 	return 0;
 }
@@ -6793,15 +6792,19 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->ctx_buf = NULL;
 	pmboxq->vport = vport;
 
-	if (vport->fc_flag & FC_OFFLINE_MODE)
+	if (vport->fc_flag & FC_OFFLINE_MODE) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
+		if (rc != MBX_SUCCESS) {
 			mempool_free(pmboxq, phba->mbox_mem_pool);
-		return NULL;
+			return NULL;
+		}
+	} else {
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return NULL;
+		}
 	}
 
 	memset(hs, 0, sizeof (struct fc_host_statistics));
@@ -6825,15 +6828,19 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->ctx_buf = NULL;
 	pmboxq->vport = vport;
 
-	if (vport->fc_flag & FC_OFFLINE_MODE)
+	if (vport->fc_flag & FC_OFFLINE_MODE) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
+		if (rc != MBX_SUCCESS) {
 			mempool_free(pmboxq, phba->mbox_mem_pool);
-		return NULL;
+			return NULL;
+		}
+	} else {
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return NULL;
+		}
 	}
 
 	hs->link_failure_count = pmb->un.varRdLnk.linkFailureCnt;
@@ -6906,15 +6913,19 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+		(!(psli->sli_flag & LPFC_SLI_ACTIVE))) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
+		if (rc != MBX_SUCCESS) {
 			mempool_free(pmboxq, phba->mbox_mem_pool);
-		return;
+			return;
+		}
+	} else {
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return;
+		}
 	}
 
 	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
@@ -6924,15 +6935,19 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+	    (!(psli->sli_flag & LPFC_SLI_ACTIVE))) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
+		if (rc != MBX_SUCCESS) {
+			mempool_free(pmboxq, phba->mbox_mem_pool);
+			return;
+		}
+	} else {
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
-			mempool_free( pmboxq, phba->mbox_mem_pool);
-		return;
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return;
+		}
 	}
 
 	lso->link_failure_count = pmb->un.varRdLnk.linkFailureCnt;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 631f22baf45f..be13a5e20efa 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9654,8 +9654,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 				"3250 QUERY_FW_CFG mailbox failed with status "
 				"x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(mboxq, phba->mbox_mem_pool);
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		rc = -ENXIO;
 		goto out_error;
 	}
@@ -9671,8 +9670,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			"ulp1_mode:x%x\n", phba->sli4_hba.fw_func_mode,
 			phba->sli4_hba.ulp0_mode, phba->sli4_hba.ulp1_mode);
 
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * Set up HBA Event Queues (EQs)
@@ -10270,8 +10268,7 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 		shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
 					 &shdr->response);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(mboxq, phba->mbox_mem_pool);
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		if (shdr_status || shdr_add_status || rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"0495 SLI_FUNCTION_RESET mailbox "
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cd9943f91eff..3b48e3e88e67 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5680,12 +5680,10 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 			phba->sli4_hba.lnk_info.lnk_no,
 			phba->BIOSVersion);
 out_free_mboxq:
-	if (rc != MBX_TIMEOUT) {
-		if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
-			lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		else
-			mempool_free(mboxq, phba->mbox_mem_pool);
-	}
+	if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	else
+		mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
 }
 
@@ -5786,12 +5784,10 @@ lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
 	}
 
 out_free_mboxq:
-	if (rc != MBX_TIMEOUT) {
-		if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
-			lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		else
-			mempool_free(mboxq, phba->mbox_mem_pool);
-	}
+	if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	else
+		mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
 }
 
@@ -17079,8 +17075,7 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				"2509 RQ_DESTROY mailbox failed with "
 				"status x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(mbox, hrq->phba->mbox_mem_pool);
+		mempool_free(mbox, hrq->phba->mbox_mem_pool);
 		return -ENXIO;
 	}
 	bf_set(lpfc_mbx_rq_destroy_q_id, &mbox->u.mqe.un.rq_destroy.u.request,
@@ -17177,7 +17172,9 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba,
 	shdr = (union lpfc_sli4_cfg_shdr *) &post_sgl_pages->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (rc != MBX_TIMEOUT)
 		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -17374,7 +17371,9 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba *phba,
 	shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	else if (rc != MBX_TIMEOUT)
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -17487,7 +17486,9 @@ lpfc_sli4_post_io_sgl_block(struct lpfc_hba *phba, struct list_head *nblist,
 	shdr = (union lpfc_sli4_cfg_shdr *)&sgl->cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	else if (rc != MBX_TIMEOUT)
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -18837,8 +18838,7 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
 	shdr = (union lpfc_sli4_cfg_shdr *) &hdr_tmpl->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
+	mempool_free(mboxq, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2514 POST_RPI_HDR mailbox failed with "
@@ -20082,7 +20082,9 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 			break;
 		}
 	}
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (rc != MBX_TIMEOUT)
 		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.26.2

