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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84593C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C5FB610A4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhDJRbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbhDJRbG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:06 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55BFC06138D
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d10so6163107pgf.12
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsDiquHv/UpJpUHaRzhhsHOX86D9c+OhSHIoAwHnNkQ=;
        b=pwoZmc5tplvmGRJHcaMD+JxIoh5yi2e5+6RvIxmmRxHgTY0LvjLfDVBWPF+zjzqA3l
         OatPpq8YS8Zpp3mjvmzMFHkqZjIuIEbBvM8ooiLP7HpQbKbc4Ub2oPnweGLmHO2Uty5w
         aoOfaXuxT/5txarZhUDnyDJZMq3aA4XG0SFodMK4Cjko9068rTWyMpMSRw8ZJZSBK/Su
         78/kUgkY7kjuyZ2kY6kSJnWReJC8KtokhxXpiLdwaRVDo9d/KT/Gx2spRXr8KbQJiA1J
         k+DnXwVUU6oWyhVqS5gHr3/YalyauVG12z5GFqzcKaE+DpQGqYoM4f93ptgm28iz6tNB
         Khzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsDiquHv/UpJpUHaRzhhsHOX86D9c+OhSHIoAwHnNkQ=;
        b=lGyf+3qEet+wr4ReaH75YyOt/byWtguxrqdCRQcR3Aq0S/QbaUmRCDmqWwgC8niNXW
         7ekHBS0+B8NLu7tw/oMiVK47s6JLaBnWhDVMqwPc9NCf8+gyFBJpi4tb8R/5rsq7R2tm
         b1341NQqZBXXVLESAFZ3xJnZCFee6rGFak6gIDr2vC6HLB60hRmYxmPIqWQLryIY4brD
         VrUowEPzb8s+GfKx2ZcZ3YMCH9tW6Bnt9k3rcXK79wZ0edr3gnzWkbhVm2RIvn0v6n9O
         bNmo6vcfALsQyOIO8u9J5H21JSsjXh4K6aE6YF28IuzwAduECc4SZ6QBeMzkUJH9t0B5
         8nlw==
X-Gm-Message-State: AOAM532zVaR7mqaGuB8jtXggyAiVWxO4khnggUVNrh906Hvpv11zrxj/
        ATcUnvrR28rOmwSg/i4GcA4q7G8PKWg=
X-Google-Smtp-Source: ABdhPJxCA3W2hs3tjGinrt6DmbmTzSJd7B/M3ZaiZ1d/Rhz0eZE3J8p1V0Q1mLAYrYiH4RnEe6cFFg==
X-Received: by 2002:a05:6a00:cc8:b029:217:4606:5952 with SMTP id b8-20020a056a000cc8b029021746065952mr18017487pfv.50.1618075850998;
        Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/16] lpfc: Remove unsupported mbox PORT_CAPABILITIES logic
Date:   Sat, 10 Apr 2021 10:30:29 -0700
Message-Id: <20210410173034.67618-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SLI-4 does not contain a PORT_CAPABILITIES mailbox command (only SLI-3
does, and SLI-3 doesn't use it), yet there are SLI-4 code paths that
have code to issue the command.  The command will always fail.

Remove the code for the mailbox command and leave only the resulting
"failure path" logic.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |   3 -
 drivers/scsi/lpfc/lpfc_hw4.h  | 174 +---------------------------------
 drivers/scsi/lpfc/lpfc_init.c | 103 +-------------------
 drivers/scsi/lpfc/lpfc_mbox.c |  36 -------
 4 files changed, 3 insertions(+), 313 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index e7db4496e8a9..383abf46fd29 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -55,9 +55,6 @@ void lpfc_register_new_vport(struct lpfc_hba *, struct lpfc_vport *,
 void lpfc_unreg_vpi(struct lpfc_hba *, uint16_t, LPFC_MBOXQ_t *);
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
-void lpfc_supported_pages(struct lpfcMboxq *);
-void lpfc_pc_sli4_params(struct lpfcMboxq *);
-int lpfc_pc_sli4_params_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli4_mbox_rsrc_extent(struct lpfc_hba *, struct lpfcMboxq *,
 			   uint16_t, uint16_t, bool);
 int lpfc_get_sli4_parameters(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 541b9aef6bfe..f5bc2c32a817 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -124,6 +124,7 @@ struct lpfc_sli_intf {
 /* Define SLI4 Alignment requirements. */
 #define LPFC_ALIGN_16_BYTE	16
 #define LPFC_ALIGN_64_BYTE	64
+#define SLI4_PAGE_SIZE		4096
 
 /* Define SLI4 specific definitions. */
 #define LPFC_MQ_CQE_BYTE_OFFSET	256
@@ -2976,62 +2977,6 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_mrqp_WORD		word3
 };
 
-struct lpfc_mbx_supp_pages {
-	uint32_t word1;
-#define qs_SHIFT 				0
-#define qs_MASK					0x00000001
-#define qs_WORD					word1
-#define wr_SHIFT				1
-#define wr_MASK 				0x00000001
-#define wr_WORD					word1
-#define pf_SHIFT				8
-#define pf_MASK					0x000000ff
-#define pf_WORD					word1
-#define cpn_SHIFT				16
-#define cpn_MASK				0x000000ff
-#define cpn_WORD				word1
-	uint32_t word2;
-#define list_offset_SHIFT 			0
-#define list_offset_MASK			0x000000ff
-#define list_offset_WORD			word2
-#define next_offset_SHIFT			8
-#define next_offset_MASK			0x000000ff
-#define next_offset_WORD			word2
-#define elem_cnt_SHIFT				16
-#define elem_cnt_MASK				0x000000ff
-#define elem_cnt_WORD				word2
-	uint32_t word3;
-#define pn_0_SHIFT				24
-#define pn_0_MASK  				0x000000ff
-#define pn_0_WORD				word3
-#define pn_1_SHIFT				16
-#define pn_1_MASK				0x000000ff
-#define pn_1_WORD				word3
-#define pn_2_SHIFT				8
-#define pn_2_MASK				0x000000ff
-#define pn_2_WORD				word3
-#define pn_3_SHIFT				0
-#define pn_3_MASK				0x000000ff
-#define pn_3_WORD				word3
-	uint32_t word4;
-#define pn_4_SHIFT				24
-#define pn_4_MASK				0x000000ff
-#define pn_4_WORD				word4
-#define pn_5_SHIFT				16
-#define pn_5_MASK				0x000000ff
-#define pn_5_WORD				word4
-#define pn_6_SHIFT				8
-#define pn_6_MASK				0x000000ff
-#define pn_6_WORD				word4
-#define pn_7_SHIFT				0
-#define pn_7_MASK				0x000000ff
-#define pn_7_WORD				word4
-	uint32_t rsvd[27];
-#define LPFC_SUPP_PAGES			0
-#define LPFC_BLOCK_GUARD_PROFILES	1
-#define LPFC_SLI4_PARAMETERS		2
-};
-
 struct lpfc_mbx_memory_dump_type3 {
 	uint32_t word1;
 #define lpfc_mbx_memory_dump_type3_type_SHIFT    0
@@ -3248,121 +3193,6 @@ struct user_eeprom {
 	uint8_t reserved191[57];
 };
 
-struct lpfc_mbx_pc_sli4_params {
-	uint32_t word1;
-#define qs_SHIFT				0
-#define qs_MASK					0x00000001
-#define qs_WORD					word1
-#define wr_SHIFT				1
-#define wr_MASK					0x00000001
-#define wr_WORD					word1
-#define pf_SHIFT				8
-#define pf_MASK					0x000000ff
-#define pf_WORD					word1
-#define cpn_SHIFT				16
-#define cpn_MASK				0x000000ff
-#define cpn_WORD				word1
-	uint32_t word2;
-#define if_type_SHIFT				0
-#define if_type_MASK				0x00000007
-#define if_type_WORD				word2
-#define sli_rev_SHIFT				4
-#define sli_rev_MASK				0x0000000f
-#define sli_rev_WORD				word2
-#define sli_family_SHIFT			8
-#define sli_family_MASK				0x000000ff
-#define sli_family_WORD				word2
-#define featurelevel_1_SHIFT			16
-#define featurelevel_1_MASK			0x000000ff
-#define featurelevel_1_WORD			word2
-#define featurelevel_2_SHIFT			24
-#define featurelevel_2_MASK			0x0000001f
-#define featurelevel_2_WORD			word2
-	uint32_t word3;
-#define fcoe_SHIFT 				0
-#define fcoe_MASK				0x00000001
-#define fcoe_WORD				word3
-#define fc_SHIFT				1
-#define fc_MASK					0x00000001
-#define fc_WORD					word3
-#define nic_SHIFT				2
-#define nic_MASK				0x00000001
-#define nic_WORD				word3
-#define iscsi_SHIFT				3
-#define iscsi_MASK				0x00000001
-#define iscsi_WORD				word3
-#define rdma_SHIFT				4
-#define rdma_MASK				0x00000001
-#define rdma_WORD				word3
-	uint32_t sge_supp_len;
-#define SLI4_PAGE_SIZE 4096
-	uint32_t word5;
-#define if_page_sz_SHIFT			0
-#define if_page_sz_MASK				0x0000ffff
-#define if_page_sz_WORD				word5
-#define loopbk_scope_SHIFT			24
-#define loopbk_scope_MASK			0x0000000f
-#define loopbk_scope_WORD			word5
-#define rq_db_window_SHIFT			28
-#define rq_db_window_MASK			0x0000000f
-#define rq_db_window_WORD			word5
-	uint32_t word6;
-#define eq_pages_SHIFT				0
-#define eq_pages_MASK				0x0000000f
-#define eq_pages_WORD				word6
-#define eqe_size_SHIFT				8
-#define eqe_size_MASK				0x000000ff
-#define eqe_size_WORD				word6
-	uint32_t word7;
-#define cq_pages_SHIFT				0
-#define cq_pages_MASK				0x0000000f
-#define cq_pages_WORD				word7
-#define cqe_size_SHIFT				8
-#define cqe_size_MASK				0x000000ff
-#define cqe_size_WORD				word7
-	uint32_t word8;
-#define mq_pages_SHIFT				0
-#define mq_pages_MASK				0x0000000f
-#define mq_pages_WORD				word8
-#define mqe_size_SHIFT				8
-#define mqe_size_MASK				0x000000ff
-#define mqe_size_WORD				word8
-#define mq_elem_cnt_SHIFT			16
-#define mq_elem_cnt_MASK			0x000000ff
-#define mq_elem_cnt_WORD			word8
-	uint32_t word9;
-#define wq_pages_SHIFT				0
-#define wq_pages_MASK				0x0000ffff
-#define wq_pages_WORD				word9
-#define wqe_size_SHIFT				8
-#define wqe_size_MASK				0x000000ff
-#define wqe_size_WORD				word9
-	uint32_t word10;
-#define rq_pages_SHIFT				0
-#define rq_pages_MASK				0x0000ffff
-#define rq_pages_WORD				word10
-#define rqe_size_SHIFT				8
-#define rqe_size_MASK				0x000000ff
-#define rqe_size_WORD				word10
-	uint32_t word11;
-#define hdr_pages_SHIFT				0
-#define hdr_pages_MASK				0x0000000f
-#define hdr_pages_WORD				word11
-#define hdr_size_SHIFT				8
-#define hdr_size_MASK				0x0000000f
-#define hdr_size_WORD				word11
-#define hdr_pp_align_SHIFT			16
-#define hdr_pp_align_MASK			0x0000ffff
-#define hdr_pp_align_WORD			word11
-	uint32_t word12;
-#define sgl_pages_SHIFT				0
-#define sgl_pages_MASK				0x0000000f
-#define sgl_pages_WORD				word12
-#define sgl_pp_align_SHIFT			16
-#define sgl_pp_align_MASK			0x0000ffff
-#define sgl_pp_align_WORD			word12
-	uint32_t rsvd_13_63[51];
-};
 #define SLI4_PAGE_ALIGN(addr) (((addr)+((SLI4_PAGE_SIZE)-1)) \
 			       &(~((SLI4_PAGE_SIZE)-1)))
 
@@ -3994,8 +3824,6 @@ struct lpfc_mqe {
 		struct lpfc_mbx_post_hdr_tmpl hdr_tmpl;
 		struct lpfc_mbx_query_fw_config query_fw_cfg;
 		struct lpfc_mbx_set_beacon_config beacon_config;
-		struct lpfc_mbx_supp_pages supp_pages;
-		struct lpfc_mbx_pc_sli4_params sli4_params;
 		struct lpfc_mbx_get_sli4_parameters get_sli4_parameters;
 		struct lpfc_mbx_set_link_diag_state link_diag_state;
 		struct lpfc_mbx_set_link_diag_loopback link_diag_loopback;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index be13a5e20efa..c80fd7d49f6e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6569,8 +6569,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *mb;
 	int rc, i, max_buf_size;
-	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
-	struct lpfc_mqe *mqe;
 	int longs;
 	int extra;
 	uint64_t wwn;
@@ -6804,32 +6802,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	lpfc_nvme_mod_param_dep(phba);
 
-	/* Get the Supported Pages if PORT_CAPABILITIES is supported by port. */
-	lpfc_supported_pages(mboxq);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (!rc) {
-		mqe = &mboxq->u.mqe;
-		memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
-		       LPFC_MAX_SUPPORTED_PAGES);
-		for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
-			switch (pn_page[i]) {
-			case LPFC_SLI4_PARAMETERS:
-				phba->sli4_hba.pc_sli4_params.supported = 1;
-				break;
-			default:
-				break;
-			}
-		}
-		/* Read the port's SLI4 Parameters capabilities if supported. */
-		if (phba->sli4_hba.pc_sli4_params.supported)
-			rc = lpfc_pc_sli4_params_get(phba, mboxq);
-		if (rc) {
-			mempool_free(mboxq, phba->mbox_mem_pool);
-			rc = -EIO;
-			goto out_free_bsmbx;
-		}
-	}
-
 	/*
 	 * Get sli4 parameters that override parameters from Port capabilities.
 	 * If this call fails, it isn't critical unless the SLI4 parameters come
@@ -12066,78 +12038,6 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 		phba->pport->work_port_events = 0;
 }
 
- /**
- * lpfc_pc_sli4_params_get - Get the SLI4_PARAMS port capabilities.
- * @phba: Pointer to HBA context object.
- * @mboxq: Pointer to the mailboxq memory for the mailbox command response.
- *
- * This function is called in the SLI4 code path to read the port's
- * sli4 capabilities.
- *
- * This function may be be called from any context that can block-wait
- * for the completion.  The expectation is that this routine is called
- * typically from probe_one or from the online routine.
- **/
-int
-lpfc_pc_sli4_params_get(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
-{
-	int rc;
-	struct lpfc_mqe *mqe;
-	struct lpfc_pc_sli4_params *sli4_params;
-	uint32_t mbox_tmo;
-
-	rc = 0;
-	mqe = &mboxq->u.mqe;
-
-	/* Read the port's SLI4 Parameters port capabilities */
-	lpfc_pc_sli4_params(mboxq);
-	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
-		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
-	}
-
-	if (unlikely(rc))
-		return 1;
-
-	sli4_params = &phba->sli4_hba.pc_sli4_params;
-	sli4_params->if_type = bf_get(if_type, &mqe->un.sli4_params);
-	sli4_params->sli_rev = bf_get(sli_rev, &mqe->un.sli4_params);
-	sli4_params->sli_family = bf_get(sli_family, &mqe->un.sli4_params);
-	sli4_params->featurelevel_1 = bf_get(featurelevel_1,
-					     &mqe->un.sli4_params);
-	sli4_params->featurelevel_2 = bf_get(featurelevel_2,
-					     &mqe->un.sli4_params);
-	sli4_params->proto_types = mqe->un.sli4_params.word3;
-	sli4_params->sge_supp_len = mqe->un.sli4_params.sge_supp_len;
-	sli4_params->if_page_sz = bf_get(if_page_sz, &mqe->un.sli4_params);
-	sli4_params->rq_db_window = bf_get(rq_db_window, &mqe->un.sli4_params);
-	sli4_params->loopbk_scope = bf_get(loopbk_scope, &mqe->un.sli4_params);
-	sli4_params->eq_pages_max = bf_get(eq_pages, &mqe->un.sli4_params);
-	sli4_params->eqe_size = bf_get(eqe_size, &mqe->un.sli4_params);
-	sli4_params->cq_pages_max = bf_get(cq_pages, &mqe->un.sli4_params);
-	sli4_params->cqe_size = bf_get(cqe_size, &mqe->un.sli4_params);
-	sli4_params->mq_pages_max = bf_get(mq_pages, &mqe->un.sli4_params);
-	sli4_params->mqe_size = bf_get(mqe_size, &mqe->un.sli4_params);
-	sli4_params->mq_elem_cnt = bf_get(mq_elem_cnt, &mqe->un.sli4_params);
-	sli4_params->wq_pages_max = bf_get(wq_pages, &mqe->un.sli4_params);
-	sli4_params->wqe_size = bf_get(wqe_size, &mqe->un.sli4_params);
-	sli4_params->rq_pages_max = bf_get(rq_pages, &mqe->un.sli4_params);
-	sli4_params->rqe_size = bf_get(rqe_size, &mqe->un.sli4_params);
-	sli4_params->hdr_pages_max = bf_get(hdr_pages, &mqe->un.sli4_params);
-	sli4_params->hdr_size = bf_get(hdr_size, &mqe->un.sli4_params);
-	sli4_params->hdr_pp_align = bf_get(hdr_pp_align, &mqe->un.sli4_params);
-	sli4_params->sgl_pages_max = bf_get(sgl_pages, &mqe->un.sli4_params);
-	sli4_params->sgl_pp_align = bf_get(sgl_pp_align, &mqe->un.sli4_params);
-
-	/* Make sure that sge_supp_len can be handled by the driver */
-	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
-		sli4_params->sge_supp_len = LPFC_MAX_SGE_SIZE;
-
-	return rc;
-}
-
 /**
  * lpfc_get_sli4_parameters - Get the SLI4 Config PARAMETERS.
  * @phba: Pointer to HBA context object.
@@ -12196,7 +12096,8 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->sli3_options &= ~LPFC_SLI4_PHWQ_ENABLED;
 	sli4_params->sge_supp_len = mbx_sli4_parameters->sge_supp_len;
-	sli4_params->loopbk_scope = bf_get(loopbk_scope, mbx_sli4_parameters);
+	sli4_params->loopbk_scope = bf_get(cfg_loopbk_scope,
+					   mbx_sli4_parameters);
 	sli4_params->oas_supported = bf_get(cfg_oas, mbx_sli4_parameters);
 	sli4_params->cqv = bf_get(cfg_cqv, mbx_sli4_parameters);
 	sli4_params->mqv = bf_get(cfg_mqv, mbx_sli4_parameters);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index c03a7f12dd65..72dd22ad5dcc 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2624,39 +2624,3 @@ lpfc_resume_rpi(struct lpfcMboxq *mbox, struct lpfc_nodelist *ndlp)
 	resume_rpi->event_tag = ndlp->phba->fc_eventTag;
 }
 
-/**
- * lpfc_supported_pages - Initialize the PORT_CAPABILITIES supported pages
- *                        mailbox command.
- * @mbox: pointer to lpfc mbox command to initialize.
- *
- * The PORT_CAPABILITIES supported pages mailbox command is issued to
- * retrieve the particular feature pages supported by the port.
- **/
-void
-lpfc_supported_pages(struct lpfcMboxq *mbox)
-{
-	struct lpfc_mbx_supp_pages *supp_pages;
-
-	memset(mbox, 0, sizeof(*mbox));
-	supp_pages = &mbox->u.mqe.un.supp_pages;
-	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_PORT_CAPABILITIES);
-	bf_set(cpn, supp_pages, LPFC_SUPP_PAGES);
-}
-
-/**
- * lpfc_pc_sli4_params - Initialize the PORT_CAPABILITIES SLI4 Params mbox cmd.
- * @mbox: pointer to lpfc mbox command to initialize.
- *
- * The PORT_CAPABILITIES SLI4 parameters mailbox command is issued to
- * retrieve the particular SLI4 features supported by the port.
- **/
-void
-lpfc_pc_sli4_params(struct lpfcMboxq *mbox)
-{
-	struct lpfc_mbx_pc_sli4_params *sli4_params;
-
-	memset(mbox, 0, sizeof(*mbox));
-	sli4_params = &mbox->u.mqe.un.sli4_params;
-	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_PORT_CAPABILITIES);
-	bf_set(cpn, sli4_params, LPFC_SLI4_PARAMETERS);
-}
-- 
2.26.2

