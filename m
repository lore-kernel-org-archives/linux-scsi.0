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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF220C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A220E61606
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhENT50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbhENT5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:21 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9BC06174A
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q2so472762pfh.13
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UMIh47i79I7+jQRWdHJE/1M9SNIudrb06jstml4kC+w=;
        b=hQY47orcekSuUx3nNCsi/EX46digrT5b41/8itKJAIeI1H8WHpsXBmXKP/1M1cBhjF
         lwbE/zXLuyEHe1kLnj9xuZU42bZCbfH9a8jnMmjTeC3Zs1BqUX6I9mkzTXWCe2YUSrS6
         cQhXFBxDjwxwKEAT8Q1sjXVKeFQFJLpOZsByhNdsewL2PqHqj7lG3guMYEUyDWQUg36P
         +aNA3LJmWPhQE6dgo+cAHquQBTau0bNz+Dve3sFhzebP4u0TvhKT0Z0roDDYvytM0Gdv
         1ZIlZ3DMCBVTNdFEyj8QZkP847lOJX2nXemEw41NQkPHhCC/fZ3jnFFDCzeuNW3vEqzk
         g2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UMIh47i79I7+jQRWdHJE/1M9SNIudrb06jstml4kC+w=;
        b=TaXz8DwyGZ7HAzG8B/xPGvjq1iBa8WKVeBxzXcfPWYxZ7g+3BGwEDzA2tI1cLPG2tQ
         iHq74OXPB6ZdmddCX4CcZHZ4cPt8EPgJ68RnmQNEFmAvwH2EydaPvsXW8PT6NPo6wING
         2KUzcVzpnolmajLErnPhuW63R4D87i3Pa8Y4BDsrViG4xRu7G/M6XCOFIj7gsiqfFahi
         uNaql3LeBKWYvYOZnsHBec4yrXMDpujGNh+DNqbN/609TC6agt2+BEoNQXVmuIfdej8O
         qcBbDf6dh1ZR0l1qeNkd028ZWMc6RugrWkqllF9uP4imF/QvtTzdD84l8YIAswWhioVT
         WJ4g==
X-Gm-Message-State: AOAM5327+Rsu5qOz+6t0E4iC4u/iczKk+xH+Q1zU5Aw3rvurHaSAgY7t
        4w1ybRg7avOD+Uy1/z5QwKDWPu2yQJY=
X-Google-Smtp-Source: ABdhPJxkDvP4TnONln0EBrq3138f3+1n2FpOMR9GZgRdHRy/xYz+LJ4aGNpV2iWt/9kxSMQBGWOL4w==
X-Received: by 2002:a65:590a:: with SMTP id f10mr48432942pgu.358.1621022168777;
        Fri, 14 May 2021 12:56:08 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/11] lpfc: Fix node handling for Fabric Controller and Domain Controller
Date:   Fri, 14 May 2021 12:55:54 -0700
Message-Id: <20210514195559.119853-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During link bounce testing, rpi counts were seen to differ from the
number of nodes For fabric and domain controllers, a temporary rpi
is assigned, but the code isn't registering it. If the nodes do go
away, such as on link down, the temporary rpi isn't being released.

Change the way these two fabric services are managed, make them
behave like any other remote port. Register the rpi and register with
the transport. Never leave the nodes in a NPR or UNUSED state where
their rpi is in limbo.  This allows them to follow normal dev_loss_tmo
handling, rpi refcounting, and normal removal rules. It also allows
fabric I/Os to use the rpi for traffic requests.

Note: There is some logic that still has a couple of exceptions
when the Domain controller (0xfffcXX). There are cases where the
fabric won't have a valid login but will send RDP. Other times, it
will it send a LOGO then an RDP. It makes for adhoc behavior to manage
the node. Exceptions are documented in the code.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h      |   1 +
 drivers/scsi/lpfc/lpfc_debugfs.c   |   4 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       | 137 ++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  54 +++++++++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  11 +++
 drivers/scsi/lpfc/lpfc_sli.c       |   1 -
 7 files changed, 189 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 383abf46fd29..8f56e8f66311 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -80,6 +80,7 @@ void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_unregister_vfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 7bddd74658b9..6ff85ae57e79 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -863,10 +863,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		len += scnprintf(buf+len, size-len, "%s DID:x%06x ",
 				statep, ndlp->nlp_DID);
 		len += scnprintf(buf+len, size-len,
-				"WWPN x%llx ",
+				"WWPN x%016llx ",
 				wwn_to_u64(ndlp->nlp_portname.u.wwn));
 		len += scnprintf(buf+len, size-len,
-				"WWNN x%llx ",
+				"WWNN x%016llx ",
 				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
 		len += scnprintf(buf+len, size-len, "RPI:x%04x ",
 				 ndlp->nlp_rpi);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 08999aad6a10..27d1a971a7f8 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -86,6 +86,7 @@ enum lpfc_fc4_xpt_flags {
 
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
+	struct serv_parm fc_sparam;		/* buffer for service params */
 	struct lpfc_name nlp_portname;
 	struct lpfc_name nlp_nodename;
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 933927f738c7..690827888edf 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3085,6 +3085,95 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_nlp_put(free_ndlp);
 }
 
+/**
+ * lpfc_reg_fab_ctrl_node - RPI register the fabric controller node.
+ * @vport: pointer to lpfc_vport data structure.
+ * @fc_ndlp: pointer to the fabric controller (0xfffffd) node.
+ *
+ * This routine registers the rpi assigned to the fabric controller
+ * NPort_ID (0xfffffd) with the port and moves the node to UNMAPPED
+ * state triggering a registration with the SCSI transport.
+ *
+ * This routine is single out because the fabric controller node
+ * does not receive a PLOGI.  This routine is consumed by the
+ * SCR and RDF ELS commands.  Callers are expected to qualify
+ * with SLI4 first.
+ **/
+static int
+lpfc_reg_fab_ctrl_node(struct lpfc_vport *vport, struct lpfc_nodelist *fc_ndlp)
+{
+	int rc = 0;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_nodelist *ns_ndlp;
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_dmabuf *mp;
+
+	if (fc_ndlp->nlp_flag & NLP_RPI_REGISTERED)
+		return rc;
+
+	ns_ndlp = lpfc_findnode_did(vport, NameServer_DID);
+	if (!ns_ndlp)
+		return -ENODEV;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+			 "0935 %s: Reg FC RPI x%x on FC DID x%x NSSte: x%x\n",
+			 __func__, fc_ndlp->nlp_rpi, fc_ndlp->nlp_DID,
+			 ns_ndlp->nlp_state);
+	if (ns_ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
+		return -ENODEV;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+				 "0936 %s: no memory for reg_login "
+				 "Data: x%x x%x x%x x%x\n", __func__,
+				 fc_ndlp->nlp_DID, fc_ndlp->nlp_state,
+				 fc_ndlp->nlp_flag, fc_ndlp->nlp_rpi);
+		return -ENOMEM;
+	}
+	rc = lpfc_reg_rpi(phba, vport->vpi, fc_ndlp->nlp_DID,
+			  (u8 *)&vport->fc_sparam, mbox, fc_ndlp->nlp_rpi);
+	if (rc) {
+		rc = -EACCES;
+		goto out;
+	}
+
+	fc_ndlp->nlp_flag |= NLP_REG_LOGIN_SEND;
+	mbox->mbox_cmpl = lpfc_mbx_cmpl_fc_reg_login;
+	mbox->ctx_ndlp = lpfc_nlp_get(fc_ndlp);
+	if (!mbox->ctx_ndlp) {
+		rc = -ENOMEM;
+		goto out_mem;
+	}
+
+	mbox->vport = vport;
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		rc = -ENODEV;
+		lpfc_nlp_put(fc_ndlp);
+		goto out_mem;
+	}
+	/* Success path. Exit. */
+	lpfc_nlp_set_state(vport, fc_ndlp,
+			   NLP_STE_REG_LOGIN_ISSUE);
+	return 0;
+
+ out_mem:
+	fc_ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
+	mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+	kfree(mp);
+
+ out:
+	mempool_free(mbox, phba->mbox_mem_pool);
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+			 "0938 %s: failed to format reg_login "
+			 "Data: x%x x%x x%x x%x\n", __func__,
+			 fc_ndlp->nlp_DID, fc_ndlp->nlp_state,
+			 fc_ndlp->nlp_flag, fc_ndlp->nlp_rpi);
+	return rc;
+}
+
 /**
  * lpfc_cmpl_els_disc_cmd - Completion callback function for Discovery ELS cmd
  * @phba: pointer to lpfc hba data structure.
@@ -3231,10 +3320,18 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_SCR);
-
 	if (!elsiocb)
 		return 1;
 
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		rc = lpfc_reg_fab_ctrl_node(vport, ndlp);
+		if (rc) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+					 "0937 %s: Failed to reg fc node, rc %d\n",
+					 __func__, rc);
+			return 1;
+		}
+	}
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_SCR;
@@ -3522,6 +3619,17 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	if (!elsiocb)
 		return -ENOMEM;
 
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+				 "0939 %s: FC_NODE x%x RPI x%x flag x%x "
+				 "ste x%x type x%x Not registered\n",
+				 __func__, ndlp->nlp_DID, ndlp->nlp_rpi,
+				 ndlp->nlp_flag, ndlp->nlp_state,
+				 ndlp->nlp_type);
+		return -ENODEV;
+	}
+
 	/* Configure the payload for the supported FPIN events. */
 	prdf = (struct lpfc_els_rdf_req *)
 		(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
@@ -4396,7 +4504,6 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_vport *vport = cmdiocb->vport;
 	IOCB_t *irsp;
-	u32 xpt_flags = 0, did_mask = 0;
 
 	irsp = &rspiocb->iocb;
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
@@ -4409,6 +4516,15 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
 			 ndlp->nlp_state, ndlp->nlp_rpi);
 
+	/* This clause allows the LOGO ACC to complete and free resources
+	 * for the Fabric Domain Controller.  It does deliberately skip
+	 * the unreg_rpi and release rpi because some fabrics send RDP
+	 * requests after logging out from the initiator.
+	 */
+	if (ndlp->nlp_type & NLP_FABRIC &&
+	    ((ndlp->nlp_DID & WELL_KNOWN_DID_MASK) != WELL_KNOWN_DID_MASK))
+		goto out;
+
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
 		/* NPort Recovery mode or node is just allocated */
 		if (!lpfc_nlp_not_used(ndlp)) {
@@ -4416,16 +4532,11 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 * If this a fabric node that cleared its transport
 			 * registration, release the rpi.
 			 */
-			xpt_flags = SCSI_XPT_REGD | NVME_XPT_REGD;
-			did_mask = ndlp->nlp_DID & Fabric_DID_MASK;
-			if (did_mask == Fabric_DID_MASK &&
-			    !(ndlp->fc4_xpt_flags & xpt_flags)) {
-				spin_lock_irq(&ndlp->lock);
-				ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-				if (phba->sli_rev == LPFC_SLI_REV4)
-					ndlp->nlp_flag |= NLP_RELEASE_RPI;
-				spin_unlock_irq(&ndlp->lock);
-			}
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				ndlp->nlp_flag |= NLP_RELEASE_RPI;
+			spin_unlock_irq(&ndlp->lock);
 			lpfc_unreg_rpi(vport, ndlp);
 		} else {
 			/* Indicate the node has already released, should
@@ -4434,7 +4545,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			cmdiocb->context1 = NULL;
 		}
 	}
-
+ out:
 	/*
 	 * The driver received a LOGO from the rport and has ACK'd it.
 	 * At this point, the driver is done so release the IOCB
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3ea07034ab97..04b6e18c5342 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -77,9 +77,7 @@ static int
 lpfc_valid_xpt_node(struct lpfc_nodelist *ndlp)
 {
 	if (ndlp->nlp_fc4_type ||
-	    ndlp->nlp_DID == Fabric_DID ||
-	    ndlp->nlp_DID == NameServer_DID ||
-	    ndlp->nlp_DID == FDMI_DID)
+	    ndlp->nlp_type & NLP_FABRIC)
 		return 1;
 	return 0;
 }
@@ -826,7 +824,8 @@ lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove)
 		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
 		    ((vport->port_type == LPFC_NPIV_PORT) &&
 		     ((ndlp->nlp_DID == NameServer_DID) ||
-		      (ndlp->nlp_DID == FDMI_DID))))
+		      (ndlp->nlp_DID == FDMI_DID) ||
+		      (ndlp->nlp_DID == Fabric_Cntl_DID))))
 			lpfc_unreg_rpi(vport, ndlp);
 
 		/* Leave Fabric nodes alone on link down */
@@ -4160,6 +4159,53 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	return;
 }
 
+/*
+ * This routine handles processing a Fabric Controller REG_LOGIN mailbox
+ * command upon completion. It is setup in the LPFC_MBOXQ
+ * as the completion routine when the command is handed off to the SLI layer.
+ */
+void
+lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	struct lpfc_vport *vport = pmb->vport;
+	MAILBOX_t *mb = &pmb->u.mb;
+	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
+	struct lpfc_nodelist *ndlp;
+
+	ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	pmb->ctx_ndlp = NULL;
+	pmb->ctx_buf = NULL;
+
+	if (mb->mbxStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				 "0933 %s: Register FC login error: 0x%x\n",
+				 __func__, mb->mbxStatus);
+		goto out;
+	}
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		ndlp->nlp_rpi = mb->un.varWords[0];
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+			 "0934 %s: Complete FC x%x RegLogin rpi x%x ste x%x\n",
+			 __func__, ndlp->nlp_DID, ndlp->nlp_rpi,
+			 ndlp->nlp_state);
+
+	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+	ndlp->nlp_type |= NLP_FABRIC;
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+
+ out:
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+	kfree(mp);
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* Drop the reference count from the mbox at the end after
+	 * all the current reference to the ndlp have been done.
+	 */
+	lpfc_nlp_put(ndlp);
+}
+
 static void
 lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 50cf23447104..e12f83fb795c 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -785,6 +785,15 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
+	/* This clause allows the initiator to ACC the LOGO back to the
+	 * Fabric Domain Controller.  It does deliberately skip all other
+	 * steps because some fabrics send RDP requests after logging out
+	 * from the initiator.
+	 */
+	if (ndlp->nlp_type & NLP_FABRIC &&
+	    ((ndlp->nlp_DID & WELL_KNOWN_DID_MASK) != WELL_KNOWN_DID_MASK))
+		return 0;
+
 	/* Notify transport of connectivity loss to trigger cleanup. */
 	if (phba->nvmet_support &&
 	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE)
@@ -1423,6 +1432,8 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_ns_reg_login;
+			/* Fabric Controller Node needs these parameters. */
+			memcpy(&ndlp->fc_sparam, sp, sizeof(struct serv_parm));
 			break;
 		case FDMI_DID:
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_fdmi_reg_login;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f68fe6f2d3db..fa4722c7a551 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2755,7 +2755,6 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				} else {
 					__lpfc_sli_rpi_release(vport, ndlp);
 				}
-
 				lpfc_nlp_put(ndlp);
 			}
 		}
-- 
2.26.2

