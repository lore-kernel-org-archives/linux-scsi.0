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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4ADC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 553BA61212
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhIJXd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbhIJXdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE14C0613D8
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j6so2936912pfa.4
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bHCwhC7mQKc33ENrUNkrzG8hfgkoJMDaQ5+v8gvc1dk=;
        b=izSGTPSgXXjN4AMtnj3MWHLRG5kGLCt2gwuaMyqOyDbEZMytE+mlENxQ4vZF9/FhET
         y/yjJuQ0HXe5V5uu8FBee/0qnzZrCFsi+Q/hSDI+1GPbW6H+QVoNdMDCH8yO6Isj5NyN
         0awxBtgsvLYv0pWhLD4FL0YCc9QudxcTeSoSl0vf22EVJm+9j2z/cRWXvQXpUNdaj5lm
         yw/7mHgqRG2vHw2Q8xB7LzqcXFtLSPvaxQMN2kwfwr6qFHbpXlYfti3pJo+LtqNfvg7E
         QmtdgkX6QyJlxa9s+nIF6BYVnoSfcy3JTZ1EUEe3ArK7qU+QSnUeW+bokvkXYxSdq099
         ptZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bHCwhC7mQKc33ENrUNkrzG8hfgkoJMDaQ5+v8gvc1dk=;
        b=Y9E2dd8LYzdYcYer9NnJ21iiK5pKa26tuCmq9vQzrrkwcviN4tzPE25NLrPnSMQYH/
         50F9evB/dl++BeYcp0Lq6WfZWbIeKxboEBpnW+W6FrfrXrEyWeEMNS12K2mwsI7+Huxp
         0ril0nEHOBjnFEcom3x1H/bWmQTzc2I5EQDAaaZlJ7vFMKHonUFRH6lLeKB6gAdyshDq
         TmoNh99pcy6rtSfugU+K65xbI5ogY5trN1E3hMkOy5FQW/rpkkcom+Qx7QHxfPDq7rN6
         596Zjq1FtknUQTh9V4wbb081haU5++GwxeJvt60D0k2xWZ6GvmylTIVnsSRTAQccjhdh
         y4JQ==
X-Gm-Message-State: AOAM5322cfl9fCsWsY1h6QQGxX8Z/gPigf8YU1zHMa8oHAnUNTOo/n5f
        IUj/HYHbRC9EZlpIhRS2ivDkzQOzQPtdcoDW
X-Google-Smtp-Source: ABdhPJygbKbCEEAZk3X0ntsMZQFZJPWPZtnUfj4Tav74KkRh7BWsT3YbV+LcX5HcnA/NFwelNkgxVw==
X-Received: by 2002:a05:6a00:80f:b0:416:1ddf:3ed7 with SMTP id m15-20020a056a00080f00b004161ddf3ed7mr10408764pfk.79.1631316740730;
        Fri, 10 Sep 2021 16:32:20 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:20 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 13/14] lpfc: Improve PBDE checks during SGL processing
Date:   Fri, 10 Sep 2021 16:31:58 -0700
Message-Id: <20210910233159.115896-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The PBDE feature, setting payload buffer address explicitly in the
WQE so it doesn't have to be fetched from the SGL, only makes sense
when there is a single buffer for the I/O. When there are multiple
buffers it actually hurts performance as the SGL subsequently has
to be fetched.

Rework the SGL logic to only use PBDE when a single buffer.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c  | 12 +++++-----
 drivers/scsi/lpfc/lpfc_nvmet.c | 44 ++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_scsi.c  | 26 ++++++++++----------
 3 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 33266e1b24ab..69d3758dd8dc 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1299,7 +1299,6 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 	struct sli4_sge *first_data_sgl;
 	struct ulp_bde64 *bde;
 	dma_addr_t physaddr = 0;
-	uint32_t num_bde = 0;
 	uint32_t dma_len = 0;
 	uint32_t dma_offset = 0;
 	int nseg, i, j;
@@ -1353,7 +1352,7 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 			}
 
 			sgl->word2 = 0;
-			if ((num_bde + 1) == nseg) {
+			if (nseg == 1) {
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 				bf_set(lpfc_sli4_sge_type, sgl,
 				       LPFC_SGE_TYPE_DATA);
@@ -1422,8 +1421,9 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 			j++;
 		}
-		if (phba->cfg_enable_pbde) {
-			/* Use PBDE support for first SGL only, offset == 0 */
+
+		/* PBDE support for first data SGE only */
+		if (nseg == 1 && phba->cfg_enable_pbde) {
 			/* Words 13-15 */
 			bde = (struct ulp_bde64 *)
 				&wqe->words[13];
@@ -1434,11 +1434,11 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 			bde->tus.w = cpu_to_le32(bde->tus.w);
 
-			/* Word 11 */
+			/* Word 11 - set PBDE bit */
 			bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
 		} else {
 			memset(&wqe->words[13], 0, (sizeof(uint32_t) * 3));
-			bf_set(wqe_pbde, &wqe->generic.wqe_com, 0);
+			/* Word 11 - PBDE bit disabled by default template */
 		}
 
 	} else {
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 6e3dd0b9bcfa..731802527b81 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2708,7 +2708,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	struct ulp_bde64 *bde;
 	dma_addr_t physaddr;
 	int i, cnt, nsegs;
-	int do_pbde;
+	bool use_pbde = false;
 	int xc = 1;
 
 	if (!lpfc_is_link_up(phba)) {
@@ -2816,9 +2816,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		if (!xc)
 			bf_set(wqe_xc, &wqe->fcp_tsend.wqe_com, 0);
 
-		/* Word 11 - set sup, irsp, irsplen later */
-		do_pbde = 0;
-
 		/* Word 12 */
 		wqe->fcp_tsend.fcp_data_len = rsp->transfer_length;
 
@@ -2896,12 +2893,13 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		if (!xc)
 			bf_set(wqe_xc, &wqe->fcp_treceive.wqe_com, 0);
 
-		/* Word 11 - set pbde later */
-		if (phba->cfg_enable_pbde) {
-			do_pbde = 1;
+		/* Word 11 - check for pbde */
+		if (nsegs == 1 && phba->cfg_enable_pbde) {
+			use_pbde = true;
+			/* Word 11 - PBDE bit already preset by template */
 		} else {
+			/* Overwrite default template setting */
 			bf_set(wqe_pbde, &wqe->fcp_treceive.wqe_com, 0);
-			do_pbde = 0;
 		}
 
 		/* Word 12 */
@@ -2972,7 +2970,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 			       ((rsp->rsplen >> 2) - 1));
 			memcpy(&wqe->words[16], rsp->rspaddr, rsp->rsplen);
 		}
-		do_pbde = 0;
 
 		/* Word 12 */
 		wqe->fcp_trsp.rsvd_12_15[0] = 0;
@@ -3007,23 +3004,24 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 			bf_set(lpfc_sli4_sge_last, sgl, 1);
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl->sge_len = cpu_to_le32(cnt);
-		if (i == 0) {
-			bde = (struct ulp_bde64 *)&wqe->words[13];
-			if (do_pbde) {
-				/* Words 13-15  (PBDE) */
-				bde->addrLow = sgl->addr_lo;
-				bde->addrHigh = sgl->addr_hi;
-				bde->tus.f.bdeSize =
-					le32_to_cpu(sgl->sge_len);
-				bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-				bde->tus.w = cpu_to_le32(bde->tus.w);
-			} else {
-				memset(bde, 0, sizeof(struct ulp_bde64));
-			}
-		}
 		sgl++;
 		ctxp->offset += cnt;
 	}
+
+	bde = (struct ulp_bde64 *)&wqe->words[13];
+	if (use_pbde) {
+		/* decrement sgl ptr backwards once to first data sge */
+		sgl--;
+
+		/* Words 13-15 (PBDE) */
+		bde->addrLow = sgl->addr_lo;
+		bde->addrHigh = sgl->addr_hi;
+		bde->tus.f.bdeSize = le32_to_cpu(sgl->sge_len);
+		bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		bde->tus.w = cpu_to_le32(bde->tus.w);
+	} else {
+		memset(bde, 0, sizeof(struct ulp_bde64));
+	}
 	ctxp->state = LPFC_NVME_STE_DATA;
 	ctxp->entry_cnt++;
 	return nvmewqe;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a2cd22728b0f..078fbea3f436 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3235,7 +3235,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	struct lpfc_vport *vport = phba->pport;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	dma_addr_t physaddr;
-	uint32_t num_bde = 0;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
 	int nseg, i, j;
@@ -3297,7 +3296,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		j = 2;
 		for (i = 0; i < nseg; i++) {
 			sgl->word2 = 0;
-			if ((num_bde + 1) == nseg) {
+			if (nseg == 1) {
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 				bf_set(lpfc_sli4_sge_type, sgl,
 				       LPFC_SGE_TYPE_DATA);
@@ -3366,13 +3365,15 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 			j++;
 		}
-		/*
-		 * Setup the first Payload BDE. For FCoE we just key off
-		 * Performance Hints, for FC we use lpfc_enable_pbde.
-		 * We populate words 13-15 of IOCB/WQE.
+
+		/* PBDE support for first data SGE only.
+		 * For FCoE, we key off Performance Hints.
+		 * For FC, we key off lpfc_enable_pbde.
 		 */
-		if ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
-		    phba->cfg_enable_pbde) {
+		if (nseg == 1 &&
+		    ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
+		     phba->cfg_enable_pbde)) {
+			/* Words 13-15 */
 			bde = (struct ulp_bde64 *)
 				&wqe->words[13];
 			bde->addrLow = first_data_sgl->addr_lo;
@@ -3382,12 +3383,15 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 			bde->tus.w = cpu_to_le32(bde->tus.w);
 
+			/* Word 11 - set PBDE bit */
+			bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
 		} else {
 			memset(&wqe->words[13], 0, (sizeof(uint32_t) * 3));
+			/* Word 11 - PBDE bit disabled by default template */
 		}
 	} else {
 		sgl += 1;
-		/* clear the last flag in the fcp_rsp map entry */
+		/* set the last flag in the fcp_rsp map entry */
 		sgl->word2 = le32_to_cpu(sgl->word2);
 		bf_set(lpfc_sli4_sge_last, sgl, 1);
 		sgl->word2 = cpu_to_le32(sgl->word2);
@@ -3400,10 +3404,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		}
 	}
 
-	/* Word 11 */
-	if (phba->cfg_enable_pbde)
-		bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
-
 	/*
 	 * Finish initializing those IOCB fields that are dependent on the
 	 * scsi_cmnd request_buffer.  Note that for SLI-2 the bdeSize is
-- 
2.26.2

