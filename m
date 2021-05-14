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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CD5C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A498F616ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhENT5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhENT5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:22 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37870C061756
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:10 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t30so91792pgl.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bPe6c9Ig6WbVrXUKDbeLfPIloOaBYsxbhWx149w2/mw=;
        b=OTa1tkKy5kmTdDnJ4zbJ0Z6mieuyQgJjUhsBNq/dba6a2Ijru+sq8mKkSch97VPcxz
         Y0c+a2bNsbrp8iq9QKW7iHjE0sHAgkbfXyVLeuh26FOUrv7PlVOeqYBGBH4TvC0IMTN7
         zMqFYOJFLH/ZQWgucl2MugAlMhLx4WnaeWwcADn/iv4uK0AOM1mc+sny2LB55V8txj9T
         qbxD5Y1/5ZUAK9JrUx5ViyU2dXb3/+WW+/cumFlILCpIVPMKntlfxfNDhJrmHdMUSvP8
         x0swDTQG9aB1OuiwjkckI6N6gzueFBjJadjVr4znWFOBaFQ+QRdF5dw4+ckyjuMaYDZB
         c2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPe6c9Ig6WbVrXUKDbeLfPIloOaBYsxbhWx149w2/mw=;
        b=MuF55npiXwypKSaTszBB4dC7R94lcV7gdEnDmCum4OwCclYLTZPlT2fgwWC3do9raB
         1/35qfmrXhvpFT4mLmR4fuPDViHj4Bce/smh/+qtjnk3g//gQt+VUokdWFBBaAFOA+B0
         3DWQfM7aAv+8Ow82+sCQq5otUVJaSvEnucAIsw2kD9zLH4e3fCzZyE5HtQCzronJfe2w
         3uEJVmO8oLd5EbQsRZXb7q2YGSvB+GATNZccJhY+FbGHmdJTtMsj4Wc3dZRJm8Lh8aH7
         NpaAyue45MjPFxxAeKL/VfaOi/1M06HHwVeUhvTBA8pTZeSDeqVIppKYUm2wNhUebisk
         51WA==
X-Gm-Message-State: AOAM530uoyfYNL0TCsv31Xnm46eyCHld7HRnkkeEGrm0WgVGV/fuHSgU
        2a8oTwsrLnjRC45rFrPB4TCdeJbu0Ko=
X-Google-Smtp-Source: ABdhPJwO4v5wuS4rcQFVSXDnaa0iE0iheUD0r3cxLTlOc11bMXJfzFZer3upG/dQPd3hO7/+uPnQQQ==
X-Received: by 2002:a05:6a00:b8c:b029:28e:eb6c:ea52 with SMTP id g12-20020a056a000b8cb029028eeb6cea52mr48547338pfj.21.1621022169521;
        Fri, 14 May 2021 12:56:09 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/11] lpfc: Ignore GID-FT response that may be received after a link flip
Date:   Fri, 14 May 2021 12:55:55 -0700
Message-Id: <20210514195559.119853-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a link bounce happens, there is a possibility that responses to
requests posted prior to the link bounce could be received. This is
problematic as the counter to track reglogin completion after link up
can become out of sync with the real state.

As there is no reason to process a request made in a prior link up
context, eliminate all the disturbance by tagging the request with the
event_tag maintained by the SLI Port for the link. The event_tag will
change on every link state transition.  As long as the tag matches the
current event_tag, the response can be processed. If it doesn't match,
just discard the response.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c  | 43 ++++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.h |  3 ++-
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 3bbefa225484..cbf1be56b1e7 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -587,7 +587,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	     struct lpfc_dmabuf *inp, struct lpfc_dmabuf *outp,
 	     void (*cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 		     struct lpfc_iocbq *),
-	     struct lpfc_nodelist *ndlp, uint32_t usr_flg, uint32_t num_entry,
+	     struct lpfc_nodelist *ndlp, uint32_t event_tag, uint32_t num_entry,
 	     uint32_t tmo, uint8_t retry)
 {
 	struct lpfc_hba  *phba = vport->phba;
@@ -608,15 +608,14 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	icmd->un.genreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
 	icmd->un.genreq64.bdl.bdeSize = (num_entry * sizeof(struct ulp_bde64));
 
-	if (usr_flg)
-		geniocb->context3 = NULL;
-	else
-		geniocb->context3 = (uint8_t *) bmp;
+	geniocb->context3 = (uint8_t *) bmp;
 
 	/* Save for completion so we can release these resources */
 	geniocb->context1 = (uint8_t *) inp;
 	geniocb->context2 = (uint8_t *) outp;
 
+	geniocb->event_tag = event_tag;
+
 	/* Fill in payload, bp points to frame payload */
 	icmd->ulpCommand = CMD_GEN_REQUEST64_CR;
 
@@ -707,8 +706,8 @@ lpfc_ct_cmd(struct lpfc_vport *vport, struct lpfc_dmabuf *inmp,
 	 * lpfc_alloc_ct_rsp.
 	 */
 	cnt += 1;
-	status = lpfc_gen_req(vport, bmp, inmp, outmp, cmpl, ndlp, 0,
-			      cnt, 0, retry);
+	status = lpfc_gen_req(vport, bmp, inmp, outmp, cmpl, ndlp,
+			phba->fc_eventTag, cnt, 0, retry);
 	if (status) {
 		lpfc_free_ct_rsp(phba, outmp);
 		return -ENOMEM;
@@ -957,6 +956,13 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 "GID_FT cmpl:     status:x%x/x%x rtry:%d",
 		irsp->ulpStatus, irsp->un.ulpWord[4], vport->fc_ns_retry);
 
+	/* Ignore response if link flipped after this request was made */
+	if (cmdiocb->event_tag != phba->fc_eventTag) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "9043 Event tag mismatch. Ignoring NS rsp\n");
+		goto out;
+	}
+
 	/* Don't bother processing response if vport is being torn down. */
 	if (vport->load_flag & FC_UNLOADING) {
 		if (vport->fc_flag & FC_RSCN_MODE)
@@ -1167,6 +1173,13 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			      irsp->ulpStatus, irsp->un.ulpWord[4],
 			      vport->fc_ns_retry);
 
+	/* Ignore response if link flipped after this request was made */
+	if (cmdiocb->event_tag != phba->fc_eventTag) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "9044 Event tag mismatch. Ignoring NS rsp\n");
+		goto out;
+	}
+
 	/* Don't bother processing response if vport is being torn down. */
 	if (vport->load_flag & FC_UNLOADING) {
 		if (vport->fc_flag & FC_RSCN_MODE)
@@ -1366,6 +1379,13 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		"GFF_ID cmpl:     status:x%x/x%x did:x%x",
 		irsp->ulpStatus, irsp->un.ulpWord[4], did);
 
+	/* Ignore response if link flipped after this request was made */
+	if (cmdiocb->event_tag != phba->fc_eventTag) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "9045 Event tag mismatch. Ignoring NS rsp\n");
+		goto iocb_free;
+	}
+
 	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
 		/* Good status, continue checking */
 		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
@@ -1479,6 +1499,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_start(vport);
 	}
 
+iocb_free:
 	free_ndlp = cmdiocb->context_un.ndlp;
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
@@ -1506,6 +1527,13 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			      "GFT_ID cmpl: status:x%x/x%x did:x%x",
 			      irsp->ulpStatus, irsp->un.ulpWord[4], did);
 
+	/* Ignore response if link flipped after this request was made */
+	if ((uint32_t) cmdiocb->event_tag != phba->fc_eventTag) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "9046 Event tag mismatch. Ignoring NS rsp\n");
+		goto out;
+	}
+
 	/* Preserve the nameserver node to release the reference. */
 	ns_ndlp = cmdiocb->context_un.ndlp;
 
@@ -1572,6 +1600,7 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "3065 GFT_ID failed x%08x\n", irsp->ulpStatus);
 
+out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ns_ndlp);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 4f6936014ff5..e40da1a7ff77 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -106,6 +106,7 @@ struct lpfc_iocbq {
 	void *context1;		/* caller context information */
 	void *context2;		/* caller context information */
 	void *context3;		/* caller context information */
+	uint32_t event_tag;	/* LA Event tag */
 	union {
 		wait_queue_head_t    *wait_queue;
 		struct lpfc_iocbq    *rsp_iocb;
-- 
2.26.2

