Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41543C43462
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BDB461025
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbhDLBc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbhDLBcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782D3C06138E
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k8so8156192pgf.4
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8BJXMZjEGaxUTt+UebTTe37Z0mV0i1yadTkWxxgDuys=;
        b=dJU9ROr2BEwPW/JcsTt05KEmJNWL4wDHhd1cKnykz5no2RCpnDGUyhMhXmKojvLRed
         DUhTC6703UHc+524O70zRm+FtLJ1XXSlsCpWkWB9ZDQgUcGxpDlJkqtyeVTfCYwrNPdX
         2K4xYTSz1E7JvrF05jZ0fKqY4FeTxeRHbPJpC7iG7cFcnfHwSGEciaKmPOTiaU3Rnnyy
         mGd4yt5boOC0eoXC7G+Vd8yrESYa+xdJZ7nkx6H+9vJMt2J3T/Qj9rDsVtYD0OJnPrH5
         kQO0fYGUKnZlE8ESiLnoZ9/Pal3emgFDsyFLxsP4wGvqvyJeV9WVc9j/deV4H3IpunAU
         CRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8BJXMZjEGaxUTt+UebTTe37Z0mV0i1yadTkWxxgDuys=;
        b=iScpTOTje0gbNYbPmvkJLquw+pJuyEbJ86EHAogtwgIaXGRbDfP5fkMjT2rMQUvqFq
         c2gmRla2vDE5KEGuG56BMo/hXCpT3EjEzkQ2yi5zlRVtgP7WGjtMkr9q/9+M9uSjNCaF
         i/sAL84VNdw3oOaqFnMpBmMcwfyte8UZ/68tsHmkEMLAHEd8VZFqUUDDAEUBJaz0mrXb
         k3HMOzVSpWI23VnNsD1YaxF4o3pLKGUveEF6h2GbrzjFORb1t6w6N3WvTM05QzqA7e1P
         yK625AsYdGBlqXAm0Ri19VC5nSFqOcbOqvSri26w5d/q4NXWUkmtXUqfgNj5QpqB45T+
         LLWw==
X-Gm-Message-State: AOAM533FfIf6R89XWdoeE5aDrQXeixKITnjktUFR5/jPk9NMvCMb/ZZv
        /wiXFkiByQ1bsJeN0ghvvG1jHIGUPrc=
X-Google-Smtp-Source: ABdhPJwxlgkz3OxfbhAOw7u3aoY4b0zACgUxz9+YUXtol43qcNeET8CYuDmwfSkc2gLT6hr06EDi/A==
X-Received: by 2002:a62:77c1:0:b029:244:4080:8c7b with SMTP id s184-20020a6277c10000b029024440808c7bmr17873204pfc.69.1618191123709;
        Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 06/16] lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
Date:   Sun, 11 Apr 2021 18:31:17 -0700
Message-Id: <20210412013127.2387-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
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

