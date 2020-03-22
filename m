Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19B5C54FCF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6372072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sw7cdzuU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCVSNQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38062 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVSNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:16 -0400
Received: by mail-pl1-f193.google.com with SMTP id w3so4880245plz.5
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HDxWJwMHM6uUFzp9Y+zb/4XsQ2PlznS8h6McRbqfrKs=;
        b=Sw7cdzuUfkfUOUCc3M114rDOCaWuAQ73Py5x1cZywiGk7Y73GUoKKBAk8G7emCvvIl
         NUZo2X9I491FO36KGGudUG7RQyQkkJEvoYo/DIeNRVh4HJ3Hnemge5LNiXgUGQ7CXG2a
         NKEW2k4RVCc+xsC4fRFRsSA41cgrCdeEyB7cf8/ZZxltx5fvucCvkdZjl3uwCZGMXjdb
         KTsWrvShc6H42ZIsMYxcWRsMPUBNAj3zieMDYvhnygpZfqUuHz5VJk3fPyxL19ijFPO8
         pl4ojMrPxzHRMo9ATLbjUVAY2oRwWFTAegTJrSxNvY7ycnzkcj1t/siAahRRi0Wjd+Bc
         DV+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HDxWJwMHM6uUFzp9Y+zb/4XsQ2PlznS8h6McRbqfrKs=;
        b=gk6W/2M/BomI79DDvb6ccvuQs8seWiYQCjk9BgzXIBHIuZ0aHpanhq6pXywMMxy07r
         FNAi0FC14nLpSjschDk1I/OmsPK1tDGIB9sBkGLgFQShKsQYKV2okgv+qkxOS+TaRFWU
         n+cUbnBuacbHl6bokj8WglnIkp1T83qtCeJY5WLBHR7+9SEW5tAFVbm45C+Fjna36Vqr
         k4VkExdAfMbDBqCpGb/JaW0bkEGWW1iGfv4vEt9/LoGJpna876Qwt0MY0mQBMdC6EP19
         ox25k9dx2sRBANLnVh6tAaBQECubyOA/Pj0CX/mR6/a8mVT7TZbzq2EM4oEAXL84VK41
         v80w==
X-Gm-Message-State: ANhLgQ2efrwoY+iyOAhtTq4L3oD7e23a5z76Bil5ByAFlaKbf8s8Voqq
        LLN9jfx/auMCbKMYgpvnDsuYf1SO
X-Google-Smtp-Source: ADFU+vuH+tq/OiQcDJcP0vk2rsw8AjkacmlYAkP2ifruRoQn+if/LSmj3DvvTMRnSfHWTMRdgQUdBg==
X-Received: by 2002:a17:902:40a:: with SMTP id 10mr15923480ple.183.1584900794354;
        Sun, 22 Mar 2020 11:13:14 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/12] lpfc: Fix lpfc overwrite of sg_cnt field in nvmefc_tgt_fcp_req
Date:   Sun, 22 Mar 2020 11:12:55 -0700
Message-Id: <20200322181304.37655-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_nvmet_prep_fcp_wqe() the line "rsp->sg_cnt = 0" is modifying the
transport's data structure. This may result in the transport believing
the s/g list was already freed, thus may not unmap/free it properly.
Lpfc driver should not modity the transport data structure.

The zeroing of the sg_cnt is to avoid use of the transport's sgl in a
subsequent loop where the driver builds the necessary requests for the
adapter firmware to complete the IO.

Change LLDD to use a local copy of the transport sg_cnt when building
requests to be passed to the adapter fw.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 9dc9afe1c255..ae89d1450912 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2598,7 +2598,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	union lpfc_wqe128 *wqe;
 	struct ulp_bde64 *bde;
 	dma_addr_t physaddr;
-	int i, cnt;
+	int i, cnt, nsegs;
 	int do_pbde;
 	int xc = 1;
 
@@ -2629,6 +2629,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 				phba->cfg_nvme_seg_cnt);
 		return NULL;
 	}
+	nsegs = rsp->sg_cnt;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	nvmewqe = ctxp->wqeq;
@@ -2868,7 +2869,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		wqe->fcp_trsp.rsvd_12_15[0] = 0;
 
 		/* Use rspbuf, NOT sg list */
-		rsp->sg_cnt = 0;
+		nsegs = 0;
 		sgl->word2 = 0;
 		atomic_inc(&tgtp->xmt_fcp_rsp);
 		break;
@@ -2885,7 +2886,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
 	nvmewqe->context1 = ndlp;
 
-	for_each_sg(rsp->sg, sgel, rsp->sg_cnt, i) {
+	for_each_sg(rsp->sg, sgel, nsegs, i) {
 		physaddr = sg_dma_address(sgel);
 		cnt = sg_dma_len(sgel);
 		sgl->addr_hi = putPaddrHigh(physaddr);
-- 
2.16.4

