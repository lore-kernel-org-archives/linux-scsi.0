Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911FBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiBYCYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbiBYCYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:24:01 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE761C885A
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso7261396pjk.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=770U6z+2B6Xtmdnpa2xaj+PbzE/q9mP2pwewga3mx+4=;
        b=j6NT7VorxOrIqrU+ahsLN7ibEeF8iCygtwmOVIgAeFvyuubpYbf1kRPqhkEfBWAZgB
         I9vod/qd/kJNrisWDugo8akeT5n1zt3i1u+oJYm1aN760rRRH3KRhXPhxh7/MxFUeuEs
         Gg06OMW42mYs76Km/cFPQ0JKEvzEVh+YQSOFMBrxhM2Ka935c+JTEgjaqFU/38CYyS10
         bkZqQ8hZECvA75PgvQeDZ5HMtodiy/H+KygMf54eBPOGmZBF9H1eu4XnwiDiMP2FTASh
         KH/8tsCfNvMRObIsV50JFtjPTFzzT0EGk5PKhkxTwEjQV04ZX22dVXGeJw6qPlihTGqB
         ERlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=770U6z+2B6Xtmdnpa2xaj+PbzE/q9mP2pwewga3mx+4=;
        b=IbHu7RlngXmZ+VyxvP0YR2XPEoDSMOUpV/DgoQLVNfUbBMxLXMpHCJj8ryU5YJsuXD
         zH9P06mWmzO+Yyzu1l7YP6z4FjFYdpSwI3hCqcbGWAjQEp4cb1/tK01MW3Ox1JUzRrlJ
         DT7myjO4OziZ3fBmGwpEcvRqineZjpvAePFUAVNaKzuzfGSw3IGu3gxWyt6lE4gm7RxF
         3OdRyp0dA1RlXnENTlVUrBp40aR6morw2oB6bK4AfpwEzUyuiwBsWxE7ds2TLKb5W3qw
         AcVS5AH58Mp6B5LuWkS5I2cJKDqS2Xc2RKYc0dZCvQn7jqPJyoV13jhJpgqRJfyPauAj
         1cTw==
X-Gm-Message-State: AOAM533SHLeiZ1hWr9axu4QjNnv9s9QPjuPCyaVFwoCMXhxBpZFpZ7Gb
        3wYNVmACV31vPFmxTBEsg5BE2LOqnY0=
X-Google-Smtp-Source: ABdhPJxtv2iBF8ZofyxkbIpWXBcfLnZ6IgmrQE4AhzHpecDqSzXdLfVmQxJjHxtVhWtOoONpl2TzGw==
X-Received: by 2002:a17:902:d886:b0:14d:5b6f:5bbe with SMTP id b6-20020a170902d88600b0014d5b6f5bbemr5542359plz.127.1645755804489;
        Thu, 24 Feb 2022 18:23:24 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/17] lpfc: SLI path split: refactor LS_RJT paths
Date:   Thu, 24 Feb 2022 18:22:59 -0800
Message-Id: <20220225022308.16486-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch refactors the LS_RJT paths to use SLI-4 as the primary
interface.

Changes include:
- conversion away from using sli-3 iocb structures to set/access fields
  in common routines. Use the new generic get/set routines that were added.
  This move changes code from indirect structure references to using
  local variables with the generic routines.
- refactor routines when setting non-generic fields, to have both
  both sli3 and sli4 specific sections. This replaces the set-as-sli3
  then translate to sli4 behavior of the past.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 04aac285a677..e28d970d2c6a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5743,6 +5743,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -5753,10 +5754,19 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-	icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
+		       get_job_ulpcontext(phba, oldiocb)); /* Xri / rx_id */
+		bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+		       get_job_rcvoxid(phba, oldiocb));
+	} else {
+		icmd = &elsiocb->iocb;
+		oldcmd = &oldiocb->iocb;
+		icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+	}
+
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_LS_RJT;
@@ -5772,7 +5782,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 			 "xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
 			 "rpi x%x\n",
 			 rejectError, elsiocb->iotag,
-			 elsiocb->iocb.ulpContext, ndlp->nlp_DID,
+			 get_job_ulpcontext(phba, elsiocb), ndlp->nlp_DID,
 			 ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue LS_RJT:    did:x%x flg:x%x err:x%x",
-- 
2.26.2

