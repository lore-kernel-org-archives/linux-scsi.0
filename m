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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D75C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC20207AC
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbhACASL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbhACASK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:10 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700BBC061794
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:02 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id e2so16430198pgi.5
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O7LymfHZoxVbM06ju8zfjeBBPjcIyw3gwBJgr1ToUwo=;
        b=NOnRc9O6D2kLxXK44zBOGKxHEPx1PSO86gO80u4fR66QO4x79QsSKrbVDE5tZFeFiR
         WdWwcc/+/Vxqc0oGCe2wLcoqVnHMMq/LpeRNUNK50iQDiX0Kn7RQlSAOE/JqPtPp/zas
         HvwHGP1eUq5MfWvxLFPQYRkzgnyPh6bS8qHKJsSd7Zo4Zy6yJcQoJf4XKEE75dYJC9+c
         t5yxhcjvWxP+An0iNP/J6dzU0WLuxkRExdUXsm/UMx4u6j5Z0J0UNPHfFO6mgkU4k5XB
         OjeYJu/scfzYHflpEADiOvmo8ingT72lomaN5954u/5qpQwGDKgLB0MPcuuz+N+HkAlJ
         yB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O7LymfHZoxVbM06ju8zfjeBBPjcIyw3gwBJgr1ToUwo=;
        b=IpiMlrA59FOK3XYkox6+akK7HnyuppHGu1Q4MFnciAAKH9H21EpF8CIvvwn3YBwTr5
         L2w49FMuMrQ7fWPIywftl1+cC6DJWErds0XF1yQXO/NqmrTlJfVjT+mSmJzyw49kQfqz
         9r2+fu+bz4g7kAxYUy88x71re7y6QQ7vfMvlI8ck4zmXGEG5FlBYnSTlAyKeTb91j60e
         9a0AsGLcEVDYdXnFV3g1CRarDQr6e6vYaxuj1aO4jXyu0tzhPURXHX63OP6KTdWcaV1x
         iNWwU0aFLfR+rxh3AuADU6pnux1F4XiW0sOzl6Jq7RkWaTnzMlXZN+7/y1EYcPwUvQBC
         9Fcw==
X-Gm-Message-State: AOAM532YEKYobRJ9SUGFIbCbXreGGWNXzZ4kV8GhUJVRXzs6pVBnvMcC
        JqzAWDHvMGxIsFRvZ0j+7SqN3QuULqk=
X-Google-Smtp-Source: ABdhPJz3NZtrN2IGmLzLOebcibVIXGxeaxeSuUyo12XoxuvjFz6BOtm7ivIzy1+LMh5EigZLagp7iA==
X-Received: by 2002:a62:7c01:0:b029:19e:1e23:1821 with SMTP id x1-20020a627c010000b029019e1e231821mr61213623pfc.72.1609633021840;
        Sat, 02 Jan 2021 16:17:01 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:01 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/15] lpfc: Use the nvme-fc transport supplied timeout for LS requests
Date:   Sat,  2 Jan 2021 16:16:29 -0800
Message-Id: <20210103001639.1995-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When lpfc generates a GEN_REQUEST wqe for the nvme LS (such as Create
Association), the timeout is set to R_A_TOV  without regard to the
timeout value supplied by the nvme-fc transport. The driver should be
setting the timeout to the value passed into the routine. Additionally
the caller should be setting the timeout value to the value in the ls
request set by the nvme transport. Instead, it unconditionally is
setting it to a driver defined value.  So the driver actually overrode
the value twice.

Fix by using the timeout provided to the routine, and for the caller,
set the timeout to the ls request timeout value.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 1cb82fa6a60e..fd4a1cf0e4a6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -458,7 +458,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	bf_set(wqe_xri_tag, &wqe->gen_req.wqe_com, genwqe->sli4_xritag);
 
 	/* Word 7 */
-	bf_set(wqe_tmo, &wqe->gen_req.wqe_com, (vport->phba->fc_ratov-1));
+	bf_set(wqe_tmo, &wqe->gen_req.wqe_com, tmo);
 	bf_set(wqe_class, &wqe->gen_req.wqe_com, CLASS3);
 	bf_set(wqe_cmnd, &wqe->gen_req.wqe_com, CMD_GEN_REQUEST64_WQE);
 	bf_set(wqe_ct, &wqe->gen_req.wqe_com, SLI4_CT_RPI);
@@ -615,7 +615,7 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	ret = lpfc_nvme_gen_req(vport, bmp, pnvme_lsreq->rqstaddr,
 				pnvme_lsreq, gen_req_cmp, ndlp, 2,
-				LPFC_NVME_LS_TIMEOUT, 0);
+				pnvme_lsreq->timeout, 0);
 	if (ret != WQE_SUCCESS) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6052 NVMEx REQ: EXIT. issue ls wqe failed "
-- 
2.26.2

