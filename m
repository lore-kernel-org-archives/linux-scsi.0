Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E00C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbiBYCYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiBYCYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:24:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F2F1D034A
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:25 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x11so3533342pll.10
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hhO3ZTl1pSVTfrEWX1u9WzIjQd6mtb+opD9fYmj6LM8=;
        b=Acfbj6k/g1t/IYlVnWDMzv4SleqkTXG0MGq5O6nm3kwJnHJArUIbS3/lRmLSflFUdF
         LgMAHooOFpMt5456jZqxoi+FwZ12ua+d0hrEiTQmfxvFx9jyITRC+0C6IiLNREiAbTdi
         29Cmi31XxG6Y75y8IqLYqY+ldQTPrDtIGwDzppAD+C9uDs4h4860KpW3bFTkt+sElnzD
         OkKUoyDMJaHgSQy5FMEYmSs8RubcuRD329owWgJpACKUZ6PUsYoOvSspJ/Y8smpyKR7T
         /RJB1h1taMsOca88hogPtRjM14348rhwVGxfSU3+cU5MF0+Xwnr6AVgCo8z3vdqGrScH
         NS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hhO3ZTl1pSVTfrEWX1u9WzIjQd6mtb+opD9fYmj6LM8=;
        b=ciEXZttoBnrinmrLKJsCob72Bx9D39fMixdGMT2+o1MQ/Cz2Aw3NE31A/RqXkUYu3N
         cD4n+xFZHznGSzj3rfL4Bc3uQnxAZ6mpIt4740OxoSq/zEknsR+2QdHKjg7JJmuX4uEs
         p9hRXa4rDY22csbNcHmjpkW8XVB29AkkKrjWCmm1S9QPe6B+4I03koHbxE+Z5Y9/kH22
         qbAARduCrq4jGS+xiTMHe05KNXql/I3oHVH953xsibsHN1QADukrnG301s0hARCwekX+
         iwOa5DaeuC0BwMl9cwrgUeTRFf5S+dEdKMpyFAUM/IH0UVg/n/IXVH8owl8xMjZbdrOI
         KlOg==
X-Gm-Message-State: AOAM533bBGBH5yTVRWIBES44wDUMq7C4Jz/4cLt6voZq3agJmAAO/V0K
        CzKjQxxa8dXIlPJpr/nHFBpoEPQg534=
X-Google-Smtp-Source: ABdhPJyzAySU/ReSZTRfgXOa8otRp5lsPd95XOMJliR0qHDMz3bInyXa/y9o+donRFTF+PCqClnHbg==
X-Received: by 2002:a17:902:f605:b0:14d:9e11:c864 with SMTP id n5-20020a170902f60500b0014d9e11c864mr5613744plg.54.1645755805300;
        Thu, 24 Feb 2022 18:23:25 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/17] lpfc: SLI path split: refactor FDISC paths
Date:   Thu, 24 Feb 2022 18:23:00 -0800
Message-Id: <20220225022308.16486-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch refactors the FDISC paths to use SLI-4 as the primary
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
 drivers/scsi/lpfc/lpfc_els.c | 47 ++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e28d970d2c6a..0d8e674c72f0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11171,6 +11171,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_hba *phba = vport->phba;
 	IOCB_t *icmd;
+	union lpfc_wqe128 *wqe = NULL;
 	struct lpfc_iocbq *elsiocb;
 	struct serv_parm *sp;
 	uint8_t *pcmd;
@@ -11190,15 +11191,14 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 1;
 	}
 
-	icmd = &elsiocb->iocb;
-	icmd->un.elsreq64.myID = 0;
-	icmd->un.elsreq64.fl = 1;
-
-	/*
-	 * SLI3 ports require a different context type value than SLI4.
-	 * Catch SLI3 ports here and override the prep.
-	 */
-	if (phba->sli_rev == LPFC_SLI_REV3) {
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		bf_set(els_req64_sid, &wqe->els_req, 0);
+		bf_set(els_req64_sp, &wqe->els_req, 1);
+	} else {
+		icmd = &elsiocb->iocb;
+		icmd->un.elsreq64.myID = 0;
+		icmd->un.elsreq64.fl = 1;
 		icmd->ulpCt_h = 1;
 		icmd->ulpCt_l = 0;
 	}
@@ -11236,14 +11236,11 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		did, 0, 0);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
-		lpfc_els_free_iocb(phba, elsiocb);
+	if (!elsiocb->context1)
 		goto err_out;
-	}
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
 	if (rc == IOCB_ERROR) {
-		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto err_out;
 	}
@@ -11252,6 +11249,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	return 0;
 
  err_out:
+	lpfc_els_free_iocb(phba, elsiocb);
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			 "0256 Issue FDISC: Cannot send IOCB\n");
@@ -11280,23 +11278,36 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	u32 ulp_status, ulp_word4, did, tmo;
 
 	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
-	irsp = &rspiocb->iocb;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		did = get_job_els_rsp64_did(phba, cmdiocb);
+		tmo = get_wqe_tmo(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		did = get_job_els_rsp64_did(phba, rspiocb);
+		tmo = irsp->ulpTimeout;
+	}
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO npiv cmpl:  status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4], irsp->un.rcvels.remoteID);
+		ulp_status, ulp_word4, did);
 
 	/* NPIV LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2928 NPIV LOGO completes to NPort x%x "
 			 "Data: x%x x%x x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, vport->num_disc_nodes,
+			 ndlp->nlp_DID, ulp_status, ulp_word4,
+			 tmo, vport->num_disc_nodes,
 			 kref_read(&ndlp->kref), ndlp->nlp_flag,
 			 ndlp->fc4_xpt_flags);
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+	if (ulp_status == IOSTAT_SUCCESS) {
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~FC_NDISC_ACTIVE;
 		vport->fc_flag &= ~FC_FABRIC;
-- 
2.26.2

