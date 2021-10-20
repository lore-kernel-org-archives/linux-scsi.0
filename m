Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05695C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2BE6611ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhJTVQy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhJTVQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F93C06174E
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g5so17045894plg.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D8OxWAgnLvDzywcOpulKpGq4fQxTCtwCSRHvF3pV1Ig=;
        b=h+JKpwSEb/7v2cr8S68e1tmVDCQklSG2FjQnIjKPISug9KzdCwtxKH1tt2QbKfcRNt
         swongjrCOsA97q12EBQoX1EdCL7WnoPjGGYCVFdewk03erJeEAV5HnjW1TYMqls7SoCP
         uqK81m+mZP1EJHLxRdfrQ/cxdUm0QSLYilIhTrOSmSuGklczhCX6smIWjQbVhFsnIhQe
         Oxxa7rQrhOVJ6F8aAG2LgomCo/u95Q+9MDGA5NZebrdINKjluuUsCYJbJ6S2XkRcyUkH
         +1MODxC6nlr6xFiOHPJeJ2b9Jqg6l0ZH5lPKgS5JhG2UTj1pou2mV8LUMNqWIADDIPoW
         yh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D8OxWAgnLvDzywcOpulKpGq4fQxTCtwCSRHvF3pV1Ig=;
        b=W25Aa2Wn8Zf3kf1XA8z0TuR0uAK5QHbV3mw8C6UKMQ7QRRSklAf2Sy+KCKuAJYVPB1
         7Nmv1WbwLPMyDLchLn//a+bJSa4vLrQeg0QVVw8eicnC0rf+NSrvGUQzX7XNdb1kbEVb
         U+1DhfCngh5rHVWIaG7xWSQXJPBkXw8Q6651QPNEL21/7G6+3szkvKPooffg5TkKoUn8
         l0BgpoSkr3yde2PzSDyQAxDgeUdxd1e3Ja/oa7ZGJMLwQbY5IKHa1SxTTbvbNv4VAkI5
         B68lqOIvj3XIrdyRGtprWi9G2i0lsyL2Soe7xF3OJ2gVxPRPDisGXk73yxvyUWRGzm+/
         utAQ==
X-Gm-Message-State: AOAM532ejyg+h9GEkUlB8E3IgvyAYbcf56lk+7Mc7ZVu6nPtgQSPwswX
        GgP43toVAv+z1zF9UbcbCJ9/UpVltTs=
X-Google-Smtp-Source: ABdhPJxgOyIagBCtcCF1kmP8H0mzovqUAOL/Ai2WiY82RD0bVN2+PIpMkljpkor71KRAvnIZQV+aFQ==
X-Received: by 2002:a17:90a:cc0d:: with SMTP id b13mr1582920pju.190.1634764468949;
        Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 7/8] lpfc: Allow fabric node recovery if recovery is in progress before devloss
Date:   Wed, 20 Oct 2021 14:14:16 -0700
Message-Id: <20211020211417.88754-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A link bounce to a slow fabric may observe FDISC response delays lasting
longer than devloss tmo.  Current logic decrements the final fabric node
kref during a devloss tmo event.  This results in a NULL ptr dereference
crash if the FDISC completes for that fabric node after devloss tmo.

Fix by adding the NLP_IN_RECOV_POST_DEV_LOSS flag, which is set when
devloss tmo triggers and we've noticed that fabric node recovery has
already started or finished in between the time lpfc_dev_loss_tmo_callbk
queues lpfc_dev_loss_tmo_handler.  If fabric node recovery succeeds, then
the driver reverses the devloss tmo marked kref put with a kref get.  If
fabric node recovery fails, then the final kref put relies
on the ELS timing out or the REG_LOGIN cmpl routine.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |   2 +
 drivers/scsi/lpfc/lpfc_disc.h    |  12 +++-
 drivers/scsi/lpfc/lpfc_els.c     |   7 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 111 ++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_init.c    |  12 ++--
 drivers/scsi/lpfc/lpfc_scsi.c    |  10 +--
 6 files changed, 139 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f0bcfeecd161..1acff46b4c60 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -119,6 +119,8 @@ int lpfc_check_sli_ndlp(struct lpfc_hba *, struct lpfc_sli_ring *,
 struct lpfc_nodelist *lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did);
 struct lpfc_nodelist *lpfc_nlp_get(struct lpfc_nodelist *);
 int  lpfc_nlp_put(struct lpfc_nodelist *);
+void lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
+				 struct lpfc_nodelist *ndlp);
 void lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			  struct lpfc_iocbq *rspiocb);
 int  lpfc_nlp_not_used(struct lpfc_nodelist *ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 871b665bd72e..37a4b79010bf 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -85,6 +85,13 @@ enum lpfc_fc4_xpt_flags {
 	NLP_XPT_HAS_HH		= 0x10
 };
 
+enum lpfc_nlp_save_flags {
+	/* devloss occurred during recovery */
+	NLP_IN_RECOV_POST_DEV_LOSS	= 0x1,
+	/* wait for outstanding LOGO to cmpl */
+	NLP_WAIT_FOR_LOGO		= 0x2,
+};
+
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
 	struct serv_parm fc_sparam;		/* buffer for service params */
@@ -144,8 +151,9 @@ struct lpfc_nodelist {
 	unsigned long *active_rrqs_xri_bitmap;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 	uint32_t fc4_prli_sent;
-	u32 upcall_flags;
-#define	NLP_WAIT_FOR_LOGO 0x2
+
+	/* flags to keep ndlp alive until special conditions are met */
+	enum lpfc_nlp_save_flags save_flags;
 
 	enum lpfc_fc4_xpt_flags fc4_xpt_flags;
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 746fe9772453..b940e0268f96 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2905,9 +2905,9 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	irsp = &(rspiocb->iocb);
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
-	if (ndlp->upcall_flags & NLP_WAIT_FOR_LOGO) {
+	if (ndlp->save_flags & NLP_WAIT_FOR_LOGO) {
 		wake_up_waiter = 1;
-		ndlp->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+		ndlp->save_flags &= ~NLP_WAIT_FOR_LOGO;
 	}
 	spin_unlock_irq(&ndlp->lock);
 
@@ -10735,6 +10735,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->ulpStatus, irsp->un.ulpWord[4]);
 		goto fdisc_failed;
 	}
+
+	lpfc_check_nlp_post_devloss(vport, ndlp);
+
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_CVL_RCVD;
 	vport->fc_flag &= ~FC_VPORT_LOGO_RCVD;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c068fbb550a..9fe6e5b386ce 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -209,7 +209,12 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
 	ndlp->nlp_flag |= NLP_IN_DEV_LOSS;
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+
+	/* If there is a PLOGI in progress, and we are in a
+	 * NLP_NPR_2B_DISC state, don't turn off the flag.
+	 */
+	if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE)
+		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 
 	/*
 	 * The backend does not expect any more calls associated with this
@@ -340,6 +345,37 @@ static void lpfc_check_inactive_vmid(struct lpfc_hba *phba)
 	lpfc_destroy_vport_work_array(phba, vports);
 }
 
+/**
+ * lpfc_check_nlp_post_devloss - Check to restore ndlp refcnt after devloss
+ * @vport: Pointer to vport object.
+ * @ndlp: Pointer to remote node object.
+ *
+ * If NLP_IN_RECOV_POST_DEV_LOSS flag was set due to outstanding recovery of
+ * node during dev_loss_tmo processing, then this function restores the nlp_put
+ * kref decrement from lpfc_dev_loss_tmo_handler.
+ **/
+void
+lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
+			    struct lpfc_nodelist *ndlp)
+{
+	unsigned long iflags;
+
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	if (ndlp->save_flags & NLP_IN_RECOV_POST_DEV_LOSS) {
+		ndlp->save_flags &= ~NLP_IN_RECOV_POST_DEV_LOSS;
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		lpfc_nlp_get(ndlp);
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
+				 "8438 Devloss timeout reversed on DID x%x "
+				 "refcnt %d ndlp %p flag x%x "
+				 "port_state = x%x\n",
+				 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp,
+				 ndlp->nlp_flag, vport->port_state);
+		spin_lock_irqsave(&ndlp->lock, iflags);
+	}
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
+}
+
 /**
  * lpfc_dev_loss_tmo_handler - Remote node devloss timeout handler
  * @ndlp: Pointer to remote node object.
@@ -358,6 +394,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	uint8_t *name;
 	int warn_on = 0;
 	int fcf_inuse = 0;
+	bool recovering = false;
+	struct fc_vport *fc_vport = NULL;
 	unsigned long iflags;
 
 	vport = ndlp->vport;
@@ -394,6 +432,64 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 
 	/* Fabric nodes are done. */
 	if (ndlp->nlp_type & NLP_FABRIC) {
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		/* In massive vport configuration settings, it's possible
+		 * dev_loss_tmo fired during node recovery.  So, check if
+		 * fabric nodes are in discovery states outstanding.
+		 */
+		switch (ndlp->nlp_DID) {
+		case Fabric_DID:
+			fc_vport = vport->fc_vport;
+			if (fc_vport &&
+			    fc_vport->vport_state == FC_VPORT_INITIALIZING)
+				recovering = true;
+			break;
+		case Fabric_Cntl_DID:
+			if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
+				recovering = true;
+			break;
+		case FDMI_DID:
+			fallthrough;
+		case NameServer_DID:
+			if (ndlp->nlp_state >= NLP_STE_PLOGI_ISSUE &&
+			    ndlp->nlp_state <= NLP_STE_REG_LOGIN_ISSUE)
+				recovering = true;
+			break;
+		}
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+		/* Mark an NLP_IN_RECOV_POST_DEV_LOSS flag to know if reversing
+		 * the following lpfc_nlp_put is necessary after fabric node is
+		 * recovered.
+		 */
+		if (recovering) {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_DISCOVERY | LOG_NODE,
+					 "8436 Devloss timeout marked on "
+					 "DID x%x refcnt %d ndlp %p "
+					 "flag x%x port_state = x%x\n",
+					 ndlp->nlp_DID, kref_read(&ndlp->kref),
+					 ndlp, ndlp->nlp_flag,
+					 vport->port_state);
+			spin_lock_irqsave(&ndlp->lock, iflags);
+			ndlp->save_flags |= NLP_IN_RECOV_POST_DEV_LOSS;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+		} else if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
+			/* Fabric node fully recovered before this dev_loss_tmo
+			 * queue work is processed.  Thus, ignore the
+			 * dev_loss_tmo event.
+			 */
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_DISCOVERY | LOG_NODE,
+					 "8437 Devloss timeout ignored on "
+					 "DID x%x refcnt %d ndlp %p "
+					 "flag x%x port_state = x%x\n",
+					 ndlp->nlp_DID, kref_read(&ndlp->kref),
+					 ndlp, ndlp->nlp_flag,
+					 vport->port_state);
+			return fcf_inuse;
+		}
+
 		lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
@@ -423,6 +519,14 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
+	/* If we are devloss, but we are in the process of rediscovering the
+	 * ndlp, don't issue a NLP_EVT_DEVICE_RM event.
+	 */
+	if (ndlp->nlp_state >= NLP_STE_PLOGI_ISSUE &&
+	    ndlp->nlp_state <= NLP_STE_PRLI_ISSUE) {
+		return fcf_inuse;
+	}
+
 	if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
@@ -4363,6 +4467,8 @@ lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		goto out;
 	}
 
+	lpfc_check_nlp_post_devloss(vport, ndlp);
+
 	if (phba->sli_rev < LPFC_SLI_REV4)
 		ndlp->nlp_rpi = mb->un.varWords[0];
 
@@ -4540,9 +4646,10 @@ lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
 void
 lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-
 	unsigned long iflags;
 
+	lpfc_check_nlp_post_devloss(vport, ndlp);
+
 	spin_lock_irqsave(&ndlp->lock, iflags);
 	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
 		/* Already registered with backend, trigger rescan */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 744da35b5074..df3edbe2b2e5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3753,12 +3753,16 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					lpfc_disc_state_machine(vports[i], ndlp,
 						NULL, NLP_EVT_DEVICE_RECOVERY);
 
-					/* Don't remove the node unless the
+					/* Don't remove the node unless the node
 					 * has been unregistered with the
-					 * transport.  If so, let dev_loss
-					 * take care of the node.
+					 * transport, and we're not in recovery
+					 * before dev_loss_tmo triggered.
+					 * Otherwise, let dev_loss take care of
+					 * the node.
 					 */
-					if (!(ndlp->fc4_xpt_flags &
+					if (!(ndlp->save_flags &
+					      NLP_IN_RECOV_POST_DEV_LOSS) &&
+					    !(ndlp->fc4_xpt_flags &
 					      (NVME_XPT_REGD | SCSI_XPT_REGD)))
 						lpfc_disc_state_machine
 							(vports[i], ndlp,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0dce4b51ca1e..fe4e5f6ecc70 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6475,28 +6475,28 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 
 		/* Issue LOGO, if no LOGO is outstanding */
 		spin_lock_irqsave(&pnode->lock, flags);
-		if (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO) &&
+		if (!(pnode->save_flags & NLP_WAIT_FOR_LOGO) &&
 		    !pnode->logo_waitq) {
 			pnode->logo_waitq = &waitq;
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 			pnode->nlp_flag |= NLP_ISSUE_LOGO;
-			pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
+			pnode->save_flags |= NLP_WAIT_FOR_LOGO;
 			spin_unlock_irqrestore(&pnode->lock, flags);
 			lpfc_unreg_rpi(vport, pnode);
 			wait_event_timeout(waitq,
-					   (!(pnode->upcall_flags &
+					   (!(pnode->save_flags &
 					      NLP_WAIT_FOR_LOGO)),
 					   msecs_to_jiffies(dev_loss_tmo *
 							    1000));
 
-			if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
+			if (pnode->save_flags & NLP_WAIT_FOR_LOGO) {
 				lpfc_printf_vlog(vport, KERN_ERR, logit,
 						 "0725 SCSI layer TGTRST "
 						 "failed & LOGO TMO (%d, %llu) "
 						 "return x%x\n",
 						 tgt_id, lun_id, status);
 				spin_lock_irqsave(&pnode->lock, flags);
-				pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+				pnode->save_flags &= ~NLP_WAIT_FOR_LOGO;
 			} else {
 				spin_lock_irqsave(&pnode->lock, flags);
 			}
-- 
2.26.2

