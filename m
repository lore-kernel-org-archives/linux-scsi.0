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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F405C07E9E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC96F61CC8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhGGSq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbhGGSqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:48 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CC0C061764
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a127so3025313pfa.10
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uG0E5fAFj9ifYbLD84JpUzgMntoUJD0F8u7sjk/SUVc=;
        b=kI+g030hjvyiuNJf4mytphMB5ImPuq6/tPRB48/5xOvn7Yl5tN5sRQWns8jDszdQgm
         yQ3DTfA+jBgcKG3OYPDFUt2mlHkIfSRGezIqqxFHMFM8nEYv9kmJWCqMx1QYxWRFkyEV
         3KpjwnT4MuL/W+wJV75a8rqxs4Zx6oEYjUsZh1kbRlc8WK04SCbRvbcqGNrvfFuqDVQA
         KJ6Z9VUE9XQiUBZY8hCD906Ey810GNYsaH40zKDFFsxZrs+aEKsEW+CPutscpt0dqhtv
         MrMvRPFrmaNkmJVojmL9C0+ea4ZN6bZyVehkmJjyZ3bQHPaou0z3FbLXnK+3eQCm5Hru
         qn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uG0E5fAFj9ifYbLD84JpUzgMntoUJD0F8u7sjk/SUVc=;
        b=BxJRCdMnm5rvDSyO3LkSSVg4GtIoULaE/N8tA88aczgdT90zl3lQD4cIzWXLkOv1ff
         rXFd+5OeE5XuILsBHIxWpK3BwSYrNPIG4NLpe1wkEDzKBIXWeqLwULW23xf7ZENHwW+e
         /g2zyRYvbTBlpQspjySN9l8tSWNxVMNzmWSEIomevPBEPWiP9wSvmkB2XaLPZ7cXlJFB
         97mldpa5k4O63Wc4P58g0NiSJG7dVUskab5cX5/IvqJoxNt0nUdpYyFAZYPdgb1kQ2RF
         I6bO9+5U6yAdVLB00xQX95XrA61Rr9EYPV8YMhxkE2bZfKTEpoonJTGOiEEfNU1+7ani
         cWMQ==
X-Gm-Message-State: AOAM530eS6zckFU1hkNy7h+Mdsi4qOEFUE9JmWNiVvoE0wIVc33wFwhW
        M8830M7W4ski3sijj0uTu8rd/OL62wU=
X-Google-Smtp-Source: ABdhPJwO6NtZqIOQIHSHR9madda3Xyzl9D3wNIf0EJGUjmYg8Ejy8nkXxObuuaEQXCuM5bHRjITUEw==
X-Received: by 2002:a62:154d:0:b029:323:a515:2e43 with SMTP id 74-20020a62154d0000b0290323a5152e43mr9081009pfv.75.1625683445308;
        Wed, 07 Jul 2021 11:44:05 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 15/20] lpfc: Delay unregistering from transport until GIDFT or ADISC completes
Date:   Wed,  7 Jul 2021 11:43:46 -0700
Message-Id: <20210707184351.67872-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On an RSCN event, the nodes specified in RSCN payload and in MAPPED state
are moved to NPR state in order to revalidate the login. This triggers an
immediate unregister from SCSI/NVME backend. The assumption is that the
node may be missing. The re-registration with the backend happens after
either relogin (PLOGI/PRLI; if ADISC is disabled or login truly lost) or
when ADISC completes successfully (rediscover with ADISC enabled).

However, the NVME-FC standard provides for an RSCN to be triggered when
the remote port supports a discovery controller and there was a change
of discovery log content. As the remote port typically also supports
storage subsystems, this unregister causes all storage controller
connections to fail and require reconnect.

Correct by reworking the code to ensure that the unregistration only
occurs when a login state is truly terminated, thereby leaving the
nvme storage controllers in place.

The changes made in the patch are:
- Retain node state in ADISC_ISSUE when scheduling ADISC els retry.
- Do not clear wwpn/wwnn values upon ADISC failure.
- Move MAPPED nodes to NPR during RSCN processing, but do not unregister
  with transport.  On GIDFT completion, identify missing nodes (not
  marked NLP_NPR_2B_DISC) and unregister them.
- Perform unregistration for nodes that will go through ADISC processing
  if ADISC completion fails.
- Successful ADISC completion will move node back to MAPPED state.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +
 drivers/scsi/lpfc/lpfc_disc.h      |   9 +-
 drivers/scsi/lpfc/lpfc_els.c       |  66 ++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 197 ++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_nportdisc.c |   9 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  10 +-
 drivers/scsi/lpfc/lpfc_nvme.h      |   4 +-
 7 files changed, 207 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 737483c3f01d..41e0d8ef015a 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -87,6 +87,8 @@ void lpfc_unregister_vfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_enqueue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_dequeue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_nlp_set_state(struct lpfc_vport *, struct lpfc_nodelist *, int);
+void lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp);
+void lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp);
 void lpfc_drop_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_set_disctmo(struct lpfc_vport *);
 int  lpfc_can_disctmo(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 131374a61d7e..871b665bd72e 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -78,10 +78,11 @@ struct lpfc_node_rrqs {
 };
 
 enum lpfc_fc4_xpt_flags {
-	NLP_WAIT_FOR_UNREG = 0x1,
-	SCSI_XPT_REGD      = 0x2,
-	NVME_XPT_REGD      = 0x4,
-	NLP_XPT_HAS_HH     = 0x8,
+	NLP_XPT_REGD		= 0x1,
+	SCSI_XPT_REGD		= 0x2,
+	NVME_XPT_REGD		= 0x4,
+	NVME_XPT_UNREG_WAIT	= 0x8,
+	NLP_XPT_HAS_HH		= 0x10
 };
 
 struct lpfc_nodelist {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 94dc80dc99b7..32f5f00f0a85 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1664,6 +1664,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	if (!new_ndlp || (new_ndlp == ndlp))
 		return ndlp;
 
+	/*
+	 * Unregister from backend if not done yet. Could have been skipped
+	 * due to ADISC
+	 */
+	lpfc_nlp_unreg_node(vport, new_ndlp);
+
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		active_rrqs_xri_bitmap = mempool_alloc(phba->active_rrq_pool,
 						       GFP_KERNEL);
@@ -4365,7 +4371,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			    (cmd == ELS_CMD_NVMEPRLI))
 				lpfc_nlp_set_state(vport, ndlp,
 					NLP_STE_PRLI_ISSUE);
-			else
+			else if (cmd != ELS_CMD_ADISC)
 				lpfc_nlp_set_state(vport, ndlp,
 					NLP_STE_NPR_NODE);
 			ndlp->nlp_last_elscmd = cmd;
@@ -5653,25 +5659,40 @@ lpfc_els_disc_adisc(struct lpfc_vport *vport)
 
 	/* go thru NPR nodes and issue any remaining ELS ADISCs */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
-		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
-		    (ndlp->nlp_flag & NLP_NPR_ADISC) != 0) {
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-			spin_unlock_irq(&ndlp->lock);
-			ndlp->nlp_prev_state = ndlp->nlp_state;
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
-			lpfc_issue_els_adisc(vport, ndlp, 0);
-			sentadisc++;
-			vport->num_disc_nodes++;
-			if (vport->num_disc_nodes >=
-			    vport->cfg_discovery_threads) {
-				spin_lock_irq(shost->host_lock);
-				vport->fc_flag |= FC_NLP_MORE;
-				spin_unlock_irq(shost->host_lock);
-				break;
-			}
+
+		if (ndlp->nlp_state != NLP_STE_NPR_NODE ||
+		    !(ndlp->nlp_flag & NLP_NPR_ADISC))
+			continue;
+
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+		spin_unlock_irq(&ndlp->lock);
+
+		if (!(ndlp->nlp_flag & NLP_NPR_2B_DISC)) {
+			/* This node was marked for ADISC but was not picked
+			 * for discovery. This is possible if the node was
+			 * missing in gidft response.
+			 *
+			 * At time of marking node for ADISC, we skipped unreg
+			 * from backend
+			 */
+			lpfc_nlp_unreg_node(vport, ndlp);
+			continue;
 		}
+
+		ndlp->nlp_prev_state = ndlp->nlp_state;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_ADISC_ISSUE);
+		lpfc_issue_els_adisc(vport, ndlp, 0);
+		sentadisc++;
+		vport->num_disc_nodes++;
+		if (vport->num_disc_nodes >=
+				vport->cfg_discovery_threads) {
+			spin_lock_irq(shost->host_lock);
+			vport->fc_flag |= FC_NLP_MORE;
+			spin_unlock_irq(shost->host_lock);
+			break;
+		}
+
 	}
 	if (sentadisc == 0) {
 		spin_lock_irq(shost->host_lock);
@@ -6882,13 +6903,6 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 			continue;
 		}
 
-		/* Check to see if we need to NVME rescan this target
-		 * remoteport.
-		 */
-		if (ndlp->nlp_fc4_type & NLP_FC4_NVME &&
-		    ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_DISCOVERY))
-			lpfc_nvme_rescan_port(vport, ndlp);
-
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 7cc5920979f8..32fb3be42b26 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4501,10 +4501,152 @@ lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
 	spin_unlock_irqrestore(shost->host_lock, iflags);
 }
 
+/* Register a node with backend if not already done */
+void
+lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+
+	unsigned long iflags;
+
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
+		/* Already registered with backend, trigger rescan */
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+		if (ndlp->fc4_xpt_flags & NVME_XPT_REGD &&
+		    ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_DISCOVERY)) {
+			lpfc_nvme_rescan_port(vport, ndlp);
+		}
+		return;
+	}
+
+	ndlp->fc4_xpt_flags |= NLP_XPT_REGD;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+	if (lpfc_valid_xpt_node(ndlp)) {
+		vport->phba->nport_event_cnt++;
+		/*
+		 * Tell the fc transport about the port, if we haven't
+		 * already. If we have, and it's a scsi entity, be
+		 */
+		lpfc_register_remote_port(vport, ndlp);
+	}
+
+	/* We are done if we do not have any NVME remote node */
+	if (!(ndlp->nlp_fc4_type & NLP_FC4_NVME))
+		return;
+
+	/* Notify the NVME transport of this new rport. */
+	if (vport->phba->sli_rev >= LPFC_SLI_REV4 &&
+			ndlp->nlp_fc4_type & NLP_FC4_NVME) {
+		if (vport->phba->nvmet_support == 0) {
+			/* Register this rport with the transport.
+			 * Only NVME Target Rports are registered with
+			 * the transport.
+			 */
+			if (ndlp->nlp_type & NLP_NVME_TARGET) {
+				vport->phba->nport_event_cnt++;
+				lpfc_nvme_register_port(vport, ndlp);
+			}
+		} else {
+			/* Just take an NDLP ref count since the
+			 * target does not register rports.
+			 */
+			lpfc_nlp_get(ndlp);
+		}
+	}
+}
+
+/* Unregister a node with backend if not already done */
+void
+lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	unsigned long iflags;
+
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		return;
+	}
+
+	ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+	if (ndlp->rport &&
+	    ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
+		vport->phba->nport_event_cnt++;
+		lpfc_unregister_remote_port(ndlp);
+	}
+
+	if (ndlp->fc4_xpt_flags & NVME_XPT_REGD) {
+		vport->phba->nport_event_cnt++;
+		if (vport->phba->nvmet_support == 0) {
+			/* Start devloss if target. */
+			if (ndlp->nlp_type & NLP_NVME_TARGET)
+				lpfc_nvme_unregister_port(vport, ndlp);
+		} else {
+			/* NVMET has no upcall. */
+			lpfc_nlp_put(ndlp);
+		}
+	}
+
+}
+
+/*
+ * Adisc state change handling
+ */
+static void
+lpfc_handle_adisc_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+		int new_state)
+{
+	switch (new_state) {
+	/*
+	 * Any state to ADISC_ISSUE
+	 * Do nothing, adisc cmpl handling will trigger state changes
+	 */
+	case NLP_STE_ADISC_ISSUE:
+		break;
+
+	/*
+	 * ADISC_ISSUE to mapped states
+	 * Trigger a registration with backend, it will be nop if
+	 * already registered
+	 */
+	case NLP_STE_UNMAPPED_NODE:
+		ndlp->nlp_type |= NLP_FC_NODE;
+		fallthrough;
+	case NLP_STE_MAPPED_NODE:
+		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
+		lpfc_nlp_reg_node(vport, ndlp);
+		break;
+
+	/*
+	 * ADISC_ISSUE to non-mapped states
+	 * We are moving from ADISC_ISSUE to a non-mapped state because
+	 * ADISC failed, we would have skipped unregistering with
+	 * backend, attempt it now
+	 */
+	case NLP_STE_NPR_NODE:
+		ndlp->nlp_flag &= ~NLP_RCV_PLOGI;
+		fallthrough;
+	default:
+		lpfc_nlp_unreg_node(vport, ndlp);
+		break;
+	}
+
+}
+
 static void
 lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       int old_state, int new_state)
 {
+	/* Trap ADISC changes here */
+	if (new_state == NLP_STE_ADISC_ISSUE ||
+	    old_state == NLP_STE_ADISC_ISSUE) {
+		lpfc_handle_adisc_state(vport, ndlp, new_state);
+		return;
+	}
+
 	if (new_state == NLP_STE_UNMAPPED_NODE) {
 		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		ndlp->nlp_type |= NLP_FC_NODE;
@@ -4514,60 +4656,17 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (new_state == NLP_STE_NPR_NODE)
 		ndlp->nlp_flag &= ~NLP_RCV_PLOGI;
 
-	/* FCP and NVME Transport interface */
+	/* Reg/Unreg for FCP and NVME Transport interface */
 	if ((old_state == NLP_STE_MAPPED_NODE ||
 	     old_state == NLP_STE_UNMAPPED_NODE)) {
-		if (ndlp->rport &&
-		    lpfc_valid_xpt_node(ndlp)) {
-			vport->phba->nport_event_cnt++;
-			lpfc_unregister_remote_port(ndlp);
-		}
-
-		if (ndlp->nlp_fc4_type & NLP_FC4_NVME) {
-			vport->phba->nport_event_cnt++;
-			if (vport->phba->nvmet_support == 0) {
-				/* Start devloss if target. */
-				if (ndlp->nlp_type & NLP_NVME_TARGET)
-					lpfc_nvme_unregister_port(vport, ndlp);
-			} else {
-				/* NVMET has no upcall. */
-				lpfc_nlp_put(ndlp);
-			}
-		}
+		/* For nodes marked for ADISC, Handle unreg in ADISC cmpl */
+		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
+			lpfc_nlp_unreg_node(vport, ndlp);
 	}
 
-	/* FCP and NVME Transport interfaces */
-
 	if (new_state ==  NLP_STE_MAPPED_NODE ||
-	    new_state == NLP_STE_UNMAPPED_NODE) {
-		if (lpfc_valid_xpt_node(ndlp)) {
-			vport->phba->nport_event_cnt++;
-			/*
-			 * Tell the fc transport about the port, if we haven't
-			 * already. If we have, and it's a scsi entity, be
-			 */
-			lpfc_register_remote_port(vport, ndlp);
-		}
-		/* Notify the NVME transport of this new rport. */
-		if (vport->phba->sli_rev >= LPFC_SLI_REV4 &&
-		    ndlp->nlp_fc4_type & NLP_FC4_NVME) {
-			if (vport->phba->nvmet_support == 0) {
-				/* Register this rport with the transport.
-				 * Only NVME Target Rports are registered with
-				 * the transport.
-				 */
-				if (ndlp->nlp_type & NLP_NVME_TARGET) {
-					vport->phba->nport_event_cnt++;
-					lpfc_nvme_register_port(vport, ndlp);
-				}
-			} else {
-				/* Just take an NDLP ref count since the
-				 * target does not register rports.
-				 */
-				lpfc_nlp_get(ndlp);
-			}
-		}
-	}
+	    new_state == NLP_STE_UNMAPPED_NODE)
+		lpfc_nlp_reg_node(vport, ndlp);
 
 	if ((new_state ==  NLP_STE_MAPPED_NODE) &&
 		(vport->stat_data_enabled)) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e12f83fb795c..46c1905f6f39 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -863,6 +863,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	}
 out:
+	/* Unregister from backend, could have been skipped due to ADISC */
+	lpfc_nlp_unreg_node(vport, ndlp);
+
 	ndlp->nlp_prev_state = ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 
@@ -1677,9 +1680,6 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 		spin_unlock_irq(&ndlp->lock);
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
-		memset(&ndlp->nlp_nodename, 0, sizeof(struct lpfc_name));
-		memset(&ndlp->nlp_portname, 0, sizeof(struct lpfc_name));
-
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		lpfc_unreg_rpi(vport, ndlp);
@@ -2597,13 +2597,14 @@ lpfc_device_recov_mapped_node(struct lpfc_vport *vport,
 			      void *arg,
 			      uint32_t evt)
 {
+	lpfc_disc_set_adisc(vport, ndlp);
+
 	ndlp->nlp_prev_state = NLP_STE_MAPPED_NODE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
 	spin_unlock_irq(&ndlp->lock);
-	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index bcc804cefd30..f36294e9b5dd 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -216,8 +216,8 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	/* The register rebind might have occurred before the delete
 	 * downcall.  Guard against this race.
 	 */
-	if (ndlp->fc4_xpt_flags & NLP_WAIT_FOR_UNREG)
-		ndlp->fc4_xpt_flags &= ~(NLP_WAIT_FOR_UNREG | NVME_XPT_REGD);
+	if (ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT)
+		ndlp->fc4_xpt_flags &= ~(NVME_XPT_UNREG_WAIT | NVME_XPT_REGD);
 
 	spin_unlock_irq(&ndlp->lock);
 
@@ -2324,7 +2324,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * race that leaves the WAIT flag set.
 		 */
 		spin_lock_irq(&ndlp->lock);
-		ndlp->fc4_xpt_flags &= ~NLP_WAIT_FOR_UNREG;
+		ndlp->fc4_xpt_flags &= ~NVME_XPT_UNREG_WAIT;
 		ndlp->fc4_xpt_flags |= NVME_XPT_REGD;
 		spin_unlock_irq(&ndlp->lock);
 		rport = remote_port->private;
@@ -2336,7 +2336,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 */
 			spin_lock_irq(&ndlp->lock);
 			ndlp->nrport = NULL;
-			ndlp->fc4_xpt_flags &= ~NLP_WAIT_FOR_UNREG;
+			ndlp->fc4_xpt_flags &= ~NVME_XPT_UNREG_WAIT;
 			spin_unlock_irq(&ndlp->lock);
 			rport->ndlp = NULL;
 			rport->remoteport = NULL;
@@ -2488,7 +2488,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * The transport will update it.
 		 */
 		spin_lock_irq(&vport->phba->hbalock);
-		ndlp->fc4_xpt_flags |= NLP_WAIT_FOR_UNREG;
+		ndlp->fc4_xpt_flags |= NVME_XPT_UNREG_WAIT;
 		spin_unlock_irq(&vport->phba->hbalock);
 
 		/* Don't let the host nvme transport keep sending keep-alives
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 69a5a844c69c..060a7c111bad 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -37,8 +37,8 @@
 #define LPFC_MAX_NVME_INFO_TMP_LEN	100
 #define LPFC_NVME_INFO_MORE_STR		"\nCould be more info...\n"
 
-#define lpfc_ndlp_get_nrport(ndlp)					\
-	((!ndlp->nrport || (ndlp->fc4_xpt_flags & NLP_WAIT_FOR_UNREG))	\
+#define lpfc_ndlp_get_nrport(ndlp)				\
+	((!ndlp->nrport || (ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))\
 	? NULL : ndlp->nrport)
 
 struct lpfc_nvme_qhandle {
-- 
2.26.2

