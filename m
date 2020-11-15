Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A268BC63777
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A8B322314
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bltq5tkR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgKOT1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgKOT1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:02 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE80AC0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:02 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c66so11359130pfa.4
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=53pKSLU3rhBP5CN78ocmczlqNX+ODsAiUS6i4IYBCKs=;
        b=bltq5tkRqlX1lbVEqhDuFGxye0XVKQR+JRrcpNE+lolxEpsHyfSIZWq0BbSViIy0SJ
         LgmOOX1+uuTAjidWV/8OL8SyBhyS43REB0EYcas5MnTdQ2WcKoGrPaDrFYkTK2NX3dYV
         rT8NTewwxuslmyY3iWiWn9WGya5+g2KURWFSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=53pKSLU3rhBP5CN78ocmczlqNX+ODsAiUS6i4IYBCKs=;
        b=mwZzyaFagzV0wfv8CSeewlq/gQ/1halTaQxN9cY2OT2mXl/fM+W81z8SixqFMgRtmR
         l0wQzwgSfGLV4cfZaTnfipv7O9rGKoO+hNlPJrKF5Tl3a/qS+IyUaw8tnL9P2Sxhk+bN
         zusZhKVsWjFd52VuySTumg8iEfLyPRxnBTNWfJjTF6CaIarc1HDlAqIC69cvdEq5KOS8
         EiDraf7hNykye3Q+yRIG3AyPHGfehMrRguKap5ICQU3LSK55CLI8a0grFdsUEYNZowuv
         l6jllPYCwTjXPyelc2tR/xjk6mVNYjPLxALwwcCmGViKL0BJsGSNp0iFcyI3SGS/ioxw
         XBJA==
X-Gm-Message-State: AOAM530w8DqjQFAImnclEfGnqIk78GuZ6+A/hqsYkVklrEnxWPQeiAAU
        NPq69W3V2mccy2jqO+fjE6N+8Dmp1wMYW0hoQ50pp1i0utNVpqDfaNHNAKPo4YmOsG5WP2mok99
        oUbxMvPuJTPD5MAwgrV+JJhlTuKh8f7HvyDLxPNVqlnr4Vj19DMnWPkKdhpkcQAPy6yorMZgXgE
        NygfQ=
X-Google-Smtp-Source: ABdhPJzreg3W7mQXCatxMWU5KwTBkoHWz01sprbpt9ytzGbxh50WY+Wcl/ylw/SDxjcOqGR/ViUyhg==
X-Received: by 2002:a17:90a:ff08:: with SMTP id ce8mr12214956pjb.210.1605468420509;
        Sun, 15 Nov 2020 11:27:00 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:26:59 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/17] lpfc: Rework remote port lock handling
Date:   Sun, 15 Nov 2020 11:26:34 -0800
Message-Id: <20201115192646.12977-6-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f710f305b42a3e47"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f710f305b42a3e47
Content-Transfer-Encoding: 8bit

Currently the discovery layers within the driver use the scsi midlayer
host_lock to access node-specific structures. This can contend with the
io path and is too coarse of a lock.

Rework the driver so that it uses a lock specific to the remote port node
structure when accessing the structure contents. A few of the changes
brought out spots were some slightly reorganized routines worked better.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h           |   2 -
 drivers/scsi/lpfc/lpfc_attr.c      |   8 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  10 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |   4 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   3 +
 drivers/scsi/lpfc/lpfc_els.c       | 168 +++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 372 ++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_init.c      |  11 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 181 ++++++--------
 drivers/scsi/lpfc/lpfc_nvme.c      |  30 +--
 drivers/scsi/lpfc/lpfc_scsi.c      |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  17 +-
 12 files changed, 345 insertions(+), 465 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 3c77e02d36b0..2b92aa7a0762 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1131,8 +1131,6 @@ struct lpfc_hba {
 	uint8_t hb_outstanding;
 	struct timer_list rrq_tmr;
 	enum hba_temp_state over_temp_state;
-	/* ndlp reference management */
-	spinlock_t ndlp_lock;
 	/*
 	 * Following bit will be set for all buffer tags which are not
 	 * associated with any HBQ.
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index aba879604437..773e8f498067 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -368,11 +368,11 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
-		spin_lock(&vport->phba->hbalock);
+		spin_lock(&ndlp->lock);
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
-		spin_unlock(&vport->phba->hbalock);
+		spin_unlock(&ndlp->lock);
 		if (!nrport)
 			continue;
 
@@ -3630,11 +3630,11 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 		if (ndlp->rport)
 			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
 #if (IS_ENABLED(CONFIG_NVME_FC))
-		spin_lock(&vport->phba->hbalock);
+		spin_lock(&ndlp->lock);
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			remoteport = rport->remoteport;
-		spin_unlock(&vport->phba->hbalock);
+		spin_unlock(&ndlp->lock);
 		if (rport && remoteport)
 			nvme_fc_set_remoteport_devloss(remoteport,
 						       vport->cfg_devloss_tmo);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index ba5b1c42b8a6..8e11a97f5a68 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -825,7 +825,6 @@ lpfc_ns_rsp_audit_did(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	char *str;
 
 	if (phba->cfg_ns_query == LPFC_NS_QUERY_GID_FT)
@@ -854,12 +853,12 @@ lpfc_ns_rsp_audit_did(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 			if (ndlp->nlp_type != NLP_NVME_INITIATOR ||
 			    ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
 				continue;
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			if (ndlp->nlp_DID == Did)
 				ndlp->nlp_flag &= ~NLP_NVMET_RECOV;
 			else
 				ndlp->nlp_flag |= NLP_NVMET_RECOV;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 		}
 	}
 }
@@ -875,7 +874,6 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 	uint32_t Did, CTentry;
 	int Cnt;
 	struct list_head head;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp = NULL;
 
 	lpfc_set_disctmo(vport);
@@ -921,9 +919,9 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 				continue;
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 						NLP_EVT_DEVICE_RECOVERY);
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NVMET_RECOV;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 		}
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8c2750cea082..8625dc824492 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -955,13 +955,13 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	len += scnprintf(buf + len, size - len, "\tRport List:\n");
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		/* local short-hand pointer. */
-		spin_lock(&phba->hbalock);
+		spin_lock(&ndlp->lock);
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
 		else
 			nrport = NULL;
-		spin_unlock(&phba->hbalock);
+		spin_unlock(&ndlp->lock);
 		if (!nrport)
 			continue;
 
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index b831f10a686c..7757175a5c37 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -81,6 +81,9 @@ struct lpfc_nodelist {
 	struct list_head nlp_listp;
 	struct lpfc_name nlp_portname;
 	struct lpfc_name nlp_nodename;
+
+	spinlock_t	lock;			/* Node management lock */
+
 	uint32_t         nlp_flag;		/* entry flags */
 	uint32_t         nlp_DID;		/* FC D_ID of entry */
 	uint32_t         nlp_last_elscmd;	/* Last ELS cmd sent */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5a592ab323e5..565ab29abf3c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -769,9 +769,9 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			if ((np->nlp_state != NLP_STE_NPR_NODE) ||
 				   !(np->nlp_flag & NLP_NPR_ADISC))
 				continue;
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&np->lock);
 			np->nlp_flag &= ~NLP_NPR_ADISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&np->lock);
 			lpfc_unreg_rpi(vport, np);
 		}
 		lpfc_cleanup_pending_mbox(vport);
@@ -915,9 +915,9 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       sizeof(struct lpfc_name));
 		/* Set state will put ndlp onto node list if not already done */
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!mbox)
@@ -1589,7 +1589,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_vport *vport = ndlp->vport;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *new_ndlp;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
@@ -1677,7 +1676,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		       ndlp->active_rrqs_xri_bitmap,
 		       phba->cfg_rrq_xri_bitmap_sz);
 
-	spin_lock_irq(shost->host_lock);
+	/* Lock both ndlps */
+	spin_lock_irq(&ndlp->lock);
+	spin_lock_irq(&new_ndlp->lock);
 	keep_new_nlp_flag = new_ndlp->nlp_flag;
 	keep_nlp_flag = ndlp->nlp_flag;
 	new_ndlp->nlp_flag = ndlp->nlp_flag;
@@ -1708,7 +1709,8 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	else
 		ndlp->nlp_flag &= ~NLP_RPI_REGISTERED;
 
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&new_ndlp->lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	/* Set nlp_states accordingly */
 	keep_nlp_state = new_ndlp->nlp_state;
@@ -1945,10 +1947,10 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Since ndlp can be freed in the disc state machine, note if this node
 	 * is being used during discovery.
 	 */
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	/* PLOGI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -1960,9 +1962,9 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		goto out;
 	}
 
@@ -1971,9 +1973,9 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
 			if (disc) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock_irq(&ndlp->lock);
 			}
 			goto out;
 		}
@@ -2093,9 +2095,9 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 		return 1;
 
 	shost = lpfc_shost_from_vport(vport);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_FCP_PRLI_RJT;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
@@ -2175,7 +2177,6 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	char *mode;
@@ -2186,13 +2187,13 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	irsp = &(rspiocb->iocb);
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_PRLI_SND;
 
 	/* Driver supports multiple FC4 types.  Counters matter. */
 	vport->fc_prli_sent--;
 	ndlp->fc4_prli_sent--;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"PRLI cmpl:       status:x%x/x%x did:x%x",
@@ -2284,7 +2285,6 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    uint8_t retry)
 {
 	int rc = 0;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba *phba = vport->phba;
 	PRLI *npr;
 	struct lpfc_nvme_prli *npr_nvme;
@@ -2421,7 +2421,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba->fc_stat.elsXmitPRLI++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_prli;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_PRLI_SND;
 
 	/* The vport counters are used for lpfc_scan_finished, but
@@ -2430,7 +2430,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 */
 	vport->fc_prli_sent++;
 	ndlp->fc4_prli_sent++;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue PRLI:  did:x%x refcnt %d",
@@ -2456,9 +2456,9 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
  node_err:
 	lpfc_nlp_put(ndlp);
  io_err:
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_PRLI_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
@@ -2601,7 +2601,6 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	int  disc;
@@ -2620,10 +2619,10 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Since ndlp can be freed in the disc state machine, note if this node
 	 * is being used during discovery.
 	 */
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
 	ndlp->nlp_flag &= ~(NLP_ADISC_SND | NLP_NPR_2B_DISC);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	/* ADISC completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0104 ADISC completes to NPort x%x "
@@ -2632,9 +2631,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 irsp->ulpTimeout, disc, vport->num_disc_nodes);
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		goto out;
 	}
 
@@ -2643,9 +2642,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
 			if (disc) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock_irq(&ndlp->lock);
 				lpfc_set_disctmo(vport);
 			}
 			goto out;
@@ -2698,7 +2697,6 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		     uint8_t retry)
 {
 	int rc = 0;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	ADISC *ap;
 	struct lpfc_iocbq *elsiocb;
@@ -2726,9 +2724,9 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba->fc_stat.elsXmitADISC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_adisc;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_ADISC_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1)
 		goto node_err;
@@ -2744,9 +2742,9 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
  io_err:
 	lpfc_nlp_put(ndlp);
  node_err:
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_ADISC_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
@@ -2769,7 +2767,6 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_vport *vport = ndlp->vport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfcMboxq *mbox;
 	unsigned long flags;
@@ -2779,9 +2776,9 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
 	irsp = &(rspiocb->iocb);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO cmpl:       status:x%x/x%x did:x%x",
@@ -2871,9 +2868,9 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET) &&
 	    skip_recovery == 0) {
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&ndlp->lock, flags);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&ndlp->lock, flags);
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3187 LOGO completes to NPort x%x: Start "
@@ -2912,19 +2909,18 @@ int
 lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    uint8_t retry)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	if (ndlp->nlp_flag & NLP_LOGO_SND) {
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return 0;
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	cmdsize = (2 * sizeof(uint32_t)) + sizeof(struct lpfc_name);
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
@@ -2943,10 +2939,10 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba->fc_stat.elsXmitLOGO++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_logo;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	ndlp->nlp_flag &= ~NLP_ISSUE_LOGO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1)
 		goto node_err;
@@ -2958,18 +2954,18 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (rc == IOCB_ERROR)
 		goto io_err;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_prev_state = ndlp->nlp_state;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_LOGO_ISSUE);
 	return 0;
 
  io_err:
 	lpfc_nlp_put(ndlp);
  node_err:
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
@@ -3522,9 +3518,9 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 
 	if (!(nlp->nlp_flag & NLP_DELAY_TMO))
 		return;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&nlp->lock);
 	nlp->nlp_flag &= ~NLP_DELAY_TMO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&nlp->lock);
 	del_timer_sync(&nlp->nlp_delayfunc);
 	nlp->nlp_last_elscmd = 0;
 	if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
@@ -3534,9 +3530,9 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 		lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
 	}
 	if (nlp->nlp_flag & NLP_NPR_2B_DISC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&nlp->lock);
 		nlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&nlp->lock);
 		if (vport->num_disc_nodes) {
 			if (vport->port_state < LPFC_VPORT_READY) {
 				/* Check if there are more ADISCs to be sent */
@@ -3612,20 +3608,19 @@ void
 lpfc_els_retry_delay_handler(struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_vport *vport = ndlp->vport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	uint32_t cmd, retry;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	cmd = ndlp->nlp_last_elscmd;
 	ndlp->nlp_last_elscmd = 0;
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return;
 	}
 
 	ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	/*
 	 * If a discovery event readded nlp_delayfunc after timer
 	 * firing and before processing the timer, cancel the
@@ -3754,7 +3749,6 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	       struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -4012,9 +4006,9 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 */
 			if (stat.un.b.lsRjtRsnCodeExp ==
 			    LSEXP_REQ_UNSUPPORTED && cmd == ELS_CMD_PRLI) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag |= NLP_FCP_PRLI_RJT;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock_irq(&ndlp->lock);
 				retry = 0;
 				goto out_retry;
 			}
@@ -4117,9 +4111,9 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			/* delay is specified in milliseconds */
 			mod_timer(&ndlp->nlp_delayfunc,
 				jiffies + msecs_to_jiffies(delay));
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			if ((cmd == ELS_CMD_PRLI) ||
@@ -4596,11 +4590,11 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 out:
 	if (ndlp && shost) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		if (mbox)
 			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
 		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 
 		/* If the node is not being used by another discovery thread,
 		 * and we are sending a reject, we are done with it.
@@ -4652,7 +4646,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		 struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp,
 		 LPFC_MBOXQ_t *mbox)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
@@ -4671,9 +4664,9 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry,
 					     ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
 		if (!elsiocb) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			return 1;
 		}
 
@@ -4777,11 +4770,11 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		return 1;
 	}
 	if (ndlp->nlp_flag & NLP_LOGO_ACC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED ||
 			ndlp->nlp_flag & NLP_REG_LOGIN_SEND))
 			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		elsiocb->iocb_cmpl = lpfc_cmpl_els_logo_acc;
 	} else {
 		elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
@@ -5408,9 +5401,9 @@ lpfc_els_disc_adisc(struct lpfc_vport *vport)
 		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
 		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
 		    (ndlp->nlp_flag & NLP_NPR_ADISC) != 0) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
 			lpfc_issue_els_adisc(vport, ndlp, 0);
@@ -8577,14 +8570,14 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 * if the ndlp is in DEV_LOSS
 	 */
 	shost = lpfc_shost_from_vport(vport);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	if (ndlp->nlp_flag & NLP_IN_DEV_LOSS) {
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		goto dropit;
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1)
@@ -8650,9 +8643,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			}
 		}
 
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_TARGET_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 
 		lpfc_disc_state_machine(vport, ndlp, elsiocb,
 					NLP_EVT_RCV_PLOGI);
@@ -9347,9 +9340,9 @@ lpfc_retry_pport_discovery(struct lpfc_hba *phba)
 
 	shost = lpfc_shost_from_vport(phba->pport);
 	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000));
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	ndlp->nlp_last_elscmd = ELS_CMD_FLOGI;
 	phba->pport->port_state = LPFC_FLOGI;
 	return;
@@ -9474,9 +9467,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if ((np->nlp_state != NLP_STE_NPR_NODE) ||
 			    !(np->nlp_flag & NLP_NPR_ADISC))
 				continue;
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			np->nlp_flag &= ~NLP_NPR_ADISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			lpfc_unreg_rpi(vport, np);
 		}
 		lpfc_cleanup_pending_mbox(vport);
@@ -9710,7 +9703,6 @@ int
 lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	int rc = 0;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
@@ -9736,9 +9728,9 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		ndlp->nlp_DID, ndlp->nlp_flag, 0);
 
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_npiv_logo;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1)
 		goto node_err;
@@ -9750,9 +9742,9 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  io_err:
 	lpfc_nlp_put(ndlp);
  node_err:
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
@@ -10235,10 +10227,10 @@ lpfc_sli_abts_recover_port(struct lpfc_vport *vport,
 	 * The rport is not responding.  Remove the FCP-2 flag to prevent
 	 * an ADISC in the follow-up recovery code.
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&ndlp->lock, flags);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 	ndlp->nlp_flag |= NLP_ISSUE_LOGO;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&ndlp->lock, flags);
 	lpfc_unreg_rpi(vport, ndlp);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 71ef50c65dcf..8f3106aadfc7 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -73,34 +73,69 @@ static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 static int lpfc_fcf_inuse(struct lpfc_hba *);
 static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
-void
-lpfc_terminate_rport_io(struct fc_rport *rport)
+/* The source of a terminate rport IO is either a dev_loss_tmo
+ * event or a call to fc_remove_host.  While the rport should be
+ * valid during these downcalls, the transport can call twice
+ * in a single event.  This routine provides somoe protection
+ * as the NDLP isn't really free, just released to the pool.
+ */
+static int
+lpfc_rport_invalid(struct fc_rport *rport)
 {
 	struct lpfc_rport_data *rdata;
-	struct lpfc_nodelist * ndlp;
-	struct lpfc_hba *phba;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_vport *vport;
+
+	if (!rport) {
+		pr_err("**** %s: NULL rport, exit.\n", __func__);
+		return -EINVAL;
+	}
 
 	rdata = rport->dd_data;
+	if (!rdata) {
+		pr_err("**** %s: NULL dd_data on rport %p SID x%x\n",
+		       __func__, rport, rport->scsi_target_id);
+		return -EINVAL;
+	}
+
 	ndlp = rdata->pnode;
+	if (!rdata->pnode) {
+		pr_err("**** %s: NULL ndlp on rport %p SID x%x\n",
+		       __func__, rport, rport->scsi_target_id);
+		return -EINVAL;
+	}
 
-	if (!ndlp) {
-		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
-			printk(KERN_ERR "Cannot find remote node"
-			" to terminate I/O Data x%x\n",
-			rport->port_id);
-		return;
+	vport = ndlp->vport;
+	if (!ndlp->vport) {
+		pr_err("**** %s: Null vport on ndlp %p, DID x%x rport %p "
+		       "SID x%x\n", __func__, ndlp, ndlp->nlp_DID, rport,
+		       rport->scsi_target_id);
+		return -EINVAL;
 	}
+	return 0;
+}
 
-	phba  = ndlp->phba;
+void
+lpfc_terminate_rport_io(struct fc_rport *rport)
+{
+	struct lpfc_rport_data *rdata;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_vport *vport;
 
-	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_RPORT,
-		"rport terminate: sid:x%x did:x%x flg:x%x",
-		ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
+	if (lpfc_rport_invalid(rport))
+		return;
+
+	rdata = rport->dd_data;
+	ndlp = rdata->pnode;
+	vport = ndlp->vport;
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
+			      "rport terminate: sid:x%x did:x%x flg:x%x",
+			      ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
-		lpfc_sli_abort_iocb(ndlp->vport,
-			&phba->sli.sli3_ring[LPFC_FCP_RING],
-			ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+		lpfc_sli_abort_iocb(vport,
+				    &vport->phba->sli.sli3_ring[LPFC_FCP_RING],
+				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 }
 
@@ -110,17 +145,13 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 void
 lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
-	struct lpfc_rport_data *rdata;
-	struct lpfc_nodelist * ndlp;
+	struct lpfc_nodelist *ndlp;
 	struct lpfc_vport *vport;
-	struct Scsi_Host *shost;
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
-	int  put_node;
 	unsigned long iflags;
 
-	rdata = rport->dd_data;
-	ndlp = rdata->pnode;
+	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
 		return;
 
@@ -132,19 +163,24 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3181 dev_loss_callbk x%06x, rport x%px flg x%x\n",
-			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag);
+			 "3181 dev_loss_callbk x%06x, rport %p flg x%x "
+			 "load_flag x%x refcnt %d\n",
+			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag,
+			 vport->load_flag, kref_read(&ndlp->kref));
 
-	/* Don't defer this if we are in the process of deleting the vport
-	 * or unloading the driver. The unload will cleanup the node
-	 * appropriately we just need to cleanup the ndlp rport info here.
+	/* Don't schedule a worker thread event if the vport is going down.
+	 * The teardown process cleans up the node via lpfc_drop_node.
 	 */
 	if (vport->load_flag & FC_UNLOADING) {
-		put_node = rdata->pnode != NULL;
-		rdata->pnode = NULL;
+		((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
 		ndlp->rport = NULL;
-		if (put_node)
-			lpfc_nlp_put(ndlp);
+
+		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+
+		/* Remove the node reference from remote_port_add now.
+		 * The driver will not call remote_port_delete.
+		 */
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
@@ -161,15 +197,20 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	if (!list_empty(&evtp->evt_listp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "6790 rport name %llx dev_loss_evt pending",
+				 "6790 rport name %llx dev_loss_evt pending\n",
 				 rport->port_name);
 		return;
 	}
 
-	shost = lpfc_shost_from_vport(vport);
-	spin_lock_irqsave(shost->host_lock, iflags);
+	spin_lock_irqsave(&ndlp->lock, iflags);
 	ndlp->nlp_flag |= NLP_IN_DEV_LOSS;
-	spin_unlock_irqrestore(shost->host_lock, iflags);
+	/*
+	 * The backend does not expect any more calls assoicated with this
+	 * rport, Remove the association between rport and ndlp
+	 */
+	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
+	ndlp->rport = NULL;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 	/* We need to hold the node by incrementing the reference
 	 * count until this queued work is done
@@ -200,68 +241,35 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 static int
 lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 {
-	struct lpfc_rport_data *rdata;
-	struct fc_rport   *rport;
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
 	struct Scsi_Host  *shost;
 	uint8_t *name;
-	int  put_node;
 	int warn_on = 0;
 	int fcf_inuse = 0;
 	unsigned long iflags;
+	u32 fc4_xpt_flags;
 
-	rport = ndlp->rport;
 	vport = ndlp->vport;
 	shost = lpfc_shost_from_vport(vport);
+	name = (uint8_t *)&ndlp->nlp_portname;
+	phba = vport->phba;
 
-	spin_lock_irqsave(shost->host_lock, iflags);
+	spin_lock_irqsave(&ndlp->lock, iflags);
 	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
-	spin_unlock_irqrestore(shost->host_lock, iflags);
-
-	if (!rport)
-		return fcf_inuse;
-
-	name = (uint8_t *) &ndlp->nlp_portname;
-	phba  = vport->phba;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		fcf_inuse = lpfc_fcf_inuse(phba);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
-		"rport devlosstmo:did:x%x type:x%x id:x%x",
-		ndlp->nlp_DID, ndlp->nlp_type, rport->scsi_target_id);
+			      "rport devlosstmo:did:x%x type:x%x id:x%x",
+			      ndlp->nlp_DID, ndlp->nlp_type, ndlp->nlp_sid);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3182 dev_loss_tmo_handler x%06x, rport x%px flg x%x\n",
-			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag);
-
-	/*
-	 * lpfc_nlp_remove if reached with dangling rport drops the
-	 * reference. To make sure that does not happen clear rport
-	 * pointer in ndlp before lpfc_nlp_put.
-	 */
-	rdata = rport->dd_data;
-
-	/* Don't defer this if we are in the process of deleting the vport
-	 * or unloading the driver. The unload will cleanup the node
-	 * appropriately we just need to cleanup the ndlp rport info here.
-	 */
-	if (vport->load_flag & FC_UNLOADING) {
-		if (ndlp->nlp_sid != NLP_NO_SID) {
-			/* flush the target */
-			lpfc_sli_abort_iocb(vport,
-					    &phba->sli.sli3_ring[LPFC_FCP_RING],
-					    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
-		}
-		put_node = rdata->pnode != NULL;
-		rdata->pnode = NULL;
-		ndlp->rport = NULL;
-		if (put_node)
-			lpfc_nlp_put(ndlp);
-
-		return fcf_inuse;
-	}
+			 "3182 %s x%06x, nflag x%x xflags x%x\n",
+			 __func__, ndlp->nlp_DID, ndlp->nlp_flag,
+			 ndlp->fc4_xpt_flags);
 
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
@@ -274,12 +282,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		return fcf_inuse;
 	}
 
-	put_node = rdata->pnode != NULL;
-	rdata->pnode = NULL;
-	ndlp->rport = NULL;
-	if (put_node)
-		lpfc_nlp_put(ndlp);
-
 	if (ndlp->nlp_type & NLP_FABRIC)
 		return fcf_inuse;
 
@@ -309,11 +311,12 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	if (!(ndlp->nlp_flag & NLP_DELAY_TMO) &&
-	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
-	    (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) &&
-	    (ndlp->nlp_state != NLP_STE_PRLI_ISSUE))
+	/* Should be final reference removal triggering a node free. */
+	spin_lock_irqsave(shost->host_lock, iflags);
+	fc4_xpt_flags = ndlp->fc4_xpt_flags;
+	spin_unlock_irqrestore(shost->host_lock, iflags);
+
+	if (!(fc4_xpt_flags & (NVME_XPT_REGD | SCSI_XPT_REGD)))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
 	return fcf_inuse;
@@ -3580,7 +3583,6 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 
 	pmb->ctx_buf = NULL;
 	pmb->ctx_ndlp = NULL;
@@ -3603,9 +3605,9 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		 * there is another reg login in
 		 * process.
 		 */
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 
 		/*
 		 * We cannot leave the RPI registered because
@@ -4157,6 +4159,7 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_rport_data *rdata;
 	struct fc_rport_identifiers rport_ids;
 	struct lpfc_hba  *phba = vport->phba;
+	unsigned long flags;
 
 	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		return;
@@ -4167,33 +4170,23 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	rport_ids.port_id = ndlp->nlp_DID;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
-	/*
-	 * We leave our node pointer in rport->dd_data when we unregister a
-	 * FCP target port.  But fc_remote_port_add zeros the space to which
-	 * rport->dd_data points.  So, if we're reusing a previously
-	 * registered port, drop the reference that we took the last time we
-	 * registered the port.
-	 */
-	rport = ndlp->rport;
-	if (rport) {
-		rdata = rport->dd_data;
-		/* break the link before dropping the ref */
-		ndlp->rport = NULL;
-		if (rdata) {
-			if (rdata->pnode == ndlp)
-				lpfc_nlp_put(ndlp);
-			rdata->pnode = NULL;
-		}
-	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
-		"rport add:       did:x%x flg:x%x type x%x",
-		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
+			      "rport add:       did:x%x flg:x%x type x%x",
+			      ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
 	/* Don't add the remote port if unloading. */
 	if (vport->load_flag & FC_UNLOADING)
 		return;
 
+	/*
+	 * Disassociate any older association between this ndlp and rport
+	 */
+	if (ndlp->rport) {
+		rdata = ndlp->rport->dd_data;
+		rdata->pnode = NULL;
+	}
+
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
@@ -4201,7 +4194,7 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		return;
 	}
 
-	/* initialize static port data */
+	/* Successful port add.  Complete initializing node data */
 	rport->maxframe_size = ndlp->nlp_maxframe;
 	rport->supported_classes = ndlp->nlp_class_sup;
 	rdata = rport->dd_data;
@@ -4214,6 +4207,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		return;
 	}
 
+	spin_lock_irqsave(&ndlp->lock, flags);
+	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
+	spin_unlock_irqrestore(&ndlp->lock, flags);
+
 	if (ndlp->nlp_type & NLP_FCP_TARGET)
 		rport_ids.roles |= FC_PORT_ROLE_FCP_TARGET;
 	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
@@ -4229,8 +4226,8 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		fc_remote_port_rolechg(rport, rport_ids.roles);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3183 rport register x%06x, rport x%px role x%x\n",
-			 ndlp->nlp_DID, rport, rport_ids.roles);
+			 "3183 %s rport x%px DID x%x, role x%x\n",
+			 __func__, rport, rport->port_id, rport->roles);
 
 	if ((rport->scsi_target_id != -1) &&
 	    (rport->scsi_target_id < LPFC_MAX_TARGET)) {
@@ -4254,12 +4251,12 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-			 "3184 rport unregister x%06x, rport x%px\n",
-			 ndlp->nlp_DID, rport);
+			 "3184 rport unregister x%06x, rport x%px "
+			 "xptflg x%x\n",
+			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags);
 
 	fc_remote_port_delete(rport);
-
-	return;
+	lpfc_nlp_put(ndlp);
 }
 
 static void
@@ -4305,8 +4302,6 @@ static void
 lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       int old_state, int new_state)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (new_state == NLP_STE_UNMAPPED_NODE) {
 		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		ndlp->nlp_type |= NLP_FC_NODE;
@@ -4400,9 +4395,9 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	    (!ndlp->rport ||
 	     ndlp->rport->scsi_target_id == -1 ||
 	     ndlp->rport->scsi_target_id >= LPFC_MAX_TARGET)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_TGT_NO_SCSIID;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
 }
@@ -4821,11 +4816,9 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 	} else {
 		if (vport->load_flag & FC_UNLOADING) {
 			if (phba->sli_rev == LPFC_SLI_REV4) {
-				spin_lock_irqsave(&vport->phba->ndlp_lock,
-						  iflags);
+				spin_lock_irqsave(&ndlp->lock, iflags);
 				ndlp->nlp_flag |= NLP_RELEASE_RPI;
-				spin_unlock_irqrestore(&vport->phba->ndlp_lock,
-						       iflags);
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
 			}
 			lpfc_nlp_get(ndlp);
 		}
@@ -5053,7 +5046,6 @@ lpfc_unreg_default_rpis(struct lpfc_vport *vport)
 static int
 lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
@@ -5112,9 +5104,9 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	lpfc_els_abort(phba, ndlp);
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	ndlp->nlp_last_elscmd = 0;
 	del_timer_sync(&ndlp->nlp_delayfunc);
@@ -5131,88 +5123,15 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		    !(ndlp->nlp_rpi == LPFC_RPI_ALLOC_ERROR)) {
 			lpfc_sli4_free_rpi(vport->phba,
 					   ndlp->nlp_rpi);
-			spin_lock_irqsave(&vport->phba->ndlp_lock,
-					  iflags);
+			spin_lock_irqsave(&ndlp->lock, iflags);
 			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
 			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-			spin_unlock_irqrestore(&vport->phba->ndlp_lock,
-					       iflags);
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 	}
 	return 0;
 }
 
-/*
- * Check to see if we can free the nlp back to the freelist.
- * If we are in the middle of using the nlp in the discovery state
- * machine, defer the free till we reach the end of the state machine.
- */
-static void
-lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
-{
-	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_rport_data *rdata;
-	struct fc_rport *rport;
-	LPFC_MBOXQ_t *mbox;
-	int rc;
-
-	lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	if (!(ndlp->nlp_flag & NLP_REG_LOGIN_SEND) &&
-	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED) &&
-	    phba->sli_rev != LPFC_SLI_REV4) {
-		/* For this case we need to cleanup the default rpi
-		 * allocated by the firmware.
-		 */
-		lpfc_printf_vlog(vport, KERN_INFO,
-				 LOG_NODE | LOG_DISCOVERY,
-				 "0005 Cleanup Default rpi:x%x DID:x%x flg:x%x "
-				 "ref %d ndlp x%px\n",
-				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
-				 kref_read(&ndlp->kref),
-				 ndlp);
-		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
-			!= NULL) {
-			rc = lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
-			    (uint8_t *) &vport->fc_sparam, mbox, ndlp->nlp_rpi);
-			if (rc) {
-				mempool_free(mbox, phba->mbox_mem_pool);
-			}
-			else {
-				mbox->mbox_flag |= LPFC_MBX_IMED_UNREG;
-				mbox->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;
-				mbox->vport = vport;
-				mbox->ctx_ndlp = ndlp;
-				rc =lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-				if (rc == MBX_NOT_FINISHED) {
-					mempool_free(mbox, phba->mbox_mem_pool);
-				}
-			}
-		}
-	}
-	lpfc_cleanup_node(vport, ndlp);
-
-	/*
-	 * ndlp->rport must be set to NULL before it reaches here
-	 * i.e. break rport/node link before doing lpfc_nlp_put for
-	 * registered rport and then drop the reference of rport.
-	 */
-	if (ndlp->rport) {
-		/*
-		 * extra lpfc_nlp_put dropped the reference of ndlp
-		 * for registered rport so need to cleanup rport
-		 */
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-				"0940 removed node x%px DID x%x "
-				"rpi %d rport not null x%px\n",
-				 ndlp, ndlp->nlp_DID, ndlp->nlp_rpi,
-				 ndlp->rport);
-		rport = ndlp->rport;
-		rdata = rport->dd_data;
-		rdata->pnode = NULL;
-		ndlp->rport = NULL;
-	}
-}
-
 static int
 lpfc_matchdid(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	      uint32_t did)
@@ -5348,7 +5267,6 @@ lpfc_findnode_mapped(struct lpfc_vport *vport)
 struct lpfc_nodelist *
 lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
 
 	ndlp = lpfc_findnode_did(vport, did);
@@ -5369,9 +5287,9 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 				 ndlp->nlp_DID, ndlp->nlp_flag,
 				 ndlp->nlp_state, vport->fc_flag);
 
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return ndlp;
 	}
 
@@ -5413,9 +5331,9 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 		} else {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "6456 Skip Setup RSCN Node x%x "
@@ -5449,9 +5367,9 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		 */
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 	}
 	return ndlp;
 }
@@ -6199,6 +6117,8 @@ lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 
 	memset(ndlp, 0, sizeof (struct lpfc_nodelist));
 
+	spin_lock_init(&ndlp->lock);
+
 	lpfc_initialize_node(vport, ndlp, did);
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
@@ -6234,18 +6154,28 @@ lpfc_nlp_release(struct kref *kref)
 {
 	struct lpfc_nodelist *ndlp = container_of(kref, struct lpfc_nodelist,
 						  kref);
+	struct lpfc_vport *vport = ndlp->vport;
 
 	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
 		"node release:    did:x%x flg:x%x type:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
-	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			"0279 %s: ndlp:x%px did %x refcnt:%d rpi:%x\n",
-			__func__, (void *)ndlp, ndlp->nlp_DID,
-			kref_read(&ndlp->kref), ndlp->nlp_rpi);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+			"0279 %s: ndlp:%p did %x refcnt:%d rpi:%x\n",
+			 __func__, ndlp, ndlp->nlp_DID,
+			 kref_read(&ndlp->kref), ndlp->nlp_rpi);
 
 	/* remove ndlp from action. */
-	lpfc_nlp_remove(ndlp->vport, ndlp);
+	lpfc_cancel_retry_delay_tmo(vport, ndlp);
+	lpfc_cleanup_node(vport, ndlp);
+
+	/* Clear Node key fields to give other threads notice
+	 * that this node memory is not valid anymore.
+	 */
+	ndlp->vport = NULL;
+	ndlp->nlp_state = NLP_STE_FREED_NODE;
+	ndlp->nlp_flag = 0;
+	ndlp->fc4_xpt_flags = 0;
 
 	/* free ndlp memory for final ndlp release */
 	kfree(ndlp->lat_data);
@@ -6276,15 +6206,15 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 		 * released.
 		 */
 		phba = ndlp->phba;
-		spin_lock_irqsave(&phba->ndlp_lock, flags);
+		spin_lock_irqsave(&ndlp->lock, flags);
 		if (!kref_get_unless_zero(&ndlp->kref)) {
-			spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+			spin_unlock_irqrestore(&ndlp->lock, flags);
 			lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
 				"0276 %s: ndlp:x%px refcnt:%d\n",
 				__func__, (void *)ndlp, kref_read(&ndlp->kref));
 			return NULL;
 		}
-		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+		spin_unlock_irqrestore(&ndlp->lock, flags);
 	} else {
 		WARN_ONCE(!ndlp, "**** %s, get ref on NULL ndlp!", __func__);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 65b9e4e06b9f..f0cbf98e7caa 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3497,9 +3497,9 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					continue;
 				}
 
-				spin_lock_irq(shost->host_lock);
+				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock_irq(&ndlp->lock);
 				/*
 				 * Whenever an SLI4 port goes offline, free the
 				 * RPI. Get a new RPI when the adapter port
@@ -5828,9 +5828,9 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 			mod_timer(&ndlp->nlp_delayfunc,
 				  jiffies + msecs_to_jiffies(1000));
 			shost = lpfc_shost_from_vport(vport);
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
 			vport->port_state = LPFC_FDISC;
 		} else {
@@ -6280,9 +6280,6 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 	atomic_set(&phba->dbg_log_dmping, 0);
 	spin_lock_init(&phba->hbalock);
 
-	/* Initialize ndlp management spinlock */
-	spin_lock_init(&phba->ndlp_lock);
-
 	/* Initialize port_list spinlock */
 	spin_lock_init(&phba->port_list_lock);
 	INIT_LIST_HEAD(&phba->port_list);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 5c57aeb1fb0b..1eddb40f009c 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -381,7 +381,6 @@ static int
 lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	       struct lpfc_iocbq *cmdiocb)
 {
-	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba    *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
 	uint64_t nlp_portwwn = 0;
@@ -617,9 +616,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 * command issued in lpfc_cmpl_els_acc().
 	 */
 	login_mbox->vport = vport;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	/*
 	 * If there is an outstanding PLOGI issued, abort it before
@@ -648,9 +647,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * this ELS request. The only way to do this is
 		 * to register, then unregister the RPI.
 		 */
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_RM_DFLT_RPI;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
@@ -739,7 +738,6 @@ static int
 lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		struct lpfc_iocbq *cmdiocb)
 {
-	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq  *elsiocb;
 	struct lpfc_dmabuf *pcmd;
 	struct serv_parm   *sp;
@@ -821,9 +819,9 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* 1 sec timeout */
 	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000));
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	ndlp->nlp_prev_state = ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
@@ -843,9 +841,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* Only call LOGO ACC for first LOGO, this avoids sending unnecessary
 	 * PLOGIs during LOGO storms from a device.
 	 */
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	if (els_cmd == ELS_CMD_PRLO)
 		lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	else
@@ -890,9 +888,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 */
 			mod_timer(&ndlp->nlp_delayfunc,
 				  jiffies + msecs_to_jiffies(1000));
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
 			vport->port_state = LPFC_FDISC;
 		} else {
@@ -908,9 +906,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		/* Only try to re-login if this is NOT a Fabric Node */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	}
@@ -918,9 +916,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_prev_state = ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	/* The driver has to wait until the ACC completes before it continues
 	 * processing the LOGO.  The action will resume in
 	 * lpfc_cmpl_els_logo_acc routine. Since part of processing includes an
@@ -1036,12 +1034,10 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 static uint32_t
 lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return 0;
 	}
 
@@ -1050,16 +1046,16 @@ lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		if (vport->cfg_use_adisc && ((vport->fc_flag & FC_RSCN_MODE) ||
 		    ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) &&
 		     (ndlp->nlp_type & NLP_FCP_TARGET)))) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_NPR_ADISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			return 1;
 		}
 	}
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_unreg_rpi(vport, ndlp);
 	return 0;
 }
@@ -1196,12 +1192,11 @@ static uint32_t
 lpfc_rcv_logo_unused_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  void *arg, uint32_t evt)
 {
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	return ndlp->nlp_state;
@@ -1262,9 +1257,9 @@ lpfc_rcv_plogi_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (lpfc_rcv_plogi(vport, ndlp, cmdiocb) &&
 		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
 		    (vport->num_disc_nodes)) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			/* Check if there are more PLOGIs to be sent */
 			lpfc_more_plogi(vport);
 			if (vport->num_disc_nodes == 0) {
@@ -1314,7 +1309,6 @@ static uint32_t
 lpfc_rcv_els_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 void *arg, uint32_t evt)
 {
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
@@ -1329,9 +1323,9 @@ lpfc_rcv_els_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* Put ndlp in npr state set plogi timer for 1 sec */
 	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000 * 1));
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
@@ -1577,12 +1571,10 @@ static uint32_t
 lpfc_device_rm_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return ndlp->nlp_state;
 	} else {
 		/* software abort outstanding PLOGI */
@@ -1599,7 +1591,6 @@ lpfc_device_recov_plogi_issue(struct lpfc_vport *vport,
 			      void *arg,
 			      uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Don't do anything that will mess up processing of the
@@ -1613,9 +1604,9 @@ lpfc_device_recov_plogi_issue(struct lpfc_vport *vport,
 
 	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	return ndlp->nlp_state;
 }
@@ -1624,7 +1615,6 @@ static uint32_t
 lpfc_rcv_plogi_adisc_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
 
@@ -1635,9 +1625,9 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (lpfc_rcv_plogi(vport, ndlp, cmdiocb)) {
 		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			if (vport->num_disc_nodes)
 				lpfc_more_adisc(vport);
 		}
@@ -1708,7 +1698,6 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 			    struct lpfc_nodelist *ndlp,
 			    void *arg, uint32_t evt)
 {
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
 	IOCB_t *irsp;
@@ -1726,9 +1715,9 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 		/* 1 sec timeout */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000));
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		memset(&ndlp->nlp_nodename, 0, sizeof(struct lpfc_name));
@@ -1770,12 +1759,10 @@ static uint32_t
 lpfc_device_rm_adisc_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return ndlp->nlp_state;
 	} else {
 		/* software abort outstanding ADISC */
@@ -1792,7 +1779,6 @@ lpfc_device_recov_adisc_issue(struct lpfc_vport *vport,
 			      void *arg,
 			      uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Don't do anything that will mess up processing of the
@@ -1806,9 +1792,9 @@ lpfc_device_recov_adisc_issue(struct lpfc_vport *vport,
 
 	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -1950,7 +1936,6 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 				  void *arg,
 				  uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba *phba = vport->phba;
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
 	MAILBOX_t *mb = &pmb->u.mb;
@@ -1977,9 +1962,9 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		/* Put ndlp in npr state set plogi timer for 1 sec */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		lpfc_issue_els_logo(vport, ndlp, 0);
@@ -2062,12 +2047,10 @@ lpfc_device_rm_reglogin_issue(struct lpfc_vport *vport,
 			      void *arg,
 			      uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return ndlp->nlp_state;
 	} else {
 		lpfc_drop_node(vport, ndlp);
@@ -2081,8 +2064,6 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 				 void *arg,
 				 uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	/* Don't do anything that will mess up processing of the
 	 * previous RSCN.
 	 */
@@ -2091,7 +2072,7 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 
 	ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 
 	/* If we are a target we won't immediately transition into PRLI,
 	 * so if REG_LOGIN already completed we don't need to ignore it.
@@ -2101,7 +2082,7 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 		ndlp->nlp_flag |= NLP_IGNR_REG_CMPL;
 
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -2172,7 +2153,6 @@ static uint32_t
 lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
 	struct lpfc_hba   *phba = vport->phba;
 	IOCB_t *irsp;
@@ -2294,9 +2274,9 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	    (vport->port_type == LPFC_NPIV_PORT) &&
 	     vport->cfg_restrict_login) {
 out:
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_TARGET_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_issue_els_logo(vport, ndlp, 0);
 
 		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
@@ -2348,12 +2328,10 @@ static uint32_t
 lpfc_device_rm_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return ndlp->nlp_state;
 	} else {
 		/* software abort outstanding PLOGI */
@@ -2387,7 +2365,6 @@ lpfc_device_recov_prli_issue(struct lpfc_vport *vport,
 			     void *arg,
 			     uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Don't do anything that will mess up processing of the
@@ -2401,9 +2378,9 @@ lpfc_device_recov_prli_issue(struct lpfc_vport *vport,
 
 	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -2440,12 +2417,11 @@ static uint32_t
 lpfc_rcv_logo_logo_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 void *arg, uint32_t evt)
 {
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *)arg;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	return ndlp->nlp_state;
 }
@@ -2482,13 +2458,11 @@ static uint32_t
 lpfc_cmpl_logo_logo_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	ndlp->nlp_prev_state = NLP_STE_LOGO_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -2582,14 +2556,12 @@ lpfc_device_recov_unmap_node(struct lpfc_vport *vport,
 			     void *arg,
 			     uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	ndlp->nlp_prev_state = NLP_STE_UNMAPPED_NODE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 
 	return ndlp->nlp_state;
@@ -2660,14 +2632,12 @@ lpfc_device_recov_mapped_node(struct lpfc_vport *vport,
 			      void *arg,
 			      uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	ndlp->nlp_prev_state = NLP_STE_MAPPED_NODE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -2676,7 +2646,6 @@ static uint32_t
 lpfc_rcv_plogi_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb  = (struct lpfc_iocbq *) arg;
 
 	/* Ignore PLOGI if we have an outstanding LOGO */
@@ -2684,9 +2653,9 @@ lpfc_rcv_plogi_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return ndlp->nlp_state;
 	if (lpfc_rcv_plogi(vport, ndlp, cmdiocb)) {
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~(NLP_NPR_ADISC | NLP_NPR_2B_DISC);
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 	} else if (!(ndlp->nlp_flag & NLP_NPR_2B_DISC)) {
 		/* send PLOGI immediately, move to PLOGI issue state */
 		if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
@@ -2702,7 +2671,6 @@ static uint32_t
 lpfc_rcv_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       void *arg, uint32_t evt)
 {
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 	struct ls_rjt     stat;
 
@@ -2713,10 +2681,10 @@ lpfc_rcv_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
 		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&ndlp->lock);
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
 			lpfc_issue_els_adisc(vport, ndlp, 0);
 		} else {
@@ -2770,27 +2738,26 @@ static uint32_t
 lpfc_rcv_prlo_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) == 0) {
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	} else {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 	}
 	return ndlp->nlp_state;
 }
@@ -2893,12 +2860,10 @@ static uint32_t
 lpfc_device_rm_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&ndlp->lock);
 		return ndlp->nlp_state;
 	}
 	lpfc_drop_node(vport, ndlp);
@@ -2909,8 +2874,6 @@ static uint32_t
 lpfc_device_recov_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	/* Don't do anything that will mess up processing of the
 	 * previous RSCN.
 	 */
@@ -2918,10 +2881,10 @@ lpfc_device_recov_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return ndlp->nlp_state;
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&ndlp->lock);
 	return ndlp->nlp_state;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 275ddccd9950..60f4fbffc4ee 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -382,7 +382,7 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			"6146 remoteport delete of remoteport %p\n",
 			remoteport);
-	spin_lock_irq(&vport->phba->hbalock);
+	spin_lock_irq(&ndlp->lock);
 
 	/* The register rebind might have occurred before the delete
 	 * downcall.  Guard against this race.
@@ -390,7 +390,7 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	if (ndlp->fc4_xpt_flags & NLP_WAIT_FOR_UNREG)
 		ndlp->fc4_xpt_flags &= ~(NLP_WAIT_FOR_UNREG | NVME_XPT_REGD);
 
-	spin_unlock_irq(&vport->phba->hbalock);
+	spin_unlock_irq(&ndlp->lock);
 
 	/* On a devloss timeout event, one more put is executed provided the
 	 * NVME and SCSI rport unregister requests are complete.  If the vport
@@ -2475,13 +2475,13 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	else
 		rpinfo.dev_loss_tmo = vport->cfg_devloss_tmo;
 
-	spin_lock_irq(&vport->phba->hbalock);
+	spin_lock_irq(&ndlp->lock);
 	oldrport = lpfc_ndlp_get_nrport(ndlp);
 	if (oldrport) {
 		prev_ndlp = oldrport->ndlp;
-		spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&ndlp->lock);
 	} else {
-		spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&ndlp->lock);
 		if (!lpfc_nlp_get(ndlp)) {
 			dev_warn(&vport->phba->pcidev->dev,
 				 "Warning - No node ref - exit register\n");
@@ -2498,10 +2498,10 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		/* Guard against an unregister/reregister
 		 * race that leaves the WAIT flag set.
 		 */
-		spin_lock_irq(&vport->phba->hbalock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->fc4_xpt_flags &= ~NLP_WAIT_FOR_UNREG;
 		ndlp->fc4_xpt_flags |= NVME_XPT_REGD;
-		spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&ndlp->lock);
 		rport = remote_port->private;
 		if (oldrport) {
 
@@ -2509,10 +2509,10 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 * before dropping the ndlp ref from
 			 * register.
 			 */
-			spin_lock_irq(&vport->phba->hbalock);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nrport = NULL;
 			ndlp->fc4_xpt_flags &= ~NLP_WAIT_FOR_UNREG;
-			spin_unlock_irq(&vport->phba->hbalock);
+			spin_unlock_irq(&ndlp->lock);
 			rport->ndlp = NULL;
 			rport->remoteport = NULL;
 
@@ -2530,9 +2530,9 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		rport->remoteport = remote_port;
 		rport->lport = lport;
 		rport->ndlp = ndlp;
-		spin_lock_irq(&vport->phba->hbalock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nrport = rport;
-		spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_printf_vlog(vport, KERN_INFO,
 				 LOG_NVME_DISC | LOG_NODE,
 				 "6022 Bind lport x%px to remoteport x%px "
@@ -2571,11 +2571,11 @@ lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_nvme_rport *nrport;
 	struct nvme_fc_remote_port *remoteport = NULL;
 
-	spin_lock_irq(&vport->phba->hbalock);
+	spin_lock_irq(&ndlp->lock);
 	nrport = lpfc_ndlp_get_nrport(ndlp);
 	if (nrport)
 		remoteport = nrport->remoteport;
-	spin_unlock_irq(&vport->phba->hbalock);
+	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			 "6170 Rescan NPort DID x%06x type x%x "
@@ -2638,11 +2638,11 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (!lport)
 		goto input_err;
 
-	spin_lock_irq(&vport->phba->hbalock);
+	spin_lock_irq(&ndlp->lock);
 	rport = lpfc_ndlp_get_nrport(ndlp);
 	if (rport)
 		remoteport = rport->remoteport;
-	spin_unlock_irq(&vport->phba->hbalock);
+	spin_unlock_irq(&ndlp->lock);
 	if (!remoteport)
 		goto input_err;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d29380184a0c..bd605bb87dfc 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5316,10 +5316,10 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0722 Target Reset rport failure: rdata x%px\n", rdata);
 		if (pnode) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&pnode->lock);
 			pnode->nlp_flag &= ~NLP_NPR_ADISC;
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&pnode->lock);
 		}
 		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 					  LPFC_CTX_TGT);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1f020d2abfa0..4f537a07bac6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2448,10 +2448,10 @@ __lpfc_sli_rpi_release(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
 		lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
-		spin_lock_irqsave(&vport->phba->ndlp_lock, iflags);
+		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
 		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-		spin_unlock_irqrestore(&vport->phba->ndlp_lock, iflags);
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 	}
 	ndlp->nlp_flag &= ~NLP_UNREG_INP;
 }
@@ -19879,7 +19879,6 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 	struct lpfc_dmabuf *mp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_nodelist *act_mbx_ndlp = NULL;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	LIST_HEAD(mbox_cmd_list);
 	uint8_t restart_loop;
 
@@ -19933,9 +19932,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 				mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
 				restart_loop = 1;
 				spin_unlock_irq(&phba->hbalock);
-				spin_lock(shost->host_lock);
+				spin_lock(&ndlp->lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock(shost->host_lock);
+				spin_unlock(&ndlp->lock);
 				spin_lock_irq(&phba->hbalock);
 				break;
 			}
@@ -19957,9 +19956,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 			ndlp = (struct lpfc_nodelist *)mb->ctx_ndlp;
 			mb->ctx_ndlp = NULL;
 			if (ndlp) {
-				spin_lock(shost->host_lock);
+				spin_lock(&ndlp->lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock(shost->host_lock);
+				spin_unlock(&ndlp->lock);
 				lpfc_nlp_put(ndlp);
 			}
 		}
@@ -19968,9 +19967,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 
 	/* Release the ndlp with the cleaned-up active mailbox command */
 	if (act_mbx_ndlp) {
-		spin_lock(shost->host_lock);
+		spin_lock(&act_mbx_ndlp->lock);
 		act_mbx_ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-		spin_unlock(shost->host_lock);
+		spin_unlock(&act_mbx_ndlp->lock);
 		lpfc_nlp_put(act_mbx_ndlp);
 	}
 }
-- 
2.26.2


--000000000000f710f305b42a3e47
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgHljFbkrhXz15artV
e2jlsrvwhBlNvuCzrHY1uJkkBBowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzAxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJ5fUTgW/chI8dzC59WR2+bhBNFw8og5UEBx
XG/Q8/A4fjj487CIjzc+RQNb3K4gNOinjez3gzaMuSdvcXetkRigyMa8JTtTXg+q4clLMSjiKSrL
qnXcnBpR8H/Rj5kwgzFKI2PY6Dfdmq65aZ9M0FrqXO1RoJPF5O7cfrvfU0Ue8EjIx46ezA/RNUwt
V3/eezKgu2mRmIlFIVfjvrciUaer09uf0OJkm5cZ9sFDKnR0GeI/YJ+9AZIwJ4xZfijNDfZfIm97
MWS6W2KS6HGsVGgtniNAQIOEBbLStxZ0Xs3KUKNp75sIpKbQCJp+MkFxEncusJXJCfwdT1lgyxEm
PW4=
--000000000000f710f305b42a3e47--
