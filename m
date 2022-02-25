Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27F9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiBYCYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236761AbiBYCXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:23:54 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57811C74D7
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:22 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x11so3533247pll.10
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E7UmOo8AhyAhCBfNfAnYZV3wMFYH97qmiYtrM+H6ve4=;
        b=JFYi+dnebnCeJ70z0V5doYtqb/KgCNg5YcsvzxZbxBXT7fVlPYho4nLUotp4qwkqUC
         nued+wCyHkjzNx77ze3Ogv/Pz9i8IFwA0UVIc+K8y95iip/vQRA5CreatAGshyyuC0hg
         FzDAKMFv6Dg71iFOxXAYOZYRqYZ1BbZsBAwqTmrvvz5WFkJzyedl8DMRKnitmbiclPUl
         bjmzXl1MUktq/5MS4ykhn7cqQDfN58ElPqlF+cU4m4RPRwSSNprlGDA+dVZqEaauPDo9
         BYdh73u7viyeGgbNjZ2IHY81/+hMY4rZuZulbsZcrW7n+11GLwT1zEUdB9eOU9JsX5mw
         M1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E7UmOo8AhyAhCBfNfAnYZV3wMFYH97qmiYtrM+H6ve4=;
        b=tH/+HiT1tTIEVX82BeSxIXts3+Tf8EO/7418dMqwwGN56NPqxtXT28woCXCJwOaLd3
         H1iIds26PUavD6LmBZeaPczE4hz7hf8Tq0HCmZmWQWAWlC3PfFnIwGDmqEhp+exGJfqy
         KU5WzLJekmXUSJATvTDG1A24/O38ihS79rJ5vBQ+cmS3/7RISHLP1E0CfvgOWsUJp1IG
         e9NRCVaSebyOgOB9PbqMNtlVlDjFhKs4bU4+YOsxAb0yD9DjzZTcfpLzomeo3yPk8SYy
         fdUMSyt1N7TiMKKp/KpMLRAl84V7RUGtwbkG59aNTDGGLcSlcvjWlGXfjk4/SkBCDpJQ
         iHug==
X-Gm-Message-State: AOAM530rEWomgiUOwxPVFEIuw420zomTljKvnNwTsdY36Bw+ZDlo3EmG
        NNzSfC/Udo1J5ZN7u7rEiqvOrZS6oLg=
X-Google-Smtp-Source: ABdhPJzXgetaH3SmHAuDPA7g1QqwGMeZP/jq4Zc1Nmg6PpfPU89vdr+FyRYYMWGqQ6uN3holZv2SPw==
X-Received: by 2002:a17:902:f711:b0:14d:61ba:8baf with SMTP id h17-20020a170902f71100b0014d61ba8bafmr5267812plo.39.1645755801814;
        Thu, 24 Feb 2022 18:23:21 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:21 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/17] lpfc: SLI path split: refactor PLOGI/PRLI/ADISC/LOGO paths
Date:   Thu, 24 Feb 2022 18:22:56 -0800
Message-Id: <20220225022308.16486-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch refactors the PLOGI/PRLI/ADISC/LOGO paths to use SLI-4 as
the primary interface.

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
 drivers/scsi/lpfc/lpfc.h           |   9 +
 drivers/scsi/lpfc/lpfc_els.c       | 278 ++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  60 ++++---
 3 files changed, 242 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 1418c6f60a9e..3da9551c651e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1844,6 +1844,15 @@ u16 get_job_ulpcontext(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 		return iocbq->iocb.ulpContext;
 }
 
+static inline
+u16 get_job_rcvoxid(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
+{
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return bf_get(wqe_rcvoxid, &iocbq->wqe.generic.wqe_com);
+	else
+		return iocbq->iocb.unsli3.rcvsli3.ox_id;
+}
+
 static inline
 u32 get_job_els_rsp64_did(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e4aee26dac92..91c030967ac1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1980,24 +1980,32 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_dmabuf *prsp;
 	int disc;
 	struct serv_parm *sp = NULL;
+	u32 ulp_status, ulp_word4, did, iotag;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &rspiocb->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		iotag = get_wqe_reqtag(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		iotag = irsp->ulpIoTag;
+	}
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"PLOGI cmpl:      status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
-		irsp->un.elsreq64.remoteID);
+		ulp_status, ulp_word4, did);
 
-	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
+	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0136 PLOGI completes to NPort x%x "
 				 "with no ndlp. Data: x%x x%x x%x\n",
-				 irsp->un.elsreq64.remoteID,
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 irsp->ulpIoTag);
+				 did, ulp_status, ulp_word4, iotag);
 		goto out_freeiocb;
 	}
 
@@ -2014,7 +2022,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 "0102 PLOGI completes to NPort x%06x "
 			 "Data: x%x x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, ndlp->nlp_fc4_type,
-			 irsp->ulpStatus, irsp->un.ulpWord[4],
+			 ulp_status, ulp_word4,
 			 disc, vport->num_disc_nodes);
 
 	/* Check to see if link went down during discovery */
@@ -2025,7 +2033,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
@@ -2037,17 +2045,18 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 		/* PLOGI failed Don't print the vport to vport rjts */
-		if (irsp->ulpStatus != IOSTAT_LS_RJT ||
-			(((irsp->un.ulpWord[4]) >> 16 != LSRJT_INVALID_CMD) &&
-			((irsp->un.ulpWord[4]) >> 16 != LSRJT_UNABLE_TPC)) ||
-			(phba)->pport->cfg_log_verbose & LOG_ELS)
+		if (ulp_status != IOSTAT_LS_RJT ||
+		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
+		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
+		    (phba)->pport->cfg_log_verbose & LOG_ELS)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
+					 "2753 PLOGI failure DID:%06X "
+					 "Status:x%x/x%x\n",
+					 ndlp->nlp_DID, ulp_status,
+					 ulp_word4);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4]))
+		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
@@ -2278,16 +2287,20 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	char *mode;
 	u32 loglevel;
+	u32 ulp_status;
+	u32 ulp_word4;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &(rspiocb->iocb);
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_PRLI_SND;
 
@@ -2298,21 +2311,21 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"PRLI cmpl:       status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		ndlp->nlp_DID);
 
 	/* PRLI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0103 PRLI completes to NPort x%06x "
 			 "Data: x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
+			 ndlp->nlp_DID, ulp_status, ulp_word4,
 			 vport->num_disc_nodes, ndlp->fc4_prli_sent);
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport))
 		goto out;
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
@@ -2335,11 +2348,11 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, mode, loglevel,
 				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
 				 "data: x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4, ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4]))
+		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
@@ -2733,16 +2746,26 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	int  disc;
+	u32 ulp_status, ulp_word4, tmo;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &(rspiocb->iocb);
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+	}
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"ADISC cmpl:      status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		ndlp->nlp_DID);
 
 	/* Since ndlp can be freed in the disc state machine, note if this node
@@ -2756,8 +2779,8 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0104 ADISC completes to NPort x%x "
 			 "Data: x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, disc, vport->num_disc_nodes);
+			 ndlp->nlp_DID, ulp_status, ulp_word4,
+			 tmo, disc, vport->num_disc_nodes);
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		spin_lock_irq(&ndlp->lock);
@@ -2766,7 +2789,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
@@ -2781,11 +2804,10 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* ADISC failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
-
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-				NLP_EVT_CMPL_ADISC);
+					NLP_EVT_CMPL_ADISC);
 
 		/* As long as this node is not registered with the SCSI or NVMe
 		 * transport, it is no longer an active node. Otherwise
@@ -2913,11 +2935,23 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	unsigned long flags;
 	uint32_t skip_recovery = 0;
 	int wake_up_waiter = 0;
+	u32 ulp_status;
+	u32 ulp_word4;
+	u32 tmo;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &(rspiocb->iocb);
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+	}
+
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
 	if (ndlp->save_flags & NLP_WAIT_FOR_LOGO) {
@@ -2928,7 +2962,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO cmpl:       status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		ndlp->nlp_DID);
 
 	/* LOGO completes to NPort <nlp_DID> */
@@ -2936,8 +2970,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 "0105 LOGO completes to NPort x%x "
 			 "refcnt %d nflags x%x Data: x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
-			 irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, vport->num_disc_nodes);
+			 ulp_status, ulp_word4,
+			 tmo, vport->num_disc_nodes);
 
 	if (lpfc_els_chk_latt(vport)) {
 		skip_recovery = 1;
@@ -2949,14 +2983,15 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * all acceptable.  Note the failure and move forward with
 	 * discovery.  The PLOGI will retry.
 	 */
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* LOGO failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2756 LOGO failure, No Retry DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
-		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4])) {
+				 "2756 LOGO failure, No Retry DID:%06X "
+				 "Status:x%x/x%x\n",
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4);
+
+		if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
 			skip_recovery = 1;
 			goto out;
 		}
@@ -3011,8 +3046,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3187 LOGO completes to NPort x%x: Start "
 				 "Recovery Data: x%x x%x x%x x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4], irsp->ulpTimeout,
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4, tmo,
 				 vport->num_disc_nodes);
 		lpfc_disc_start(vport);
 		return;
@@ -5392,6 +5427,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
+	union lpfc_wqe128 *wqe;
+	union lpfc_wqe128 *oldwqe = &oldiocb->wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	struct serv_parm *sp;
@@ -5400,8 +5437,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	ELS_PKT *els_pkt_ptr;
 	struct fc_els_rdf_resp *rdf_resp;
 
-	oldcmd = &oldiocb->iocb;
-
 	switch (flag) {
 	case ELS_CMD_ACC:
 		cmdsize = sizeof(uint32_t);
@@ -5414,9 +5449,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			return 1;
 		}
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 		*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 		pcmd += sizeof(uint32_t);
@@ -5433,9 +5484,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		if (!elsiocb)
 			return 1;
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 		if (mbox)
@@ -5495,9 +5562,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		if (!elsiocb)
 			return 1;
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 		memcpy(pcmd, ((struct lpfc_dmabuf *) oldiocb->context2)->virt,
@@ -5517,9 +5600,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		if (!elsiocb)
 			return 1;
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *)elsiocb->context2)->virt);
 		rdf_resp = (struct fc_els_rdf_resp *)pcmd;
 		memset(rdf_resp, 0, sizeof(*rdf_resp));
@@ -5774,10 +5873,12 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	struct lpfc_hba  *phba = vport->phba;
 	ADISC *ap;
 	IOCB_t *icmd, *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+	u32 ulp_context;
 
 	cmdsize = sizeof(uint32_t) + sizeof(ADISC);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
@@ -5785,16 +5886,29 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-	icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		/* XRI / rx_id */
+		bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
+		       get_job_ulpcontext(phba, oldiocb));
+		ulp_context = get_job_ulpcontext(phba, elsiocb);
+		/* oxid */
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
 
 	/* Xmit ADISC ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0130 Xmit ADISC ACC response iotag x%x xri: "
 			 "x%x, did x%x, nlp_flag x%x, nlp_state x%x rpi x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext,
+			 elsiocb->iotag, ulp_context,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -5827,14 +5941,6 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		return 1;
 	}
 
-	/* Xmit ELS ACC response tag <ulpIoTag> */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0128 Xmit ELS ACC response Status: x%x, IoTag: x%x, "
-			 "XRI: x%x, DID: x%x, nlp_flag: x%x nlp_state: x%x "
-			 "RPI: x%x, fc_flag x%x\n",
-			 rc, elsiocb->iotag, elsiocb->sli4_xritag,
-			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi, vport->fc_flag);
 	return 0;
 }
 
@@ -5867,13 +5973,14 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	lpfc_vpd_t *vpd;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	uint32_t prli_fc4_req, *req_payload;
 	struct lpfc_dmabuf *req_buf;
 	int rc;
-	u32 elsrspcmd;
+	u32 elsrspcmd, ulp_context;
 
 	/* Need the incoming PRLI payload to determine if the ACC is for an
 	 * FC4 or NVME PRLI type.  The PRLI type is at word 1.
@@ -5899,20 +6006,31 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
-		ndlp->nlp_DID, elsrspcmd);
+				     ndlp->nlp_DID, elsrspcmd);
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
 
 	/* Xmit PRLI ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0131 Xmit PRLI ACC response tag x%x xri x%x, "
 			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext,
+			 elsiocb->iotag, ulp_context,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d9879348c336..8964518d89f9 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -680,13 +680,13 @@ static int
 lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		struct lpfc_iocbq *cmdiocb)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq  *elsiocb;
 	struct lpfc_dmabuf *pcmd;
 	struct serv_parm   *sp;
 	struct lpfc_name   *pnn, *ppn;
 	struct ls_rjt stat;
 	ADISC *ap;
-	IOCB_t *icmd;
 	uint32_t *lp;
 	uint32_t cmd;
 
@@ -704,8 +704,8 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ppn = (struct lpfc_name *) & sp->portName;
 	}
 
-	icmd = &cmdiocb->iocb;
-	if (icmd->ulpStatus == 0 && lpfc_check_adisc(vport, ndlp, pnn, ppn)) {
+	if (get_job_ulpstatus(phba, cmdiocb) == 0 &&
+	    lpfc_check_adisc(vport, ndlp, pnn, ppn)) {
 
 		/*
 		 * As soon as  we send ACC, the remote NPort can
@@ -716,7 +716,6 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			elsiocb = kmalloc(sizeof(struct lpfc_iocbq),
 				GFP_KERNEL);
 			if (elsiocb) {
-
 				/* Save info from cmd IOCB used in rsp */
 				memcpy((uint8_t *)elsiocb, (uint8_t *)cmdiocb,
 					sizeof(struct lpfc_iocbq));
@@ -1312,23 +1311,24 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	struct lpfc_dmabuf *pcmd, *prsp, *mp;
 	uint32_t *lp;
 	uint32_t vid, flag;
-	IOCB_t *irsp;
 	struct serv_parm *sp;
 	uint32_t ed_tov;
 	LPFC_MBOXQ_t *mbox;
 	int rc;
+	u32 ulp_status;
+	u32 did;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
 	if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
 		/* Recovery from PLOGI collision logic */
 		return ndlp->nlp_state;
 	}
 
-	irsp = &rspiocb->iocb;
-
-	if (irsp->ulpStatus)
+	if (ulp_status)
 		goto out;
 
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -1440,7 +1440,9 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		goto out;
 	}
 
-	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (lpfc_reg_rpi(phba, vport->vpi, did,
 			 (uint8_t *) sp, mbox, ndlp->nlp_rpi) == 0) {
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
@@ -1670,17 +1672,18 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
 	ADISC *ap;
 	int rc;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
 	ap = (ADISC *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
-	irsp = &rspiocb->iocb;
 
-	if ((irsp->ulpStatus) ||
+	if ((ulp_status) ||
 	    (!lpfc_check_adisc(vport, ndlp, &ap->nodeName, &ap->portName))) {
 		/* 1 sec timeout */
 		mod_timer(&ndlp->nlp_delayfunc,
@@ -2123,14 +2126,16 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
 	struct lpfc_hba   *phba = vport->phba;
-	IOCB_t *irsp;
 	PRLI *npr;
 	struct lpfc_nvme_prli *nvpr;
 	void *temp_ptr;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
 	/* A solicited PRLI is either FCP or NVME.  The PRLI cmd/rsp
 	 * format is different so NULL the two PRLI types so that the
 	 * driver correctly gets the correct context.
@@ -2143,8 +2148,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else if (cmdiocb->cmd_flag & LPFC_PRLI_NVME_REQ)
 		nvpr = (struct lpfc_nvme_prli *) temp_ptr;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		if ((vport->port_type == LPFC_NPIV_PORT) &&
 		    vport->cfg_restrict_login) {
 			goto out;
@@ -2743,16 +2747,18 @@ static uint32_t
 lpfc_cmpl_plogi_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus) {
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status)
 		return NLP_STE_FREED_NODE;
-	}
+
 	return ndlp->nlp_state;
 }
 
@@ -2760,14 +2766,16 @@ static uint32_t
 lpfc_cmpl_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
 		lpfc_drop_node(vport, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
@@ -2794,14 +2802,16 @@ static uint32_t
 lpfc_cmpl_adisc_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
 		lpfc_drop_node(vport, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
-- 
2.26.2

