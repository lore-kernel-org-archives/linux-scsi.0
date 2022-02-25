Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADDBC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiBYCYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbiBYCXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:23:54 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874651C74FD
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:23 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p17so3539470plo.9
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LnZSHJalZN7dmbxp6caPBJXTN2B6Fl0DasYAwzjxTw0=;
        b=knSZLfg1+GctOcYftpXO6cptK34hkB8SO6PB0ygsXyvCnegfdEIDCgLFJpq8XH4LD9
         bjjMSV2/Gey/NovTSEJ7PdDl7hmsAJcQO3DGaRupN5LQSkngPD/luYywrhWSRYDuBGXw
         iGL0ZXguZm1HA1EigLY+Qy2WWuMrbzH2UsLyieN0JcTRUxD7nMhhKeMkQT/4XDEB9kBb
         NjZu14yacturnc6/oCOZTpOtNSJBbUiorpwblC/KA09EGJEsanJWozwQkIMki8HocV/h
         ezidWCOEihu/MOgxOMLvrXt5zheFBkux6jHfejewN5S7ha220BSWhg1bbvkIg6xu4x2h
         kt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LnZSHJalZN7dmbxp6caPBJXTN2B6Fl0DasYAwzjxTw0=;
        b=5Y8+958ROaeheoFTy/gK9zdhH5I0GeQ0PU8chUdOLZuRhAf/SXGfPVVCvOGnWRmnEf
         y7X5DwZcrotaXwxwxqZVKsJq2MC6qIe9HO/56GaZgwFcoLiVwuzXAwjsKV12UDqKep7g
         cox0x3UhPNJqFFuyR1PauCCRJRYWNcUwDE/IVD1yc6y0LCD6dRqihc3xdtydcqY3t2lv
         PhwBAy9xr1Q8viZ+UlOQjXX8TIjmXz79xh9aFbktwypDpyXZy3xbe0U8RMzUeOFQ2aoX
         /PNYI2KL3o9NB50c8ZxBwqo32eCU5wkwaneNKPaR4HFq/3UIZmrJ0R24yCVWhgGb9SHK
         QZTQ==
X-Gm-Message-State: AOAM532XAcAwd0dnHhLfTLLja1HtsMO6ltH7csc4GdavUsYY+TZ/t7VX
        P9TF+PZ49joBs3RUKIIJdSUnXMz2EYA=
X-Google-Smtp-Source: ABdhPJw+XMHcZgNwVCD8bs7mU/73PG4Sd/1IJfkDPDgJkE/mu9uILu7ETp37MK7dpkqbUJpBuLqcfg==
X-Received: by 2002:a17:90a:ae14:b0:1bc:c078:e02 with SMTP id t20-20020a17090aae1400b001bcc0780e02mr962552pjq.167.1645755802800;
        Thu, 24 Feb 2022 18:23:22 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:22 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/17] lpfc: SLI path split: refactor the RSCN/SCR/RDF/EDC/FARPR paths
Date:   Thu, 24 Feb 2022 18:22:57 -0800
Message-Id: <20220225022308.16486-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch refactors the SLI3/SLI4 RSCN/SCR/RDF/EDC/FARPR paths to use
SLI-4 as the primary interface.

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
 drivers/scsi/lpfc/lpfc_els.c | 115 ++++++++++++++++++++++++-----------
 1 file changed, 81 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 91c030967ac1..365580abcb5b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3178,19 +3178,29 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_nodelist *free_ndlp;
 	IOCB_t *irsp;
+	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	irsp = &rspiocb->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+		iotag = get_wqe_reqtag(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+		iotag = irsp->ulpIoTag;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "ELS cmd cmpl:    status:x%x/x%x did:x%x",
-			      irsp->ulpStatus, irsp->un.ulpWord[4],
-			      irsp->un.elsreq64.remoteID);
+			      ulp_status, ulp_word4, did);
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0106 ELS cmd tag x%x completes Data: x%x x%x x%x\n",
-			 irsp->ulpIoTag, irsp->ulpStatus,
-			 irsp->un.ulpWord[4], irsp->ulpTimeout);
+			 iotag, ulp_status, ulp_word4, tmo);
 
 	/* Check to see if link went down during discovery */
 	lpfc_els_chk_latt(vport);
@@ -3312,20 +3322,29 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 *pdata;
 	u32 cmd;
 	struct lpfc_nodelist *ndlp = cmdiocb->context1;
+	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	irsp = &rspiocb->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+		iotag = get_wqe_reqtag(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+		iotag = irsp->ulpIoTag;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"ELS cmd cmpl:    status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
-		irsp->un.elsreq64.remoteID);
+		ulp_status, ulp_word4, did);
+
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
-			 "0217 ELS cmd tag x%x completes Data: x%x x%x x%x "
-			 "x%x\n",
-			 irsp->ulpIoTag, irsp->ulpStatus,
-			 irsp->un.ulpWord[4], irsp->ulpTimeout,
-			 cmdiocb->retry);
+			 "0217 ELS cmd tag x%x completes Data: x%x x%x x%x x%x\n",
+			 iotag, ulp_status, ulp_word4, tmo, cmdiocb->retry);
 
 	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
 	if (!pcmd)
@@ -3337,8 +3356,8 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	cmd = *pdata;
 
 	/* Only 1 retry for ELS Timeout only */
-	if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-	    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+	if (ulp_status == IOSTAT_LOCAL_REJECT &&
+	    ((ulp_word4 & IOERR_PARAM_MASK) ==
 	    IOERR_SEQUENCE_TIMEOUT)) {
 		cmdiocb->retry++;
 		if (cmdiocb->retry <= 1) {
@@ -3363,11 +3382,11 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_cmpl_els_edc(phba, cmdiocb, rspiocb);
 		return;
 	}
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* ELS discovery cmd completes with error */
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS | LOG_CGN_MGMT,
 				 "4203 ELS cmd x%x error: x%x x%X\n", cmd,
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto out;
 	}
 
@@ -3392,7 +3411,7 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 "4677 Fabric RDF Notification Grant "
 					 "Data: 0x%08x Reg: %x %x\n",
 					 be32_to_cpu(
-						prdf->reg_d1.desc_tags[i]),
+						 prdf->reg_d1.desc_tags[i]),
 					 phba->cgn_reg_signal,
 					 phba->cgn_reg_fpin);
 	}
@@ -3637,7 +3656,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
-				     ndlp->nlp_DID, ELS_CMD_RNID);
+				     ndlp->nlp_DID, ELS_CMD_FARPR);
 	if (!elsiocb)
 		return 1;
 
@@ -3939,7 +3958,7 @@ static void
 lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_iocbq *rspiocb)
 {
-	IOCB_t *irsp;
+	IOCB_t *irsp_iocb;
 	struct fc_els_edc_resp *edc_rsp;
 	struct fc_tlv_desc *tlv;
 	struct fc_diag_cg_sig_desc *pcgd;
@@ -3950,20 +3969,31 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int desc_cnt = 0, bytes_remain;
 	bool rcv_cap_desc = false;
 	struct lpfc_nodelist *ndlp;
+	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	irsp = &rspiocb->iocb;
 	ndlp = cmdiocb->context1;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(rspiocb);
+		iotag = get_wqe_reqtag(rspiocb);
+	} else {
+		irsp_iocb = &rspiocb->iocb;
+		tmo = irsp_iocb->ulpTimeout;
+		iotag = irsp_iocb->ulpIoTag;
+	}
+
 	lpfc_debugfs_disc_trc(phba->pport, LPFC_DISC_TRC_ELS_CMD,
 			      "EDC cmpl:    status:x%x/x%x did:x%x",
-			      irsp->ulpStatus, irsp->un.ulpWord[4],
-			      irsp->un.elsreq64.remoteID);
+			      ulp_status, ulp_word4, did);
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
 			"4201 EDC cmd tag x%x completes Data: x%x x%x x%x\n",
-			irsp->ulpIoTag, irsp->ulpStatus,
-			irsp->un.ulpWord[4], irsp->ulpTimeout);
+			iotag, ulp_status, ulp_word4, tmo);
 
 	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
 	if (!pcmd)
@@ -3974,7 +4004,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 
 	/* Need to clear signal values, send features MB and RDF with FPIN. */
-	if (irsp->ulpStatus)
+	if (ulp_status)
 		goto out;
 
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
@@ -6286,12 +6316,18 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 		      struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_hba  *phba = vport->phba;
+	IOCB_t *icmd, *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+	u32 ulp_context;
 
-	cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		cmdsize = oldiocb->wcqe_cmpl.total_data_placed;
+	else
+		cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
 
 	/* The accumulated length can exceed the BPL_SIZE.  For
 	 * now, use this as the limit
@@ -6303,13 +6339,26 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	if (!elsiocb)
 		return 1;
 
-	elsiocb->iocb.ulpContext = oldiocb->iocb.ulpContext;  /* Xri / rx_id */
-	elsiocb->iocb.unsli3.rcvsli3.ox_id = oldiocb->iocb.unsli3.rcvsli3.ox_id;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
+		       get_job_ulpcontext(phba, oldiocb)); /* Xri / rx_id */
+		ulp_context = get_job_ulpcontext(phba, elsiocb);
+		bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+		       get_job_rcvoxid(phba, oldiocb));
+	} else {
+		icmd = &elsiocb->iocb;
+		oldcmd = &oldiocb->iocb;
+		icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+		ulp_context = elsiocb->iocb.ulpContext;
+		icmd->unsli3.rcvsli3.ox_id =
+			oldcmd->unsli3.rcvsli3.ox_id;
+	}
 
 	/* Xmit ECHO ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2876 Xmit ECHO ACC response tag x%x xri x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext);
+			 elsiocb->iotag, ulp_context);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t);
@@ -8868,11 +8917,9 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *lp;
-	IOCB_t *icmd;
 	uint32_t did;
 
-	icmd = &cmdiocb->iocb;
-	did = icmd->un.elsreq64.remoteID;
+	did = get_job_els_rsp64_did(vport->phba, cmdiocb);
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
 
-- 
2.26.2

